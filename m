Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A035AC3F
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778399412; cv=none; b=eaGFuiVOEv7DmI74fPnK7B3wIxstOHSH38l2C94V4pvbc71uokFUfMUCk5YGYYP3nWlCUCn7N+iPDHYQtbJmE+sGvlkG5KVcETGszm6QnAlbFR34teIXwktdXoyFfbCIIzHa00JEoaCEYwhLT4tIVgScUHYktwIl7UrlYaobDuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778399412; c=relaxed/simple;
	bh=RwwAGlKxXZBb/P3ZjO3CvPHY1HS6oesfIgXb1dIhkeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zyem1HgancUPKSMQhqSA+LtoK4bHo8ZzLjSlTU1KS3cxl1XUv96M4Tu1fc6ux4UlMgv0lAcADZ+asiwDuUhHFoZ2ifYU63jc9lV+LDUVd8XveSvg9U26KytZXRN7kiF0/rzbX0l4DL1q6vIQ9wtFOY1K1iWjnJb16UH5TvYc+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8CS6jvq; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8CS6jvq"
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-c80291e6237so2281077a12.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 00:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778399409; x=1779004209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V/OEDvEYBKDAkuoJrrNS8/0alIlEJeeyuOcPwiOgWZ0=;
        b=M8CS6jvqTWwL/GWDLoX5H4x1a0QsDzFXUymnvHwqkoVSxj6j9XusfNjQ+/ojmJeKpi
         6styRmpd3pKFWiP4Ft8yTLyGhi2kptWYn/vZ10oLg7AtnILcL1+fEg2MH2684rXWvBdv
         Kwoo8WRKiX47NhQlT6L4mmYHYvhLjf0VzL9wXeWgux00jKRXwrimRkgEmiM4jhqr3zYA
         9UVszS06tUqlQDL1UeEMKrunZ9/kU8kbUf6vq1JzuHCf7aKMoG0plHahEHVL8VXgNLE3
         O6JcYEqxS6bkzWCStmKgUZXHdkB61Y13garJNYdmWUJs0oxxhZvk8CZO8cFjd/PDSj1B
         rCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778399409; x=1779004209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/OEDvEYBKDAkuoJrrNS8/0alIlEJeeyuOcPwiOgWZ0=;
        b=S8pNIAyAmax5fzLnGShzaLGgbIw2PYzf9UGxXT1Upg2KZ+YMlYXJ2DPK2OW8hHA1Tz
         5SEF1s6fLCEYe8TFK2gUE5IDRsopPYQaaW7RMLdusUL4Q9Xl0IPzXPBhyfeToOFKEf2V
         gChVC6o5L3Igo0QaOeJZx4iLeqmCF+A2AsPK8frgJDxM6HMVoUOzMN8NC4vydO8nfmmJ
         8OHJAXxIWcQk42vFVmQ1GQXNS9wd1D8Lp6nfYkDBsZwCXWMJq0I/pelx45UIbMiS+6xZ
         9F0KJCl42X5Zx+OZIDyEbj/8tzMokCZ2DFz8HexMjhSzWHfxcldNDBRGJ1yH3vFQpLIW
         EkXQ==
X-Gm-Message-State: AOJu0YyfVWk6jllSWvSun/My8hCeULMJjmjfxl1zdFh+qLhsBWhsIbo+
	ot4zbyIV6nPToUlNF9agtl0XQsHO4Pt2dtteDwaDUmRFyPqFJ3kUjb8U
X-Gm-Gg: Acq92OHCrb97sP9dM6M9bVVUUkcD8s63YSw8AOohliCeeUp9xysxat6mdEIHImsBJI6
	gggairOBuStHYs5nTrcoJWeJF93jVmG6jOBQN5izVyf9X7IBgcY5J3JvNmD0gCzMc++PXIIAZvf
	S+NAlUZzkp/OjuHTuBWDtdfcsDFWLe8Ep49xqgqnFI+rdxeqwbqFnFY4a17tCbj7e7FPYQe/2tP
	UeL/e8X59wiCdFEybQYoTct6SQ0pUziggYPiUkxxPq/CcO2o0qnDikcjnfAf1Qpxf/yuxWvLWYp
	86aPxfGbycR0/NCMbegUgDe4Y6n35Dznpy93dQs+2QcbZcfeEIE/2bWHHMwgl+t342fvDmCburo
	A52Q51MX08ulL0+MlT6j8qhfzy4haKOr69YgIR8zLjeeLC39FoJaKTRQoy5iNp0oGOW7BCNCl5w
	tpPK5DPBuY2705kGJQoOCZEJ3spilccAmj8TOJbV2iuIpTUmkCAvhF
X-Received: by 2002:a05:6a20:748a:b0:39b:a48e:6a77 with SMTP id adf61e73a8af0-3aa5ab62f7emr20742038637.37.1778399408962;
        Sun, 10 May 2026 00:50:08 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm5966541a12.17.2026.05.10.00.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 00:50:08 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] btrfs: free-space-tree: reject mismatched extent and bitmap items
Date: Sun, 10 May 2026 15:49:43 +0800
Message-Id: <20260510074943.2644334-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_load_free_space_tree() picks bitmap or extent mode from the
FREE_SPACE_INFO flags and then lets load_free_space_bitmaps() or
load_free_space_extents() walk the following records until the next info
item. Those walkers only verify the record type and range with ASSERT(),
so production builds can decode an EXTENT item as bitmap data or accept
a BITMAP item as a whole free extent.

Add a shared runtime check for each post-info key and call it from both
loaders before decoding the current record. Reject keys whose type does
not match the mode selected by FREE_SPACE_INFO and keys whose range falls
outside the block group with -EUCLEAN, instead of reaching
btrfs_free_space_test_bit() or btrfs_add_new_free_space() with an
unexpected record.

Sanitizer validation reported a fatal fault in extent_buffer_test_bit()
(fs/btrfs/extent_io.c:4313) through btrfs_free_space_test_bit()
(fs/btrfs/free-space-tree.c:518), reached from load_free_space_bitmaps()
(fs/btrfs/free-space-tree.c:1603) after an extent item was decoded as
bitmap data.

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
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 472b3060e5ac..e7fed8041eb1 100644
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
+	if (key->type != expected_type) {
+		btrfs_err(block_group->fs_info,
+			  "block group %llu has unexpected free space key type %u, expected %u",
+			  block_group->start, key->type, expected_type);
+		return -EUCLEAN;
+	}
+
+	if (key->objectid >= end || key->offset > end - key->objectid) {
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
+		if (ret)
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
+		if (ret)
+			return ret;
 
 		ret = btrfs_add_new_free_space(block_group, key.objectid,
 					       key.objectid + key.offset,
