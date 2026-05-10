Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F239E6FC
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778425425; cv=none; b=Yj0295TEuwrjYumNVNWxSNxma6e2u8ETOtFqmgGDJ7z6HOzcgXptuMJR6BzCUYfy0V8oKCOOfL5TLXXbM3C/P7ndf0LO5uPE/iNveXXL/dqbGKotg0yTHw7ES6VzRuw6Xb3vCF1KwEOW0dfFEzQw1JIYf7+CY0w9HsUQNiHWZo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778425425; c=relaxed/simple;
	bh=Ahwg0Cx2kD8DvjG4ZQfwZoUXHc23R/47IU8VQM8NKSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mGGXUrhxgAsHHReNsLoiz2nnKJFLKBxKd1uP8/0BmDSBMvT5fhltP+xYepfxr/gP5IzC2j0de/AF4sASzp0vuJNJPEf8gmUZS/TF/oysLv9hGb+zersBw/02M/7NKuZ9qZVspJDCsuqJO+0dafZtGxVFzwvnq+C5alu6NZPde9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNqCWd7t; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNqCWd7t"
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-367c26471f5so918087a91.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778425421; x=1779030221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mqb5atmlaX4DNNEm4JEpWwRW6bdKqpdo/BCBOHOTB4=;
        b=KNqCWd7tUuyzq/3dSxZcmvxgBIPLae3TJ/5WxdENCX1onjqix5KzFeRgQRV5AbvIy1
         KtntBRVJVHsCVmejpW9csJyuMj7BM6P5aIQpjCeHIz8v1S7rZwzQJG9PmQ2ArMi5bO2P
         357zoKBy9TV0mMk4pvFbJTyaemwzYYyZ8yJqrEX16WX59VE8tbDC4DzqYNGKnPkcIPAZ
         qaprJ2h469kT6muCUxQ/qFOs1DWy7HAWZCNyb2hINvAjNEBVsbI2FzGPSXFEwYiNxzPj
         PlKI4dRfzOKUBMd+RQnDuoehJy8OH+I53wi2dI12rgtscBFNnDp+yJkSNfIu5jBvy/4V
         c3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778425421; x=1779030221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5mqb5atmlaX4DNNEm4JEpWwRW6bdKqpdo/BCBOHOTB4=;
        b=ATMOjfffQuKK9v0uz+RsIjN+p7EijhXDVofhl70fXsJ8b9zYI1yboFqYtCSre8BLFh
         lCqSgA85UDjxcL/TCfz1cSNnJlILD1NCGiJ4fW+Pc2LOeqy6VI9l/s3+cMnKViQ+TdUt
         WOQDLwWRmOgOeD1KvAYLtZ1pVNu5Cp1uyoxKi3bqJxbGsteh9NYgU9YpJMufcNXWO/mL
         D52jbtQcM06IyTAmHrn0EsYS5lvulyCGDeijJ5G1bNQSeAdDHqr0nDQ4v/q/wiUq105r
         OyxrZqaBHqq2GUnVPL2o3AjSMLhZiIN6SFy5at/qLLOfo398tq7bzNME0BN3tFniO7dK
         2KWg==
X-Gm-Message-State: AOJu0YwhqfkHeL8JH7+FPEFZ9kSfEldHjTQTvoxjw91UluOOodQWCnTF
	2RbTPxZCDPB35ejkVy3mbfys+hcMBfUwJoTfan31bpz4ji51UZ8NNJ8x
X-Gm-Gg: Acq92OGe1EVzAQe5y/FPvwUgxSVPOJ963+KShS1QPRd8LIuj9QuonTl55AMbcfiBoLC
	YbBfJENbxJFAXovAI3wwAhGVcmF3mBKjtFvO2USkJajbUKOaUOzZ6J4hTgGS/Egp6cJxrkUgHWf
	vmnzDSRIYnUNGs64xT5+HE86KiNdr4Qn79W1wAQ5vYGi9X0D/PCt4LdAzcq6bk9kUFFNgraXi31
	mutkqOhat1kPu/x4OT5UUSHWq45A2jmBzmeTnZ7N88bL25J6TFd+TMh8vhefB3wc9INqzABGLAD
	tjRumPzOsXtYBZP/wsUJLea4eEXawhUTdLX3frP2cKy6Sra3v36qbLZcpWDF2FyhrSqVf8xAHky
	iooEu02Gn7CH+ZGKTWkDaaOQ23vvgvfjjiBSQBp++eVq7HJPoB1lAL6zTP5rrIAno6pnMGOIIBz
	17scOYsrSzeCiiGoAX5ln95km2c2XrsPYwD8P3fRR+QQ==
X-Received: by 2002:a17:90b:3bc8:b0:35f:b3fe:18dc with SMTP id 98e67ed59e1d1-365ac47ab2fmr21566265a91.19.1778425421204;
        Sun, 10 May 2026 08:03:41 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d660b9d7sm4843012a91.17.2026.05.10.08.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 08:03:40 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Zhang Cen <rollkingzzc@gmail.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: [PATCH v3] btrfs: validate root ref names in tree-checker
Date: Sun, 10 May 2026 23:03:22 +0800
Message-Id: <20260510150322.3778139-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260510074943.2644335-1-rollkingzzc@gmail.com>
References: <20260510074943.2644335-1-rollkingzzc@gmail.com> <qu-root-backref-20260510-161800@local>
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
  read_extent_buffer()
  btrfs_ioctl_get_subvol_info()

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
Changes since v2:
- Regenerate the mail-ready patch without the nested mbox wrapper.
- No code changes beyond the v2 fix.

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
