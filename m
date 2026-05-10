Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C4B39C645
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424154; cv=none; b=rg+azXJibmdaIGODunNrxw7GJy0TpG7B5tWOkrGogHYvSq7OSxYNPFT0xXGWjR8mKtvXoc1mjmYUicAm2MM9kQfv422/OJgdiD2P58l9d7OywqaB+oilv63aZpsp3M0eb9Ma9TXPV2lHdHnaMOpuaFMQ5dq2Vm8w6T7xGyHz7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424154; c=relaxed/simple;
	bh=D7dudmE3roq/f9yJbY8WAPjFG5ZF+HGvlmNu9Tczzcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o7Pdw08WUhnRX52c5O2MU0ZgH3bQQU/gtyp1bgc18NWHviJ9p9dtYb0D9Jay+7UOiN/Z/7xnTujBFPaXcgr5GTd3dVMfW1+MCtMGzpGBsbn2LD+dYBFbbP6ASIO/7Jh9EiY3zhyUx877j5f5puzHh565gCkcDpsFiKLRdgYL2tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j71ZS6EP; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j71ZS6EP"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-83d31ac4017so930182b3a.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778424153; x=1779028953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=szAH80tmB7v8Z3h7EPN8yh+RK34xyrH6Frin9lhSfCA=;
        b=j71ZS6EP+DEj9I+mfu9LLbpAfbsyIqUepC48PrLlQ17RLYg+N4USzpW0IJ9giI03Z5
         mbnfoSACpHrVu++f/8M7PF4Uy3k0x948lqVpu7/6QFLielZ6NZDhP/cVUvtaxvbifHmX
         SFRSrQf9PUOlvmhXun278e60A0bvCo2DnANY9JUSCf3vDRzjPMOGRdwCGbkEndhcU1KC
         IDsp2fRT72Dcd+Jmz6O8UWykDeH80mdvnkFjm9Y1mMfsf/QqjzitQBLE4gQrHTd9OdzA
         6n5s3iuTQzuw9m+ZPat/3di8jY8raLIO9+DYVU3FmFQLcAq6Az2fV879VhwGDF+b6csC
         ZK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778424153; x=1779028953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=szAH80tmB7v8Z3h7EPN8yh+RK34xyrH6Frin9lhSfCA=;
        b=kvtWYrjpy/VZBlBYbIKDLb+/vFhhTuTpQmIVU+CjFrfkgGa37bu6yVASZxSQSd3EL+
         nmypPxQMWl00nbNk4X1vmBaCextdECKtBdmX7cSAg61uepKknPu8qaM/aVXVVZ9GiWWM
         ZhNRjm7nhkfyREPaNcqIkjaOocOr5csIG+L+Ld0CGyLpNLzHMFHgzWFXC1fLUiMFliaJ
         2g0NI6svqszcQFxH7TooX73VwGm+gf2MvHI+0P610UQMRhamXPFqTUbfKRfo98d/kbPU
         5yod1/uB/KwyvsjtDFAW3AAqe2tIq9DMgyYIOf9IxFS8fvbR/7UTzvOGxt4TT70N6RA5
         6eLg==
X-Gm-Message-State: AOJu0YyRhPcsPxHxWuwCmk0g9z8Aesac224PW5NqBgHi1MSgSKaxWYWB
	/ssyeOUBWWMdUDrSQoHSHJn+/tTXHQ3Vd7xIAO1xozFpn+g/k/UfPr8U
X-Gm-Gg: Acq92OF8rbhamKaIPVpBrBRNFHNV2EkUS6kaWw+mYjX2Fiu8yd/jzk04xVApyoSZeOK
	9s1Dx1y+5/JxFZwXNOSnZOnLqo4ChVgK6rDQcG+k/Hcn0PI69i+nGDW/GRb1nArRxLQfz46t3o7
	s2tEpdGY7Qx4k+79IV7TnUMeAlZUUfuyf760Cee+6piiy+1OSroN9GxKOlVATUCr6owsMkSZqhE
	NVRnZNN6HkOLKRaE0uVaNQLOrxGy1rlnUAFaouUKhxIntvrhFgVbA/z/rwUPSsj/veXPR3AjfEz
	wzHoWKlw5Xeuq1RLurNKKGAB42p2AxZzYJEnTKhrmEWUDlCD4ySJywGxNv1a/pnufBXM4/P9AWI
	1pZUjzkX9BdqcBy5YpJ0O/WQttoQdvuISOSDGamREuP+dJe/M+TkbN4cHdVVepSnoUo2eiTTKAp
	FnBXHQVrSjHN8mubionVrLqNzHYbWDXtU=
X-Received: by 2002:a05:6a00:414f:b0:824:9bc5:e946 with SMTP id d2e1a72fcca58-83a5e34fe53mr19203765b3a.46.1778424152465;
        Sun, 10 May 2026 07:42:32 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f111sm17286281b3a.4.2026.05.10.07.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 07:42:32 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2] btrfs: free-space-tree: reject mismatched extent and bitmap items
Date: Sun, 10 May 2026 22:42:11 +0800
Message-Id: <20260510144211.3722703-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260510074943.2644334-1-rollkingzzc@gmail.com>
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
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

Sanitizer validation reported:
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
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
From ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7 Mon Sep 17 00:00:00 2001
Message-ID: <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
In-Reply-To: <20260510074943.2644334-1-rollkingzzc@gmail.com>
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
From: Zhang Cen <rollkingzzc@gmail.com>
Date: Sun, 10 May 2026 16:51:00 +0800
Subject: [PATCH v2] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: Chris Mason <clm@fb.com>,
    David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    Qu Wenruo <wqu@suse.com>,
    zerocling0077@gmail.com,
    2045gemini@gmail.com,
    Zhang Cen <rollkingzzc@gmail.com>

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

A malformed extent-as-bitmap record was observed as a KASAN fault in
extent_buffer_test_bit() (fs/btrfs/extent_io.c:4313), reached through
btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518) from
load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1603).

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
Changes since v1:
- Use unlikely() on validate_free_space_key() failure checks.
- Replace the loader range check with key->objectid + key->offset > end.
- Reject zero-length free-space extent items in tree-checker.

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
