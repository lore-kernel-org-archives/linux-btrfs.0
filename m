Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41111 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbeENLNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC6E3ADD2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:39 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/9] btrfs-progs: btrfs-corrupt-block: Correctly handle -r when passing -I
Date: Mon, 14 May 2018 14:13:27 +0300
Message-Id: <1526296414-27638-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The documentation for the -I option (corrupt an item) states:

  An item to corrupt (must also specify the field to corrupt and a root+key for the item)

The code on the other hand doesn't check whether -r is in fact passed,
and even if it is it's not handled at all. This means presently -I
is possible to corrupt items only in the root tree. Fix this by
correctly checking -r is passed and fail otherwise and passing the
correct root to corrupt_btrfs_item.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index ab6ca0a1e90a..0018b6c9662d 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1337,9 +1337,15 @@ int main(int argc, char **argv)
 		goto out_close;
 	}
 	if (corrupt_item) {
+		struct btrfs_root *target;
 		if (!key.objectid)
 			print_usage(1);
-		ret = corrupt_btrfs_item(root, &key, field);
+		if (!root_objectid)
+			print_usage(1);
+
+		target = open_root(root->fs_info, root_objectid);
+
+		ret = corrupt_btrfs_item(target, &key, field);
 	}
 	if (delete) {
 		struct btrfs_root *target = root;
-- 
2.7.4

