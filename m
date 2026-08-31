Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F18481652;
	Mon, 31 Aug 2026 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183476; cv=none; b=FWdgKBfwo5rAyipr5KJpJdcThyNgIpo0NgmwBtHImtatHHUwHn+Zz4Jq6c+SGjO7YBgEPxGW6GKRiNtQOg2uEqz3+DxuC1PACYAatOdxCPyLaQiTJwGkRpuiCwMdwjFKdvDuzk07kn7jqMiclTITgzqh9rkFnrDS6KLV0Nd2cD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183476; c=relaxed/simple;
	bh=PXRh4kIt5FHKAyKEbfsJnv/uPZcSsPdmMdKL2m1m6Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkTn49HXp+fP9M/mHDHmYgeDEfqJl9KKxZzoBuWjKOhpuapTO8oE6QC1pt/xWlV7QUYG3tW/clVIZ93nI4LIiRXJ+9PHTPTgaH6KAPCZjg+fp8pxrESaWtrrUn5FjlNGudud37c2L4S85lOwp9IV4XG5NiiTzzBYK0jSD3rwV7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be7V1EQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be7V1EQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6642E1F00A3F;
	Mon, 31 Aug 2026 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183474;
	bh=w8AgcJcC28d8usKmvG/1RQt+YxSUGWMZ4Yhm/hTZhb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=be7V1EQiwSbslW4mGI2dArZZQcoX1cm+G1eYTs6hOn7KUIuzSwExLOsxvkwxyIDJr
	 2Hm2xiI+bkLF/PTarCsIyhXFN41bdIN7/LMB8x2oJPXMFspkm9orfKcHW8jlPObdYO
	 jJfk7h5KOU1gUEn7GaBv+tqgAwfRln3z39HaIiiINGH4ww2mzUucVlZt0vTneX9xdI
	 8pCI3gfJmNkydJHdBb0GrgiBEWXZ+DX+k4tzNFBLHMPmrxBg3paKz9r09+laWBfaWs
	 E/43bDQeq9H9Li5dQEzruSRKg5hHMOJBibRkOgMZpIqBlHfoIXr6jzF2u1HhAopAPi
	 Sr3hpl2FhDBeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Teng Liu <27rabbitlt@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: validate data reloc tree file extent item members
Date: Mon, 31 Aug 2026 09:22:26 -0400
Message-ID: <20260831133314.4125787-118-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Teng Liu <27rabbitlt@gmail.com>

[ Upstream commit a6908f88c9da9778957a07ac568aa643124278a8 ]

get_new_location() uses BUG_ON() to crash the kernel if the file extent
item it looks up has any of offset, compression, encryption, or
other_encoding set non-zero. The data reloc inode is only written by
relocation's own paths and the four fields are always 0 in what the
kernel writes:

  - insert_prealloc_file_extent() memsets the stack item to zero and
    only fills in type, disk_bytenr, disk_num_bytes and num_bytes, so
    offset/compression/encryption/other_encoding stay 0.
  - insert_ordered_extent_file_extent() copies oe->compress_type into
    the file extent's compression field, but the data reloc inode is
    created with BTRFS_INODE_NOCOMPRESS so compress_type is always 0;
    encryption and other_encoding are reserved-and-zero in btrfs.

A non-zero value here means the leaf decoded from disk does not match
what the kernel wrote, i.e. on-disk corruption. A malformed image
reaches this code via balance and panics the kernel.

