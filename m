Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19401378D7D
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778425436; cv=none; b=rBFY/y+Kkmyijrc6mev4rYXa1O3x2ssP91bna3uy68Pzvjc0dmJE23OcsFNSU+pAnMnyZYdpMwA4nfqyyxQ4se3MUMBfHo11wL0BNQF+TnKsdxhYTvPLIbZa+Bmd+/cX9KB4ijkPPl02mKVc2gJeWLKmmMxfKEZhEZwSps5fYwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778425436; c=relaxed/simple;
	bh=7CxR0eUflOq46ACVuemq9Lf6Wi+CSUTJFhcekhb1kWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=htN0lnI8JDf4lZz+ENedJbzamyE3TYBQWACdUKVpM1/rtOmt9WhFVQAyrPF4RBtNvJ4WE1s9XDl7LtFoARPT6Xna+UyafCDTX+QfNeDmh7G9qzv5C7AQc/ToLLKEdlFcnOTif54Ihp65uJuXFSOEFLajk9REQk7sT2Krh87RXI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgcpkja6; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgcpkja6"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-8383fb7143aso1588294b3a.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778425434; x=1779030234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6Hm19EJtwD21Da5UzL5z03jX64rB2SIao+D2V64mV8=;
        b=kgcpkja66ohOb+3tZX1AoLJkVpgCGd+tiuB3olkfFfx+7cLFUTlFGJDsJeJQGJACQ2
         xd2qM30d1ao0sB9FdXS+sc0PsVqYjeoXttpOmmdstO8MOdAKzaUNQte2Vmw2b6BlPlUj
         vxknq+n6Iw9uryrfD53MeZn919zz4RuRipOqc5v+LOSfbCqsYqSOV42qzxmAJ21HDrxG
         B8tLpVE+cq9AtEvWVgCjUoaW2x9xoF/UiQlaTMGED4iTxviW1SBKN9hFl6WdVP0MF7F2
         78Akg6ZABc1d84XlLVa3WDzTuxP8bMgGJlJaKUJQmCOzQMr5PznyWdAeKJjeuLfjkgmr
         885Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778425434; x=1779030234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S6Hm19EJtwD21Da5UzL5z03jX64rB2SIao+D2V64mV8=;
        b=XFP3Hfe8A8uHEiN1sv54vBZMyxkGk6ji4Ua2E0AOvp8k/+YL2IIZaE06g+s/u3hOlD
         Rraoa3hGq7kgFBFYw+b7cveMLGzCYfzhIIrdq58mfpeoBtN4IZ1KeCMA55uzvB+prgTZ
         ghVpUJGa1Y8cKabuYmFb467Af7rULfCU22dz8TUqYFPUJU1thk2dcxqTqrEQOcNukdHL
         6R4obPe3fd1N8arP5vE/KAlsGLty8CKfOE3yxIk9phV6PrK8g+MgnRAL8uehkBAIy0b3
         7p1wd2UWiGTdaTTLQqAqluva2gR/tnh48HHZ5zSwtBzYZmTQAMMluhvCS1cOlXgBNFvV
         rjZA==
X-Gm-Message-State: AOJu0Yz8EWPhk40U0v5XTxWp1MUsmniyMIMtGTTNbwKKt5t4sR/HqCrJ
	dNcHHsY5ckyvGrcF33MzC9r3ZNAJ8VRYzYGbpXB5YK2FIZK4oC4rD4YU
X-Gm-Gg: Acq92OFMUuS86HtsMddu68aXN7rcoV608nzmIjzjHaRrlqICFbyXLQpQrBZ2SH8uKbv
	JVTQUUd8Gpo+gFGHR1lrZS5dJ64VC0M5+oIcWtrt8X7Tl/fQjUB17J/7oGEtdq0WkyTglqO9odz
	TGIcwO19BItW7/rZbpx2BdjSzTiStLU054THuQdFDuVGgb3Fzt2UXJND94wf+VtiTSZ9ocHHaT0
	nFaPB7UgYSTPFj6yJ8YaOEucrwo8R/jviPM2ruw+yfyhgpjYnFhoChVpTi/zAP9eUWIgSmxfH58
	z+KLKcYZz5hOk8nXAtnOLinropvK3Erx9y6wNR0rBpyGLvxBJUWgCJmrKJ6XGJjTVkLA9rwLyXA
	PPwVHUpE8qAmWigjel9JdnfRpwfK3JMMXFI+34Lj0+PjCJ5XH5UCUVlqNSMxTP8xzbYeUwv02lW
	Tj7S0m19OvUsnis5WgmXuGZGwCPRSuSkg0WaKDviH7sw==
X-Received: by 2002:a05:6a00:4c08:b0:83c:5e:f647 with SMTP id d2e1a72fcca58-83e3b2d32b4mr5582876b3a.29.1778425434382;
        Sun, 10 May 2026 08:03:54 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c7ba9sm17769734b3a.35.2026.05.10.08.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 08:03:53 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Zhang Cen <rollkingzzc@gmail.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and bitmap items
Date: Sun, 10 May 2026 23:03:22 +0800
Message-Id: <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
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

A malformed extent-as-bitmap record was observed as a KASAN fault in
extent_buffer_test_bit() (fs/btrfs/extent_io.c:4313), reached through
btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518) from
load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1603).

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
Changes since v2:
- Regenerate the mail-ready patch without the nested mbox wrapper.
- No code changes beyond the v2 fix.

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
