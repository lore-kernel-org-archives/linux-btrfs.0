Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:48343 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab2HTL5S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 07:57:18 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: Robert Buhren <robert@robertbuhren.de>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs-progs: replace find_mount_root from send code
Date: Mon, 20 Aug 2012 13:57:15 +0200
Message-Id: <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <5028D57F.5090803@robertbuhren.de>
References: <5028D57F.5090803@robertbuhren.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Robert,

i made a quick patch, can you please give it a try? Can be applied with
"git am --scissors".

Thanks,
-Jan

-- >8 --

find_mount_root had the problem that it tried to conclude from a file system
path to a mount point, taking the fsid as an indicator. This only works if
no two subvolumes (sharing the same btrfs fsid) are mounted in the same
hierarchy.

Now instead, we're parsing /etc/mtab and look for the longest match.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 cmds-send.c |   88 ++++++++++++++---------------------------------------------
 1 files changed, 21 insertions(+), 67 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 8a0c110..41ea523 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -28,6 +28,7 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 #include <libgen.h>
+#include <mntent.h>
 
 #include <uuid/uuid.h>
 
@@ -55,82 +56,35 @@ struct btrfs_send {
 
 int find_mount_root(const char *path, char **mount_root)
 {
-	int ret;
-	char *cur;
-	char fsid[BTRFS_FSID_SIZE];
+	FILE *mnttab;
 	int fd;
-	struct stat st;
-	char *tmp;
-	char *dup = NULL;
-
-	struct btrfs_ioctl_fs_info_args args;
+	struct mntent *ent;
+	int len;
+	int longest_matchlen = 0;
+	char *longest_match = NULL;
 
 	fd = open(path, O_RDONLY | O_NOATIME);
-	if (fd < 0) {
-		ret = -errno;
-		goto out;
-	}
-
-	ret = fstat(fd, &st);
-	if (fd < 0) {
-		ret = -errno;
-		goto out;
-	}
-	if (!S_ISDIR(st.st_mode)) {
-		ret = -ENOTDIR;
-		goto out;
-	}
-
-	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
-	if (fd < 0) {
-		ret = -errno;
-		goto out;
-	}
-	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
+	if (fd < 0)
+		return -errno;
 	close(fd);
-	fd = -1;
 
-	cur = strdup(path);
-
-	while (1) {
-		dup = strdup(cur);
-		tmp = dirname(dup);
-
-		if (!tmp)
-			break;
-		fd = open(tmp, O_RDONLY | O_NOATIME);
-		if (fd < 0) {
-			ret = -errno;
-			goto out;
+	mnttab = fopen("/etc/mtab", "r");
+	while ((ent = getmntent(mnttab))) {
+		len = strlen(ent->mnt_dir);
+		if (strncmp(ent->mnt_dir, path, len) == 0) {
+			/* match found */
+			if (longest_matchlen < len) {
+				free(longest_match);
+				longest_matchlen = len;
+				longest_match = strdup(ent->mnt_dir);
+			}
 		}
-
-		ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
-		close(fd);
-		fd = -1;
-		if (ret < 0)
-			break;
-		if (memcmp(fsid, args.fsid, BTRFS_FSID_SIZE) != 0)
-			break;
-
-		free(cur);
-		cur = strdup(tmp);
-		free(dup);
-		dup = NULL;
-		if (strcmp(cur, "/") == 0)
-			break;
-		if (strcmp(cur, ".") == 0)
-			break;
 	}
 
-	ret = 0;
-	*mount_root = realpath(cur, NULL);
+	*mount_root = realpath(longest_match, NULL);
+	free(longest_match);
 
-out:
-	if (dup)
-		free(dup);
-	if (fd != -1)
-		close(fd);
-	return ret;
+	return 0;
 }
 
 static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
-- 
1.7.1

