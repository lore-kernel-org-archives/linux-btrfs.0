Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbbFQLpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 07:45:17 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs-progs: add feature to get mininum size for resizing a fs/device
Date: Wed, 17 Jun 2015 12:44:55 +0100
Message-Id: <1434541495-14934-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Currently there is not way for a user to know what is the minimum size a
device of a btrfs filesystem can be resized to. Sometimes the value of
total allocated space (sum of all allocated chunks/device extents), which
can be parsed from 'btrfs filesystem show' and 'btrfs filesystem usage',
works as the minimum size, but sometimes it does not, namely when device
extents have to relocated to holes (unallocated space) within the new
size of the device (the total allocated space sum).

This change adds the ability to reliably compute such minimum value and
extents 'btrfs filesystem resize' with the following syntax to get such
value:

   btrfs filesystem resize [devid:]get_min_size

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 Documentation/btrfs-filesystem.asciidoc |   4 +-
 Makefile.in                             |   8 +-
 cmds-filesystem.c                       | 219 +++++++++++++++++++++++++++++++-
 ctree.h                                 |   3 +
 tests/shrink-min-size-tests.sh          |  72 +++++++++++
 5 files changed, 302 insertions(+), 4 deletions(-)
 create mode 100755 tests/shrink-min-size-tests.sh

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index f1c35b6..45f8cf7 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -88,7 +88,7 @@ If a newlabel optional argument is passed, the label is changed.
 NOTE: the maximum allowable length shall be less than 256 chars
 
 // Some wording are extracted by the resize2fs man page
