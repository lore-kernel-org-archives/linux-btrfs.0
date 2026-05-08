Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDE279792;
	Fri,  8 May 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251651; cv=none; b=Z5yCFDRobg32v4+HJ3E4CBVMYY9wLWB+g7/VbX6R1EEI6yCXjGYKsIfu84fUQpjL/X5uW60N7x1cKMoWy34j/sDiyTtRozbxgAoc+2RjAwMN3CvZ/fToZMH2VwIpVflvw2eLuowvNajmB+ugqI9ru05R11LVcvrDIz3YwKXh5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251651; c=relaxed/simple;
	bh=puF0Sl9NmkVWAeiPEvE75t9mDGez+H8o7iWsz+Z4NB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cY5hVTwfdmI/PVMn7Vxs8JNA5fA8mb/KT8Eep/Ib7IBbXVaXJQiF4xfkWE6qO75stVJUR4dFJUibQuPLVEtuo4xuei1YvFmEkKOmJ3Uq/v7QV5Wa58BSTZJRrI0piwujM8Hn89e/CIF62e4KisUOk/Jk46U1vP1EMiF6FVZojJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X1DWUbkr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X1DWUbkr"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 648E9FQG3254680;
	Fri, 8 May 2026 14:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=QWGOklq9g6Bs+JbxIbQKUFXLyOHqVYJwTeAx8b7t/
	5w=; b=X1DWUbkrZDrxSh0p+alKLWJJBIfMiTGUiupiNOP1BQZfAHSS/6mRr3cwt
	ihm1Fu1i1sQkdISciJRjGQuJaS5CSHiKdgv5f6ohm52efb1w9p/kV+EtN5GAhqs+
	aAP2j+AJVdL6h34TtLgKTVlHA8OE8QcDBQZL2x1nZsoTZypZKlpRzDMyknwc3mwx
	bj20Jtu9Os2MaQcyHmxGjttYP+MVcWjld6hzj63SQh2XnXMECQZeirhsl9rb9QAh
	UjIqjQaHOsZJfd1kP+LqcKJTToiFh6ojuSCsQz+xOucB0ZYPFpTtuHc4Eyujvqvr
	vqBnECPZfxXn9rQoaVey7Z3AiZK/Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6tv71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:47:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648EdZuL014876;
	Fri, 8 May 2026 14:47:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuywgpcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:47:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648ElMhH50856392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 14:47:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F22020043;
	Fri,  8 May 2026 14:47:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7538520040;
	Fri,  8 May 2026 14:47:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.21.154])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 May 2026 14:47:18 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, anajain.sg@gmail.com,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v3 1/2] common/dmlogwrites: add _require_log_writes_sized helper
Date: Fri,  8 May 2026 20:17:00 +0530
Message-ID: <20260508144701.68561-1-disgoel@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69fdf77f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=hwWE5IYIQOin4IlEfmAA:9
X-Proofpoint-ORIG-GUID: ce45iQ1nBTvk_0OQBClVh-WrWYQq-v2s
X-Proofpoint-GUID: L6DiMiDEwQPVxc-l6kdNyT89_KvZ_h9o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfX+DoOhU4yr9L7
 wZhpZ6V0GURm68BeUat3AsQBYL2jPfBlqfgWDZL4WwfGK2G5pC4UFgv+DNfLY3udoUcMG7a5JYk
 MaFXANJBn3cZ2ggg3MgFHwuUFppq59nhigheCpirHK9ACwJe5FEv9nlX84iAgE0rtiNgPwhJREr
 f7uHxFczakVfHqSVLRywfoSq/0KrJWp2hPFRGGvdEQBW1DRJ4MUoWJYNXNHDkZdXREGWb0+Gqti
 rjkKiwfSI5trDYxdB81lLpNPs9vr4d8gdd6KRt1SrEvTIfdoXgjBM5AMTABm8YJZCcKLskTr83z
 nKbe46F0c6HjgfFjN9gE4owGqDwoM4JKQmQp9l9qRyCFThARD6QAMkVQ9Gvtx2BL2nSGfM12o62
 e1FZt2YN9mULB/JKPvTVcIOqNSdDihlVXw8OfAwmSBsyy9xhuLMLRFPwcVLHWHPJDJ4ZWv6sfT1
 3kqjqc5XyXGs7OzUx1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080150

Add a new helper function _require_log_writes_sized() to check if the
LOGWRITES_DEV meets a minimum size requirement.

This is useful for tests that use dm-log-writes with additional space
requirements, such as creating LVM snapshots during log replay or tests
that generate large amounts of logged I/O operations.

The function takes a size parameter in KB, calls _require_log_writes()
internally, and skips the test if LOGWRITES_DEV is smaller than the
required size.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Anand Jain <anajain.sg@gmail.com>
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
v2 -> v3:
- Fixed variable declaration order - declare all local variables at the
  beginning of the function
- Use $size instead of $1 for clarity in the comparison

 common/dmlogwrites | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index a27e1966..b457ef7f 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -14,6 +14,22 @@ _require_log_writes()
 	_require_test_program "log-writes/replay-log"
 }
 
+# Require a log writes device of a minimum size
+# $1: minimum size in KB
+_require_log_writes_sized()
+{
+	local size=$1
+	local devsize
+
+	[ $# -eq 1 ] || _fail "_require_log_writes_sized: expected size param"
+
+	_require_log_writes
+
+	devsize=$(_get_device_size $LOGWRITES_DEV)
+	[ $devsize -lt $size ] && \
+		_notrun "LOGWRITES_DEV too small, ${devsize}KB < ${size}KB"
+}
+
 # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
 # that it doesn't track the data that we write via the mmap(), so we can't do
 # any data integrity checking. We can only verify that the metadata writes for
-- 
2.45.1

