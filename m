Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57182 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3FJTwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 15:52:07 -0400
Received: by mail-wg0-f51.google.com with SMTP id e11so1098428wgh.18
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 12:52:05 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/5] Btrfs-progs: Add missing close_ctree() calls to debug-tree
Date: Mon, 10 Jun 2013 20:51:33 +0100
Message-Id: <1370893895-24884-4-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-debug-tree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 97459b1..74d4d66 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -195,10 +195,10 @@ int main(int ac, char **av)
 		if (!leaf) {
 			fprintf(stderr, "failed to read %llu\n",
 				(unsigned long long)block_only);
-			return 0;
+			goto close_root;
 		}
 		btrfs_print_tree(root, leaf, 0);
-		return 0;
+		goto close_root;
 	}
 
 	if (!extent_only) {
@@ -370,7 +370,7 @@ no_node:
 	}
 
 	if (extent_only || device_only)
-		return 0;
+		goto close_root;
 
 	if (root_backups)
 		print_old_roots(info->super_copy);
@@ -383,5 +383,6 @@ no_node:
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", BTRFS_BUILD_VERSION);
-	return 0;
+close_root:
+	return close_ctree(root);
 }
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
