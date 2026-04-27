Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72191366072
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777321709; cv=none; b=euZpndqtPIbAn7K6+sq9dukVcwlLaVIi03EVCvY7Ez8Ped7nasxZKWXVY0W9tsY0pg6VqW8wxFiWgWWhtyOJOx4UEi2nvB+4l/rJNG7KqaYcxySy0fX8R4mySHVJoDudm31tF4qcrF2RzCfOQEotS6weBnk7XRVhmxvPHJhZaH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777321709; c=relaxed/simple;
	bh=2W3udJfpoUpVU+zcXEL2kBe6tqgHZ5XeEjLMm3rQp+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYh2s7Zot9mB7/Z0W24/4DZplBlSB4vEyIMKfK75y9ylaz5rsaZfWO8LwprPAn18fBQC5zQW0KRMC4lodiW4HhbvMJ29RfU6Y5bwHI1NOG27DA4ihRRCzuPboYOjKuRZ31ZQTFRrOhKJq1aFITOlH0zRIV+LEjQJGf5p++htI1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEbITPW9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEbITPW9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso108204335e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 13:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777321706; x=1777926506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJsJ0/AdMp4F3EjvGpZbBz3zMwBhPSd1Q0YoCqjYwls=;
        b=CEbITPW9JJptOSlT6yC2YhPqoav+hmMeWJmZhPPMgHHF0EM7KPvo5+v9kLqYVTnmeT
         L48c2AjLgOXcdNn5Swjz/D7ETSBmxGE0ZA8LTwBbId91R8tlWg2pPsrFSMZ/ZIN/B93y
         QXprOZDPYuBYfZQ+6h+Fc9rryMpWalD3NHvhgYQd1UWkwQzjoDw/pTlM0fu7ApfQpLm7
         vZkSmE77jWLG1BoNvhGS2vEODLWess64ET+18+NAbJpOVyCXTFutbzSFQfACInRRg09j
         fLS3yMDY6aMTA2Q+5jvbyFt9leqLL0ki2iEtPfb+Ys0Gns8Rk051KKuRGNMiMTYNBMui
         4t1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777321706; x=1777926506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RJsJ0/AdMp4F3EjvGpZbBz3zMwBhPSd1Q0YoCqjYwls=;
        b=lv1RqdKBEyIpBmFhCV0j1hVAyc5XHglYQ+qezpkeZGz2e3NH4HsoHDeibnHw7UfkJy
         JR2klw9aHemLn1NSrbK48snSSZA5lE9dgoNyCWAAB333q8eD2jamPAy/L5VmYAQz6CLS
         B6QhMcIMP2FahoY2PDwUagtO5PYGZgqtabjZOY93StGbD9oXSKWCcAR30snFlMzB61GD
         c2R7M4XEEQ2atn2f3g+K2TZuPH9bfMAyyVXumIeg/lOvTRzslj0j44DunOFUbFQ7aMmR
         MUyrnX7/uHV7Y0NPa97lv5nt4Prk6UYDWh+K1QI9sczXUqg/qm4mtAGXMdfuBrGCnllf
         7MNw==
X-Gm-Message-State: AOJu0YwprcSfbBEreA35tTGWftq7WOar8Wef15Xy6gg1Tpdmw9+cuXov
	5KKfv8Dnw+cl7vgUd5X5YPsP8PJoFJnwbMoADMCs5v7EZhPIeKdHpESaTHUASedy
X-Gm-Gg: AeBDievC9m3IQWbgGdhRMlarv+sdsQe4gN/vMLpohM9S9pQ9+vwvxj4WHJLhKSIXKeu
	/2o6f4tjUHzvwJM9dQ8QSLOpvvjQ8gdf9tJlbZENK6z0DaMLvQhxnnnktRRXZL4c/zFi4Azx8Mf
	lN1b57TAe0Qpwq3ayZGM/N2/luIrPSajY8ZXsFfIvpVDHqjxS8SilG9TIKYoEhekW9LAC8wYyg1
	NLUSxYroZDTw6m5V1XGRwl862NZ2ccQ9NFyn5Rr3xSf2zgAkPP1CbDt4L8Wp9nbad3gfHeOXSnp
	PU7KeG6D9sdsFjBf/u5GP0ohX/5sZIPJ6FdsCuWgmXwNCKSD/AR6GVDHbXPtHxsZd63GnpViFP+
	Dngmbv+4EoC7zt0Q9J+BnlR+XpqyWk1M5GM0npgVvHw+Y+5GFai1Ou35UshItCwndJmjW6HUQWu
	l14oGRg+g3X0jQuFmC8VOMDqpWGx9fr6f63wtupqJFSKg=
