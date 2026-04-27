Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1514C3B8958;
	Mon, 27 Apr 2026 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292797; cv=none; b=BgIlVJoG47tpgVir0eIvBkUSv78wX9WPw/ytYkQLFMd46kO8pELbRAZ2US4E5xyBQ5L6Cx4nqVIysZ5ROAPLI96WA58420u/0rexK04eiSMTLJtc9nnW/zWeOjseaq/63LIdO718VOasjnf8EdKEzbMX/b1JrSKvqn7KHySomAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292797; c=relaxed/simple;
	bh=fIYmU85GhwsWtEXBFUsMBtpl2olMBq7/skfP2pMyzmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnlSFGFgEN/G2zyZlQZ6IJEjKka/5zCCKa0IOzRaPo//yEQCWkpfLx52kZ1xrkH8YNaV/AgOH7PaGvtN9BKpTAWF9WUGjdNjcn1NbxFbne+okDBcdH6vRL6rpsB/d2dXPk2Ikob3X5BIW12HuKkkf/K3WZh6n6VNR4BeWGNVSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fCuAayvS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fCuAayvS"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R9s1oV2036575;
	Mon, 27 Apr 2026 12:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=e/vGZqXVi/yp3SEX5ohhJLmYyM6wNbot5uJ+JTn9c
	Vc=; b=fCuAayvSPTZztSd69V/FNBhAePziwVA4iGL2zsnqASzD8+bEPrN8TBc1K
	Akd/TwG+zk0BUREOeiSxn+gQ7kDfb+ACzh7bxuRYitNoXo0r1tSPQPLOy9UPeEHQ
	MwZmYDU4/BXP5YMOUwoGI6dhRBHoZVCiZTxc+qFcFlwCJxdg2VWeIRpH+3CLmd4q
	GMDA+cK8SbYSdjizeCSKzzt8kh6zjyngruenDUPOg3O4Ubq0VeKZ8+INaosk7bjM
	SQfEZpLNlrMir2plAkczyHPfZ/G/sWhLZeLAemVo7nrYRuUX6tzouUtbh289jvLZ
	s5tlqSr11TRHtGiMtQ2XgxCwiobpw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drk1jfran-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:26:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63RCNvsc031695;
	Mon, 27 Apr 2026 12:26:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dsa5g4x96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:26:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63RCQRL344105984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 12:26:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D616F2004B;
	Mon, 27 Apr 2026 12:26:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CCFF2004D;
	Mon, 27 Apr 2026 12:26:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.16.1])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Apr 2026 12:26:24 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, anajain.sg@gmail.com,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v2 1/2] common/dmlogwrites: add _require_log_writes_sized helper
Date: Mon, 27 Apr 2026 17:55:50 +0530
Message-ID: <20260427122551.71696-1-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzMSBTYWx0ZWRfX/H3wz9ABPq4n
 HveGjYy9b1MtH/bYHoqqXOMyvNfFvtIPkhXAtOQvOZaOHJmsEHA7xFD2OHlERvcwKXRteZvOwvv
 5mIEJdDlLm5781OPfTcIrvZWUWDLbp/ptjI0Ck/2E0XjO5tJFUbNALVD0UZrG47gkT+Q+TTBI/5
 N97DPB1DqM4CayjGmjYtdVbhyWAKNdRenZS3pjgwesrBSJWoaC11Fe6yBAZWB/Rb36qTfb4WjJ8
 oeqTee5GxjQEoDPY0MMvAuC//ZHl4hzArLYcRfY5B3qxe81OGJX0o+7zguxlX9+JYa1lV6GZU9D
 uC2XxjJnT4unrlCsikh4iXvekZ4Bjv/jiWaCAQcOwlOEe5CZ0k+MEDjVRxmfD3D2x3BsqpBKdbm
 GwELOd1p/VVTfHbaoDQY2g85wwQ3Q2ACIKYWl/NzLdwGR3hvqMPyqmwfpOFc6hgO1D43SeK+EIj
 c15POh/ABkKOuAiq0XA==
X-Proofpoint-GUID: HybTEW3AdEt4uY2WvTWesKFTnP6M_K_u
X-Proofpoint-ORIG-GUID: 3OVBar1ZMVPklyRUCsg_KTJluAcKqMle
X-Authority-Analysis: v=2.4 cv=MohiLWae c=1 sm=1 tr=0 ts=69ef55f8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=9OGe75lrTsZGxTEJxl8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270131

Add a new helper function _require_log_writes_sized() to check if the
LOGWRITES_DEV meets a minimum size requirement.

This is useful for tests that use dm-log-writes with additional space
requirements, such as creating LVM snapshots during log replay or tests
that generate large amounts of logged I/O operations.

The function takes a size parameter in KB, calls _require_log_writes()
internally, and skips the test if LOGWRITES_DEV is smaller than the
required size.

v2:
- Renamed function from _require_logwrites_size to _require_log_writes_sized
- Added documentation comment clarifying the parameter is in KB
- Made function call _require_log_writes() internally to avoid redundant
  calls in test code

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Anand Jain <anajain.sg@gmail.com>
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 common/dmlogwrites | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index a27e1966..0925b333 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -14,6 +14,21 @@ _require_log_writes()
 	_require_test_program "log-writes/replay-log"
 }
 
+# Require a log writes device of a minimum size
+# $1: minimum size in KB
+_require_log_writes_sized()
+{
+        local size=$1
+
+        [ $# -eq 1 ] || _fail "_require_log_writes_sized: expected size param"
+
+        _require_log_writes
+
+        local devsize=$(_get_device_size $LOGWRITES_DEV)
+        [ $devsize -lt $1 ] && \
+                _notrun "LOGWRITES_DEV too small, ${devsize}KB < ${size}KB"
+}
+
 # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
 # that it doesn't track the data that we write via the mmap(), so we can't do
 # any data integrity checking. We can only verify that the metadata writes for
-- 
2.45.1

