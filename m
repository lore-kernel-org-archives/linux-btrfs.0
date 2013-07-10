Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48327 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJQMK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 12:12:10 -0400
Received: by mail-wi0-f171.google.com with SMTP id hj3so11597644wib.10
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 09:12:09 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: fix restore command leaving corrupted files
Date: Wed, 10 Jul 2013 17:11:55 +0100
Message-Id: <1373472715-21850-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373471006-20994-1-git-send-email-fdmanana@gmail.com>
References: <1373471006-20994-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When there are files that have parts shared with snapshots, the
restore command was incorrectly restoring them, as it was not
taking into account the offset and number of bytes fields from
the file extent item. Besides leaving the recovered file corrupt,
it was also inneficient as it read and wrote more data than needed
(with each extent copy overwriting portions of the one previously
written).

The following steps and small C program show how to reproduce this
corruption issue:

$ mkfs.btrfs -f  /dev/sdb3
$ mount /dev/sdb3 /mnt/btrfs
$ ./write_file /mnt/btrfs/foobar
$ du -b /mnt/btrfs/foobar
1048926 /mnt/btrfs/foobar
$ md5sum /mnt/btrfs/foobar
f9f778f3a7410c40e4ed104a3a63c3c4  /mnt/btrfs/foobar

$ btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/my_snap
$ perl -e 'open($f, "+<", "/dev/btrfs/foobar"); seek($f, 4096, 0); print $f "\xff"; close($f);'
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

$ cat write_file.c:

 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <string.h>
 #include <assert.h>

 #define BUF_SIZE (60 * 1024 * 1024 + 33350)

int main(int argc, char *argv[])
{
	int fd;
	unsigned char buf[BUF_SIZE];

	if (argc < 2) {
		fprintf(stderr, "Use:  %s filepath\n", argv[0]);
		return 1;
	}
	fd = open(argv[1], O_CREAT | O_WRONLY | O_TRUNC, S_IRWXU);
	assert(fd >= 0);
	memset(buf, 0, BUF_SIZE);
	buf[0] = 65;
	assert(write(fd, buf, BUF_SIZE) == BUF_SIZE);
	assert(close(fd) == 0);
	return 0;
}

Tested this change with zlib, lzo compression and file sizes larger
than 1GiB, and found no regression or other corruption issues (so far
at least).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: updated commit message to include the C preprocessor macros
    in the C program.

 cmds-restore.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index e48df40..9688599 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -272,6 +272,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	u64 bytenr;
 	u64 ram_size;
 	u64 disk_size;
+	u64 num_bytes;
 	u64 length;
 	u64 size_left;
 	u64 dev_bytenr;
@@ -288,7 +289,9 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	disk_size = btrfs_file_extent_disk_num_bytes(leaf, fi);
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
 	offset = btrfs_file_extent_offset(leaf, fi);
-	size_left = disk_size;
+	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+	size_left = num_bytes;
+	bytenr += offset;
 
 	if (offset)
 		printf("offset is %Lu\n", offset);
@@ -296,7 +299,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (disk_size == 0)
 		return 0;
 
-	inbuf = malloc(disk_size);
+	inbuf = malloc(size_left);
 	if (!inbuf) {
 		fprintf(stderr, "No memory\n");
 		return -1;
@@ -351,8 +354,8 @@ again:
 		goto again;
 
 	if (compress == BTRFS_COMPRESS_NONE) {
-		while (total < ram_size) {
-			done = pwrite(fd, inbuf+total, ram_size-total,
+		while (total < num_bytes) {
+			done = pwrite(fd, inbuf+total, num_bytes-total,
 				      pos+total);
 			if (done < 0) {
 				ret = -1;
@@ -365,7 +368,7 @@ again:
 		goto out;
 	}
 
-	ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
+	ret = decompress(inbuf, outbuf, num_bytes, &ram_size, compress);
 	if (ret) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
-- 
1.7.9.5