A previous attempt to enforce all four constraints in tree-checker's
check_extent_data_item() was merged as commit 7d0ee95979e9 ("btrfs:
validate data reloc tree file extent item members in tree-checker")
and then reverted by commit 1c034697fcaa after btrfs/061 produced
false positives on arm64 with 64K pages. The reason: relocation
writeback legitimately produces REG file_extent_items with offset != 0
in the data reloc tree. When an ordered extent covers only the back
portion of an underlying PREALLOC (num_bytes < ram_bytes on the input
file_extent), insert_ordered_extent_file_extent() inserts a REG with

  offset    = oe->offset
  num_bytes = oe->num_bytes
  ram_bytes preserved from the original PREALLOC,

and this item can reach disk if a transaction commit fires while it
is present in the leaf.

The four fields belong in different layers:

  - compression, encryption and other_encoding are universal
    invariants for every item in the data reloc tree, regardless of
    cluster geometry. Enforce them in tree-checker's
    check_extent_data_item() so a corrupt leaf is rejected at read
    time.

  - offset is only an invariant at the cluster-boundary keys that
    get_new_location() searches (the key is computed as
    src_disk_bytenr - reloc_block_group_start). Partial-PREALLOC
    writebacks legitimately place REG items at non-boundary keys with
    offset != 0; tree-checker cannot reject these. The cluster-
    boundary item is always written by either
    insert_prealloc_file_extent() (offset=0 by memset) or by the
    front portion of a partial writeback (offset=0 by construction),
    so a non-zero offset there is corruption.

Enforce the universal invariants in check_extent_data_item() with a
file_extent_err() rejection. Convert the BUG_ON() in
get_new_location() to a -EUCLEAN return paired with btrfs_print_leaf()
and btrfs_err() so the offending leaf is logged. The caller in
replace_file_extents() already handles non-zero returns from
get_new_location() by breaking out of the loop without aborting the
transaction.

Suggested-by: Qu Wenruo <wqu@suse.com>
Suggested-by: David Sterba <dsterba@suse.com>
Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished with no matches — expected, since
this tree is **v6.18.44** and commit `a6908f88c9da` isn’t on it yet.
Subject grep and related-commit searches also came up empty, which fits:
the earlier mainline-only fix/revert pair (`7d0ee95979e9` /
`1c034697fcaa`) never landed in 6.18.y.

That doesn’t change the earlier conclusion: this is a syzbot-reported
kernel panic fix (`BUG_ON()` → `-EUCLEAN`), it applies cleanly, and it
should be backported to this tree.

**YES**

 fs/btrfs/relocation.c   | 22 ++++++++++++++++++----
 fs/btrfs/tree-checker.c | 27 +++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 80e5de6736e82..f1104fa6efb3f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -822,6 +822,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 			    u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *leaf;
@@ -843,10 +844,23 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
-	       btrfs_file_extent_compression(leaf, fi) ||
-	       btrfs_file_extent_encryption(leaf, fi) ||
-	       btrfs_file_extent_other_encoding(leaf, fi));
+	/*
+	 * The cluster-boundary key searched above is always written by
+	 * relocation with offset 0: either by insert_prealloc_file_extent()
+	 * (memsets the stack item to 0) or by the front portion of a partial
+	 * writeback (offset=0 by construction). A non-zero value here means
+	 * the on-disk leaf does not match what relocation wrote, i.e.
+	 * corruption. The other encoding fields are caught earlier by
+	 * tree-checker's check_extent_data_item().
+	 */
+	if (unlikely(btrfs_file_extent_offset(leaf, fi))) {
+		btrfs_print_leaf(leaf);
+		btrfs_err(fs_info,
+"unexpected non-zero offset in file extent item for data reloc inode %llu key offset %llu offset %llu",
+			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr,
+			  btrfs_file_extent_offset(leaf, fi));
+		return -EUCLEAN;
+	}
 
 	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
 		return -EINVAL;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 97be0c1ed22f7..c7e0e5fb6402d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -296,6 +296,33 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
+	/*
+	 * For the data reloc tree, file extent items are written by
+	 * relocation's own paths. The data reloc inode is created with
+	 * BTRFS_INODE_NOCOMPRESS, so insert_ordered_extent_file_extent()
+	 * always leaves the compression field at 0. Encryption and
+	 * other_encoding are reserved-and-zero in btrfs. A non-zero value
+	 * for any of these means the leaf decoded from disk does not match
+	 * what the kernel wrote, i.e. on-disk corruption.
+	 *
+	 * The file_extent_item's offset field is NOT a universal invariant
+	 * here: partial-PREALLOC writebacks legitimately produce REG items
+	 * with non-zero offset at non-boundary keys. The offset check is
+	 * performed at the call site in get_new_location(), which only
+	 * inspects cluster-boundary keys where offset is always 0.
+	 */
+	if (unlikely(btrfs_header_owner(leaf) == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		     (btrfs_file_extent_compression(leaf, fi) ||
+		      btrfs_file_extent_encryption(leaf, fi) ||
+		      btrfs_file_extent_other_encoding(leaf, fi)))) {
+		file_extent_err(leaf, slot,
+"invalid encoding fields for data reloc tree, compression=%u encryption=%u other_encoding=%u",
+				btrfs_file_extent_compression(leaf, fi),
+				btrfs_file_extent_encryption(leaf, fi),
+				btrfs_file_extent_other_encoding(leaf, fi));
+		return -EUCLEAN;
+	}
+
 	/* Regular or preallocated extent has fixed item size */
 	if (unlikely(item_size != sizeof(*fi))) {
 		file_extent_err(leaf, slot,
-- 
2.53.0

