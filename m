Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:60978 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaBGSyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 13:54:06 -0500
Received: by mail-yh0-f52.google.com with SMTP id a41so3031776yho.11
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 10:54:04 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] btrfs-progs: Preserve process_one_leaf return value.
Date: Fri,  7 Feb 2014 12:53:50 -0600
Message-Id: <1391799230-6954-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return value in process_one_leaf could be over-written while
looping over the items in the leaf.

This patch will preserve a non-zero return value to the calling
function if a non-zero return value is encountered in the loop.

The return value of one (1) is consistent with non-zero values
that could be returned while processing the leaf.

The only caller of this function (walk_down_tree) would ignore
the return value anyway.  But this patch will correct the
behaviour in case future changes intend to utilize the return
value.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 cmds-check.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2911af0..eef7c6c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1219,6 +1219,7 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	u32 nritems;
 	int i;
 	int ret = 0;
+	int error = 0;
 	struct cache_tree *inode_cache;
 	struct shared_node *active_node;
 
@@ -1268,8 +1269,10 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		default:
 			break;
 		};
+		if (ret != 0)
+			error = 1;
 	}
-	return ret;
+	return error;
 }
 
 static void reada_walk_down(struct btrfs_root *root,
-- 
1.8.3.2

