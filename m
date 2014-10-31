Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23757 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbaJaSBv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:01:51 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/11] Btrfs-progs: spit out the broken file when ignoring errors
Date: Fri, 31 Oct 2014 14:01:23 -0400
Message-ID: <1414778489-4049-6-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's nice to ignore errors on restore, but spit out the filename so the user
knows which files of his aren't going to look right.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-restore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 38a131e..b52d5c8 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -840,6 +840,8 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			ret = copy_file(root, fd, &location, path_name);
 			close(fd);
 			if (ret) {
+				fprintf(stderr, "Error copying data for %s\n",
+					path_name);
 				if (ignore_errors)
 					goto next;
 				btrfs_free_path(path);
@@ -917,6 +919,8 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 					 output_rootdir, dir, mreg);
 			free(dir);
 			if (ret) {
+				fprintf(stderr, "Error searching %s\n",
+					path_name);
 				if (ignore_errors)
 					goto next;
 				btrfs_free_path(path);
-- 
1.8.3.1

