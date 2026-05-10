Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F6A39F19C
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778426950; cv=none; b=lItCVbxIXrT3jjDGaYXnG616BTUDtSyFqkzyqNo3Ek40pWmexAHJzUwGxdewX+rjvGo9ehrv0Ed9D+SCPEfWms5he/j89rQNArU2E5xz0zws5gsKxS3wsNYBzdV8+bKizXvjQPD9tX5WSovjbTy3pa0i4gGJRzmTuRBoYtnRh6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778426950; c=relaxed/simple;
	bh=RdWkJsGkjIH/VTFznyVcbfyK21hwEYLnJ7cnJDxyEdk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LKTmYIyy4MDDtZqCg+RAeOMw8hmimPdw3DkyIAF5fhKbqNqIGVIlwA6LmDM8HMNk0eNfKtGTuKkOIo2rL5xuJl7+pTT8j2XWbkWDhhWY+yFAFbnxMgqdxxxaHkJMPbfD+jgHcmlL5tKezKJKEZAXlMlQN1Qkkz0JKERZVqf87iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZlnGstX; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZlnGstX"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-367d88b9940so596171a91.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778426947; x=1779031747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RJF0QXlUZgra5IcAiUicc3AV5dy6J9m951SNRsFByt0=;
        b=dZlnGstXfozb/tlNmDv7g3JCU42fU7sz9raAW3myAGLgAPg+HUjwyk8DX2kwJnNtfE
         zQAvO8RrPvNwNvGoQbU8ip2csQx8v6SnrBf+hlZH2kXeVijbrxnQFv3rtkRgjTcLqW6g
         tbnKGuyVOjM96vuTR4fotJew6koTBpafEil2fCAy1uP9BtdH6/DJaA/5LV+LfMZgd4Jr
         748X9Ne1PYYhZJDBXTx6+tNdU6jwtmDvvKFHRvl98stRv0nB0Op19IAMSWKU0r1o+wlo
         GFK3aa1j6nwOuM3sXaxf+94Y0NCt+mWZiFrMotdJBPTAuwC+iyfPLXAPEdKCiIBkjlJh
         BXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778426947; x=1779031747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJF0QXlUZgra5IcAiUicc3AV5dy6J9m951SNRsFByt0=;
        b=ndER4NOkHPusqHfjWJQm6niANyKFRx4e2Xknh1i/cL3eYpw4up4inz5ZXdN2RUyInb
         hlbVNJVhu3dhfDqAMnZfuDyxXPV5Gu1yByvIrn1WDNhqbpl6srfjn5FjD4+D4yJYsrJB
         VJ2qavfZO/QB8Cap5/SdLEqLMdv6p/QYZU1ETbK7VKvXRdb81as/HkkepML8eL0roJwY
         vSBCQAtCJHiQdoOj6M3njLcgXnDf6Gtnw+CFF7Dw+W/NdgmRvBdEAacfDDke7PZPXyWy
         IuK1TMJngcqS8ZMeSNZJcUuo6ZfE0d4XDelg8q5dpfrBdmc71kVQ2KfIRcLTEMlC4gET
         0rVw==
X-Gm-Message-State: AOJu0Yz87sdPUgr3UyqzhWi9EywQ4A/qSQs8KWEozpiriV7X+S7ZDf2C
	xp/aqz7RmYCT7AocZiOLqU39NiDiW94SIc9aUiTcpC+11z5P0MMAOJHi
X-Gm-Gg: Acq92OHK/VfUg5kJcNOMgLUg7nkBRtmNagpQf17v0EtSZ/yHLKAchHwEc3UvgiBFwCL
	1ixGRF9utpTtceSR8PU5PM9CzHStI9FBVLs/m1YPcMxpfoZKv47sFwhUgtz4HG4uT0bWYewobke
	xlXjyj5O5k1h4TnQv4HZYzG1K/45X2FNUBe80tAaHi2O7cP1/g3yPUZiW6pF6TeaDdVE8U3BsBY
	wJdwoK3nAvbrmVyi+c5vOE+kv/iQnLvWFo809Nhy0C65RwXP3WQtT6YkwD5zXE7ODnf4YLLifD3
	sFfhMg1gWKf3UL2pBlLGb8kPa3nOmS+5RMPjPpFf7fK0WlyJpCaS6yqA8VmGX+1wmwidJAJEBU6
	4bWgASGxc7J4f+oXD38zEGO8esJZmP9DMZSJWCQxdhPnTCczEbTUp74cbBUjGR5wlAZLQ3ApWCp
	EeFU4bZyrSB04OljdZ4S2k1rTCERV5CLqlgfxPyGCkkg==
X-Received: by 2002:a17:90b:3c8c:b0:35f:be09:1a2b with SMTP id 98e67ed59e1d1-3664c91ec9bmr11455335a91.10.1778426946952;
        Sun, 10 May 2026 08:29:06 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367be29a01esm2468906a91.2.2026.05.10.08.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 08:29:06 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and bitmap items
Date: Sun, 10 May 2026 23:28:48 +0800
Message-Id: <20260510152848.3844894-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_load_free_space_tree() reads FREE_SPACE_INFO once and then chooses
the bitmap or extent loader for all following free-space records until the
next FREE_SPACE_INFO item. Those loaders currently enforce the selected
record type only with ASSERT().

On production builds without CONFIG_BTRFS_ASSERT, a malformed free-space
tree can therefore be decoded in the wrong mode. An EXTENT item can reach
btrfs_free_space_test_bit() as bitmap data, while a BITMAP item can be
added as a full free extent. The latter corrupts the in-memory free-space
cache and the former can read beyond the item payload.

