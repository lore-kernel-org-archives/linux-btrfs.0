Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32088 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932591AbcE3C6c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 22:58:32 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id C26E3489F997
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 10:58:21 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests: add 020-extent-ref-cases
Date: Mon, 30 May 2016 10:58:13 +0800
Message-ID: <1464577093-12877-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to confirm that btrfsck supports to check a variety of
refs, add the
following cases:
* keyed_block_ref
* keyed_data_ref
* shared_block_ref
* shared_data_ref
* no_inline_ref (a extent item without inline ref)
* no_skinny_ref

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
In order to btrfsck on the restored file system, we should use the patch
"btrfs-progs: make btrfs-image restore to support dup". This patch make
btrfs-image correctly restore img in dup case.
---
 .../fsck-tests/020-extent-ref-cases/keyed_block_ref.img | Bin 0 -> 10240 bytes
 .../fsck-tests/020-extent-ref-cases/keyed_data_ref.img  | Bin 0 -> 4096 bytes
 tests/fsck-tests/020-extent-ref-cases/no_inline_ref.img | Bin 0 -> 4096 bytes
 tests/fsck-tests/020-extent-ref-cases/no_skinny_ref.img | Bin 0 -> 3072 bytes
 .../020-extent-ref-cases/shared_block_ref.img           | Bin 0 -> 23552 bytes
 .../fsck-tests/020-extent-ref-cases/shared_data_ref.img | Bin 0 -> 5120 bytes
 tests/fsck-tests/020-extent-ref-cases/test.sh           |  14 ++++++++++++++
 7 files changed, 14 insertions(+)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_block_ref.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_data_ref.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/no_inline_ref.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/no_skinny_ref.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_block_ref.img
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_data_ref.img
 create mode 100755 tests/fsck-tests/020-extent-ref-cases/test.sh

