Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57226 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaJGOpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 10:45:23 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so7208613pab.24
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Oct 2014 07:45:22 -0700 (PDT)
Received: from vm01.localdomain ([112.0.61.175])
        by mx.google.com with ESMTPSA id iu1sm16182638pbc.53.2014.10.07.07.45.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Oct 2014 07:45:22 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix incorrect compression ratio detection
Date: Tue,  7 Oct 2014 18:44:35 -0400
Message-Id: <1412721875-39569-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sdb
 # mount -t btrfs /dev/sdb /mnt -o compress=lzo
 # dd if=/dev/zero of=/mnt/data bs=$((33*4096)) count=1

after previous steps, inode will be detected as bad compression ratio,
and NOCOMPRESS flag will be set for that inode.

Reason is that compress have a max limit pages every time(128K), if a
132k write in, it will be splitted into two write(128k+4k), this bug
is a leftover for commit 68bb462d42a(Btrfs: don't compress for a small write)

Fix this problem by checking every time before compression, if it is a
small write(<=blocksize), we bail out and fall into nocompression directly.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 fs/btrfs/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 344a322..b78e90a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -411,14 +411,6 @@ static noinline int compress_file_range(struct inode *inode,
 	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		btrfs_add_inode_defrag(NULL, inode);
 
-	/*
-	 * skip compression for a small file range(<=blocksize) that
-	 * isn't an inline extent, since it dosen't save disk space at all.
-	 */
-	if ((end - start + 1) <= blocksize &&
-	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
-		goto cleanup_and_bail_uncompressed;
-
 	actual_end = min_t(u64, isize, end + 1);
 again:
 	will_compress = 0;
@@ -440,6 +432,14 @@ again:
 
 	total_compressed = actual_end - start;
 
+	/*
+	 * skip compression for a small file range(<=blocksize) that
+	 * isn't an inline extent, since it dosen't save disk space at all.
+	 */
+	if (total_compressed <= blocksize &&
+	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
+		goto cleanup_and_bail_uncompressed;
+
 	/* we want to make sure that amount of ram required to uncompress
 	 * an extent is reasonable, so we limit the total size in ram
 	 * of a compressed extent to 128k.  This is a crucial number
-- 
1.8.3.1

