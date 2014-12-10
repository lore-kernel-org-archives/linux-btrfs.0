Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35401 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933296AbaLJVFi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:38 -0500
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id DC1EAE3E94
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:36 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 01/18] btrfs-progs: btrfs-debug-tree: add option -f for "block only"
Date: Wed, 10 Dec 2014 21:51:31 +0100
Message-Id: <1418244708-7087-2-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

btrfs-debug-tree prints only the given block. It is sometimes
useful to be able to print the subtree under this block.
This patch enables this behavior with the option "-f".

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 btrfs-debug-tree.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e46500d..e61c71c 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -41,6 +41,8 @@ static int print_usage(void)
 	fprintf(stderr, "\t-u : print info of uuid tree only\n");
 	fprintf(stderr, "\t-b block_num : print info of the specified block"
                     " only\n");
+	fprintf(stderr, "\t-f : (with -b) follow subtree of the specified"
+		" block\n");
 	fprintf(stderr,
 		"\t-t tree_id : print only the tree with the given id\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -137,6 +139,7 @@ int main(int ac, char **av)
 	int roots_only = 0;
 	int root_backups = 0;
 	u64 block_only = 0;
+	int block_follow = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
 
@@ -144,7 +147,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "deb:rRut:");
+		c = getopt(ac, av, "defb:rRut:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -167,6 +170,9 @@ int main(int ac, char **av)
 			case 'b':
 				block_only = arg_strtou64(optarg);
 				break;
+			case 'f':
+				block_follow = 1;
+				break;
 			case 't':
 				tree_id = arg_strtou64(optarg);
 				break;
@@ -211,7 +217,7 @@ int main(int ac, char **av)
 				(unsigned long long)block_only);
 			goto close_root;
 		}
-		btrfs_print_tree(root, leaf, 0);
+		btrfs_print_tree(root, leaf, block_follow);
 		goto close_root;
 	}
 
-- 
1.7.3.4