X-Received: by 2002:a05:600c:4f08:b0:48a:5821:6006 with SMTP id 5b1f17b1804b1-48a77e40cfamr2229895e9.4.1777321706225;
        Mon, 27 Apr 2026 13:28:26 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463cb59a68sm872149f8f.4.2026.04.27.13.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 13:28:25 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com,
	linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH v3] btrfs: validate data reloc tree file extent item members in tree-checker
Date: Mon, 27 Apr 2026 22:24:58 +0200
Message-ID: <20260427202822.278326-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260426201605.36626-1-27rabbitlt@gmail.com>
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get_new_location() uses BUG_ON() to crash the kernel if the file extent
item it looks up has any of offset, compression, encryption, or
other_encoding set. The data reloc inode is only written by relocation's
own paths -- insert_prealloc_file_extent() and
insert_ordered_extent_file_extent() -- which always leave those four
fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
and encryption/other_encoding are reserved-and-zero). Observing a
non-zero value therefore means the leaf decoded from disk does not match
what the kernel wrote, i.e. on-disk corruption. A malformed image can
reach this code via balance and panic the kernel.

Move the validation into tree-checker's check_extent_data_item(), where
the constraint is enforced when the leaf is read off disk rather than
after relocation has already started. The data reloc tree has a fixed
root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
header, so check_extent_data_item() has all the information it needs to
apply this check on its own. Report violations via file_extent_err() and
print the four offending values.

In get_new_location() replace the BUG_ON() with an ASSERT().
The caller in replace_file_extents() already handles non-zero returns from
get_new_location() by breaking out of the loop without aborting the
transaction, so no caller changes are needed.

Suggested-by: Qu Wenruo <wqu@suse.com>
Suggested-by: David Sterba <dsterba@suse.com>
Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
Changes in v3:
 - Move the corruption check from relocation.c into tree-checker's
   check_extent_data_item(), per Qu and David. The data reloc tree's
   fixed objectid is recorded in the extent buffer header, so the
   check has all the context it needs at read time.
 - Use file_extent_err() and print offset/compression/encryption/
   other_encoding values, per Qu.
 - Replace the BUG_ON in get_new_location() with ASSERT() rather than
   -EUCLEAN, per David.

Changes in v2:
 - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err() so
   the offending leaf is dumped to dmesg, per Qu's review of v1.
 - Expand the changelog to argue why non-zero
   compression/encryption/other_encoding in the data reloc inode imply
   on-disk corruption.

 fs/btrfs/relocation.c   |  8 ++++----
 fs/btrfs/tree-checker.c | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bdd..527d4dbfe31c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -835,10 +835,10 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 
-	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
-	       btrfs_file_extent_compression(leaf, fi) ||
-	       btrfs_file_extent_encryption(leaf, fi) ||
-	       btrfs_file_extent_other_encoding(leaf, fi));
+	ASSERT(!btrfs_file_extent_offset(leaf, fi) &&
+	       !btrfs_file_extent_compression(leaf, fi) &&
+	       !btrfs_file_extent_encryption(leaf, fi) &&
+	       !btrfs_file_extent_other_encoding(leaf, fi));
 
 	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
 		return -EINVAL;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1f15d0793a9c..e4864f7a471e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -296,6 +296,27 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
+	/*
+	 * For the data reloc tree, file extent items are written by
+	 * relocation's own paths, which always leave offset, compression,
+	 * encryption and other_encoding as 0. Any non-zero value here means
+	 * the leaf decoded from disk does not match what the kernel wrote,
+	 * i.e. on-disk corruption.
+	 */
+	if (unlikely(btrfs_header_owner(leaf) == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		     (btrfs_file_extent_offset(leaf, fi) ||
+		      btrfs_file_extent_compression(leaf, fi) ||
+		      btrfs_file_extent_encryption(leaf, fi) ||
+		      btrfs_file_extent_other_encoding(leaf, fi)))) {
+		file_extent_err(leaf, slot,
+"invalid members for data reloc tree, offset=%llu compress=%u encryption=%u other_encoding=%u",
+				btrfs_file_extent_offset(leaf, fi),
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
2.54.0

