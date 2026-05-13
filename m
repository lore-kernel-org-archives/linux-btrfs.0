Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986653932DE
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675797; cv=none; b=IzymBtc7LFzAHK4lqdZANz2qeWEVOILr5weGRtyjryfNZoP9uW0bI7H2iyl8WS/9EbnW5hqtW3zV8ts5gFNfORGQj/ZfZnwOt60ivX3QhdQmiu2dbTzyF4+5JxQ/0bYtpc7r6kBS7bUAWoPfG1BS80Cow5bAMeDD1L4sjQwFQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675797; c=relaxed/simple;
	bh=0l+ziYlRDjP2Zyzl6gHNrYAHjrq6RY040r6ga3U5Jas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGbxahXCHqjyW7VS7GpGwfuicdysGYiD0f59S3dIhslfpqq3webWkZ0mv9VF13kSKDmMpnvs/Pm+v1gKaluYYmgoBY8fmvf1HiRC2FfQc0e7ZKA46Uzu37uHdRXBtzf6R2nXhxdMVIAQjgKfNp1nj89Ma7+eXpuygHeon9RueCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WOjSob1M; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WOjSob1M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675797; x=1810211797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0l+ziYlRDjP2Zyzl6gHNrYAHjrq6RY040r6ga3U5Jas=;
  b=WOjSob1Mx4c4xr1uRjxvIDQh+CHGuCRDS7LJg93C+yD0GVY/Y4rGFtb+
   pvC8PENQ19HRjBGaw9C48r1x6D/iSnLcxFYg5TF6Hc8PXbQEDtC5UwanG
   LcyAeR1leLEyhT6jmXpYuYNYcsoLbENPLSVnbECzAxwRnehaJHi+ZVO0d
   yTyYqjIRsFkgw7oObwOG59Hgw3kGdZFmnTtv/PXW9eunr0WLhr75aXJuS
   N4dRxTsFeR43YKxS50NGsLBmXaZq2jwc8YvCD/Jiqx2NDSzgC9n0oCIst
   u0z+uRQbS0Rx+RongnfNdXW+AfhEc3TOspTAqR1SrKp91M2cWnGP/bAfi
   Q==;
X-CSE-ConnectionGUID: Cj32vsF6QRiSnS5MXBmBQQ==
X-CSE-MsgGUID: C4xCQ5oiRzKeRAPQGfikuA==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869035"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:26 +0800
X-CSE-ConnectionGUID: rH42eA5wSZuxdD5cipchWg==
X-CSE-MsgGUID: 7TG73m/pTMmsgnMmJMtCgQ==
IronPort-SDR: 6a046ffc_hblOqiKNrBEubxfsZk+6fmexYEw5LicQiQCH4KDYhdOw5vx
 lNIkKVgg22YkHGoWA2I1MFJMiUyI+XLX1yhYwxA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:07 -0700
X-CSE-ConnectionGUID: UoAGZlNKSuS+ctWuBMvVng==
X-CSE-MsgGUID: rq/VDo3kSNOiAOHHJlmQTg==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:07 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/7] btrfs: zoned: always set data_relocation_bg
Date: Wed, 13 May 2026 14:34:41 +0200
Message-ID: <20260513123445.43197-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When searching for a data relocation block-group on mount,
btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
block-group. But it first checks if the block-group is empty and if yes
continues the search, and then checks if it is the first DATA block-group.

Reverse the order, first check if it is the first DATA block-group found
and skip, then check if the block-group is empty. This enusres that there
is always a DATA block-group set as data_relocation_bg in the filesystem.

Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 16dd87aa06f2..0b80b498fb85 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2784,14 +2784,14 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 again:
 	bg_list = &space_info->block_groups[index];
 	list_for_each_entry(bg, bg_list, list) {
-		if (bg->alloc_offset != 0)
-			continue;
-
 		if (first) {
 			first = false;
 			continue;
 		}
 
+		if (bg->alloc_offset != 0)
+			continue;
+
 		if (space_info == data_sinfo) {
 			/* Migrate the block group to the data relocation space_info. */
 			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-- 
2.54.0

