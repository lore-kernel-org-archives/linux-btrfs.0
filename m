Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15969 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813AbbBIUDh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:37 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 06/16] Btrfs-progs: don't check csums for data reloc root
Date: Mon, 9 Feb 2015 15:03:09 -0500
Message-ID: <1423512199-16552-7-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data reloc root is weird with it's csums.  It'll copy an entire extent and
then log any csums it finds, which makes it look weird when it comes to prealloc
extents.  So just skip the data reloc tree, it's special and we just don't need
to worry about it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2b08c64..2163823 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1530,7 +1530,16 @@ static int process_file_extent(struct btrfs_root *root,
 	}
 	rec->extent_end = key->offset + num_bytes;
 
-	if (disk_bytenr > 0) {
+	/*
+	 * The data reloc tree will copy full extents into its inode and then
+	 * copy the corresponding csums.  Because the extent it copied could be
+	 * a preallocated extent that hasn't been written to yet there may be no
+	 * csums to copy, ergo we won't have csums for our file extent.  This is
+	 * ok so just don't bother checking csums if the inode belongs to the
+	 * data reloc tree.
+	 */
+	if (disk_bytenr > 0 &&
+	    btrfs_header_owner(eb) != BTRFS_DATA_RELOC_TREE_OBJECTID) {
 		u64 found;
 		if (btrfs_file_extent_compression(eb, fi))
 			num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
-- 
1.8.3.1

