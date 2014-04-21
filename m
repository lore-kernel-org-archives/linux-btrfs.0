Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40216 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbaDUMRf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 08:17:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3LCHWnq032307
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 20:17:32 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: fix wrong max system array size check in kernel space
Date: Mon, 21 Apr 2014 20:13:11 +0800
Message-ID: <1398082392-5755-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For system chunk array,
We copy a "disk_key" and an chunk item each time,
so there should be enough space to hold both of them,
not only the chunk item.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b4660c4..302f956 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3868,7 +3868,8 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	u8 *ptr;
 
 	array_size = btrfs_super_sys_array_size(super_copy);
-	if (array_size + item_size > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE)
+	if (array_size + item_size + sizeof(disk_key)
+			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE)
 		return -EFBIG;
 
 	ptr = super_copy->sys_chunk_array + array_size;
-- 
1.8.1.4

