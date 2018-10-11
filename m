Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C616FC4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC612075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EC612075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbeJKWbt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:50072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728122AbeJKWbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FE26B0C4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/8] btrfs-progs: tests: Add tests for changing fsid feature
Date:   Thu, 11 Oct 2018 18:04:01 +0300
Message-Id: <1539270244-27076-6-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a bunch of tests exercising the new btrfstune functionality. In
particular check that various restrictions are implemented correctly,
test that btrfs-image works as expected and also test the output of
btrfs inspect-internal dump-super is correct.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/misc-tests/033-metadata-uuid/disk1.raw.xz | Bin 0 -> 78336 bytes
 tests/misc-tests/033-metadata-uuid/disk2.raw.xz | Bin 0 -> 77664 bytes
 tests/misc-tests/033-metadata-uuid/disk3.raw.xz | Bin 0 -> 78328 bytes
 tests/misc-tests/033-metadata-uuid/disk4.raw.xz | Bin 0 -> 77592 bytes
 tests/misc-tests/033-metadata-uuid/disk5.raw.xz | Bin 0 -> 78348 bytes
 tests/misc-tests/033-metadata-uuid/disk6.raw.xz | Bin 0 -> 77552 bytes
 tests/misc-tests/033-metadata-uuid/test.sh      | 225 ++++++++++++++++++++++++
 7 files changed, 225 insertions(+)
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk1.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk2.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk3.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk4.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk5.raw.xz
 create mode 100644 tests/misc-tests/033-metadata-uuid/disk6.raw.xz
 create mode 100755 tests/misc-tests/033-metadata-uuid/test.sh

