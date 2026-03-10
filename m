Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8C359A79
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 10:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140184; cv=none; b=NNOfeTo3u/wG5P6mYZGzGNJJtWtnOJ/WhHp5PZk38I298UKkKfCT9zz44MXpboGg1ps1gPdke7QYdRThsSUnYjC/k1v9XJtsaGnTxVtnmpMZQng8akQfielcKggPJfo+Po5zuuZJ4pbf1Bfq3lIUShHvEjHmWzG7LGLrE7UHYjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140184; c=relaxed/simple;
	bh=4wmdd2cg0/m1f/1qyTr/K0c031G2xoidDPc2GAzftvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLuO4W/mhUGF2cVgnrHFg3Gfert0ljXU/in0SNBvFeXJy3kGJTncBmSvRK08+DTjyr7Oqu4ZbpUveZ5YfKOKNkBxLQDrGAytjjDrkPknE0Q8/PKwIs4lQupAaDnQk5tsup8xvowgYrTQQpbsyyG8UWPUROm5ORpI6KMeOYNPD2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9SuEGOc; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9SuEGOc"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-359f35dfef6so433308a91.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773140181; x=1773744981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lq0gtUIdK/pcjxTH7mAibkkU2ZdoA8YXOl+R8yTw3JQ=;
        b=Z9SuEGOcOYcYsrAijHSdCfW02mbXFyds+uQb+MNbC35h4BtEIgfd7YpsRc8jjNQnTP
         uNiIJAdqOTM4YBu+8VRiepAlkC8QheTjQZbkw20dK+RojEsx8MI5Q6Deqr63XWtqx5xB
         mwwkQ5X0cBVFtKhCUCtyjFyE6YKqvm7Tc9EI9hGaGrGnLtYLCYDD0TTzhhaPrEttQ46K
         If9qbaQu4aiEQq+fXRx+yYRZ+wk9H37uUtGFbEnH5beuSwaHT08a1B7owsuGml6j0dkg
         MUBTo2BLt/sddqzBUPGgvvebRnYHfmmkUnyq1EFHPQYclJXmZ5T1H+LORl4iYw5J3x2r
         3mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773140181; x=1773744981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lq0gtUIdK/pcjxTH7mAibkkU2ZdoA8YXOl+R8yTw3JQ=;
        b=w0vSDlnJCXIzE63hNXwOvHPDR03dLA8aN3gJA89xDMYIv9oE6N8Bc2pz/DWfqQKR9Y
         JYJ35U0zMS4uXvbkLf/zY1LVF9jc758foAn6pU7hUo9PkpQiyuYYSs4QS0F4bzeyPDnm
         kB+W1Xao4A0CZX1JIa45ZIIeGH1VqRK4iDK1uoZQELYoesmkRhK1N20PqvpOJ4cKh/E3
         xAA4zlMta1giPl6H5SJwS+W5liyt4g4JAqqc79Jag8xrYkFeFESdT9N99FljQ+a/mTEI
         AU48DVOUkDVLH9gtmcf5OtP7CwdL0W95G8wbJ5AUhP3I6mX3BFfcEAA3I2F+fRuHxAeS
         BL4w==
X-Forwarded-Encrypted: i=1; AJvYcCUW948Dq6QCzAY0QiP3lNJ2nzvreFaoTjY0i9Ck5QX0AR36hO25IREogAQLQ3rK0cZ/L/xHcllP1syjdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4J2gawzSqGAhZnnAxRYwCmarMiAZWIXMh/81up1vunXHfV+9
	m+Bw27Jz5mVp0jTmgFVmx6UXo4+cbppDjQ+VC2ayST7iDhGMUwkvYe75xmJaJWEwRfQ2wQ==
