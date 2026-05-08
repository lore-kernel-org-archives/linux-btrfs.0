Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C3351C20;
	Fri,  8 May 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251659; cv=none; b=roZMXRz2ZZUwGnrMXR/0PTMstbhWKeaSNziUdVqIRSwhLcQ7VTWYytXLQ92PsiF4rBWHh8rmjTG5GtZxf3R0uQiVRaYdntgEQXJQ4SLEi2oRAu6yDgR6U9e7oS99TXmYffYB2RlbpBSGYfCKlsL4kdN//IkN8tCpt/qNaTwh2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251659; c=relaxed/simple;
	bh=9wLEIXqCLPs7T+hih337uOWJkQNJr8DSNAPmvVY2m7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1VcmyNUZDUoa8lEigJa201OqPymFeDY36tnQLOgj7A4Gk71RmULtG1cCcydvR39M7s1tzOCUW7o0Y7bvbRVOswEDxZkvgguYWtadbUzJmIsR3PdBRZHoIBgNW14e6HbR4cTCq0RQfzwATcLMeXN6FKYiYMQBODrJKtXRVzIFqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AfvLrRov; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AfvLrRov"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 648DCWfq2752196;
	Fri, 8 May 2026 14:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6rAwNXvdob4Q+inJu
	Y3uwu/eOlN5dYA9MTIXeF5ID04=; b=AfvLrRovBceM2V6dfbbSQUgX7lW2okGGw
	roG69vZboq4IedFBbZa02t0Qi6ugqyHKG5hJnVfPR+dZTgaU5RyBbG5yXBpFzFyB
	U29fP6jP5g3+Qvk5jNNv/VZP448QE72+ortvRcpjiZEqUoINqcudjJwTHv9Nh+eD
	AbnXxE+WjDitljSwlsDjw/tGXQJ1njusHeXckf0owBlB8QNJ8+0C3yk/X5XRTNht
	57LSFCkWqWZDDgIt9zSxJP9xYiO0/mOy9xLg7MH67gcJciNJBPP6vox1rD+bWYBP
	B9dLG/ZPyaNsjgbVqH+xIbbOpbDXgTW5LQB1Uh82uoWO1r6f/J/Rg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x547c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:47:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648EdZeg019422;
	Fri, 8 May 2026 14:47:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e10073n01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:47:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648ElV1o52691452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 14:47:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F10C620043;
	Fri,  8 May 2026 14:47:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 766A520040;
	Fri,  8 May 2026 14:47:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.21.154])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 May 2026 14:47:27 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, anajain.sg@gmail.com,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v3 2/2] btrfs/291: fix state transition logic and add size requirement
Date: Fri,  8 May 2026 20:17:01 +0530
Message-ID: <20260508144701.68561-2-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20260508144701.68561-1-disgoel@linux.ibm.com>
References: <20260508144701.68561-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfXzsio6/kvJjkf
 ZzasQP0l3fNgu48y1SkopbxtZb+jO//O9meuGuNbU0XV6tOYxCbBnrCyxDpXSjJphDhxpyXpUS+
 J3kL/xx9e7hp8ZU7hwtfnF2Rf4W8OJYOWfZtVkcb3sbi8nBOJqwYLnlnvws6n8+moh/fZOQfe4y
 eHU1dQ9Lsjrl880IKyZYKKQ5Z1RnlTAeKFf1uxtwJbSi+XvDLlgm+5pz+BEDk5nM1U/tAeXCt5a
 5BR7jP0JdDT8V/a6rsh/FQrayABOuAN5CdudI5tYzPbnKJyBg4w+neJAWms80Er44pCPLhswsck
 76kIuuh4C86Mg00iIk+fYRQ2BKHKsdpwjFor54re4F0ECyrCF0745HLhAo91D1IMy3c8OYt5RNM
 Pel3KXOwrKNhV3ZRx/jI2S9Mzt8LdJieuDmsQ6EbA1plZHoek0N6O2wT5BET/r1Db80uLj0xc7h
 VOwtlL9m38ZmM6JlXWw==
X-Proofpoint-ORIG-GUID: K39Snt73ctQNYRqU0T42XKe9hidbOyU3
X-Proofpoint-GUID: cVkapJjlPhkdSLYKykn1o_pf02Cw77j3
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69fdf788 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=mwbAGt0PX1LO7ssdYbAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605080150

This patch fixes two issues in btrfs/291:

1. Add dynamic LOGWRITES_DEV size requirement based on SCRATCH_DEV
   The test creates LVM snapshots at each FUA point during replay,
   requiring significant space. Calculate the required size as 120%
   of SCRATCH_DEV size (adding 20% overhead for LVM snapshots and
   metadata) to ensure the test works regardless of SCRATCH_DEV size.

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
orphan items while maintaining crash consistency validation, and
works with any SCRATCH_DEV size.

Suggested-by: Anand Jain <anajain.sg@gmail.com>
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
v2 -> v3:
- Calculate LOGWRITES_DEV size requirement dynamically based on SCRATCH_DEV
  size (120% of SCRATCH_DEV) instead of fixed 9GB
- This fixes test failures when SCRATCH_DEV > 9GB, as reported by Anand

 tests/btrfs/291 | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/291 b/tests/btrfs/291
index 122aeaa5..e5ea4b50 100755
--- a/tests/btrfs/291
+++ b/tests/btrfs/291
@@ -36,7 +36,9 @@ _cleanup()
 _require_scratch
 _require_test
 _require_loop
-_require_log_writes
+scratch_size=$(_get_device_size $SCRATCH_DEV)
+required_log_size=$((scratch_size * 120 / 100))
+_require_log_writes_sized $required_log_size
 _require_dm_target snapshot
 _require_command $LVM_PROG lvm
 _require_scratch_verity
@@ -129,9 +131,14 @@ do
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
@@ -143,8 +150,10 @@ do
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

