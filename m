Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57963 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3CLRbN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:13 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D82BE9A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:12 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id VMhcjzPGIj4pAFHg (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:12 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/10] btrfs-progs: Fix error handling for failed reads in restore tool when mirrors exist
Date: Tue, 12 Mar 2013 13:38:11 -0400
Message-ID: <1363109897-7931-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Marcin <djmarcin@google.com>

Signed-off-by: David Marcin <djmarcin@google.com>
---
 cmds-restore.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 617f507..9781801 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -198,7 +198,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	int compress;
 	int ret;
 	int dev_fd;
-	int mirror_num = 0;
+	int mirror_num = 1;
 	int num_copies;
 
 	compress = btrfs_file_extent_compression(leaf, fi);
@@ -241,14 +241,15 @@ again:
 
 	if (size_left < length)
 		length = size_left;
-	size_left -= length;
 
 	done = pread(dev_fd, inbuf+count, length, dev_bytenr);
-	if (done < length) {
+	/* Need both checks, or we miss negative values due to u64 conversion */
+	if (done < 0 || done < length) {
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      bytenr, length);
 		mirror_num++;
-		if (mirror_num >= num_copies) {
+		/* mirror_num is 1-indexed, so num_copies is a valid mirror. */
+		if (mirror_num > num_copies) {
 			ret = -1;
 			fprintf(stderr, "Exhausted mirrors trying to read\n");
 			goto out;
@@ -257,6 +258,8 @@ again:
 		goto again;
 	}
 
+	mirror_num = 1;
+	size_left -= length;
 	count += length;
 	bytenr += length;
 	if (size_left)
-- 
1.7.7.6