-*resize* [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max <path>::
+*resize* [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max|[<devid>:]get_min_size <path>::
 Resize a mounted filesystem identified by directory <path>. A particular device
 can be resized by specifying a <devid>.
 +
@@ -108,6 +108,8 @@ KiB, MiB, GiB, TiB, PiB, or EiB, respectively. Case does not matter.
 +
 If \'max' is passed, the filesystem will occupy all available space on the
 device devid.
+If \'get_min_size' is passed, return the minimum size the device can be
+shrunk to, without performing any resize operation.
 +
 The resize command does not manipulate the size of underlying
 partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
diff --git a/Makefile.in b/Makefile.in
index 860a390..202c51e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -46,7 +46,7 @@ libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
-TESTS = fsck-tests.sh convert-tests.sh
+TESTS = fsck-tests.sh convert-tests.sh shrink-min-size-tests.sh
 
 prefix ?= @prefix@
 exec_prefix = @exec_prefix@
@@ -161,6 +161,10 @@ $(BUILDDIRS):
 	@echo "Making all in $(patsubst build-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
 
+test-shrink-min-size: btrfs mkfs.btrfs
+	@echo "    [TEST]   shrink-min-size-tests.sh"
+	$(Q)bash tests/shrink-min-size-tests.sh
+
 test-convert: btrfs btrfs-convert
 	@echo "    [TEST]   convert-tests.sh"
 	$(Q)bash tests/convert-tests.sh
@@ -169,7 +173,7 @@ test-fsck: btrfs btrfs-image btrfs-corrupt-block btrfs-debug-tree mkfs.btrfs
 	@echo "    [TEST]   fsck-tests.sh"
 	$(Q)bash tests/fsck-tests.sh
 
-test: test-fsck test-convert
+test: test-fsck test-convert test-shrink-min-size
 
 #
 # NOTE: For static compiles, you need to have all the required libs
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b93bb33..13b5bc5 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1220,14 +1220,228 @@ static int cmd_defrag(int argc, char **argv)
 }
 
 static const char * const cmd_resize_usage[] = {
-	"btrfs filesystem resize [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>",
+	"btrfs filesystem resize [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max|[devid:]get_min_size <path>",
 	"Resize a filesystem",
 	"If 'max' is passed, the filesystem will occupy all available space",
 	"on the device 'devid'.",
+	"If 'get_min_size' is passed, return the minimum size the device can",
+	"be shrunk to.",
 	"[kK] means KiB, which denotes 1KiB = 1024B, 1MiB = 1024KiB, etc.",
 	NULL
 };
 
+struct dev_extent_elem {
+	u64 start;
+	/* inclusive end */
+	u64 end;
+	struct list_head list;
+};
+
+static int add_dev_extent(struct list_head *list,
+			  const u64 start, const u64 end,
+			  const int append)
+{
+	struct dev_extent_elem *e;
+
+	e = malloc(sizeof(*e));
+	if (!e)
+		return -ENOMEM;
+
+	e->start = start;
+	e->end = end;
+
+	if (append)
+		list_add_tail(&e->list, list);
+	else
+		list_add(&e->list, list);
+
+	return 0;
+}
+
+static void free_dev_extent_list(struct list_head *list)
+{
+	while (!list_empty(list)) {
+		struct dev_extent_elem *e;
+
+		e = list_first_entry(list, struct dev_extent_elem, list);
+		list_del(&e->list);
+		free(e);
+	}
+}
+
+static void adjust_dev_min_size(struct list_head *extents,
+				struct list_head *holes,
+				u64 *min_size)
+{
+	/*
+	 * If relocation of the block group of a device extent must happen (see
+	 * below) scratch space is used for the relocation. So track here the
+	 * size of the largest device extent that has to be relocated. We track
+	 * only the largest and not the sum of the sizes of all relocated block
+	 * groups because after each block group is relocated the running
+	 * transaction is committed so that pinned space is released.
+	 */
+	u64 scratch_space = 0;
+
+	/*
+	 * List of device extents is sorted by descending order of the extent's
+	 * end offset. If some extent goes beyond the computed minimum size,
+	 * which initially matches the sum of the lenghts of all extents,
+	 * we need to check if the extent can be relocated to an hole in the
+	 * device between [0, *min_size[ (which is what the resize ioctl does).
+	 */
+	while (!list_empty(extents)) {
+		struct dev_extent_elem *e;
+		struct dev_extent_elem *h;
+		int found = 0;
+		u64 extent_len;
+		u64 hole_len = 0;
+
+		e = list_first_entry(extents, struct dev_extent_elem, list);
+		if (e->end <= *min_size)
+			break;
+
+		/*
+		 * Our extent goes beyond the computed *min_size. See if we can
+		 * find a hole large enough to relocate it to. If not we must stop
+		 * and set *min_size to the end of the extent.
+		 */
+		extent_len = e->end - e->start + 1;
+		list_for_each_entry(h, holes, list) {
+			hole_len = h->end - h->start + 1;
+			if (hole_len >= extent_len) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (!found) {
+			*min_size = e->end + 1;
+			break;
+		}
+
+		if (hole_len > extent_len) {
+			h->start += extent_len;
+		} else {
+			list_del(&h->list);
+			free(h);
+		}
+
+		list_del(&e->list);
+		free(e);
+
+		if (extent_len > scratch_space)
+			scratch_space = extent_len;
+	}
+
+	*min_size += scratch_space;
+}
+
+static int get_min_size(int fd, DIR *dirstream, const char *amount)
+{
+	int ret = 1;
+	char *p = strstr(amount, ":");
+	u64 devid = 1;
+	/*
+	 * Device allocations starts at 1Mb or at the value passed through the
+	 * mount option alloc_start if it's bigger than 1Mb. The alloc_start
+	 * option is used for debugging and testing only, and recently the
+	 * possibility of deprecating/removing it has been discussed, so we
+	 * ignore it here.
+	 */
+	u64 min_size = 1 * 1024 * 1024ull;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	u64 last_pos = (u64)-1;
+	LIST_HEAD(extents);
+	LIST_HEAD(holes);
+
+	if (p && sscanf(amount, "%llu:get_min_size", &devid) != 1) {
+		fprintf(stderr, "Invalid parameter: %s\n", amount);
+		goto out;
+	}
+
+	memset(&args, 0, sizeof(args));
+	sk->tree_id = BTRFS_DEV_TREE_OBJECTID;
+	sk->min_objectid = devid;
+	sk->max_objectid = devid;
+	sk->max_type = BTRFS_DEV_EXTENT_KEY;
+	sk->min_type = BTRFS_DEV_EXTENT_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 4096;
+
+	while (1) {
+		int i;
+		struct btrfs_ioctl_search_header *sh;
+		unsigned long off = 0;
+
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0) {
+			fprintf(stderr,
+				"Error invoking tree search ioctl: %s\n",
+				strerror(errno));
+			ret = 1;
+			goto out;
+		}
+
+		if (sk->nr_items == 0)
+			break;
+
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_dev_extent *extent;
+			u64 len;
+
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+			extent = (struct btrfs_dev_extent *)(args.buf + off);
+			off += sh->len;
+
+			sk->min_objectid = sh->objectid;
+			sk->min_type = sh->type;
+			sk->min_offset = sh->offset + 1;
+
+			if (sh->objectid != devid ||
+			    sh->type != BTRFS_DEV_EXTENT_KEY)
+				continue;
+
+			len = btrfs_stack_dev_extent_length(extent);
+			min_size += len;
+			ret = add_dev_extent(&extents, sh->offset,
+					     sh->offset + len - 1, 0);
+
+			if (!ret && last_pos != (u64)-1 &&
+			    last_pos != sh->offset)
+				ret = add_dev_extent(&holes, last_pos,
+						     sh->offset - 1, 1);
+			if (ret) {
+				fprintf(stderr, "Error: %s\n", strerror(-ret));
+				ret = 1;
+				goto out;
+			}
+
+			last_pos = sh->offset + len;
+		}
+
+		if (sk->min_type != BTRFS_DEV_EXTENT_KEY ||
+		    sk->min_objectid != devid)
+			break;
+	}
+
+	adjust_dev_min_size(&extents, &holes, &min_size);
+	printf("%llu bytes (%s)\n", min_size, pretty_size(min_size));
+	ret = 0;
+out:
+	close_file_or_dir(fd, dirstream);
+	free_dev_extent_list(&extents);
+	free_dev_extent_list(&holes);
+
+	return ret;
+}
+
 static int cmd_resize(int argc, char **argv)
 {
 	struct btrfs_ioctl_vol_args	args;
@@ -1269,6 +1483,9 @@ static int cmd_resize(int argc, char **argv)
 		return 1;
 	}
 
