Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbeEPWDY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 18:03:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8C196AF5C
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 22:03:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: tests: add helper for error messages and update them
Date: Thu, 17 May 2018 00:00:42 +0200
Message-Id: <d0b58eb60b8adcd5fab0173f3ae1e8fea056d7ff.1526507933.git.dsterba@suse.com>
In-Reply-To: <cover.1526507933.git.dsterba@suse.com>
References: <cover.1526507933.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test failures are not clearly visible in the system log as they're
printed at INFO level. Add a new helper that is level ERROR. As this
touches almost all strings, I took the opportunity to unify them:

- decapitalize the first letter as there's a prefix and the text
  continues after ":"
- glue strings split to more lines and un-indent so they fit to 80
  columns
- use %llu instead of %Lu
- drop \n from the modified messages (test_msg is left untouched)

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/btrfs-tests.h           |   1 +
 fs/btrfs/tests/extent-buffer-tests.c   |  56 +++---
 fs/btrfs/tests/extent-io-tests.c       |  75 ++++----
 fs/btrfs/tests/extent-map-tests.c      |  30 ++--
 fs/btrfs/tests/free-space-tests.c      | 177 ++++++++++---------
 fs/btrfs/tests/free-space-tree-tests.c |  74 ++++----
 fs/btrfs/tests/inode-tests.c           | 312 +++++++++++++++++----------------
 fs/btrfs/tests/qgroup-tests.c          |  88 +++++-----
 8 files changed, 412 insertions(+), 401 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 4c11cffb377c..47b5d2eac790 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -10,6 +10,7 @@
 int btrfs_run_sanity_tests(void);
 
 #define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt, ##__VA_ARGS__)
+#define test_err(fmt, ...) pr_err("BTRFS: selftest: " fmt "\n", ##__VA_ARGS__)
 
 struct btrfs_root;
 struct btrfs_trans_handle;
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 31e8a9ec228c..2fa440cf7874 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -26,31 +26,31 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	u32 value_len = strlen(value);
 	int ret = 0;
 
-	test_msg("Running btrfs_split_item tests\n");
+	test_msg("running btrfs_split_item tests\n");
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Could not allocate fs_info\n");
+		test_err("could not allocate fs_info");
 		return -ENOMEM;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Could not allocate root\n");
+		test_err("could not allocate root");
 		ret = PTR_ERR(root);
 		goto out;
 	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Could not allocate path\n");