Validate every post-info key before decoding it. Reject keys whose type
does not match the mode selected by FREE_SPACE_INFO, and reject keys
whose range extends past the block group, returning -EUCLEAN instead of
feeding the wrong record type to the bitmap or extent decoder.

Also reject zero-length FREE_SPACE_EXTENT items in tree-checker, matching
the existing FREE_SPACE_BITMAP zero-length check. This keeps the loader
range check simple and prevents a zero-length extent item from being a
valid on-disk free-space record.

Changes since v2:
- Regenerate the mail-ready patch without the nested mbox wrapper.
- No code changes beyond the v2 fix.

Sanitizer validation reported:
general protection fault
Call trace:
  assert_eb_folio_uptodate() (fs/btrfs/extent_io.c:4134)
  extent_buffer_test_bit() (?:?)
  btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  __entry_text_end() (?:?)
  __asan_memcpy() (mm/kasan/shadow.c:103)
  read_extent_buffer() (?:?)
  load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1548)
  btrfs_get_32() (fs/btrfs/free-space-tree.c:?)
  btrfs_set_16() (fs/btrfs/free-space-tree.c:?)
  kmem_cache_alloc_noprof() (?:?)
  btrfs_load_free_space_tree() (fs/btrfs/free-space-tree.c:1685)
  load_free_space_tree_for_test() (?:?)
  rcu_disable_urgency_upon_qs() (kernel/rcu/tree.c:721)
  vprintk_emit() (?:?)
  __up_write() (kernel/locking/rwsem.c:1401)
  clone_commit_root_for_test() (?:?)
  test_extent_as_bitmap_mode_mismatch() (?:?)
  kmem_cache_free() (?:?)
  btrfs_free_path() (fs/btrfs/free-space-tree.c:1449)
  __add_block_group_free_space() (fs/btrfs/free-space-tree.c:20)
  run_test() (?:?)
  do_raw_spin_unlock() (?:?)
  btrfs_test_free_space_tree() (fs/btrfs/tests/free-space-tree-tests.c:547)
  btrfs_test_qgroups() (fs/btrfs/tests/qgroup-tests.c:462)
  btrfs_run_sanity_tests() (fs/btrfs/free-space-tree.c:?)
  init_btrfs_fs() (fs/btrfs/super.c:2690)
  do_one_initcall() (init/main.c:1382)
  __kasan_kmalloc() (?:?)
  rcu_is_watching() (?:?)
  do_initcalls() (init/main.c:1457)
  kernel_init_freeable() (init/main.c:1674)
  kernel_init() (init/main.c:1584)
  ret_from_fork() (?:?)
  __switch_to() (?:?)
  ret_from_fork_asm() (?:?)

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
fs/btrfs/free-space-tree.c | 37 ++++++++++++++++++++++++++++++++-----
 fs/btrfs/tree-checker.c    |  4 ++++
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 472b3060e5ac..c1af70761919 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1545,6 +1545,30 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static int validate_free_space_key(struct btrfs_block_group *block_group,
+				   const struct btrfs_key *key,
+				   u8 expected_type)
+{
+	const u64 end = btrfs_block_group_end(block_group);
+
+	if (unlikely(key->type != expected_type)) {
+		btrfs_err(block_group->fs_info,
+			  "block group %llu has unexpected free space key type %u, expected %u",
+			  block_group->start, key->type, expected_type);
+		return -EUCLEAN;
+	}
+
+	if (unlikely(key->objectid + key->offset > end)) {
+		btrfs_err(block_group->fs_info,
+			  "block group %llu has invalid free space key (%llu %u %llu)",
+			  block_group->start, key->objectid, key->type,
+			  key->offset);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 				   struct btrfs_path *path,
 				   u32 expected_extent_count)
@@ -1576,8 +1600,10 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 		if (key.type == BTRFS_FREE_SPACE_INFO_KEY)
 			break;
 
-		ASSERT(key.type == BTRFS_FREE_SPACE_BITMAP_KEY);
-		ASSERT(key.objectid < end && key.objectid + key.offset <= end);
+		ret = validate_free_space_key(block_group, &key,
+					      BTRFS_FREE_SPACE_BITMAP_KEY);
+		if (unlikely(ret))
+			return ret;
 
 		offset = key.objectid;
 		while (offset < key.objectid + key.offset) {
@@ -1633,7 +1659,6 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	const u64 end = btrfs_block_group_end(block_group);
 	u64 total_found = 0;
 	u32 extent_count = 0;
 	int ret;
@@ -1654,8 +1679,10 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 		if (key.type == BTRFS_FREE_SPACE_INFO_KEY)
 			break;
 
-		ASSERT(key.type == BTRFS_FREE_SPACE_EXTENT_KEY);
-		ASSERT(key.objectid < end && key.objectid + key.offset <= end);
+		ret = validate_free_space_key(block_group, &key,
+					      BTRFS_FREE_SPACE_EXTENT_KEY);
+		if (unlikely(ret))
+			return ret;
 
 		ret = btrfs_add_new_free_space(block_group, key.objectid,
 					       key.objectid + key.offset,
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1f15d0793a9c..ec24ffb6641d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2129,6 +2129,10 @@ static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key
 			    blocksize, BTRFS_KEY_FMT_VALUE(key));
 		return -EUCLEAN;
 	}
+	if (unlikely(key->offset == 0)) {
+		generic_err(leaf, slot, "free space extent length is 0");
+		return -EUCLEAN;
+	}
 	if (unlikely(btrfs_item_size(leaf, slot) != 0)) {
 		generic_err(leaf, slot,
 			    "invalid item size for free space info, has %u expect 0",
-- 
2.43.0
