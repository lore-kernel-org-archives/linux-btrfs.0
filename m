Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60556 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbaDHPhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 11:37:33 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so7307240wiv.4
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 08:37:31 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: restore, for compressed extents don't read more bytes than needed
Date: Tue,  8 Apr 2014 17:37:22 +0100
Message-Id: <1396975042-14465-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to read a number of bytes corresponding to the disk size of the file extent
item, and not to the number of bytes in the num_bytes field. Normally disk_size is
smaller than num_bytes (when using compression), except for files created with lzo
compression in a kernel older then the one which introduced the following change:

commit 59516f6017c589e7316418fda6128ba8f829a77f
Author: Stefan Agner <stefan@agner.ch>
Date:   Mon Jul 1 20:33:39 2013 +0200

    Btrfs: return -1 when lzo compression makes data bigger

    With this fix the lzo code behaves like the zlib code by returning an
    error
    code when compression does not help reduce the size of the file.
    This is currently not a bug since the compressed size is checked again
    in
    the calling method compress_file_range.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 07a0e63..2ecbc94 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -297,7 +297,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
 	offset = btrfs_file_extent_offset(leaf, fi);
 	num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
-	size_left = num_bytes;
+	size_left = disk_size;
 	if (compress == BTRFS_COMPRESS_NONE)
 		bytenr += offset;
 
@@ -376,7 +376,7 @@ again:
 		goto out;
 	}
 
-	ret = decompress(inbuf, outbuf, num_bytes, &ram_size, compress);
+	ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
 	if (ret) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
-- 
1.9.1

