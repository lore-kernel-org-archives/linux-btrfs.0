Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794897985;
	b=P5z+2KTOiXyKJzo/V9S9mEWYd54Q1eJYV6o51VsEb+FUWu1rIwzvAMv2WWaaBlq5aeGO
	 E6dEH8RMNlmdliVhQ8DJ3rnvpEa5gz8xubcwII8bKTK4XU9YASCNgl54bHULUR1MYffnK
	 wfFLkm3me2N9IfWUsG+d3noV4ITlpv8vvFfWBz+2BXNJTw4qdTJbUgwkpnGMYvf6obg+8
	 Iq5IMyC/z+feAZt2fWr6a++MjijdTr1uFBwPwPSbptu7A0MyXDuuaRj3M6FORqdGw9knG
	 zsWqGd0nPU0TyxEszKbQ6zGvOUm7UULYmnMf3QlWzWomVxAg653SjCc74EBno7//3Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794897985;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k5c7pJ1Iixuk0U4yRF+KLqpvtirGvPa8Ng7t1nZh858=;
	b=xjIWc68hd66Px4C1/SerJHAhHh33PLgp43sqi3jLACMlY9z7ZEBpd+DuTcOOAjLNFbVQ
	 k9kQnw0QDYALMRehyTWn2U7A3MYKaXrto2x5lPcM2r80QbElunm6hnunDfX/a5yXaSj7L
	 llTwbxc6lqH26YmsHY96WxUW5qfVTZzrk3GyReC/Rej+AznN0O4CgJOrTHrUoa5B2mz87
	 ZlJS9UVfU+CETiA9yBYRVs+ERDz8o/c6W0uS1kJzfSMEWkyxEDhYxLSB1EF8URSeeI1Bp
	 u9i6Rh60LdON55vA8LTe9iVd8W9jnR9Gxvnlb8pbIx0NgGkXyDU3ymhnIO5HpB493fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mm6oD0nS;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21173606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 06:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21173606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mm6oD0nS
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-37198ed3727so701540eec.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794897983; x=1795502783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k5c7pJ1Iixuk0U4yRF+KLqpvtirGvPa8Ng7t1nZh858=;
        b=mm6oD0nS4LYLj+mfDtByMe2mNTXLMyjx9sDc5kJzv1E3R//3GyR1A97SsNWjOTcxp0
         icNsLHtdrPpCuvxef4sZWX16J52Zz3v/jsvROv2aZm+3pnJgdhieTtgVvv8SCfeWcHIg
         mIrXDcmB5QEWXPO6MHt0RmNgypMZrKO8NCrJ2mNXqx5pv30DNsZO+fH9nODIH7dkxF2x
         B0oyf/Qv7rDIi5QAZwaQ6GaIf15RmVfJCqzeMRBlmipSpdIQDIIFD9zxxvwD3sY0P6am
         MT8qmV8NIcwHwG8K36IqEKGrtrvhE/Vzh4s67mxuK72TKQMkI8iWzTTVfUdUddrIe+7j
         OFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794897983; x=1795502783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5c7pJ1Iixuk0U4yRF+KLqpvtirGvPa8Ng7t1nZh858=;
        b=vOgVqmvNZtPJxd4FbBGOuKZoqPn//u3cxlishuhCodmm7avjh9SUocm6EdBgAECo+P
         LjXx4giKnwHA8PnHXjMDng9rfESiOiwZorbBCrNH1FTA61p/mCbOdCF3bkx8S3XX67LZ
         9rIXR/WszeUGtADWCtCdZcuZIkq/lCznG9J+1NaPcL/5mpxwok+QQMOGBrlqd8Db/q1U
         1SiDA5svYzAPeLPzJMJgWneNRMe19XsS5oaZQi3Vd4DMe1RrwHQ+20nzlzANit/XqoNp
         cgOACQFXA6dmMS565xRkFcHRwzH9aWZKQJJfXMQBN6M9SLgipcWfGZCOHKcrqYR5qEym
         BAEg==
