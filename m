Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729424AbeHOSTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:39 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56203AD6B
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/7] btrfs: Remove redundant extent_buffer_get in get_old_root
Date: Wed, 15 Aug 2018 18:26:53 +0300
Message-Id: <1534346817-9108-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_old_root used used only by btrfs_search_old_slot to initialise the
path structure. The old root is always a cloned buffer (either via
alloc dummy or via btrfs_clone_extent_buffer) and its reference count is
2 - 1 from allocation 1 from extent_buffer_get call in get_old_root.
This latter explicit ref count acquire operation is in fact unnecessary
since the semantic is such that the newly allocated buffer is
handed over to the btrfs_path for lifetime management. Considering this
just remove the extra extent_buffer_get in get_old_root.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d436fb4c002e..4dc5d4becd49 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1382,7 +1382,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 
 	if (!eb)
 		return NULL;
-	extent_buffer_get(eb);
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
-- 
2.7.4
