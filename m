Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7B38644D;
	Wed,  2 Sep 2026 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788342132; cv=none; b=phM5n1SzE/xCKeE81H9xbiRMYIpzWvSAGUWgt8SS+Sx3lItLG5gRBXAgnDK0wrnB3rv9SPbryjV+bRsNzc2hoSMW2kk52dP6dcpbdB0JVg9+YESDucvuzgDnCudR290vBC6damYF7a1CgikCgDHRdi75ZkLDUgzuNNR1SrLZcns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788342132; c=relaxed/simple;
	bh=muTaDowgq+2Bm9BrvlSfI/WoD0EhKNZSlU/urjQgRH0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MJp/cu9Y+JBPJfVYfFx9ei/4S8pxYq7Ylfco1xXQNq+hP6P0B70aeIvKXYYlkJNUgceOw5tt3eiSqgM/dyD5E0Lm99bQov+X2iI+pzTwV3aGBF1uVU9ORQaP+DBB9ULQw1fogDfkYAdCx4z34rkVY6704vS7Ugr2RcwHOcl5OeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=a4151vkd; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Xq7t7/gZ; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="a4151vkd";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Xq7t7/gZ"
Received: from pps.filterd (m0170395.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6829M2lf989524;
	Wed, 2 Sep 2026 05:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=3AUNxz58vDoxYSvA8k5ZM/r33BED3JsGq8RI
	d98C0kU=; b=a4151vkd5WG5l3nW3Tz4sZ9BlWjbIqdnW3CVmXNAIdhsDAkbgEZ/
	gje0AMvVPfgQUgb44R89rLYW1GJ6fhhuWkF+kBls3A6WDEV9opBdOUXIPteHee1x
	IIxMELtd2glRcLA4GgM18Vcfu0YUIPpW3A0/qMNSbO8QDA1d8AwFyz/PcZs+tXoY
	T0yo2S+L9fRR2FOBcX1DzvCNsOBkCHYd77cnXcrZlTI3jkuOABtgQ+MXdR6cI91j
	ox0GVbKg8KaJe2Q5JQSjWjPnW2l0EzVXEhsnGtvg2BpoaqXhsd+bPJ4PbEHofE+N
	sZ5UOfgjH4ZfthAMnnKRS66S5+V8Sr70xw==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gbv3ggnpb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 05:42:09 -0400 (EDT)
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6829O1xH2418422;
	Wed, 2 Sep 2026 05:42:08 -0400
Received: from esapsmtpat08.us.dell.com (esapsmtpat08.us.dell.com [143.166.211.148])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gefjw9eb9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 02 Sep 2026 05:42:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788342128; x=1819878128;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3AUNxz58vDoxYSvA8k5ZM/r33BED3JsGq8RId98C0kU=;
  b=Xq7t7/gZu2BKhwzps0Afb1ESCymotsAl7QNVRUbC+J1k9sZDjtRILMLg
   H4EYKsI2PJPE8vqPSH1a0IsB9e/z5ebrNhzN2FIJnCcjNZh/fMxNe/tCq
   DQAhhCzuTdpLJOaJcWt2r+/nk7ib22ZCn128q3D0nrp7DAKZ/AZuLTuUc
   532df/aPc4zwQbAvUc6I0ZFsvnQWFR9vjPJrWMMkM85SFw+E4YqPyIS/v
   N2q+33vzgA/MEPOH5V8btJLAjjUCjp5594bDu/JcBUwdxr9qcr5ZMWq07
   dMA7O/mgoLVJq79KYRGQHK37XD/qSsuOOJLUjtWRGpWBGGOe9uw+6t+yt
   g==;
X-CSE-ConnectionGUID: okrmZRLCR0uS8MZdT/Vhmw==
X-CSE-MsgGUID: b6XiNk71SS+CheVp4BF9Aw==
X-LoopCount0: from 10.94.14.196
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.14.196])
  by esapsmtpat08.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 02 Sep 2026 09:42:04 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: [PATCH v2] btrfs/273: add missing _require_scratch check
Date: Wed,  2 Sep 2026 09:42:00 +0000
Message-ID: <20260902094200.6270-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-09-02_02,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020085
X-Proofpoint-ORIG-GUID: b2gIGZmbzNaMLnYTPfrm99aleHxHf-g4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA4NSBTYWx0ZWRfX+cPXQjJZ1/dk
 RtBKZmDvFTBZyKT/pBijj0aJCXejDMTAXIkUoMumg7HIngX+jYFuWuMRX737AyxXaJaSkk+6Sgi
 /iHYHdcKutcR1nagyTW9wUG8Ewbj3ajS8s2GYzbz8WB7llKJmoLmKaaWORvR++xtru+tORSgv94
 L2k2pOAUES7Fc7Gg1LLVuaNdILeilJN2hcrnuqTYIsjP7+LB0fQHsVr9rXfvPAkRkd8jQMMdPvK
 P2vy6h4QJ+y62CL9aBdJGa42VZyz3O3VQUMvNj9QjXEXRe63F8QYuJ3J3zH4HQtwXpzPuNW9AmX
 sRG1ZTfsPqGw6RnZyZKG+Qwb8vmTP8+94LIbQcFQHHLjGdWFfHNyX7K58L3JMuCL3caft+KZk4a
 /M9SLMwRwgmPH8nSabJv+5/kr+8ds21d0bcbw/zT2x64rzxf26nbPcRWBdkQojyRBwtj9SAG2m4
 KOiGOXtZacWMPyOnUGw==
X-Proofpoint-GUID: b2gIGZmbzNaMLnYTPfrm99aleHxHf-g4
X-Authority-Analysis: v=2.4 cv=B7SJFutM c=1 sm=1 tr=0 ts=6a97ef71 cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=yMHKiRmgHdO7ybaHu+/uXg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=Qy6CKLcU0MZ4grw4BCWD:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=iox4zFpeAAAA:8 a=ud7VmjWcpcx5hLGjRdQA:9
 a=gbU3OgOOxF9bX48Letew:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA4NSBTYWx0ZWRfX4ZcOG7pPzdAO
 gPzFoH46/sosgqj8jXA+jV+mOWf6/6NO2BuJYiVMcMUzneDXYbCA6KPbxkUKS0DQJZAdF0wH7Hc
 LT/bpWTlR2XuSrQR1+L6kEBX2juSPP8=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015
 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020085

The test passes $SCRATCH_DEV to _require_zoned_device() and mkfs/mount
without first requiring a scratch device, so it fails messily instead
of skipping when no scratch device is configured.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
Changes in v2:
- Wrap the commit message at 74 columns, per Qu Wenruo's review.
- Add Qu Wenruo's Reviewed-by; Cc him.

v1: https://lore.kernel.org/fstests/20260902050145.2439-1-prabhakar.pujeri@dell.com/

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

