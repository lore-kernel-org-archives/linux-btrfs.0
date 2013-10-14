Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35346 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3JNRPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 13:15:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 473E47C068E
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 11:15:55 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id 1FhDQuQhWD2xs0XK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 11:15:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add a sanity test for a vacant extent at the front of a file
Date: Mon, 14 Oct 2013 13:15:52 -0400
Message-ID: <1381770952-1277-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_get_extent was not handling this case properly, add a test to make sure we
don't regress.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tests/inode-tests.c | 133 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 128 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 92416b3..ce9f9bb 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -86,6 +86,26 @@ static void insert_extent(struct btrfs_root *root, u64 start, u64 len,
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
 }
 
+static void insert_inode_item_key(struct btrfs_root *root)
+{
+	struct btrfs_path path;
+	struct extent_buffer *leaf = root->node;
+	struct btrfs_key key;
+	u32 value_len = 0;
+
+	memset(&path, 0, sizeof(path));
+
+	path.nodes[0] = leaf;
+	path.slots[0] = 0;
+
+	key.objectid = BTRFS_INODE_ITEM_KEY;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	setup_items_for_insert(root, &path, &key, &value_len, value_len,
+			       value_len + sizeof(struct btrfs_item), 1);
+}
+
 /*
  * Build the most complicated map of extents the earth has ever seen.  We want
  * this so we can test all of the corner cases of btrfs_get_extent.  Here is a
@@ -236,10 +256,6 @@ static noinline int test_btrfs_get_extent(void)
 	u64 offset;
 	int ret = -ENOMEM;
 
-	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
-	set_bit(EXTENT_FLAG_VACANCY, &vacancy_only);
-	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
-
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_msg("Couldn't allocate inode\n");
@@ -825,8 +841,115 @@ out:
 	return ret;
 }
 
+static int test_hole_first(void)
+{
+	struct inode *inode = NULL;
+	struct btrfs_root *root = NULL;
+	struct extent_map *em = NULL;
+	int ret = -ENOMEM;
+
+	inode = btrfs_new_test_inode();
+	if (!inode) {
+		test_msg("Couldn't allocate inode\n");
+		return ret;
+	}
+
+	BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
+	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	BTRFS_I(inode)->location.offset = 0;
+
+	root = btrfs_alloc_dummy_root();
+	if (IS_ERR(root)) {
+		test_msg("Couldn't allocate root\n");
+		goto out;
+	}
+
+	root->fs_info = alloc_dummy_fs_info();
+	if (!root->fs_info) {
+		test_msg("Couldn't allocate dummy fs info\n");
+		goto out;
+	}
+
+	root->node = alloc_dummy_extent_buffer(0, 4096);
+	if (!root->node) {
+		test_msg("Couldn't allocate dummy buffer\n");
+		goto out;
+	}
+
+	extent_buffer_get(root->node);
+	btrfs_set_header_nritems(root->node, 0);
+	btrfs_set_header_level(root->node, 0);
+	BTRFS_I(inode)->root = root;
+	ret = -EINVAL;
+
+	/*
+	 * Need a blank inode item here just so we don't confuse
+	 * btrfs_get_extent.
+	 */
+	insert_inode_item_key(root);
+	insert_extent(root, 4096, 4096, 4096, 0, 4096, 4096,
+		      BTRFS_FILE_EXTENT_REG, 0, 1);
+	em = btrfs_get_extent(inode, NULL, 0, 0, 8192, 0);
+	if (IS_ERR(em)) {
+		test_msg("Got an error when we shouldn't have\n");
+		goto out;
+	}
+	if (em->block_start != EXTENT_MAP_HOLE) {
+		test_msg("Expected a hole, got %Lu\n", em->block_start);
+		goto out;
+	}
+	if (em->start != 0 || em->len != 4096) {
+		test_msg("Unexpected extent wanted start 0 len 4096, got start "
+			 "%Lu len %Lu\n", em->start, em->len);
+		goto out;
+	}
+	if (em->flags != vacancy_only) {
+		test_msg("Wrong flags, wanted %lu, have %lu\n", vacancy_only,
+			 em->flags);
+		goto out;
+	}
+	free_extent_map(em);
+
+	em = btrfs_get_extent(inode, NULL, 0, 4096, 8192, 0);
+	if (IS_ERR(em)) {
+		test_msg("Got an error when we shouldn't have\n");
+		goto out;
+	}
+	if (em->block_start != 4096) {
+		test_msg("Expected a real extent, got %Lu\n", em->block_start);
+		goto out;
+	}
+	if (em->start != 4096 || em->len != 4096) {
+		test_msg("Unexpected extent wanted start 4096 len 4096, got "
+			 "start %Lu len %Lu\n", em->start, em->len);
+		goto out;
+	}
+	if (em->flags != 0) {
+		test_msg("Unexpected flags set, wanted 0 got %lu\n",
+			 em->flags);
+		goto out;
+	}
+	ret = 0;
+out:
+	if (!IS_ERR(em))
+		free_extent_map(em);
+	iput(inode);
+	free_dummy_root(root);
+	return ret;
+}
+
 int btrfs_test_inodes(void)
 {
+	int ret;
+
+	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
+	set_bit(EXTENT_FLAG_VACANCY, &vacancy_only);
+	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
+
 	test_msg("Running btrfs_get_extent tests\n");
-	return test_btrfs_get_extent();
+	ret = test_btrfs_get_extent();
+	if (ret)
+		return ret;
+	test_msg("Running hole first btrfs_get_extent test\n");
+	return test_hole_first();
 }
-- 
1.8.3.1

