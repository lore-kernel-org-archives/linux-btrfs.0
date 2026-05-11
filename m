Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3730E0FD
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 07:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778482943; cv=none; b=ct6XtWWA0UyKseNr24lVOt5ounH01fOy/9mXfEicujvPeGgY0OUOGa4+6fQtP6T2ojrledQVGEAgEu+qVqJhqQVcVYmsdPyQcS3UCaNZN6J3w8l8cmVNCB6wzPQYxKqy9w4KMUz7zGAhjFQ1vw0K+ZJgJUXLwFetOWG7c6A4WM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778482943; c=relaxed/simple;
	bh=bMylxZU7xCn8v0NKeRAAzmBA9utLgzIsrTiqODyB7zU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aGEMbWBjh4hkmvbE7kaVHxtrjDusCGRS/MVfnDdge3RafHocSpZD5J1gWmoyAEpZFJ6CjsGCiUff2ofeziJUQH96jsTx4kthc8MtTWO06VaiCiDTJL0IPhkR4x2kdnFAgTKl4HKFIfPh3lVAQUuqaIXoICizmVQrDcMPIfax+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G/O9cQnv; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/O9cQnv"
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c7980c060cfso1709508a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778482938; x=1779087738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mH+6JS7Gahylof9XnJVrLBLHHlJ2doof5ysDMOk/mWM=;
        b=G/O9cQnvqv+OH4ySXGUAHa7dNbaalkwu+NTRcrAg4aho1/MwT5uRF/UHBwUwQQea3Q
         QtTDnPISVcYHrdwIDse2J3jhOavU4T047iRkBw7+qTYvlCVkna/wXQSz1Gza3en7q/55
         A38elr9omwzsNOYul5qHyu8KEJI8p21m2Il3iQe8rcI6g0NKEYtnfE1NFJ7lxhA+i5VV
         ODcJGOQBhqjRvqxCkdThy8deJIFF7E+9FO+jwowCs1iBs/Drk92fHYasGJBMFoeF3ahF
         8yIUHMiO/d7PLV2g/HB8O7UyHdwjwPX/tXnpwwVVBARAlmE0cGOp1OWt3TZtv0b4eC0+
         1kNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778482938; x=1779087738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mH+6JS7Gahylof9XnJVrLBLHHlJ2doof5ysDMOk/mWM=;
        b=jVQExYedKShkFgkN+VkVsUS8mivbafZroN+M8XGO6FMC43m4m6KEsO8pCJaCCKQhQy
         n0uu+HtE9gN46FBvZbwMKkuOAOGSWxKzB/INv2D+chHOdMIo8j0n6TszRzZZEZtGTxPq
         GrgZNI5QOhrqdqH1Gq8M9jRqv40dXoX+oBxKq1KWpJi+xcRyTLI4WMhq+1J1qDSy5IBc
         ndmTdaE+9jxdHtLENuW1RMKDhM0MSbW7pVHI1azUOmtWdN+8qQCBz/juGCUKPEozxJJL
         jm9Q+u9tlx2h1fjIKA3he45P123uNOMHgSWMKZJ47S9zx9jZZazJJLUPjJh6G92SvIzL
         K4Fg==
X-Gm-Message-State: AOJu0Yw6DbT9Eq3PN+8pPvBhlzEgYkcg0iSgO/A7lhmRQFs06wVewDSP
	MMKEYXPr/4gdCKqEZya+4E9YO88d1PTvyx3pIqDXVPYvPLCgKA+l7xy4
X-Gm-Gg: Acq92OFZU+CZHxP1HhTthqTRVGdeTvyuPiQZqJLyouG4zOgMJvcuZwFIYXNTYwovgQN
	Ck1lBoPoyZ7eTjt3pnzJrPet6I1In8g2m/Kk/szw6GFfrI/0vZPMtizcdi7ZjzpMFJziuxDzSL9
	TWRL4vK8A/dJVlTaMyeDu1kQlH2BdHPSmxRMGMopCtIX4SgNsMAxsJ7HhR4mn9SakmomSezLbIV
	EXuxo7unQJjyxZ2OGZJrSG7SWEsFq+owSupq7D0p7QBre9WFV7CUy0+g6Wihm6Sxd9oZCRXTrte
	bWBydwhvXCkOiEOVKo6RblOiHTN6IP6TKyUPEyhENoTbjFDpJsQi2N3tJb0vR/Ft1YqJFBEiOGp
	ePz4CyCiEKIJqSHcnHJ9wJQ4IWzTXdhgqF/BIWwjOqhboP2pgK8/fMjSxdsDVNh8GW/Ubl27WRQ
	DXh6mP8/2CP5fAFFg1ETtv0dgEz5POajU=
X-Received: by 2002:a17:902:b208:b0:2bc:cf06:6835 with SMTP id d9443c01a7336-2bccf066d32mr12975085ad.8.1778482937717;
        Mon, 11 May 2026 00:02:17 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d40677sm93383265ad.33.2026.05.11.00.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 00:02:17 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v4] btrfs: validate root ref names in tree-checker
Date: Mon, 11 May 2026 15:01:28 +0800
Message-Id: <20260511070128.2093775-1-rollkingzzc@gmail.com>
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
uses them. Reject records that do not contain a non-empty name, whose
name_len does not exactly describe the remaining item payload, or whose
name exceeds BTRFS_NAME_LEN.

For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len
instead of deriving the copy length from the item size. The ioctl result is
zeroed when allocated. That leaves the existing trailing zero byte
untouched.

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/btrfs/ioctl.c        | 12 ++++++------
 fs/btrfs/tree-checker.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf6..5958aa8c7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1956,7 +1956,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	struct btrfs_root_ref *rref;
 	struct extent_buffer *leaf;
 	unsigned long item_off;
-	unsigned long item_len;
 	int slot;
 	int ret = 0;
 
@@ -2031,17 +2030,18 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid == subvol_info->treeid &&
 		    key.type == BTRFS_ROOT_BACKREF_KEY) {
+			u16 name_len;
+
 			subvol_info->parent_id = key.offset;
 
 			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+			name_len = btrfs_root_ref_name_len(leaf, rref);
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
 		} else {
 			ret = -ENOENT;
 			goto out;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1f15d0793..b48520ff0 100644
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
+	if (unlikely(item_size <= sizeof(*rref))) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect > %zu",
+			    key->type, item_size, sizeof(*rref));
+		return -EUCLEAN;
+	}
+
+	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(leaf, rref);
+	if (unlikely(name_len > BTRFS_NAME_LEN)) {
+		generic_err(leaf, slot,
+			    "root ref name too long for key type %u, have %u max %u",
+			    key->type, name_len, BTRFS_NAME_LEN);
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

