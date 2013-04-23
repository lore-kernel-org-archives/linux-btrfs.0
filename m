Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:10330 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab3DWKS7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 06:18:59 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.27 OK)
	with ESMTP id g04953p3N9C5Lg for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Apr 2013 12:18:55 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add function to map subvol ID to path
Date: Tue, 23 Apr 2013 12:18:55 +0200
Message-Id: <1366712335-13322-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several tools like btrfs-send and btrfs-receive need to map a
subvolume ID to a filesystem path. The so far existing methods
in btrfs-list.c cause a horrible effort when performing this
operation (and the effort is dependent on the number of
existing subvolumes with quadratic effort). This commit adds a
function that is able to map a subvolume ID to a filesystem path
with an effort that is independent of the number of existing
subvolumes.

In addition to this function, a command line frontend is added as well:
btrfs inspect-internal subvolid-resolve <subvolid> <path>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
A following commit will also use this function (in addition to the
usage in "btrfs inspect-internal"). I send this commit on its own
because the function is of general use IMO. The effort of the
btrfs-list.c functions is incredible and not required to map a
subvol ID to a filesystem path.

 cmds-inspect.c | 46 +++++++++++++++++++++++++++
 man/btrfs.8.in |  6 ++++
 send-utils.c   | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 send-utils.h   |  2 +-
 4 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 7761759..30b41fc 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -24,6 +24,8 @@
 #include "kerncompat.h"
 #include "ioctl.h"
 #include "utils.h"
+#include "ctree.h"
+#include "send-utils.h"
 
 #include "commands.h"
 #include "btrfs-list.h"
@@ -253,12 +255,56 @@ out:
 	return ret;
 }
 
