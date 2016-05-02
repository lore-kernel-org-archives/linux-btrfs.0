Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbcEBQco (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 12:32:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3EB67ABA6
	for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2016 16:32:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: mfasheh@suse.de, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fi du: switch to negative error codes
Date: Mon,  2 May 2016 18:32:26 +0200
Message-Id: <1462206746-20735-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're using the kernel-style negative error numbers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-fi-du.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 168fc722e349..84316b4e4a0c 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -83,7 +83,7 @@ static int add_shared_extent(u64 start, u64 len, struct rb_root *root)
 
 	sh = calloc(1, sizeof(*sh));
 	if (!sh)
-		return ENOMEM;
+		return -ENOMEM;
 
 	sh->start = start;
 	sh->last = (start + len - 1);
@@ -233,7 +233,7 @@ static int mark_inode_seen(u64 ino, u64 subvol)
 
 	si = calloc(1, sizeof(*si));
 	if (!si)
-		return ENOMEM;
+		return -ENOMEM;
 
 	si->i_ino = ino;
 	si->i_subvol = subvol;
@@ -259,7 +259,7 @@ static int inode_seen(u64 ino, u64 subvol)
 		else if (cmp > 0)
 			n = n->rb_right;
 		else
-			return EEXIST;
+			return -EEXIST;
 	}
 	return 0;
 }
@@ -308,7 +308,7 @@ static int du_calc_file_space(int fd, struct rb_root *shared_extents,
 		fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
-			ret = errno;
+			ret = -errno;
 			goto out;
 		}
 
@@ -418,17 +418,15 @@ static int du_add_file(const char *filename, int dirfd,
 	DIR *dirstream = NULL;
 
 	ret = fstatat(dirfd, filename, &st, 0);
-	if (ret) {
-		ret = errno;
-		return ret;
-	}
+	if (ret)
+		return -errno;
 
 	if (!S_ISREG(st.st_mode) && !S_ISDIR(st.st_mode))
 		return 0;
 
 	if (len > (path_max - pathp)) {
 		error("path too long: %s %s", path, filename);
-		return ENAMETOOLONG;
+		return -ENAMETOOLONG;
 	}
 
 	pathtmp = pathp;
@@ -440,7 +438,7 @@ static int du_add_file(const char *filename, int dirfd,
 
 	fd = open_file_or_dir3(path, &dirstream, O_RDONLY);
 	if (fd < 0) {
-		ret = fd;
+		ret = -errno;
 		goto out;
 	}
 
@@ -568,7 +566,7 @@ int cmd_filesystem_du(int argc, char **argv)
 		ret = du_add_file(argv[i], AT_FDCWD, NULL, NULL, NULL, 1);
 		if (ret) {
 			error("cannot check space of '%s': %s", argv[i],
-					strerror(ret));
+					strerror(-ret));
 			err = 1;
 		}
 
-- 
2.7.1

