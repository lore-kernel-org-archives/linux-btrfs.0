Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbcENAF2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:28 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05QTX018035
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05QmR028808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:26 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05Nna022445
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] Btrfs: free sys_array eb as soon as possible
Date: Fri, 13 May 2016 17:06:59 -0700
Message-Id: <1463184422-13584-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While reading sys_chunk_array in superblock, btrfs creates a temporary
extent buffer.  Since we don't use it after finishing reading
 sys_chunk_array, we don't need to keep it in memory.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bd0f45f..1331606 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6586,13 +6586,13 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 		sb_array_offset += len;
 		cur_offset += len;
 	}
-	free_extent_buffer(sb);
+	free_extent_buffer_stale(sb);
 	return ret;
 
 out_short_read:
 	printk(KERN_ERR "BTRFS: sys_array too short to read %u bytes at offset %u\n",
 			len, cur_offset);
-	free_extent_buffer(sb);
+	free_extent_buffer_stale(sb);
 	return -EIO;
 }
 
-- 
2.5.5

