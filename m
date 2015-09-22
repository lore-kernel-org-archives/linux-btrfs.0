Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbbIVUQA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 16:16:00 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, quwenruo@cn.fujitsu.com,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/4] Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
Date: Tue, 22 Sep 2015 13:15:45 -0700
Message-Id: <1442952948-21389-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

The backref code will look up the fs_root we're trying to resolve our indirect
refs for, unfortunately we use btrfs_read_fs_root_no_name, which returns -ENOENT
if the ref is 0.  This isn't helpful for the qgroup stuff with snapshot delete
as it won't be able to search down the snapshot we are deleting, which will
cause us to miss roots.  So use btrfs_get_fs_root and send false for check_ref
so we can always get the root we're looking for.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 802fabb..5de66e9 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -332,7 +332,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	index = srcu_read_lock(&fs_info->subvol_srcu);
 
-	root = btrfs_read_fs_root_no_name(fs_info, &root_key);
+	root = btrfs_get_fs_root(fs_info, &root_key, false);
 	if (IS_ERR(root)) {
 		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		ret = PTR_ERR(root);
-- 
2.1.2

