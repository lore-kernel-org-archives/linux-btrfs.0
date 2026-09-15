Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D0C3793AA;
	Tue, 15 Sep 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481887; cv=none; b=mtheLC1ohIDaPCwP5+nWqtc3oMmArApiALi1nQBWx+5ohUt6Hn9mIJT0im4E1omKEtwKVM7vvKkOgcK8k+6DFDyLU7iW+aWeTDQYgVV6A26x9I5Omslub4gfG6JfzEisqFuJBmkIG6amQCeEM+gnqktZvwkP2Vl8j3jSP6WYrwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481887; c=relaxed/simple;
	bh=nuH298LRdUWAWfbo3i7dhR3LXoM9+IsAamTXytrVkG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXGiI4V9TSx9H6rHDTYIcA9+cVVg66M/+WDqizRbOUBpMFFbe+0lnXHkf5jlY2VALokFZAuIXgeQGqOwv3PrN+zIr/oSXWzYKNnTjs9oRgDYp8MSG1YgeLoRNOtRboH51HqBWOtZv/9f7ZseR4XQf8y39e7qcBf4fKqJnoYkwos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=kN4p1cpj; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=gaHcCpfR; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="kN4p1cpj";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="gaHcCpfR"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FD1XE2512348;
	Tue, 15 Sep 2026 10:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=j8iQVTD2FyoZ
	TrUVXLIwVpNJAp18kB5y/Acq4NWVeck=; b=kN4p1cpjnu6/xWSYhSCW0tXugkKB
	q9E5hDMKIxNBge2icV8M4IrIhVGcVISAKgfa9Y3cfP7dkzMnnPxjNgefyahzxkkW
	+22GGDO0WD46OWT94LvZFGRpzgBok7zHRsMhskHBg9lhbjfSXXxcpkBeLsge91fD
	8mZefreTvX6Y+otOx2mw1Jm7Vk6FED915/lk0F3mjHFjQGXcqPnumTRXGSDCEDOc
	2K6jKwuScYFH3TCgJn0qVwL1jG5/PJ1bACxaRwYI+aCX+K2WGti/WKD+NOVvakAd
	r0/UAOTzYGpEFtZVN0T1XAfkTadx+ZcLnhZsSB4RLktqvW3nioNvSVr8LA==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn1w7usjt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 10:18:04 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FDxS9H3661268;
	Tue, 15 Sep 2026 10:18:03 -0400
Received: from esapsmtpat02.us.dell.com (esapsmtpat02.us.dell.com [143.166.211.150])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq4m0k5v9-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 10:18:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789481884; x=1821017884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j8iQVTD2FyoZTrUVXLIwVpNJAp18kB5y/Acq4NWVeck=;
  b=gaHcCpfR5ySymU7ZiR902o3eDWEENJsOUu0cGxZGqc1Kk3rm4SUJZW8u
   Xkpn8T0Hs3/+IYKJnA7JedrYSX0+wOojV5TUa7Q28FxUNs+N+sRXbV9sI
   NnzSThANqR0Q9Oj+4ssGrHbQYmwQCdM4Hpe6w9NoQm/ufBhrO26zJb5R6
   Y9smkNVdjym5E5mHRQANlHYedsl0yx/dgOajSQTyVliYiAl/FU1gBl6GB
   rWqluYVlQtnt2RzRoupP4kk3IDJczgA/realBYOKXpy5PARZjzqchZIcl
   85pHFv+xOffpqTeUoctqyoe3Z3OYmcHULo2O6JCS8IXQS0FQED+j8jQNE
   A==;
X-CSE-ConnectionGUID: 3wFfzbqrR9KFvjmhMpasAw==
X-CSE-MsgGUID: gBxxW5L7Tu+b5iivGemuaQ==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat02.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 14:18:01 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Qu Wenruo <wqu@suse.com>,
        quwenruo.btrfs@gmx.com, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/6] btrfs/333: require scratch before checking encoded reads
Date: Tue, 15 Sep 2026 14:17:43 +0000
Message-ID: <20260915141745.4299-5-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
References: <20260915141745.4299-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150207
X-Proofpoint-GUID: GGifHUcriWgsY7i4Clq_WxYjEUl3J3FL
X-Proofpoint-ORIG-GUID: GGifHUcriWgsY7i4Clq_WxYjEUl3J3FL
X-Authority-Analysis: v=2.4 cv=e46T2qp/ c=1 sm=1 tr=0 ts=6aa9539c cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=i8a7nF7jFa3EbZrjgrQYpA==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=m3zZTHMLHbwB7Lmtoed2:22 a=iox4zFpeAAAA:8
 a=iLNU1ar6AAAA:8 a=oNaMta7XYEjnxCRIwMoA:9 a=zgiPjhLxNE0A:10
 a=hlJyneSgMmFPbskH-t2w:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfX3U/qManGSvXw
 iFvkKbBLARFdQPeI2V+WJCsTh2x7u218CBpvhVMBULImiCTDB+9yPHCqgOtnol9kjgNzG4Il0F/
 paeNlx5B/lMTMEVKl+khKpgmIxLBetg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIwOCBTYWx0ZWRfX4pROi7Wizs3B
 4NLt8IrThy0f9YBJnGAvPpvFX2pB5vg9fJu306zXmH+TwS8JDCz/nRVud3Bj+nY5gGqtXE5WKEP
 TtkfAXMcsiM6G9IbMq29zVMY1TmUaLr8V5uqNyJRL1Hx71zP9Qvy6TY9LsXZiBurmCUvVDvFR+O
 DdzDNSzV2eia3YSC7zy27s/8JIKtoDEi2g5a/18nNlY8qzYkzNnTtAzsDNanVMfNUWuFJ63Jkq4
 J2e9AsA01mg+1iQHtOX7FSEb+lODy7qZCZ/8NDdKPnejRbV2joWtSsOv6MdSGd4JHRbMCrS0oRN
 ouLqpHzX+b5yC01dIvYd0EKdTtR2TnSa88q/WeIu3qR9LgY+xXBniRPSK9P3NJOyc6QCY238wiR
 5hM5NJgroicnb8jK6Fz/PdMYuIS7clZVQkc9QgsPlTiSQXHcbn7ziyi/z3cVLkAVHzpdn/TutEC
 1vyuaxDpMAQYD1lDuIA==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150208

_require_btrfs_iouring_encoded_read() formats and mounts the scratch
device while checking for encoded-read support.  Without a configured
scratch device, callers therefore fail inside the helper before any
scratch requirement is checked.

Add _require_scratch at the top of the helper so that all of its
callers skip cleanly when no scratch device is present.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 common/btrfs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/btrfs b/common/btrfs
index a75fbf1c..ccac8626 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -1055,6 +1055,7 @@ _require_btrfs_iouring_encoded_read()
 	local tmpfile
 	local ret
 
+	_require_scratch
 	_require_command src/btrfs_encoded_read
 
 	_scratch_mkfs &> /dev/null
-- 
2.55.0

