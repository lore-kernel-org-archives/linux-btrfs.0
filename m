Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32809 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047AbaGWFrl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 01:47:41 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6N5lbrD029300
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 13:47:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: Remove fprintf() in find_mount_root().
Date: Wed, 23 Jul 2014 13:47:34 +0800
Message-ID: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_mount_root() function in utils.c should not print error string.
Caller should be responsible to print error string.

This patch will remove the only fprintf in find_mount_root() and modify
the caller a little to use strerror() to prompt users.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-receive.c | 4 ++--
 cmds-send.c    | 4 ++--
 utils.c        | 6 +-----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 48380a5..72afe2a 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -980,9 +980,9 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 
 	ret = find_mount_root(dest_dir_full_path, &r->root_path);
 	if (ret < 0) {
-		ret = -EINVAL;
 		fprintf(stderr, "ERROR: failed to determine mount point "
-			"for %s\n", dest_dir_full_path);
+			"for %s: %s\n", dest_dir_full_path, strerror(-ret));
+		ret = -EINVAL;
 		goto out;
 	}
 	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
diff --git a/cmds-send.c b/cmds-send.c
index 9a73b32..48c3df4 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -356,9 +356,9 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
 
 	ret = find_mount_root(subvol, &s->root_path);
 	if (ret < 0) {
-		ret = -EINVAL;
 		fprintf(stderr, "ERROR: failed to determine mount point "
-				"for %s\n", subvol);
+				"for %s: %s\n", subvol, strerror(-ret));
+		ret = -EINVAL;
 		goto out;
 	}
 
diff --git a/utils.c b/utils.c
index 11250d9..2d0f18e 100644
--- a/utils.c
+++ b/utils.c
@@ -2422,12 +2422,8 @@ int find_mount_root(const char *path, char **mount_root)
 	}
 	endmntent(mnttab);
 
-	if (!longest_match) {
-		fprintf(stderr,
-			"ERROR: Failed to find mount root for path %s.\n",
-			path);
+	if (!longest_match)
 		return -ENOENT;
-	}
 
 	ret = 0;
 	*mount_root = realpath(longest_match, NULL);
-- 
2.0.2

