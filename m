Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DD740DFD1
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774841535; cv=none; b=JRTYwuL7RP7wWxEtHQ2CRfye/MMGalqx9Alh7c/6ycLEwaavrtkcWmGOlCg4WkJGcBYxfi6R2IqH5YvpJZfx6Gd5qIkKJNxXj7IBW3Ns6KA7tTfPbBvzfiLgh6v52HQ7wuyhG3m5YFQ/GiEF/M6bbPWa2+Q1DtTGeRT6SRsJyc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774841535; c=relaxed/simple;
	bh=fs2v3HokEencOxhHjGu42mcLmjEqUAE8rhP9tgMEnsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JA1aQnLv6RrnJumv6zOUJhrN/k61y4gxjjG07sxDTO6aDA4/wNeq0HCfN3SfZAzopnjE0Px0oB5P/Q0ManCG+KCkDL/R61dFg/BVZol2H+zi5LYYARXbqLYyQrDQcMilGkLaJnaK6lbgKu5FSgVVWlIqpVVbWqq3pLzT/ekev+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=nMyOvN+k; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="nMyOvN+k"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4fkcHp5SDmzHdhJvB;
	Mon, 30 Mar 2026 11:32:06 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1774841527; bh=fs2v3HokEencOxhHjGu42mcLmjEqUAE8rhP9tgMEnsk=;
	h=From:To:Cc:Subject:Date;
	b=nMyOvN+kZAvtyb6xQIBxNf9pHEzheI7zuAgIlTntLk+gfC+Fz0j3eF2TehNqC+6PR
	 wxjp3QxNG+C8hP8+Ah1LalCzMJJ2ywIg7WBfU73SvpizVlIDehVSWyjNRwzOe6qd1B
	 V9awFRe0VMQztXnEgnk3KdmAz24SWRrL3Hpp1qVY=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	robbieko@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: skip clearing EXTENT_DEFRAG for nocow ordered extents
Date: Mon, 30 Mar 2026 11:31:48 +0800
Message-ID: <20260330033148.696942-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
Content-Type: text/plain

In btrfs_finish_one_ordered(), clear_bits is unconditionally initialized
with EXTENT_DEFRAG.  For nocow ordered extents this is always a no-op
because should_nocow() already forces the COW path when EXTENT_DEFRAG is
set, so a nocow ordered extent can never have EXTENT_DEFRAG on its range.

Although harmless, the unconditional btrfs_clear_extent_bit() call still
performs a cold rbtree lookup under the io tree spinlock on every nocow
write completion.  Avoid this by only adding EXTENT_DEFRAG to clear_bits
for non-nocow ordered extents, and skip the call entirely when there are
no bits to clear.

Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f643a05208720..80daf7e248ab8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3203,7 +3203,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	bool freespace_inode;
 	bool truncated = false;
 	bool clear_reserved_extent = true;
-	unsigned int clear_bits = EXTENT_DEFRAG;
+	unsigned int clear_bits = 0;
 
 	start = ordered_extent->file_offset;
 	end = start + ordered_extent->num_bytes - 1;
@@ -3214,6 +3214,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	    !test_bit(BTRFS_ORDERED_ENCODED, &ordered_extent->flags))
 		clear_bits |= EXTENT_DELALLOC_NEW;
 
+	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
+		clear_bits |= EXTENT_DEFRAG;
+
 	freespace_inode = btrfs_is_free_space_inode(inode);
 	if (!freespace_inode)
 		btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
@@ -3345,8 +3348,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 out:
-	btrfs_clear_extent_bit(&inode->io_tree, start, end, clear_bits,
-			       &cached_state);
+	if (clear_bits)
+		btrfs_clear_extent_bit(&inode->io_tree, start, end, clear_bits,
+				       &cached_state);
 
 	if (trans)
 		btrfs_end_transaction(trans);
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
