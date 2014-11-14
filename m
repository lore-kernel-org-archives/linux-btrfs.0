Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbaKNKdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5A6E8AD1E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 10:33:21 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] btrfs: move commit out of sysfs when changing label
Date: Fri, 14 Nov 2014 11:33:21 +0100
Message-Id: <a6f69dc8018dbb4ce2009ccba49b53f68c8bdc64.1415894838.git.dsterba@suse.cz>
In-Reply-To: <cover.1415894837.git.dsterba@suse.cz>
References: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 226f7261533a..92db3f648df4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -369,9 +369,6 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 				 const char *buf, size_t len)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root = fs_info->fs_root;
-	int ret;
 	size_t p_len;
 
 	if (fs_info->sb->s_flags & MS_RDONLY)
@@ -386,20 +383,18 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
-	spin_lock(&root->fs_info->super_lock);
+	spin_lock(&fs_info->super_lock);
 	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
 	memcpy(fs_info->super_copy->label, buf, p_len);
-	spin_unlock(&root->fs_info->super_lock);
-	ret = btrfs_commit_transaction(trans, root);
+	spin_unlock(&fs_info->super_lock);
 
-	if (!ret)
-		return len;
+	/*
+	 * We don't want to do full transaction commit from inside sysfs
+	 */
+	btrfs_set_pending(fs_info, COMMIT);
+	wake_up_process(fs_info->transaction_kthread);
 
-	return ret;
+	return len;
 }
 BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
 
-- 
1.8.4.5