X-Gm-Gg: ATEYQzyS1mkC1ZE/mFouO16TrpNYpfSUV6ksbkdVirUs+FCdcwDVOXnA8tKo/PDM4LY
	vEP8NRYUWy3Yn64svNqJo1oitcwsPEjsr3i7KwczrOwliiq9h+bSlncHSEKzdN6NdJ6jtVDr0fl
	n90XhbgAP/gUjdgVeW647F9KlIUf6qrV8ASOX2ido6gYeWAfrxFTqm2dFISOJdB5i27ZVhkOmTf
	AQIsjS582zH0x933MVwz/9K7NkZTlxnB1dRRcgV1cxCO3Az3KiWUghB56w5ZD6ghayw2JCuIO4z
	pw8I6KgQ06J7PN8F/vuevMxFNC/1uRpX4gEyUZwXAlN8KVsVgoFUvC0i7l+Am1EloSvh88lKrAa
	831n+WBaJsmIxJBMQV6W6bKMzcSGMdWM85A2VPbw0WMEDz0vl2US9xyqNHYFX4ktHSkMw3+Lx7L
	nGrAmhGwjOfgauAlk9nEp55eYOzw+Y7kFj2U6Cp92sjInzeSi6/JHATv08VgaI5/41IGtF1A==
X-Received: by 2002:a17:902:ce82:b0:2aa:ea8e:f118 with SMTP id d9443c01a7336-2ae8241ddf9mr166651615ad.3.1773140181101;
        Tue, 10 Mar 2026 03:56:21 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840c9a0csm149873725ad.91.2026.03.10.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 03:56:20 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: wqu@suse.com,
	osandov@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2] btrfs: tree-checker: introduce checks for FREE_SPACE_BITMAP
Date: Tue, 10 Mar 2026 18:56:06 +0800
Message-ID: <20260310105606.2134142-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce checks for FREE_SPACE_BITMAP item, which include:

- Key alignment check
  Same as FREE_SPACE_EXTENT, the objectid is the logical bytenr of the
  free space, and offset is the length of the free space, so both
  should be aligned to the fs block size. 

- Non-zero range check
  A zero key->offset would describe an empty bitmap, which is invalid.

- Item size check
  The item must hold exactly DIV_ROUND_UP(key->offset >> sectorsize_bits,
  BITS_PER_BYTE) bytes.  A mismatch indicates a truncated or otherwise
  corrupt bitmap item; without this check, the bitmap loading path would
  walk past the end of the leaf and trigger a NULL dereference in
  assert_eb_folio_uptodate().

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
[CHANGELOG]
v2:
- Move the FREE_SPACE_BITMAP item size validation from
  load_free_space_bitmaps() in free-space-tree.c into tree-checker, so
  corrupt bitmap items are rejected when the leaf is read from disk.
- Drop the extent_buffer_test_bit() range check added in v1.
- Rework the fix to follow Qu Wenruo's suggested tree-checker based
  validation.
---
 fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c10b4c242acf..0f12fe462b6c 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1901,6 +1901,42 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_free_space_bitmap(struct extent_buffer *leaf,
+				   struct btrfs_key *key, int slot)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	const u32 blocksize = fs_info->sectorsize;
+	u32 expected_item_size;
+
+	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
+		     !IS_ALIGNED(key->offset, blocksize))) {
+		generic_err(leaf, slot,
+			    "free space bitmap key range is not aligned to %u, has (%llu %u %llu)",
+			    blocksize, key->objectid, key->type, key->offset);
+		return -EUCLEAN;
+	}
+	if (unlikely(key->offset == 0)) {
+		generic_err(leaf, slot,
+			    "free space bitmap range is 0");
+		return -EUCLEAN;
+	}
+	/*
+	 * The item must hold exactly the right number of bitmap bytes for the
+	 * range described by key->offset.  A mismatch means the item was
+	 * truncated or the key is corrupt; either way the bitmap data is not
+	 * safe to access.
+	 */
+	expected_item_size = DIV_ROUND_UP(key->offset >> fs_info->sectorsize_bits,
+					  BITS_PER_BYTE);
+	if (unlikely(btrfs_item_size(leaf, slot) != expected_item_size)) {
+		generic_err(leaf, slot,
+			    "invalid item size for free space bitmap, has %u expect %u",
+			    btrfs_item_size(leaf, slot), expected_item_size);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -1964,6 +2000,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_RAID_STRIPE_KEY:
 		ret = check_raid_stripe_extent(leaf, key, slot);
 		break;
+	case BTRFS_FREE_SPACE_BITMAP_KEY:
+		ret = check_free_space_bitmap(leaf, key, slot);
+		break;
 	}
 
 	if (unlikely(ret))
-- 
2.43.0

