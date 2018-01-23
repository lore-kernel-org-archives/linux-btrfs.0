Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37119 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752411AbeAWURI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 15:17:08 -0500
Received: by mail-qt0-f193.google.com with SMTP id d54so4705341qtd.4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 12:17:08 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Subject: [PATCH] Btrfs: fix stale entries in readdir
Date: Tue, 23 Jan 2018 15:17:05 -0500
Message-Id: <1516738626-23283-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

In fixing the readdir+pagefault deadlock I accidentally introduced a
stale entry regression in readdir.  If we get close to full for the
temporary buffer, and then skip a few delayed deletions, and then try to
add another entry that won't fit, we will emit the entries we found and
retry.  Unfortunately we delete entries from our del_list as we find
them, assuming we won't need them.  However our pos will be with
whatever our last entry was, which could be before the delayed deletions
we skipped, so the next search will add the deleted entries back into
our readdir buffer.  So instead don't delete entries we find in our
del_list so we can make sure we always find our delayed deletions.  This
is a slight perf hit for readdir with lots of pending deletions, but
hopefully this isn't a common occurrence.  If it is we can revist this
and optimize it.

cc: stable@vger.kernel.org
Fixes: 23b5ec74943f ("btrfs: fix readdir deadlock with pagefault")
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-inode.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1c0bab4080a0..c9f7b13a7847 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1632,28 +1632,18 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
 int btrfs_should_delete_dir_index(struct list_head *del_list,
 				  u64 index)
 {
-	struct btrfs_delayed_item *curr, *next;
-	int ret;
-
-	if (list_empty(del_list))
-		return 0;
+	struct btrfs_delayed_item *curr;
+	int ret = 0;
 
-	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
+	list_for_each_entry(curr, del_list, readdir_list) {
 		if (curr->key.offset > index)
 			break;
-
-		list_del(&curr->readdir_list);
-		ret = (curr->key.offset == index);
-
-		if (refcount_dec_and_test(&curr->refs))
-			kfree(curr);
-
-		if (ret)
-			return 1;
-		else
-			continue;
+		if (curr->key.offset == index) {
+			ret = 1;
+			break;
+		}
 	}
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.7.5