diff --git a/tests/fsck-tests/020-extent-ref-cases/keyed_block_ref.img b/tests/fsck-tests/020-extent-ref-cases/keyed_block_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..289d37bc309fb8c33bff13cb71de8b9c5d83f1bb
GIT binary patch
literal 10240
zcmeHMcTiK`mrv**#1MK39Rx%S1d-lRq-bag5-@ZGM0$}H2qgkiq!)pRA_yX2qbMyD
zY0^ZRNK>jHML=pc=<mC_yD&TJ&i=QV%)6gCdH3CW+UJ~i6K$95J}HQN1NhfRfH(qw
zeu;pKhyY-fgDYV8;DV_8iLnPb{ueGez@_y+<u?y7py4M@IJols!Y&8m(qGu^0IT4C
z-s66NyZ^wb#^3VgKQOxKx16W>H!l5!e?7D1x4iog?E3b%9NhXF*ZqN)e_?MD;(pL=
zzwhB`|BdVZz^IPja&YHwT>1w_y!$Oj|H3y8o)7N&DgU`=*!$o2sC@W|{SWSO{e@i)
zaOp4Hae%vjVIvA62Gku~0MMVae!~C1{J#bMrxx%X*3tV|+<~Snrg5gaT<DcuKB}(l
z)b*fxjFpwOeliBJ<$EG7_xZT*HE3GIu>l?f5>Sjxj58pSyaN?QCrWii3?0Q0!gvyd
z;he}|O`t`a){WyMEqN?TyOulVFWm^5U)!jzoeM}Qz|O5F(0O*x(o^PM_)1MmDt1HN
zfSn<OMvzg7UuI5%_mNvc(08)PcxAM4HWzbDs6LG5T)i+Wc^-gCw}PhR%!_e7W35xi
zZf0|-B%VeupPAU^eIZ`l+P)0XQ!G|2L$kfOpo@G)1|;FpbG?CFa#l$kLpPuInIVz#
zdoH9fv=rve<mp<u2Fy_4^^ru{YdGZ?wA`a`Sivq`B$x72Tj4?r9sgEVikN;!Tv>}8
z5OLEv!FTxC&6^qRhgpY=lT~#x27JBwnbQ?Tqu9+c1^;{V^34G?_+mt02O@*~f&`w9
z6@ND;gqQllG&Lz62%8e*CRGPKCTpzG&eZ^BfMAIXLK6Q{62<t3#wb{blr*@NY(~Ax
zLsU3`hZ$X985S*%e(@Eq@NC;KGiUqt-qKCE96?dO&#7*xM0=D2s?IJ4V!6Y*GU9_y
zVBBFX8*IVyf#&unUmkaaVUBaBK~x%ifmOF>_xu1;Mdt5)hppG|u{0f~83_m$+Q`P+
z8)H9Ea;t#zTdm)QT)$7uRzRd_?sg3!5+Foj(+@KYUXy@{sX!(|BtET$$mIP;1^&?n
zOrlGB>sCjF06C&EM(gXV*v}(#yG@E&U=B6_;EI;ORo~%0^8~p};BgbCL2$9bf`V;z
zWYCA~3qG|Hx-xZC5c@DKc(!@<JkI?!VR~r6XiQ>y4Qhv(w+`ubejBkDHg6?7ZI9|!
zNo#P82$=w+P0%L6RFYi*&%z}Hc|d+0k%buQ#=#hovKZ1vhY0OIjr`9Zg;^ueY|Usd
zO5EsqiU=uJ7N$4cI+eF5g^NN$r00*r#tknyR{#L)2721Q!wkrI@y5ffCe3L>b{nqt
zfUT><d>tYCDR}Lx*W+)jYg-@>)pdymMl_X>@CiygM-F*Xj4&nsAh7>sG6y=8F&yvE
zB>y`UoB;s!FANjD!}2RL2nJHFQqfXglZPMt+PshN6)Pq#1zDqH8jmo}bm+WwnCQ5z
z%4ItE`dMyLJc$537weQFHx?65HT0;40K>Y0gmG9g{Wt21AZ!_hFfL3Wp^ofD9*5p}
z61Wi`!($BnsPPFu-V!SfpMEY2?0FOf@=hr*uKpZQ6O$m|jye}!Dhb27!(cGnNLe_!
z6(vIzv>goz(1N(ihnn(u|Fp6ziAjB48&6%GepUwZYLclz;gzh6#Plmy^)phla#B;$
zQ!^mf9FudBk~5HyYc|FisflSx8KjJ2Wunq3bn<aATER;42&BWbq-$;ut%EEF6+64c
zXp`21ot>JBNX+c@MUO_TrH3TSr|S=6o|7BTtuQ8AxF~_Ss>w+@D6Ab?9-UL$Q`giy
z>rxM;aqgE0&G2HqrxeznUN2gJB8zEh%ze}nYe&Nk%HfNAYj$4OPl!*wn3SE}map=4
zMMi88!uteirVQZpo%oBs!#iM(=68qrpAjT+MAlT|w$pNH(&`*7AJb2(=}xE_-Xl#N
za|LVuWVgfeMi>AX5n@974rlsI4{%W^po~%KrP@!{k`}qPP5p&N_nJ#5!2DWS^n9JZ
z-iwbT+gA27?VlP3wxo6Wq)|SOV|$FIE@sYWw-j$=6c>)87ES!`7gVHV!TJsxj!rck
z8s3~B_z~*);kHfwT|F+6XO+1MLIt`YWDs7J@!w<o7nA?iHJ4bYR`;3sh!H;3Retxd
z^he5c92Mcj^bZ$Bkrag&o=fwm>X;5)P0N*(b={())c>8-|7mSBv45hNXEr8M`sK{}
z=EGbFi9L$=ws6~nf2Cu!5)-%Yum^$OKj$zV17sSG(2*HEZyotJItGDQP7!J9ZIa@l
zWs5yl@(4eY<F;k~N=LO2rUIfLAMl+CKTJnqPU|Cx@tEqmn;H`=q`$$4zeADC&O_Bt
z7m?0cu^WLA{>_EI8-btUbMQ8j)Xfw?EF3w^4d~<lwQrF=dO`JdH`Tvca4wK3k(iCR
z?J4EM$k<ip-BE4~nV*XI8#j(1nd^ycW4zSdc37y2bJ`za)M&N!6_vly(W;Hv%y&52
zZ)*o~n2y3S^+)N5nV<TrbOh|N7!lLaWVtosu)v|pI;x^ZtFN#8l^-$ZnHGp7r#q3=
za+p;?N3N)&vc97JH&&f^%!DWQ*hPb`iHGSJAk%t;Ra4OOm^Sz_Mi%jj>~evFJi>%b
z3$7}7wE_oW@nvIu3Fi|Sm)lrY^Mv6&msJE!{CMQjdb|QYN6ex^=ElRdP25yHOLG?x
zQ=zk{@VRk}_Gb?j&(iw~*lF}E3NtqzsV!!SnMJ7&NQBVc$3XMd0ite+<V0lNqR)&4
zfzm*#1!UZC4NA(Y*lW6AXdY@DDCHu9LkdM$d7P6H?0`i8E<Zsnf1uZVJfRHkZfgyl
z1v$t>&D)Sld6|5S7N9Xq;eENFM96opHFq1S{Z>`dFN1$GwDJm3bMt&-eU&M_W$Y|_
zC2Oe}DJjE2MR#C0<FbDi@p9)ekLlI(f|PusofQ5?G`aHQc=}>}5f!9SL(*J%u{r+B
z_>}Za!<NrN?;8sUM>2_khTyeIw9J#dyHNV%e2k*#Ru42DO&o4VYp0c8Zy(~?3Hq@J
zU#x$aiIlB5*LY4)nOZ-+YLA_pIE9WrS?FL&H`H|k_MzZ2zqqJno4DWQ%j`&9&wETp
z-@o@>c%)^OcQ-DqK=*A$`^AL<8%>ReE2uba3r|X!gJJSMBwtrFVrF&qMpRAbSntJq
zN<EXh&PJ<u!O1zKp=l1#WHD@k6#G~GR?HHbF0%BT;Bhy7YQxLbzN66$aaN;`WE3j`
zpImT~FVk;T*D$JyC}&A3H|>@aO{dqtE;E>Smtz!2LmV<I3c^G@JRJOBkG{lqSxHZH
z1+ASp3Fb)tD4=1>ICDasXf_5uQ91x06(Nlnbz3K%9$L)VFCNva2;#QM{;CMv*=E}F
z9bWKR7(Dcyg7M-}?Zd;|Z8F?H-O>M~eV}{I%t&O&%va+whw+t+YX-f*JE{abg=+79
z^)J4J&SwLKHP#(7@?v!TC&-NJ$Sxl<yaU?=r*)Elkx;dDA7AAF-T$+b{15FJkQ@N0
zg|WC1%TCQmbNylL0eN>+`(T^99rjl`s;V*#68$)DtbAzCN%rojVs4Au*7z$wF8ML_
z`VP0Bnj1N^eUQ$wJ)-WktFGVvt71Op&rD=U`R}1q5{LPbN~Yx~hK!tN!2C^ZEt6*M
zB38Pb&#i~G5A5%bN{%nM?c7z`0G?2WHYfVfD5VKo)Zja8d|Dk%as?m>4D3b1pbZG>
z3tU)`xF@t&0Sx^JgYqG$mBq0j7f)!43bj5@CutuqO|ruzdUjlOAfX-DQ-7?Fmm+zv
znWCpYy2P57LxYlAH&VuElIa)`RmB#GfuXxFC<H+*Ylj5|c|x-~4!C$0;J`_vQrSV<
z6d@Gj;FxAf3oO1>KmLS2$_O9Klbf6=NaV9|fyaq--R~{kPTv*Q9lAN-!2(aouM~IH
z*BiDecW$TMv}+kt+p2-mQ!dzPhRNP{`fOF_LPx9nW0DJWU+;az)|lFm*-7cNZaML-
zgvnmt(w2uZRitDGgPR+*;l|T|l8#NM&e%n5g6I?JYpXoc;!PK@I+SO`y{@(havLDo
z={71D)qPazsf*o2&LNQvNqQwx^S$OzzCL?p(3fo*9LZir{6P&F)Va-nVWHx)W|R)T
zo-6hKEU3bj(+L>`VM&GAUU_v}=z0EzT!&Kgg45Xk4KCswZ8hYFxir^4IdQ-E$zBw3
zOH@^)oCm|f&hq{7t4%R+2}<%)Gc(uT+La1Pi)&)B?Pn1ix1}vk5;rGS29sbk18o#A
zp7W`Tur|pvNIT$GhSkBFHKz#`I~wa3NHz$sviYS&!!Kal8j(6sBDb>eiJm$rNjP~G
zAaS5)Nru@z9bxXOG)Y<PTj{aIM;V_;CDO4Pk&f3|Z-_ppVFpw|c8G@@YagPpHg%+z
z$)(AP-pgGYTEgYLu<sqcNlP-rcEm9f4I*$7L9UB>0qdvoI36;DL~t<}2~mpIPVhwi
zr=IwqlQI+|0sz>>Gx7TlkKnj!Fo$&<tVqivGT2FFUE;4Yc;17Vgve5iaf_CRsR$Z4
z>ZEKK5txOz%Bg`I70T$&7+zTR-;l7lwzF|_O=t}ca|H<QCwC=p1w9#B@u}{u)h_Bx
zRj9&23T?eoZ4;&L1z&P(3)~pC*hj*RChywYKCExj7#MpN8kKD!H^*p7m;7V#){<3o
zuhhWUF{DwVbh_Ax0c~=(t!Z^cdwt8|X4bKpu_rp4x6<j73(Q|HHQhd6wp9C1DfX8%
zQhRG%yH&G0wN!iJ@g+zpp>`c9Wi)x*ezYnt<#l$g4^^5kflye?LYs`;y1c(S?P%CF
zrsKWeXYq1SwuM7<#crZ{Fw#)>P0(gdt?Y`%+INtBK_h6onEZTxv>(CcYxQEVvgq|k
zXN($L7xoeT{F9$*Sx&fIo9$(L-oz>@p}e1|Kf5*esn#c0nYH`H5?<p*L8Fjqz0O)+
ztS`Z$o*ld-V?6`1Eol6#ohLrp-=<W%dD(FozVHo^7(w1j*Ukc0I=8+1iA`CVpeBuZ
z0W+HP8kv-3X)g~9@(J)9Dz)lw75s>xJ{y@r>2Y=G$F4<((C*O9eH(JSg2v}xoZ|wO
zcQ>{a|LK})w|F215(=rQHx0k<jqaXWd_Tu<>Rk>F0{<AYaw_TDPBs4|YP1*&YZ*Y?
zrY$qy+&XK!v-gSV)!t6Y!qq!*ILJTeU4NbhqyZ?4)oCA^=1OrS*@gCIAu>3$*VL{{
z2%jQ(NS^x~oWva7+dvEvZ4cG!cEX*Yhg&$QlS#~By#a^}N^MdAuf%GI@9<RMvQf-o
z!On<0>fO^xeO>hn+Ygm6K+*soHB(?idtK>0dR~bTCQ&yoVP2XC<d$*|av=~RiHFY0
zr4hU9FqGT_97G8ThN{iVbyN}smU1?^5IRmUv|(1RT$V>p10`pJgP08xQMXrzJ!Tdh
zJ{OPCevJy51#1qtrIX)Rr_ERA66M9y_V7lOVD7Qqw`Qbe0^Ct`GwHPzmX@^9FvQbZ
zQ=$5gQQU;;KVaV{1wQ#G7Po{(dlX!hRxylhdZTq8W}9h4e!BCL{N$U^Gdv&Nn%_a;
zA2XrB$G+@%Yj754GSN?COA?}i)n{O^iD-WrthD~rbTFmu(;BmU-31~aN9kaQ9P2&{
z8gylLLblN#aO_Ryn&?28ruRjgd!4sWWIXZ#bELWpG=3@LD0F`wtD~=hWWNg9s7TWE
zK?8_`pt!hY+jL7XoJLW3)PHjm12kVy(iM;vw<Yp_`|2et;vD)170+3}x`_~5-Y~ey
zltDyAMVLtRKbayZPq=>C>}!^~GqNonoa&^puyq}p+MwljU1@O2fPEB5dC~fg&h^Pj
zNWL?r$A?h<zNXh4J1#q8aoWQdoRQjz;M4?ixD0WQ8gY&^aSqKvk33}%b+C-isiJDJ
z%m;G{g(90nPX1dSjm-}ksol1uLsP>)xQSpHQ;Dw$;(|TUZdV#7r1sA;6JfR)`Iw7-
z(;}-P5T|3`&1^Mga2Hz<aLo4F_x`f`#-#v&SpcxscX)9?Pm9r#lVbVaigm5BXRX*8
zzg|3K#MEna5nPabjEhe)jK=ec`g>Jjs?!`0ayBU6Ni0^<Mg&j8AN7^z7B=cWRT#GX
z0TpKcu78;%VV(QlCiN}M?8|SqIiq86cs2anYdlCQ_FeiujN<INvqgfloZrcsTbrW{
zr~C337-#}ZcCEhjbdP7QZrnNh&f>|B2cDJ9S5~}bciAP`Mz$^N&4v2N@h3ov0p2~C
znhtugQnrS^3dh^;baQM{h|uz84J#R+n_vx{Sx<GR@dtkpxOqk2AwAN7|Mfa(cX$7!
zTXf?K%R8Y=s-xvE(i@&Lcqd;Rx+?PV{12EyX09unW#F}7mT>-yGUwdz$!{3FCzv&@
z^As5;srrUjlxUKvI24W(|3R6OuoH!d(0qfIhD+i`AGjXJJ)7T>2~Q&R_PSNRNga--
z`UIWHF&MlJ-r4`k6z=64lXtv&OkcR=6iDM_AEOZ(lzif2lKDsD^UQcwHEFyiS>QQt
zjkmV58ZfvNp9yOlxR_QnRF43a22}6MgE?vUq-6vzMsSg_sLO|DTAm7x#8L6aO%yTl
z<V=u<rcQuD<0fcBb8sBIb=?tQ8!Qha?1$Iem=5CiM-KnnqAr{)*TZ8;wg#Kwc%WDk
zmb^1A+^P(`YKhYlc91yDoN_zdL5Z2BNiC3zIVCC_OL<JEQSBbbF>)*1hw$)RlL9v@
zULNKKkl2r=P`j4UOJZTpCd=ZC@3+)CqOwo>z7Nel;roVdl;2l?W%QJ<IjBl!dDz+W
z(fAqDSx`M*w94F7Pxb6EuDcfa;2M(NOjSAhhlZx!5Ze=~x8&PO%AHf*+NFQ@PSxWd
zl8V>kpL6FkXS6+=;n|ZUezvzst?Hv#5N_UaFF0bq*0(m6Yvp<_>uO8HSPpYaZNTH_
z9a67)79Q5UYG9m6XuToW?EIAgcvCDnM2zJuGiOF)))ss1kwury4~tBdo=(TqXiOX`
zzpEO42EM1#ybXCzMRi6Wf-S0HZDr5I>RaUre1h>xKs0%aC?qDVfU1QgcO-7;ezv+l
zal4l?p7o5E&&+OZ`kLOWc7vjaL4?Sqj?JAMxW{x>`aO>!E-^ESPpoRyDJ|cM{9Srp
z2I{y3?$$Zk2f?fSJB&U)FZFZZEXi@=Hr*JK_s{>H&Ve~^U*H+V5ni~c@S^YHP=tRU
zMa8lAGv3_2>zfV~hE4M0Qrnjvs2e*D6wxlyvrazh#W`})Q;04JEr8b@UqK>-Y4!I6
zH2D&=1R%FH4u&er{?do?35Ep1?u&Io&zGF*fu8w<AhhQVUVPdDptW}8dvh<i>iemD
zifLfjsb$`ar3%!J#k%qLPo0@X?J^mOT$NvER3<l$0#R&`3V;^Ib?ad7<Wxwk$wg3e
z*ler1rv}0*A_jHrNQ4M%-0edg2JQ;Z{ZasWN$Lq-7OR_o>RC#Yn-gM({viQ10&2u9
zj5|tPOby{er#$s4Wy#G9xdF(m=~1QS2~eZlB=MAlaj4t@=?8`ZC(Um~=_oNSn?bWk
zW^GVs>*l|CF4L&|cmT=<Xu(`rR2D>_x|9fviBT+{T=R9sCi15wbjq{iGAcT8+5J0!
zOjZX<E!eU!nw|84^+%v<_QL|;tbH8-cFW7Pgo@l|9ITQQ;sYd_N%;H(Z}S)uGF?iS
zZ8;O4>I7Q<h=}iuKSOyMuIupyH6I~-)<{y_>!pV)o2UsWu@aZXCgi5h2G{)@VPKb5
zM@Mg0ahpRs%~IiPSUOI0#LJaUO)OH|g-TML{47}-E{kKg1JO*^)PZQDQ?kQWTxEnO
zxvJB{!_0k{;b9fHc(%}zolrKCkMUi!K`yK<v`r<M1Mg3^rWP6-E<C)f{UqTk^o6*i
z=6lwH-a_|6NMU(_!R%z8W`6VqmOJ7gb23perl_UuGIO~Zg_oZc2A^bf(OsbwV=G#d
zvWM!Jj5}VTa9VHkgA>}U9=)yQFC`SV*3NTQd%aTj6nwNF9PF}2V0y>b`+Yx}ccD@Z
zz_exa_7)$#im`GBkR1;JbtBnjRWKPHz>KU^QmM9fRf=xsE;n?<XcI7F-vZ?7@pT;V
zs;ixIeB?VDIgQ`qhCq(3JZD|pof7mqD}F!fTU<cpnNb$qP?6S4uS>ht?$mr%zmb!^
zR5FLE=^}Ye&wkVQ35LHMh<Y->zE*!v(=_n2zUe{u&endTQ!hzPPz_*VaTLxDT43YV
zn>vx(EPsKnBNc}fr5VYLzGm{{yv>xN*=4RzyBlpgEOzpAufN`sT#jvz=GF?7);k3{
zWju14Ej*du%hZn60KxF=<Wg_uRX(3dGf9i;A8Q*MVXC78`J`8hqsuqms3&l&TNKU!
z&osK&RM<zjL?@ZISD8D#Q}|Hvbt>Zmi_*3JSJS~isMz!?2i7(~kA|DuR#D$i4^wu#
z3Hrsn_F5SEpzvlw1S41U%<fKmQXf_S8s9o6)X~3`^oqWGOlP`vseZJPt8^$+EQ&Pr
zi?^#cJk&OJoP<mVTE9hgj<ep6Dn%yLgPvACRF5ixv;G_zCYC2zc$~`M_AU{;<tm6e
zQ@g$W)XZa^P?RZXMi}FNYVb$8L+-F^vV`%=t`qQYWIG9z#UT_rQeSp->M~Y4XHfZL
zB&;#_3m0w&IlX^?eq{2k&(OJLch#NS%o_ay`pOO6&)p|mw;k^ea##UVnpnH{v;!{V
zcHaU&6mm`hPMRvM4CD3wwHm+B`jX|-xjQ{#sROY+0#_2Cd9vbh&^!@wf2JETb`@XO
zpGstmm$URWI|MmpLG$LGD9C?+4PPmFzs8`o%U?uZvLhww@aSq<8Q~+QpI{fg#_Aa5
z_xv=s@MqvUd~%_<rJ-!Sk@ZFY^woT~n)8<f1(+N&GYkpJ8D<3KJprFRC&llClUudx
z^3YOdB(iKE*TiSwoj_XlZsSwY0zz=1$>q4{pA<-B!d|A1f`A~BC;0jLnYglBa6j%>
z(inX+6XoH^vHQDZ?}NMf&cMdvlU*7%9{H?gTX%-Y*HWDwRb2L8EOu5FSYyL*Q@HQD
z7GJti`(n*%Ps==|7I+sxoky%Gy{9kYQLJ?nDat|TXMteDSvL$jnalY>`lv=@D=j-M
znR6lasJa54CU-hc>b;uVSNITJiDG8KTjiUJRnPj0rlJ$Swb$0fMirk79-CizEH*8o
z>tT`)6EU21X}R<)z{)-K;%As1t`!%Jt2sV#GNMT|Y?3!jI^6s0hD7WgoJC97!ZNhe
zkQiyKDYD;1jH;WY-OBWkUj@UIBAT4i4Bmt@nA5J^7|a`uP<*`k9SJf_3yi@HwnqoX
y;%Y_u-ei4?J5h4H_q24FNGEuodla0lMEt+<fALwa4FYg1nlJt@9`S!P_1^%n<9k#9

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref.img b/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..2ac0ae5361b5d7fb66de6f9844d3456e2e998c01
GIT binary patch
literal 4096
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
F{sZU%$|C>(

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/no_inline_ref.img b/tests/fsck-tests/020-extent-ref-cases/no_inline_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..b05ae73f30edf058d2e1de700b6a1639fe4facd1
GIT binary patch
literal 4096
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
QLjQRDkAXi3{BH>S4pPdKo&W#<

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/no_skinny_ref.img b/tests/fsck-tests/020-extent-ref-cases/no_skinny_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..900b65caa180e7305999b485008030901a879cac
GIT binary patch
literal 3072
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
A#{d8T

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/shared_block_ref.img b/tests/fsck-tests/020-extent-ref-cases/shared_block_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..8d7b50f7f1e8be1013759e6f770c89beee616011
GIT binary patch
literal 23552
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
F{{Y^bc*6hy

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/shared_data_ref.img b/tests/fsck-tests/020-extent-ref-cases/shared_data_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..aa2dafa5d593dfd1a20c7e1f2d008eb53964d508
GIT binary patch
literal 5120
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
F{{$kOIF0}S

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
new file mode 100755
index 0000000..9b23319
--- /dev/null
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+source $TOP/tests/common
+
+check_prereq btrfs
+
+for img in *.img
+do
+	image=$(extract_image $img)
+	run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+		grep -q "Errors found in extent allocation tree or chunk allocation" &&
+		_fail "unexpected error occurred when checking $img"
+	rm -f "$image"
+done
-- 
2.5.5



