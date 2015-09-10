Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59399 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbbIJU1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 16:27:23 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <mfasheh@suse.de>
Subject: [PATCH] Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
Date: Thu, 10 Sep 2015 16:27:10 -0400
Message-ID: <1441916830-18931-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backref code will look up the fs_root we're trying to resolve our indirect
refs for, unfortunately we use btrfs_read_fs_root_no_name, which returns -ENOENT
if the ref is 0.  This isn't helpful for the qgroup stuff with snapshot delete
as it won't be able to search down the snapshot we are deleting, which will
cause us to miss roots.  So use btrfs_get_fs_root and send false for check_ref
so we can always get the root we're looking for.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
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
1.8.3.1

