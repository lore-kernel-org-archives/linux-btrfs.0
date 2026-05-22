Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81683B7759
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779440596; cv=none; b=KadyZc/OmvfDVjVBFKxW93kgjeCNd+wgXn2sCQhy4APh01MP5L7U7jpa8rEgl1ODXYiJgcvMDeqkaZExjnD0Tkcw2UVa8Lbeb+R2bQpfRMJ2Aasys6msq6JT+tuhCZKSFQM9BYiozS/NLUf7zT12U5DLqEwjhhjxjGZdSOz3zAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779440596; c=relaxed/simple;
	bh=6JZoFEBtdIJdwoVungURMWVh7PWDbHUEZxXg0DUyxlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pauM/Tc1I6Mvcd7FLZhXLE1GUIxH/vePry/mDBqoISTijM/Ed20QJaiVW5cIhBo35Ie3BqVj+T+2rUNCmHgUJeFckgaUvB608nJob0y0f2uiyyICzH4JvPMN2Sp5833PO/ahsFk6XE5k1l4p9fypHmxhBh6fgzAgdnPb1VstvZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PIAardlm; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PIAardlm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779440595; x=1810976595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6JZoFEBtdIJdwoVungURMWVh7PWDbHUEZxXg0DUyxlQ=;
  b=PIAardlmi45nQgAWSP18OkpvQbcSfgOzbFAXebRk7L8+20cuGWhellz2
   Hn8Tt4F3KSQmHalbij2ZSs1gTTxe0SLAZejsVTPAArA0B2wA0YKiQuaFi
   OhS8nupxDQBdJ1UbkeOxBfJKGRjilC84fvMrUNgvqtwp4jXhryOlqAQgc
   qe7jMWACMufx6+I/NXGpUA2hqXZL37GHf56M/nm0hObi9/lySjUl9cR74
   v14fPfyxRud/t75PxUyx8tpCmyN/61p11Qu1ph6Hxz1u4+GHU3luBJ0bi
   vPDH3jzz8UbWM8SDSlXmynbFcx6lFUhFATreOWrWyR5eAgaCJLqn7TfCR
   g==;
X-CSE-ConnectionGUID: p9Rx68WIRsKKMHYUO8YarA==
X-CSE-MsgGUID: jvbTkqOrSzidobp6qv9XUg==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="scan'208";a="147475607"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2026 17:03:15 +0800
X-CSE-ConnectionGUID: UO9k4muVSyWhw6cToczLIQ==
X-CSE-MsgGUID: RgVEa2n3SuiYQ4y5TNr0Yw==
IronPort-SDR: 6a101bd2_b1ig9sHSvxehwg2qwFf3dUO4CQ1dFBoiTJiph/L5DVk7KGQ
 hXjNB8bJpPtu38+MgZwp9ajkxhj7EMqcdJG8yuw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 02:03:13 -0700
X-CSE-ConnectionGUID: vdsF1CEETimXDYTwSb9NcA==
X-CSE-MsgGUID: 40ka7D/bQ/uoS2C8AjqZFg==
WDCIronportException: Internal
Received: from wdap-b6euub3vgq.ad.shared (HELO neo.wdc.com) ([10.224.19.8])
  by uls-op-esai1-o.wdc.com with ESMTP; 22 May 2026 02:03:11 -0700
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
Subject: [PATCH v3 5/5] btrfs: zoned: fix deadlock waiting for ticket during data relocation
Date: Fri, 22 May 2026 11:02:47 +0200
Message-ID: <20260522090247.27445-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When performing data relocation on a zoned filesystem, BTRFS can deadlock
in handle_reserve_tickets(). The relocation process is waiting on a space
reservation ticket that can never be fulfilled, because the relocation
itself is the operation responsible for freeing up that space.

Fix this by introducing a new flush state,
BTRFS_RESERVE_FLUSH_ZONED_RELOCATION, specifically for data chunk
allocation during zoned relocation. Like
BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
priority_reclaim_data_space() instead of the normal flushing path, which
avoids re-entering the relocation code and breaking the deadlock cycle.

In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
inode belongs to a data relocation root on a zoned filesystem.

Fixes: e2a7fd22378f ("btrfs: zoned: add zone reclaim flush state for DATA space_info")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/delalloc-space.c |  2 ++
 fs/btrfs/space-info.c     |  2 ++
 fs/btrfs/space-info.h     | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa4..4293a6383433 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -134,6 +134,8 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 
 	if (btrfs_is_free_space_inode(inode))
 		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
+	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
+		flush = BTRFS_RESERVE_FLUSH_ZONED_RELOCATION;
 
 	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
 }
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 739984462677..e6641597b321 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1705,6 +1705,7 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
 						ARRAY_SIZE(evict_flush_states));
 		break;
 	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
+	case BTRFS_RESERVE_FLUSH_ZONED_RELOCATION:
 		priority_reclaim_data_space(space_info, ticket);
 		break;
 	default:
@@ -1968,6 +1969,7 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
 
 	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
 	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
+	       flush == BTRFS_RESERVE_FLUSH_ZONED_RELOCATION ||
 	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
 	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
 	       "current->journal_info=0x%lx flush=%d",
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 24f45072ca4b..aa836e8a9d4a 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -77,6 +77,17 @@ enum btrfs_reserve_flush_enum {
 	 */
 	BTRFS_RESERVE_FLUSH_ALL_STEAL,
 
+	/*
+	 * This is for relocation on zoned filesystems only. We need to use
+	 * priority flushing for this, because otherwise we can deadlock on
+	 * waiting for a ticket, that cannot be granted, because we cannot do
+	 * any allocations.
+	 *
+	 * Apart from being specific to zoned relocation, it is equal to
+	 * BTRFS_FLUSH_FREE_SPACE_INODE.
+	 */
+	BTRFS_RESERVE_FLUSH_ZONED_RELOCATION,
+
 	/*
 	 * This is for btrfs_use_block_rsv only.  We have exhausted our block
 	 * rsv and our global block rsv.  This can happen for things like
-- 
2.54.0

