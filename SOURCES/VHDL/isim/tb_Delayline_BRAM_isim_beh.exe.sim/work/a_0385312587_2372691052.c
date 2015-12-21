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
static const char *ng0 = "D:/ADAT DeEncoder/ADAT_De-Encoder/tb_Delayline_BRAM.vhd";



static void work_a_0385312587_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 2052U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(94, ng0);
    t2 = (t0 + 2428);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(95, ng0);
    t2 = (t0 + 1428U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 1952);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(96, ng0);
    t2 = (t0 + 2428);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 1428U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 1952);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_0385312587_2372691052_p_1(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    int t6;
    int t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    int t14;
    int t15;
    int t16;
    int t17;
    int t18;
    int t19;
    int t20;
    int t21;
    int t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    int t27;
    int t28;
    int t29;
    int t30;
    int t31;
    int t32;
    int t33;
    int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned char t38;
    char *t39;
    int t40;
    int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    char *t48;
    char *t49;

LAB0:    t1 = (t0 + 2196U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(106, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 2096);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(108, ng0);
    t2 = (t0 + 1428U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 2096);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(111, ng0);
    t2 = (t0 + 4924);
    *((int *)t2) = 0;
    t4 = (t0 + 4928);
    *((int *)t4) = 255;
    t6 = 0;
    t7 = 255;

LAB12:    if (t6 <= t7)
        goto LAB13;

LAB15:    xsi_set_current_line(126, ng0);

LAB47:    *((char **)t1) = &&LAB48;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB13:    xsi_set_current_line(112, ng0);
    t8 = (t0 + 4924);
    t9 = (t0 + 2464);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    *((int *)t13) = *((int *)t8);
    xsi_driver_first_trans_fast(t9);
    xsi_set_current_line(113, ng0);
    t2 = (t0 + 4932);
    *((int *)t2) = 0;
    t4 = (t0 + 4936);
    *((int *)t4) = 50;
    t14 = 0;
    t15 = 50;

LAB16:    if (t14 <= t15)
        goto LAB17;

LAB19:    xsi_set_current_line(121, ng0);
    t2 = (t0 + 1224U);
    t4 = *((char **)t2);
    t14 = *((int *)t4);
    t15 = (t14 - 1);
    t2 = (t0 + 4956);
    *((int *)t2) = 0;
    t8 = (t0 + 4960);
    *((int *)t8) = t15;
    t16 = 0;
    t17 = t15;

LAB35:    if (t16 <= t17)
        goto LAB36;

LAB38:    xsi_set_current_line(124, ng0);
    t2 = (t0 + 1428U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (300 * t3);
    t2 = (t0 + 2096);
    xsi_process_wait(t2, t5);

LAB42:    *((char **)t1) = &&LAB43;
    goto LAB1;

LAB14:    t2 = (t0 + 4924);
    t6 = *((int *)t2);
    t4 = (t0 + 4928);
    t7 = *((int *)t4);
    if (t6 == t7)
        goto LAB15;

LAB44:    t14 = (t6 + 1);
    t6 = t14;
    t8 = (t0 + 4924);
    *((int *)t8) = t6;
    goto LAB12;

LAB17:    xsi_set_current_line(114, ng0);
    t16 = (256U - 1);
    t8 = (t0 + 4940);
    *((int *)t8) = 0;
    t9 = (t0 + 4944);
    *((int *)t9) = t16;
    t17 = 0;
    t18 = t16;

LAB20:    if (t17 <= t18)
        goto LAB21;

LAB23:
LAB18:    t2 = (t0 + 4932);
    t14 = *((int *)t2);
    t4 = (t0 + 4936);
    t15 = *((int *)t4);
    if (t14 == t15)
        goto LAB19;

LAB34:    t16 = (t14 + 1);
    t14 = t16;
    t8 = (t0 + 4932);
    *((int *)t8) = t14;
    goto LAB16;

LAB21:    xsi_set_current_line(115, ng0);
    t10 = (t0 + 1224U);
    t11 = *((char **)t10);
    t19 = *((int *)t11);
    t20 = (t19 - 1);
    t10 = (t0 + 4948);
    *((int *)t10) = 0;
    t12 = (t0 + 4952);
    *((int *)t12) = t20;
    t21 = 0;
    t22 = t20;

LAB24:    if (t21 <= t22)
        goto LAB25;

LAB27:    xsi_set_current_line(118, ng0);
    t2 = (t0 + 1428U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 2096);
    xsi_process_wait(t2, t3);

LAB31:    *((char **)t1) = &&LAB32;
    goto LAB1;

LAB22:    t2 = (t0 + 4940);
    t17 = *((int *)t2);
    t4 = (t0 + 4944);
    t18 = *((int *)t4);
    if (t17 == t18)
        goto LAB23;

LAB33:    t16 = (t17 + 1);
    t17 = t16;
    t8 = (t0 + 4940);
    *((int *)t8) = t17;
    goto LAB20;

LAB25:    xsi_set_current_line(116, ng0);
    t13 = (t0 + 1496U);
    t23 = *((char **)t13);
    t13 = (t0 + 4940);
    t24 = (t0 + 4948);
    t25 = (t0 + 1360U);
    t26 = *((char **)t25);
    t27 = *((int *)t26);
    t28 = *((int *)t24);
    t29 = (t28 * t27);
    t30 = *((int *)t13);
    t31 = (t30 + t29);
    t32 = (256U - 1);
    t33 = xsi_vhdl_mod(t31, t32);
    t34 = (t33 - 0);
    t35 = (t34 * 1);
    xsi_vhdl_check_range_of_index(0, 255, 1, t33);
    t36 = (1U * t35);
    t37 = (0 + t36);
    t25 = (t23 + t37);
    t38 = *((unsigned char *)t25);
    t39 = (t0 + 4948);
    t40 = *((int *)t39);
    t41 = (t40 - 2);
    t42 = (t41 * -1);
    t43 = (1 * t42);
    t44 = (0U + t43);
    t45 = (t0 + 2500);
    t46 = (t45 + 32U);
    t47 = *((char **)t46);
    t48 = (t47 + 40U);
    t49 = *((char **)t48);
    *((unsigned char *)t49) = t38;
    xsi_driver_first_trans_delta(t45, t44, 1, 0LL);

LAB26:    t2 = (t0 + 4948);
    t21 = *((int *)t2);
    t4 = (t0 + 4952);
    t22 = *((int *)t4);
    if (t21 == t22)
        goto LAB27;

LAB28:    t16 = (t21 + 1);
    t21 = t16;
    t8 = (t0 + 4948);
    *((int *)t8) = t21;
    goto LAB24;

LAB29:    goto LAB22;

LAB30:    goto LAB29;

LAB32:    goto LAB30;

LAB36:    xsi_set_current_line(122, ng0);
    t9 = (t0 + 4956);
    t18 = *((int *)t9);
    t19 = (t18 - 2);
    t35 = (t19 * -1);
    t36 = (1 * t35);
    t37 = (0U + t36);
    t10 = (t0 + 2500);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t23 = *((char **)t13);
    *((unsigned char *)t23) = (unsigned char)0;
    xsi_driver_first_trans_delta(t10, t37, 1, 0LL);

LAB37:    t2 = (t0 + 4956);
    t16 = *((int *)t2);
    t4 = (t0 + 4960);
    t17 = *((int *)t4);
    if (t16 == t17)
        goto LAB38;

LAB39:    t14 = (t16 + 1);
    t16 = t14;
    t8 = (t0 + 4956);
    *((int *)t8) = t16;
    goto LAB35;

LAB40:    goto LAB14;

LAB41:    goto LAB40;

LAB43:    goto LAB41;

LAB45:    goto LAB2;

LAB46:    goto LAB45;

LAB48:    goto LAB46;

}


extern void work_a_0385312587_2372691052_init()
{
	static char *pe[] = {(void *)work_a_0385312587_2372691052_p_0,(void *)work_a_0385312587_2372691052_p_1};
	xsi_register_didat("work_a_0385312587_2372691052", "isim/tb_Delayline_BRAM_isim_beh.exe.sim/work/a_0385312587_2372691052.didat");
	xsi_register_executes(pe);
}
