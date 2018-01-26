Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751604AbeAZH0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:26:15 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 6/7] btrfs-progs: remove no longer be used btrfs_alloc_extent
Date: Fri, 26 Jan 2018 15:26:05 +0800
Message-ID: <1516951566-21777-7-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup.
Function btrfs_alloc_extent is no longer be used.
So let's remove it.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 679bbc91..41b14b57 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2501,12 +2501,6 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					u32 blocksize, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
-int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       u64 num_bytes, u64 parent,
-		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 empty_size, u64 hint_byte,
-		       u64 search_end, struct btrfs_key *ins, int data);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
 			     u64 offset, int metadata, u64 *refs, u64 *flags);
-- 
2.14.3