X-Forwarded-Encrypted: i=1; AL+hErF/WaGMivYhGRxELFbezM2k9BB7/1hlqn/dnW38bJLEIMizJ+hDk/yROp8dDjMQGdrmc9uVquj7IvBUYg==@vger.kernel.org
X-Gm-Message-State: APuU4Z889+MKwfoBxqI6TpPrr7JAUqm5oqYIFtUZ26fqh38OT36RYL4w
	1gKpIKjfMc58MPX7Kisq4nVmtAF0AsH/pEqLu3l72nHPpJ/rP5D7VolF
X-Gm-Gg: AZFdTZfWgF7OZQDg/RlXFMsPuVZ1mnfAqB0pEJOdc6Wlak0FkZk87S/P1SD6vsTrgom
	MW5PyqEKDQ1UhDGicjUceAMBak33rh+hCudHRnlgGrj5b2sWBqJUIfRzQMhlioV036dOISiOdx8
	iuWUDYQimM6Qj362IHkHJa4Zpc9Y2JdoxUG57LO8MjC+zB16Vw8nCcKC6DJmQRYIAPk/rDNuLUR
	YoeZ8gA3RvHIxLYbM2vNhd48QfkAqUaDEd9ClEshRDhBUQWfNIwh+qPgC/rgmZlXzSZZlmEmesc
	r/oBELeif3lNkETsZZa9SIS478hPSKx3315wkMe4kOV3hyMmYcEZINVRhGMpLzyR3RWeFmKmAeP
	6EZE2SBapyvpx2n0NizzjwthGKKA9PiIrmjy3G7gKF7hSHrw43mZDQK7YqgmoAOh7aDbJov9UKa
	2Rc/NVpCxcnTD0avFDExOw7ro/udCqqY6/vdWK+sjmjDaQ1AnfPJtpmE1fvgo5bN11uT8mZ1v/4
	DRJwVq7VWtFJt6ByYit38BCBMSapo0vNdcu8LKXpCzhT75NiUy7ocEk/jFV4Ay6t8VW2pwYnwOo
	44wCNj7OUqQpqKfRXKTGVHu9au871FE4NHDLNxu2vTmly327ccdIEy7QXV79m2qWROhK
X-Received: by 2002:a05:7301:162b:b0:36a:647b:2d7a with SMTP id 5a478bee46e88-381088b4313mr1778261eec.0.1794897982949;
        Mon, 16 Nov 2026 22:46:22 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38116afd7f7sm4712013eec.17.2026.11.16.22.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:46:22 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Mon, 16 Nov 2026 22:46:13 -0800
Message-Id: <20261117064613.771336-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check_extent_data_item() only checks that disk_num_bytes of a regular or
preallocated file extent is sector aligned. A crafted image can have a
compressed extent far larger than anything btrfs writes, and reading it
goes wrong in different ways:

- With disk_num_bytes == 4GiB, btrfs_submit_compressed_read() truncates
  it to a zero compressed_len and submits an empty bio:

    assertion failed: IS_ALIGNED(logical, blocksize) &&
    IS_ALIGNED(length, blocksize) && length != 0, in fs/btrfs/bio.c:895

- With a 4MiB zlib extent whose num_bytes and ram_bytes are above 4GiB,
  bvec_offset + bv_len wraps in btrfs_decompress_buf2page() and memcpy()
  reads past the zlib workspace buffer:

    BUG: KASAN: slab-out-of-bounds in btrfs_decompress_buf2page+0x3e0/0x650

Compression and encoded writes never create a compressed extent larger
than BTRFS_MAX_COMPRESSED on disk or BTRFS_MAX_UNCOMPRESSED in memory,
and its offset + num_bytes always fits in ram_bytes. Uncompressed
extents can be larger than 256MiB, for example preallocated extents
from kernels before v3.9 or extents from direct I/O writes, but they
should never get close to U32_MAX.

Reject a file extent whose disk_num_bytes is above BTRFS_MAX_COMPRESSED
if it is compressed, or above U32_MAX otherwise. For an extent with data
on disk, also reject:

- a zero disk_num_bytes, which makes btrfs_submit_compressed_read()
  submit an empty bio the same way;
