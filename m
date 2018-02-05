Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44812 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeBEGre (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 5 Feb 2018 01:47:34 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 2/4] btrfs-progs: fsck-tests: Add test case with valid orphan inode
Date: Mon,  5 Feb 2018 14:47:12 +0800
Message-Id: <20180205064714.15659-2-wqu@suse.com>
In-Reply-To: <20180205064714.15659-1-wqu@suse.com>
References: <20180205064714.15659-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for false alerts in lowmem mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../029-valid-orphan-item/orphan_inode.img.xz         | Bin 0 -> 1620 bytes
 tests/fsck-tests/029-valid-orphan-item/test.sh        |  18 ++++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 tests/fsck-tests/029-valid-orphan-item/orphan_inode.img.xz
 create mode 100755 tests/fsck-tests/029-valid-orphan-item/test.sh

diff --git a/tests/fsck-tests/029-valid-orphan-item/orphan_inode.img.xz b/tests/fsck-tests/029-valid-orphan-item/orphan_inode.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..26e4cf8a370f64fef0701fbbcb6d4d2a824f9e4b
GIT binary patch
literal 1620
zcmV-a2CMn~H+ooF000E$*0e?f03iV!0000G&sfah3;zZYT>wRyj;C3^v%$$4d1oRm
zhA1@4B?lQ}ZjK|GB5rDiq)X8b>ZOMF(pIJ`e|vi*K%5GJEdbxw%w4{`w=*7x!{Zx&
zf94;C)yE>0ectd-izF^o+QKUyVcDXHyjDokI<yS9O~#BLG}6sYFa`^|`_9HQLy}<l
zG|denofJgm0d__2-~>E6==$WEBwGaD1>f*X1)+N;g;-9-h^!en*tL>*E>JyYjT;_a
zRL1tPs<#&9#JZk=5g0t@o}!VvF>OdhVx;%ZO`4$`fbvaDGP!Z?0=ne@)T#Yl3W9Y=
zLPlWO>2gb5LN~0=<M1ajUyiGZCeI7ZzyVyZ_WW_@$1=vyjt(-j64n!(jsNMsY^?2U
z&O{S>VQZXB#gS`s?+3|h6=bR#w&#dbJ};FpBB*0C3VyZW#lK3{IoEthgRcd<!cf-<
z{sdeY=cZH9{!qosZbe(of3B>`zxhq2WDmJ|opH-ZI5R?cts5){kr)YUDj0qdmLO$!
z_o0iA+`UkH{QW%&QI=0);atfK7Q`j_))k;6hlJ64BOFPe(tGPM)m>21pVz5^e0|w+
z!u`|oUOUX8U}RgsC&hapFC|{(EZojm9N?+{z~_hRh_ZKAP6YnOj5r+n^Tz;w-A>Dr
zcX1=XeY4i1ER>@pv5}hOh1+}LNJwNjpVs&l%GYBf(~*OH^`-~|O?SS7Aw<9qpY{hA
z+~ZqpUS$Sk+YTgoWk<5c00tjELb97WKrEFGU_B;91_XbPP+Q&7O&ppORb!WjN_pE}
zr=o)zt_G=8DX=&*C~Xhn_!zNUe%!4Pn@_7h7Te@b3gl>*q>4LsCx2Z}Vd%fN{9g!F
zx5#4mOee-h?0uwTW+OLO+4lQMRoN9}eV*I$m>pyYNekh}Maa9bn$k5=mH~NOh9iF`
z7SY+|qTlftD35c*d;UJsf{n*>00Ri`wnb~7mbj`&V}89(xk6%d|5@Hyn!PbQvdBCv
z1cKB~3nh!PpK&WWQMURJjJ*R6@wmsbtr1uN4=?VCt(lap7XPQr1)veS8jxnLSD*Gz
zd>^^;mXRRQdz}j?P+aFxTN_R6ggM-t_Or?QdjJ`bdWJ#9t1GhW?beC;2E}?P!AZ!{
znr3^Y4~6~y%XvF8ybxyu2mB1u-Y~FU{;O`4fRN<F1Lxd=8HYG3=wId;^fTn}jjY>E
znksVmHOFJHLtiqVZkr^8qb_dhgU$e{sx}a2E&N%V=?-0sKnyaTd(Kur1$5R5Cbh#8
zD=PLxrx>c@;D$?~ESDg2^EmTK^D)OzurqvBn#J5>*Yd(?mdY5iPpR|dNBBJATYv;g
zr;G1w@Uq0;;2EF!8jld%Oy}jCY0)vQ1zPUYJ#z0bN@&3l3ek?cc3ug5EGYasOUZvK
zT#qaeF?*@dx%_JzTadb^v@R314=Jnp)ZF@MOrlMn?r9?C{nNPU(d|dO)n8SSf)tvN
zT7YK(4w*@eyGOb6Ab*VwKtquOqWdRL@Fcb2p?w%OfeQjM{)XrAyXc<ft6TB|bwb&G
zJ|3wz?RW^`#4-E?j}%t95!e!gM8GLuDwI+7ac@RVsha6(p|YRI_k4ETMa}l|-=9i&
zZjMB!FR4qvJs>DYKuCDIERNN4>wAizy<SP$5uERbrn>|SRL_f2Lx8d3htRSYcDv&K
zGwkrdJu#f`W_(ry93NFOWeK@peO}+S1nVfF(C@xNzu`t3Z$MiW@|zYN`6h3Q=_5^8
z9k2p$?KT#(yI9fwF%5IPKYV0OfPn@dnCrP;zoSLH?a4XkVpsi8zAp<zp@ZCzpXSTR
z`A;nIWRz-2O$f(Rs5hv|sX@U@vIkY+S4b~HPJ<I6OrFu9bK7mlupm)mZ_QT`qi^DW
zIMwR?Y7D9%AW4GBOT6Pq?X`8{rujMBAVek&RF9#c$IsZki6ULfJTWgMS+Sy-3{gBS
zm^6GN>v%i_K<FwQDVEmt4}#W%H3U^%Ncd5Zq_kDyu_nFb{iD9l&KQP>Bz5sBH|gQ@
zA!*jNP%s{9V`c3<JOxPxHczQ^=3`yO8rzT1GXVeq0000YrsSaXHn5xk0j&&x7ytkt
Se@k4k#Ao{g000001X)^tvJ;K~

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/029-valid-orphan-item/test.sh b/tests/fsck-tests/029-valid-orphan-item/test.sh
new file mode 100755
index 000000000000..997eb70e671c
--- /dev/null
+++ b/tests/fsck-tests/029-valid-orphan-item/test.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+# To check if btrfs check can handle valid orphan items without problem
+# Orphan item is a marker used to delete inode/root.
+# Orphan inode/root will has no referencer to it, and will have an orphan item,
+# which should not be reported as error.
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+
+check_image() {
+	local image
+
+	image=$1
+	run_check "$TOP/btrfs" check "$image"
+}
+
+check_all_images
-- 
2.16.1

