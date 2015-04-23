Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030684AbbDWVMJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 17:12:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 309E5AB22
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 21:12:07 +0000 (UTC)
Date: Thu, 23 Apr 2015 14:12:06 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: David Sterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH][RFC] btrfs-progs: add 'du' command
Message-ID: <20150423211206.GQ17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch adds a 'du' subcommand to btrfs. 'btrfs fi du' will
calculate disk usage of the target files using fiemap. For individual
files, it will report a count of total bytes, and exclusive (not
shared) bytes. We also calculate a 'set shared' value which is
described below.

Each argument to 'btrfs fi du' will have a 'set shared' value
calculated for it. We define each 'set' as those files found by a
recursive search of an argument to btrfs fi du. The 'set shared' value
then is a sum of all shared space referenced by the set.

'set shared' takes into account overlapping shared extents, hence it
isn't as simple as adding up shared extents. To efficiently find
overlapping regions, we store them in an interval tree. When the scan
of a file set is complete, we can walk the tree and calculate our
actual shared bytes while also taking into account any duplicate or
overlapping extents.

The interval tree implementation is taken from Linux v4.0-rc7. I went
ahead and made some small comment updates to rbtree.h and
rbtree_augmented.h while I was importing this code as both are used by
the interval tree and I needed to check for any code changes in those
headers (there weren't any).

Following this paragraph is a very simple example. I started with a
clean btrfs fs in which i copied vmlinuz from /boot. I then made a
snapshot of the fs root in 'snap1'. After the snapshot, I made a 2nd
copy of vmlinuz into the main fs to give us some not-shared data. The
output below shows a sum of all the space, and a 'set shared' with len
exactly equal to that of the single shared file.

# btrfs fi du .
total	exclusive	set shared	filename
4362240	0			./vmlinuz-4.0.0-rc7
4362240	0			./snap1/vmlinuz-4.0.0-rc7
4362240	0			./snap1
4362240	4362240			./vmlinuz-4.0.0-rc7.copy
13086720	4362240	4362240	.


A git tree of the patches can be found here:

https://github.com/markfasheh/btrfs-progs-patches/tree/du

or if you prefer to pull:

git pull https://github.com/markfasheh/btrfs-progs-patches du

Attached to this e-mail is a single patch version of the change.

Comments/feedback appreciated.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>

diff --git a/Makefile.in b/Makefile.in
index 83927e4..6095b6e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -40,7 +40,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
-	       cmds-property.o cmds-fi-disk_usage.o
+	       cmds-property.o cmds-fi-disk_usage.o cmds-du.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/cmds-du.c b/cmds-du.c
new file mode 100644
index 0000000..6ca2c99
--- /dev/null
+++ b/cmds-du.c
@@ -0,0 +1,569 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <dirent.h>
+
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+
+#include "utils.h"
+#include "commands.h"
+#include "kerncompat.h"
+#include "rbtree.h"
+
+#include "interval_tree.h"
+#include "interval_tree_generic.h"
+
+static int summarize = 0;
+static unsigned unit_mode = UNITS_RAW;
+static char path[PATH_MAX] = { 0, };
+static char *pathp = path;
+static char *path_max = &path[PATH_MAX - 1];
+
+struct shared_extent {
+	struct rb_node	rb;
+	u64	start;	/* Start of interval */
+	u64	last;	/* Last location _in_ interval */
+	u64	__subtree_last;
+};
+
+/*
+ * extent_tree_* functions are defined in the massive interval tree
+ * macro below. This serves to illustrate the api in human-readable
+ * terms.
+ */
+static void
+extent_tree_insert(struct shared_extent *node, struct rb_root *root);
+
+static void
+extent_tree_remove(struct shared_extent *node, struct rb_root *root);
+
+static struct shared_extent *
+extent_tree_iter_first(struct rb_root *root,
+		       u64 start, u64 last);
+
+static struct shared_extent *
+extent_tree_iter_next(struct shared_extent *node,
+			u64 start, u64 last);
+
+#define START(node) ((node)->start)
+#define LAST(node)  ((node)->last)
+
+INTERVAL_TREE_DEFINE(struct shared_extent, rb,
+		     u64, __subtree_last,
+		     START, LAST, static, extent_tree)
+
+static int add_shared_extent(u64 start, u64 len, struct rb_root *root)
+{
+	struct shared_extent *sh;
+
+	BUG_ON(len == 0);
+
+	sh = calloc(1, sizeof(*sh));
+	if (!sh)
+		return ENOMEM;
+
+	sh->start = start;
+	sh->last = (start + len - 1);
+
+	extent_tree_insert(sh, root);
+
+	return 0;
+}
+
+static void cleanup_shared_extents(struct rb_root *root)
+{
+	struct shared_extent *s;
+	struct shared_extent *tmp;
+
+	if (!root)
+		return;
+
+	s = extent_tree_iter_first(root, 0, -1ULL);
+	while (s) {
+		tmp = extent_tree_iter_next(s, 0, -1ULL);
+		extent_tree_remove(s, root);
+
+		free(s);
+		s = tmp;
+	}
+}
+
+#define dprintf(...)
+
+/*
+ * Find all extents which overlap 'n', calculate the space
+ * covered by them and remove those nodes from the tree.
+ */
+static u64 count_unique_bytes(struct rb_root *root, struct shared_extent *n)
+{
+	struct shared_extent *tmp;
+	u64 wstart = n->start;
+	u64 wlast = n->last;
+
+	dprintf("Count overlaps:");
+
+	do {
+		/*
+		 * Expand our search window based on the lastest
+		 * overlapping extent. Doing this will allow us to
+		 * find all possible overlaps
+		 */
+		if (wstart > n->start)
+			wstart = n->start;
+		if (wlast < n->last)
+			wlast = n->last;
+
+		dprintf(" (%llu, %llu)", n->start, n->last);
+
+		tmp = n;
+		n = extent_tree_iter_next(n, wstart, wlast);
+
+		extent_tree_remove(tmp, root);
+		free(tmp);
+	} while (n);
+
+	dprintf("; wstart: %llu wlast: %llu total: %llu\n", wstart,
+		wlast, wlast - wstart + 1);
+
+	return wlast - wstart + 1;
+}
+
+/*
+ * What we want to do here is get a count of shared bytes within the
+ * set of extents we have collected. Specifcally, we don't want to
+ * count any byte more than once, so just adding them up doesn't
+ * work.
+ *
+ * For each set of overlapping extents we find the lowest start and
+ * highest end. From there we have the actual number of bytes which is
+ * shared across all of the extents in our set. A sum of each sets
+ * extent length is returned.
+ */
+static void count_shared_bytes(struct rb_root *root, u64 *ret_cnt)
+{
+	u64 count = 0;
+	struct shared_extent *s = extent_tree_iter_first(root,
+							 0, -1ULL);
+
+	if (!s)
+		goto out;
+
+	while (s) {
+		/*
+		 * Find all extents which overlap 's', calculate the space
+		 * covered by them and remove those nodes from the tree.
+		 */
+		count += count_unique_bytes(root, s);
+
+		/*
+		 * Since count_unique_bytes will be emptying the tree,
+		 * we can grab the first node here
+		 */
+		s = extent_tree_iter_first(root, 0, -1ULL);
+	}
+
+	BUG_ON(!RB_EMPTY_ROOT(root));
+out:
+	*ret_cnt = count;
+}
+
+/* Track which inodes we've seen for the purposes of hardlink detection. */
+struct seen_inode {
+	struct rb_node	i_node;
+	u64		i_ino;
+	u64		i_subvol;
+};
+static struct rb_root seen_inodes = RB_ROOT;
+
+static int cmp_si(struct seen_inode *si, u64 ino, u64 subvol)
+{
+	if (ino < si->i_ino)
+		return -1;
+	else if (ino > si->i_ino)
+		return 1;
+	if (subvol < si->i_subvol)
+		return -1;
+	else if (subvol > si->i_subvol)
+		return 1;
+	return 0;
+}
+
+static int mark_inode_seen(u64 ino, u64 subvol)
+{
+	int cmp;
+	struct rb_node **p = &seen_inodes.rb_node;
+	struct rb_node *parent = NULL;
+	struct seen_inode *si;
+
+	while (*p) {
+		parent = *p;
+
+		si = rb_entry(parent, struct seen_inode, i_node);
+		cmp = cmp_si(si, ino, subvol);
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	si = calloc(1, sizeof(*si));
+	if (!si)
+		return ENOMEM;
+
+	si->i_ino = ino;
+	si->i_subvol = subvol;
+
+	rb_link_node(&si->i_node, parent, p);
+	rb_insert_color(&si->i_node, &seen_inodes);
+
+	return 0;
+}
+
+static int inode_seen(u64 ino, u64 subvol)
+{
+	int cmp;
+	struct rb_node *n = seen_inodes.rb_node;
+	struct seen_inode *si;
+
+	while (n) {
+		si = rb_entry(n, struct seen_inode, i_node);
+
+		cmp = cmp_si(si, ino, subvol);
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return EEXIST;
+	}
+	return 0;
+}
+
+static void clear_seen_inodes(void)
+{
+	struct rb_node *n = rb_first(&seen_inodes);
+	struct seen_inode *si;
+
+	while (n) {
+		si = rb_entry(n, struct seen_inode, i_node);
+
+		rb_erase(&si->i_node, &seen_inodes);
+		free(si);
+
+		n = rb_first(&seen_inodes);
+	}
+}
+
+const char * const cmd_filesystem_du_usage[] = {
+	"btrfs filesystem du [options] <path> [<path>..]",
+	"Summarize disk usage of each file.",
+	"-h|--human-readable",
+	"                   human friendly numbers, base 1024 (default)",
+	"-s                 display only a total for each argument",
+	NULL
+};
+
+/*
+ * Inline extents are skipped because they do not take data space,
+ * delalloc and unknown are skipped because we do not know how much
+ * space they will use yet.
+ */
+#define	SKIP_FLAGS	(FIEMAP_EXTENT_UNKNOWN|FIEMAP_EXTENT_DELALLOC|FIEMAP_EXTENT_DATA_INLINE)
+static int du_calc_file_space(int fd, struct rb_root *shared_extents,
+			      uint64_t *ret_total, uint64_t *ret_shared)
+{
+	char buf[16384];
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+	int count = (sizeof(buf) - sizeof(*fiemap)) /
+			sizeof(struct fiemap_extent);
+	unsigned int i, ret;
+	int last = 0;
+	int rc;
+	u64 ext_len;
+	u64 file_total = 0;
+	u64 file_shared = 0;
+	u32 flags;
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+
+	do {
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_extent_count = count;
+		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc < 0) {
+			ret = errno;
+			goto out;
+		}
+
+		/* If 0 extents are returned, then more ioctls are not needed */
+		if (fiemap->fm_mapped_extents == 0)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			ext_len = fm_ext[i].fe_length;
+			flags = fm_ext[i].fe_flags;
+
+			if (flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+
+			if (flags & SKIP_FLAGS)
+				continue;
+
+			file_total += ext_len;
+			if (flags & FIEMAP_EXTENT_SHARED) {
+				file_shared += ext_len;
+
+				if (shared_extents) {
+					ret = add_shared_extent(fm_ext[i].fe_physical,
+								ext_len,
+								shared_extents);
+					if (ret)
+						goto out;
+				}
+			}
+		}
+
+		fiemap->fm_start = (fm_ext[i - 1].fe_logical +
+				    fm_ext[i - 1].fe_length);
+	} while (last == 0);
+
+	*ret_total = file_total;
+	*ret_shared = file_shared;
+
+	ret = 0;
+out:
+	return ret;
+}
+
+struct du_dir_ctxt {
+	uint64_t	bytes_total;
+	uint64_t	bytes_shared;
+	DIR		*dirstream;
+	struct rb_root	shared_extents;
+};
+#define INIT_DU_DIR_CTXT	(struct du_dir_ctxt) { 0ULL, 0ULL, NULL, RB_ROOT }
+
+static int du_add_file(const char *filename, int dirfd,
+		       struct rb_root *shared_extents, uint64_t *ret_total,
+		       uint64_t *ret_shared, int top_level);
+
+static int du_walk_dir(struct du_dir_ctxt *ctxt, struct rb_root *shared_extents)
+{
+	int ret, type;
+	struct dirent *entry;
+	DIR *dirstream = ctxt->dirstream;
+
+	ret = 0;
+	do {
+		uint64_t tot, shr;
+
+		errno = 0;
+		entry = readdir(dirstream);
+		if (entry) {
+			if (strcmp(entry->d_name, ".") == 0
+			    || strcmp(entry->d_name, "..") == 0)
+				continue;
+
+			type = entry->d_type;
+			if (type == DT_REG || type == DT_DIR) {
+				tot = shr = 0;
+
+				ret = du_add_file(entry->d_name,
+						  dirfd(dirstream),
+						  shared_extents, &tot, &shr,
+						  0);
+				if (ret)
+					break;
+
+				ctxt->bytes_total += tot;
+				ctxt->bytes_shared += shr;
+			}
+		}
+	} while (entry != NULL);
+
+	return ret;
+}
+
+static int du_add_file(const char *filename, int dirfd,
+		       struct rb_root *shared_extents, uint64_t *ret_total,
+		       uint64_t *ret_shared, int top_level)
+{
+	int ret, len = strlen(filename);
+	char *pathtmp;
+	struct stat st;
+	struct du_dir_ctxt dir = INIT_DU_DIR_CTXT;
+	int is_dir = 0;
+	uint64_t file_total = 0;
+	uint64_t file_shared = 0;
+	u64 dir_set_shared = 0;
+	u64 subvol;
+	int fd;
+	DIR *dirstream = NULL;
+
+	ret = fstatat(dirfd, filename, &st, 0);
+	if (ret) {
+		ret = errno;
+		return ret;
+	}
+
+	if (!S_ISREG(st.st_mode) && !S_ISDIR(st.st_mode))
+		return 0;
+
+	if (len > (path_max - pathp)) {
+		fprintf(stderr, "ERROR: Path max exceeded: %s %s\n", path,
+			filename);
+		return ENAMETOOLONG;
+	}
+
+	pathtmp = pathp;
+	if (pathp == path)
+		ret = sprintf(pathp, "%s", filename);
+	else
+		ret = sprintf(pathp, "/%s", filename);
+	pathp += ret;
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		ret = fd;
+		goto out;
+	}
+
+	ret = lookup_ino_rootid(fd, &subvol);
+	if (ret)
+		goto out_close;
+
+	if (inode_seen(st.st_ino, subvol))
+		goto out_close;
+
+	ret = mark_inode_seen(st.st_ino, subvol);
+	if (ret)
+		goto out_close;
+
+	if (S_ISREG(st.st_mode)) {
+		ret = du_calc_file_space(fd, shared_extents, &file_total,
+					 &file_shared);
+		if (ret)
+			goto out_close;
+	} else if (S_ISDIR(st.st_mode)) {
+		struct rb_root *root = shared_extents;
+
+		/*
+		 * We collect shared extents in an rb_root, the top
+		 * level caller will not pass a root down, so use the
+		 * one on our dir context.
+		 */
+		if (top_level)
+			root = &dir.shared_extents;
+
+		is_dir = 1;
+
+		dir.dirstream = dirstream;
+		ret = du_walk_dir(&dir, root);
+		*pathp = '\0';
+		if (ret) {
+			if (top_level)
+				cleanup_shared_extents(root);
+			goto out_close;
+		}
+
+		file_total = dir.bytes_total;
+		file_shared = dir.bytes_shared;
+		if (top_level)
+			count_shared_bytes(root, &dir_set_shared);
+	}
+
+	if (!summarize || top_level) {
+		u64 excl = file_total - file_shared;
+
+		if (top_level) {
+			u64 set_shared = file_shared;
+
+			if (is_dir)
+				set_shared = dir_set_shared;
+
+			printf("%s\t%s\t%s\t%s\n",
+			       pretty_size_mode(file_total, unit_mode),
+			       pretty_size_mode(excl, unit_mode),
+			       pretty_size_mode(set_shared, unit_mode),
+			       path);
+		} else {
+			printf("%s\t%s\t\t\t%s\n",
+			       pretty_size_mode(file_total, unit_mode),
+			       pretty_size_mode(excl, unit_mode), path);
+		}
+	}
+
+	if (ret_total)
+		*ret_total = file_total;
+	if (ret_shared)
+		*ret_shared = file_shared;
+
+out_close:
+	close_file_or_dir(fd, dirstream);
+out:
+	/* reset path to just before this element */
+	pathp = pathtmp;
+
+	return ret;
+}
+
+int cmd_filesystem_du(int argc, char **argv)
+{
+	int ret = 0, error = 0;
+	int i;
+
+	optind = 1;
+	while (1) {
+		int long_index;
+		static const struct option long_options[] = {
+			{ "summarize", no_argument, NULL, 's'},
+			{ "human-readable", no_argument, NULL, 'h'},
+			{ NULL, 0, NULL, 0 }
+		};
+		int c = getopt_long(argc, argv, "sh", long_options,
+				&long_index);
+
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'h':
+			unit_mode = UNITS_HUMAN;
+			break;
+		case 's':
+			summarize = 1;
+			break;
+		default:
+			usage(cmd_filesystem_du_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_filesystem_du_usage);
+
+	printf("total\texclusive\tset shared\tfilename\n");
+
+	for (i = optind; i < argc; i++) {
+		ret = du_add_file(argv[i], AT_FDCWD, NULL, NULL, NULL, 1);
+		if (ret) {
+			fprintf(stderr, "ERROR: can't check space of '%s': %s\n",
+				argv[i], strerror(ret));
+			error = 1;
+		}
+
+		/* reset hard-link detection for each argument */
+		clear_seen_inodes();
+	}
+
+	return error;
+}
diff --git a/cmds-du.h b/cmds-du.h
new file mode 100644
index 0000000..5ffb178
--- /dev/null
+++ b/cmds-du.h
@@ -0,0 +1,7 @@
+#ifndef __CMDS_DU_H__
+#define __CMDS_DU_H__
+
+extern const char * const cmd_filesystem_du_usage[];
+int cmd_filesystem_du(int argc, char **argv);
+
+#endif	/* __CMDS_DU_H__ */
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f3fc160..eb82664 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -37,7 +37,7 @@
 #include "cmds-fi-disk_usage.h"
 #include "list_sort.h"
 #include "disk-io.h"
-
+#include "cmds-du.h"
 
 /*
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
@@ -1297,6 +1297,7 @@ static int cmd_label(int argc, char **argv)
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
+		{ "du", cmd_filesystem_du, cmd_filesystem_du_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
diff --git a/interval_tree_generic.h b/interval_tree_generic.h
new file mode 100644
index 0000000..e26c732
--- /dev/null
+++ b/interval_tree_generic.h
@@ -0,0 +1,193 @@
+/*
+  Interval Trees
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  include/linux/interval_tree_generic.h
+*/
+
+#include <stdbool.h>
+
+#include "rbtree_augmented.h"
+
+/*
+ * Template for implementing interval trees
+ *
+ * ITSTRUCT:   struct type of the interval tree nodes
+ * ITRB:       name of struct rb_node field within ITSTRUCT
+ * ITTYPE:     type of the interval endpoints
+ * ITSUBTREE:  name of ITTYPE field within ITSTRUCT holding last-in-subtree
+ * ITSTART(n): start endpoint of ITSTRUCT node n
+ * ITLAST(n):  last endpoint of ITSTRUCT node n
+ * ITSTATIC:   'static' or empty
+ * ITPREFIX:   prefix to use for the inline tree definitions
+ *
+ * Note - before using this, please consider if non-generic version
+ * (interval_tree.h) would work for you...
+ */
+
+#define INTERVAL_TREE_DEFINE(ITSTRUCT, ITRB, ITTYPE, ITSUBTREE,		      \
+			     ITSTART, ITLAST, ITSTATIC, ITPREFIX)	      \
+									      \
+/* Callbacks for augmented rbtree insert and remove */			      \
+									      \
+static inline ITTYPE ITPREFIX ## _compute_subtree_last(ITSTRUCT *node)	      \
+{									      \
+	ITTYPE max = ITLAST(node), subtree_last;			      \
+	if (node->ITRB.rb_left) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_left,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	if (node->ITRB.rb_right) {					      \
+		subtree_last = rb_entry(node->ITRB.rb_right,		      \
+					ITSTRUCT, ITRB)->ITSUBTREE;	      \
+		if (max < subtree_last)					      \
+			max = subtree_last;				      \
+	}								      \
+	return max;							      \
+}									      \
+									      \
+RB_DECLARE_CALLBACKS(static, ITPREFIX ## _augment, ITSTRUCT, ITRB,	      \
+		     ITTYPE, ITSUBTREE, ITPREFIX ## _compute_subtree_last)    \
+									      \
+/* Insert / remove interval nodes from the tree */			      \
+									      \
+ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;	      \
+	ITTYPE start = ITSTART(node), last = ITLAST(node);		      \
+	ITSTRUCT *parent;						      \
+									      \
+	while (*link) {							      \
+		rb_parent = *link;					      \
+		parent = rb_entry(rb_parent, ITSTRUCT, ITRB);		      \
+		if (parent->ITSUBTREE < last)				      \
+			parent->ITSUBTREE = last;			      \
+		if (start < ITSTART(parent))				      \
+			link = &parent->ITRB.rb_left;			      \
+		else							      \
+			link = &parent->ITRB.rb_right;			      \
+	}								      \
+									      \
+	node->ITSUBTREE = last;						      \
+	rb_link_node(&node->ITRB, rb_parent, link);			      \
+	rb_insert_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node, struct rb_root *root)	      \
+{									      \
+	rb_erase_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+}									      \
+									      \
+/*									      \
+ * Iterate over intervals intersecting [start;last]			      \
+ *									      \
+ * Note that a node's interval intersects [start;last] iff:		      \
+ *   Cond1: ITSTART(node) <= last					      \
+ * and									      \
+ *   Cond2: start <= ITLAST(node)					      \
+ */									      \
+									      \
+static ITSTRUCT *							      \
+ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariant: start <= node->ITSUBTREE		      \
+		 * (Cond2 is satisfied by one of the subtree nodes)	      \
+		 */							      \
+		if (node->ITRB.rb_left) {				      \
+			ITSTRUCT *left = rb_entry(node->ITRB.rb_left,	      \
+						  ITSTRUCT, ITRB);	      \
+			if (start <= left->ITSUBTREE) {			      \
+				/*					      \
+				 * Some nodes in left subtree satisfy Cond2.  \
+				 * Iterate to find the leftmost such node N.  \
+				 * If it also satisfies Cond1, that's the     \
+				 * match we are looking for. Otherwise, there \
+				 * is no matching interval as nodes to the    \
+				 * right of N can't satisfy Cond1 either.     \
+				 */					      \
+				node = left;				      \
+				continue;				      \
+			}						      \
+		}							      \
+		if (ITSTART(node) <= last) {		/* Cond1 */	      \
+			if (start <= ITLAST(node))	/* Cond2 */	      \
+				return node;	/* node is leftmost match */  \
+			if (node->ITRB.rb_right) {			      \
+				node = rb_entry(node->ITRB.rb_right,	      \
+						ITSTRUCT, ITRB);	      \
+				if (start <= node->ITSUBTREE)		      \
+					continue;			      \
+			}						      \
+		}							      \
+		return NULL;	/* No match */				      \
+	}								      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_first(struct rb_root *root, ITTYPE start, ITTYPE last)      \
+{									      \
+	ITSTRUCT *node;							      \
+									      \
+	if (!root->rb_node)						      \
+		return NULL;						      \
+	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);			      \
+	if (node->ITSUBTREE < start)					      \
+		return NULL;						      \
+	return ITPREFIX ## _subtree_search(node, start, last);		      \
+}									      \
+									      \
+ITSTATIC ITSTRUCT *							      \
+ITPREFIX ## _iter_next(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
+{									      \
+	struct rb_node *rb = node->ITRB.rb_right, *prev;		      \
+									      \
+	while (true) {							      \
+		/*							      \
+		 * Loop invariants:					      \
+		 *   Cond1: ITSTART(node) <= last			      \
+		 *   rb == node->ITRB.rb_right				      \
+		 *							      \
+		 * First, search right subtree if suitable		      \
+		 */							      \
+		if (rb) {						      \
+			ITSTRUCT *right = rb_entry(rb, ITSTRUCT, ITRB);	      \
+			if (start <= right->ITSUBTREE)			      \
+				return ITPREFIX ## _subtree_search(right,     \
+								start, last); \
+		}							      \
+									      \
+		/* Move up the tree until we come from a node's left child */ \
+		do {							      \
+			rb = rb_parent(&node->ITRB);			      \
+			if (!rb)					      \
+				return NULL;				      \
+			prev = &node->ITRB;				      \
+			node = rb_entry(rb, ITSTRUCT, ITRB);		      \
+			rb = node->ITRB.rb_right;			      \
+		} while (prev == rb);					      \
+									      \
+		/* Check if the node intersects [start;last] */		      \
+		if (last < ITSTART(node))		/* !Cond1 */	      \
+			return NULL;					      \
+		else if (start <= ITLAST(node))		/* Cond2 */	      \
+			return node;					      \
+	}								      \
+}
diff --git a/rbtree.h b/rbtree.h
index 0d4f2bf..47b662a 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -57,7 +57,7 @@ struct rb_root {
 
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
 
-/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+/* 'empty' nodes are nodes that are known not to be inserted in an rtbree */
 #define RB_EMPTY_NODE(node)  \
 	((node)->__rb_parent_color == (unsigned long)(node))
 #define RB_CLEAR_NODE(node)  \
diff --git a/rbtree_augmented.h b/rbtree_augmented.h
index cbc9639..5d26978 100644
--- a/rbtree_augmented.h
+++ b/rbtree_augmented.h
@@ -46,6 +46,16 @@ struct rb_augment_callbacks {
 
 extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+/*
+ * Fixup the rbtree and update the augmented information when rebalancing.
+ *
+ * On insertion, the user must update the augmented information on the path
+ * leading to the inserted node, then call rb_link_node() as usual and
+ * rb_augment_inserted() instead of the usual rb_insert_color() call.
+ * If rb_augment_inserted() rebalances the rbtree, it will callback into
+ * a user provided function to update the augmented information on the
+ * affected subtrees.
+ */
 static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
