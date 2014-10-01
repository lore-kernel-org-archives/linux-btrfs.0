Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28210 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbaJAOLN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 10:11:13 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s91EA2DY004460
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Oct 2014 07:11:13 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pr09uj166-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Oct 2014 07:11:12 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make free space cache less noisy
Date: Wed, 1 Oct 2014 10:11:09 -0400
Message-ID: <1412172669-1975-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fsck only cares if the cache is really broken, so don't be noisy if the
generations don't match or other such errors.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 free-space-cache.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 2440dd8..43c0894 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -174,9 +174,6 @@ static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
 
 	gen = io_ctl->cur;
 	if (le64_to_cpu(*gen) != generation) {
-		printk("btrfs: space cache generation "
-		       "(%Lu) does not match inode (%Lu)\n", *gen,
-		       generation);
 		io_ctl_unmap_page(io_ctl);
 		return -EIO;
 	}
@@ -318,11 +315,6 @@ static int __load_free_space_cache(struct btrfs_root *root,
 	}
 
 	if (btrfs_inode_generation(leaf, inode_item) != generation) {
-		printf("free space inode generation (%llu) did not match "
-		       "free space cache generation (%llu)\n",
-		       (unsigned long long)btrfs_inode_generation(leaf,
-								  inode_item),
-		       (unsigned long long)generation);
 		btrfs_release_path(path);
 		return 0;
 	}
@@ -434,13 +426,9 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				      block_group->key.objectid);
 	btrfs_free_path(path);
 
-	if (ret < 0) {
+	if (ret < 0)
 		ret = 0;
 
-		printf("failed to load free space cache for block group %llu\n",
-			block_group->key.objectid);
-	}
-
 	return ret;
 }
 
-- 
1.8.3.1

