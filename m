Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932548AbcK2PAe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 10:00:34 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uATF0NjB033240
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 10:00:33 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 271b7djmdj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 10:00:24 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 29 Nov 2016 09:59:15 -0500
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com
Subject: [PATCH] btrfs-progs: Use helper functions to access btrfs_super_block->sys_chunk_array_size
Date: Tue, 29 Nov 2016 20:29:02 +0530
Message-Id: <1480431542-16889-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_super_block->sys_chunk_array_size is stored as le32 data on
disk. However insert_temp_chunk_item() writes sys_chunk_array_size in
host cpu order. This commit fixes this by using super block access
helper functions to read and write
btrfs_super_block->sys_chunk_array_size field.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 utils.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index d0189ad..7b17b20 100644
--- a/utils.c
+++ b/utils.c
@@ -562,14 +562,17 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 	 */
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		char *cur;
+		u32 array_size;
 
 		cur = (char *)sb->sys_chunk_array + sb->sys_chunk_array_size;
 		memcpy(cur, &disk_key, sizeof(disk_key));
 		cur += sizeof(disk_key);
 		read_extent_buffer(buf, cur, (unsigned long int)chunk,
 				   btrfs_chunk_item_size(1));
-		sb->sys_chunk_array_size += btrfs_chunk_item_size(1) +
+		array_size = btrfs_super_sys_array_size(sb);
+		array_size += btrfs_chunk_item_size(1) +
 					    sizeof(disk_key);
+		btrfs_set_super_sys_array_size(sb, array_size);
 
 		ret = write_temp_super(fd, sb, cfg->super_bytenr);
 	}
-- 
2.5.5

