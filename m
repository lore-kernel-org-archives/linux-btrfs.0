Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67930C368;
	Mon, 27 Apr 2026 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292805; cv=none; b=ExyUe1/e3wC2D019HX7gv4SKZFjJQOg6mOhtz8VgvJDPjVt9eBeYavHmZ2mieqA2ugEax2A4L4vT9nUmfhKYtsbQaXbiw4nQM1+TJ8oXZJIsfu+qBmWJdkJOjAs/8CZ9F6+ZpkwmtOuRyjJSYeuCL83L08x3FjjTjMalGh7gITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292805; c=relaxed/simple;
	bh=aBJBhc+43ZXYiGmbWEEDuMxCs6BOVT4osYdp6x3foGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0yjuel8MPtsFj87eaqeynsmPRF5SUVJM6Cswkr1pxAtILZd7x/PSGm805eOjVQYLEEX96PsGPMI4bLgJ+wTo47jCnGg+ndSzcY8Qu//bxZkybn77I/ccGiMVYd9MRof/8y1ol/1JesMlk13Yz0TXMCKHlR3qKfjsn70WEi7Sq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vkbtlp3y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vkbtlp3y"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QJmjPS3238929;
	Mon, 27 Apr 2026 12:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=otNIxpTb4TKkzeJC+
	jcB/yvDPqrwnQUrLQ1CUPDcnT8=; b=Vkbtlp3yPhx2R4Bi5aZu+a0+oEYyCbKK7
	u6w/30TkhaEPULA/s9/STphgHOzP4n5+LA/JJLQ44+UAv6bbZcT9HiqWBYAIbMGG
	CdmvatCvJAk2H901fMQ/u4PzC/sB4ms9/Mv8ULszLC90xrfeq4V/rwS49CTZX/k0
	OGW9eN4b+tAQKUd9dNbCgES1cASFPF5wka9E86N42T4YYQA/13atA9ptNUcDLoUr
	dqMzk52vJBeP65OnG6gM4c5x7upd+QSxjpuULW8NgnC7FGnG1hKrHtrE7GeiJn7M
	/97XZn7stQdFSD0tfXdm9CL4Vb0ylBeGIBB2DQEnA0AIIbG8UbSlg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drm1dqk2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:26:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63RCNrgx006454;
	Mon, 27 Apr 2026 12:26:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8xjw3ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:26:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63RCQaR851970356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 12:26:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BF872004D;
	Mon, 27 Apr 2026 12:26:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DED72004E;
	Mon, 27 Apr 2026 12:26:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.16.1])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Apr 2026 12:26:32 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, anajain.sg@gmail.com,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v2 2/2] btrfs/291: fix state transition logic and add size requirement
Date: Mon, 27 Apr 2026 17:55:51 +0530
Message-ID: <20260427122551.71696-2-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20260427122551.71696-1-disgoel@linux.ibm.com>
References: <20260427122551.71696-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: EAyICJw78_4uXxEwvUMeZ_0RhcIhjrJC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzMSBTYWx0ZWRfX0ZTHpTweArjI
 2F6TgMBGMp4AjQNY6hY2t0qp7ZJmbGuZWR7inUa5BnR+bfjNkQ8S9FbljXR4FbRK9Bk/0MoBlwG
 977RJj1juDgb7wloCxIiz06NDtWNthOJoySSbo3u3ND7Pv5mtH2R0yIRfMtwxN5WHwWQ5aQIOIr
 DIiEuBD5Fw2YPIrFXFhDF6NuF8ep+7q+025IhfdsYDWvmm4DnxAUQXLNj4HetniF3cc5Tof8dxC
 tg+YKTHi7V91CBBqp3mcxYcQdiXohtGPk6JwO6pK055veHG/JgJzGsGtxo7oc7Ohj898WwrsNf1
 pMCRisxuueIPFp1tARla9OwKRr494mlrOHgNH1bWtFVZnGfWqt9P5iFAu3QIGFsduBAgGbIBSJo
 gs2zvI8rQM/rjfdlT4tFGtuYzy2HvA7z35BPq+UswRglcvz52FuhoWi4e6AZZXhH6ELLjp3z8l9
 bK3Aq9ul2mmTpTK9+Pw==
X-Authority-Analysis: v=2.4 cv=VZLH+lp9 c=1 sm=1 tr=0 ts=69ef5601 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=mwbAGt0PX1LO7ssdYbAA:9
X-Proofpoint-GUID: E7xGCvvfp9kTfQkJgkgCUDt8j9SASUc9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270131

This patch fixes two issues in btrfs/291:

1. Add minimum 9GB LOGWRITES_DEV size requirement
   The test creates LVM snapshots at each FUA point during replay,
   requiring significant space. Use _require_log_writes_sized to
   ensure sufficient space is available before running the test.

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

v2:
- Use _require_log_writes_sized instead of separate _require_log_writes
  and _require_logwrites_size calls

Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 tests/btrfs/291 | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/291 b/tests/btrfs/291
index 122aeaa5..ac1d192d 100755
--- a/tests/btrfs/291
+++ b/tests/btrfs/291
@@ -36,7 +36,7 @@ _cleanup()
 _require_scratch
 _require_test
 _require_loop
-_require_log_writes
+_require_log_writes_sized $((9 * 1024 * 1024))
 _require_dm_target snapshot
 _require_command $LVM_PROG lvm
 _require_scratch_verity
@@ -129,9 +129,14 @@ do
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
@@ -143,8 +148,10 @@ do
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

