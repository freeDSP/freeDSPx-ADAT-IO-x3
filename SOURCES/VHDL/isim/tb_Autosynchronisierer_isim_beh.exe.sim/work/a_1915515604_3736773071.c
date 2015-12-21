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
static const char *ng0 = "D:/ADAT DeEncoder/ADAT_De-Encoder/Delayline_BRAM.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1915515604_3736773071_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    int t5;
    int t6;
    int t7;
    int t8;
    char *t9;
    int t10;
    char *t11;
    char *t12;

LAB0:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 568U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 2272);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(80, ng0);
    t3 = (t0 + 1452U);
    t4 = *((char **)t3);
    t5 = *((int *)t4);
    t6 = (t5 + 1);
    t7 = xsi_vhdl_pow(2, 8);
    t8 = xsi_vhdl_mod(t6, t7);
    t3 = (t0 + 1452U);
    t9 = *((char **)t3);
    t3 = (t9 + 0);
    *((int *)t3) = t8;
    xsi_set_current_line(81, ng0);
    t1 = (t0 + 1452U);
    t3 = *((char **)t1);
    t5 = *((int *)t3);
    t1 = (t0 + 776U);
    t4 = *((char **)t1);
    t6 = *((int *)t4);
    t7 = (t5 + t6);
    t8 = xsi_vhdl_pow(2, 8);
    t10 = xsi_vhdl_mod(t7, t8);
    t1 = (t0 + 1520U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((int *)t1) = t10;
    xsi_set_current_line(82, ng0);
    t1 = (t0 + 1452U);
    t3 = *((char **)t1);
    t5 = *((int *)t3);
    t1 = (t0 + 2316);
    t4 = (t1 + 32U);
    t9 = *((char **)t4);
    t11 = (t9 + 40U);
    t12 = *((char **)t11);
    *((int *)t12) = t5;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(83, ng0);
    t1 = (t0 + 1520U);
    t3 = *((char **)t1);
    t5 = *((int *)t3);
    t1 = (t0 + 2352);
    t4 = (t1 + 32U);
    t9 = *((char **)t4);
    t11 = (t9 + 40U);
    t12 = *((char **)t11);
    *((int *)t12) = t5;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

}


extern void work_a_1915515604_3736773071_init()
{
	static char *pe[] = {(void *)work_a_1915515604_3736773071_p_0};
	xsi_register_didat("work_a_1915515604_3736773071", "isim/tb_Autosynchronisierer_isim_beh.exe.sim/work/a_1915515604_3736773071.didat");
	xsi_register_executes(pe);
}
