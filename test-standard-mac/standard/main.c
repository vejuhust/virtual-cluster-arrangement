#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


#define MAX_N   100
#define MAX_M   100
#define MAX_C   1<<26


typedef struct {
    uint64_t code;
    int8_t  count;
} code_type;                            //存储状态选择信息

int64_t num_n_physical;                 //物理节点总数
int64_t num_m_virtual;                  //虚拟集群、单节点虚拟机数量
int64_t mat_capablity [MAX_N][MAX_M];   //c[i][j] i号节点的，j号虚拟机的处理能力
int64_t vec_demand [MAX_M];             //对各个虚拟集群的处理能力需求
code_type arr_code [MAX_C];             //所有的状态选择情况
int64_t cnt_solution;                   //符合要求的状态数量
int64_t index_begin [MAX_N];            //不同物理节点开启数量的在所有状态列表中的开始位置
int64_t vec_satisfy [MAX_M];            //当前每个虚拟集群的处理能力满足情况


void input_data (char * filename);
void generate_code (int64_t max_bit);
uint64_t count_bits (int64_t to_count);
int compare_code (const void * code_a, const void * code_b);
void find_solution_range (void);
int64_t assess_all_solutions (void);
int8_t is_that_satisfied (void);
int8_t evaluate_new_solution (uint64_t code);
int8_t evaluate_different_solution (uint64_t code_old, uint64_t code_new);
void print_solution (uint64_t code);


/* 主函数 */
int main (int argc, const char * argv[]) {
    input_data("input.txt");
    
    generate_code(num_n_physical);
    
    mergesort(arr_code, cnt_solution, sizeof(code_type), compare_code);
    //qsort(arr_code, cnt_solution, sizeof(code_type), compare_code);
    
    find_solution_range();
    
    printf("#%lld solutions\n", assess_all_solutions());
    
    return (0);
}


/* 数据读入 */
void input_data (char * filename) {
    FILE *  inputFile = fopen(filename, "r");
    fscanf(inputFile, "%lld%lld", &num_n_physical, &num_m_virtual);
    
    // Retrieve c[i][j] of VM[i][j]
    for (int64_t i = 0; i < num_n_physical; i++) {
        for (int64_t j = 0; j < num_m_virtual; j++) {
            fscanf(inputFile, "%lld", &(mat_capablity[i][j]));
        }
    }
    
    // Retrieve C[i]
    for (int64_t i = 0; i < num_m_virtual; i++) {
        fscanf(inputFile, "%lld", &(vec_demand[i]));
    }
    fclose(inputFile);
}


/* 生成各个状态选择（基于Gray Code） */
void generate_code (int64_t max_bit) {
    cnt_solution = ((int64_t)1)<<max_bit;
    for (int64_t index = 0; index < cnt_solution; index++) {
        arr_code[index].code = index ^ (index >> 1);
        arr_code[index].count = count_bits(arr_code[index].code);
    }
}


/* 统计64位二进制整数中1的数量 */
inline uint64_t count_bits (int64_t to_count) {
    uint64_t  bits = to_count;
    bits = (bits & 0x5555555555555555) + ((bits >> 1) & 0x5555555555555555);
    bits = (bits & 0x3333333333333333) + ((bits >> 2) & 0x3333333333333333);
    bits = (bits & 0x0F0F0F0F0F0F0F0F) + ((bits >> 4) & 0x0F0F0F0F0F0F0F0F);
    bits = (bits & 0x00FF00FF00FF00FF) + ((bits >> 8) & 0x00FF00FF00FF00FF);
    bits = (bits & 0x0000FFFF0000FFFF) + ((bits >>16) & 0x0000FFFF0000FFFF);
    bits = (bits & 0x00000000FFFFFFFF) + ((bits >>32) & 0x00000000FFFFFFFF);
    return (bits);
}


/* 比较基于两个状态选择中1的数量 */
int compare_code (const void * code_a, const void * code_b) {
    if (((*(code_type *)code_a).count) < ((*(code_type *)code_b).count)) {
        return (-1);
    }
    else {
        return (1);
    }
}


/* 在有序的所有选择状态中按1的数量进行划分 */
void find_solution_range (void) {
    int64_t counter = -1;
    for (int64_t index = 0; index < cnt_solution; index++) {
        if (arr_code[index].count != counter) {
            counter = arr_code[index].count;
            index_begin[counter] = index;
        }
    }
    index_begin[counter + 1] = cnt_solution;
}


/* 评估所有选择状态 */
int64_t assess_all_solutions (void) {
    for (int64_t index_bit = 0; index_bit <= num_n_physical; index_bit++) {
        uint64_t last_sln = 0;
        uint64_t this_sln = 0;
        int64_t no_more_bits = 0;
        
        for (int64_t index_sln = index_begin[index_bit], index_end = index_begin[index_bit + 1]; index_sln < index_end; index_sln++) {
            int8_t satisfied = 0;
            this_sln = arr_code[index_sln].code;
            
            if (0 == last_sln) {
                satisfied = evaluate_new_solution(this_sln);
            }
            else {
                if (2 == count_bits(last_sln^this_sln)) {
                    satisfied = evaluate_different_solution(last_sln, this_sln);
                }
                else {
                    satisfied = evaluate_new_solution(this_sln);
                }
            }
            last_sln = this_sln;
            
            if (1 == satisfied) {
                no_more_bits++;
                print_solution(this_sln);
            }
            
        } //for solutions
        
        if (no_more_bits) {
            return (no_more_bits);
        }
    } //for index_bit
    
    return (0);
} //function assess



/* 判断目前处理能力需求是否满足 */
inline int8_t is_that_satisfied (void) {
    for (int64_t index_m = 0; index_m < num_m_virtual; index_m++) {
        if (vec_satisfy[index_m] < vec_demand[index_m]) {
            return (0);
        }
    }
    return (1);
}


/* 从零开始评估选择状态 */
int8_t evaluate_new_solution (uint64_t code) {
    memset(vec_satisfy, 0, sizeof(int64_t) * num_m_virtual);
    
    for (int64_t index_n = 0; index_n < num_n_physical; index_n++) {
        if ((code>>index_n) & 1) {
            for (int64_t index_m = 0; index_m < num_m_virtual; index_m++) {
                vec_satisfy[index_m] += mat_capablity[index_n][index_m];
            }
        }
    }
    
    return (is_that_satisfied());
}


/* 基于Gray code变换，根据已有选择状态快速评估新的选择状态 */
int8_t evaluate_different_solution (uint64_t code_old, uint64_t code_new) {
    uint64_t code_diff = code_old ^ code_new;
    uint64_t code_close = code_old & code_diff;
    uint64_t code_open = code_new & code_diff;
    code_close = count_bits((~code_close) & (code_close - 1));
    code_open = count_bits((~code_open) & (code_open - 1));
    
    for (int64_t index_m = 0; index_m < num_m_virtual; index_m++) {
        vec_satisfy[index_m] -= mat_capablity[code_close][index_m];
        vec_satisfy[index_m] += mat_capablity[code_open][index_m];
    }
    
    return (is_that_satisfied());
}


/* 输出选择结果 */
void print_solution (uint64_t code) {
    for (int64_t index_n = 0; index_n < num_n_physical; index_n++) {
        if ((code>>index_n) & 1) {
            printf("%lld ", index_n);
        }
    }
    printf("\n");
}
