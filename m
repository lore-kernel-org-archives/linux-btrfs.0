Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50391 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932414AbaICNeO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYAQi006670
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:10 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/18] Btrfs: fix unprotected system chunk array insertion
Date: Wed, 3 Sep 2014 21:35:39 +0800
Message-ID: <1409751347-5296-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't protect the system chunk array when we added a new
system chunk into it, it would cause the array be corrupted
if someone remove/add some system chunk into array at the same
time. Fix it by chunk lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 41da102..9f22398d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4054,10 +4054,13 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	u32 array_size;
 	u8 *ptr;
 
+	lock_chunks(root);
 	array_size = btrfs_super_sys_array_size(super_copy);
 	if (array_size + item_size + sizeof(disk_key)
-			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE)
+			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+		unlock_chunks(root);
 		return -EFBIG;
+	}
 
 	ptr = super_copy->sys_chunk_array + array_size;
 	btrfs_cpu_key_to_disk(&disk_key, key);
@@ -4066,6 +4069,8 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	memcpy(ptr, chunk, item_size);
 	item_size += sizeof(disk_key);
 	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
+	unlock_chunks(root);
+
 	return 0;
 }
 
-- 
1.9.3

