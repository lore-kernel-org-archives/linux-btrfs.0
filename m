Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52698 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3AaPX2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 10:23:28 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id RqrKrkDIiSDohM3G (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 08:23:22 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove extent mapping if we fail to add chunk
Date: Thu, 31 Jan 2013 10:30:11 -0500
Message-ID: <1359646211-2013-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got a double free error when unmounting a file system that failed to add a
chunk during its operation.  This is because we will kfree the mapping that
we created but leave the extent_map in the em_tree for chunks.  So to fix
this just remove the extent_map when we error out so we don't run into this
problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/volumes.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ba5b84..4f3f152 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3762,9 +3762,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	write_unlock(&em_tree->lock);
-	free_extent_map(em);
-	if (ret)
+	if (ret) {
+		free_extent_map(em);
 		goto error;
+	}
 
 	for (i = 0; i < map->num_stripes; ++i) {
 		struct btrfs_device *device;
@@ -3804,6 +3805,14 @@ error_dev_extent:
 			break;
 		}
 	}
+	write_lock(&em_tree->lock);
+	remove_extent_mapping(em_tree, em);
+	write_unlock(&em_tree->lock);
+
+	/* One for our allocation */
+	free_extent_map(em);
+	/* One for the tree reference */
+	free_extent_map(em);
 error:
 	kfree(map);
 	kfree(devices_info);
-- 
1.7.7.6

