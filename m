Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794883128;
	b=jz6dPUYsn2CXmC9hnEUtHYR6YkUsKlmFrOOU9SfLIRHqI3G4sHvFdKOlAiPzCpCcleTh
	 /3fyTmsz9vUcSLdaE/EP063O++k+53gicvPdgC/6/4U80fTBFSfAxDrARxD4AgVlpBskW
	 ql3F8cnkf0Tw7yZfZiGYrNK1NC69ZVE6yARN7olZz82wsL6NCdB7a2PVWWxFttNZ44UiZ
	 uMI9GjcTpsrUTxDg1yJ23fyBOwD19LXkccPyqHiJDC/S+Qj9y+U5QXtfBIxW+ZOvZDWI6
	 Oj2AFC44UU9zwuN6EMFSMpK8nEG/oAx8SSC08LAla0jQlTONX7ZfGOGJLCFjmLMWQWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794883128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K13RmILmom/RrxkaTM1q3j27D29seBkDnjVNn1mUC7o=;
	b=jz6MJ2dS58PiBL2DVvCD7asi3eu1+/KcTxOhdcYraJtizw3dYS5QILWAIR9nAK70bvff
	 ChPmqpWFjxbMaJy+zVDfHflcPr6XemkReIDhqEfM5iHSA3vJleOfVdeeyxVElXDTxUSCn
	 8A7sV5DqN62esO2H5diojBfVq1s20OWCH+h0IQbdFH7eVj4v+r3iQalUoQtjSXtEXniDr
	 JlwcwPR/yaMXuYbtPIao/KfCr6GZyrmqcsm36qWicLocwQGLqKEaEWs9Y0UwH2KUvRpMo
	 FI6L19cUaS1cqT88/vtzM2mctI/rw58WW2nOrkN4W70ZbvTQhOjy40BJV8KS13s1ZhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WsNY8vmE;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7272606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 02:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7272606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WsNY8vmE
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so7886928eec.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 18:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794883127; x=1795487927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K13RmILmom/RrxkaTM1q3j27D29seBkDnjVNn1mUC7o=;
        b=WsNY8vmEneldOkBd4RphBF+JS9qgAPJ0O0VqBb71kwjMe8uuUZK+qOnhMsfyXeDKR1
         w6RSMYgI764tQzPZ336Ok63c96B2i6IoBax7WbzlKBF7I3rL0M1ogAjvo4vx8u4qnn0j
         2vpGdAQP73MVmGnlCz5rDbWWuAeNwUNZHAQdfYS6FRkuUJ56T8CcSm42fs/gipXb0bk2
         WxYr/c3Xr4GxnNhJfy/Ts+05t+W0uTZIwb73rpQ5qlhlnt4MVIKlcJXRUZNqrezrY6RQ
         PYELZJMxcNiekzn2XEb+lp9tHc1pHNQh7LAu1/L1TN1a73vDBlSdf5U/+QvYUxUcycAT
         r5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794883127; x=1795487927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K13RmILmom/RrxkaTM1q3j27D29seBkDnjVNn1mUC7o=;
        b=s0mogVR+0B5zo9C+nqaYY17W2fBHHCJaDIVumWAXzDVDs2FfTLEjKhbDTZV9bs9AOG
         yH6tAE9OtTvqHtpWI6Sz1GCtrjgZ0I53qt9IR6wAYhzfwE/dJLjRti5zQkgcHNDnZoT8
         KJr48VcGYuZlQJxVcfWCuNSHeU8si/SGKI+8/oezBKJLyq2894buJcqxW1mGfhC7l6Oe
         RKcSP/yRAafEUSM8SgsulGNgc9z3Wyzwch3JaK1PYfUe0xkiClXetyyTw9Re0SBMSoS7
         GTXL+IJ7qF1jzFaD1GTbqEaJmNqdn6loCxiaxrwF2wxdP+deNtzKuV4cKKFzmx7G0d2J
         y66Q==
X-Forwarded-Encrypted: i=1; AL+hErG5Ddbtckpak+YMiLWi41Xo/Dn7cxgJK+tHs7V4rC9G3Jz/dEI5FFsnj4/w47/tUEfgOnCY9lMpbF9n9g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/LVSNHQXik+++RI+FQiX8v2rgYcSpQqj/QWT81K3foD9C/Zqch
	3kRZvgHwB4mudiCBPhi3AN+YP0q6Zy4HI05dEsSn6/9Wbhasx+tznUC+UcKScPEt
