Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB2E398911
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424153; cv=none; b=lnaDerTkV90qPYGpkEmkv7p4NZwn6drU+fBCoUa1kfxo3+fHriaE+aWG9eWACbjRh5C2/Ex17QsOknmS2/pqkGj8bOQp2jB6vGZMKffUgZCo9y8CqgwjhYx3bBOjkjjvFcGnN/nykYhrl5DmeEkQir5RiAu6LqkiwA1LulAhSFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424153; c=relaxed/simple;
	bh=DhoOitcLBWoA9Uu8j0FiaM95vmMtVwbo5o9qniSY9ZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XKsY+dcJHDgAi7zCJolL6psawjKR/4coQXOUa8LRvyeCocbtWXmkyeRUtB9f0IKQEXyJkqOfOjPWMpQ80XZ3cQhjBzZ+1txv08BHKYyW150ZwHeIFvb5Hvto3LgIex2jK/ioe0eADADJDRu0nTEbYZ2DZfXqAxOHEciQ5dQiDqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mjHvE8SF; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjHvE8SF"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2bc85eda6b6so3560015ad.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778424151; x=1779028951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+0h2sLIoGSF78icSGDkbrHibSA3VKa3ta7OX8ujdII=;
        b=mjHvE8SF750BLW8+cCLCkJ7JfNSe37uDxgjfMDmChL9nbrbV+Bd1an3ONhtQdjJZMz
         IzYQ0KQt2tBBKcIktdPnGE/Xi29OzB3QvKblLqRF1XWBN1BOd3z3wBFO61aup+PTgCf/
         fFCYelGvoLfa5TFFknUdTdmYxwMrVw5E1QHrgha5CXCrLpWc3gThX9vWZoLbQsv86QMo
         tq1StkhjPbVH9CyCE2dpP1Vm0rtY8Xw7fXaoXjgAmpqE2vi/eZ2yf0QzvaP97JxH+aAW
         3qGXZP4GQ3fTB51UbBuk1bUDonGOFvWORX+alVkfwaKme73sf01CZSDwIcRB1mQ/GCFM
         BDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778424151; x=1779028951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b+0h2sLIoGSF78icSGDkbrHibSA3VKa3ta7OX8ujdII=;
        b=cDgI7I+emRSVTsUKy6EStYViQGyRMnHXpqQJ085ty4Pf+/4s2F6YloM443ATu/Rdr+
         CaY641IV/0CNDvm+l6dqFzR4gHFPBIBcsY7NuBThWHtDmlsKBJpJHV5L6YTvlmeM1BrK
         1KU07RWQDnHTOD/BbLBApoXgEwcf5gkp1JMZ6kibsxoGnKsvB7vWicBMLUZd6GI6eLd3
         DT/QkuF7TRAmT6jgcPIBfCAAyCRi7960KD+KvsVY4QEIb8nYsICKKVX8Ju45eqx2XcbY
         yTeyXTw/FTb9LY8BlymimH6Y2e6XNtngi619x1FfkM300T43cLFdn/shJiIN8wenPlWR
         /bsA==
X-Gm-Message-State: AOJu0Yz9dJQZ2QRp3NhaH8edkP+fFZEorW7dla3mW7DMWYWLxIPlOVvY
	W9GQchmRWmRUQNKQwqbK933pAZ6M55YePDfCnVfVE7MSu9LiO3ULICsM
X-Gm-Gg: Acq92OHAWshxpGRP6BpIyap1lVyvsWJT+733iWbxxOUHCTliUotDuMZJAeqcE2clfn0
	f0WtXZXxlg8URxILw+DEEgHJFby/PbPII2xq6n9On6wSb0waMtRNTJsxtpjX2DmvZuo4qQmM+A9
	rpzy77wE5dv5pzpm1trO9gFR5Qm06XvlVuz4Ve61FSZxE9omHu7/PvADt7AbVS+QQS9UA2xivnb
	jRbuvPkr94PdofsTGAXQbe15YcSaJ11v9kWc2uXpF0USVH08Io52wxDf1ROn285qKmI6IhRaJup
	9rGYgmxfdHZlhE98WDseZWWZxLQxPHqM1RA5zJ1JiKlk0JSTALMK7oFyxg7Culo0o1ei3KGwYhv
	iMKT0YXoTm028CV68aV+OI/Ry3nddbQ7cGkRtYZXwAS+C5oSxZ0TUNCHTsVfXMOw+yTJW1S7XOn
	kQ5l3c1FntAFMIEWhz104zH8FjxR5K5IKqfC95VZZ6vA==
X-Received: by 2002:a17:903:4765:b0:2ba:6013:eeaf with SMTP id d9443c01a7336-2baf0dd5c4emr104042635ad.19.1778424151097;
        Sun, 10 May 2026 07:42:31 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d26968sm75328855ad.16.2026.05.10.07.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 07:42:30 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2] btrfs: validate root ref names in tree-checker
Date: Sun, 10 May 2026 22:42:11 +0800
Message-Id: <20260510144211.3722701-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260510074943.2644335-1-rollkingzzc@gmail.com>
References: <20260510074943.2644335-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
by the subvolume name. Several readers assume that this layout is already
valid and then use the on-disk name length directly. A corrupted item can
therefore make those readers address bytes outside the item, and
BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
name buffer.

Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
uses them. Reject items smaller than struct btrfs_root_ref, reject records
whose name_len does not exactly describe the remaining item payload, and
reject names longer than BTRFS_SUBVOL_NAME_MAX.

For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len and
keep a local BTRFS_VOL_NAME_MAX guard for the fixed ioctl output field.
Terminate the copied name explicitly.

