Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53188 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3JIQFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 12:05:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A1BE49A06B2
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 10:05:05 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id wO2hwp7df1DlxDZd (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 10:05:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add tests for find_lock_delalloc_range
Date: Wed, 9 Oct 2013 12:05:00 -0400
Message-ID: <1381334700-2355-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So both Liu and I made huge messes of find_lock_delalloc_range trying to fix
stuff, me first by fixing extent size, then him by fixing something I broke and
then me again telling him to fix it a different way.  So this is obviously a
candidate for some testing.  This patch adds a pseudo fs so we can allocate fake
inodes for tests that need an inode or pages.  Then it addes a bunch of tests to
make sure find_lock_delalloc_range is acting the way it is supposed to.  With
this patch and all of our previous patches to find_lock_delalloc_range I am sure
it is working as expected now.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/Makefile                |   2 +-
 fs/btrfs/ctree.h                 |   6 +
 fs/btrfs/extent_io.c             |   9 +-
 fs/btrfs/extent_io.h             |   6 +
 fs/btrfs/super.c                 |  14 +-
 fs/btrfs/tests/btrfs-tests.h     |  15 +++
 fs/btrfs/tests/extent-io-tests.c | 276 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/magic.h       |   2 +-
 8 files changed, 321 insertions(+), 9 deletions(-)
 create mode 100644 fs/btrfs/tests/extent-io-tests.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 4c7dfbf..cac4f2d 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -15,4 +15,4 @@ btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
-	tests/extent-buffer-tests.o
+	tests/extent-buffer-tests.o tests/btrfs-tests.o tests/extent-io-tests.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9ca15a8..2f39806 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -47,6 +47,12 @@ extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+#define STATIC noinline
+#else
+#define STATIC static noinline
+#endif
+
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
 #define BTRFS_MAX_MIRRORS 3
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2bf6f46..c10291cc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1598,11 +1598,10 @@ done:
  *
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
-static noinline u64 find_lock_delalloc_range(struct inode *inode,
-					     struct extent_io_tree *tree,
-					     struct page *locked_page,
-					     u64 *start, u64 *end,
-					     u64 max_bytes)
+STATIC u64 find_lock_delalloc_range(struct inode *inode,
+				    struct extent_io_tree *tree,
+				    struct page *locked_page, u64 *start,
+				    u64 *end, u64 max_bytes)
 {
 	u64 delalloc_start;
 	u64 delalloc_end;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6dbc645..f98602e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -345,4 +345,10 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+noinline u64 find_lock_delalloc_range(struct inode *inode,
+				      struct extent_io_tree *tree,
+				      struct page *locked_page, u64 *start,
+				      u64 *end, u64 max_bytes);
+#endif
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0991fb1..2bdaafd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1791,10 +1791,20 @@ static int btrfs_run_sanity_tests(void)
 {
 	int ret;
 
-	ret = btrfs_test_free_space_cache();
+	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
-	return btrfs_test_extent_buffer_operations();
+
+	ret = btrfs_test_free_space_cache();
+	if (ret)
+		goto out;
+	ret = btrfs_test_extent_buffer_operations();
+	if (ret)
+		goto out;
+	ret = btrfs_test_extent_io();
+out:
+	btrfs_destroy_test_fs();
+	return ret;
 }
 
 static int __init init_btrfs_fs(void)
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 04f2cd2..e935fe5 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -25,6 +25,10 @@
 
 int btrfs_test_free_space_cache(void);
 int btrfs_test_extent_buffer_operations(void);
+int btrfs_test_extent_io(void);
+int btrfs_init_test_fs(void);
+void btrfs_destroy_test_fs(void);
+struct inode *btrfs_new_test_inode(void);
 #else
 static inline int btrfs_test_free_space_cache(void)
 {
@@ -34,6 +38,17 @@ static inline int btrfs_test_extent_buffer_operations(void)
 {
 	return 0;
 }
+static inline int btrfs_init_test_fs(void)
+{
+	return 0;
+}
+static inline void btrfs_destroy_test_fs(void)
+{
+}
+static inline int btrfs_test_extent_io(void)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
new file mode 100644
index 0000000..7e99c2f
--- /dev/null
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -0,0 +1,276 @@
+/*
+ * Copyright (C) 2013 Fusion IO.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include "btrfs-tests.h"
+#include "../extent_io.h"
+
+#define PROCESS_UNLOCK		(1 << 0)
+#define PROCESS_RELEASE		(1 << 1)
+#define PROCESS_TEST_LOCKED	(1 << 2)
+
+static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
+				       unsigned long flags)
+{
+	int ret;
+	struct page *pages[16];
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
+	unsigned long nr_pages = end_index - index + 1;
+	int i;
+	int count = 0;
+	int loops = 0;
+
+	while (nr_pages > 0) {
+		ret = find_get_pages_contig(inode->i_mapping, index,
+				     min_t(unsigned long, nr_pages,
+				     ARRAY_SIZE(pages)), pages);
+		for (i = 0; i < ret; i++) {
+			if (flags & PROCESS_TEST_LOCKED &&
+			    !PageLocked(pages[i]))
+				count++;
+			if (flags & PROCESS_UNLOCK && PageLocked(pages[i]))
+				unlock_page(pages[i]);
+			page_cache_release(pages[i]);
+			if (flags & PROCESS_RELEASE)
+				page_cache_release(pages[i]);
+		}
+		nr_pages -= ret;
+		index += ret;
+		cond_resched();
+		loops++;
+		if (loops > 100000) {
+			printk(KERN_ERR "stuck in a loop, start %Lu, end %Lu, nr_pages %lu, ret %d\n", start, end, nr_pages, ret);
+			break;
+		}
+	}
+	return count;
+}
+
+static int test_find_delalloc(void)
+{
+	struct inode *inode;
+	struct extent_io_tree tmp;
+	struct page *page;
+	struct page *locked_page = NULL;
+	unsigned long index = 0;
+	u64 total_dirty = 256 * 1024 * 1024;
+	u64 max_bytes = 128 * 1024 * 1024;
+	u64 start, end, test_start;
+	u64 found;
+	int ret = -EINVAL;
+
+	inode = btrfs_new_test_inode();
+	if (!inode) {
+		test_msg("Failed to allocate test inode\n");
+		return -ENOMEM;
+	}
+
+	extent_io_tree_init(&tmp, &inode->i_data);
+
+	/*
+	 * First go through and create and mark all of our pages dirty, we pin
+	 * everything to make sure our pages don't get evicted and screw up our
+	 * test.
+	 */
+	for (index = 0; index < (total_dirty >> PAGE_CACHE_SHIFT); index++) {
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		if (!page) {
+			test_msg("Failed to allocate test page\n");
+			ret = -ENOMEM;
+			goto out;
+		}
+		SetPageDirty(page);
+		if (index) {
+			unlock_page(page);
+		} else {
+			page_cache_get(page);
+			locked_page = page;
+		}
+	}
+
+	/* Test this scenario
+	 * |--- delalloc ---|
+	 * |---  search  ---|
+	 */
+	set_extent_delalloc(&tmp, 0, 4095, NULL, GFP_NOFS);
+	start = 0;
+	end = 0;
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+					 &end, max_bytes);
+	if (!found) {
+		test_msg("Should have found at least one delalloc\n");
+		goto out_bits;
+	}
+	if (start != 0 || end != 4095) {
+		test_msg("Expected start 0 end 4095, got start %Lu end %Lu\n",
+			 start, end);
+		goto out_bits;
+	}
+	unlock_extent(&tmp, start, end);
+	unlock_page(locked_page);
+	page_cache_release(locked_page);
+
+	/*
+	 * Test this scenario
+	 *
+	 * |--- delalloc ---|
+	 *           |--- search ---|
+	 */
+	test_start = 64 * 1024 * 1024;
+	locked_page = find_lock_page(inode->i_mapping,
+				     test_start >> PAGE_CACHE_SHIFT);
+	if (!locked_page) {
+		test_msg("Couldn't find the locked page\n");
+		goto out_bits;
+	}
+	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL, GFP_NOFS);
+	start = test_start;
+	end = 0;
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+					 &end, max_bytes);
+	if (!found) {
+		test_msg("Couldn't find delalloc in our range\n");
+		goto out_bits;
+	}
+	if (start != test_start || end != max_bytes - 1) {
+		test_msg("Expected start %Lu end %Lu, got start %Lu, end "
+			 "%Lu\n", test_start, max_bytes - 1, start, end);
+		goto out_bits;
+	}
+	if (process_page_range(inode, start, end,
+			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+		test_msg("There were unlocked pages in the range\n");
+		goto out_bits;
+	}
+	unlock_extent(&tmp, start, end);
+	/* locked_page was unlocked above */
+	page_cache_release(locked_page);
+
+	/*
+	 * Test this scenario
+	 * |--- delalloc ---|
+	 *                    |--- search ---|
+	 */
+	test_start = max_bytes + 4096;
+	locked_page = find_lock_page(inode->i_mapping, test_start >>
+				     PAGE_CACHE_SHIFT);
+	if (!locked_page) {
+		test_msg("Could'nt find the locked page\n");
+		goto out_bits;
+	}
+	start = test_start;
+	end = 0;
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+					 &end, max_bytes);
+	if (found) {
+		test_msg("Found range when we shouldn't have\n");
+		goto out_bits;
+	}
+	if (end != (u64)-1) {
+		test_msg("Did not return the proper end offset\n");
+		goto out_bits;
+	}
+
+	/*
+	 * Test this scenario
+	 * [------- delalloc -------|
+	 * [max_bytes]|-- search--|
+	 *
+	 * We are re-using our test_start from above since it works out well.
+	 */
+	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL, GFP_NOFS);
+	start = test_start;
+	end = 0;
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+					 &end, max_bytes);
+	if (!found) {
+		test_msg("Didn't find our range\n");
+		goto out_bits;
+	}
+	if (start != test_start || end != total_dirty - 1) {
+		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
+			 test_start, total_dirty - 1, start, end);
+		goto out_bits;
+	}
+	if (process_page_range(inode, start, end,
+			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+		test_msg("Pages in range were not all locked\n");
+		goto out_bits;
+	}
+	unlock_extent(&tmp, start, end);
+
+	/*
+	 * Now to test where we run into a page that is no longer dirty in the
+	 * range we want to find.
+	 */
+	page = find_get_page(inode->i_mapping, (max_bytes + (1 * 1024 * 1024))
+			     >> PAGE_CACHE_SHIFT);
+	if (!page) {
+		test_msg("Couldn't find our page\n");
+		goto out_bits;
+	}
+	ClearPageDirty(page);
+	page_cache_release(page);
+
+	/* We unlocked it in the previous test */
+	lock_page(locked_page);
+	start = test_start;
+	end = 0;
+	/*
+	 * Currently if we fail to find dirty pages in the delalloc range we
+	 * will adjust max_bytes down to PAGE_CACHE_SIZE and then re-search.  If
+	 * this changes at any point in the future we will need to fix this
+	 * tests expected behavior.
+	 */
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+					 &end, max_bytes);
+	if (!found) {
+		test_msg("Didn't find our range\n");
+		goto out_bits;
+	}
+	if (start != test_start && end != test_start + PAGE_CACHE_SIZE - 1) {
+		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
+			 test_start, test_start + PAGE_CACHE_SIZE - 1, start,
+			 end);
+		goto out_bits;
+	}
+	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
+			       PROCESS_UNLOCK)) {
+		test_msg("Pages in range were not all locked\n");
+		goto out_bits;
+	}
+	ret = 0;
+out_bits:
+	clear_extent_bits(&tmp, 0, total_dirty - 1,
+			  (unsigned long)-1, GFP_NOFS);
+out:
+	if (locked_page)
+		page_cache_release(locked_page);
+	process_page_range(inode, 0, total_dirty - 1,
+			   PROCESS_UNLOCK | PROCESS_RELEASE);
+	iput(inode);
+	return ret;
+}
+
+int btrfs_test_extent_io(void)
+{
+	test_msg("Running find delalloc tests\n");
+	return test_find_delalloc();
+}
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 2944278..77c6031 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -71,6 +71,6 @@
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
 #define MTD_INODE_FS_MAGIC      0x11307854
 #define ANON_INODE_FS_MAGIC	0x09041934
-
+#define BTRFS_TEST_MAGIC	0x73727279
 
 #endif /* __LINUX_MAGIC_H__ */
-- 
1.8.3.1

