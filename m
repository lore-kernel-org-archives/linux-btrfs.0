Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58643 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757305AbcLANv3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 08:51:29 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB1DnDsW108822
        for <linux-btrfs@vger.kernel.org>; Thu, 1 Dec 2016 08:51:29 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 272ms2h80k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 08:51:28 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 1 Dec 2016 06:51:28 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com
Subject: [PATCH V2] btrfs-progs: Use helper function to access btrfs_super_block->sys_chunk_array_size
Date: Thu,  1 Dec 2016 19:21:14 +0530
Message-Id: <1480600274-13623-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_super_block->sys_chunk_array_size is stored as le32 data on
disk. However insert_temp_chunk_item() writes sys_chunk_array_size in
host cpu order. This commit fixes this by using super block access
helper functions to read and write
btrfs_super_block->sys_chunk_array_size field.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 utils.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index d0189ad..74dde1e 100644
--- a/utils.c
+++ b/utils.c
@@ -562,14 +562,18 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 	 */
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		char *cur;
+		u32 array_size;
 
-		cur = (char *)sb->sys_chunk_array + sb->sys_chunk_array_size;
+		cur = (char *)sb->sys_chunk_array
+			+ btrfs_super_sys_array_size(sb);
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

