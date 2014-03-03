Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36604 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaCCJYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 04:24:53 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s239OpqU019890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 09:24:52 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s239Op0Q027935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 09:24:51 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s239OouJ007877
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 09:24:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: add readahead for send_write
Date: Mon,  3 Mar 2014 17:24:43 +0800
Message-Id: <1393838683-25216-1-git-send-email-bo.li.liu@oracle.com>
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
v1->v2: return ENOMEM on failing to allocate memory.

 fs/btrfs/send.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9dde971..d55faa7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3972,6 +3972,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	pgoff_t last_index;
 	unsigned pg_offset = offset & ~PAGE_CACHE_MASK;
 	ssize_t ret = 0;
+	struct file_ra_state *ra = NULL;
 
 	key.objectid = sctx->cur_ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
@@ -3991,6 +3992,17 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		goto out;
 
 	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+
+	/* initial readahead */
+	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	if (!ra) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	file_ra_state_init(ra, inode->i_mapping);
+	btrfs_force_ra(inode->i_mapping, ra, NULL, index, last_index-index + 1);
+
 	while (index <= last_index) {
 		unsigned cur_len = min_t(unsigned, len,
 					 PAGE_CACHE_SIZE - pg_offset);
@@ -4022,6 +4034,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		ret += cur_len;
 	}
 out:
+	kfree(ra);
 	iput(inode);
 	return ret;
 }
-- 
1.8.1.4