- a ram_bytes above BTRFS_MAX_UNCOMPRESSED if it is compressed, or above
  U32_MAX otherwise;
- an offset + num_bytes beyond ram_bytes if it is compressed, as the
  compressed read path takes the decompressed range from offset and
  num_bytes.

Holes are skipped, since without NO_HOLES a hole extent has ram_bytes
set to the size of the hole.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Changes in v4:
- Also check ram_bytes of uncompressed extents against U32_MAX, with
  max_ram_bytes picked the same way as max_disk_num_bytes.
- Reject a zero disk_num_bytes for extents with data on disk, and an
  offset + num_bytes beyond ram_bytes for compressed extents, as
  Sashiko pointed out on v2 and v3.
- Skip holes for the new checks, as their ram_bytes is the hole size
  without NO_HOLES.
- Correct the commit message: direct I/O writes can also create
  uncompressed extents larger than 256MiB.
- Rebase onto misc-next.

Changes in v3:
- Relax the uncompressed disk_num_bytes limit from 256MiB to U32_MAX,
  as preallocated extents created before v3.9 can be larger.
- Also check ram_bytes of compressed extents against
  BTRFS_MAX_UNCOMPRESSED.

Changes in v2:
- Use SZ_256M directly instead of adding a new macro, and leave
  inode.c alone.
- Shorten the comment.

 fs/btrfs/tree-checker.c | 55 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..e7e0bb6be76f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -244,7 +244,10 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 max_disk_num_bytes;
+	u32 max_ram_bytes;
 	u64 extent_end;
+	u64 ram_end;
 	u8 fi_type;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
@@ -377,6 +380,58 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	/*
+	 * Compressed extents are at most 128K both on disk and uncompressed.
+	 * Uncompressed extents should never get close to U32_MAX.
+	 */
+	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
+		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+		max_ram_bytes = BTRFS_MAX_UNCOMPRESSED;
+	} else {
+		max_disk_num_bytes = U32_MAX;
+		max_ram_bytes = U32_MAX;
+	}
+	if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
+		file_extent_err(leaf, slot,
+		"invalid disk_num_bytes for file extent, have %llu expect <= %u",
+				btrfs_file_extent_disk_num_bytes(leaf, fi),
+				max_disk_num_bytes);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * The remaining checks only apply to extents with data on disk. Holes
+	 * are skipped, as without NO_HOLES their ram_bytes is the hole size.
+	 */
+	if (btrfs_file_extent_disk_bytenr(leaf, fi)) {
+		if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) == 0)) {
+			file_extent_err(leaf, slot,
+		"invalid zero disk_num_bytes for file extent with disk_bytenr %llu",
+					btrfs_file_extent_disk_bytenr(leaf, fi));
+			return -EUCLEAN;
+		}
+		if (unlikely(btrfs_file_extent_ram_bytes(leaf, fi) > max_ram_bytes)) {
+			file_extent_err(leaf, slot,
+		"invalid ram_bytes for file extent, have %llu expect <= %u",
+					btrfs_file_extent_ram_bytes(leaf, fi),
+					max_ram_bytes);
+			return -EUCLEAN;
+		}
+		/* Reads of compressed extents use offset and num_bytes in ram_bytes. */
+		if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE &&
+		    unlikely(check_add_overflow(btrfs_file_extent_offset(leaf, fi),
+						btrfs_file_extent_num_bytes(leaf, fi),
+						&ram_end) ||
+			     ram_end > btrfs_file_extent_ram_bytes(leaf, fi))) {
+			file_extent_err(leaf, slot,
+	"invalid offset + num_bytes for compressed file extent, have %llu + %llu expect <= %llu",
+					btrfs_file_extent_offset(leaf, fi),
+					btrfs_file_extent_num_bytes(leaf, fi),
+					btrfs_file_extent_ram_bytes(leaf, fi));
+			return -EUCLEAN;
+		}
+	}
+
 	/* Catch extent end overflow */
 	if (unlikely(check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
 					key->offset, &extent_end))) {

base-commit: d45cbbab23d3ca231771e4bff996a6a8118162cf
-- 
2.34.1

