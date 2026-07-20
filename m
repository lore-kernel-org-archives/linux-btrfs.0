Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9955330D22;
	Mon, 20 Jul 2026 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546358; cv=none; b=sWBN99AbW3z5UK7lALkNlzdY29G/111MRWVoHlNBPDxC+vJVF0HshiXfjOaoJ+7Wr6M6O4Si4KBUJ0jPMdh5XLwjIsrXjfbuD3JXmh2oLCNNqttfOkLm6eicHJSNF8jD9R2KWjRMXfobNm/ObXNw6ioE2QYpv6i+kAILOZ8PQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546358; c=relaxed/simple;
	bh=24mzGDxXh2c1EAK8i2AdW9WnWlDwGJqAthP917bjLA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt6jRMyB/D6oytawLG5FIVSIb/U0pF68KskduMOd7aHM4nn2QaAZb46U5HOtXeNWVh4qf5kxW3Kq32gufm8uzGguZHTUS8LWbJdNX2p0HEsdwQ/IRFPbprDA4NQUdDWN/HHFWyyxyC5VO6jqcWrGBOuSabkJ2y3hEsS1vz9CI38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BHsRgEdP; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BHsRgEdP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784546355; x=1816082355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=24mzGDxXh2c1EAK8i2AdW9WnWlDwGJqAthP917bjLA0=;
  b=BHsRgEdP48/vKm3cDbR+Vva6X6U5byU5Qdyve9q4HRQ4YH7ZyzgE7dIa
   4/VHUf+3K8nyczw4Kmz/cNVD6OdxKMPIIqqxKscGu55Zf35fFK3X51XE2
   RKiSuGGj5cMBl5xkQx2IvDdftFj0FsMxva6jfFNaCDWC7EH8+bG7LUDCK
   FP84wLQLmExanfl76H2U+6GIIvMCRTdnxR7k4j0S9SIKKswmJDVtZ2Wgz
   VucY5grIxXGEkAJEL2nXKqPh/QYYH1fX9Vdyjyz7479kDre3QMCG18043
   L7kUiCjRzOW5Kbx8M3taE3R/u/mrYNwSSv8oFzSVRi67/7M5OviuHkd+w
   A==;
X-CSE-ConnectionGUID: kzAmeRrrRouaVRV41uSUAA==
X-CSE-MsgGUID: uFZJEYCETO+5XdXENKDcyw==
X-IronPort-AV: E=Sophos;i="6.25,174,1779120000"; 
   d="scan'208";a="151105677"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2026 19:19:12 +0800
X-CSE-ConnectionGUID: wDJXu4dNSwa5KhwLMzPGPA==
X-CSE-MsgGUID: 3IaxFiXeQfKErushVF5hHg==
IronPort-SDR: 6a5e0428_6ix/VR3KdORjcEYnMQiBAMJPzlHsw5Di4r59ETVm3cBHHzw
 Br4yqJXjomgaGV/3M8R+UCWtOg0T/d3bKJEhtOg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2026 04:19:04 -0700
X-CSE-ConnectionGUID: OOZhr5C4SOWw7VgoKSH8oQ==
X-CSE-MsgGUID: KBd698F9SAWTNRYSWnGftA==
WDCIronportException: Internal
Received: from wdap-kyufgunycc.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 20 Jul 2026 04:19:02 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] generic/781: fix copyright
Date: Mon, 20 Jul 2026 13:18:49 +0200
Message-ID: <20260720111849.1659111-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My employer is called Western Digital not Wesgtern Digital. I'm sorry.

Spotted-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/generic/781 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/781 b/tests/generic/781
index 575cc4abfb7b..38536d64e3cd 100755
--- a/tests/generic/781
+++ b/tests/generic/781
@@ -1,6 +1,6 @@
 #! /bin/bash
 # SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2025 Wesgtern Digital Corporation.  All Rights Reserved.
+# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
 #
 # FS QA Test No. 781
 #
-- 
2.54.0

