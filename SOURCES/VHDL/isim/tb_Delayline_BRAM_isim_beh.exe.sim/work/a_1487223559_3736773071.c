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
static const char *ng0 = "D:/ADAT DeEncoder/ADAT_De-Encoder/DualAdressBRAM.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1487223559_3736773071_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    unsigned char t4;
    char *t5;
    unsigned char t6;
    char *t7;
    int t8;
    int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    t1 = (t0 + 1940U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(44, ng0);

LAB6:    t2 = (t0 + 2136);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    t5 = (t0 + 2136);
    *((int *)t5) = 0;
    xsi_set_current_line(45, ng0);
    t2 = (t0 + 684U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t6 = (t4 == (unsigned char)1);
    if (t6 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(48, ng0);
    t2 = (t0 + 1144U);
    t3 = *((char **)t2);
    t2 = (t0 + 868U);
    t5 = *((char **)t2);
    t8 = *((int *)t5);
    t9 = (t8 - 0);
    t10 = (t9 * 1);
    xsi_vhdl_check_range_of_index(0, 31, 1, t8);
    t11 = (3U * t10);
    t12 = (0 + t11);
    t2 = (t3 + t12);
    t7 = (t0 + 2216);
    t13 = (t7 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t2, 3U);
    xsi_driver_first_trans_fast_port(t7);
    goto LAB2;

LAB5:    t3 = (t0 + 568U);
    t4 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t3, 0U, 0U);
    if (t4 == 1)
        goto LAB4;
    else
        goto LAB6;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(46, ng0);
    t2 = (t0 + 960U);
    t5 = *((char **)t2);
    t2 = (t0 + 776U);
    t7 = *((char **)t2);
    t8 = *((int *)t7);
    t9 = (t8 - 0);
    t10 = (t9 * 1);
    t11 = (3U * t10);
    t12 = (0U + t11);
    t2 = (t0 + 2180);
    t13 = (t2 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t5, 3U);
    xsi_driver_first_trans_delta(t2, t12, 3U, 0LL);
    goto LAB9;

}


extern void work_a_1487223559_3736773071_init()
{
	static char *pe[] = {(void *)work_a_1487223559_3736773071_p_0};
	xsi_register_didat("work_a_1487223559_3736773071", "isim/tb_Delayline_BRAM_isim_beh.exe.sim/work/a_1487223559_3736773071.didat");
	xsi_register_executes(pe);
}