Sanitizer validation reported:
BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
Write of size 505 at addr ffff88810936d608
Call trace:
  dump_stack_lvl() (?:?)
  print_address_description() (mm/kasan/report.c:373)
  read_extent_buffer() (?:?)
  print_report() (?:?)
  __virt_addr_valid() (?:?)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  kasan_addr_to_slab() (mm/kasan/common.c:45)
  kasan_report() (?:?)
  kasan_check_range() (?:?)
  __asan_memcpy() (mm/kasan/shadow.c:103)
  btrfs_ioctl_get_subvol_info() (fs/btrfs/ioctl.c:1948)
  btrfs_get_32() (?:?)
  btrfs_set_16() (?:?)
  btrfs_test_get_subvol_info_name_oob() (?:?)
  btrfs_run_sanity_tests() (?:?)
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
  kasan_save_stack() (mm/kasan/common.c:52)
  kasan_save_track() (mm/kasan/common.c:74)

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
In-Reply-To: <20260510074943.2644335-1-rollkingzzc@gmail.com>
References: <20260510074943.2644335-1-rollkingzzc@gmail.com> <qu-root-backref-20260510-161800@local>
From: Zhang Cen <rollkingzzc@gmail.com>
Date: Sun, 10 May 2026 17:05:00 +0800
Subject: [PATCH v2] btrfs: validate root ref names in tree-checker
To: Chris Mason <clm@fb.com>,
    David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
    Qu Wenruo <wqu@suse.com>,
    zerocling0077@gmail.com,
    2045gemini@gmail.com,
    Zhang Cen <rollkingzzc@gmail.com>

ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
by the subvolume name. Several readers assume that this layout is already
valid and then use the on-disk name length directly. A corrupted item can
therefore make those readers address bytes outside the item, and
BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
name buffer.

Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
uses them. Reject items smaller than struct btrfs_root_ref, reject records
whose name_len does not exactly describe the remaining item payload, and
reject names longer than BTRFS_SUBVOL_NAME_MAX.

For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len and
keep a local BTRFS_VOL_NAME_MAX guard for the fixed ioctl output field.
Terminate the copied name explicitly.

Sanitizer validation reported:
BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
Write of size 505 at addr ffff88810936d608
Call trace:
  read_extent_buffer()
  btrfs_ioctl_get_subvol_info()

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
Changes since v1:
- Move ROOT_REF/ROOT_BACKREF structural validation into tree-checker.
- Validate both forward and backward root refs instead of only the ioctl path.
- Keep the ioctl-side BTRFS_VOL_NAME_MAX check as a destination-buffer guard.

 fs/btrfs/ioctl.c       | 17 +++++++++++++----
 fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)
diff --git aa/fs/btrfs/ioctl.c bb/fs/btrfs/ioctl.c
index a39460bf68a7..b43d33eaea07 100644
--- aa/fs/btrfs/ioctl.c
+++ bb/fs/btrfs/ioctl.c
@@ -1956,7 +1956,8 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	struct btrfs_root_ref *rref;
 	struct extent_buffer *leaf;
 	unsigned long item_off;
-	unsigned long item_len;
+	u32 item_size;
+	u16 name_len;
 	int slot;
 	int ret = 0;
 
@@ -2034,14 +2035,21 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 			subvol_info->parent_id = key.offset;
 
 			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+			item_size = btrfs_item_size(leaf, slot);
+			name_len = btrfs_root_ref_name_len(leaf, rref);
+			if (name_len > item_size - sizeof(*rref) ||
+			    name_len > BTRFS_VOL_NAME_MAX) {
+				ret = -EUCLEAN;
+				goto out;
+			}
+
 			subvol_info->dirid = btrfs_root_ref_dirid(leaf, rref);
 
-			item_off = btrfs_item_ptr_offset(leaf, slot)
-					+ sizeof(struct btrfs_root_ref);
-			item_len = btrfs_item_size(leaf, slot)
-					- sizeof(struct btrfs_root_ref);
+			item_off = btrfs_item_ptr_offset(leaf, slot) +
+				   sizeof(*rref);
 			read_extent_buffer(leaf, subvol_info->name,
-					   item_off, item_len);
+					   item_off, name_len);
+			subvol_info->name[name_len] = '\0';
 		} else {
 			ret = -ENOENT;
 			goto out;
diff --git aa/fs/btrfs/tree-checker.c bb/fs/btrfs/tree-checker.c
index 1f15d0793a9c..41417b2df32d 100644
--- aa/fs/btrfs/tree-checker.c
+++ bb/fs/btrfs/tree-checker.c
@@ -1371,6 +1371,38 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key,
+				  int slot)
+{
+	struct btrfs_root_ref *rref;
+	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 name_len;
+
+	if (unlikely(item_size < sizeof(*rref))) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect >= %zu",
+			    key->type, item_size, sizeof(*rref));
+		return -EUCLEAN;
+	}
+
+	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(leaf, rref);
+	if (unlikely(name_len > BTRFS_SUBVOL_NAME_MAX)) {
+		generic_err(leaf, slot,
+			    "root ref name too long for key type %u, have %u max %u",
+			    key->type, name_len, BTRFS_SUBVOL_NAME_MAX);
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size != sizeof(*rref) + name_len)) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect %zu",
+			    key->type, item_size, sizeof(*rref) + name_len);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 __printf(3,4)
 __cold
 static void extent_err(const struct extent_buffer *eb, int slot,
@@ -2226,6 +2258,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		ret = check_root_ref(leaf, key, slot);
+		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 		ret = check_extent_item(leaf, key, slot, prev_key);
-- 
2.43.0