diff --git a/tests/misc-tests/033-metadata-uuid/disk1.raw.xz b/tests/misc-tests/033-metadata-uuid/disk1.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..24f47d2b07553b394f273df8794f503935ab658e
GIT binary patch
literal 78336
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%0A8uywI1{4Mg`;H20L{fi5
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
IM~}1kH-Kd|J^%m!

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/disk2.raw.xz b/tests/misc-tests/033-metadata-uuid/disk2.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..a1c80371b47080d435010a1de07c4a0c4f67a35b
GIT binary patch
literal 77664
zcmeI*c{tVi9tZFvdmKxWEfU#FLW6W{WlK~?8;+$jMP$obt`jAuP$5NGVr0pZp&_zF
zQzM-up(GR;J0p~xd*|L~?(^JP?o%`A@yFZW9_R5r-{0r+ef_@g-}g7G=C|LHKw#>6
z{=LBx!fJ+<1OkDlcK_q~c{avn)&zpv?EHMn?Ri5jBYqE!1G|c%WV=#ASSN=%#ZJ|)
zf3RsYgGt_r>d;Wr^(n-c0cmf;C3(%?SO`Aw4(;%rD2xu^bgF3cGCoL2q+T+~a9c;W
zGH4oDdyy^IY9Nc^wC}ZsNLDnT-B?}M9qSOs>v2bVs;<aUY=s#%x6K=My1KIIx!y}C
z_58WHo~7lyzyGl{h5a}EOO`t*iB%`tIkm<s_fivHA5!E~N*bX}|J<N&#-3eWCE%>3
zp`Ndo@sHNi3FL{6)T6>o<^;*9l$8Q(5h7dD@3ROMud_~)BN~>@J$HL59{#wrrPyaU
z^R(Zg@$wu6fosDOO}DS8ZfWmxNKCD{Rop**HBPzWj7C;;UC}o_t7xvGq{u6(&W!p(
zd_kcJgBOz<U7{M!H`}+H^^vX^uTZ!&X*gxpP40+d*(;Q|HL>Gar@@Ea!)LtLD!sb5
zb9baf3=5-ewY%o>3T3s}RDOoko)mWZfy{YJ>1+?q6;bKs8W+~IyC<eg+78IlgX=EE
zhMtg*9FZ(vH}w3_Ph_i;DhjF0E_`M6OA5zcBsdT4lvbCcpXG1&Z#26syi0blx<^oT
z3o%#8Iosr(wZ2in3W+msGs|Ae@mQ&8RtU+HGqpD<DmU(O;I%uKaVI__*XyBedoG8L
z-iPP8`5cXRV=5@}B~|1*M}p*xH}Riqa6UO<^Ri4oHvLxRx1j@PL&F0K5=SaIh_#nq
z1mvsc?}!*VT%dKm=eRG2gy!@EQ>l_#&)9w6NjACL)Z0WF=vtLMDtlF-Jamwgvo2_W
znxvT6J<rtbm+5rbsnzYci1{SX*0+ztJV;esQ%kZ0ybU=WPZ-;jyD`ap`#w@&;8e$$
zdi}f8V})hhABuPrn$?w`1vy$=-@eLlelCakK#lf(rKB!8#Z;tWpQlS&`@^~8s|zwz
zE>KU?EO$|(yo@RLUGk&4lO8@{Wg5EHma0cTqfH@Pcxsj_EgOAw73q)0S;l)@sDdTd
zG<LQrw=shIzLfdI`^c|0FsFVu<W}jvou2ez{MtMZg92f|(>#5){HFf~;cK_gZE*eF
z7xw@Ekf|YOT_kU2j-BY8CwVf06pN5vd-DGBUY~4>&Y!H9*(R%+b7rQ=3SKp0R^ob-
zt>&Z&xr6MQfpmH2*9Drx_sbM*Gr6@)?DZn}xaN5-P8>aEF~LzYe@WJW`^Joa+w@f>
z#l005f=7c+Rvh}x|L|o$dKb5LJ_hU)zAFsaCr<AF3|JA9?V`LSP1tVfY+J?lwo5j6
z3$am<X5;Ntlzez7&~wk0hG&$)f$n0yP7aS1>zm{o_>xU|lw?-)XRQ|u3E_ICLJtWk
z%)TjGClFtn`|6><Ew(1kh`@le{<<8@q}x%QEGN`h^AgSSE7E`Bvl-o{%Iode{OGpy
zjuPjFt1?p8r^Z>y(F{*$X=S34Y+~1a*&@XZA8^bmip^!I8=Sf!%(dUei0tP~?eO$A
zDegVUt&#Im@i0v?Zf|2>Fga!?z0HkHJI&H>;%=fy#n6n}yPm|D^qR{|!ddD318;P1
z7%jUT%{)a;dMEE?=}C7!K2%9b|AFS4A0EaWMD9J;x}=1Cz<b)N>&81f;(LRhv%c@E
z^pDAOgxC9ybnH>h_6d!*V|F<3{h<1*$<2kTq>etB=5I1`itJ>c9+4Y5C)#eaiDHyc
z)VW4njC65{Iz4za=G6GS)1Vd6`jn+pXx&yZeYLTfjw;!WVJp(+#3PeryjzSDDVyU5
zb2YTW<~mzanq1S4AE63VgeM&6imUO?8)Y&PC6e;leN?^EJB?`kjo#jmSeu8roeg;@
zj%F-D8>J30+1mMM?qa2hX{?rV@G~@C`8LG$2MH@NoxLtv+f@95ml7R?IMZKmnC>X%
z^JLVgN|pB>+}2#PKaA+}qk}cApkv^u$Ud<w>eo?iJiHtMOnq;N=e;s_yScg36eTP(
z<G+qh6HX#+v7T97p?y;9NC+1X+o`&lIfs$ycMd5GRMU&IAF}!es|B2@`D+9+YUS2G
z3J8DtCVtxa^?L8kDP9(Vl)G^aGX@149uw(;Czp<%*A*0wbq|gR+)QiN8%fyXA>N%$
zn7kL=qD~#{&1-%!qu@(>?9s7QNPUe*H`BAdjRo7OzWoYEpC0p6;Yf(F+@ibe;XfM9
zs6{l7_S(onf`ols?X$kstRA|$@=7t>cen^YZs^vuA=!r}hessa?6&ibeK0j(GATY{
zQ=0BrE8vhcwq|KbKZ~s$d)Ny%g)>3VrEMpSe{5l#ty<1&qb^FXx%^n>(aMsD2(BB6
z9_)guS>tkfcOCp|3EG3N%IirX(%bD{$F&d+2jA<nZ7nn$w%=)UwQ{?44o!#g?mF8E
zi-w_Py?%^l514ld7mT}I(d|@D+4z-KbFk*Cyl!d9j0u*om+u3f6GgOXzF9%bSG(3V
z`i*KWH>ZC7F1o`-_YT?^+StOa(a`t*Qs2i?{G%0s8HO3Qu+GE`!wka=!~GZBu&Q+b
zvbWj(=Pu=!{b&?@6nzwZ6nzwZ6n*T2{n-{Ax+J<Jx+J<Jx+J<Jx+J>fXG->9S%GB*
zmKBR|Sy9ZOL+G#4?h;5N><rz0NzeWC`QoqDSYoQ{5;uh>PwxvNiSVm@>)&YIAEL)c
za!A@bp|;MhwcjKEbA&}dE_+A~HC}n>%6Ss&VvHSDt2{Z2zy$&q2wWh_i|jMP;=g$u
z;^R6T()Is+egp&d?<XPPC3p#5T7+IgjuSb~g>op0K8ikyK8il}-mv$Ey*KQ=VejqN
z^9+y_#^DJ#ZQ}Rme0<sK0^$8n^a%zG1GccBTLd#~?P563M5iQERJU|g<f(_w!tKQV
z-NBY>@<~Nj09k>Bo1wUa_=yeY*8y7;MeL*RtpD9Y^jD5(8{?$!`Mzme@VjG|#Zbgh
z#8AW#ctYR_fhPo>{^%srU)L2lfAu4ee#L<O#g!{&7-rb#KS%PH)0lBd;*wn0yO)?@
zm|>V<2s|P1guoL5PY66A@Pxn<-WG$`>-_nPjSzUk3!MJ=-BGY4ED1}(lCUH!2}{C~
zup}%AOTv<{BsOwC^*zL}BrFL_!jiBgED1}(lCUH!2}{C~up}%AOHx21&<HdFjX)#N
z2s8qXKqJryGy;u4BhcsuXapL8MxYUB1R8-xpb=;U8i7Wj5oiP&iGxO<5oiP&fkvPa
zXapL8MxYUB1R8-xpphGB1R8-xpb=;U8i7Wj5oiP&fkvPaXapLa1C2l<&<HdFjX)#N
z2s8qXKqJryGy;u4qZ-f%Gy;u4BhUym0*yc;&<HdFjX)#N2s9#tMxYUB1R8-xpb=;U
z8i7Wj5oiP&fkvRwSD+DS1R8-xpb=;U8i7Wj5oiP&fkvPaXp{*WfkvPaXapL8MxYUB
z1R8-xpb=;U8i7V+&<HdFjX)#N2s8qXKqJryGy;u4BhUym5(14tBhUym0*yc;&<HdF
zjX)#N2s8qXK%@Jh5oiP&fkvPaXapL8MxT>Lfjuh;M8bfldHQVmO@F=|`DL7hfBlpS
mZ5-Agt1Kok6tpn~1_n+s5D2xa$ok6#G?f^C`2{8m%YOoASkx{6

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/disk3.raw.xz b/tests/misc-tests/033-metadata-uuid/disk3.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..25e9be696fef1d3ae590185a85de9ed9a2a7d012
GIT binary patch
literal 78328
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
V!L^m|K}{zkg!@1L0Z&)&zW~lEG_wEz

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/disk4.raw.xz b/tests/misc-tests/033-metadata-uuid/disk4.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..f591cfec6f3fe93c6a2170cb6f5edc2d8dd3cdff
GIT binary patch
literal 77592
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
OrZ|@P_dgzElYasEi@X&8

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/disk5.raw.xz b/tests/misc-tests/033-metadata-uuid/disk5.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..e9095b78877555a7e2364ebb7bf4237c4796c071
GIT binary patch
literal 78348
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
INUd%D0mmL8ng9R*

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/disk6.raw.xz b/tests/misc-tests/033-metadata-uuid/disk6.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..9926ae494f53cbacd94b8bc61a3440b38f1c0ac0
GIT binary patch
literal 77552
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
Pl+f4UA^hVr+1BnaD{80U

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/033-metadata-uuid/test.sh b/tests/misc-tests/033-metadata-uuid/test.sh
new file mode 100755
index 000000000000..0ab432938b97
--- /dev/null
+++ b/tests/misc-tests/033-metadata-uuid/test.sh
@@ -0,0 +1,225 @@
+#!/bin/bash
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_prereq btrfstune
+check_prereq btrfs-image
+
+setup_root_helper
+
+prepare_test_dev
+
+function read_fsid {
+	local dev="$1"
+	echo $(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal \
+		dump-super "$dev" | awk '/fsid/ {print $2}' | head -n 1)
+}
+
+function read_metadata_uuid {
+	local dev="$1"
+	echo $(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal \
+		dump-super "$dev" | awk '/metadata_uuid/ {print $2}')
+}
+
+function check_btrfstune {
+	local fsid
+	echo "Checking btrfstune logic" >> "$RESULTS"
+	#Test with random uuid
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+
+	#check that specific uuid can set
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M d88c8333-a652-4476-b225-2e9284eb59f1 "$TEST_DEV"
+
+	#test that having seed on already changed device doesn't work 
+	run_mustfail "Managed to set seed on metadata uuid fs" \
+		$SUDO_HELPER "$TOP/btrfstune" -S 1 "$TEST_DEV"
+
+	#test that setting both seed and -m|M is forbidden 
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_mustfail "Succeeded setting seed and changing fs uuid" \
+		$SUDO_HELPER "$TOP/btrfstune" -S 1 -m "$TEST_DEV"
+
+	#test that having -m|-M on seed device is forbidden
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -S 1 "$TEST_DEV" 
+	run_mustfail "Succeded changing fsid on a seed device" $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+
+	#test that using -U|-u on an fs with METADATA_UUID flag is forbidden
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+	run_mustfail "Succeeded triggering FSID rewrite while METADATA_UUID is active" \
+		$SUDO_HELPER "$TOP/btrfstune" -u  "$TEST_DEV"
+
+}
+
+function check_dump_super_output {
+	local fsid
+	local metadata_uuid
+	local dev_item_match
+	local old_metadata_uuid
+
+	echo "Checking dump-super output" >> "$RESULTS"
+	#Assert that metadata/fsid match on non-changed fs
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	[ "$fsid" = "$metadata_uuid" ] || _fail "fsid ("$fsid") doesn't match metadata_uuid ("$metadata_uuid")"
+
+	dev_item_match=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | awk '/dev_item.fsid/ {print $3}')
+
+	[ $dev_item_match = "[match]" ] || _fail "dev_item.fsid doesn't match on non-metadata uuid fs"
+
+
+	echo "Checking output after fsid change" >> "$RESULTS"
+	#change metadatauuid and ensure everything in the output is still correct 
+	old_metadata_uuid=$metadata_uuid
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M d88c8333-a652-4476-b225-2e9284eb59f1 "$TEST_DEV"
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	dev_item_match=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" \
+		inspect-internal dump-super "$TEST_DEV" | awk '/dev_item.fsid/ {print $3}')                         
+		                                                                                
+    [ "$dev_item_match" = "[match]" ] || _fail "dev_item.fsid doesn't match on metadata uuid fs"
+	[ "$fsid" = "d88c8333-a652-4476-b225-2e9284eb59f1" ] || _fail "btrfstune metadata UUID change failed"
+	[ "$old_metadata_uuid" = "$metadata_uuid" ] || _fail "Metadata uuid change unexpectedly"
+
+	echo "Checking for incompat textual representation" >> "$RESULTS"
+	#check for textual output of the new incompat feature
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | grep -q METADATA_UUID
+	[ $? -eq 0 ] || _fail "Didn't find textual representation of METADATA_UUID feature"
+
+	echo "Checking setting fsid back to original" >> "$RESULTS"
+	#ensure that  setting the fsid back to the original works
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M "$old_metadata_uuid" "$TEST_DEV"
+
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+
+	[ "$fsid" = "$metadata_uuid" ] || _fail "FSID and METADATA_UUID don't match"
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | grep -q METADATA_UUID
+	[ $? -eq 1 ] || _fail "METADATA_UUID feature still shown as enabled"
+}
+
+function check_image_restore {
+	local metadata_uuid
+	local fsid
+	local fsid_restored
+	local metadata_uuid_restored
+
+	echo "TESTING btrfs-image restore" >> "$RESULTS"
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	run_mayfail $SUDO_HELPER "$TOP/btrfs-image" "$TEST_DEV" /tmp/test-img.dump
+	# erase the fs by creating a new one, wipefs is not sufficient as it just 
+	# deletes the fs magic string
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfs-image" -r /tmp/test-img.dump "$TEST_DEV"
+	fsid_restored=$(read_fsid "$TEST_DEV")
+	metadata_uuid_restored=$(read_metadata_uuid "$TEST_DEV")
+
+	[ "$fsid" = "$fsid_restored" ] || _fail "FSID don't match after restore"
+	[ "$metadata_uuid" = "$metadata_uuid_restored" ] || _fail "metadata uuids don't match after restore"
+}
+
+function check_inprogress_flag {
+
+	# check the flag is indeed cleared
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		$1 | grep -q 0x1000000001
+	[ $? -eq 1 ] || _fail "Found BTRFS_SUPER_FLAG_CHANGING_FSID_V2 set for $1"
+
+	run_check_stdout $SUDO_HELPER $TOP/btrfs inspect-internal dump-super \
+		$2 | grep -q 0x1000000001
+	[ $? -eq 1 ] || _fail "Found BTRFS_SUPER_FLAG_CHANGING_FSID_V2 set for $2"
+}
+
+function check_completed {
+
+	# check that metadata uuid is indeed completed
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		$1 | grep -q METADATA_UUID
+	[ $? -eq 0 ] || _fail "METADATA_UUID not set on $1"
+
+	run_check_stdout $SUDO_HELPER $TOP/btrfs inspect-internal dump-super \
+		$2 | grep -q METADATA_UUID
+	[ $? -eq 0 ] || _fail "METADATA_UUID not set on $2"
+}
+
+function check_multi_fsid_change {
+	check_inprogress_flag $1 $2
+	check_completed $1 $2
+}
+
+function failure_recovery {
+	local image1
+	local image2
+	local loop1
+	local loop2
+	local devcount
+
+	image1=$(extract_image "$1")
+	image2=$(extract_image "$2")
+	loop1=$(run_check_stdout $SUDO_HELPER losetup --find --show "$image1")
+	loop2=$(run_check_stdout $SUDO_HELPER losetup --find --show "$image2")
+
+	# Mount and unmount, on trans commit all disks should be consistent
+	run_check $SUDO_HELPER mount "$loop1" "$TEST_MNT"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+
+	# perform any specific check
+	$3 "$loop1" "$loop2"
+
+	# cleanup
+	run_check $SUDO_HELPER losetup -d "$loop1"                                      
+	run_check $SUDO_HELPER losetup -d "$loop2"
+	rm -f "$image1" "$image2"
+}
+
+function reload_btrfs {
+	rmmod btrfs
+	modprobe btrfs
+}
+
+#for full coverage we need btrfs to actually be a module
+modinfo btrfs > /dev/null 2>&1 || _not_run "btrfs must be a module."
+modprobe -r btrfs || _not_run "Require btrfs to be unloadable"
+modprobe btrfs || _not_run "btrfs load failed"
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_btrfstune
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_dump_super_output
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_image_restore
+
+# disk1 is an image which has no metadata uuid flags set and disk2 is part of
+# the same fs but has the in-progress flag set. Test that whicever is scanned
+# first will result in consistent filesystem.
+failure_recovery "./disk1.raw.xz" "./disk2.raw.xz" check_inprogress_flag
+reload_btrfs
+failure_recovery "./disk2.raw.xz" "./disk1.raw.xz" check_inprogress_flag
+
+reload_btrfs
+
+# disk4 contains an image in with the in-progress flag set and disk 3 is part
+# of the same filesystem but has both METADATA_UUID incompat and a new
+# metadata uuid set. So disk 3 must always take precedence. 
+failure_recovery "./disk3.raw.xz" "./disk4.raw.xz" check_completed
+reload_btrfs
+failure_recovery "./disk4.raw.xz" "./disk3.raw.xz" check_completed
+
+# disk5 contains an image which has undergone a successful fsid change more 
+# than once, disk6 on the other hand is member of the same filesystem but 
+# hasn't completed its last change. Thus it has both the FSID_CHANGING flag set
+# and METADATA_UUID flag set. 
+failure_recovery "./disk5.raw.xz" "./disk6.raw.xz" check_multi_fsid_change
+reload_btrfs
+failure_recovery "./disk6.raw.xz" "./disk5.raw.xz" check_multi_fsid_change
-- 
2.7.4

