Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424AbcATVti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 16:49:38 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/3] btrfs-progs du: Calculate space shared by each directory arguments file set
Date: Wed, 20 Jan 2016 13:49:27 -0800
Message-Id: <1453326567-20454-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here we define each file set as those found by a recursive search of a
single directory argument to btrfs fi du.

This isn't as simple as adding up shared extents - they may be shared with
each other, and may also overlap. This patch uses an interval tree to store
shared extents we find while fiemapping files. After collecting them, a 'set
shared' count is calculated by summing (without overlap) each shared region
discovered. This is then displayed to the user as 'set shared'.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-du.c | 272 +++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 236 insertions(+), 36 deletions(-)

diff --git a/cmds-du.c b/cmds-du.c
index 57758d2..7ab4562 100644
--- a/cmds-du.c
+++ b/cmds-du.c
@@ -18,12 +18,162 @@
 #include "kerncompat.h"
 #include "rbtree.h"
 
+#include "interval_tree_generic.h"
+
 static int summarize = 0;
 static unsigned unit_mode = UNITS_RAW;
 static char path[PATH_MAX] = { 0, };
 static char *pathp = path;
 static char *path_max = &path[PATH_MAX - 1];
 
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
 /* Track which inodes we've seen for the purposes of hardlink detection. */
 struct seen_inode {
 	struct rb_node	i_node;
@@ -96,7 +246,21 @@ static int inode_seen(u64 ino, u64 subvol)
 			return EEXIST;
 	}
 	return 0;
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
 
