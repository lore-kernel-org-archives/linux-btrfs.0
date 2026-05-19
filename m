Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200BF33B6D0
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779205786; cv=none; b=pNteQZ4OuBBpNvgy5FuBn4iyq5PPcoGx6pfc26c79I1/bNg7O9PeFAI4Ls5ufpHm9USg0AuFG/Tqjn8ntnL/A7t7UxGlaB0XdwpU7pKzv3W6dWlqmJPi9a8vyFtt8fJ8N/9UAQipA+UDLrgnVdOj4pu4yvtW2jvQxTPNT8wFhKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779205786; c=relaxed/simple;
	bh=0DoqlFvljVzm/L8fs1+qQ89P46f50muUd2llKEnL3wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV9ZK35Vw7KD27SibnwJlJDqmLuYWMDkNsy2XotwOHmAeYJKiyAuYkfOHBoBA9Y+7UzQF6Z/rON2V+QoWE5JKg+HF4GOTp5PAtG8cydbJ6wv5M9A5mN1wuVT6KRyk7hEOwxtVwUfVVkaZ2KXwULdkGcZj9N3EyYzs1aCKEV19cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EMUa9DcR; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EMUa9DcR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779205784; x=1810741784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0DoqlFvljVzm/L8fs1+qQ89P46f50muUd2llKEnL3wE=;
  b=EMUa9DcRaXTW6bS9ON3gXuYf6Tm1xSSNsHN4VtOlN5YRwXeUJ5xgUf/j
   yv9x2Qx+N8apA5LUR9hf8mkHRNTMun4yHABdLLh0B+s+L+XScFCWteVTS
   TkW4L/FTjZN9OVAwzfstqWJbIXHERORT53OOIbhNUWeEWbCXyrU1D047+
   HTnSBFDbgj8KYg4ZnIOq+VBerCXQLn5mmZiEl8HvWQMV00i1jB+npqQoY
   HNjHjq9z0xAhLzeC3wJ5ly4TyOB05smGEI//blp0toI+OXnGINuKi25Gy
   xsjLR6KkVvkcFnrWEKLzL/qsNklxIhoolFj00ALxecGYuGKN7aD2vyuny
   A==;
X-CSE-ConnectionGUID: Cz9ym5IlT56hRzqdU29FPw==
X-CSE-MsgGUID: p4rjB0f8RfmpyA3+Md6Mhw==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="146893475"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2026 23:49:35 +0800
X-CSE-ConnectionGUID: Ns6U6MEXQEC+zTzPuQ2iMA==
X-CSE-MsgGUID: /MTYv6+tRlqnL3dlpbFPMQ==
IronPort-SDR: 6a0c868c_2ENUlPm/YGYqcbDYes6tkoyNYPKocnEgudTdzEooyA0LU7n
 9ctSoukljyQWIHkn96LPGIh7I3fFUbSSupCOO9Q==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 May 2026 08:49:32 -0700
X-CSE-ConnectionGUID: 5lgVFeBFQ+22T6HLGvJnbg==
X-CSE-MsgGUID: wYzIpr4HSsWh7NxmO49USg==
WDCIronportException: Internal
Received: from wdap-koukjqvp2n.ad.shared (HELO neo.fritz.box) ([10.224.19.38])
  by uls-op-esai1-o.wdc.com with ESMTP; 19 May 2026 08:49:29 -0700
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
Subject: [PATCH v2 5/5] btrfs: zoned: fix deadlock waiting for ticket during data relocation
Date: Tue, 19 May 2026 17:49:02 +0200
Message-ID: <20260519154902.223445-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
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

