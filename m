Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5482E1746;
	Wed,  2 Sep 2026 03:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.137.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788320000; cv=none; b=Hn4R9IHe7lmJATmkOztrG1o57lfUnkXJFTNGJwEwePkRTQjoEkMuryGpivuzFhMqXIPabv1igvMcEUuhk4VwbR+CntP5XofSsvM9hej3UnzT7a3+qIKwwUBiHVHKY60KEF6uS0oBL7kvdS1sGzYBxx2zizePsWyRP0ajKXZ5Pps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788320000; c=relaxed/simple;
	bh=064Ieci4iVAZ6XlHEIoNfB3zrBQUfeYYnn16rUoii5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ns+vih1OEbNCBxnW+cq7ufXtShwJ8/8gxWu/ifFqr0tWf7jXSLYr+4GELSMrLZN3f2dvanXiHB/zJQOP2kj2+OuGZBW9jUg11EK+xqQfRvjo0WLM2IQnznFXIlA+wdfjkE0cVqtl8uODUgT1xvpRHQjMO6TlnreqPwTIszTVt/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=infQhWoB; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=E+YxXrCM; arc=none smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="infQhWoB";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="E+YxXrCM"
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681KSEQR3274239;
	Tue, 1 Sep 2026 23:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=smtpout1; bh=jsq6GKKYrrEXq7ux/b2H4jgpxx6/PJLP//Nh
	pDbxN1o=; b=infQhWoBZsL/FzVnvAM4ABq225OGfsY/qqydGUR3vo80vBuSKa7f
	7X6hCOYmkiYXfEn82K07rs4FuTSf5WjMPbjJ1JzThDrB9f22U2hymScqhUoq7lKK
	FYWyH3o0wbiegzKF/ru8dBNURT6RdUoJctpJsf5EJTw2kV9fjIvNoBONwPibTuhL
	bEbpetM0EPy+reBpZxXK2vedCAzFk6rlKCIp+WRhDDyrD6HjN0Z0Aa6rMayZN1dz
	9La5mM87A9eUjEn0VEcqT0NvKJBa/XkZRyvezyWQ8S0gCDK11kJOUaxCGQKafxzV
	ylfMtDqiE7/UbMbWq+0qPURo/xBeu0eDTA==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 4gbrgqfvct-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 23:33:17 -0400 (EDT)
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6822s7LW3193805;
	Tue, 1 Sep 2026 23:33:17 -0400
Received: from esapsmtplv03.us.dell.com (esapsmtplv03.us.dell.com [143.166.203.148])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gebe38bj0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 23:33:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1788319997; x=1819855997;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jsq6GKKYrrEXq7ux/b2H4jgpxx6/PJLP//NhpDbxN1o=;
  b=E+YxXrCM6Zr+AXsP2ED4cl0sWXBgJSqI7h7DJBV8wKXqysluf+6sU6hk
   GrhG9lUZ7AwajiCiBr3wTTD/5ltY7Xby8hK6g8MFT2rFXGZp1YggXCQdY
   tjMaD/54Y6R/xlQTqMJTxGyCaGGQkJ3T1UkPjUzc3cjV4pbReMjJO0Rv7
   5P9gbAiyZj9MD2IwsIAgcHKvL9MvtkrtYRdHCpxuI+aW3RF4ePYHW5FC8
   wT32Zl29Uh/M8Yx4uVIgBrLw2+WPOTiOLvqNmnXDj85PtoYcspfPwOGsH
   zOjYRonN4vT3bdM53UDbFogh8KneNf4LWSdLfwDz7EePhRNTSjFA11sKF
   A==;
X-CSE-ConnectionGUID: iNP+Ie4hQ9eG7ynnSW4U6w==
X-CSE-MsgGUID: A9RBtHBGQFefR3T6mNaTMA==
X-LoopCount0: from 10.94.14.196
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.14.196])
  by esapsmtplv03.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 02 Sep 2026 03:33:14 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
        Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs/333: require scratch before checking encoded reads
Date: Wed,  2 Sep 2026 03:33:10 +0000
Message-ID: <20260902033310.1698-1-prabhakar.pujeri@dell.com>
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
 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020027
X-Proofpoint-GUID: 3Z1gYzT0mVxDTrpbG58TSUPw0RkpMQkU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDAyOCBTYWx0ZWRfX3Fr+uRIWERnC
 S9IFqFZfFDndN3kkz9+k19yqSc5LanBxbl0B/Jgvl3dGh/flUnsxZW59F3ojmV3BweJKJPLKan8
 7/9xY7LYzhhEm82xnZJVzMqBrA0OaxYN2FCh6FrJQ9c4lrJSlMw2Cqq3eNHH5ZkeN6LoUBipNIj
 ki+jpEUKhA3qBIamIScaJJMj/TbdfTphegRuu4yvtWuYr7E/vaYW+0ajy3lHpxfEFTzpkJnIWpU
 tHr28bqFd97KKzSAUs260LQZyRpm5AxfUHgjjwXxZvYulCu3V5NQvP27NR6Gdr3MmHVdQfMBL6G
 q8HSyb962f5xOBsbzwjVjtx3NpEWbMTuyY2BNQHsop1eDbHplHfhC0FefkLVMxBI7LflOYIrriE
 9xCf24ksMJtfdtT7JBSRHA0lBKL7QEUNep17Fpwim7t5EzlGZr4MNPUWAOtc298XEq8t6POXA0c
 9GNwIPiudSmji+xA59w==
X-Proofpoint-ORIG-GUID: 3Z1gYzT0mVxDTrpbG58TSUPw0RkpMQkU
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDAyOCBTYWx0ZWRfX1GdenaNfmolP
 kjgwQ311pDgYMJHUEyWVst/KNFZNcFUhKBhOIlNuHAK8wCmVMj3OGY+6ogJcdF7EPzn78AOTdFs
 pEJ38/clpXx8BgpEZPXVhx/QgrsLagI=
X-Authority-Analysis: v=2.4 cv=IoQutr/g c=1 sm=1 tr=0 ts=6a9798fd cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=iGMIhCliR854E25UHWhNxg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=U3ti1ie9CgboSd2qXsAw:22 a=VwQbUJbxAAAA:8
 a=iLNU1ar6AAAA:8 a=VrkLsc7LKfkCMsSZmd0A:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020028

_require_btrfs_iouring_encoded_read() formats and mounts the scratch
device while checking for encoded-read support.  Without a configured
scratch device, callers therefore fail inside the helper before any
scratch requirement is checked.

Add _require_scratch at the top of the helper so that all of its
callers skip cleanly when no scratch device is present.

Changes in v2:
- Move _require_scratch into _require_btrfs_iouring_encoded_read() so
  the requirement is enforced for all callers of the helper, per Qu
  Wenruo's suggestion.  Revert the v1 caller-side change in btrfs/333.
- Cc Qu Wenruo.

v1: https://lore.kernel.org/fstests/20260831104200.2269-1-prabhakar.pujeri@dell.com/

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 common/btrfs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/btrfs b/common/btrfs
index a75fbf1..ccac862 100644
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