+static const char * const cmd_subvolid_resolve_usage[] = {
+	"btrfs inspect-internal subvolid-resolve <subvolid> <path>",
+	"Get file system paths for the given subvolume ID.",
+	NULL
+};
+
+static int cmd_subvolid_resolve(int argc, char **argv)
+{
+	int ret;
+	int fd = -1;
+	u64 subvol_id;
+	char path[BTRFS_PATH_NAME_MAX + 1];
+
+	if (check_argc_exact(argc, 3))
+		usage(cmd_subvolid_resolve_usage);
+
+	fd = open_file_or_dir(argv[2]);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[2]);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	subvol_id = atoll(argv[1]);
+	ret = btrfs_subvolid_resolve(fd, path, sizeof(path), subvol_id);
+
+	if (ret) {
+		fprintf(stderr,
+			"%s: btrfs_subvolid_resolve(subvol_id %llu) failed with ret=%d\n",
+			argv[0], (unsigned long long)subvol_id, ret);
+		goto out;
+	}
+
+	path[BTRFS_PATH_NAME_MAX] = '\0';
+	printf("%s\n", path);
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return ret ? 1 : 0;
+}
+
 const struct cmd_group inspect_cmd_group = {
 	inspect_cmd_group_usage, NULL, {
 		{ "inode-resolve", cmd_inode_resolve, cmd_inode_resolve_usage,
 			NULL, 0 },
 		{ "logical-resolve", cmd_logical_resolve,
 			cmd_logical_resolve_usage, NULL, 0 },
+		{ "subvolid-resolve", cmd_subvolid_resolve,
+			cmd_subvolid_resolve_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 0b2538e..d9af323 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -60,6 +60,8 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
 [-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBinspect-internal subvolid-resolve\fP \fI<subvolid>\fP \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBqgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBqgroup remove\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
@@ -456,6 +458,10 @@ not enough to read all the resolved results. The max value one can set is 64k.
 .RE
 .TP
 
+\fBinspect-internal subvolid-resolve\fP \fI<subvolid>\fP \fI<path>\fP
+Get file system paths for the given subvolume ID.
+.TP
+
 \fBbtrfs qgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
 Enable subvolume qgroup support for a filesystem.
 .TP
diff --git a/send-utils.c b/send-utils.c
index bc0feb8..bacd47e 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -23,6 +23,105 @@
 #include "ioctl.h"
 #include "btrfs-list.h"
 
+static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
+				      u64 subvol_id);
+
+int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id)
+{
+	if (path_len < 1)
+		return -EOVERFLOW;
+	path[0] = '\0';
+	path_len--;
+	path[path_len] = '\0';
+	return btrfs_subvolid_resolve_sub(fd, path, &path_len, subvol_id);
+}
+
+static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
+				      u64 subvol_id)
+{
+	int ret;
+	struct btrfs_ioctl_search_args search_arg;
+	struct btrfs_ioctl_ino_lookup_args ino_lookup_arg;
+	struct btrfs_ioctl_search_header *search_header;
+	struct btrfs_root_ref *backref_item;
+
+	if (subvol_id == BTRFS_FS_TREE_OBJECTID) {
+		if (*path_len < 1)
+			return -EOVERFLOW;
+		*path = '\0';
+		(*path_len)--;
+		return 0;
+	}
+
+	memset(&search_arg, 0, sizeof(search_arg));
+	search_arg.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	search_arg.key.min_objectid = subvol_id;
+	search_arg.key.max_objectid = subvol_id;
+	search_arg.key.min_type = BTRFS_ROOT_BACKREF_KEY;
+	search_arg.key.max_type = BTRFS_ROOT_BACKREF_KEY;
+	search_arg.key.max_offset = (u64)-1;
+	search_arg.key.max_transid = (u64)-1;
+	search_arg.key.nr_items = 1;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_arg);
+	if (ret) {
+		fprintf(stderr,
+			"ioctl(BTRFS_IOC_TREE_SEARCH, subvol_id %llu) ret=%d, error: %s\n",
+			(unsigned long long)subvol_id, ret, strerror(errno));
+		return ret;
+	}
+
+	if (search_arg.key.nr_items < 1) {
+		fprintf(stderr,
+			"failed to lookup subvol_id %llu!\n",
+			(unsigned long long)subvol_id);
+		return -ENOENT;
+	}
+	search_header = (struct btrfs_ioctl_search_header *)search_arg.buf;
+	backref_item = (struct btrfs_root_ref *)(search_header + 1);
+	if (search_header->offset != BTRFS_FS_TREE_OBJECTID) {
+		int sub_ret;
+
+		sub_ret = btrfs_subvolid_resolve_sub(fd, path, path_len,
+						     search_header->offset);
+		if (sub_ret)
+			return sub_ret;
+		if (*path_len < 1)
+			return -EOVERFLOW;
+		strcat(path, "/");
+		(*path_len)--;
+	}
+
+	if (btrfs_stack_root_ref_dirid(backref_item) !=
+	    BTRFS_FIRST_FREE_OBJECTID) {
+		int len;
+
+		memset(&ino_lookup_arg, 0, sizeof(ino_lookup_arg));
+		ino_lookup_arg.treeid = search_header->offset;
+		ino_lookup_arg.objectid =
+			btrfs_stack_root_ref_dirid(backref_item);
+		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_lookup_arg);
+		if (ret) {
+			fprintf(stderr,
+				"ioctl(BTRFS_IOC_INO_LOOKUP) ret=%d, error: %s\n",
+				ret, strerror(errno));
+			return ret;
+		}
+
+		len = strlen(ino_lookup_arg.name);
+		if (*path_len < len)
+			return -EOVERFLOW;
+		strcat(path, ino_lookup_arg.name);
+		(*path_len) -= len;
+	}
+
+	if (*path_len < btrfs_stack_root_ref_name_len(backref_item))
+		return -EOVERFLOW;
+	strncat(path, (char *)(backref_item + 1),
+		btrfs_stack_root_ref_name_len(backref_item));
+	(*path_len) -= btrfs_stack_root_ref_name_len(backref_item);
+	return 0;
+}
+
 static struct rb_node *tree_insert(struct rb_root *root,
 				   struct subvol_info *si,
 				   enum subvol_search_type type)
diff --git a/send-utils.h b/send-utils.h
index 78abf94..06af75f 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -70,7 +70,7 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 void subvol_uuid_search_add(struct subvol_uuid_search *s,
 			    struct subvol_info *si);
 
-
+int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id);
 
 char *path_cat(const char *p1, const char *p2);
 char *path_cat3(const char *p1, const char *p2, const char *p3);
-- 
1.8.2.1

