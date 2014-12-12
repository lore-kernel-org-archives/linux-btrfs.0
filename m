Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32358 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754941AbaLLVCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 16:02:25 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBCKxJt1020307
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:02:24 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1r84hcrw4u-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:02:24 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: abort transaction if we don't find the block group
Date: Fri, 12 Dec 2014 16:02:20 -0500
Message-ID: <1418418140-1524-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We shouldn't BUG_ON() if there is corruption.  I hit this while testing my block
group patch and the abort worked properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ddc838..a86e55a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3152,9 +3152,11 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 
 	ret = btrfs_search_slot(trans, extent_root, &cache->key, path, 0, 1);
-	if (ret < 0)
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
 		goto fail;
-	BUG_ON(ret); /* Corruption */
+	}
 
 	leaf = path->nodes[0];
 	bi = btrfs_item_ptr_offset(leaf, path->slots[0]);
@@ -3162,11 +3164,9 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 fail:
-	if (ret) {
+	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
-		return ret;
-	}
-	return 0;
+	return ret;
 
 }
 
-- 
1.8.3.1

