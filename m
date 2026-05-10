Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08E243951
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778426960; cv=none; b=Pa1XDxMu1/FgkJWDgYLO8NEJk44f+JHWs9WHcYEIcaejFrDvXdjA8CvPBt29azyroO3/Wlc1bPRmy3h3/gC2PPp5fd9LyznJPEz6lU9aaWlEwAmBuhRhA9u16pCNbg9uDUMtUdSwa7DqwGNeV3zfqH6OisxgoPRW/ppkFt8TZ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778426960; c=relaxed/simple;
	bh=X9hjY0rwMAsfwrAY3m95a7ArJ/isWcsx4qfAwX3RLDc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JANHaxN1XWYqhoTSKWqw4j5/40QTZHDR4vB3AE9DRxcyXbxOdnYwll/0mdW2q4h9ji2bY7JDKKzN17rv+peQUmSZzN1FPmHxSQm1PstC/qE3QOFXu1ToNumF5MOCN12BmSHP7T6Uu3b86/wlbtn0KPa3RfJ7Is9NSvV032ffOvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMYBqV/a; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMYBqV/a"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c7b9f54d3deso2310836a12.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778426958; x=1779031758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8q7GuFqAon4StG56UBqxvWt0V3wronoJWg2hbApzjzA=;
        b=nMYBqV/aI+JFT35yDkqRpymbOgcwOGUSdpO6GU7/hFuRpeOznxCjjmWAgpbNSpa1kE
         q3mxZrlQzTu1C9wm/YGyeafIwJjhLuOLtif44x2movlPQgkl6obg58J+TuaMJz3BsN6z
         pOaaLmel0iqFf4sSWU4nO9iaE3iv4OiJdfrbiNlum85JT30YVfvfEiF47S8a/Zk8EvQ6
         sSZ3kWMIBbj1jNBXTtA9NvwEFW4I/yoRgsrX7DhZMu8WuAUSzaTs3ll8aRkIR7CNFRmS
         ct1dkffm4d5BuMs9VLrt/Fk6PiLHnzKiel+lZL9qC1UtqxhptwWH2BBInbfbppRwW2rU
         YODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778426958; x=1779031758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8q7GuFqAon4StG56UBqxvWt0V3wronoJWg2hbApzjzA=;
        b=RtvQNnJEFsTTH73pUNiADivA2uXUZwltKEggTdVk8FENfBvW8w/2EIckdJDRdxUoav
         LrNm7y0klhkPWrZNv3oT2vkFr+wR+dwybspqsTTtPpawjLIlvndKF731fGATm4VKrl9C
         f7a2X6sm+lAxhRJ5JJsGx/fSg7CDpzkOR5DAhR7DmBVyKwgqxeteF3+vpyIzmnpm4pYu
         h5YbNl1R6GLIQo8SRuZBqBg7MYCEwWWCOw45nDwit+yk1z2J86FJmAyYWaldReoQ7Owk
         KNZ2cLPjKPJRrfzlQiilBD2LSFzMSyWNAZhT7dVa/FSrrczfBJS0yvjm7tcTOP5ow+ki
         yFQQ==
X-Gm-Message-State: AOJu0YzBDkq3A0ywyR14I4I7l0LV01WZBnzCij9rNCKiE9jRDnf1K07h
	44m1E8lRVCSSDOCb/eBpvpbO3OSiMUyN9gWlKUAUoTM25rfeizjQqP7/
X-Gm-Gg: Acq92OEm1lzekMw5lVIKPozwuw7am7+jJBHi4+P4YTIqa/vwoFT/8ocsoWw4TBnhVDF
	0wD7bHrI8eVYyvxjXRxQaYTc70x8efpX10YR7fZlGTOlQOrfEz/77RSXC/qoGKLkyk/Fmax4Uwz
	m8/KtyybLZdGUBXoC6U1r084mbce4qgW1iyj6M0bTTlUTrAMHbPhLwo0CO7jMW7+8bpU5+sfzAD
	a5tWirPzEWToIJwugsfMzuJR+dKsfcV1WFsXohUcMEcOqaPs3vwzNvYqIkKtkwONMpHQ2RuDjVp
	ggMBzDqLKnY+z3SJOz+/bYODx0TfDcvL5cBHRi0Pl5f31wXy/S5q5MRfZJY8dNsxx9v1G35Xvly
	cUPN7Q2kLPUW6vBPfmxnPV3rBgBYC6OnsLJiJqd8FE0cUgtxlhRVDKTjFQfGhzxcBGIxdSSUcMD
	DDNK/nAtkq3Pf7703yx8voizpZxXf2XLyn7GSnRs5kPQ==
X-Received: by 2002:a05:6a20:7295:b0:39c:39d1:dbf4 with SMTP id adf61e73a8af0-3aa5abc85e8mr22076551637.46.1778426958044;
        Sun, 10 May 2026 08:29:18 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771c6ddsm6604225a12.23.2026.05.10.08.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 08:29:16 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: [PATCH v3] btrfs: validate root ref names in tree-checker
Date: Sun, 10 May 2026 23:28:48 +0800
Message-Id: <20260510152848.3844890-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Changes since v2:
- Regenerate the mail-ready patch without the nested mbox wrapper.
- No code changes beyond the v2 fix.

Sanitizer validation reported:
KASAN slab-out-of-bounds in read_extent_buffer()
Write of size 505
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
fs/btrfs/ioctl.c       | 17 +++++++++++++----
 fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf68a7..b43d33eaea07 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
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
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1f15d0793a9c..41417b2df32d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1371,6 +1371,38 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key,
+			  int slot)
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
