Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab3HNXRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:22 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHMrQ030719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSq017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/15] btrfs-progs: fix endian bugs in chunk rebuilding
Date: Wed, 14 Aug 2013 16:16:37 -0700
Message-Id: <1376522205-16992-8-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A disk_key was set by hand instead of using the endian helpers.

I *think* the second one is just a typo.  The chunk's num_stripes was
already initialized from the record, but it's le16.  So we'll set the
item's size based on the record's native num_stripes.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-chunk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 16f399e..54f0573 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1031,9 +1031,9 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 		if (min_devid > dev->devid)
 			min_devid = dev->devid;
 	}
-	disk_key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
-	disk_key.type = BTRFS_DEV_ITEM_KEY;
-	disk_key.offset = min_devid;
+	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_disk_key_offset(&disk_key, min_devid);
 
 	cow = btrfs_alloc_free_block(trans, root, root->sectorsize,
 				     BTRFS_CHUNK_TREE_OBJECTID,
@@ -1117,7 +1117,7 @@ static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
 		key.offset = chunk_rec->offset;
 
 		ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
-				btrfs_chunk_item_size(chunk->num_stripes));
+				btrfs_chunk_item_size(chunk_rec->num_stripes));
 		free(chunk);
 		if (ret)
 			return ret;
-- 
1.7.11.7

