Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11890 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316AbaGWFrm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 01:47:42 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6N5lcFM029303
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 13:47:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/4] btrfs-progs: Check fstype in find_mount_root()
Date: Wed, 23 Jul 2014 13:47:35 +0800
Message-ID: <1406094457-3100-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When calling find_mount_root(), caller in fact wants to find the mount
point of *BTRFS*.

So also check ent->fstype in find_mount_root() and do special error
string output in caller.

This will suppress a lot of "Inapproiate ioctl for device" error
message.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:
   move error message to caller.
---
 cmds-receive.c   |  7 +++++++
 cmds-send.c      | 14 ++++++++++++++
 cmds-subvolume.c |  7 +++++++
 utils.c          |  9 +++++++++
 4 files changed, 37 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 72afe2a..0644b59 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -985,6 +985,13 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		ret = -EINVAL;
 		goto out;
 	}
+	if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: %s doesn't belong to btrfs mount point\n",
+			dest_dir_full_path);
+		ret = -EINVAL;
+		goto out;
+	}
 	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
 		ret = -errno;
diff --git a/cmds-send.c b/cmds-send.c
index 48c3df4..d6b1855 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -361,6 +361,13 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
 		ret = -EINVAL;
 		goto out;
 	}
+	if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: %s doesn't belong to btrfs mount point\n",
+			subvol);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	s->mnt_fd = open(s->root_path, O_RDONLY | O_NOATIME);
 	if (s->mnt_fd < 0) {
@@ -628,6 +635,13 @@ int cmd_send(int argc, char **argv)
 				strerror(-ret));
 			goto out;
 		}
+		if (ret > 0) {
+			fprintf(stderr,
+			"ERROR: %s doesn't belong to btrfs mount point\n",
+				subvol);
+			ret = -EINVAL;
+			goto out;
+		}
 		if (strcmp(send.root_path, mount_root) != 0) {
 			ret = -EINVAL;
 			fprintf(stderr, "ERROR: all subvols must be from the "
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 639fb10..64a66e3 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -986,6 +986,13 @@ static int cmd_subvol_show(int argc, char **argv)
 				"%s\n", fullpath, strerror(-ret));
 		goto out;
 	}
+	if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: %s doesn't belong to btrfs mount point\n",
+			fullpath);
+		ret = -EINVAL;
+		goto out;
+	}
 	ret = 1;
 	svpath = get_subvol_name(mnt, fullpath);
 
diff --git a/utils.c b/utils.c
index 2d0f18e..b96d5b4 100644
--- a/utils.c
+++ b/utils.c
@@ -2390,6 +2390,9 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 	return 0;
 }
 
+/* return 0 if a btrfs mount point if found
+ * return 1 if a mount point is found but not btrfs
+ * return <0 if something goes wrong */
 int find_mount_root(const char *path, char **mount_root)
 {
 	FILE *mnttab;
@@ -2397,6 +2400,7 @@ int find_mount_root(const char *path, char **mount_root)
 	struct mntent *ent;
 	int len;
 	int ret;
+	int not_btrfs;
 	int longest_matchlen = 0;
 	char *longest_match = NULL;
 
@@ -2417,6 +2421,7 @@ int find_mount_root(const char *path, char **mount_root)
 				free(longest_match);
 				longest_matchlen = len;
 				longest_match = strdup(ent->mnt_dir);
+				not_btrfs = strcmp(ent->mnt_type, "btrfs");
 			}
 		}
 	}
@@ -2424,6 +2429,10 @@ int find_mount_root(const char *path, char **mount_root)
 
 	if (!longest_match)
 		return -ENOENT;
+	if (not_btrfs) {
+		free(longest_match);
+		return 1;
+	}
 
 	ret = 0;
 	*mount_root = realpath(longest_match, NULL);
-- 
2.0.2

