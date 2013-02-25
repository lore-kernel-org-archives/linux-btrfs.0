Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:54656 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759582Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/17] btrfs-progs: close fd on cmd_subvol_get_default return
Date: Mon, 25 Feb 2013 16:54:46 -0600
Message-Id: <1361832890-40921-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without this we leak the fd when we return from the
function.

Also, remove the senseless random return values.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f9258fc..0dfaefe 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -624,7 +624,7 @@ static const char * const cmd_subvol_get_default_usage[] = {
 
 static int cmd_subvol_get_default(int argc, char **argv)
 {
-	int fd;
+	int fd = -1;
 	int ret;
 	char *subvol;
 	struct btrfs_list_filter_set *filter_set;
@@ -638,35 +638,36 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		return 12;
+		return 1;
 	}
 	if (!ret) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		return 13;
+		return 1;
 	}
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
-		return 12;
+		return 1;
 	}
 
 	ret = btrfs_list_get_default_subvolume(fd, &default_id);
 	if (ret) {
 		fprintf(stderr, "ERROR: can't perform the search - %s\n",
 			strerror(errno));
-		return ret;
+		goto out;
 	}
 
+	ret = 1;
 	if (default_id == 0) {
 		fprintf(stderr, "ERROR: 'default' dir item not found\n");
-		return ret;
+		goto out;
 	}
 
 	/* no need to resolve roots if FS_TREE is default */
 	if (default_id == BTRFS_FS_TREE_OBJECTID) {
 		printf("ID 5 (FS_TREE)\n");
-		return ret;
+		goto out;
 	}
 
 	filter_set = btrfs_list_alloc_filter_set();
@@ -684,8 +685,11 @@ static int cmd_subvol_get_default(int argc, char **argv)
 
 	if (filter_set)
 		btrfs_list_free_filter_set(filter_set);
+out:
+	if (fd != -1)
+		close(fd);
 	if (ret)
-		return 19;
+		return 1;
 	return 0;
 }
 
-- 
1.7.1

