Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36685 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaBYSZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:25:49 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so737508wes.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 10:25:48 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: fix restore of files with compressed extents
Date: Tue, 25 Feb 2014 18:25:39 +0000
Message-Id: <1393352739-25073-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code was incorrectly adding the file extent items' data offset to the logical
disk address of the extent (bytenr) when the extent is compressed. The offset is
relative to the uncompressed data and not to what we store on disk (compressed).
Also it attempted to copy ram_bytes to destination, which is incorrect when the
data offset field is non-zero, it must use num_bytes instead.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 1748262..e620ee7 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -297,7 +297,8 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	offset = btrfs_file_extent_offset(leaf, fi);
 	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
 	size_left = num_bytes;
-	bytenr += offset;
+	if (compress == BTRFS_COMPRESS_NONE)
+		bytenr += offset;
 
 	if (offset)
 		printf("offset is %Lu\n", offset);
@@ -387,8 +388,10 @@ again:
 		goto again;
 	}
 
-	while (total < ram_size) {
-		done = pwrite(fd, outbuf+total, ram_size-total, pos+total);
+	while (total < num_bytes) {
+		done = pwrite(fd, outbuf + offset + total,
+			      num_bytes - total,
+			      pos + total);
 		if (done < 0) {
 			ret = -1;
 			goto out;
-- 
1.7.9.5

