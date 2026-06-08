Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476573B0AE3
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780907746; cv=none; b=Rlvrar6dQ4amEzqBpvwNVAQ3K5y8im9xiyE5V5ksUx6w+UzoK8rgXHMX5OsST1m4CqGxckkUL0pKSmUpYzGXn5TtkQqBQmi+XD9fEWKNZpEqrV+VgcF2W7Vr7g7vvaNPs0oM0OsJiuIhdXCyhB0XexSPLQ7kzjkjqjdwPxcqM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780907746; c=relaxed/simple;
	bh=p4YYXNFAHqlQLnnfnDXOqLV/z+1Bi5JqYPdoPdnqzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NhyUjOg68jHi9Afgs3pkXmwfwNhJs62P5D6+WuGrqIkpF6/LCB+MZDYcQjOY6XRj4pCIx0c2/5cq3pwEEN8cvyJW9DhUK9qz3cFtAzVP1BOUoMeg2VDIr3HQfeab6BWQP7AJdfgWrB/NcrehJ93h3bO8sGYOLBFikuRRLSLujjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNwijyDg; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNwijyDg"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-13807d2f898so2732018c88.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 01:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780907741; x=1781512541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TKZjQe27+PJvsypmIoxW1Ox9wBnS4j2Fv+eUh5E1dkU=;
        b=fNwijyDgxLu7CmZQJGtRIAK/iZ1TXAd+OLd7O3Pwl8KLlQSCdx/lVkRuUNqzflYHBq
         aXv/Qed4+fVhG3w5CgMggbqPgUH0YWowFXLrCE2skZ1lmBcRwaqFP9KkD0NK+Xo4N/uk
         fq0fIleT0t9y5A/32BcqD7wGXnq5eQOa0ItSQtJd7fHFMasIzBlMt0Oq0ypICzgWMElX
         aq6DG+7utVG2PKsYVH13nPiNzGeD6jVZQo4dZDrQN4cDMf4tV2i5NrvdVmR4UEplIGWj
         F8Rt6J3RN930dieKIVHubmokZ6K5K1tWXLRr0k+TPcYCgkuPb/Tt3uuc4BuwMnRi3jhO
         15qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907741; x=1781512541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKZjQe27+PJvsypmIoxW1Ox9wBnS4j2Fv+eUh5E1dkU=;
        b=ekNdcxdT37wQGwFOwNIvgQgCAlUPRuCKlFcTs1i4+i8Rb6g04LSM+lVgzdAPX2EM0D
         hlmoOIhgtFURmRbdlNBPd3nGCuKZvqnA4dONP6FE2Ei1SkcpNauTG81kHW3UbydRUFtV
         J4nZdjrooRNWm5cGuSZniz+I0VIynMOSIlSdFNK01V5n863bixJPPszCdtioKn3oDDpB
         J8spltyqWm2OerMipk54Ll4p0xp7Ds6LM5e+GwtLTb4895ow2P0JLQ/GLBoVETQ/hEY3
         WuyiVk5A25PBCInswXUmMnDCmHuYWgOeja/3Y0gJyDRzl7PsWBkjASIJ08t93R7Tnav2
         sRiA==
X-Gm-Message-State: AOJu0Yzx9B1hzidaMJlzj6+8024WhU4pN+E/IGcwJq/J/2XGNuJLoNDZ
	vhtW0vPh24sYIF07JayxhL/e7V+fv5z5ZaeHwQ+Uw2cc+dhVfbXgJ7wl5w/4uem+
X-Gm-Gg: Acq92OEYKZg22mpfhzUrUMIeY69CouohHCIf1VsEMnVVwaR3nT6KaUoPfz7PrLPGayp
	UXZoJ6idY2iCE9rvPq2Ny2TO2zct2+LFBE+E5ILEYZC/NIbwkcANx08svVjiV5RD4rkrsgrwhf/
	w0qFaibpiu4HbC6Yi3xWvAL0OOtbWDAPBax8H4jNIpTwfuD2VWi/hIEt9qlHi7kmWXnEZYl0632
	Xx8UWuE1oekQNyPyEFjEdwfiJIHFUtsb9rE3fari60PUw4LZIAZO5ELdTc6IDXcsrmd5nCjSVCb
	vFqlroy5/A7Q6fplHCjADNo1UzpiZTPS5AShJ+RvrDRfpFCim+xLYDyIOLF6Qp+HRnxW5t/PxGb
	Uqp5hUlXYcnY3cuq5fXtnUMz7IwVubAmrt1HAUcQ077opePN3DkPYlV30g3r/yhuA/8MLKizE/r
	BrchET4lT0QHO/Pp3B4DRdpOceCmbb8ZM2AUJ07cVdt1gJoK+hsUMJK6no5Ngwxqp7wvnHRzYj4
	jLaHaU=
