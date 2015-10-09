Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:3482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755041AbbJICcx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:32:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992WEE7023746
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:32:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 19/23] btrfs: Add handler for invalidate page
Date: Fri, 9 Oct 2015 10:30:37 +0800
Message-ID: <1444357837-2563-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_invalidatepage() and its variant evict_inode_truncate_page(),
there will be pages don't reach disk.
In that case, their reserved space won't be release nor freed by
finish_ordered_io() nor delayed_ref handler.

So we must free their qgroup reserved space, or we will leaking reserved
space again.

So this will patch will call btrfs_qgroup_free_data() for
invalidatepage() and its variant evict_inode_truncate_page().

And due to the nature of new btrfs_qgroup_reserve/free_data() reserved
space will only be reserved or freed once, so for pages which are
already flushed to disk, their reserved space will be released and freed
by delayed_ref handler.

Double free won't be a problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced
---
 fs/btrfs/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee0b239..85b06d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5075,6 +5075,18 @@ static void evict_inode_truncate_pages(struct inode *inode)
 		spin_unlock(&io_tree->lock);
 
 		lock_extent_bits(io_tree, start, end, 0, &cached_state);
+
+		/*
+		 * If still has DELALLOC flag, the extent didn't reach disk,
+		 * and its reserved space won't be freed by delayed_ref.
+		 * So we need to free its reserved space here.
+		 * (Refer to comment in btrfs_invalidatepage, case 2)
+		 *
+		 * Note, end is the bytenr of last byte, so we need + 1 here.
+		 */
+		if (state->state & EXTENT_DELALLOC)
+			btrfs_qgroup_free_data(inode, start, end - start + 1);
+
 		clear_extent_bit(io_tree, start, end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
 				 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
@@ -8592,6 +8604,18 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 		}
 	}
 
+	/*
+	 * Qgroup reserved space handler
+	 * Page here will be either
+	 * 1) Already written to disk
+	 *    In this case, its reserved space is released from data rsv map
+	 *    and will be freed by delayed_ref handler finally.
+	 *    So even we call qgroup_free_data(), it won't decrease reserved
+	 *    space.
+	 * 2) Not written to disk
+	 *    This means the reserved space should be freed here.
+	 */
+	btrfs_qgroup_free_data(inode, page_start, PAGE_CACHE_SIZE);
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
-- 
2.6.1

