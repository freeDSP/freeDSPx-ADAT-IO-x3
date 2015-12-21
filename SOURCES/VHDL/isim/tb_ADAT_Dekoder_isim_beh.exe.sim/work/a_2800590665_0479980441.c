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
static const char *ng0 = "D:/ADAT DeEncoder/ADAT_De-Encoder/ADAT_Taktgewinnung.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_2800590665_0479980441_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    int t10;
    int t11;
    char *t12;
    int t13;
    unsigned char t14;
    unsigned char t15;
    char *t16;
    unsigned char t17;
    unsigned char t18;
    char *t19;

LAB0:    xsi_set_current_line(69, ng0);
    t1 = (t0 + 936U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 2904);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(73, ng0);
    t3 = (t0 + 684U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t3 = (t0 + 1200U);
    t6 = *((char **)t3);
    t7 = *((unsigned char *)t6);
    t8 = (t5 == t7);
    if (t8 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 1812U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(80, ng0);
    t1 = (t0 + 1472U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t1 = (t0 + 1540U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t2 = (t10 > t11);
    if (t2 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 1472U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 1608U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t11 = (t10 + 1);
    t1 = (t0 + 1608U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;
    xsi_set_current_line(87, ng0);
    t1 = (t0 + 1608U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t1 = (t0 + 1404U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t2 = (t10 == t11);
    if (t2 != 0)
        goto LAB14;

LAB16:
LAB15:
LAB6:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 1268U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t7 = (t5 == (unsigned char)3);
    if (t7 == 1)
        goto LAB20;

LAB21:    t2 = (unsigned char)0;

LAB22:    if (t2 != 0)
        goto LAB17;

LAB19:    xsi_set_current_line(109, ng0);
    t1 = (t0 + 1880U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t11 = (t10 + 1);
    t1 = (t0 + 1880U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;

LAB18:    xsi_set_current_line(113, ng0);
    t1 = (t0 + 1200U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 684U);
    t4 = *((char **)t1);
    t5 = *((unsigned char *)t4);
    t7 = (t2 != t5);
    if (t7 != 0)
        goto LAB23;

LAB25:    xsi_set_current_line(128, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t1 = (t0 + 2084U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t13 = (t11 / 2);
    t2 = (t10 == t13);
    if (t2 != 0)
        goto LAB32;

LAB34:
LAB33:    xsi_set_current_line(131, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t1 = (t0 + 2084U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t2 = (t10 >= t11);
    if (t2 != 0)
        goto LAB35;

LAB37:    xsi_set_current_line(135, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t11 = (t10 + 1);
    t1 = (t0 + 2016U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;

LAB36:
LAB24:    xsi_set_current_line(140, ng0);
    t1 = (t0 + 684U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 1200U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((unsigned char *)t1) = t2;
    xsi_set_current_line(141, ng0);
    t1 = (t0 + 1812U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 1268U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((unsigned char *)t1) = t2;
    xsi_set_current_line(142, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 1336U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((unsigned char *)t1) = t2;
    xsi_set_current_line(145, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 2948);
    t4 = (t1 + 32U);
    t6 = *((char **)t4);
    t9 = (t6 + 40U);
    t12 = *((char **)t9);
    *((unsigned char *)t12) = t2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(146, ng0);
    t1 = (t0 + 1812U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 2984);
    t4 = (t1 + 32U);
    t6 = *((char **)t4);
    t9 = (t6 + 40U);
    t12 = *((char **)t9);
    *((unsigned char *)t12) = t2;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(74, ng0);
    t3 = (t0 + 1472U);
    t9 = *((char **)t3);
    t10 = *((int *)t9);
    t11 = (t10 + 1);
    t3 = (t0 + 1472U);
    t12 = *((char **)t3);
    t3 = (t12 + 0);
    *((int *)t3) = t11;
    xsi_set_current_line(75, ng0);
    t1 = (t0 + 1472U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t1 = (t0 + 1744U);
    t4 = *((char **)t1);
    t11 = *((int *)t4);
    t2 = (t10 == t11);
    if (t2 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB6;

LAB8:    xsi_set_current_line(76, ng0);
    t1 = (t0 + 1812U);
    t6 = *((char **)t1);
    t1 = (t6 + 0);
    *((unsigned char *)t1) = (unsigned char)3;
    goto LAB9;

LAB11:    xsi_set_current_line(81, ng0);
    t1 = (t0 + 1472U);
    t6 = *((char **)t1);
    t13 = *((int *)t6);
    t1 = (t0 + 1540U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((int *)t1) = t13;
    goto LAB12;

LAB14:    xsi_set_current_line(88, ng0);
    t1 = (t0 + 1540U);
    t6 = *((char **)t1);
    t13 = *((int *)t6);
    t1 = (t0 + 1676U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((int *)t1) = t13;
    xsi_set_current_line(89, ng0);
    t1 = (t0 + 1676U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t11 = (t10 / 2);
    t1 = (t0 + 1744U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;
    xsi_set_current_line(90, ng0);
    t1 = (t0 + 1540U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(91, ng0);
    t1 = (t0 + 1608U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB15;

LAB17:    xsi_set_current_line(102, ng0);
    t1 = (t0 + 1880U);
    t6 = *((char **)t1);
    t10 = *((int *)t6);
    t1 = (t0 + 1948U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((int *)t1) = t10;
    xsi_set_current_line(103, ng0);
    t1 = (t0 + 1948U);
    t3 = *((char **)t1);
    t10 = *((int *)t3);
    t11 = (t10 / 256);
    t1 = (t0 + 2084U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t11;
    xsi_set_current_line(105, ng0);
    t1 = (t0 + 1880U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(106, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(107, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((unsigned char *)t1) = (unsigned char)2;
    goto LAB18;

LAB20:    t1 = (t0 + 1812U);
    t4 = *((char **)t1);
    t8 = *((unsigned char *)t4);
    t14 = (t8 == (unsigned char)2);
    t2 = t14;
    goto LAB22;

LAB23:    xsi_set_current_line(114, ng0);
    t1 = (t0 + 1812U);
    t6 = *((char **)t1);
    t8 = *((unsigned char *)t6);
    t14 = (t8 == (unsigned char)2);
    if (t14 != 0)
        goto LAB26;

LAB28:
LAB27:    xsi_set_current_line(121, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB24;

LAB26:    xsi_set_current_line(116, ng0);
    t1 = (t0 + 2016U);
    t9 = *((char **)t1);
    t10 = *((int *)t9);
    t1 = (t0 + 2084U);
    t12 = *((char **)t1);
    t11 = *((int *)t12);
    t13 = (t11 / 8);
    t15 = (t10 >= t13);
    if (t15 != 0)
        goto LAB29;

LAB31:
LAB30:    goto LAB27;

LAB29:    xsi_set_current_line(118, ng0);
    t1 = (t0 + 2152U);
    t16 = *((char **)t1);
    t17 = *((unsigned char *)t16);
    t18 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t17);
    t1 = (t0 + 2152U);
    t19 = *((char **)t1);
    t1 = (t19 + 0);
    *((unsigned char *)t1) = t18;
    goto LAB30;

LAB32:    xsi_set_current_line(129, ng0);
    t1 = (t0 + 2152U);
    t6 = *((char **)t1);
    t5 = *((unsigned char *)t6);
    t7 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t5);
    t1 = (t0 + 2152U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((unsigned char *)t1) = t7;
    goto LAB33;

LAB35:    xsi_set_current_line(132, ng0);
    t1 = (t0 + 2152U);
    t6 = *((char **)t1);
    t5 = *((unsigned char *)t6);
    t7 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t5);
    t1 = (t0 + 2152U);
    t9 = *((char **)t1);
    t1 = (t9 + 0);
    *((unsigned char *)t1) = t7;
    xsi_set_current_line(133, ng0);
    t1 = (t0 + 2016U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB36;

}


extern void work_a_2800590665_0479980441_init()
{
	static char *pe[] = {(void *)work_a_2800590665_0479980441_p_0};
	xsi_register_didat("work_a_2800590665_0479980441", "isim/tb_ADAT_Dekoder_isim_beh.exe.sim/work/a_2800590665_0479980441.didat");
	xsi_register_executes(pe);
}
