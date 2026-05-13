Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E642885E
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675733; cv=none; b=S0y7JVBs+pxm7gSLYyAKf0+cjTKObYRJ44aLU0v3zpaTirY0ipJKdkzCAi6471bAAHyvto6zHdpokDWBa9RO91kY/wTUHxFc4h1i3aJuwOtGiZtQN9bKc/PGI1oWpWAONeRjbEygom/VNKSvCSUMQmYEMDJaFiOrTUkzeMW8w58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675733; c=relaxed/simple;
	bh=HBVos65qkWgIw25lh0mJ0hKnMjVkc4POfXs93dcA7XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZYNVZi1f4K+5RSgq+B5cnSvvgHldLqZuCHIhRApy5CVAHd+P34M4yENkMZhHgqKz/Ruu3xLxF/mMCO1+M+4H82abQST/GGbNSJioB9jyo481so8CXxMVGuoIscH/d2KXz1+hNpJFCumwYa58uN0IB9dgonph/aA5p3RElWK9Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OtpUYCGx; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OtpUYCGx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778675732; x=1810211732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HBVos65qkWgIw25lh0mJ0hKnMjVkc4POfXs93dcA7XE=;
  b=OtpUYCGxLFLEnEjejFmPxnd/v240F5ihzJgGFkXBcwzVKZdxrP7zoags
   GZ6JBuwTLyULb7ME1L+OvARz6m0Mio3PDL4MSkGyzopevNxdFYCT/0pBS
   GCNYcZfmJXItjURJG0yGbSDi5CLo+Tj94b09u/klpTLrGoxW/bI4mpvBv
   8bcMGaidz9AGLUB+5VaoVbwaIiVNxilxrPmxIFTWPiWB7QgQqzkSSnwtv
   W0bzcJo8luJFvbIVQ+KdQFMhCEounDjzxq42Q/n9tSUmhqpPmKSSbY4FQ
   +Up8dL4psFca9O4eqscnDYGfOwjZqk1rlfgk36ohv4CrDO2+B2FgGJWP1
   Q==;
X-CSE-ConnectionGUID: QIrIEnTTSTSqIEIfcrU46Q==
X-CSE-MsgGUID: qG5lCq4IQI+xRl7nX4AJEw==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146869038"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 20:35:26 +0800
X-CSE-ConnectionGUID: AwIER6N2R8CFZ6pUmF724A==
X-CSE-MsgGUID: kuYn0kD2QvyZKxNquRvBOw==
IronPort-SDR: 6a047005_59POYsMMJzG4wzvHMwNVWub+Yqe2sKrID9IMyN7eoi5JHcT
 BrwWCLhTcuDqs0rj3Cwk90GMCp5z0BhctR7oQOg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 May 2026 05:35:16 -0700
X-CSE-ConnectionGUID: UoRYYaojS7KlRpjPtK5Hrw==
X-CSE-MsgGUID: QjUQytwwTYmM8yhbEDQPjg==
WDCIronportException: Internal
Received: from wdap-6xonuiesoc.ad.shared (HELO neo.wdc.com) ([10.224.28.49])
  by uls-op-esai1-o.wdc.com with ESMTP; 13 May 2026 05:35:15 -0700
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
Subject: [PATCH 6/7] btrfs: zoned: fix deadlock waiting for ticket during data relocation
Date: Wed, 13 May 2026 14:34:44 +0200
Message-ID: <20260513123445.43197-7-johannes.thumshirn@wdc.com>
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

When performing data relocation on a zoned filesystem, BTRFS can deadlock
in handle_reserve_tickets(). The relocation process is waiting on a space
reservation ticket that can never be fulfilled, because the relocation
itself is the operation responsible for freeing up that space.

Fix this by introducing a new flush state,
BTRFS_RESERVE_FLUSH_DATA_RELOCATION, specifically for data chunk
allocation during zoned relocation. Like
BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
priority_reclaim_data_space() instead of the normal flushing path, which
avoids re-entering the relocation code and breaking the deadlock cycle.

In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
inode belongs to a data relocation root on a zoned filesystem.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/delalloc-space.c |  2 ++
 fs/btrfs/space-info.c     |  2 ++
 fs/btrfs/space-info.h     | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa4..c9d3ec6bbc3c 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -134,6 +134,8 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 
 	if (btrfs_is_free_space_inode(inode))
 		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
+	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
+		flush = BTRFS_RESERVE_FLUSH_DATA_RELOCATION;
 
 	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
 }
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 58256a9c056d..ec811a77ebb1 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1703,6 +1703,7 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
 						ARRAY_SIZE(evict_flush_states));
 		break;
 	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
+	case BTRFS_RESERVE_FLUSH_DATA_RELOCATION:
 		priority_reclaim_data_space(space_info, ticket);
 		break;
 	default:
@@ -1966,6 +1967,7 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
 
 	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
 	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
+	       flush == BTRFS_RESERVE_FLUSH_DATA_RELOCATION ||
 	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
 	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
 	       "current->journal_info=0x%lx flush=%d",
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 24f45072ca4b..f2b8be2af5c3 100644
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
+	BTRFS_RESERVE_FLUSH_DATA_RELOCATION,
+
 	/*
 	 * This is for btrfs_use_block_rsv only.  We have exhausted our block
 	 * rsv and our global block rsv.  This can happen for things like
-- 
2.54.0

