Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63963 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbbHEIDU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:03:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <robert.munteanu@gmail.com>
Subject: [PATCH 3/3] btrfs-progs: fsck-tests: Add test case for inode lost all its file extent
Date: Wed, 5 Aug 2015 16:03:14 +0800
Message-ID: <1438761794-32738-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test case with no file extents, but still non-zero inode size.
To test whether fsck will infinite loop.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../017-missing-all-file-extent/default_case.img.xz      | Bin 0 -> 1104 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/017-missing-all-file-extent/default_case.img.xz

diff --git a/tests/fsck-tests/017-missing-all-file-extent/default_case.img.xz b/tests/fsck-tests/017-missing-all-file-extent/default_case.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..10cd4c786e1223d1d00eaeab81941b142135d97c
GIT binary patch
literal 1104
zcmV-W1h4!3H+ooF000E$*0e?f03iVu0001VFXf})lm7${T>wRyj;C3^v%$$4d1rE0
zjjaER49m*J$Ny#wkkW^{#)(qVu6jW@U&${Z!$pUxwR_2<M^&H7KU2hve~sxWXa?I<
z%Nm>WQokys>I=scC%OAq$m&Z!a?Xa@3%R}h@8vWy-xl~qOuWtRg-R5!%XR;99;~oq
zdk{P`R>yx4e(-g_fYI=#ZDobJ@0`2Gi5Z==2t%tsj$0@PK$0}7L`88Br(*1nkpN>K
z_XxR>VtghToWQcwSZMnTkBh=v`!_jtFZnBcHm1>wf5wOm9i*QuB{`*iwt$@={jV)*
z%}T2!cPnR{zgSI}F-k1(>|ItD#YU*lQ5caPRu;$454g#EI<MlP+@`=aT*A@LADD7u
zk@V7c2kM}eBPO^Qu;ANX4!roj9d3LYnAteNtD<3soCJnDoNp54HZ4ZeX@naau}+a^
zy|#?-`{(08Rl!wH-SY4?>wetPi2Qb(f`c45RskYyF)v;1`SlF<lxU5!p|~;ics;3^
zBX%=|JUR^Ky(ynC=M7)sv&k~E4@16W$NYHYzCJ3;@@${p?4~ysw=fq^vz(x(PtElF
zwf3WM-8M{A?g(sW#s;uPp5)F}4lhgs%K1q1nFGU`)GD9qPGir}B%j3$a3;A?Gq|tS
zaDXnqJ{7yrj8iPECu)i;L_ouU|17}`kpGA2x2A0_<=e3S$bZ7H^DTsDQRGOZb@F;q
z%#Y6-P@=P|nbod(i7Gd3Lvl9v<Vzd!)uy)eEr2h(pFvf<GR9gMp7SL=Ww6;c&>vzs
zSIkg93uy516A@onIsCrvlQqwJlV~$<z#z)3I_GDFsRim|mp%_0{a_wo&v_H$C4TDq
zwn7^>-kcft_F)4WPt0OV+n3W`nZ4>OC`z1a<gtXhR}#S0IqeJw$Lsxl>4BHy`9hHs
zBtPA?RQYVy53b&CXwhyaxL;{eBnLK1F~EqXTP1;aSvcM5-y;6(p2G02#<C0S{EE=g
zW>1iR3fbSs^zRyjGTuc(qgYeJO3yRzBq+JtviiuggemrKK5?gVyt|AD#<jSXzU4VQ
zfop5yezs3WSr<m8QE|MhpJ<H!92~QSYE^Eq1p4jh$Idi{1`R>B5>jNvfrJ7h*)M7<
zoMsb>cB?RsO4>P-LyY62_cY6mGWv~hlA;J%`X3cfL4vfPWRRidP0rp|UFe_14^R2I
z{a1+AOJXzAm=7pkt%~NC1$Zx&1R?`MOxJIC_dRjwdc8K9d6>3f6rzoibNqCnp{u$U
z+A~#XVza7Y=CSF*ohfxwwN9we2j*qrOWm@Z+eMws1MlfN_ibWsO<9Z^OTT^VoVw{S
zPt09il30LPI_!MVdj_{j0W`{}1|)2jXtn*D`NB+JQbn9BfB*m@w2urGUN=kt0jmgr
Wr~&{`ruvAn#Ao{g000001X)^bF)Hl<

literal 0
HcmV?d00001

-- 
2.5.0

