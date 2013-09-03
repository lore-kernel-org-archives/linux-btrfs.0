Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:59459 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933Ab3ICLUS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 07:20:18 -0400
Received: by mail-we0-f178.google.com with SMTP id p58so633654wes.37
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 04:20:17 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RESEND] Btrfs-progs: fix restore command leaving corrupted files
Date: Tue,  3 Sep 2013 12:19:58 +0100
Message-Id: <1378207198-4509-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When there are files that have parts shared with snapshots, the
restore command was incorrectly restoring them, as it was not
taking into account the offset and number of bytes fields from
the file extent item. Besides leaving the recovered file corrupt,
it was also inneficient as it read and wrote more data than needed
(with each extent copy overwriting portions of the one previously
written).

The following steps show how to reproduce this corruption issue:

$ mkfs.btrfs -f  /dev/sdb3
$ mount /dev/sdb3 /mnt/btrfs
$ perl -e '$d = "\x41" . ("\x00" x (1024*1024+349)); open($f,">","/mnt/btrfs/foobar"); print $f $d; close($f);'
$ du -b /mnt/btrfs/foobar
1048926 /mnt/btrfs/foobar
$ md5sum /mnt/btrfs/foobar
f9f778f3a7410c40e4ed104a3a63c3c4  /mnt/btrfs/foobar

$ btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/my_snap
$ perl -e 'open($f, "+<", "/mnt/btrfs/foobar"); seek($f, 4096, 0); print $f "\xff"; close($f);'
$ md5sum /mnt/btrfs/foobar
b983fcefd4622a03a78936484c40272b  /mnt/btrfs/foobar
$ umount /mnt/btrfs

$ btrfs restore /dev/sdb3 /tmp/copy
$ du -b /tmp/copy/foobar
1048926 /tmp/copy/foobar
$ md5sum /tmp/copy/foobar
88db338cbc1c44dfabae083f1ce642d5  /tmp/copy/foobar
$ od -t x1 -j 8192 -N 4 /tmp/copy/foobar
0020000 41 00 00 00
0020004
$ mount /dev/sdb3 /mnt/btrfs
$ od -t x1 -j 8192 -N 4 /mnt/btrfs/foobar
0020000 00 00 00 00
0020004
$ md5sum /mnt/btrfs/foobar
b983fcefd4622a03a78936484c40272b  /mnt/btrfs/foobar

Tested this change with zlib, lzo compression and file sizes larger
than 1GiB, and found no regression or other corruption issues (so far
at least).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

This patch is based on top of branch integration-20130902.
It used to be present in older integration branches, but it suddenly
disappeared in more recent integration branches.

 cmds-restore.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 4c87483..2a05ece 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -278,6 +278,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	u64 bytenr;
 	u64 ram_size;
 	u64 disk_size;
+	u64 num_bytes;
 	u64 length;
 	u64 size_left;
 	u64 dev_bytenr;
@@ -294,7 +295,9 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	disk_size = btrfs_file_extent_disk_num_bytes(leaf, fi);
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
 	offset = btrfs_file_extent_offset(leaf, fi);
-	size_left = disk_size;
+	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+	size_left = num_bytes;
+	bytenr += offset;
 
 	if (offset)
 		printf("offset is %Lu\n", offset);
@@ -302,7 +305,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (disk_size == 0)
 		return 0;
 
-	inbuf = malloc(disk_size);
+	inbuf = malloc(size_left);
 	if (!inbuf) {
 		fprintf(stderr, "No memory\n");
 		return -1;
@@ -357,8 +360,8 @@ again:
 		goto again;
 
 	if (compress == BTRFS_COMPRESS_NONE) {
-		while (total < ram_size) {
-			done = pwrite(fd, inbuf+total, ram_size-total,
+		while (total < num_bytes) {
+			done = pwrite(fd, inbuf+total, num_bytes-total,
 				      pos+total);
 			if (done < 0) {
 				ret = -1;
@@ -371,7 +374,7 @@ again:
 		goto out;
 	}
 
-	ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
+	ret = decompress(inbuf, outbuf, num_bytes, &ram_size, compress);
 	if (ret) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
-- 
1.7.9.5