X-Gm-Gg: AZFdTZdvzCplXi9/bE7de1TtrdwO/mp0sXbGtxSg9SrxceJDAYoP3orDMlFmTSCZHPF
	QAl6PCrBPJbmo8y56W5u7nSnRW0g3zu3XvjwDNSGZxxMxfIH1vYvMa5GuYAJwxXlWrZG/nLcbgT
	aNSkQednulukRTyFlAkuelHQQvj6710pigS+WBTLgBZyHdpjCBIKEHcRAiATTeu6kzjTWpbt+d7
	T5eE4G/a78/ZA6SkwNXdhDyGOwEffp4GM3IbWaUpUMw0+FY5E3hvoHy64ITze3Ck3tHawlfsNtb
	ZppMs0DuQkLkmKFh8OqEI+q91KCRhpgN8KqPYQKZ6XHJDPND8V9IIytuv8QQoRH3SG3ApVfXt8x
	h0fgOwf6dIa6RUgrJFAUfAGlt8+kO51VX+j9ZRz6RLIioLQHoJRwQhc+Z07QhNkHCKzrUDHPlj+
	0XAxrYajdNO/0CNp8DmW/rE9oHnFZI4QRn+fwNeRVw8aBQRg4EGjCrs9XU4dTB684a1vvCi30b4
	3rJNbv5V5ViLaKpROnv2vdeqJLipFWarbzfAgweiePKfJglBkbOgKMFeYAkTCrQhsMEUxnBak0B
	IN2vzThgeKJlQMtxmqAZWfNnrGVLSDWaMyRg/LVD5yhD2t3TtsOezsod22PPPgLl7gEy
X-Received: by 2002:a05:7301:1625:b0:36e:aa5c:7851 with SMTP id 5a478bee46e88-37966d40c48mr13047282eec.27.1794883126757;
        Mon, 16 Nov 2026 18:38:46 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955a1c5c2sm39022023eec.14.2026.11.16.18.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 18:38:46 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Mon, 16 Nov 2026 18:38:41 -0800
Message-Id: <20261117023841.467366-1-teel4res@gmail.com>
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
than BTRFS_MAX_COMPRESSED on disk or BTRFS_MAX_UNCOMPRESSED in memory.
Uncompressed extents are limited to 256MiB since v3.9, but older kernels
could create larger preallocated extents.

Reject a compressed file extent whose ram_bytes is above
BTRFS_MAX_UNCOMPRESSED or whose disk_num_bytes is above
BTRFS_MAX_COMPRESSED. For an uncompressed extent, only reject a
disk_num_bytes above U32_MAX, which should never be reached.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Changes in v3:
- Relax the uncompressed limit from 256MiB to U32_MAX, so preallocated
  extents created before v3.9 are still accepted.
- Also check ram_bytes of compressed extents against
  BTRFS_MAX_UNCOMPRESSED.

v2: https://lore.kernel.org/linux-btrfs/20261116050922.310476-1-teel4res@gmail.com/
v1: https://lore.kernel.org/linux-btrfs/20261116044543.282187-1-teel4res@gmail.com/

 fs/btrfs/tree-checker.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..e5d17bf4051b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -244,6 +244,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 max_disk_num_bytes;
 	u64 extent_end;
 	u8 fi_type;
 
@@ -377,6 +378,30 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	/*
+	 * Compressed extents are at most 128K both on disk and uncompressed.
+	 * Uncompressed extents should never get close to U32_MAX.
+	 */
+	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
+		if (unlikely(btrfs_file_extent_ram_bytes(leaf, fi) > BTRFS_MAX_UNCOMPRESSED)) {
+			file_extent_err(leaf, slot,
+		"invalid ram_bytes for compressed file extent, have %llu expect <= %u",
+					btrfs_file_extent_ram_bytes(leaf, fi),
+					BTRFS_MAX_UNCOMPRESSED);
+			return -EUCLEAN;
+		}
+		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+	} else {
+		max_disk_num_bytes = U32_MAX;
+	}
+	if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
+		file_extent_err(leaf, slot,
+		"invalid disk_num_bytes for file extent, have %llu expect <= %u",
+				btrfs_file_extent_disk_num_bytes(leaf, fi),
+				max_disk_num_bytes);
+		return -EUCLEAN;
+	}
+
 	/* Catch extent end overflow */
 	if (unlikely(check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
 					key->offset, &extent_end))) {

base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031
-- 
2.34.1

