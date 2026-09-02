Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624F23914EE;
	Wed,  2 Sep 2026 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333085; cv=none; b=EDKjQh1Dr/kq+PX1+MYpEWBiSSsyEdyLwJtqtEpUDqXVcU2BA2l7eD9XafMAviriduM5lTwOthjZ7dCY2klvobVtS7PZr7smCkby85x/h9AZbbZZOc4kniOdDN1e3PYtYV7bXXIPa1CAQ3piC+IijhyhJ+n+lrYHxKNZ02YyV8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333085; c=relaxed/simple;
	bh=uI2aveXHYKVB5GiQ2bqm8ADcSSTmbjihfTSHxTtEMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V76VZl+xt5AcO82c2Jl9V+hnYzh9B+zAOtuZG/MlHhmVkd5J6CHg1XeGOOz1+JHyf/3hEqEBrjUF/VxcK54ZSpai8LMTEUn7g9batkGbdwOzZvTgP4iFqFt1asKIm96nhOza5BtdhLNqOZK9d1t66PcyaU3FHus6lpmaW5eK4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=t7qcZh0K; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=PnM1xE1i; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="t7qcZh0K";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="PnM1xE1i"
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6826Vb7m062662;
	Wed, 2 Sep 2026 03:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=LZxawOXGFvNcXfBsRsK+p1Vpf7TZQQo6pYlY
	FHf5lrI=; b=t7qcZh0K391pmO8PlKRqCISj7PUx8okVIq9iKDpKT8m8SKOIbUG0
	SSt1hecRCgpbHq/wJBUaT15uarQDxAsXPEdosncHz/Mv24+JsjZxzL3KDZi2lXqK
	7hA3PJk/3Utu5sPJ2kI+2Ua1ppyspYiioZflt9A9gX5ZdnRuvD0nG4IjMhJJ22F8
	h2cg9xsDPDhYgtMx8U2RKBrB6oGOlEAQTx2yTJhjnqYkINXnNyRcXjj4sEOdbrls
	hbr4wZuQitHXxijz5okeNiW50wLNOJEdeiO1XcxWn7W0UR9jmahQiPmN1R9SAZDs
	WLzaN3gLUnmfKBZQT+BYK/zcNunEj9iijA==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gbuee831j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 03:11:23 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6826XKK3079139;
	Wed, 2 Sep 2026 03:11:22 -0400
Received: from esapsmtplv05.us.dell.com (esapsmtplv05.us.dell.com [143.166.203.153])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4ge92pc0c2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 02 Sep 2026 03:11:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788333082; x=1819869082;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LZxawOXGFvNcXfBsRsK+p1Vpf7TZQQo6pYlYFHf5lrI=;
  b=PnM1xE1iU8VfRw4VyLNhbFjCUgNe1hR1/6yEyRwyMKgHU7C9bNrBTpYm
   gJBm/+g/j9PTBVKynHaRn5hBMOA0Yd1XBHaLpFG01IZMGRROx48WpgsgF
   z9/4owhA5HTjAwzgjEZreeWApm0dRIpvsRzdgIKcgI3o37GfTDUtsL8H6
   RTT3lk4ItLLLqCYQ9XCCFRJ13I40Kjfml/PBGGK0nlhLlfDb9O5PNNYxR
   3q/V6Tt/TdXpfq/znDFMKNcAxWBWYNXxm/h+S4dTFv7iZBS46CrWMtjQE
   sGeWgw1IejBWcktUH9XMj9EpEWfZHDP62TshxLD66Ybs3rmyGnfjzAy9F
   w==;
X-CSE-ConnectionGUID: aHavFecKTtqCCrYgMHmVIw==
X-CSE-MsgGUID: 6KdKRDYdSMGaz8BDhxpPHw==
X-LoopCount0: from 10.94.14.196
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.14.196])
  by esapsmtplv05.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 02 Sep 2026 07:11:19 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: [PATCH v3] btrfs/333: require scratch before checking encoded reads
Date: Wed,  2 Sep 2026 07:11:15 +0000
Message-ID: <20260902071115.4711-1-prabhakar.pujeri@dell.com>
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
 definitions=2026-09-02_01,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020062
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA2MyBTYWx0ZWRfX+RcgJXiQsQVy
 b2ANvtmLfOfcXH/ZXHDJ1WPiAsdwK8v3NbvREo9astfiTyJtLPAgjHNyIM6b5t3ZINseIygWpP5
 +AjkZ8AdbTyqUSaHPaJ4GqluIW9xgvE=
X-Authority-Analysis: v=2.4 cv=FbUHAp+6 c=1 sm=1 tr=0 ts=6a97cc1b cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=t4Iba6VQkoKuxR139xjPXA==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=PpEg0BoV_A2aca28hXd0:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=iox4zFpeAAAA:8 a=EwHIQIwI0FVK92YP5MQA:9
 a=hlJyneSgMmFPbskH-t2w:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: 2gEad4r4YkjsZOsdAapfCpBGFi3HWwZp
X-Proofpoint-ORIG-GUID: 2gEad4r4YkjsZOsdAapfCpBGFi3HWwZp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA2MyBTYWx0ZWRfX2qWsdLOwX8tW
 6ve9P6MClJMHf+ZSYDxQ4gmWUOO3ezZoBtbEtyKMO0s1BLOlqbUZE0EOdg8eHs2cz1XFZd9oqRm
 WXJkc6pCeKFAEmDhM/0jgHkvy+nTu0xJR5uEgakDxIYyp16gWhUIOKckbfgMBFfXeRSyP6Yaeeb
 u4UNtqJGR8n9tHORYy0TkdAQpWZmxz+uVQTngYQSVB3hnw4+uXwAdbbQCBLNaXdAyqG180WcvCe
 +1DGN3FP/+E3qj8D+jDdIyqubhD/htoqn0hpIWK6fCAmNMJbBiwYa6RQSFLDK24zwQfMEUmbDAq
 92gBewr8SKowWWbMXI5VwN+Nc7IHpWc3yrcSKNUKAFEG4yerRJAyRI/2icIewLxeS//Dy/GrgBc
 TGrtpvaVU9y1fThCqX619ak/Sf4ROVyafMxjkPmqd+XR5BJ6Y/4FjCTP1QtSDeiDZKZ48BN/edB
 HTp/MumPYSdoXy1vwQw==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020063

_require_btrfs_iouring_encoded_read() formats and mounts the scratch
device while checking for encoded-read support.  Without a configured
scratch device, callers therefore fail inside the helper before any
scratch requirement is checked.

Add _require_scratch at the top of the helper so that all of its
callers skip cleanly when no scratch device is present.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
Changes in v3:
- Move the change log below the "---" marker, per Qu Wenruo's review.
- Add Qu Wenruo's Reviewed-by.

Changes in v2:
- Move _require_scratch into _require_btrfs_iouring_encoded_read() so
  the requirement is enforced for all callers of the helper, per Qu
  Wenruo's suggestion.  Revert the v1 caller-side change in btrfs/333.
- Cc Qu Wenruo.

v2: https://lore.kernel.org/fstests/20260902033310.1698-1-prabhakar.pujeri@dell.com/
v1: https://lore.kernel.org/fstests/20260831104200.2269-1-prabhakar.pujeri@dell.com/

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

