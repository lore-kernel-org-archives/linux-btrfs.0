Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331AA360EC3
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859750; cv=none; b=g5li3wJbo71X/SwbW+glDmlYlz7Rly3m443Q8MujiflCYf7tDN2SF8p52hemwvoeN+GLRK6GsR6CrAYPbhOgBAajKxBRLfNt4KeyAbWKmtnZGIYMjlslLyWe5xpEmPrTpkHiy12Q6944WbXH3OIgZOMyoeu8ibGjIZ5Crf7GkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859750; c=relaxed/simple;
	bh=li18msiuwo6d5haWUStOoEZUp2DcPg5MK246aPNG3Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=telmP20IlKaUG5z00/rl4IFWA+mYPJk/8HDy64Ed0I1PTqCUDlnRF/4OAW/Ee9/HG0ji5HNKBcu2/y/Y2lpSsq4rAwrdVAgFwCs4ziLV4PxtjwMm8aDlxUzIKb0oPtUWRJic0W9mEVGHYwIklDeAwgihmLWK20VnPZ+knr81yP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pedIvM0a; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pedIvM0a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781859750; x=1813395750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=li18msiuwo6d5haWUStOoEZUp2DcPg5MK246aPNG3Os=;
  b=pedIvM0a+p/pT/Ar/4VX15ZBHLm1QJtzDh3gONMxe8Ze0ldPA81I18aB
   zNRT4f3wtQO+CuKwUyjbianClzCZLKlHOfwxoaruPHN9Pjz044qUnZh2m
   RYyXp7aDJsJKcMb2NzmDory2kgDkCHJLOiS22yIBzKD3XljIbStDYfE47
   IiiyHSTdRYCTPnu5qRawsg18vmJPo8xFDcMXHhwaLKHZH1CiFyz5SlE5V
   2TYjufzVdeyUhdClHbugo06gS8s8RIOx/Hre/5a5OcNJulXt79U4kbwBx
   8hS3fVEkQo2/PDuJdCIEHT4OtWe1L6Dp53qqAERe28zeiwj/B6IusLLsC
   w==;
X-CSE-ConnectionGUID: W7+ugvVnQCKBRO7rcfxc+g==
X-CSE-MsgGUID: kf1mB5luTbSFwcm3R38aGg==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="147951272"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2026 17:02:27 +0800
X-CSE-ConnectionGUID: CIfc7CaTR46n8UqusUrNeA==
X-CSE-MsgGUID: 9dindfkURRiHvLAflVpKiw==
IronPort-SDR: 6a35059b_qSCmrPe4lfhZfSkmJucztcjzT5drM+ZoiWDnCZEbcb+Bwfk
 5hNJEGN6UEhs7TT4vZoo3X7s7ny6eTk1KLZyFkQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 02:02:19 -0700
X-CSE-ConnectionGUID: IOBbOQs4S5O3RJ0TpGjwiQ==
X-CSE-MsgGUID: BMOHrToxTwqsOekwF8z6mA==
WDCIronportException: Internal
Received: from wdap-62juwqezoj.ad.shared (HELO neo.fritz.box) ([10.224.19.3])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 Jun 2026 02:02:19 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC 04/15] btrfs: zoned: align max_zone_append_size to the stripe length for RST
Date: Fri, 19 Jun 2026 11:01:59 +0200
Message-ID: <20260619090211.497100-5-johannes.thumshirn@wdc.com>
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

On a zoned filesystem fs_info->max_zone_append_size is the minimum of the
device's zone append limit, max_sectors and max_segments * PAGE_SIZE,
rounded down to the sectorsize, and it caps fs_info->max_extent_size and
thus the size of data extents and writeback bios.

For the raid-stripe-tree RAID56 maps every data and parity stripe to a
BTRFS_STRIPE_LEN window and records its physical location. If
max_zone_append_size is not a multiple of BTRFS_STRIPE_LEN extents and
bios end mid-stripe, so consecutive bios start at a drifting intra-stripe
offset. That fragments the per-stripe writes, splits stripes across zone
appends and corrupts the stripe-tree mapping, surfacing later as checksum
failures or -EIO for files larger than a few megabytes.

Align max_zone_append_size down to BTRFS_STRIPE_LEN when the
raid-stripe-tree feature is enabled, so a stripe is never split across
appends, and guard against a zero result should the device's append limit
be smaller than a stripe.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 97f06dd01693..ab386b4afa72 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -781,6 +781,14 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 		     (u64)lim->max_sectors << SECTOR_SHIFT,
 		     (u64)lim->max_segments << PAGE_SHIFT),
 		fs_info->sectorsize);
+
+	if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE)) {
+		u64 aligned = ALIGN_DOWN(fs_info->max_zone_append_size,
+					 BTRFS_STRIPE_LEN);
+
+		if (aligned)
+			fs_info->max_zone_append_size = aligned;
+	}
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
 
 	fs_info->max_extent_size = min_not_zero(fs_info->max_extent_size,
-- 
2.54.0

