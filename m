Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9671839A052;
	Tue, 14 Apr 2026 10:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162085; cv=none; b=qFauu+XX9W0ZLIxSsI52lQ47+3hY0E1XbtPOyQSGeF4q1OaMgSXzeoXUnQYtKbt9H9deZ0OfRKkBdQmQDJ6gTF1Sd8ZeVpLh2smgjNBq3DP7l+v5dMNMMMqncGd3IOFR+ftjGRZ9t/Na21Fdn8v6jKKXa5i6TfGevReZFDcbflw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162085; c=relaxed/simple;
	bh=ZFwkzl/0vo3Jaa8tdWF8FRZg+SALo9SyR9lDZIQ2J2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcAbXgN+KSliZm+EpoeYz/MOexOMp3Pq2wP/bMW+f5ZJ/zj2UDpG4/d3p3d+nXVqDnXpE+N7eN4Waha3ThSgIqlEr8fyvjDNYkqiQlKh2VzbG4ih/f7mr/SDrJcAb570jO5o+ENGjhdrvMTiz2Ynu71CV+ccw+2sLNJlO6u4otQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DSS2GpvA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DSS2GpvA"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIOTx1842922;
	Tue, 14 Apr 2026 10:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KA9kHtblM762cOGcI
	jDIaUgMF6i5ctNB7X1etNKYuEQ=; b=DSS2GpvAmPNr2QG2uqZb0SiSz1jqyhPec
	CTX4aRIX2DR4/y3DW3gOuN5R+Avu5RgBb7O9POjlAFCC6wJgmuGeFtZDuPxLjHkd
	+ObIjoXS86oqyQ2GN6vOujgb2boayNmXPLAxHIwcwVw7lhHA1zU2+PgYn8d3GJdL
	RlB7vOdM9xiKvKXGl98c8FN8G3rpbbgIzWogC+OenvKKDvhqW6CmXEoLAUGA1ftI
	dR0LcGigy2QK+vbhmbRGF9qOvpNPJuT15uiy8Dd7I3vVWeS9DXni+MLjD1pcZho1
	2FIObgvaekGx+OoNANJEb01500dzvBgn/OpcMKPUFWCRChOE36otQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mj5wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:21:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E91Cl1015149;
	Tue, 14 Apr 2026 10:21:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msh4md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:21:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EALA3x47513900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:21:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51F5B20040;
	Tue, 14 Apr 2026 10:21:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A77EB2004B;
	Tue, 14 Apr 2026 10:21:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.217.53])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 10:21:08 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, disgoel@linux.ibm.com
Subject: [PATCH 2/2] btrfs/291: fix state transition logic and add size requirement
Date: Tue, 14 Apr 2026 15:50:31 +0530
Message-ID: <20260414102031.74527-2-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20260414102031.74527-1-disgoel@linux.ibm.com>
References: <20260414102031.74527-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA5NiBTYWx0ZWRfXzei9qZq6VEPi
 E5zIray++fKZ9nRm/Lkv0Wka62FkgMZJ8Kjp1auJOMmizIP25Zz3yBCGZwdcjPObZRMguk+fMBL
 v9d+7FOIlKVxYvLdjr9J9AstGBo2cf5uWmV4t7K2ZxrV7WYKTZaVjPoOiz77V9+C1PoGS12e5LQ
 RBuOIlmnVpsvBsbzCxeHgbPCQQRjYJ3Cq+ZJSeXSG1b/NdsyGikuEY3s78XKZDIBMyu+6m48jFM
 xFCA+EzcO1rWijDVSRD7Ynwh2wU2JprNKjetyR9qV295iuAQDts5WbGDD2uO0TbxIsl7OM6rT3r
 ToY/0IOnVUF2QWeEYS0/lSuydZgt6vqmlmatWvSfbEl8fV9bqllTBzz58VRgSHhVDfejHvTgEBO
 AquudXl1zg3wph0qoKx5gA3F6tBJi8vB/xJekwZFsGwPtAGF6dcVXEt0VEgx70F696qexTBbqer
 6DPGHL/qGgjvR3PWTgA==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69de151b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=mwbAGt0PX1LO7ssdYbAA:9
X-Proofpoint-GUID: 7rgYaHDelfM8c_o_hfjZ_lxK5rpmRLrp
X-Proofpoint-ORIG-GUID: gK-keISSti0-ybcn9skkJdlwLwnCuxNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140096

This patch fixes two issues in btrfs/291:

1. Add minimum 9GB LOGWRITES_DEV size requirement
   The test creates LVM snapshots at each FUA point during replay,
   requiring significant space. Add _require_logwrites_size check
   to ensure sufficient space is available before running the test.

2. Fix state transition logic for verity enablement
   The original test assumed orphan items would always be created
   during verity enablement (state 0->1 transition). However, in
   some cases verity completes without creating orphan items,
   causing the test to fail with "expected to reach verity done state".

   Fix by transitioning to state 1 when either orphan items exist
   OR merkle items appear, handling both verity enablement paths.
   Also improve state 1 validation to only check for cleared merkle
   items when measurement actually fails.

The test now correctly handles verity enablement with or without
orphan items while maintaining crash consistency validation.

Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 tests/btrfs/291 | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tests/btrfs/291 b/tests/btrfs/291
index 122aeaa5..d29dc5dd 100755
--- a/tests/btrfs/291
+++ b/tests/btrfs/291
@@ -37,6 +37,7 @@ _require_scratch
 _require_test
 _require_loop
 _require_log_writes
+_require_logwrites_size $((9 * 1024 * 1024))
 _require_dm_target snapshot
 _require_command $LVM_PROG lvm
 _require_scratch_verity
@@ -129,9 +130,14 @@ do
 	_udev_wait /dev/mapper/$vgname-$snapname
 
 	orphan=$(count_item $snap_dev ORPHAN)
-	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
-
 	pre_mount=$(count_merkle_items $snap_dev)
+
+	if [ $state -eq 0 ]; then
+		if [ $orphan -gt 0 ] || [ $pre_mount -gt 0 ]; then
+			state=1
+		fi
+	fi
+
 	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
 	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
 	measured=$?
@@ -143,8 +149,10 @@ do
 	echo "entry: $cur, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
 
 	if [ $state -eq 1 ]; then
-		[ $post_mount -eq 0 ] || \
-			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
+		if [ $measured -ne 0 ]; then
+			[ $post_mount -eq 0 ] || \
+				_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
+		fi
 	fi
 	if [ $state -eq 2 ]; then
 		[ $pre_mount -gt 0 ] || \
-- 
2.45.1

