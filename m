Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51751 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759840Ab3EOR5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 13:57:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7391A9A0320
	for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 11:57:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Gm7EkN7WsELzKmTG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 11:57:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add a newline to a free space cache message
Date: Wed, 15 May 2013 13:57:16 -0400
Message-ID: <1368640636-16884-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Left out a newline in the generation check printf.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 5fb8ece..a30438b 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -314,7 +314,7 @@ int __load_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_inode_item);
 	if (btrfs_inode_generation(leaf, inode_item) != generation) {
 		printf("free space inode generation (%llu) did not match "
-		       "free space cache generation (%llu)",
+		       "free space cache generation (%llu)\n",
 		       (unsigned long long)btrfs_inode_generation(leaf,
 								  inode_item),
 		       (unsigned long long)generation);
-- 
1.7.7.6

