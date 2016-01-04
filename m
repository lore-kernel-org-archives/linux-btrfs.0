Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:32999 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbcADBCK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 20:02:10 -0500
Received: by mail-pf0-f173.google.com with SMTP id q63so157225796pfb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 17:02:09 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Zach Brown <zab@redhat.com>
Subject: [PATCH v2 4/6] btrfs-progs: fix endian bugs in chunk rebuilding
Date: Mon,  4 Jan 2016 10:01:32 +0900
Message-Id: <1451869294-4291-5-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451869294-4291-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a same patch as Zach Brown's but we lost so I resend it based on
current code.
 - 'commit 2cd95f945a61 ("fix endian bugs in chunk rebuilding")'

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 chunk-recover.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 85dc1bca031a..b03330b4cda0 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1159,9 +1159,9 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 		if (min_devid > dev->devid)
 			min_devid = dev->devid;
 	}
-	disk_key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
-	disk_key.type = BTRFS_DEV_ITEM_KEY;
-	disk_key.offset = min_devid;
+	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_disk_key_offset(&disk_key, min_devid);
 
 	cow = btrfs_alloc_free_block(trans, root, root->nodesize,
 				     BTRFS_CHUNK_TREE_OBJECTID,
@@ -1234,7 +1234,7 @@ static int __insert_chunk_item(struct btrfs_trans_handle *trans,
 	key.offset = chunk_rec->offset;
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
-				btrfs_chunk_item_size(chunk->num_stripes));
+				btrfs_chunk_item_size(chunk_rec->num_stripes));
 	free(chunk);
 	return ret;
 }
-- 
2.6.4

