Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E0C351C34;
	Wed,  2 Sep 2026 05:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788325314; cv=none; b=nRQRPOF9kZAHVjAxxip9Reee7HY3tl7x1BTIONa6mELsiUBYqy+r2Kae4i9UXD0jMOXQaD1gq8O4zsJQnEaVNOHao0M5uo/bAZEp6AEg4sjEMEMFLUTprx+pm94KOAynsp5V9+/D0NKMC8KPviTduZahyhb2LcP+i1Kg1ylAoBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788325314; c=relaxed/simple;
	bh=6NnCw3CufFX0xP66aXXb18Y3rPofro8aUZ80Z9Gw56Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FHVul61fcccYbhJ8f5k7wao3BkB5rCjZJomiNsRKse6JePOi0M8mJinnRyKxvzQmOCIxqnnIKsejja7H0nusP9XnTcFOhhRFJkB2iCCWqv5vIuniIjNkwKgkG59fpczkkPp2tRTKP1dAcXBomN73+l7XUDgl4kofRZa/ja9I4a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=KKpQc5T8; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Vw4YAQoB; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="KKpQc5T8";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Vw4YAQoB"
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681KSORQ3054661;
	Wed, 2 Sep 2026 01:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=+b+QlfmGbqZvQiYvAoZJ6o4FJwDtJ1QumrIH
	LNAXNio=; b=KKpQc5T8BSjv3ILcRy8NkrqfZDb4CkloVReUYp250Q5NnxhQKIne
	C/IJHri6u9JqSbB9noKrSQhbBrd1O2zAFQYv0DOgJxWVFUBv/j9GVwNFJVzATFnE
	VluD5HBBm1voV8knxrHPfHkBsz5sgHdzRxha3wfCHyBgARD/1RLB9facKCNJ2q2H
	KvvTcjq++hGkd4G35zT9tLbONg5vPKi4Ydu5ee/0kR2RP+IpDvESM6Uf6GjSJkDf
	9ClFPqxUQpJRjJmDdOWOzqsoYKKTd4UmgwHTFkDkvsfSlKiG0ark7Y5uAK+E76kk
	dLFBPeS/oMpUyKHPlgqj4iqPUlxi2r6Ang==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gbtrg7q69-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 01:01:52 -0400 (EDT)
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6823qWPX2198676;
	Wed, 2 Sep 2026 01:01:52 -0400
Received: from esapsmtpat07.us.dell.com (esapsmtpat07.us.dell.com [143.166.211.149])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gec9d8n3t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 02 Sep 2026 01:01:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788325312; x=1819861312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+b+QlfmGbqZvQiYvAoZJ6o4FJwDtJ1QumrIHLNAXNio=;
  b=Vw4YAQoB7o8GrmiLxVW9U5HGbObCQckxE9wwXqNzDAFkO7pUrtP6qtte
   ISwFXCpUMU3wnV7yEVKG6ydQ6qlfpR9VdydHjFzFnDqSMY0Bwgv4A+RYK
   +FKnCVzUqTOHEPPyJW03133wjrhU/ALQcNbgPBJGRVwYVO0TWhG48pATm
   Hu7YBThEhorFlUOgocw8VU7Wf2QX+m3BLqFpoMI6obsrTE7APO0G4sKdN
   Ot+Fgf5zs4UwiPPScUh1iMNvU45IYO/NftGIv75j9jIpW4EDwx10522kC
   5itmwg4Df8vgBuDm3wCPsEZknMjXn+51HbThgHi/LInzJnTw2BRHAUriC
   w==;
X-CSE-ConnectionGUID: RJKPJjmMSy+wPF1544YgQA==
X-CSE-MsgGUID: mEmeCT4KQmeYuzuyvgDBFA==
X-LoopCount0: from 10.94.14.196
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.14.196])
  by esapsmtpat07.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 02 Sep 2026 05:01:49 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs/273: add missing _require_scratch check
Date: Wed,  2 Sep 2026 05:01:45 +0000
Message-ID: <20260902050145.2439-1-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020042
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA0MyBTYWx0ZWRfX8kqU+HL/Nvra
 TWM8KaCY1SpBN7TmYO8yVpbUdrcMEf3DVbhOYtsZhkw0QWDwENWm5WnWZuokkmH8Qx1VjZsHCWh
 2OGR+KvPw8VhDgVdX7BPRlXd4Jv3S/GLaUtixaHlXT25Q2r2fQDZQJZTLx/OG9VjtjIK34jbOX4
 J9bJKjF41LAKjMRRPWXj2sNnl/K1bcZMUo/Y3p+BBX2Gn1ZdoHeZ6celD3mbAoxVHIl3adO16ID
 RMb4LrZ3dfzziGt1IgWOIEufuL/OyJH/k+ATbN53ZEhnDizgNtRIZZJmHLYu8BUMWbHcs2dsnLH
 UXwio3mTNlbQWis1jj8qIjiw2U/3LICGIhVm5oyAuELel6xHPaMld+M1gO2bngZX4kF342JG5xr
 ArBPe91wRYLVthdgdTlPitMkAZNbcOsZ5fo7yMjonxQRHGf05JF4ZRBW+rP9e49d1L/9AgJ5xjL
 eVAllAYGWJja7dXVpWw==
X-Authority-Analysis: v=2.4 cv=SeXHsPRu c=1 sm=1 tr=0 ts=6a97adc0 cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=vdbZnCXtvJht7X5WT7bgSg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=2Lpba0WeoN7BYVdwMO11:22 a=iLNU1ar6AAAA:8
 a=agzMk0wusT9Gg33094gA:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-GUID: YbqDisc9kYGfySF1BR5_tAVyqo5PaTpV
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA0MyBTYWx0ZWRfX0G3gkbktQNe0
 Z4hdfDR42NVVijlzoxHaOIYR3MZ2WOEJo3wr6CGkH1ur9/6mnoEtwJAwfy7gFf2jrHHyQR/wIxt
 ZnawFarU0yzBvOxV7A5HxmRaZc0fqL4=
X-Proofpoint-ORIG-GUID: YbqDisc9kYGfySF1BR5_tAVyqo5PaTpV
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020043

The test passes $SCRATCH_DEV to _require_zoned_device() and mkfs/mount without first requiring a scratch device, so it fails messily instead of skipping when no scratch device is configured.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/btrfs/273 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/273 b/tests/btrfs/273
index 60c3967b..197cfb02 100755
--- a/tests/btrfs/273
+++ b/tests/btrfs/273
@@ -28,6 +28,7 @@ _fixed_by_kernel_commit 2ce543f47843 \
 # which is further fixed by
 _fixed_by_kernel_commit d5b81ced74af \
 	"btrfs: zoned: fix API misuse of zone finish waiting"
+_require_scratch
 _require_zoned_device "$SCRATCH_DEV"
 _require_limited_active_zones "$SCRATCH_DEV"
 
-- 
2.55.0