+		n = rb_first(&seen_inodes);
+	}
 }
 
 const char * const cmd_filesystem_du_usage[] = {
@@ -114,7 +278,7 @@ const char * const cmd_filesystem_du_usage[] = {
  * space they will use yet.
  */
 #define	SKIP_FLAGS	(FIEMAP_EXTENT_UNKNOWN|FIEMAP_EXTENT_DELALLOC|FIEMAP_EXTENT_DATA_INLINE)
-static int du_calc_file_space(int dirfd, const char *filename,
+static int du_calc_file_space(int fd, struct rb_root *shared_extents,
 			      uint64_t *ret_total, uint64_t *ret_shared)
 {
 	char buf[16384];
@@ -126,28 +290,19 @@ static int du_calc_file_space(int dirfd, const char *filename,
 	int last = 0;
 	int rc;
 	u64 ext_len;
-	int fd;
 	u64 file_total = 0;
 	u64 file_shared = 0;
 	u32 flags;
 
 	memset(fiemap, 0, sizeof(struct fiemap));
 
-	fd = openat(dirfd, filename, O_RDONLY);
-	if (fd == -1) {
-		ret = errno;
-		fprintf(stderr, "ERROR: can't access '%s': %s\n",
-			filename, strerror(ret));
-		return ret;
-	}
-
 	do {
 		fiemap->fm_length = ~0ULL;
 		fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
 			ret = errno;
-			goto out_close;
+			goto out;
 		}
 
 		/* If 0 extents are returned, then more ioctls are not needed */
@@ -165,8 +320,17 @@ static int du_calc_file_space(int dirfd, const char *filename,
 				continue;
 
 			file_total += ext_len;
-			if (flags & FIEMAP_EXTENT_SHARED)
+			if (flags & FIEMAP_EXTENT_SHARED) {
 				file_shared += ext_len;
+
+				if (shared_extents) {
+					ret = add_shared_extent(fm_ext[i].fe_physical,
+								ext_len,
+								shared_extents);
+					if (ret)
+						goto out;
+				}
+			}
 		}
 
 		fiemap->fm_start = (fm_ext[i - 1].fe_logical +
@@ -177,28 +341,27 @@ static int du_calc_file_space(int dirfd, const char *filename,
 	*ret_shared = file_shared;
 
 	ret = 0;
-out_close:
-	close(fd);
+out:
 	return ret;
 }
 
 struct du_dir_ctxt {
 	uint64_t	bytes_total;
 	uint64_t	bytes_shared;
+	DIR		*dirstream;
+	struct rb_root	shared_extents;
 };
+#define INIT_DU_DIR_CTXT	(struct du_dir_ctxt) { 0ULL, 0ULL, NULL, RB_ROOT }
 
-static int du_add_file(const char *filename, int dirfd, uint64_t *ret_total,
+static int du_add_file(const char *filename, int dirfd,
+		       struct rb_root *shared_extents, uint64_t *ret_total,
 		       uint64_t *ret_shared, int top_level);
 
-static int du_walk_dir(struct du_dir_ctxt *ctxt)
+static int du_walk_dir(struct du_dir_ctxt *ctxt, struct rb_root *shared_extents)
 {
-	int fd, ret, type;
-	DIR *dirstream = NULL;
+	int ret, type;
 	struct dirent *entry;
-
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0)
-		return fd;
+	DIR *dirstream = ctxt->dirstream;
 
 	ret = 0;
 	do {
@@ -216,8 +379,9 @@ static int du_walk_dir(struct du_dir_ctxt *ctxt)
 				tot = shr = 0;
 
 				ret = du_add_file(entry->d_name,
-						  dirfd(dirstream), &tot,
-						  &shr, 0);
+						  dirfd(dirstream),
+						  shared_extents, &tot, &shr,
+						  0);
 				if (ret)
 					break;
 
@@ -227,19 +391,21 @@ static int du_walk_dir(struct du_dir_ctxt *ctxt)
 		}
 	} while (entry != NULL);
 
-	close_file_or_dir(fd, dirstream);
 	return ret;
 }
 
-static int du_add_file(const char *filename, int dirfd, uint64_t *ret_total,
+static int du_add_file(const char *filename, int dirfd,
+		       struct rb_root *shared_extents, uint64_t *ret_total,
 		       uint64_t *ret_shared, int top_level)
 {
 	int ret, len = strlen(filename);
 	char *pathtmp;
 	struct stat st;
-	struct du_dir_ctxt dir;
+	struct du_dir_ctxt dir = INIT_DU_DIR_CTXT;
+	int is_dir = 0;
 	uint64_t file_total = 0;
 	uint64_t file_shared = 0;
+	u64 dir_set_shared = 0;
 	u64 subvol;
 	int fd;
 	DIR *dirstream = NULL;
@@ -284,26 +450,57 @@ static int du_add_file(const char *filename, int dirfd, uint64_t *ret_total,
 		goto out_close;
 
 	if (S_ISREG(st.st_mode)) {
-		ret = du_calc_file_space(dirfd, filename, &file_total,
+		ret = du_calc_file_space(fd, shared_extents, &file_total,
 					 &file_shared);
 		if (ret)
 			goto out_close;
 	} else if (S_ISDIR(st.st_mode)) {
-		memset(&dir, 0, sizeof(dir));
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
 
-		ret = du_walk_dir(&dir);
+		dir.dirstream = dirstream;
+		ret = du_walk_dir(&dir, root);
 		*pathp = '\0';
-		if (ret)
+		if (ret) {
+			if (top_level)
+				cleanup_shared_extents(root);
 			goto out_close;
+		}
 
 		file_total = dir.bytes_total;
 		file_shared = dir.bytes_shared;
+		if (top_level)
+			count_shared_bytes(root, &dir_set_shared);
 	}
 
 	if (!summarize || top_level) {
-		printf("%s\t%s\t%s\n", pretty_size_mode(file_total, unit_mode),
-		       pretty_size_mode((file_total - file_shared), unit_mode),
-		       path);
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
 	}
 
 	if (ret_total)
@@ -353,15 +550,18 @@ int cmd_filesystem_du(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_filesystem_du_usage);
 
-	printf("total\texclusive\tfilename\n");
+	printf("total\texclusive\tset shared\tfilename\n");
 
 	for (i = optind; i < argc; i++) {
-		ret = du_add_file(argv[i], AT_FDCWD, NULL, NULL, 1);
+		ret = du_add_file(argv[i], AT_FDCWD, NULL, NULL, NULL, 1);
 		if (ret) {
 			fprintf(stderr, "ERROR: can't check space of '%s': %s\n",
 				argv[i], strerror(ret));
 			error = 1;
 		}
+
+		/* reset hard-link detection for each argument */
+		clear_seen_inodes();
 	}
 
 	return error;
-- 
2.1.4

