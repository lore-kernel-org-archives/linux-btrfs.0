Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01C835DA56
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859752; cv=none; b=UWpBbNz7dBv2reZoIfU7EnFMpiBTQSx1gkt1cptXnb79KRa0+DmEecArVYFjIQ6HcUjxa/GvKVt2kMBUawABqc9A0ar7HHCG4QRyLHW/+U3jqGULVcQJmR28RKF+k6oKWvRY94FijvwAABFfsdFKRzkOa6m7FdWhhbBaH317VBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859752; c=relaxed/simple;
	bh=JXyqD2ARR9OnNFzCw3Ug9eKHuVOcWjjp4PWm9BTgWk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC8tYNBdvwjZWjzdJoYWBHm+xPzoB0s/P9/JpWbIAKU973yMG0+hr/cpaUUuVM4GXnWdBIHPwuljz4qXH9tzn7fprM6iPPkSMgN9wnbU3aicy3RF9zc1mh6wwaeaN8ahhNfoquBTeQGgmWSKcxSf/DBxzbfs+Qw7Sd/aHH6n0Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F12q2DiJ; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F12q2DiJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859751; x=1813395751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JXyqD2ARR9OnNFzCw3Ug9eKHuVOcWjjp4PWm9BTgWk0=;
  b=F12q2DiJsOht5g9uTAUvjHQQKLoB+35dTqLTHLD7G8liLrG/ttICP4To
   4DQQ03NDgBXui/OihMpSwUexbx0fZXqcTtdzGZQ2aySpbQSBFfMxBKbtt
   qhszzQtQ3kk7uUnTLKhVr1EnO8i3FvQXqlpzQPsNxSbz/+kKl8UfmcOLS
   kzqqUknO8126GSR7rxhN9TkET6Gq/eaj2dcRskE0j3vqJTjNY23utHDjY
   KeOzFKoAlX+h5oG+pW/1PXJzf4BWuAl2AOIKqzF3koenEv65k2rjVsbad
   jM21oACP7Ytn6gzpi92Kqx2cItFtRt9LPVM1pf/7y6fYQj3hDWSuIhzP2
   Q==;
X-CSE-ConnectionGUID: nsJu0+OKRcaOw1s3WBHCqw==
X-CSE-MsgGUID: WUL9EAdVSjG2wD4XoWMm7g==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951275"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: tXxtW84oRoaQdrXgl5oxNg==
X-CSE-MsgGUID: TotmqO37QPWd5A1f1xo86Q==
IronPort-SDR: 6a35059d_uDC+wthiJM4eNz8LrtX1Birio7AyZG6Ve6BqL955tgA37LJ
 oIwTq3bBoKXiCSmpW6+Hxy683b4C3c4a6q9rXGw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:21 -0700
X-CSE-ConnectionGUID: YlX8JzllSlWaOVx4yto86Q==
X-CSE-MsgGUID: 97FAIxSTR/ijT9lOzi4F+g==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:21 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 06/15] btrfs: allow RAID56 for data block groups with stripe-tree
Date: Fri, 19 Jun 2026 11:02:01 +0200
Message-ID: <20260619090211.497100-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add BTRFS_BLOCK_GROUP_RAID56_MASK to the set of profiles that update the
raid-stripe-tree, so data extents on a RAID5/6 block-group get their data
and parity stripe locations recorded in the stripe-tree.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/raid-stripe-tree.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 3c67d814640f..b1a26e21b0d5 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -14,7 +14,8 @@
 #define BTRFS_RST_SUPP_BLOCK_GROUP_MASK    (BTRFS_BLOCK_GROUP_DUP |		\
 					    BTRFS_BLOCK_GROUP_RAID1_MASK |	\
 					    BTRFS_BLOCK_GROUP_RAID0 |		\
-					    BTRFS_BLOCK_GROUP_RAID10)
+					    BTRFS_BLOCK_GROUP_RAID10 |		\
+					    BTRFS_BLOCK_GROUP_RAID56_MASK)
 
 struct btrfs_io_context;
 struct btrfs_io_stripe;
-- 
2.54.0

