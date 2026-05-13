Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE673C3450
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778672198; cv=none; b=FyuQ+OHzCXkLsrzAHGNC7gUKhWM76ANB1Xh7cRd8988wt9PNV8DOijfVEfKwwSFqst7xqtOTUsoEpTMRKHF9OECJez8oDhJPH85HgFhXk0grtyuFnjd7KbOwCyS8xSClJ2ly8lgNhF356xDESo46SN360APpDS5XXonaJpkSwZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778672198; c=relaxed/simple;
	bh=WMI6SX8+xZCJbOMEF3NcXDHs3XR+YsIVqh2TST2U26A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPpAju2c9Um6dtGBjCh0HOGcOwi29u9Z35TqP4lHavEzI5exVi3da5c8RjKsjThRuDFGDu6xLqoiyAnWWE4v86QmKnrlIba6RGMdC6I6qQGxkeY7fNaSh2kchy2N+3zGCu6hpyP5dlQzJCOtZeX9gehH6/t7Zz0zPDWgCPf8f5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtXj9EOn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtXj9EOn"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso46651475e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778672195; x=1779276995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOkHx16RNuN3vhaNJNrHgET9ecn8NhlzfITBtdnhrUU=;
        b=XtXj9EOn8Sra5lWoTdPxPnEmXIq3pGosJsAb4/Vl+mhIbkCMEvrxKAyHcuCXmDFKUw
         Of5k2zcyUS1oJBtQfPvQeeggPs90CyIbIXsTbCc8DehejXSJ8dtf/0xXSPwpoNJwr7Wo
         a2DUvVXzpXW40rEpR1gfm4Klbwhkqw7P/OLdh9rSM9ybGeT+je6E2RSUl5LFoT5AaYLG
         njU4VuNrOHCWNzRltgdSrGIAQ0LByQDXYXNadEqCZOfJs9GOUv2fGb0c/HTHhvXGXPxy
         gLBsnQPplUO+o5IGJw6rrIZPpoOWWvGLX6+qh+8jBBX32ZRC9Pln6UCJsOM3IPQkKxvG
         joHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778672195; x=1779276995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zOkHx16RNuN3vhaNJNrHgET9ecn8NhlzfITBtdnhrUU=;
        b=sCwZ3zmqhpg6zNNqKhbfbrRPisRhy3aRlgkUv2qyhtoM13fIthrk0zbX7CA45en4V+
         AlKxTHqg8KUye9ulGyNok83BtdxlV3Kh0Ky8T2WK1CsqHodbNuiEf8W/Skqm3CYbG4w9
         VnqlF2KqwBQpvVxnEK4RDRGTwr+A4K2SfXxUPXpEv1ZUikcNxcvPmya6fl97VDKn+qz9
         v8zpz2ZRWC6w/cU5nCO1VZxFv32M6pm5nYG00MXi6YtdcvC1jzTM+7I9UXI0/1DrmmVk
         Y8K4OgJ6ckWADULIclhXmMcVYECMGQUxdU85TTeYesz4nq+DWAoV3hzOCgMkZnCEF03c
         0Uuw==
X-Gm-Message-State: AOJu0YwJKYejmyf88AXi7zbZpOUjS3I3HbecHjUJ/YYKbvH90If0Nu8Q
	eWqX8XAQXJHeTk9nNFV4EHCGv5dXKCu04ier9A9SJO0gLg8W84CNaXz2pEKTnclt
X-Gm-Gg: Acq92OE0ofDU23KPR/wUHldBgfpfTZn+VJoURcie5i5j5XSiWFQEDOQwLLwOTmm9Klv
	B+qBCZXgDfpJRmidpSsR6tQBjh1zuo5MVes+5sagnSO0JxVOMAV8PiyUxwePi79JD4IHKuul9gN
	3cPfkl3vgoTsJ4uFt7M8TtNEI9RnLOemfWqzarWuKSJmL/9xxZCn8K30y8fcK6PeTQKRoHQC5jb
	mzX5u02sEVl4/IerzduYqQWvgV92+3OF99U/1nus4NC/EcJigvJYW2ply+x985qTByGBtE3pFK0
	yVGnm4stIF8wDiAU/9Ddiq0N8tKkicFTgJ6m47x6u9gOxAxK0j3tC5EHcOmmciAalkM5tRVd1Fz
	ZSSwU8WnQJxeyEOpu23UQ1SNtsd6uX5KdqIvhGfdDv5q+n/gxYahXpmCx9xdH8RrUjMjUzwAce4
	bftwp4UR2Oh4HQy55OYmjy5AD6JH5+Bp8NzmBbFgIZeYI=
X-Received: by 2002:a05:600c:811b:b0:489:2005:b36e with SMTP id 5b1f17b1804b1-48fc9a397a1mr39904085e9.19.1778672194427;
        Wed, 13 May 2026 04:36:34 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a66bfsm35435544f8f.4.2026.05.13.04.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 04:36:33 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Teng Liu <27rabbitlt@gmail.com>,
	dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com,
	linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: [PATCH v4] btrfs: validate data reloc tree file extent item members
Date: Wed, 13 May 2026 13:35:44 +0200
Message-ID: <20260513113553.213959-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427202822.278326-1-27rabbitlt@gmail.com>
References: <20260427202822.278326-1-27rabbitlt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
Changes in v4:
 - Split the check by which layer the invariant holds in. Reject
   compression/encryption/other_encoding != 0 in tree-checker (true
   on-disk invariant for the entire data reloc tree). Keep the offset
   check at the call site in get_new_location() (true only at the
   cluster-boundary keys it searches; partial-PREALLOC writeback
   legitimately produces non-zero offset at non-boundary keys, which
   is why the v3 single-rule approach was reverted).
 - Suggested by Qu Wenruo in reply to v3:
   https://lore.kernel.org/linux-btrfs/20260427202822.278326-1-27rabbitlt@gmail.com/

Changes in v3:
 - Moved the entire four-field check from get_new_location() into
   tree-checker's check_extent_data_item(). Replaced BUG_ON() with
   ASSERT() in get_new_location(). Merged as 7d0ee95979e9 and
   reverted by 1c034697fcaa due to false positives in btrfs/061 on
   arm64 64K pages.

Changes in v2:
 - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err()
   so the offending leaf is dumped to dmesg, per Qu's v1 review:
   https://lore.kernel.org/linux-btrfs/6c54901d-5e07-4c46-9553-997b28c93b86@suse.com/
 - Expand the changelog to argue why non-zero compression/encryption/
   other_encoding in the data reloc inode imply on-disk corruption
   rather than a kernel bug.

 fs/btrfs/relocation.c   | 22 ++++++++++++++++++----
 fs/btrfs/tree-checker.c | 27 +++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bdd..01977fa282db 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -814,6 +814,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 			    u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *leaf;
@@ -835,10 +836,23 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
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
index 1f15d0793a9c..8fc919dc08d0 100644
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

base-commit: 6bf684b8823552b99c86bf791b22f622934ee771
-- 
2.54.0

