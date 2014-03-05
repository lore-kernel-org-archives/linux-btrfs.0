Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaCECHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Mar 2014 21:07:51 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] Btrfs: add readahead for send_write
Date: Wed,  5 Mar 2014 10:07:35 +0800
Message-Id: <1393985255-16974-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs send reads data from disk and then writes to a stream via pipe or
a file via flush.

Currently we're going to read each page a time, so every page results
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
v2->v3: move file_ra_state to @send_ctx, suggested by David Sterba.

v1->v2: return ENOMEM on failing to allocate memory.

 fs/btrfs/send.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9dde971..190a71e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -120,6 +120,8 @@ struct send_ctx {
 	struct list_head name_cache_list;
 	int name_cache_size;
 
+	struct file_ra_state ra;
+
 	char *read_buf;
 
 	/*
@@ -3991,6 +3993,13 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		goto out;
 
 	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+
+	/* initial readahead */
+	memset(&sctx->ra, 0, sizeof(struct file_ra_state));
+	file_ra_state_init(&sctx->ra, inode->i_mapping);
+	btrfs_force_ra(inode->i_mapping, &sctx->ra, NULL, index,
+		       last_index - index + 1);
+
 	while (index <= last_index) {
 		unsigned cur_len = min_t(unsigned, len,
 					 PAGE_CACHE_SIZE - pg_offset);
-- 
1.8.1.4

