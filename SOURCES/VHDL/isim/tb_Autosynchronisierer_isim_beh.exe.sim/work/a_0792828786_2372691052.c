/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/ADAT DeEncoder/ADAT_De-Encoder/tb_Autosynchronisierer.vhd";



static void work_a_0792828786_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 3752U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(109, ng0);
    t2 = (t0 + 4568);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(110, ng0);
    t2 = (t0 + 2448U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 3652);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(111, ng0);
    t2 = (t0 + 4568);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(112, ng0);
    t2 = (t0 + 2448U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 3652);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_0792828786_2372691052_p_1(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    char *t6;
    int t7;
    int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    int t13;
    char *t14;
    int t15;
    int t16;
    unsigned char t17;
    unsigned char t18;
    char *t19;
    char *t20;
    unsigned char t21;
    unsigned char t22;
    char *t23;

LAB0:    t1 = (t0 + 3896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(123, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 3796);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(124, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 3796);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 2584U);
    t4 = *((char **)t2);
    t2 = (t0 + 2652U);
    t6 = *((char **)t2);
    t7 = *((int *)t6);
    t8 = (t7 - 0);
    t9 = (t8 * 1);
    t10 = (8U * t9);
    t11 = (0 + t10);
    t2 = (t4 + t11);
    t3 = *((int64 *)t2);
    t12 = (t0 + 3796);
    xsi_process_wait(t12, t3);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(130, ng0);
    t7 = (100 * 256);
    t2 = (t0 + 9941);
    *((int *)t2) = 1;
    t4 = (t0 + 9945);
    *((int *)t4) = t7;
    t8 = 1;
    t13 = t7;

LAB16:    if (t8 <= t13)
        goto LAB17;

LAB19:    xsi_set_current_line(148, ng0);

LAB33:    *((char **)t1) = &&LAB34;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB17:    xsi_set_current_line(131, ng0);
    t6 = (t0 + 2516U);
    t12 = *((char **)t6);
    t6 = (t0 + 2720U);
    t14 = *((char **)t6);
    t15 = *((int *)t14);
    t16 = (t15 - 0);
    t9 = (t16 * 1);
    xsi_vhdl_check_range_of_index(0, 255, 1, t15);
    t10 = (1U * t9);
    t11 = (0 + t10);
    t6 = (t12 + t11);
    t17 = *((unsigned char *)t6);
    t18 = (t17 == (unsigned char)1);
    if (t18 != 0)
        goto LAB20;

LAB22:
LAB21:    xsi_set_current_line(138, ng0);
    t2 = (t0 + 2720U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t17 = (t7 != 255);
    if (t17 != 0)
        goto LAB23;

LAB25:    xsi_set_current_line(141, ng0);
    t2 = (t0 + 2720U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;

LAB24:    xsi_set_current_line(143, ng0);
    t2 = (t0 + 2720U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t2 = (t0 + 4640);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((int *)t19) = t7;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(145, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 3796);
    xsi_process_wait(t2, t3);

LAB28:    *((char **)t1) = &&LAB29;
    goto LAB1;

LAB18:    t2 = (t0 + 9941);
    t8 = *((int *)t2);
    t4 = (t0 + 9945);
    t13 = *((int *)t4);
    if (t8 == t13)
        goto LAB19;

LAB30:    t7 = (t8 + 1);
    t8 = t7;
    t6 = (t0 + 9941);
    *((int *)t6) = t8;
    goto LAB16;

LAB20:    xsi_set_current_line(132, ng0);
    t19 = (t0 + 2788U);
    t20 = *((char **)t19);
    t21 = *((unsigned char *)t20);
    t22 = (!(t21));
    t19 = (t0 + 2788U);
    t23 = *((char **)t19);
    t19 = (t23 + 0);
    *((unsigned char *)t19) = t22;
    xsi_set_current_line(133, ng0);
    t2 = (t0 + 2788U);
    t4 = *((char **)t2);
    t17 = *((unsigned char *)t4);
    t2 = (t0 + 4604);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((unsigned char *)t19) = t17;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    goto LAB21;

LAB23:    xsi_set_current_line(139, ng0);
    t2 = (t0 + 2720U);
    t6 = *((char **)t2);
    t15 = *((int *)t6);
    t16 = (t15 + 1);
    t2 = (t0 + 2720U);
    t12 = *((char **)t2);
    t2 = (t12 + 0);
    *((int *)t2) = t16;
    goto LAB24;

LAB26:    goto LAB18;

LAB27:    goto LAB26;

LAB29:    goto LAB27;

LAB31:    goto LAB2;

LAB32:    goto LAB31;

LAB34:    goto LAB32;

}

static void work_a_0792828786_2372691052_p_2(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    char *t6;
    int t7;
    int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    int t13;
    char *t14;
    int t15;
    int t16;
    unsigned char t17;
    unsigned char t18;
    char *t19;
    char *t20;
    unsigned char t21;
    unsigned char t22;
    char *t23;

LAB0:    t1 = (t0 + 4040U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(123, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 3940);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(124, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 3940);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 2584U);
    t4 = *((char **)t2);
    t2 = (t0 + 2856U);
    t6 = *((char **)t2);
    t7 = *((int *)t6);
    t8 = (t7 - 0);
    t9 = (t8 * 1);
    t10 = (8U * t9);
    t11 = (0 + t10);
    t2 = (t4 + t11);
    t3 = *((int64 *)t2);
    t12 = (t0 + 3940);
    xsi_process_wait(t12, t3);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(130, ng0);
    t7 = (100 * 256);
    t2 = (t0 + 9949);
    *((int *)t2) = 1;
    t4 = (t0 + 9953);
    *((int *)t4) = t7;
    t8 = 1;
    t13 = t7;

LAB16:    if (t8 <= t13)
        goto LAB17;

LAB19:    xsi_set_current_line(148, ng0);

LAB33:    *((char **)t1) = &&LAB34;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB17:    xsi_set_current_line(131, ng0);
    t6 = (t0 + 2516U);
    t12 = *((char **)t6);
    t6 = (t0 + 2924U);
    t14 = *((char **)t6);
    t15 = *((int *)t14);
    t16 = (t15 - 0);
    t9 = (t16 * 1);
    xsi_vhdl_check_range_of_index(0, 255, 1, t15);
    t10 = (1U * t9);
    t11 = (0 + t10);
    t6 = (t12 + t11);
    t17 = *((unsigned char *)t6);
    t18 = (t17 == (unsigned char)1);
    if (t18 != 0)
        goto LAB20;

LAB22:
LAB21:    xsi_set_current_line(138, ng0);
    t2 = (t0 + 2924U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t17 = (t7 != 255);
    if (t17 != 0)
        goto LAB23;

LAB25:    xsi_set_current_line(141, ng0);
    t2 = (t0 + 2924U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;

LAB24:    xsi_set_current_line(143, ng0);
    t2 = (t0 + 2924U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t2 = (t0 + 4712);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((int *)t19) = t7;
    xsi_driver_first_trans_delta(t2, 1U, 1, 0LL);
    xsi_set_current_line(145, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 3940);
    xsi_process_wait(t2, t3);

LAB28:    *((char **)t1) = &&LAB29;
    goto LAB1;

LAB18:    t2 = (t0 + 9949);
    t8 = *((int *)t2);
    t4 = (t0 + 9953);
    t13 = *((int *)t4);
    if (t8 == t13)
        goto LAB19;

LAB30:    t7 = (t8 + 1);
    t8 = t7;
    t6 = (t0 + 9949);
    *((int *)t6) = t8;
    goto LAB16;

LAB20:    xsi_set_current_line(132, ng0);
    t19 = (t0 + 2992U);
    t20 = *((char **)t19);
    t21 = *((unsigned char *)t20);
    t22 = (!(t21));
    t19 = (t0 + 2992U);
    t23 = *((char **)t19);
    t19 = (t23 + 0);
    *((unsigned char *)t19) = t22;
    xsi_set_current_line(133, ng0);
    t2 = (t0 + 2992U);
    t4 = *((char **)t2);
    t17 = *((unsigned char *)t4);
    t2 = (t0 + 4676);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((unsigned char *)t19) = t17;
    xsi_driver_first_trans_delta(t2, 1U, 1, 0LL);
    goto LAB21;

LAB23:    xsi_set_current_line(139, ng0);
    t2 = (t0 + 2924U);
    t6 = *((char **)t2);
    t15 = *((int *)t6);
    t16 = (t15 + 1);
    t2 = (t0 + 2924U);
    t12 = *((char **)t2);
    t2 = (t12 + 0);
    *((int *)t2) = t16;
    goto LAB24;

LAB26:    goto LAB18;

LAB27:    goto LAB26;

LAB29:    goto LAB27;

LAB31:    goto LAB2;

LAB32:    goto LAB31;

LAB34:    goto LAB32;

}

static void work_a_0792828786_2372691052_p_3(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    char *t6;
    int t7;
    int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    int t13;
    char *t14;
    int t15;
    int t16;
    unsigned char t17;
    unsigned char t18;
    char *t19;
    char *t20;
    unsigned char t21;
    unsigned char t22;
    char *t23;

LAB0:    t1 = (t0 + 4184U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(123, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 4084);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(124, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 4084);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 2584U);
    t4 = *((char **)t2);
    t2 = (t0 + 3060U);
    t6 = *((char **)t2);
    t7 = *((int *)t6);
    t8 = (t7 - 0);
    t9 = (t8 * 1);
    t10 = (8U * t9);
    t11 = (0 + t10);
    t2 = (t4 + t11);
    t3 = *((int64 *)t2);
    t12 = (t0 + 4084);
    xsi_process_wait(t12, t3);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(130, ng0);
    t7 = (100 * 256);
    t2 = (t0 + 9957);
    *((int *)t2) = 1;
    t4 = (t0 + 9961);
    *((int *)t4) = t7;
    t8 = 1;
    t13 = t7;

LAB16:    if (t8 <= t13)
        goto LAB17;

LAB19:    xsi_set_current_line(148, ng0);

LAB33:    *((char **)t1) = &&LAB34;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB17:    xsi_set_current_line(131, ng0);
    t6 = (t0 + 2516U);
    t12 = *((char **)t6);
    t6 = (t0 + 3128U);
    t14 = *((char **)t6);
    t15 = *((int *)t14);
    t16 = (t15 - 0);
    t9 = (t16 * 1);
    xsi_vhdl_check_range_of_index(0, 255, 1, t15);
    t10 = (1U * t9);
    t11 = (0 + t10);
    t6 = (t12 + t11);
    t17 = *((unsigned char *)t6);
    t18 = (t17 == (unsigned char)1);
    if (t18 != 0)
        goto LAB20;

LAB22:
LAB21:    xsi_set_current_line(138, ng0);
    t2 = (t0 + 3128U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t17 = (t7 != 255);
    if (t17 != 0)
        goto LAB23;

LAB25:    xsi_set_current_line(141, ng0);
    t2 = (t0 + 3128U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;

LAB24:    xsi_set_current_line(143, ng0);
    t2 = (t0 + 3128U);
    t4 = *((char **)t2);
    t7 = *((int *)t4);
    t2 = (t0 + 4784);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((int *)t19) = t7;
    xsi_driver_first_trans_delta(t2, 2U, 1, 0LL);
    xsi_set_current_line(145, ng0);
    t2 = (t0 + 2448U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 4084);
    xsi_process_wait(t2, t3);

LAB28:    *((char **)t1) = &&LAB29;
    goto LAB1;

LAB18:    t2 = (t0 + 9957);
    t8 = *((int *)t2);
    t4 = (t0 + 9961);
    t13 = *((int *)t4);
    if (t8 == t13)
        goto LAB19;

LAB30:    t7 = (t8 + 1);
    t8 = t7;
    t6 = (t0 + 9957);
    *((int *)t6) = t8;
    goto LAB16;

LAB20:    xsi_set_current_line(132, ng0);
    t19 = (t0 + 3196U);
    t20 = *((char **)t19);
    t21 = *((unsigned char *)t20);
    t22 = (!(t21));
    t19 = (t0 + 3196U);
    t23 = *((char **)t19);
    t19 = (t23 + 0);
    *((unsigned char *)t19) = t22;
    xsi_set_current_line(133, ng0);
    t2 = (t0 + 3196U);
    t4 = *((char **)t2);
    t17 = *((unsigned char *)t4);
    t2 = (t0 + 4748);
    t6 = (t2 + 32U);
    t12 = *((char **)t6);
    t14 = (t12 + 40U);
    t19 = *((char **)t14);
    *((unsigned char *)t19) = t17;
    xsi_driver_first_trans_delta(t2, 2U, 1, 0LL);
    goto LAB21;

LAB23:    xsi_set_current_line(139, ng0);
    t2 = (t0 + 3128U);
    t6 = *((char **)t2);
    t15 = *((int *)t6);
    t16 = (t15 + 1);
    t2 = (t0 + 3128U);
    t12 = *((char **)t2);
    t2 = (t12 + 0);
    *((int *)t2) = t16;
    goto LAB24;

LAB26:    goto LAB18;

LAB27:    goto LAB26;

LAB29:    goto LAB27;

LAB31:    goto LAB2;

LAB32:    goto LAB31;

LAB34:    goto LAB32;

}

static void work_a_0792828786_2372691052_p_4(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned char t8;
    char *t9;
    char *t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned char t15;
    unsigned char t16;
    char *t17;
    char *t18;
    int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned char t23;
    char *t24;
    char *t25;
    int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned char t30;
    unsigned char t31;
    unsigned char t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;

LAB0:    xsi_set_current_line(151, ng0);

LAB3:    t2 = (t0 + 1196U);
    t3 = *((char **)t2);
    t4 = (0 - 0);
    t5 = (t4 * 1);
    t6 = (1U * t5);
    t7 = (0 + t6);
    t2 = (t3 + t7);
    t8 = *((unsigned char *)t2);
    t9 = (t0 + 1196U);
    t10 = *((char **)t9);
    t11 = (1 - 0);
    t12 = (t11 * 1);
    t13 = (1U * t12);
    t14 = (0 + t13);
    t9 = (t10 + t14);
    t15 = *((unsigned char *)t9);
    t16 = (t8 ^ t15);
    if (t16 == 1)
        goto LAB5;

LAB6:    t17 = (t0 + 1196U);
    t18 = *((char **)t17);
    t19 = (0 - 0);
    t20 = (t19 * 1);
    t21 = (1U * t20);
    t22 = (0 + t21);
    t17 = (t18 + t22);
    t23 = *((unsigned char *)t17);
    t24 = (t0 + 1196U);
    t25 = *((char **)t24);
    t26 = (2 - 0);
    t27 = (t26 * 1);
    t28 = (1U * t27);
    t29 = (0 + t28);
    t24 = (t25 + t29);
    t30 = *((unsigned char *)t24);
    t31 = (t23 ^ t30);
    t1 = t31;

LAB7:    t32 = (!(t1));
    t33 = (t0 + 4820);
    t34 = (t33 + 32U);
    t35 = *((char **)t34);
    t36 = (t35 + 40U);
    t37 = *((char **)t36);
    *((unsigned char *)t37) = t32;
    xsi_driver_first_trans_fast(t33);

LAB2:    t38 = (t0 + 4524);
    *((int *)t38) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    t1 = (unsigned char)1;
    goto LAB7;

}


extern void work_a_0792828786_2372691052_init()
{
	static char *pe[] = {(void *)work_a_0792828786_2372691052_p_0,(void *)work_a_0792828786_2372691052_p_1,(void *)work_a_0792828786_2372691052_p_2,(void *)work_a_0792828786_2372691052_p_3,(void *)work_a_0792828786_2372691052_p_4};
	xsi_register_didat("work_a_0792828786_2372691052", "isim/tb_Autosynchronisierer_isim_beh.exe.sim/work/a_0792828786_2372691052.didat");
	xsi_register_executes(pe);
}