+		test_err("could not allocate path");
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	path->nodes[0] = eb = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!eb) {
-		test_msg("Could not allocate dummy buffer\n");
+		test_err("could not allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -75,7 +75,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	 */
 	ret = btrfs_split_item(NULL, root, path, &key, 17);
 	if (ret) {
-		test_msg("Split item failed %d\n", ret);
+		test_err("split item failed %d", ret);
 		goto out;
 	}
 
@@ -86,14 +86,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	btrfs_item_key_to_cpu(eb, &key, 0);
 	if (key.objectid != 0 || key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    key.offset != 0) {
-		test_msg("Invalid key at slot 0\n");
+		test_err("invalid key at slot 0");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	item = btrfs_item_nr(0);
 	if (btrfs_item_size(eb, item) != strlen(split1)) {
-		test_msg("Invalid len in the first split\n");
+		test_err("invalid len in the first split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -101,8 +101,8 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	read_extent_buffer(eb, buf, btrfs_item_ptr_offset(eb, 0),
 			   strlen(split1));
 	if (memcmp(buf, split1, strlen(split1))) {
-		test_msg("Data in the buffer doesn't match what it should "
-			 "in the first split have='%.*s' want '%s'\n",
+		test_err(
+"data in the buffer doesn't match what it should in the first split have='%.*s' want '%s'",
 			 (int)strlen(split1), buf, split1);
 		ret = -EINVAL;
 		goto out;
@@ -111,14 +111,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	btrfs_item_key_to_cpu(eb, &key, 1);
 	if (key.objectid != 0 || key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    key.offset != 3) {
-		test_msg("Invalid key at slot 1\n");
+		test_err("invalid key at slot 1");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	item = btrfs_item_nr(1);
 	if (btrfs_item_size(eb, item) != strlen(split2)) {
-		test_msg("Invalid len in the second split\n");
+		test_err("invalid len in the second split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -126,8 +126,8 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	read_extent_buffer(eb, buf, btrfs_item_ptr_offset(eb, 1),
 			   strlen(split2));
 	if (memcmp(buf, split2, strlen(split2))) {
-		test_msg("Data in the buffer doesn't match what it should "
-			 "in the second split\n");
+		test_err(
+	"data in the buffer doesn't match what it should in the second split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -136,21 +136,21 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	/* Do it again so we test memmoving the other items in the leaf */
 	ret = btrfs_split_item(NULL, root, path, &key, 4);
 	if (ret) {
-		test_msg("Second split item failed %d\n", ret);
+		test_err("second split item failed %d", ret);
 		goto out;
 	}
 
 	btrfs_item_key_to_cpu(eb, &key, 0);
 	if (key.objectid != 0 || key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    key.offset != 0) {
-		test_msg("Invalid key at slot 0\n");
+		test_err("invalid key at slot 0");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	item = btrfs_item_nr(0);
 	if (btrfs_item_size(eb, item) != strlen(split3)) {
-		test_msg("Invalid len in the first split\n");
+		test_err("invalid len in the first split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -158,8 +158,8 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	read_extent_buffer(eb, buf, btrfs_item_ptr_offset(eb, 0),
 			   strlen(split3));
 	if (memcmp(buf, split3, strlen(split3))) {
-		test_msg("Data in the buffer doesn't match what it should "
-			 "in the third split");
+		test_err(
+	"data in the buffer doesn't match what it should in the third split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -167,14 +167,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	btrfs_item_key_to_cpu(eb, &key, 1);
 	if (key.objectid != 0 || key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    key.offset != 1) {
-		test_msg("Invalid key at slot 1\n");
+		test_err("invalid key at slot 1");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	item = btrfs_item_nr(1);
 	if (btrfs_item_size(eb, item) != strlen(split4)) {
-		test_msg("Invalid len in the second split\n");
+		test_err("invalid len in the second split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -182,8 +182,8 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	read_extent_buffer(eb, buf, btrfs_item_ptr_offset(eb, 1),
 			   strlen(split4));
 	if (memcmp(buf, split4, strlen(split4))) {
-		test_msg("Data in the buffer doesn't match what it should "
-			 "in the fourth split\n");
+		test_err(
+	"data in the buffer doesn't match what it should in the fourth split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -191,14 +191,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	btrfs_item_key_to_cpu(eb, &key, 2);
 	if (key.objectid != 0 || key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    key.offset != 3) {
-		test_msg("Invalid key at slot 2\n");
+		test_err("invalid key at slot 2");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	item = btrfs_item_nr(2);
 	if (btrfs_item_size(eb, item) != strlen(split2)) {
-		test_msg("Invalid len in the second split\n");
+		test_err("invalid len in the second split");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -206,8 +206,8 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	read_extent_buffer(eb, buf, btrfs_item_ptr_offset(eb, 2),
 			   strlen(split2));
 	if (memcmp(buf, split2, strlen(split2))) {
-		test_msg("Data in the buffer doesn't match what it should "
-			 "in the last chunk\n");
+		test_err(
+	"data in the buffer doesn't match what it should in the last chunk");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -220,6 +220,6 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)
 {
-	test_msg("Running extent buffer operation tests\n");
+	test_msg("running extent buffer operation tests\n");
 	return test_btrfs_split_item(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 76aa5a678a96..f17e2e31d64f 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -46,7 +46,9 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 		cond_resched();
 		loops++;
 		if (loops > 100000) {
-			printk(KERN_ERR "stuck in a loop, start %Lu, end %Lu, nr_pages %lu, ret %d\n", start, end, nr_pages, ret);
+			printk(KERN_ERR
+		"stuck in a loop, start %llu, end %llu, nr_pages %lu, ret %d\n",
+				start, end, nr_pages, ret);
 			break;
 		}
 	}
@@ -66,11 +68,11 @@ static int test_find_delalloc(u32 sectorsize)
 	u64 found;
 	int ret = -EINVAL;
 
-	test_msg("Running find delalloc tests\n");
+	test_msg("running find delalloc tests\n");
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_msg("Failed to allocate test inode\n");
+		test_err("failed to allocate test inode");
 		return -ENOMEM;
 	}
 
@@ -84,7 +86,7 @@ static int test_find_delalloc(u32 sectorsize)
 	for (index = 0; index < (total_dirty >> PAGE_SHIFT); index++) {
 		page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
 		if (!page) {
-			test_msg("Failed to allocate test page\n");
+			test_err("failed to allocate test page");
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -107,11 +109,11 @@ static int test_find_delalloc(u32 sectorsize)
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
-		test_msg("Should have found at least one delalloc\n");
+		test_err("should have found at least one delalloc");
 		goto out_bits;
 	}
 	if (start != 0 || end != (sectorsize - 1)) {
-		test_msg("Expected start 0 end %u, got start %llu end %llu\n",
+		test_err("expected start 0 end %u, got start %llu end %llu",
 			sectorsize - 1, start, end);
 		goto out_bits;
 	}
@@ -129,7 +131,7 @@ static int test_find_delalloc(u32 sectorsize)
 	locked_page = find_lock_page(inode->i_mapping,
 				     test_start >> PAGE_SHIFT);
 	if (!locked_page) {
-		test_msg("Couldn't find the locked page\n");
+		test_err("couldn't find the locked page");
 		goto out_bits;
 	}
 	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, 0, NULL);
@@ -138,17 +140,17 @@ static int test_find_delalloc(u32 sectorsize)
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
-		test_msg("Couldn't find delalloc in our range\n");
+		test_err("couldn't find delalloc in our range");
 		goto out_bits;
 	}
 	if (start != test_start || end != max_bytes - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu, end "
-			 "%Lu\n", test_start, max_bytes - 1, start, end);
+		test_err("expected start %llu end %llu, got start %llu, end %llu",
+				test_start, max_bytes - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end,
 			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
-		test_msg("There were unlocked pages in the range\n");
+		test_err("there were unlocked pages in the range");
 		goto out_bits;
 	}
 	unlock_extent(&tmp, start, end);
@@ -164,7 +166,7 @@ static int test_find_delalloc(u32 sectorsize)
 	locked_page = find_lock_page(inode->i_mapping, test_start >>
 				     PAGE_SHIFT);
 	if (!locked_page) {
-		test_msg("Couldn't find the locked page\n");
+		test_err("couldn't find the locked page");
 		goto out_bits;
 	}
 	start = test_start;
@@ -172,11 +174,11 @@ static int test_find_delalloc(u32 sectorsize)
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (found) {
-		test_msg("Found range when we shouldn't have\n");
+		test_err("found range when we shouldn't have");
 		goto out_bits;
 	}
 	if (end != (u64)-1) {
-		test_msg("Did not return the proper end offset\n");
+		test_err("did not return the proper end offset");
 		goto out_bits;
 	}
 
@@ -193,17 +195,17 @@ static int test_find_delalloc(u32 sectorsize)
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
-		test_msg("Didn't find our range\n");
+		test_err("didn't find our range");
 		goto out_bits;
 	}
 	if (start != test_start || end != total_dirty - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
+		test_err("expected start %llu end %llu, got start %llu end %llu",
 			 test_start, total_dirty - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end,
 			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
-		test_msg("Pages in range were not all locked\n");
+		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
 	unlock_extent(&tmp, start, end);
@@ -215,7 +217,7 @@ static int test_find_delalloc(u32 sectorsize)
 	page = find_get_page(inode->i_mapping,
 			     (max_bytes + SZ_1M) >> PAGE_SHIFT);
 	if (!page) {
-		test_msg("Couldn't find our page\n");
+		test_err("couldn't find our page");
 		goto out_bits;
 	}
 	ClearPageDirty(page);
@@ -234,18 +236,17 @@ static int test_find_delalloc(u32 sectorsize)
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
-		test_msg("Didn't find our range\n");
+		test_err("didn't find our range");
 		goto out_bits;
 	}
 	if (start != test_start && end != test_start + PAGE_SIZE - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
-			 test_start, test_start + PAGE_SIZE - 1, start,
-			 end);
+		test_err("expected start %llu end %llu, got start %llu end %llu",
+			 test_start, test_start + PAGE_SIZE - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
 			       PROCESS_UNLOCK)) {
-		test_msg("Pages in range were not all locked\n");
+		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
 	ret = 0;
@@ -271,14 +272,14 @@ static int check_eb_bitmap(unsigned long *bitmap, struct extent_buffer *eb,
 		bit = !!test_bit(i, bitmap);
 		bit1 = !!extent_buffer_test_bit(eb, 0, i);
 		if (bit1 != bit) {
-			test_msg("Bits do not match\n");
+			test_err("bits do not match");
 			return -EINVAL;
 		}
 
 		bit1 = !!extent_buffer_test_bit(eb, i / BITS_PER_BYTE,
 						i % BITS_PER_BYTE);
 		if (bit1 != bit) {
-			test_msg("Offset bits do not match\n");
+			test_err("offset bits do not match");
 			return -EINVAL;
 		}
 	}
@@ -295,7 +296,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	memset(bitmap, 0, len);
 	memzero_extent_buffer(eb, 0, len);
 	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
-		test_msg("Bitmap was not zeroed\n");
+		test_err("bitmap was not zeroed");
 		return -EINVAL;
 	}
 
@@ -303,7 +304,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
 	ret = check_eb_bitmap(bitmap, eb, len);
 	if (ret) {
-		test_msg("Setting all bits failed\n");
+		test_err("setting all bits failed");
 		return ret;
 	}
 
@@ -311,7 +312,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	extent_buffer_bitmap_clear(eb, 0, 0, len * BITS_PER_BYTE);
 	ret = check_eb_bitmap(bitmap, eb, len);
 	if (ret) {
-		test_msg("Clearing all bits failed\n");
+		test_err("clearing all bits failed");
 		return ret;
 	}
 
@@ -324,7 +325,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 					sizeof(long) * BITS_PER_BYTE);
 		ret = check_eb_bitmap(bitmap, eb, len);
 		if (ret) {
-			test_msg("Setting straddling pages failed\n");
+			test_err("setting straddling pages failed");
 			return ret;
 		}
 
@@ -337,7 +338,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 					sizeof(long) * BITS_PER_BYTE);
 		ret = check_eb_bitmap(bitmap, eb, len);
 		if (ret) {
-			test_msg("Clearing straddling pages failed\n");
+			test_err("clearing straddling pages failed");
 			return ret;
 		}
 	}
@@ -361,7 +362,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 
 	ret = check_eb_bitmap(bitmap, eb, len);
 	if (ret) {
-		test_msg("Random bit pattern failed\n");
+		test_err("random bit pattern failed");
 		return ret;
 	}
 
@@ -376,7 +377,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	struct extent_buffer *eb;
 	int ret;
 
-	test_msg("Running extent buffer bitmap tests\n");
+	test_msg("running extent buffer bitmap tests\n");
 
 	/*
 	 * In ppc64, sectorsize can be 64K, thus 4 * 64K will be larger than
@@ -389,13 +390,13 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
-		test_msg("Couldn't allocate test bitmap\n");
+		test_err("couldn't allocate test bitmap");
 		return -ENOMEM;
 	}
 
 	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
 	if (!eb) {
-		test_msg("Couldn't allocate test extent buffer\n");
+		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
 	}
@@ -408,7 +409,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	free_extent_buffer(eb);
 	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
 	if (!eb) {
-		test_msg("Couldn't allocate test extent buffer\n");
+		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
 	}
@@ -424,7 +425,7 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
-	test_msg("Running extent I/O tests\n");
+	test_msg("running extent I/O tests\n");
 
 	ret = test_find_delalloc(sectorsize);
 	if (ret)
@@ -432,6 +433,6 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 
 	ret = test_eb_bitmaps(sectorsize, nodesize);
 out:
-	test_msg("Extent I/O tests finished\n");
+	test_msg("extent I/O tests finished\n");
 	return ret;
 }
diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 9c051c4a3315..d55266e01cad 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -19,8 +19,8 @@ static void free_extent_map_tree(struct extent_map_tree *em_tree)
 
 #ifdef CONFIG_BTRFS_DEBUG
 		if (refcount_read(&em->refs) != 1) {
-			test_msg(
-"em leak: em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx) refs %d\n",
+			test_err(
+"em leak: em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx) refs %d",
 				 em->start, em->len, em->block_start,
 				 em->block_len, refcount_read(&em->refs));
 
@@ -93,12 +93,12 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 	em->block_len = len;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, em->start, em->len);
 	if (ret)
-		test_msg("case1 [%llu %llu]: ret %d\n", start, start + len, ret);
+		test_err("case1 [%llu %llu]: ret %d", start, start + len, ret);
 	if (em &&
 	    (em->start != 0 || extent_map_end(em) != SZ_16K ||
 	     em->block_start != 0 || em->block_len != SZ_16K))
-		test_msg(
-"case1 [%llu %llu]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu\n",
+		test_err(
+"case1 [%llu %llu]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu",
 			 start, start + len, ret, em->start, em->len,
 			 em->block_start, em->block_len);
 	free_extent_map(em);
@@ -157,12 +157,12 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 	em->block_len = (u64)-1;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, em->start, em->len);
 	if (ret)
-		test_msg("case2 [0 1K]: ret %d\n", ret);
+		test_err("case2 [0 1K]: ret %d", ret);
 	if (em &&
 	    (em->start != 0 || extent_map_end(em) != SZ_1K ||
 	     em->block_start != EXTENT_MAP_INLINE || em->block_len != (u64)-1))
-		test_msg(
-"case2 [0 1K]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu\n",
+		test_err(
+"case2 [0 1K]: ret %d return a wrong em (start %llu len %llu block_start %llu block_len %llu",
 			 ret, em->start, em->len, em->block_start,
 			 em->block_len);
 	free_extent_map(em);
@@ -203,7 +203,7 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 	em->block_len = SZ_16K;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	if (ret)
-		test_msg("case3 [0x%llx 0x%llx): ret %d\n",
+		test_err("case3 [0x%llx 0x%llx): ret %d",
 			 start, start + len, ret);
 	/*
 	 * Since bytes within em are contiguous, em->block_start is identical to
@@ -212,8 +212,8 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 	if (em &&
 	    (start < em->start || start + len > extent_map_end(em) ||
 	     em->start != em->block_start || em->len != em->block_len))
-		test_msg(
-"case3 [0x%llx 0x%llx): ret %d em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)\n",
+		test_err(
+"case3 [0x%llx 0x%llx): ret %d em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)",
 			 start, start + len, ret, em->start, em->len,
 			 em->block_start, em->block_len);
 	free_extent_map(em);
@@ -290,12 +290,12 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 	em->block_len = SZ_32K;
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	if (ret)
-		test_msg("case4 [0x%llx 0x%llx): ret %d\n",
+		test_err("case4 [0x%llx 0x%llx): ret %d",
 			 start, len, ret);
 	if (em &&
 	    (start < em->start || start + len > extent_map_end(em)))
-		test_msg(
-"case4 [0x%llx 0x%llx): ret %d, added wrong em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)\n",
+		test_err(
+"case4 [0x%llx 0x%llx): ret %d, added wrong em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)",
 			 start, len, ret, em->start, em->len, em->block_start,
 			 em->block_len);
 	free_extent_map(em);
@@ -341,7 +341,7 @@ int btrfs_test_extent_map(void)
 	struct btrfs_fs_info *fs_info = NULL;
 	struct extent_map_tree *em_tree;
 
-	test_msg("Running extent_map tests\n");
+	test_msg("running extent_map tests\n");
 
 	/*
 	 * Note: the fs_info is not set up completely, we only need
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index d3c9f8a59ba5..7cbad3e666d3 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -20,63 +20,63 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 {
 	int ret = 0;
 
-	test_msg("Running extent only tests\n");
+	test_msg("running extent only tests\n");
 
 	/* First just make sure we can remove an entire entry */
 	ret = btrfs_add_free_space(cache, 0, SZ_4M);
 	if (ret) {
-		test_msg("Error adding initial extents %d\n", ret);
+		test_err("error adding initial extents %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, SZ_4M);
 	if (ret) {
-		test_msg("Error removing extent %d\n", ret);
+		test_err("error removing extent %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, 0, SZ_4M)) {
-		test_msg("Full remove left some lingering space\n");
+		test_err("full remove left some lingering space");
 		return -1;
 	}
 
 	/* Ok edge and middle cases now */
 	ret = btrfs_add_free_space(cache, 0, SZ_4M);
 	if (ret) {
-		test_msg("Error adding half extent %d\n", ret);
+		test_err("error adding half extent %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 3 * SZ_1M, SZ_1M);
 	if (ret) {
-		test_msg("Error removing tail end %d\n", ret);
+		test_err("error removing tail end %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, SZ_1M);
 	if (ret) {
-		test_msg("Error removing front end %d\n", ret);
+		test_err("error removing front end %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, SZ_2M, 4096);
 	if (ret) {
-		test_msg("Error removing middle piece %d\n", ret);
+		test_err("error removing middle piece %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, 0, SZ_1M)) {
-		test_msg("Still have space at the front\n");
+		test_err("still have space at the front");
 		return -1;
 	}
 
 	if (test_check_exists(cache, SZ_2M, 4096)) {
-		test_msg("Still have space in the middle\n");
+		test_err("still have space in the middle");
 		return -1;
 	}
 
 	if (test_check_exists(cache, 3 * SZ_1M, SZ_1M)) {
-		test_msg("Still have space at the end\n");
+		test_err("still have space at the end");
 		return -1;
 	}
 
@@ -92,34 +92,34 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache,
 	u64 next_bitmap_offset;
 	int ret;
 
-	test_msg("Running bitmap only tests\n");
+	test_msg("running bitmap only tests\n");
 
 	ret = test_add_free_space_entry(cache, 0, SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't create a bitmap entry %d\n", ret);
+		test_err("couldn't create a bitmap entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, SZ_4M);
 	if (ret) {
-		test_msg("Error removing bitmap full range %d\n", ret);
+		test_err("error removing bitmap full range %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, 0, SZ_4M)) {
-		test_msg("Left some space in bitmap\n");
+		test_err("left some space in bitmap");
 		return -1;
 	}
 
 	ret = test_add_free_space_entry(cache, 0, SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't add to our bitmap entry %d\n", ret);
+		test_err("couldn't add to our bitmap entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, SZ_1M, SZ_2M);
 	if (ret) {
-		test_msg("Couldn't remove middle chunk %d\n", ret);
+		test_err("couldn't remove middle chunk %d", ret);
 		return ret;
 	}
 
@@ -133,19 +133,19 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache,
 	ret = test_add_free_space_entry(cache, next_bitmap_offset - SZ_2M,
 					SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't add space that straddles two bitmaps %d\n",
+		test_err("couldn't add space that straddles two bitmaps %d",
 				ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, next_bitmap_offset - SZ_1M, SZ_2M);
 	if (ret) {
-		test_msg("Couldn't remove overlapping space %d\n", ret);
+		test_err("couldn't remove overlapping space %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, next_bitmap_offset - SZ_1M, SZ_2M)) {
-		test_msg("Left some space when removing overlapping\n");
+		test_err("left some space when removing overlapping");
 		return -1;
 	}
 
@@ -161,7 +161,7 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 	int ret;
 
-	test_msg("Running bitmap and extent tests\n");
+	test_msg("running bitmap and extent tests\n");
 
 	/*
 	 * First let's do something simple, an extent at the same offset as the
@@ -170,42 +170,42 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	 */
 	ret = test_add_free_space_entry(cache, SZ_4M, SZ_1M, 1);
 	if (ret) {
-		test_msg("Couldn't create bitmap entry %d\n", ret);
+		test_err("couldn't create bitmap entry %d", ret);
 		return ret;
 	}
 
 	ret = test_add_free_space_entry(cache, 0, SZ_1M, 0);
 	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
+		test_err("couldn't add extent entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 0, SZ_1M);
 	if (ret) {
-		test_msg("Couldn't remove extent entry %d\n", ret);
+		test_err("couldn't remove extent entry %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, 0, SZ_1M)) {
-		test_msg("Left remnants after our remove\n");
+		test_err("left remnants after our remove");
 		return -1;
 	}
 
 	/* Now to add back the extent entry and remove from the bitmap */
 	ret = test_add_free_space_entry(cache, 0, SZ_1M, 0);
 	if (ret) {
-		test_msg("Couldn't re-add extent entry %d\n", ret);
+		test_err("couldn't re-add extent entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, SZ_4M, SZ_1M);
 	if (ret) {
-		test_msg("Couldn't remove from bitmap %d\n", ret);
+		test_err("couldn't remove from bitmap %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, SZ_4M, SZ_1M)) {
-		test_msg("Left remnants in the bitmap\n");
+		test_err("left remnants in the bitmap");
 		return -1;
 	}
 
@@ -215,18 +215,18 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	 */
 	ret = test_add_free_space_entry(cache, SZ_1M, SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't add to a bitmap %d\n", ret);
+		test_err("couldn't add to a bitmap %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, SZ_512K, 3 * SZ_1M);
 	if (ret) {
-		test_msg("Couldn't remove overlapping space %d\n", ret);
+		test_err("couldn't remove overlapping space %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, SZ_512K, 3 * SZ_1M)) {
-		test_msg("Left over pieces after removing overlapping\n");
+		test_err("left over pieces after removing overlapping");
 		return -1;
 	}
 
@@ -235,24 +235,24 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	/* Now with the extent entry offset into the bitmap */
 	ret = test_add_free_space_entry(cache, SZ_4M, SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't add space to the bitmap %d\n", ret);
+		test_err("couldn't add space to the bitmap %d", ret);
 		return ret;
 	}
 
 	ret = test_add_free_space_entry(cache, SZ_2M, SZ_2M, 0);
 	if (ret) {
-		test_msg("Couldn't add extent to the cache %d\n", ret);
+		test_err("couldn't add extent to the cache %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, 3 * SZ_1M, SZ_4M);
 	if (ret) {
-		test_msg("Problem removing overlapping space %d\n", ret);
+		test_err("problem removing overlapping space %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, 3 * SZ_1M, SZ_4M)) {
-		test_msg("Left something behind when removing space");
+		test_err("left something behind when removing space");
 		return -1;
 	}
 
@@ -269,25 +269,25 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	__btrfs_remove_free_space_cache(cache->free_space_ctl);
 	ret = test_add_free_space_entry(cache, bitmap_offset + SZ_4M, SZ_4M, 1);
 	if (ret) {
-		test_msg("Couldn't add bitmap %d\n", ret);
+		test_err("couldn't add bitmap %d", ret);
 		return ret;
 	}
 
 	ret = test_add_free_space_entry(cache, bitmap_offset - SZ_1M,
 					5 * SZ_1M, 0);
 	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
+		test_err("couldn't add extent entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, bitmap_offset + SZ_1M, 5 * SZ_1M);
 	if (ret) {
-		test_msg("Failed to free our space %d\n", ret);
+		test_err("failed to free our space %d", ret);
 		return ret;
 	}
 
 	if (test_check_exists(cache, bitmap_offset + SZ_1M, 5 * SZ_1M)) {
-		test_msg("Left stuff over\n");
+		test_err("left stuff over");
 		return -1;
 	}
 
@@ -301,19 +301,19 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	 */
 	ret = test_add_free_space_entry(cache, SZ_1M, SZ_2M, 1);
 	if (ret) {
-		test_msg("Couldn't add bitmap entry %d\n", ret);
+		test_err("couldn't add bitmap entry %d", ret);
 		return ret;
 	}
 
 	ret = test_add_free_space_entry(cache, 3 * SZ_1M, SZ_1M, 0);
 	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
+		test_err("couldn't add extent entry %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_remove_free_space(cache, SZ_1M, 3 * SZ_1M);
 	if (ret) {
-		test_msg("Error removing bitmap and extent overlapping %d\n", ret);
+		test_err("error removing bitmap and extent overlapping %d", ret);
 		return ret;
 	}
 
@@ -335,12 +335,14 @@ check_num_extents_and_bitmaps(const struct btrfs_block_group_cache *cache,
 			      const int num_bitmaps)
 {
 	if (cache->free_space_ctl->free_extents != num_extents) {
-		test_msg("Incorrect # of extent entries in the cache: %d, expected %d\n",
+		test_err(
+		"incorrect # of extent entries in the cache: %d, expected %d",
 			 cache->free_space_ctl->free_extents, num_extents);
 		return -EINVAL;
 	}
 	if (cache->free_space_ctl->total_bitmaps != num_bitmaps) {
-		test_msg("Incorrect # of extent entries in the cache: %d, expected %d\n",
+		test_err(
+		"incorrect # of extent entries in the cache: %d, expected %d",
 			 cache->free_space_ctl->total_bitmaps, num_bitmaps);
 		return -EINVAL;
 	}
@@ -358,7 +360,7 @@ static int check_cache_empty(struct btrfs_block_group_cache *cache)
 	 * allocate.
 	 */
 	if (cache->free_space_ctl->free_space != 0) {
-		test_msg("Cache free space is not 0\n");
+		test_err("cache free space is not 0");
 		return -EINVAL;
 	}
 
@@ -366,7 +368,7 @@ static int check_cache_empty(struct btrfs_block_group_cache *cache)
 	offset = btrfs_find_space_for_alloc(cache, 0, 4096, 0,
 					    &max_extent_size);
 	if (offset != 0) {
-		test_msg("Space allocation did not fail, returned offset: %llu",
+		test_err("space allocation did not fail, returned offset: %llu",
 			 offset);
 		return -EINVAL;
 	}
@@ -402,7 +404,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	};
 	const struct btrfs_free_space_op *orig_free_space_ops;
 
-	test_msg("Running space stealing from bitmap to extent\n");
+	test_msg("running space stealing from bitmap to extent\n");
 
 	/*
 	 * For this test, we want to ensure we end up with an extent entry
@@ -430,7 +432,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = test_add_free_space_entry(cache, SZ_128M - SZ_256K, SZ_128K, 0);
 	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
+		test_err("couldn't add extent entry %d", ret);
 		return ret;
 	}
 
@@ -438,7 +440,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	ret = test_add_free_space_entry(cache, SZ_128M + SZ_512K,
 					SZ_128M - SZ_512K, 1);
 	if (ret) {
-		test_msg("Couldn't add bitmap entry %d\n", ret);
+		test_err("couldn't add bitmap entry %d", ret);
 		return ret;
 	}
 
@@ -457,17 +459,17 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 				      SZ_128M + 768 * SZ_1K,
 				      SZ_128M - 768 * SZ_1K);
 	if (ret) {
-		test_msg("Failed to free part of bitmap space %d\n", ret);
+		test_err("failed to free part of bitmap space %d", ret);
 		return ret;
 	}
 
 	/* Confirm that only those 2 ranges are marked as free. */
 	if (!test_check_exists(cache, SZ_128M - SZ_256K, SZ_128K)) {
-		test_msg("Free space range missing\n");
+		test_err("free space range missing");
 		return -ENOENT;
 	}
 	if (!test_check_exists(cache, SZ_128M + SZ_512K, SZ_256K)) {
-		test_msg("Free space range missing\n");
+		test_err("free space range missing");
 		return -ENOENT;
 	}
 
@@ -477,7 +479,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	if (test_check_exists(cache, SZ_128M + 768 * SZ_1K,
 			      SZ_128M - 768 * SZ_1K)) {
-		test_msg("Bitmap region not removed from space cache\n");
+		test_err("bitmap region not removed from space cache");
 		return -EINVAL;
 	}
 
@@ -486,7 +488,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * covered by the bitmap, isn't marked as free.
 	 */
 	if (test_check_exists(cache, SZ_128M + SZ_256K, SZ_256K)) {
-		test_msg("Invalid bitmap region marked as free\n");
+		test_err("invalid bitmap region marked as free");
 		return -EINVAL;
 	}
 
@@ -495,7 +497,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * by the bitmap too, isn't marked as free either.
 	 */
 	if (test_check_exists(cache, SZ_128M, SZ_256K)) {
-		test_msg("Invalid bitmap region marked as free\n");
+		test_err("invalid bitmap region marked as free");
 		return -EINVAL;
 	}
 
@@ -506,12 +508,12 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_128M, SZ_512K);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 	/* Confirm the region is marked as free. */
 	if (!test_check_exists(cache, SZ_128M, SZ_512K)) {
-		test_msg("Bitmap region not marked as free\n");
+		test_err("bitmap region not marked as free");
 		return -ENOENT;
 	}
 
@@ -531,7 +533,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_128M + SZ_16M, sectorsize);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 
@@ -550,12 +552,12 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_128M - SZ_128K, SZ_128K);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 	/* Confirm the region is marked as free. */
 	if (!test_check_exists(cache, SZ_128M - SZ_128K, SZ_128K)) {
-		test_msg("Extent region not marked as free\n");
+		test_err("extent region not marked as free");
 		return -ENOENT;
 	}
 
@@ -583,12 +585,12 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * allocate the whole free space at once.
 	 */
 	if (!test_check_exists(cache, SZ_128M - SZ_256K, SZ_1M)) {
-		test_msg("Expected region not marked as free\n");
+		test_err("expected region not marked as free");
 		return -ENOENT;
 	}
 
 	if (cache->free_space_ctl->free_space != (SZ_1M + sectorsize)) {
-		test_msg("Cache free space is not 1Mb + %u\n", sectorsize);
+		test_err("cache free space is not 1Mb + %u", sectorsize);
 		return -EINVAL;
 	}
 
@@ -596,7 +598,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 					    0, SZ_1M, 0,
 					    &max_extent_size);
 	if (offset != (SZ_128M - SZ_256K)) {
-		test_msg("Failed to allocate 1Mb from space cache, returned offset is: %llu\n",
+		test_err(
+	"failed to allocate 1Mb from space cache, returned offset is: %llu",
 			 offset);
 		return -EINVAL;
 	}
@@ -610,7 +613,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 		return ret;
 
 	if (cache->free_space_ctl->free_space != sectorsize) {
-		test_msg("Cache free space is not %u\n", sectorsize);
+		test_err("cache free space is not %u", sectorsize);
 		return -EINVAL;
 	}
 
@@ -618,7 +621,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 					    0, sectorsize, 0,
 					    &max_extent_size);
 	if (offset != (SZ_128M + SZ_16M)) {
-		test_msg("Failed to allocate %u, returned offset : %llu\n",
+		test_err("failed to allocate %u, returned offset : %llu",
 			 sectorsize, offset);
 		return -EINVAL;
 	}
@@ -640,14 +643,14 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = test_add_free_space_entry(cache, SZ_128M + SZ_128K, SZ_128K, 0);
 	if (ret) {
-		test_msg("Couldn't add extent entry %d\n", ret);
+		test_err("couldn't add extent entry %d", ret);
 		return ret;
 	}
 
 	/* Bitmap entry covering free space range [0, 128Mb - 512Kb[ */
 	ret = test_add_free_space_entry(cache, 0, SZ_128M - SZ_512K, 1);
 	if (ret) {
-		test_msg("Couldn't add bitmap entry %d\n", ret);
+		test_err("couldn't add bitmap entry %d", ret);
 		return ret;
 	}
 
@@ -664,17 +667,17 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_remove_free_space(cache, 0, SZ_128M - 768 * SZ_1K);
 	if (ret) {
-		test_msg("Failed to free part of bitmap space %d\n", ret);
+		test_err("failed to free part of bitmap space %d", ret);
 		return ret;
 	}
 
 	/* Confirm that only those 2 ranges are marked as free. */
 	if (!test_check_exists(cache, SZ_128M + SZ_128K, SZ_128K)) {
-		test_msg("Free space range missing\n");
+		test_err("free space range missing");
 		return -ENOENT;
 	}
 	if (!test_check_exists(cache, SZ_128M - 768 * SZ_1K, SZ_256K)) {
-		test_msg("Free space range missing\n");
+		test_err("free space range missing");
 		return -ENOENT;
 	}
 
@@ -683,7 +686,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * as free anymore.
 	 */
 	if (test_check_exists(cache, 0, SZ_128M - 768 * SZ_1K)) {
-		test_msg("Bitmap region not removed from space cache\n");
+		test_err("bitmap region not removed from space cache");
 		return -EINVAL;
 	}
 
@@ -692,7 +695,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * covered by the bitmap, isn't marked as free.
 	 */
 	if (test_check_exists(cache, SZ_128M - SZ_512K, SZ_512K)) {
-		test_msg("Invalid bitmap region marked as free\n");
+		test_err("invalid bitmap region marked as free");
 		return -EINVAL;
 	}
 
@@ -703,12 +706,12 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_128M - SZ_512K, SZ_512K);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 	/* Confirm the region is marked as free. */
 	if (!test_check_exists(cache, SZ_128M - SZ_512K, SZ_512K)) {
-		test_msg("Bitmap region not marked as free\n");
+		test_err("bitmap region not marked as free");
 		return -ENOENT;
 	}
 
@@ -728,7 +731,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_32M, 2 * sectorsize);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 
@@ -739,12 +742,12 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 */
 	ret = btrfs_add_free_space(cache, SZ_128M, SZ_128K);
 	if (ret) {
-		test_msg("Error adding free space: %d\n", ret);
+		test_err("error adding free space: %d", ret);
 		return ret;
 	}
 	/* Confirm the region is marked as free. */
 	if (!test_check_exists(cache, SZ_128M, SZ_128K)) {
-		test_msg("Extent region not marked as free\n");
+		test_err("extent region not marked as free");
 		return -ENOENT;
 	}
 
@@ -772,19 +775,20 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	 * allocate the whole free space at once.
 	 */
 	if (!test_check_exists(cache, SZ_128M - 768 * SZ_1K, SZ_1M)) {
-		test_msg("Expected region not marked as free\n");
+		test_err("expected region not marked as free");
 		return -ENOENT;
 	}
 
 	if (cache->free_space_ctl->free_space != (SZ_1M + 2 * sectorsize)) {
-		test_msg("Cache free space is not 1Mb + %u\n", 2 * sectorsize);
+		test_err("cache free space is not 1Mb + %u", 2 * sectorsize);
 		return -EINVAL;
 	}
 
 	offset = btrfs_find_space_for_alloc(cache, 0, SZ_1M, 0,
 					    &max_extent_size);
 	if (offset != (SZ_128M - 768 * SZ_1K)) {
-		test_msg("Failed to allocate 1Mb from space cache, returned offset is: %llu\n",
+		test_err(
+	"failed to allocate 1Mb from space cache, returned offset is: %llu",
 			 offset);
 		return -EINVAL;
 	}
@@ -798,7 +802,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 		return ret;
 
 	if (cache->free_space_ctl->free_space != 2 * sectorsize) {
-		test_msg("Cache free space is not %u\n", 2 * sectorsize);
+		test_err("cache free space is not %u", 2 * sectorsize);
 		return -EINVAL;
 	}
 
@@ -806,9 +810,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 					    0, 2 * sectorsize, 0,
 					    &max_extent_size);
 	if (offset != SZ_32M) {
-		test_msg("Failed to allocate %u, offset: %llu\n",
-			 2 * sectorsize,
-			 offset);
+		test_err("failed to allocate %u, offset: %llu",
+			 2 * sectorsize, offset);
 		return -EINVAL;
 	}
 
@@ -829,7 +832,7 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	struct btrfs_root *root = NULL;
 	int ret = -ENOMEM;
 
-	test_msg("Running btrfs free space cache tests\n");
+	test_msg("running btrfs free space cache tests\n");
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info)
 		return -ENOMEM;
@@ -843,7 +846,7 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	cache = btrfs_alloc_dummy_block_group(fs_info,
 				      BITS_PER_BITMAP * sectorsize + PAGE_SIZE);
 	if (!cache) {
-		test_msg("Couldn't run the tests\n");
+		test_err("couldn't run the tests");
 		btrfs_free_dummy_fs_info(fs_info);
 		return 0;
 	}
@@ -871,6 +874,6 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	btrfs_free_dummy_block_group(cache);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
-	test_msg("Free space cache tests finished\n");
+	test_msg("free space cache tests finished\n");
 	return ret;
 }
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index cb92868eec15..8c0b395257ea 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -32,7 +32,7 @@ static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 
 	info = search_free_space_info(trans, fs_info, cache, path, 0);
 	if (IS_ERR(info)) {
-		test_msg("Could not find free space info\n");
+		test_err("could not find free space info");
 		ret = PTR_ERR(info);
 		goto out;
 	}
@@ -40,7 +40,7 @@ static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 	extent_count = btrfs_free_space_extent_count(path->nodes[0], info);
 
 	if (extent_count != num_extents) {
-		test_msg("Extent count is wrong\n");
+		test_err("extent count is wrong");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -99,7 +99,7 @@ static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	return ret;
 invalid:
-	test_msg("Free space tree is invalid\n");
+	test_err("free space tree is invalid");
 	ret = -EINVAL;
 	goto out;
 }
@@ -117,7 +117,7 @@ static int check_free_space_extents(struct btrfs_trans_handle *trans,
 
 	info = search_free_space_info(trans, fs_info, cache, path, 0);
 	if (IS_ERR(info)) {
-		test_msg("Could not find free space info\n");
+		test_err("could not find free space info");
 		btrfs_release_path(path);
 		return PTR_ERR(info);
 	}
@@ -133,13 +133,13 @@ static int check_free_space_extents(struct btrfs_trans_handle *trans,
 	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
 		ret = convert_free_space_to_extents(trans, cache, path);
 		if (ret) {
-			test_msg("Could not convert to extents\n");
+			test_err("could not convert to extents");
 			return ret;
 		}
 	} else {
 		ret = convert_free_space_to_bitmaps(trans, cache, path);
 		if (ret) {
-			test_msg("Could not convert to bitmaps\n");
+			test_err("could not convert to bitmaps");
 			return ret;
 		}
 	}
@@ -174,7 +174,7 @@ static int test_remove_all(struct btrfs_trans_handle *trans,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
@@ -197,7 +197,7 @@ static int test_remove_beginning(struct btrfs_trans_handle *trans,
 	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid, alignment);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
@@ -222,7 +222,7 @@ static int test_remove_end(struct btrfs_trans_handle *trans,
 					    cache->key.offset - alignment,
 					    alignment);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
@@ -247,7 +247,7 @@ static int test_remove_middle(struct btrfs_trans_handle *trans,
 					    cache->key.objectid + alignment,
 					    alignment);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
@@ -270,14 +270,14 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -285,7 +285,7 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -308,7 +308,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
@@ -316,7 +316,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -324,7 +324,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -347,14 +347,14 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -362,7 +362,7 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -370,7 +370,7 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -395,14 +395,14 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-		test_msg("Could not remove free space\n");
+		test_err("could not remove free space");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -410,7 +410,7 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + 4 * alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -418,7 +418,7 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
-		test_msg("Could not add free space\n");
+		test_err("could not add free space");
 		return ret;
 	}
 
@@ -444,14 +444,14 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_err("couldn't allocate dummy fs info");
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Couldn't allocate dummy root\n");
+		test_err("couldn't allocate dummy root");
 		ret = PTR_ERR(root);
 		goto out;
 	}
@@ -463,7 +463,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
 	if (!root->node) {
-		test_msg("Couldn't allocate dummy buffer\n");
+		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -473,7 +473,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	cache = btrfs_alloc_dummy_block_group(fs_info, 8 * alignment);
 	if (!cache) {
-		test_msg("Couldn't allocate dummy block group cache\n");
+		test_err("couldn't allocate dummy block group cache");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -486,21 +486,21 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Couldn't allocate path\n");
+		test_err("couldn't allocate path");
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	ret = add_block_group_free_space(&trans, cache);
 	if (ret) {
-		test_msg("Could not add block group free space\n");
+		test_err("could not add block group free space");
 		goto out;
 	}
 
 	if (bitmaps) {
 		ret = convert_free_space_to_bitmaps(&trans, cache, path);
 		if (ret) {
-			test_msg("Could not convert block group to bitmaps\n");
+			test_err("could not convert block group to bitmaps");
 			goto out;
 		}
 	}
@@ -511,12 +511,12 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	ret = remove_block_group_free_space(&trans, cache);
 	if (ret) {
-		test_msg("Could not remove block group free space\n");
+		test_err("could not remove block group free space");
 		goto out;
 	}
 
 	if (btrfs_header_nritems(root->node) != 0) {
-		test_msg("Free space tree has leftover items\n");
+		test_err("free space tree has leftover items");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -538,14 +538,16 @@ static int run_test_both_formats(test_func_t test_func, u32 sectorsize,
 
 	ret = run_test(test_func, 0, sectorsize, nodesize, alignment);
 	if (ret) {
-		test_msg("%pf failed with extents, sectorsize=%u, nodesize=%u, alignment=%u\n",
+		test_err(
+	"%pf failed with extents, sectorsize=%u, nodesize=%u, alignment=%u",
 			 test_func, sectorsize, nodesize, alignment);
 		test_ret = ret;
 	}
 
 	ret = run_test(test_func, 1, sectorsize, nodesize, alignment);
 	if (ret) {
-		test_msg("%pf failed with bitmaps, sectorsize=%u, nodesize=%u, alignment=%u\n",
+		test_err(
+	"%pf failed with bitmaps, sectorsize=%u, nodesize=%u, alignment=%u",
 			 test_func, sectorsize, nodesize, alignment);
 		test_ret = ret;
 	}
@@ -576,7 +578,7 @@ int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 	 */
 	bitmap_alignment = BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE;
 
-	test_msg("Running free space tree tests\n");
+	test_msg("running free space tree tests\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		int ret;
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index e0ba799536b4..2f2f9dc30f4c 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -228,7 +228,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_msg("Couldn't allocate inode\n");
+		test_err("couldn't allocate inode");
 		return ret;
 	}
 
@@ -238,19 +238,19 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_err("couldn't allocate dummy fs info");
 		goto out;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Couldn't allocate root\n");
+		test_err("couldn't allocate root");
 		goto out;
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!root->node) {
-		test_msg("Couldn't allocate dummy buffer\n");
+		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
 
@@ -268,11 +268,11 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, 0, sectorsize, 0);
 	if (IS_ERR(em)) {
 		em = NULL;
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole, got %llu\n", em->block_start);
+		test_err("expected a hole, got %llu", em->block_start);
 		goto out;
 	}
 	free_extent_map(em);
@@ -287,20 +287,21 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, 0, (u64)-1, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole, got %llu\n", em->block_start);
+		test_err("expected a hole, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != 0 || em->len != 5) {
-		test_msg("Unexpected extent wanted start 0 len 5, got start "
-			 "%llu len %llu\n", em->start, em->len);
+		test_err(
+		"unexpected extent wanted start 0 len 5, got start %llu len %llu",
+			em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	offset = em->start + em->len;
@@ -308,21 +309,22 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_INLINE) {
-		test_msg("Expected an inline, got %llu\n", em->block_start);
+		test_err("expected an inline, got %llu", em->block_start);
 		goto out;
 	}
 
 	if (em->start != offset || em->len != (sectorsize - 5)) {
-		test_msg("Unexpected extent wanted start %llu len 1, got start "
-			 "%llu len %llu\n", offset, em->start, em->len);
+		test_err(
+	"unexpected extent wanted start %llu len 1, got start %llu len %llu",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	/*
@@ -335,20 +337,21 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole, got %llu\n", em->block_start);
+		test_err("expected a hole, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != 4) {
-		test_msg("Unexpected extent wanted start %llu len 4, got start "
-			 "%llu len %llu\n", offset, em->start, em->len);
+		test_err(
+	"unexpected extent wanted start %llu len 4, got start %llu len %llu",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	offset = em->start + em->len;
@@ -357,24 +360,25 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* Regular extent */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize - 1) {
-		test_msg("Unexpected extent wanted start %llu len 4095, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+		test_err(
+	"unexpected extent wanted start %llu len 4095, got start %llu len %llu",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -384,25 +388,25 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* The next 3 are split extents */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+		"unexpected extent start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -413,21 +417,21 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole, got %llu\n", em->block_start);
+		test_err("expected a hole, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	offset = em->start + em->len;
@@ -435,31 +439,31 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != 2 * sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != orig_start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n",
+		test_err("wrong orig offset, want %llu, have %llu",
 			 orig_start, em->orig_start);
 		goto out;
 	}
 	disk_bytenr += (em->start - orig_start);
 	if (em->block_start != disk_bytenr) {
-		test_msg("Wrong block start, want %llu, have %llu\n",
+		test_err("wrong block start, want %llu, have %llu",
 			 disk_bytenr, em->block_start);
 		goto out;
 	}
@@ -469,26 +473,26 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* Prealloc extent */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 prealloc_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -498,26 +502,26 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* The next 3 are a half written prealloc extent */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 prealloc_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -528,30 +532,30 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_HOLE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != orig_start) {
-		test_msg("Unexpected orig offset, wanted %llu, have %llu\n",
+		test_err("unexpected orig offset, wanted %llu, have %llu",
 			 orig_start, em->orig_start);
 		goto out;
 	}
 	if (em->block_start != (disk_bytenr + (em->start - em->orig_start))) {
-		test_msg("Unexpected block start, wanted %llu, have %llu\n",
+		test_err("unexpected block start, wanted %llu, have %llu",
 			 disk_bytenr + (em->start - em->orig_start),
 			 em->block_start);
 		goto out;
@@ -561,31 +565,31 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != 2 * sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 prealloc_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != orig_start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", orig_start,
+		test_err("wrong orig offset, want %llu, have %llu", orig_start,
 			 em->orig_start);
 		goto out;
 	}
 	if (em->block_start != (disk_bytenr + (em->start - em->orig_start))) {
-		test_msg("Unexpected block start, wanted %llu, have %llu\n",
+		test_err("unexpected block start, wanted %llu, have %llu",
 			 disk_bytenr + (em->start - em->orig_start),
 			 em->block_start);
 		goto out;
@@ -596,31 +600,31 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* Now for the compressed extent */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != 2 * sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u,"
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 compressed_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n",
+		test_err("wrong orig offset, want %llu, have %llu",
 			 em->start, em->orig_start);
 		goto out;
 	}
 	if (em->compress_type != BTRFS_COMPRESS_ZLIB) {
-		test_msg("Unexpected compress type, wanted %d, got %d\n",
+		test_err("unexpected compress type, wanted %d, got %d",
 			 BTRFS_COMPRESS_ZLIB, em->compress_type);
 		goto out;
 	}
@@ -630,31 +634,31 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	/* Split compressed extent */
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u,"
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 compressed_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n",
+		test_err("wrong orig offset, want %llu, have %llu",
 			 em->start, em->orig_start);
 		goto out;
 	}
 	if (em->compress_type != BTRFS_COMPRESS_ZLIB) {
-		test_msg("Unexpected compress type, wanted %d, got %d\n",
+		test_err("unexpected compress type, wanted %d, got %d",
 			 BTRFS_COMPRESS_ZLIB, em->compress_type);
 		goto out;
 	}
@@ -665,25 +669,25 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -692,32 +696,32 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != disk_bytenr) {
-		test_msg("Block start does not match, want %llu got %llu\n",
+		test_err("block start does not match, want %llu got %llu",
 			 disk_bytenr, em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != 2 * sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 compressed_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != orig_start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n",
+		test_err("wrong orig offset, want %llu, have %llu",
 			 em->start, orig_start);
 		goto out;
 	}
 	if (em->compress_type != BTRFS_COMPRESS_ZLIB) {
-		test_msg("Unexpected compress type, wanted %d, got %d\n",
+		test_err("unexpected compress type, wanted %d, got %d",
 			 BTRFS_COMPRESS_ZLIB, em->compress_type);
 		goto out;
 	}
@@ -728,25 +732,25 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset + 6,
 			sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -755,11 +759,11 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, SZ_4M, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole extent, got %llu\n", em->block_start);
+		test_err("expected a hole extent, got %llu", em->block_start);
 		goto out;
 	}
 	/*
@@ -768,18 +772,18 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	 * test.
 	 */
 	if (em->start != offset || em->len != 3 * sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, 3 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_err("unexpected flags set, want %lu have %lu",
 			 vacancy_only, em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -788,25 +792,25 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != offset || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %llu len %u,"
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %llu len %u, got start %llu len %llu",
 			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, want 0 have %lu\n", em->flags);
+		test_err("unexpected flags set, want 0 have %lu", em->flags);
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
+		test_err("wrong orig offset, want %llu, have %llu", em->start,
 			 em->orig_start);
 		goto out;
 	}
@@ -830,7 +834,7 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_msg("Couldn't allocate inode\n");
+		test_err("couldn't allocate inode");
 		return ret;
 	}
 
@@ -840,19 +844,19 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_err("couldn't allocate dummy fs info");
 		goto out;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Couldn't allocate root\n");
+		test_err("couldn't allocate root");
 		goto out;
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!root->node) {
-		test_msg("Couldn't allocate dummy buffer\n");
+		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
 
@@ -871,21 +875,21 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, 1);
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, 0, 2 * sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != EXTENT_MAP_HOLE) {
-		test_msg("Expected a hole, got %llu\n", em->block_start);
+		test_err("expected a hole, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != 0 || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start 0 len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start 0 len %u, got start %llu len %llu",
 			sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
-		test_msg("Wrong flags, wanted %lu, have %lu\n", vacancy_only,
+		test_err("wrong flags, wanted %lu, have %lu", vacancy_only,
 			 em->flags);
 		goto out;
 	}
@@ -894,21 +898,21 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, sectorsize,
 			2 * sectorsize, 0);
 	if (IS_ERR(em)) {
-		test_msg("Got an error when we shouldn't have\n");
+		test_err("got an error when we shouldn't have");
 		goto out;
 	}
 	if (em->block_start != sectorsize) {
-		test_msg("Expected a real extent, got %llu\n", em->block_start);
+		test_err("expected a real extent, got %llu", em->block_start);
 		goto out;
 	}
 	if (em->start != sectorsize || em->len != sectorsize) {
-		test_msg("Unexpected extent wanted start %u len %u, "
-			"got start %llu len %llu\n",
+		test_err(
+	"unexpected extent wanted start %u len %u, got start %llu len %llu",
 			sectorsize, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
-		test_msg("Unexpected flags set, wanted 0 got %lu\n",
+		test_err("unexpected flags set, wanted 0 got %lu",
 			 em->flags);
 		goto out;
 	}
@@ -931,19 +935,19 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_msg("Couldn't allocate inode\n");
+		test_err("couldn't allocate inode");
 		return ret;
 	}
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_err("couldn't allocate dummy fs info");
 		goto out;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Couldn't allocate root\n");
+		test_err("couldn't allocate root");
 		goto out;
 	}
 
@@ -954,12 +958,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1, 0,
 					NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 1) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 1, got %u\n",
+		test_err("miscount, wanted 1, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -969,12 +973,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
 					0, NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 2, got %u\n",
+		test_err("miscount, wanted 2, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -986,12 +990,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			       EXTENT_DELALLOC | EXTENT_DIRTY |
 			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
-		test_msg("clear_extent_bit returned %d\n", ret);
+		test_err("clear_extent_bit returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 2, got %u\n",
+		test_err("miscount, wanted 2, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1002,12 +1006,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 					+ sectorsize - 1,
 					0, NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 2, got %u\n",
+		test_err("miscount, wanted 2, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1020,12 +1024,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
 			0, NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 4) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 4, got %u\n",
+		test_err("miscount, wanted 4, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1037,12 +1041,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 3) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 3, got %u\n",
+		test_err("miscount, wanted 3, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1054,12 +1058,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
-		test_msg("clear_extent_bit returned %d\n", ret);
+		test_err("clear_extent_bit returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 4) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 4, got %u\n",
+		test_err("miscount, wanted 4, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1072,12 +1076,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL, 0);
 	if (ret) {
-		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
+		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 3) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 3, got %u\n",
+		test_err("miscount, wanted 3, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1087,12 +1091,12 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
-		test_msg("clear_extent_bit returned %d\n", ret);
+		test_err("clear_extent_bit returned %d", ret);
 		goto out;
 	}
 	if (BTRFS_I(inode)->outstanding_extents) {
 		ret = -EINVAL;
-		test_msg("Miscount, wanted 0, got %u\n",
+		test_err("miscount, wanted 0, got %u",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1115,14 +1119,14 @@ int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
-	test_msg("Running btrfs_get_extent tests\n");
+	test_msg("running btrfs_get_extent tests\n");
 	ret = test_btrfs_get_extent(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("Running hole first btrfs_get_extent test\n");
+	test_msg("running hole first btrfs_get_extent test\n");
 	ret = test_hole_first(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("Running outstanding_extents tests\n");
+	test_msg("running outstanding_extents tests\n");
 	return test_extent_accounting(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index df4bcce20ba5..578c6c461897 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -32,14 +32,14 @@ static int insert_normal_tree_ref(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Couldn't allocate path\n");
+		test_err("couldn't allocate path");
 		return -ENOMEM;
 	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(&trans, root, path, &ins, size);
 	if (ret) {
-		test_msg("Couldn't insert ref %d\n", ret);
+		test_err("couldn't insert ref %d", ret);
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -82,14 +82,14 @@ static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Couldn't allocate path\n");
+		test_err("couldn't allocate path");
 		return -ENOMEM;
 	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
 	if (ret) {
-		test_msg("Couldn't find extent ref\n");
+		test_err("couldn't find extent ref");
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -111,7 +111,7 @@ static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 
 	ret = btrfs_insert_empty_item(&trans, root, path, &key, 0);
 	if (ret)
-		test_msg("Failed to insert backref\n");
+		test_err("failed to insert backref");
 	btrfs_free_path(path);
 	return ret;
 }
@@ -132,14 +132,14 @@ static int remove_extent_item(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Couldn't allocate path\n");
+		test_err("couldn't allocate path");
 		return -ENOMEM;
 	}
 	path->leave_spinning = 1;
 
 	ret = btrfs_search_slot(&trans, root, &key, path, -1, 1);
 	if (ret) {
-		test_msg("Didn't find our key %d\n", ret);
+		test_err("didn't find our key %d", ret);
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -166,14 +166,14 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_msg("Couldn't allocate path\n");
+		test_err("couldn't allocate path");
 		return -ENOMEM;
 	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
 	if (ret) {
-		test_msg("Couldn't find extent ref\n");
+		test_err("couldn't find extent ref");
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -195,7 +195,7 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 
 	ret = btrfs_search_slot(&trans, root, &key, path, -1, 1);
 	if (ret) {
-		test_msg("Couldn't find backref %d\n", ret);
+		test_err("couldn't find backref %d", ret);
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -215,10 +215,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("Qgroup basic add\n");
+	test_msg("qgroup basic add\n");
 	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
-		test_msg("Couldn't create a qgroup %d\n", ret);
+		test_err("couldn't create a qgroup %d", ret);
 		return ret;
 	}
 
@@ -231,7 +231,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
@@ -245,20 +245,20 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
 					  nodesize, old_roots, new_roots);
 	if (ret) {
-		test_msg("Couldn't account space for a qgroup %d\n", ret);
+		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				nodesize, nodesize)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 	old_roots = NULL;
@@ -268,7 +268,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
@@ -281,19 +281,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
 					  nodesize, old_roots, new_roots);
 	if (ret) {
-		test_msg("Couldn't account space for a qgroup %d\n", ret);
+		test_err("couldn't account space for a qgroup %d", ret);
 		return -EINVAL;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID, 0, 0)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
@@ -316,7 +316,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("Qgroup multiple refs test\n");
+	test_msg("qgroup multiple refs test\n");
 
 	/*
 	 * We have BTRFS_FS_TREE_OBJECTID created already from the
@@ -324,7 +324,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	 */
 	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FIRST_FREE_OBJECTID);
 	if (ret) {
-		test_msg("Couldn't create a qgroup %d\n", ret);
+		test_err("couldn't create a qgroup %d", ret);
 		return ret;
 	}
 
@@ -332,7 +332,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
@@ -346,20 +346,20 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
 					  nodesize, old_roots, new_roots);
 	if (ret) {
-		test_msg("Couldn't account space for a qgroup %d\n", ret);
+		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				       nodesize, nodesize)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
@@ -367,7 +367,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
@@ -381,26 +381,26 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
 					  nodesize, old_roots, new_roots);
 	if (ret) {
-		test_msg("Couldn't account space for a qgroup %d\n", ret);
+		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 					nodesize, 0)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
 					nodesize, 0)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
@@ -408,7 +408,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
@@ -422,26 +422,26 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-		test_msg("Couldn't find old roots: %d\n", ret);
+		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
 
 	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
 					  nodesize, old_roots, new_roots);
 	if (ret) {
-		test_msg("Couldn't account space for a qgroup %d\n", ret);
+		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
 					0, 0)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 					nodesize, nodesize)) {
-		test_msg("Qgroup counts didn't match expected values\n");
+		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
 
@@ -457,13 +457,13 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_err("couldn't allocate dummy fs info");
 		return -ENOMEM;
 	}
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_msg("Couldn't allocate root\n");
+		test_err("couldn't allocate root");
 		ret = PTR_ERR(root);
 		goto out;
 	}
@@ -485,7 +485,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
 	if (!root->node) {
-		test_msg("Couldn't allocate dummy buffer\n");
+		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -495,7 +495,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	tmp_root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(tmp_root)) {
-		test_msg("Couldn't allocate a fs root\n");
+		test_err("couldn't allocate a fs root");
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
@@ -504,13 +504,13 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	root->fs_info->fs_root = tmp_root;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
-		test_msg("Couldn't insert fs root %d\n", ret);
+		test_err("couldn't insert fs root %d", ret);
 		goto out;
 	}
 
 	tmp_root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(tmp_root)) {
-		test_msg("Couldn't allocate a fs root\n");
+		test_err("couldn't allocate a fs root");
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
@@ -518,11 +518,11 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	tmp_root->root_key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
-		test_msg("Couldn't insert fs root %d\n", ret);
+		test_err("couldn't insert fs root %d", ret);
 		goto out;
 	}
 
-	test_msg("Running qgroup tests\n");
+	test_msg("running qgroup tests\n");
 	ret = test_no_shared_qgroup(root, sectorsize, nodesize);
 	if (ret)
 		goto out;
-- 
2.16.2

