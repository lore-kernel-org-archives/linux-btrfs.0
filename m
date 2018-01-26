Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32016 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751478AbeAZDWQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:22:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 46ADE49F19B7
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 11:22:12 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] btrfs-progs: remove no longer be used btrfs_alloc_extent
Date: Fri, 26 Jan 2018 11:22:06 +0800
Message-ID: <1516936926-18707-6-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup.
Function btrfs_alloc_extent is no longer be used.
So let's remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index c82e7547..34d2505e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2487,12 +2487,6 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
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



