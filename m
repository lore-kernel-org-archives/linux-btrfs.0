Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbcFWX3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 19:29:38 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] Btrfs: error out if generic_bin_search get invalid arguments
Date: Thu, 23 Jun 2016 16:32:45 -0700
Message-Id: <1466724765-27364-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1466645539-27296-1-git-send-email-bo.li.liu@oracle.com>
References: <1466645539-27296-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With btrfs-corrupt-block, one can set btree node/leaf's field, if
we assign a negative value to node/leaf, we can get various hangs,
eg. if extent_root's nritems is -2ULL, then we get stuck in
 btrfs_read_block_groups() because it has a while loop and
btrfs_search_slot() on extent_root will always return the first
 child.

This lets us know what's happening and returns a EINVAL to callers
instead of returning the first item.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix typo of in printed message.

 fs/btrfs/ctree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c49a500..915d224 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1770,6 +1770,14 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 	unsigned long map_len = 0;
 	int err;
 
+	if (low > high) {
+		btrfs_err(eb->fs_info,
+		 "%s: low (%d) > high (%d) eb %llu owner %llu level %d",
+			  __func__, low, high, eb->start,
+			  btrfs_header_owner(eb), btrfs_header_level(eb));
+		return -EINVAL;
+	}
+
 	while (low < high) {
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
-- 
2.5.5

