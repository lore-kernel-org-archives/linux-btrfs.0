Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37697 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752027AbeCOMgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 973BAAD25
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:35 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/8] btrfs: Remove unused op_key var from add_delayed_refs
Date: Thu, 15 Mar 2018 14:36:22 +0200
Message-Id: <1521117389-13712-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added as part of 86d5f9944252 ("btrfs: convert prelimary reference
tracking to use rbtrees") but never used. tmp_op_key essentially
subsumed that variable

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/backref.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4e89598ca878..93f76a69dd44 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -773,15 +773,12 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
 	struct btrfs_key tmp_op_key;
-	struct btrfs_key *op_key = NULL;
 	struct rb_node *n;
 	int count;
 	int ret = 0;
 
-	if (extent_op && extent_op->update_key) {
+	if (extent_op && extent_op->update_key)
 		btrfs_disk_key_to_cpu(&tmp_op_key, &extent_op->key);
-		op_key = &tmp_op_key;
-	}
 
 	spin_lock(&head->lock);
 	for (n = rb_first(&head->ref_tree); n; n = rb_next(n)) {
-- 
2.7.4

