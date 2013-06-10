Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35199 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3FJTwE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 15:52:04 -0400
Received: by mail-wi0-f175.google.com with SMTP id m6so1746731wiv.14
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 12:52:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/5] Btrfs-progs: Add missing free_extent_buffer() call to debug-tree
Date: Mon, 10 Jun 2013 20:51:32 +0100
Message-Id: <1370893895-24884-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-debug-tree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index bae7f94..97459b1 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -355,6 +355,7 @@ again:
 					btrfs_print_tree(tree_root_scan, buf, 1);
 				}
 			}
+			free_extent_buffer(buf);
 		}
 next:
 		path.slots[0]++;
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