X-Received: by 2002:a05:7022:10b:b0:134:def6:e73f with SMTP id a92af1059eb24-1380671fb25mr6732914c88.21.1780907741009;
        Mon, 08 Jun 2026 01:35:41 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f554f732sm11216908c88.12.2026.06.08.01.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:35:40 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	josef@toxicpanda.com,
	clm@fb.com,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2] btrfs: tree-checker: validate inode_ref and root_ref name lengths
Date: Mon,  8 Jun 2026 01:35:10 -0700
Message-ID: <20260608083509.3907960-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The on-disk name length of an INODE_REF and a ROOT_REF/ROOT_BACKREF is a
__le16 and can be up to 65535, but a btrfs name is never longer than
BTRFS_NAME_LEN (255). The tree-checker validated only that a ref's name
stays within the item, not that name_len <= BTRFS_NAME_LEN, and it did
not validate ROOT_REF/ROOT_BACKREF items at all. A reader that copies
name_len bytes into a NAME_MAX-sized buffer therefore overflows it.

For example btrfs_get_name(), used by the NFS/exportfs ->get_name op,
copies the inode_ref/root_ref name into the caller's NAME_MAX + 1 byte
stack buffer with no bound of its own, which a crafted leaf with
name_len = 4096 overflows. It is reachable from a mounted untrusted
btrfs image via open_by_handle_at(), and on btrfs exported over NFS:

 BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent_io.c:3742)
 Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
  read_extent_buffer (fs/btrfs/extent_io.c:3742)
  btrfs_get_name (fs/btrfs/export.c:289)
  reconnect_path (fs/exportfs/expfs.c:222)
  exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
  do_handle_open (fs/fhandle.c:230)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
 Kernel panic - not syncing: stack-protector: Kernel stack is corrupted

Reject name_len > BTRFS_NAME_LEN for INODE_REF, and add a check_root_ref()
that validates ROOT_REF/ROOT_BACKREF item size and name length. Bounding
the length at read time protects every consumer instead of patching each
copy site, so the corrupted leaf is refused when the tree block is read.

Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---

v2:
- Check name_len in the tree-checker instead of btrfs_get_name().
- Add check_root_ref() for ROOT_REF/ROOT_BACKREF items.

 fs/btrfs/tree-checker.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 60bba7fbe..fedb0bd55 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1760,6 +1760,12 @@ static int check_inode_ref(struct extent_buffer *leaf,
 				ptr, end, namelen);
 			return -EUCLEAN;
 		}
+		if (unlikely(namelen > BTRFS_NAME_LEN)) {
+			inode_ref_err(leaf, slot,
+				"inode ref name too long, namelen %u max %u",
+				namelen, BTRFS_NAME_LEN);
+			return -EUCLEAN;
+		}
 
 		/*
 		 * NOTE: In theory we should record all found index numbers
@@ -1804,6 +1810,36 @@ static int check_inode_extref(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_root_ref *ref;
+	u32 item_size = btrfs_item_size(leaf, slot);
+	u16 namelen;
+
+	if (unlikely(item_size < sizeof(*ref))) {
+		generic_err(leaf, slot,
+			"invalid root ref item size, have %u expect >= %zu",
+			item_size, sizeof(*ref));
+		return -EUCLEAN;
+	}
+
+	ref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	namelen = btrfs_root_ref_name_len(leaf, ref);
+	if (unlikely(sizeof(*ref) + namelen != item_size)) {
+		generic_err(leaf, slot,
+			"invalid root ref name len, have %u expect %zu",
+			namelen, item_size - sizeof(*ref));
+		return -EUCLEAN;
+	}
+	if (unlikely(namelen > BTRFS_NAME_LEN)) {
+		generic_err(leaf, slot,
+			"root ref name too long, namelen %u max %u",
+			namelen, BTRFS_NAME_LEN);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 				    const struct btrfs_key *key, int slot)
 {
@@ -1937,6 +1973,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		ret = check_root_ref(leaf, slot);
+		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 		ret = check_extent_item(leaf, key, slot, prev_key);
-- 
2.43.0

