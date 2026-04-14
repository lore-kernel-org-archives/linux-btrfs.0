Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920C39A051;
	Tue, 14 Apr 2026 10:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162075; cv=none; b=rNbrPSmp7hH1z0oEMcxowb5jHjBl9fd8NPNmM56zU/K/vT+huS+Fw+2PtgmAc1Hp61Ljf0/IAeSPoKzMDxHCewrLJVNoLIV9tSdc25WWB54pNVAhrQvCtO18HT8V9EWtRF/VL3ZznUZFwseQZjknuSc/fjvAw2hkHxU5BgqeGyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162075; c=relaxed/simple;
	bh=fP9aYceQUpoXHvPr5QlrqvQzxMxT00Ab7vkmTJA+UvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fID5t2Fj2y5q/Csd3IawkAUKQvYelIgF4B5WYk3Zn0MTMkl3fq0StG+ixGe3/8rG7q6pwWEwp68m9pm8jypiYI+k87Qe78PVIal1ZoSKAm3Xh/FiyO9a51hW+518oZHa/gzlREBsjuRlg6fMgGeYYRErxIQHtPBuY/uz9VHCucY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Igky6iG5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Igky6iG5"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLI9fJ1804494;
	Tue, 14 Apr 2026 10:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=4TvkfcPrjzTsTuSRfXKtToxzbgkFKlArroTIIDu3j
	ZM=; b=Igky6iG5ZRBDNvA+t5se2OBm6LIhZz7+aZqF9Ws3A6QBLpiriAj8kXh2l
	x9WY6zGyv5TXrdTBuOV7sRHZazRIkVDQq3YrUpFqqyE32qS5uIPmLz3FAtMa08Uj
	+eKb50G9/WGrjVmK79H+DNFeZXp34+wKyOooJJUzjq34xUumIAhQ2maooHXZiW2p
	vH4tbi0te77d3mXGSVHHGpMl9Hj15h8cw7hNs8tQNE1yj3Dx9o+NAxeZPeH8ZXp5
	yr61KVKGrKu5kuiZ37N+GGT0+Op/4Sjy8pGt9oihZvGYMA3nmKpVCbli+OOZ2kMz
	GpkR59bySQwtYU1g3ybRhAmlixARg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k231r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:21:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E91Cl0015149;
	Tue, 14 Apr 2026 10:21:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msh4m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:21:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EAL2cR42598748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:21:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07F782004D;
	Tue, 14 Apr 2026 10:21:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AA3120040;
	Tue, 14 Apr 2026 10:21:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.217.53])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 10:21:00 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org, disgoel@linux.ibm.com
Subject: [PATCH 1/2] common/dmlogwrites: add _require_logwrites_size helper
Date: Tue, 14 Apr 2026 15:50:30 +0530
Message-ID: <20260414102031.74527-1-disgoel@linux.ibm.com>
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
X-Proofpoint-GUID: bSKWSpK8CFSoke3Sf3XTFvoGZoEZtmEn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA5NiBTYWx0ZWRfX2jO2QA1KCaEm
 c3UAIvdIQ4cYjP+CEXx0uKd+RuCFQAfebp98vXtORolfAy72DKlqZgy4ujejs3iHKuE2R0wTIXG
 maAMLYSOJ6edI4+k1MWj80YG8w2tr/nMgUy6VmWiLiL4JL9twaBFUcQujFGmt2Vatj2FJFaoAL9
 RbY7oBy10XArfN77YTYY9t+HrII6TtRPBEdnsuYaCT36WZv5QIURUGlL3R1k10dZ5PaWa9VK7MV
 l+vpFbe9Cn0prjmA6tSRZMU7hLKIHD1x20EKRrsHROku1jBn9DVLXWYA8xz7p+qNHCvEIAgIAPI
 9TGWo0TJDWpZnS5ztRqq/h93qwQXCULLDeoxXAWhR0jWSSj9bya8yzazD+SEnyt5UfL2y+EI+WQ
 8epseT4830DrHhk8L2EQbnPlBM0lEw5B8XKSfTB+A3McoPn4m7V6lGyGJnh3zC2LNCvyjwGUXjm
 8ia/ZDJjI59jRTZ8LBA==
X-Proofpoint-ORIG-GUID: bgUhrbvMAACFPHDrm2bdy4Bxd0K3XyoZ
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69de1513 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=4jkvksA_EdEw6qjqcTMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140096

Add a new helper function _require_logwrites_size() to check if the
LOGWRITES_DEV meets a minimum size requirement.

This is useful for tests that use dm-log-writes with additional space
requirements, such as creating LVM snapshots during log replay or tests
that generate large amounts of logged I/O operations.

The function takes a size parameter in KB and skips the test if
LOGWRITES_DEV is smaller than the required size.

Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
---
 common/dmlogwrites | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index a27e1966..1ce2b2fb 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -14,6 +14,15 @@ _require_log_writes()
 	_require_test_program "log-writes/replay-log"
 }
 
+_require_logwrites_size()
+{
+        [ $# -eq 1 ] || _fail "_require_logwrites_size: expected size param"
+
+        local devsize=$(_get_device_size $LOGWRITES_DEV)
+        [ $devsize -lt $1 ] && \
+                _notrun "LOGWRITES_DEV too small, ${devsize}KB < $1KB"
+}
+
 # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
 # that it doesn't track the data that we write via the mmap(), so we can't do
 # any data integrity checking. We can only verify that the metadata writes for
-- 
2.45.1

