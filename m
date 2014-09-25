Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14131 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbaIYUq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 16:46:58 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8PKjPcp032124
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:46:57 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pkytgtpc6-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:46:57 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: let btrfs-image actually work on a balanced fs
Date: Thu, 25 Sep 2014 16:46:55 -0400
Message-ID: <1411678015-5928-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use the read extent buffer infrastructure to read the super block when we are
creating a btrfs-image.  This works out fine most of the time except when the fs
has been balanced, then it fails to map the super block.  So we could fix
btrfs-image to read in the super in a special way, but thats more code.  So
instead just check in the eb reading code if we are reading the super and then
don't bother mapping the block, just read the actual offset.  This fixed some
poor guy who was trying to btrfs-image his fs that had been balanced.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-image.c | 5 ++++-
 disk-io.c     | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index cb17f16..6643ad1 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1020,6 +1020,9 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 	int i = 0;
 	int ret;
 
+	if (btrfs_header_bytenr(eb) == 65536)
+		printf("We have bytenr 65536, belongs to %llu, level %d\n",
+		       btrfs_header_owner(eb), btrfs_header_level(eb));
 	ret = add_extent(btrfs_header_bytenr(eb), root->leafsize, metadump, 0);
 	if (ret) {
 		fprintf(stderr, "Error adding metadata block\n");
@@ -1279,7 +1282,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	}
 
 	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, BTRFS_SUPER_INFO_SIZE,
-			&metadump, 0);
+			&metadump, 1);
 	if (ret) {
 		fprintf(stderr, "Error adding metadata %d\n", ret);
 		err = ret;
diff --git a/disk-io.c b/disk-io.c
index 26a532e..34c0a97 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -201,7 +201,8 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 		read_len = bytes_left;
 		device = NULL;
 
-		if (!info->on_restoring) {
+		if (!info->on_restoring &&
+		    eb->start != BTRFS_SUPER_INFO_OFFSET) {
 			ret = btrfs_map_block(&info->mapping_tree, READ,
 					      eb->start + offset, &read_len, &multi,
 					      mirror, NULL);
-- 
1.9.3

