Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50752 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3CLRbJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:09 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 16D347C04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:09 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id GIQiezE57tPNMXux (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:08 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/10] Btrfs-progs: try other mirrors if decomression fails
Date: Tue, 12 Mar 2013 13:38:09 -0400
Message-ID: <1363109897-7931-3-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

This will make the restore program fall back on other mirrors if it fails to
decompress an extent for whatever reason.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 467e5ef..1d24691 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -65,7 +65,7 @@ static int decompress(char *inbuf, char *outbuf, u64 compress_len,
 	ret = inflate(&strm, Z_NO_FLUSH);
 	if (ret != Z_STREAM_END) {
 		(void)inflateEnd(&strm);
-		fprintf(stderr, "ret is %d\n", ret);
+		fprintf(stderr, "failed to inflate: %d\n", ret);
 		return -1;
 	}
 
@@ -198,6 +198,8 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	int compress;
 	int ret;
 	int dev_fd;
+	int mirror_num = 0;
+	int num_copies;
 
 	compress = btrfs_file_extent_compression(leaf, fi);
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
@@ -226,12 +228,10 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 again:
 	length = size_left;
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			      bytenr, &length, &multi, 0, NULL);
+			      bytenr, &length, &multi, mirror_num, NULL);
 	if (ret) {
-		free(inbuf);
-		free(outbuf);
 		fprintf(stderr, "Error mapping block %d\n", ret);
-		return ret;
+		goto out;
 	}
 	device = multi->stripes[0].dev;
 	dev_fd = device->fd;
@@ -245,10 +245,9 @@ again:
 
 	done = pread(dev_fd, inbuf+count, length, dev_bytenr);
 	if (done < length) {
-		free(inbuf);
-		free(outbuf);
+		ret = -1;
 		fprintf(stderr, "Short read %d\n", errno);
-		return -1;
+		goto out;
 	}
 
 	count += length;
@@ -256,41 +255,46 @@ again:
 	if (size_left)
 		goto again;
 
-
 	if (compress == BTRFS_COMPRESS_NONE) {
 		while (total < ram_size) {
 			done = pwrite(fd, inbuf+total, ram_size-total,
 				      pos+total);
 			if (done < 0) {
-				free(inbuf);
+				ret = -1;
 				fprintf(stderr, "Error writing: %d %s\n", errno, strerror(errno));
-				return -1;
+				goto out;
 			}
 			total += done;
 		}
-		free(inbuf);
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	ret = decompress(inbuf, outbuf, disk_size, ram_size);
-	free(inbuf);
 	if (ret) {
-		free(outbuf);
-		return ret;
+		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+					      bytenr, length);
+		mirror_num++;
+		if (mirror_num >= num_copies) {
+			ret = -1;
+			goto out;
+		}
+		fprintf(stderr, "Trying another mirror\n");
+		goto again;
 	}
 
 	while (total < ram_size) {
 		done = pwrite(fd, outbuf+total, ram_size-total, pos+total);
 		if (done < 0) {
-			free(outbuf);
-			fprintf(stderr, "Error writing: %d %s\n", errno, strerror(errno));
-			return -1;
+			ret = -1;
+			goto out;
 		}
 		total += done;
 	}
+out:
+	free(inbuf);
 	free(outbuf);
-
-	return 0;
+	return ret;
 }
 
 static int ask_to_continue(const char *file)
-- 
1.7.7.6