+	if (strstr(amount, "get_min_size"))
+		return get_min_size(fd, dirstream, amount);
+
 	printf("Resize '%s' of '%s'\n", path, amount);
 	strncpy_null(args.name, amount);
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
diff --git a/ctree.h b/ctree.h
index f14a795..7d74d1a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1491,6 +1491,9 @@ BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
 		   chunk_offset, 64);
 BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
 
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_length, struct btrfs_dev_extent,
+			 length, 64);
+
 static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 {
 	unsigned long ptr = offsetof(struct btrfs_dev_extent, chunk_tree_uuid);
diff --git a/tests/shrink-min-size-tests.sh b/tests/shrink-min-size-tests.sh
new file mode 100755
index 0000000..33938b7
--- /dev/null
+++ b/tests/shrink-min-size-tests.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+#
+# Test getting the minimum size a filesystem can be resized to and verify we
+# are able to resize (shrink) it to that size.
+#
+
+unset TOP
+unset LANG
+LANG=C
+SCRIPT_DIR=$(dirname $(realpath $0))
+TOP=$(realpath $SCRIPT_DIR/../)
+TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
+RESULTS="$TOP/tests/shrink-min-size-tests-results.txt"
+IMAGE="$TOP/tests/test.img"
+
+source $TOP/tests/common
+
+rm -f $RESULTS
+
+check_prereq mkfs.btrfs
+setup_root_helper
+
+
+shrink_test()
+{
+	min_size=$(btrfs filesystem resize get_min_size $TEST_MNT)
+	if [ $? != 0 ]; then
+		_fail "Failed to get minimum size"
+	fi
+	min_size=$(echo $min_size | cut -d ' ' -f 1)
+	echo "min size = ${min_size}" >> $RESULTS
+	run_check btrfs filesystem resize $min_size $TEST_MNT
+}
+
+run_check truncate -s 20G $IMAGE
+run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $IMAGE
+run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
+
+# Create 7 data block groups, each with a size of 1Gb.
+for ((i = 1; i <= 7; i++)); do
+	run_check fallocate -l 1G $TEST_MNT/foo$i
+done
+
+# Make sure they are persisted (all the chunk, device and block group items
+# added to the chunk/dev/extent trees).
+run_check btrfs filesystem sync $TEST_MNT
+
+# Now remove 3 of those 1G files. This will result in 3 block groups becoming
+# unused, which will be automatically deleted by the cleaner kthread, and this
+# will result in 3 holes (unallocated space) in the device (each with a size
+# of 1Gb).
+
+run_check rm -f $TEST_MNT/foo2
+run_check rm -f $TEST_MNT/foo4
+run_check rm -f $TEST_MNT/foo6
+
+# Sync once to wake up the cleaner kthread which will delete the unused block
+# groups - it could have been sleeping when they become unused. Then wait a bit
+# to allow the cleaner kthread to delete them and then finally ensure the
+# transaction started by the cleaner kthread is committed.
+run_check btrfs filesystem sync $TEST_MNT
+sleep 3
+run_check btrfs filesystem sync $TEST_MNT
+
+# Now attempt to get the minimum size we can resize the filesystem to and verify
+# the resize operation succeeds. This size closely matches the sum of the size
+# of all the allocated device extents.
+for ((i = 1; i <= 3; i++)); do
+	shrink_test
+done
+
+run_check $SUDO_HELPER umount $TEST_MNT
-- 
2.1.3

