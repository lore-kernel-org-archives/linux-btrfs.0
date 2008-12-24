From: "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATCH]Fix compile error in quick-test.c of btrfs progs
Date: Wed, 24 Dec 2008 14:42:13 +0800
Message-ID: <2c3b11250812232242r6198dd67gf12b88fd26055a04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
This patch fix compiler error in quick-test.c

-- 
Thanks & Best Regards
Liu Hui
--

diff --git a/quick-test.c b/quick-test.c
index 44c2318..351c706 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -18,6 +18,7 @@

 #include <stdio.h>
 #include <stdlib.h>
+#include <fcntl.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -96,7 +97,7 @@ int main(int ac, char **av) {
 	printf("node %p level %d total ptrs %d free spc %lu\n", root->node,
 	        btrfs_header_level(root->node),
 		btrfs_header_nritems(root->node),
-		BTRFS_NODEPTRS_PER_BLOCK(root) -
+		(unsigned long)BTRFS_NODEPTRS_PER_BLOCK(root) -
 		btrfs_header_nritems(root->node));
 	printf("all searches good, deleting some items\n");
 	i = 0;
