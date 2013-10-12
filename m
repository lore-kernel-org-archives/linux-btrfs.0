Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57851 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3JLPu3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Oct 2013 11:50:29 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq14so5682350pab.40
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Oct 2013 08:50:28 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] Btrfs-progs: check return value of realpath(3)
Date: Sat, 12 Oct 2013 23:47:52 +0800
Message-Id: <1381592872-24751-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a segfault when deleting a subvolume with very long name(>4096),
it's because cmd_subvol_delete() calls strdup() and passes NULL as
argument, which is returned by realpath(3).

I used the following script to reproduce

	#!/bin/bash
	mnt=$1
	i=1
	path=$mnt/subvol_$i

	# Create very deep subvolumes
	while btrfs sub create $path;do
	      ((i++))
	      path="$path/subvol_$i"
	done
	last_vol=$(dirname $path)
	dir=$(dirname $last_vol)
	vol=$(basename $last_vol)

	# Try to delete tha last one, this would get segfault
	pushd $dir
	btrfs sub delete $vol
	popd

Fix it by checking return value of realpath(3), also fix the one in
find_mount_root().

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-send.c      | 8 ++++++--
 cmds-subvolume.c | 6 ++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 0057e6b..9e4d031 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -62,6 +62,7 @@ int find_mount_root(const char *path, char **mount_root)
 	int fd;
 	struct mntent *ent;
 	int len;
+	int ret;
 	int longest_matchlen = 0;
 	char *longest_match = NULL;
 
@@ -91,10 +92,13 @@ int find_mount_root(const char *path, char **mount_root)
 		return -ENOENT;
 	}
 
+	ret = 0;
 	*mount_root = realpath(longest_match, NULL);
-	free(longest_match);
+	if (!mount_root)
+		ret = -errno;
 
-	return 0;
+	free(longest_match);
+	return ret;
 }
 
 static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..f7249f8 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -225,6 +225,12 @@ again:
 	}
 
 	cpath = realpath(path, 0);
+	if (!cpath) {
+		ret = errno;
+		fprintf(stderr, "ERROR: finding real path for '%s': %s\n",
+			path, strerror(errno));
+		goto out;
+	}
 	dname = strdup(cpath);
 	dname = dirname(dname);
 	vname = strdup(cpath);
-- 
1.8.3.1

