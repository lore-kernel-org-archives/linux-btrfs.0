Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20095 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1167837AbcKAICR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 04:02:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: misc-test: Add send stream dump test
Date: Tue,  1 Nov 2016 16:01:47 +0800
Message-Id: <20161101080147.13163-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* PLEASE DON'T MERGE THIS PATCH*

With 2 send stream which contains all operations for user to check the
output.

This is just used for checking output format and find any possible
deflects or ugly layout.

It doesn't really checks any thing and doesn't follow normal test output
redirection.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../016-send-dump-output/creation.stream.xz        | Bin 0 -> 984 bytes
 .../016-send-dump-output/deletion.stream.xz        | Bin 0 -> 408 bytes
 tests/misc-tests/016-send-dump-output/test.sh      |  23 +++++++++++++++++++++
 3 files changed, 23 insertions(+)
 create mode 100644 tests/misc-tests/016-send-dump-output/creation.stream.xz
 create mode 100644 tests/misc-tests/016-send-dump-output/deletion.stream.xz
 create mode 100755 tests/misc-tests/016-send-dump-output/test.sh

diff --git a/tests/misc-tests/016-send-dump-output/creation.stream.xz b/tests/misc-tests/016-send-dump-output/creation.stream.xz
new file mode 100644
index 0000000000000000000000000000000000000000..521c5d97170e7ad41ac8b3305461df09e2cb4c86
GIT binary patch
literal 984
zcmV;}11J3bH+ooF000E$*0e?f03iVu0001VFXf})8bkw?T>vp13XGw}P}F=IbdLR(
z>U`@9XCIGr1@6OEPWlaQgT5hCS#G{B*Zx$SeQxx(I;AlUUp>USnJ^DpJDxOMlV57u
zelh2}f67+r{m^CB^YzYr3tjQ|k)GN6FCPlJzZl~%dVK~u^utMa*9rwMg9+N$g{SND
zcZ-NRsrbN=(OpirB^JtZ_@@|0ko&m=lrZK&kwT4$K~N%4wfsccFuJN7=oxM?(C{$t
zrJ3+}UkQ}_E*UQZWqzP7z377g)WK7w_xN6@JI=Ju(YvI$Mt_bx^7=ASE}(b8_B}4i
zasV`w=9w+*M6KB1PI0epqZRs16o(yJ_TJRHtLJs)H=r2l{lUm#HgtEO+R509mJ9Dp
zH53E2E>5wavINe=AaNq|VGT6MOCuv!R7O%jU@r%Yrdpfo?l6$2s-G=tmJ&#ZJK-XI
zc3_*HY85LsZo<$!ckHazSUr=utE9f?X_~CA>t03#bx~F<mvHfn1i6m>T8lXi$?P|(
zyUn-J`1NVoq>_vLA+8)in6aeaTk1B53fFNk)2uRv5OTLy;afVi?wl>cMS@Y<e`g+$
z)FDH?VwD`thACCobJJ`9&&4{|D;D*QKv^^C62Df^&_92eS=-x!-ep`F>{dRkH;AHw
zS^qftW|-zRq~4aB8Kg{kG*5vYWv*suPO<y5Q^;aW!(Yj=Hu&r#^TMCoPGHD*H)E^i
zM1Rfahee#ZtD&<OX=NhM5bA>OIx5<3%t>J~EcplJGDQ@?EpA?a!WZ^tuQB7Lid{7l
zWLuhRJZ3uiQ(-7c!+d4j2#bJ4GD4P%lv6G(cG-A7%R}d<d3ww6(SZAaI{&z*os!5`
z_dICt&b0qrjTKF#JwD6cZxb5#i<C&PRelC?HsCnm(QSt7J?u9h=3PGA%pOjpB?w&m
zaWP2tKuRNZWk^fRs(@XTvMM?`@u;I#xyaK6QpF_?HT5vCyi{f#&&QWKka&xKVzAKy
zKIczYjr<qtBza6d>${N+_2>{&W|9ejC}b5lc$A}M$5<VKgm@@_Ms(wEq2fml0muq*
zs@|Fzh`C>e(E4qn&EfR`1?U4<n!5gnJBcB8j<A2|T4yd*VW?{Qmirh113jpbc=_Xg
zBjrV$8hCJ}zK}x2`ldZ%Z&cdv6XkVg+P=RSz*ul-9_l=EEEw$=eR#*j$0g`BC+Byr
zV1;8DLJMNr19q7I^jAH0qrkub0002<S#w0x6j%%Z0kH?gGyni)n-apY#Ao{g00000
G1X)@v?&B%|

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/016-send-dump-output/deletion.stream.xz b/tests/misc-tests/016-send-dump-output/deletion.stream.xz
new file mode 100644
index 0000000000000000000000000000000000000000..d04c0bbbdf1b5c8631d565ddd5ab88b654b9ad35
GIT binary patch
literal 408
zcmV;J0cZaGH+ooF000E$*0e?f03iVu0001VFXf})0+|6<T>vp13XGw}P}F=IbdLR(
z>U`@R#K~!;K6&PD9_8<Tm+X$wWFUg4g!Xb}hz}pqVOA+vFBLg$tLtyfgcU7SwZ;gJ
z#Vn}s)6N#00Av};DKO;W8$cbQ0S$_{rCv;a7e?J%*LA!l(#pIaz5ggmmk(u=u?v<d
z$-GvlqyAkeq#3pnOVEEL){E#%a2@LW4#}&`9iG!ttJW!X-6IzWiPh|Y;1dM^qOz!F
z^?Ep*e~M7yrqGBuY$?9-q*hE8{iK~2BgU;feTX`4io}b)o<$54{}3kuOQ}vn))YSD
zYnkhIV4U0N?b(W=l%Cb@_Mq`In_D@IYAq&~lA-m@Ys&NfwGkG|Fe7|n_=a1edxrHf
zFRd2#+}@y_1&v360k(wP?bAH#Ss8U`2+^E%>7`}Ysb&w5Tjy)cDTA~&eSS_FzE%Qx
z1=H-qw6D#$620}uFzMY^0002pjh8@1RLQ^q0rLWy1pojcFQxvm#Ao{g000001X)_e
CV8dwu

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/016-send-dump-output/test.sh b/tests/misc-tests/016-send-dump-output/test.sh
new file mode 100755
index 0000000..cc8586c
--- /dev/null
+++ b/tests/misc-tests/016-send-dump-output/test.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+#
+# output receive --dump output for further tunning
+
+source $TOP/tests/common
+
+check_prereq btrfs
+
+# send streams are in *.stream.xz format, can't reuse check_all_images()
+
+rm *.stream -f
+
+for image in $(find . -iname '*.stream.xz'); do
+	xz --decompress --keep "$image" || \
+		_fail "failed to decompress $image" >&2
+	image=${image%%.xz}
+
+	echo "###### $image: ######"
+	# We call btrfs directly to output result without redirection
+	$TOP/btrfs receive --dump -f $image || \
+		_fail "failed to exam send stream"
+	rm -f $image
+done
-- 
2.10.1



