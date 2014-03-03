Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaCCEHL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 23:07:11 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s2347AKL027564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 04:07:11 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23479I5025338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 04:07:10 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23479WP025335
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 04:07:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add readahead for send_write
Date: Mon,  3 Mar 2014 12:07:02 +0800
Message-Id: <1393819622-22074-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs send reads data from disk and then writes to a stream via pipe or
a file via flush.

Currently we're going to read each page at a time, so every page results
in a disk read, which is not friendly to disks, esp. HDD.  Given that,
the performance can be gained by adding readahead for those pages.

Here is a quick test:
$ btrfs subvolume create send
$ xfs_io -f -c "pwrite 0 1G" send/foobar
$ btrfs subvolume snap -r send ro
$ time "btrfs send ro -f /dev/null"

           w/o             w
real    1m37.527s       0m9.097s
user    0m0.122s        0m0.086s
sys     0m53.191s       0m12.857s

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4f00446..6d198ef 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3966,6 +3966,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	pgoff_t last_index;
 	unsigned pg_offset = offset & ~PAGE_CACHE_MASK;
 	ssize_t ret = 0;
+	struct file_ra_state *ra = NULL;
 
 	key.objectid = sctx->cur_ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
@@ -3985,6 +3986,15 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		goto out;
 
 	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+
+	/* initial readahead */
+	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	if (!ra)
+		goto out;
+
+	file_ra_state_init(ra, inode->i_mapping);
+	btrfs_force_ra(inode->i_mapping, ra, NULL, index, last_index-index + 1);
+
 	while (index <= last_index) {
 		unsigned cur_len = min_t(unsigned, len,
 					 PAGE_CACHE_SIZE - pg_offset);
@@ -4016,6 +4026,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		ret += cur_len;
 	}
 out:
+	kfree(ra);
 	iput(inode);
 	return ret;
 }
-- 
1.8.2.1

