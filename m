Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:32845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935333AbeCHIMR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 03:12:17 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: fsck-tests: Introduce test case with
 keyed data backref with the extent offset
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
 <20180228101323.25442-3-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5e0793b2-0030-f61e-f9a8-c33e54d14045@gmx.com>
Date: Thu, 8 Mar 2018 16:12:04 +0800
MIME-Version: 1.0
In-Reply-To: <20180228101323.25442-3-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bvrqbipxpc4KUg4yktFgN1snd5nIROR1t"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bvrqbipxpc4KUg4yktFgN1snd5nIROR1t
Content-Type: multipart/mixed; boundary="t9cihb2rklurjU3ZEG8MTniXnbmKpQqzj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <5e0793b2-0030-f61e-f9a8-c33e54d14045@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: fsck-tests: Introduce test case with
 keyed data backref with the extent offset
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
 <20180228101323.25442-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180228101323.25442-3-lufq.fnst@cn.fujitsu.com>

--t9cihb2rklurjU3ZEG8MTniXnbmKpQqzj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8828=E6=97=A5 18:13, Lu Fengqi wrote:
> Add the testcase for false alert of data extent backref lost with the
> extent offset.
>=20
> The image can be reproduced by the following commands:
> ------
> dev=3D~/test.img
> mnt=3D/mnt/btrfs
>=20
> umount $mnt &> /dev/null
> fallocate -l 128M $dev
>=20
> mkfs.btrfs $dev
> mount $dev $mnt
>=20
> for i in `seq 1 10`; do
> 	xfs_io -f -c "pwrite 0 2K" $mnt/file$i
> done
>=20
> xfs_io -f -c "falloc 0 64K" $mnt/file11
>=20
> for i in `seq 1 32`; do
> 	xfs_io -f -c "reflink $mnt/file11 0 $(($i * 64))K 64K" $mnt/file11
> done
>=20
> xfs_io -f -c "reflink $mnt/file11 32K $((33 * 64))K 32K" $mnt/file11
>=20
> btrfs subvolume snapshot $mnt $mnt/snap1
>=20
> umount $mnt
> btrfs-image -c9 $dev extent_data_ref.img
> ------
>=20

The image reproducer looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu


> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  .../fsck-tests/020-extent-ref-cases/extent_data_ref.img  | Bin 0 -> 61=
44 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 tests/fsck-tests/020-extent-ref-cases/extent_data_r=
ef.img
>=20
> diff --git a/tests/fsck-tests/020-extent-ref-cases/extent_data_ref.img =
b/tests/fsck-tests/020-extent-ref-cases/extent_data_ref.img
> new file mode 100644
> index 0000000000000000000000000000000000000000..3ab2396ba9c810d98f16a5e=
fcf7fe23ee4b12ab5
> GIT binary patch
> literal 6144
> zcmeHKhgXx!wg;pLB1&(OB2^R<s&u7D4NVA02^bDdib(G@AW9MG2$7D`0)jxKgen9<
> zr3M7)NG}0thfs0@@80*$I`{nncdhGQ-`exrd*<8U?B6%D_DrmOs>hswC7R@)a*^1Q
> zo<Brzc;>ukK(t9nD9`o4x$Zyr51!+&3ungAIaVYi!m$6rv1jhq;d6iHImVvj2b5>V
> zZ~4u@ZwCGY81Nfk`ym*TMS8{0BlxQ&y0Uq6A0K)8N6Q>rPiyN%7Kg|ljJ!X25e4SR
> zqg7JI60Rvr4w?fol%`OCtCcBcV<_$g<gs->A%9RVL#wS;7f#<1L22?a92Cb2xOK=3D~
> zt<mc0CV`r-(y(HGongg27Iq<?%bg_iQ#J_HI_PsD!&b#8FS6Z%Tu4zcg`Z|1A$#WP
> zFV^=3DxLmd%@AR6^HVK$0_M@+d9l$yxTly0jkPG){PyCj(kHEDL?Wi63{q4W^0sTvy<
> zw}B)|I!j7tJIsO}mE_?C(}7{eH9eLGlP^k{#vwDU3*RUu55ql{i19j@Nl3c!7G!?o
> z8$Xaw$ds9$%}S)?NN1oaBb*~hq8=3D-U@kpAH-U%b4AcOO*Tr-}@EX}_<qa4=3Dy=3DxSj=
u
> z^;<2`mo-t>cp9_ps855F#$LaXkeFsh<lxs;gIv<k2cPyAoQ-c0)LF)=3DZNc8(O&iLm
> zl8RhE=3D7g?;eI|!_4%p?U8s)z!|A3jjVOeoVj6qh@zqW|Q3DFOk_4^}(^JW`hqTG5E
> z|Np{h)g@a>xR3J0Tq7L8mL*o3+{{h8zP1eZcPCgCjIA^nAjejfD;qQ|nts`g?xciH
> zSxzRsQ}~tghc&9j`df0KVy!nE4dZN{05%*Q5=3DfhH7U^d!v}miq*r;Z3j>~gzE;@8W
> z6;$=3D)G#k9A=3D;EiI!?T{UWC3V7yjSSRK6Abo%Piy-qi57pvzh%<VF(vIjq77>8ZyE0
> z0;(+IqPI&A6`Z}KJN*Z#XK#$}6`aVdTGyFIX`vPTET<uxmFle42QlYG;4k^fK#uSN
> ziqeECg0;LWfpFppWUYR8r82}=3DRa4^4Aa4`I_wQ^V3~zsOKSjYd0@>|;IsYQub!&uY
> zwfq$QiB<?A=3D7X@%WHJPFIr#WE_+UY_TAG~|ekGlgdrAJlhKtNB&f!-bU-2yKz|gyo
> zSgYQ}a7B`-#^gtHiE~G2<_BCHj2398EhLL&5aCwQDtGKdu)jIPHF)ORaN|ROJN46q
> zpzJrE_9u7!q~~|1SZ<Kwtfn>(`qtSwrzUre0u876v5M(qYvQN{owlvG00#}j>3Q58
> zRrn9L;w~AKI|K>y>=3DIsih~!@YzSS&9VjAeID>ihw!{Lp-KJt7ypjyx;GWJED%rm7j
> ziD!Rj>Mx}I1@ce}zXc`0IWd@m<#(Mcvio-{-6V}syKbv|5Ap*Bju=3D+1IqCewAP6|U
> zpi^s!F8{bS^|eCQMI~!KtqW<UgJ3aeN616T_8h!W5I9aP-rHn;HZLL-JQ2g;jO^Nb
> zwk-wTHJG0{@gx<bGb%ti|Kw+^9hQ-of13Tm#VPWpU=3DB#kR5vc%K^5N+XE@)shQz&Q
> z%kQetW&Z%SEbQ{yMEeWMm2TjgI_)MtQHtkxPVjLS!$R2MDwjP|r%dQOj>n(DoHEt|
> zqd2TOWRx%Gz#>Z$ZP-Yi3OTx}MSgu7qWz;ZiBo*i^m1yD^=3DB_@*B2ZsECn5aDkXlc
> z*8}y9j>h`0H0m9Pw|Npg28u^ixQhCVH7FFc^9+42`K727;7xag@5JL1F$EKnt2$f>
> z9z(^ZW(qy31tQgcDbec8_S?c&;(IK=3D6&Q11Q_pqUnXc8JH{^)tF!oPTFQ_O{pb2Y9
> z@SW{5u?WN@dh8hK6*P}3f$NqxjjF1uXDV?nIA{CO#Y=3D7;_r1O}o&B4w(EPE0jB49G
> z&>n=3D!<Gy47+nIN{xQ^?sq?sc4blCA_i7$)pCu}*TBJEjM+*IdyM+$#g^mYQSkA7eo
> zcIM2TuiFFV5rY)zV?O9!+YgQ_GrRoHP{MUwf*Cc0m6MUzqWJ?IXT$Gd?ABmppI2e#
> zcY~k;`9>@5%~3D3OZnH_cwfy~8m(J2bagn3G`$qalENf;V5<th%s+gv>T~OcAwWmv
> zHYO=3D|{o!@5KnfdjLB6Mf6i?z><!II^!|yXZbRw#;+1M+U)0MBP3*MTcb{P-rmG-s3
> zCtrm|N-M3hKgYgfZy~8>fGQIAU&dWWMi^UHi(^(}Z;`Zl@~KW%jR7FCz;JxrP??o*
> zt1gxa#S)8z$HL+6i80A^;WRNbIVJFjmr%KnBF5!q*CSqrgSEvDLVQQ34hjP-ij-P-
> zr<0E+kFI{4wGub9Xem8y9gR=3Dbu$n){U_FPjMxv94w2|+Q*KQz<uDsNh8U*$MkjRq&
> z_hanJk_l*(3z1ELQTPHQk-mZ{JwLR^V7kK1@i+I>Twk~pOK0YLW<4(*QGhOFKsvH3
> zJie6P);E>4$1Xmv=3D*fVjYj{Dr${YHb>RqpwW&-*l6=3Dt=3DT!$j?kDlW79;8c2}Yfj}=
I
> zLrgG3$S(XlaQ1SHG&O_?Pnvx{G0os!9{0(T($%_1W~P^soWkM^dU;O;ymGs>{~W%Q
> zui9?JM8$8ZI#80s6N8A9W}*^kS|fGWY*%H1GT0je(m*lSfwK;Go<~HYgc}4VGzR!!
> zl=3Dmwm`GoQO!<TsQ0_FL_+7DI4cxJE1C{x3QwHcb1lv4zn)W!H`O?WQyMqX7pSNjSk
> zDfunDC!sXc7@!Gc9V~4-@rjqt{kbY&uD?Yl<#KZocH+3*rO4*BTlcELvCDu78lCFd
> zCX3k8ZIZEW{F#%G&ba{UiyOU(tPa)RZFG4eMvUDZ8qaBMqYisfWdXb_FDm8~ox0+t
> z^W{TP)&l=3D)9on<cM}nW$^)g7*TgZPwR|VYATBK7wn^D_~4UmwJb9DXbg7*J9XYY8q
> z*Zv?bp08qbZBLn~9)(gX(uxgJ(}G<#L;?8@pzm>DO1ekx<jl8cXeQMRTnl3_bRXyf
> zaR-6^Z$c0?As?ZrGG(zwz}po*xr9NJwCDq+pt<+Ylk*$1cGECN_8++`3-IqnYI?;a
> zeSl*nh&3N$fgRj@li}IM`HO_L?2}_um`Bg*qS#Ai7!zebL24%hsma7|ZfKC#Mp>>Q
> zm0YZ@b=3D|Q4F@L_HQ)Hxe{s`JeMX<eToDwk<^cj6%(GE?xv$56gf0zAda@P|>+;Qg*
> zZJ}GJfj_uTDhn!A<PS4OJWjB##t2BX`*`o$!=3D{_iq@2ZV1N1kYmdU=3DUl07ILFXLb4
> zbOvWOimn{{PSWs55ob1O;lcy~V7A8sQKA*O1}P7Eq?lBSbS!R-j*ur7f6}4n%_O0x
> ztzs)+U~IFE_lu`dX@`>zJ?8**@hC9GN77IWl9AFNi^(Nz)C#u3c%IYy`Ye9gJVq(X
> z7p6EJhHx!E4kaAo*1xUqk|+*sRg@mk#xq)n)-)flPrClVW$x+!d^&lnpdRZGGU?FS
> zjNQh6nEi@Muxi}FUFixI-#B@WhIXGW>tjn-y{7AiA3`+N3wfbWyCHwe>0jo(gu3Fr
> zpyb<q<^;FOiGzmImWl3i6DUwmEUqiAlBu+9<;J4WO71CYPorS*k-j)v8vDB6$MSA~
> z3z$+>0)AQIC9N10u;<afL#1&BoI>2se<gci@lh$Q3BoyO2*A{v+q{T@F3z;u(o2Ta
> z?uE%ZCbw<Q4z-9;S=3DenIR{aPOrz*33ipfw~`qIY0j=3D24}!I91$?9;-(bG%<Bui_#G
> zd_+acPQEd7q;=3DgO+O3hc-Dj(gb~rp#ozmaO00=3DL>X57s)O;?eu9DeOs&QM`TMgF@e
> z+{))YEFaq=3D)c2`XZ4JEpSz<eZ`Wb!iMTCVBAc0eT`e*X5UK68vlbbCrQqoUqiN*zW
> zGbC9xwpzRla<9%w_=3D7oxZP^$cX`(z<S~Bd!oPv~2Ge<^LV>3@p%3is6zwLHnPD1K2
> znIToGv8NeWky{p%3?Iy+?8*ku4Q91+6Z)~$s`prt>lTVkb>?|Oy`Igpx6CKrKW*~V
> zV1K<-f2a2&b9|zoQX{f&z5{61<Wq6zzS%P`VAW-IL_Bp>=3D+ch@-ZnHYg1nQtgtx`*
> z>4<mz2kjNIV2JNmnEGk8Z!U*EcW}*Qm01UXc&-2Lnf^r<Y)9<tNtn3P-<u&ztZkaq
> z4U3@p24^~>y@f;@sfvVb7hjhVP&Dy$bAxmgAUNfEcPKDKt14a0lUO8Q%@N-gA&!<H
> zEJ<8wii6BEr@O37H(e7y)>l*_yoe#I|8*P6ARScVV3wHEXzx-ppZN-6l$`$I=3DZNOF
> zr0rRR05%UH0BJ)Aq=3Dq8|=3D8t7{=3D9&=3D#*;ZCpTou;iqIcRl=3D(o1U{bh!^^w_Ro=
20F%O
> zW@Q5W84H1=3D3k#%%b(T@J*IFt=3DD|<ukvRW=3D4DS0;SV(qr~yWUo#)UBrQ1oIO-L18;=
6
> zz|QKDsSH$zQ#~1Yl7Q6%*(Wg<6J7v~@0vVB&<1d>w2s-#k{__F4XgHnDetS}sTkjw
> z{yEPPxKR}p=3Dj&Xab)~p(&BABXuLGcvPW#LOptjWJn}Fg{5P?6eWtMT{t6hPoZazvK
> z$2Dj>`x0uV-So;v=3Dk{6twPpUV9VM%OsUq4}Kd~SK6%h8#-Omk7cSb7$$10)$clOo*
> zs_IS@<IFOd)SgIP(+zL6&3kjN0@JhZzu9-h8=3DLKwd|0y&IoPOi#j>*eY&q>XvGU~`
> zRNkCm4R&m=3D)mt}5YucjqzDCRM2pVtLoMduA>yg{veA8;z<=3DGXpXU50wkLpp4>hb;2
> zS!n(_%ikW)ZT8Xebnw|btf_c<x&2E1{KQleWb)&?APL7OXohK8xnTFT8OQaLwWu=3Du
> zWgeUF@8&{J#2LQ@Sk!neiZj~V2SaQpvu+NIyzUq=3Dda@^#Km7~n<v)TaM56WxPM<^F
> z);hw6b2za+i@3*bmkZ&dIh&!6cXDM}1A{YYV<hS{tr(I1gR8dvccmIIOElRKWhAr9
> zgFq!AcG^1g647#Wsi*lhFE_)|x?<+GB5DywcPfnWtE+83%xuvUZJD+pk@-rptl`7G
> z!twTO7deZGHFD&pXqQ~Vz~a>P#r2Addf4Jg<~Akb9rE8Lj37{ZY*4W~vEB!nVWglp
> zySnP7ENL39eOyl?7ji47*q8z~CL%0HZWoS+_FZF<iQUUOsW9nKTY5DCa^9<j%Bpdx
> zTOY;KAmm3<<PNWHs}v`RnsJVy?6+#UDZOBBP#I0u{eh^?hAla$<8phJ_iTIvsQl87
> z7fh3tg=3Dl-h5^sMQjZ%hw*Js@yjSBXjC4sVGqv)XzOD|EawsU&r>9clu<yo_`thO^i
> a{m_i3m!>iDz<<x=3Dx92wlzZv+iVBjBP`o6jV
>=20
> literal 0
> HcmV?d00001
>=20


--t9cihb2rklurjU3ZEG8MTniXnbmKpQqzj--

--bvrqbipxpc4KUg4yktFgN1snd5nIROR1t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqg8FQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi3dQf8DOfdDDC7nW9TpQHZtkzl+X8G
Nij9AB7GuD4cD1k8cBv2xcizeh13wgBaf0an2qwma4sSbf4K2pSxlJWymvpkZavm
5SqO6DCQg1k2nFFLhawgMx0r78jo96PDR+gSHkOSDgSsv7DmZUU94LOa68U+5A7R
5OZ38ixxFE8LOKHZurlYMTO55/4kz4Wx1qqKjssyG/IGp23zh4PKo3AfVqdAS4SE
lLTEK+3gsnmpmusp6ciBTxIrzM4bITVJK6NFnDPFCFMOx4ZtJaw0X8+SuHAvSXTH
SXXHNC5ITujcztsp4uAdP+rzXydQlU+H3ypgIdU9BnOg0+4UKY20tsceH6+BrQ==
=F2Ai
-----END PGP SIGNATURE-----

--bvrqbipxpc4KUg4yktFgN1snd5nIROR1t--
