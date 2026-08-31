Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665634CFC2;
	Mon, 31 Aug 2026 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788172930; cv=none; b=q/vgfBcNRH0BQDxTXl7zTD7bF/h+EOt+5lqypcbk3VjVSHBc7rlhiNYLGb1rqSlNDCRZF9qwvQbAia3ajZnxLGC/Nvg+4CLeaLdMzoKtQ2iIA5Hxl1i/6k6DFjjX50oWpHXMEPRBLwab9K/w6WY/eoq990s6DmaJtAkhtfyS6LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788172930; c=relaxed/simple;
	bh=T+L1FWh7q2CxulVYExOvZeU9/t33wRwvz3J0sN0PlJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cJSIqtjhB9ehgLO3hPfKjoTdNcyqCRYZ2MuDJX3gVClsaK5vZ5piHB+SYVnO2lnd6YZoCRZsWVeFU0AF2iDXvFCi6GW3ukB9/BycNE8Cj3O2BNaMl0Wam7ANLNLnjhoGbIV+3llIh5U2IlOU12TAzJ4vxHzF9EyAgyqVlrXQB8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=U1Y8a31Z; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Xpsj5Bwe; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="U1Y8a31Z";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Xpsj5Bwe"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V7wrod2779774;
	Mon, 31 Aug 2026 06:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=moMN0fKAz6ITP1DIUMuMj0/Q4hvgJvdO9y4H
	UzP4g7s=; b=U1Y8a31ZLfsG7zdV3ZhqGI1/Yy3S8JHrs3wYlcqwMJD8/NqEKDvt
	OtYWUZkYZZzLczeVKZ6hBOeIehdR5fgwPio4TioDfc3PVSdqmFPYwJwBhshBxVHH
	rVjEngTjJnREd6axRTtea05uaiseqX2yF75flWw8mWMb4lc2mzmiHYIQyhPHgCML
	6O2gc/0GL3wocDeaKiQXxsGIQ90rnz1VmXG4GFeG+vvpfg9q74sV1oTxdG2FKE4r
	u4djGXpoGaFn6eC+ytxayR5mTRuRbu1EY+Z8owx5gQTnVEnPT6HpXPk6Pc7DBRK8
	ZZ1Gbc9ZGjz5EMEEQdIrH0blWlDtA263lw==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gbtk6wevx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 06:42:07 -0400 (EDT)
Received: from pps.filterd (m0144102.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V8PdCk2742967;
	Mon, 31 Aug 2026 06:42:06 -0400
Received: from esapsmtplv07.us.dell.com (esapsmtplv07.us.dell.com [143.166.203.154])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gd63g9dpw-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 06:42:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788172926; x=1819708926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=moMN0fKAz6ITP1DIUMuMj0/Q4hvgJvdO9y4HUzP4g7s=;
  b=Xpsj5BwelTJXVAJxzU4T556YjJEQXIOGQGFygXpFBWnoQsDQB0qLbfVj
   thHnjorpyBZTMZhPxooFVb1cmpq8vzy1vkCDktgeRH6oG+GTJDvQ4xWF+
   wdP6/E1CLxuLqUdQ6T0HpXL1OhcFkkmp6xNNJbRZAvdVbKpkKQI9RQslC
   HTfa5vyTwVSYbAkTLmadjythPYKce22MdLjG8uxksmwbX5X5tBWF8kbM+
   RmA7jiuQU8+1aiF0t5a0PSiuNJhhrX72MtXh8kXO+2laP+dHCC6cGCo0j
   bFeQFbWCt0hDTPNNFilFT2HEjJvaNimtJvkuG8EXi4j0SzY3LOnGm7i4v
   w==;
X-CSE-ConnectionGUID: eOvWxjjxRZCuNSa+MiecPA==
X-CSE-MsgGUID: BNUH9jzPTK+6UXNrR6tepQ==
X-LoopCount0: from 10.94.8.206
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.8.206])
  by esapsmtplv07.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 31 Aug 2026 10:42:03 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs/333: require scratch before checking encoded reads
Date: Mon, 31 Aug 2026 10:42:00 +0000
Message-ID: <20260831104200.2269-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310091
X-Proofpoint-ORIG-GUID: tEP67kPDArqDVMDtTj41Os-izqX-K5lc
X-Authority-Analysis: v=2.4 cv=PL0/P/qC c=1 sm=1 tr=0 ts=6a955a7f cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=FlBIjDbFArVVlnHZBJJA7g==:17
 a=Sv0fKeRqtYgA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=m3zZTHMLHbwB7Lmtoed2:22 a=iLNU1ar6AAAA:8
 a=N-L_FQ8NQ9RuPFgcjEUA:9 a=zgiPjhLxNE0A:10 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA5MiBTYWx0ZWRfXzK/SfcIy9pRV
 KGEnONDJQDXW85rtDGs3NdsrdWWrZxNpAwP2eDR6bvCbfqllTjkbNmJMH5FqAd8TjUCILcVM01O
 GzNpzqvzNz7wrvuBbWCVftGlAOb52jM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA5MiBTYWx0ZWRfX26Ed/obguZGo
 k5rsJ1uam00TBtQwINlqa06drLP2YgzB8L0rb12QUeDI6Gasa2qtYAi0UOya0x4iinFtD4usdoP
 MHvEpjJZtuSyg+gsgmj9yH97dmU3odWNrdk588mhYdP84f9fGgqqHlpb9M1t80dqFZWLCLHfIj5
 79jI89g+3hsZNdWkldLX2TOPnffdcRKiBmwAXlM0bEibcGZtjesGZt3xFX8pKefIQJGtiXCN4Vm
 ZG7po6oSCL/U8+BFoQ3dXBRl/B5Yr5rgojbjVW41/vs5R70CTAq5X5xjdeM4ZeWrJqjDl1lVHXt
 nmfTINm9dW0bazYjmqZhtEhqQ/05pTuO09JKbsE5HboU6VMEPNBBAEu6ujZGk1GdbUFNoXgmMw7
 xnwBjBT53j3QLzL4VWvVL/Wzw3o7dkno0I8n297vO1W43VlKPRAULv0iccNjAUX8PDNJp2WNfzw
 LnkgOKCq8M2QmXTO2tg==
X-Proofpoint-GUID: tEP67kPDArqDVMDtTj41Os-izqX-K5lc
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 phishscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310092

_require_btrfs_iouring_encoded_read() formats and mounts the scratch
device while checking for encoded-read support.  Without a configured
scratch device, the test therefore fails before reaching its existing
_require_scratch call.

Move _require_scratch before the encoded-read check so the test is skipped
before its first scratch operation.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/btrfs/333 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/333 b/tests/btrfs/333
index 6214d7c..9dcdf1c 100755
--- a/tests/btrfs/333
+++ b/tests/btrfs/333
@@ -13,6 +13,7 @@ _begin_fstest auto quick compress rw io_uring ioctl
 
 _require_command src/btrfs_encoded_read
 _require_command src/btrfs_encoded_write
+_require_scratch
 _require_btrfs_iouring_encoded_read
 # Encoded writes are reject for inodes with the NODATASUM flag, so we must skip
 # the test if running with either the nodatasum or nodatacow (which implies
-- 
2.55.0

