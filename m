Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909344C66D;
	Fri, 14 Aug 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720688; cv=none; b=RYsxK7obivSqgcR2BgXfd5Khda0j7RRfu7Vk4PgIxtii5GR39Yla6W5YtkFE3dTMTJWOUfWBAF5V8/CABIm0C/Cq0RDu2asbkD2/1JO1xj2mDrLu5NPEErLzrOnMhDukCE+Hoe/Co84ZH69RiqqQDVtyBrKyU2XURFVsO2KEXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720688; c=relaxed/simple;
	bh=wX0BSXCSXs8Z0UUJP0oU3+H5pV9CQLTdvZ13FwKf6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gyFJmk04axfVDk2LsWZeDV2rBPXEjIvAIGyfGvA/CY97dd+FA/TDASf29UPDMdkw/jLgl6U/Sq8xrIPU4UA9uCaPMHERAvVGKoS9R48NBAjaII3KdeD/8Zs2Ypt3UTcDG4LC2QEKbyd2vgXwYGYj3008hHDuzaP91PmzLt9v4nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cGaYyOdY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cGaYyOdY"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5rbs230451;
	Fri, 14 Aug 2026 15:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=qrL8gzwWg2sydhorFDofqOeQlhQRqeRFKP16NMbqK
	gM=; b=cGaYyOdYihcr2B0Z/xjxDsL/FImyP/MMCgSmjXHTnHzRwJG8vqL5NYVBO
	GS12JKM0QUSRmbRNtRbOzEeu1e/3eokZyqfmehJ/AavgmxCM2JVCoVt/HkJqJTmN
	N6Zh+bmu7lTY45pdnw02+ltC6ADp6FaKswrSSz/E9VeD9YujuAypXA+s2xPK52a2
	KLNyUqG9E82GnShyS2xwmse0ReIvJjJ/vcDfA98y3HhOkhW92q6ArdU0NSQ5aBeX
	pWgSecomQoy7QCMMnIql/i8V4vGIXq4uoFWs0OzZa91ptQNV8OAUFud3BpDqxY0h
	5f4ztEQ1G8joDidCp3Bev9vJT8BYg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb245kae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 15:18:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EFBUgT025709;
	Fri, 14 Aug 2026 15:18:02 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqfy3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 15:18:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EFI2eE4850228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 15:18:02 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BA4D58061;
	Fri, 14 Aug 2026 15:18:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B0458056;
	Fri, 14 Aug 2026 15:18:00 +0000 (GMT)
Received: from li-d98989cc-2c66-11b2-a85c-93ab83b7dd53.ehn-de.ibm.com (unknown [9.224.77.173])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 15:18:00 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: borntraeger@linux.ibm.com, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 1/1] s390x/css: Fix css stsch detection to go beyond 8192 devices
Date: Fri, 14 Aug 2026 17:17:59 +0200
Message-ID: <20260814151759.1831153-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7f31ab cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=I40c305UB8KqZV4D04UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfXwiSr0Na4S8mj
 qiYQOfMqi2x3vCzgXbudvZE6LV+/IVKvv/iWXCRBKLf2aXlszuwo03fABtZYVgHvrsRtgHcVqJc
 hi806stJSSti0xwkPnPL6Ml+563B6oKB/EAkAODpjT0HwjcH2HXG6mWYagcvFzCScb+9iUex08s
 +JBE6P2cqimbah/glNf147f+ulxniPtDlv4mrE79v/XahOWEDU3bAGnvRcne+26vY2Zdzk8W7J7
 MIl+pPjfeMrB/PsmeeE50r8tqEqp2vGFls4/P9PkPFMrbESE6G3dbkMMaQA3u7np7y55+Q4ZzhY
 +E5DUgBuH5zcJ/wJ7f1qz1yXRviB+BHyl6QXgRD9mmj1Ycrp9P8PowRJbVM4gq4mCxOTjZuDrUt
 8KWB2WY85BTzqA8+wnARw+tgJG/8m3a0ocFrprtHOn6WZN6KipcOQoWQFWN5zGTxEmOvust0zT5
 ch7vGkFBCkbCOygNcxA==
X-Proofpoint-ORIG-GUID: Pf9jo0x16chyHvJn-zhFReGE7dqak_vS
X-Proofpoint-GUID: Pf9jo0x16chyHvJn-zhFReGE7dqak_vS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfXxuetWXqxsvL8
 BQt1OLXDezk5r0ksKODKrGPhj9vtVXB8n+UgUP1T4rpLKxsBvGIT+a0W5sMW6dF0AAw4oBmD+W1
 1WtO2RPkxjm7st/LAAyfoMYqbfnLZBU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140114

find_last_bit expects a size in bits and not in words. the calculation
limits the number of guest devices to 8192.  This probably does not
matter in reality, its wrong anyway.

Fixes: df1fe5bb49241 ("s390: Virtual channel subsystem support")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 hw/s390x/css.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/s390x/css.c b/hw/s390x/css.c
index 3a67b670531..dedd39006bf 100644
--- a/hw/s390x/css.c
+++ b/hw/s390x/css.c
@@ -2023,8 +2023,7 @@ bool css_schid_final(int m, uint8_t cssid, uint8_t ssid, uint16_t schid)
         return true;
     }
     set = channel_subsys.css[real_cssid]->sch_set[ssid];
-    return schid > find_last_bit(set->schids_used,
-                                 (MAX_SCHID + 1) / sizeof(unsigned long));
+    return schid > find_last_bit(set->schids_used,(MAX_SCHID + 1));
 }
 
 unsigned int css_find_free_chpid(uint8_t cssid)
-- 
2.55.0

