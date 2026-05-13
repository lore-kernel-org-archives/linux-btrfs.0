Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67A41B373
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675798; cv=none; b=igdondkyJVcqQdlSJURDi3zZZwx+s51UjdmoxRHObGqKRKU/7YunTPTHJeneETgnR8tR+XcURJiQcrtYQfNFrUX4h+acoajOrweDLjw5Gl9xAXpDI/7UzpH201KyHMBSlhdxayZl/cNMmbwU1TgosCLi2ys9pi/nw2wQZWRc2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675798; c=relaxed/simple;
	bh=0s75Cv6HGPJeTAykvSRmBEp358efltskuQZVX+kEhrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwrxzqIaUXetIHrh+DnP23ZGr0KJiaNAFdEKvngYU8Bd2lSKTxBzwrTpYxUXjGnZ9YQLDRNDYgLEbQ//kMiTO1VbjlkIwSD5yjpPCzdiFib3eEVelMvzrJ1OHwnsxI9crpAW5CflzW/F6suCoG2OoWJDMydW9heIeOJdI88wVFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=D2jOQM/f; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D2jOQM/f"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675797; x=1810211797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0s75Cv6HGPJeTAykvSRmBEp358efltskuQZVX+kEhrg=;
  b=D2jOQM/fcANJItuZCSdrOjFLkCaRM4G3E0JmkZLAOlVLhfTr4TnhUe+1
   1CLevYhhym8zha0AOWsRPOjLwnrsSBIUvttsqJLICFUYpWe2mhxnBwNgb
   PZMTuSaXs0ey9EkFhkOBd6R4SqB7XBXHVW4JaUzk9vJ11GpemBwDef7V1
   36oDIjjcalatiBcg6kN6M4X+hx0EASafbLszMajOhtJoREiUw4lBYTC1O
   6vM2Nt6WwMEmJpfErARqPhySTFSgBRkQ/PJOyO0PuCbSKnZxBVakGY7k5
   GtbEZzMHPBmqmDPKmsKQjWMFgnAu+kTuWRqGOwYYO1zBBURxhPEVTXEwq
   w==;
X-CSE-ConnectionGUID: g7xePx07SD6u5csEVJegjA==
X-CSE-MsgGUID: LLR5209tTqGxuXtqE7AnBA==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869036"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:26 +0800
X-CSE-ConnectionGUID: mztByqKGQEOpYnIbf8I+cQ==
X-CSE-MsgGUID: 8ta6FgBsSwetSx3acK1umQ==
IronPort-SDR: 6a046fff_dsoZxHsXTxFx47ML7HY1n4jMiaT9q8i48GBQI5c5kJbPBjI
 v+rfG6CQmfOniZ3cTc4W9uzlqBMTr2y6YRU9UkA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:10 -0700
X-CSE-ConnectionGUID: Dryw4l2MTjaldHQ4EhHLMA==
X-CSE-MsgGUID: aFFHBXr+Qky3uCFDjgkADQ==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:10 -0700
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
Subject: [PATCH 4/7] btrfs: zoned: don't account data relocation space-info in statfs free space
Date: Wed, 13 May 2026 14:34:42 +0200
Message-ID: <20260513123445.43197-5-johannes.thumshirn@wdc.com>
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

Don't account the free space in a data relocation space-info sub-group as
usable free space in statfs.

This is misleading as no user allocations can be made in this space-info
sub-group. It is only a target for relocation.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fb15decb0861..a0dbc0d2213f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1739,7 +1739,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.54.0

