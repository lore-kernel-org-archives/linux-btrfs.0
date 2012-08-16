Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48439 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2HPNRm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:42 -0400
Received: by yhmm54 with SMTP id m54so2854619yhm.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 06:17:42 -0700 (PDT)
Message-ID: <502CF2F0.7020601@gmail.com>
Date: Thu, 16 Aug 2012 21:17:36 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: trivial code style fix in root-tree.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add code indent to the bad styled statements.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 root-tree.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/root-tree.c b/root-tree.c
index 782472c..39cfef6 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -182,12 +182,10 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (ret < 0)
 		goto out;
 	if (ret) {
-btrfs_print_leaf(root, path->nodes[0]);
-printk("failed to del %llu %u %llu\n",
-	(unsigned long long)key->objectid,
-	key->type,
-	(unsigned long long)key->offset);
-
+		btrfs_print_leaf(root, path->nodes[0]);
+		printk("failed to del %llu %u %llu\n",
+			(unsigned long long)key->objectid, key->type,
+			(unsigned long long)key->offset);
 	}
 	BUG_ON(ret != 0);
 	leaf = path->nodes[0];
-- 
1.7.1

