Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794804350;
	b=zN0rzi8NpOdZVDUG0XDMpeXNE4qLfy6G3kPj5wR82uOoOj7mqqXgGOavPzbeyJD6yS/k
	 2UgqjunSxVO6dJo79ik87YnNG+NSxtctHmpSJ/zO2/OINKrpNFYtq7MbB+e5klGnrAndI
	 CkLVgMT8h8dLtt3yeULHoSNIauF7877keklPZE83Rhxp3H79TsiMAIOghQGmO2Gyziy7W
	 6GkU1Jh/UsfunyQZ4CquvCMlPnBSKy5eF2dYcSnvoHiLoIvNOn5YshD0eO3LIfCt4A8CK
	 hGK2BykOWxYu6tVq0pxz5rfW9vgI8LlgQ10TCHTZ8OPA2iWaYIRIXvXVSoq9q9VJymA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794804350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UGuM+GPpkioXjAM+mOf4pqTWILy+sZBNY2NJm0f6pw8=;
	b=dI1XDUcEG3W9Zlv9alX0uK501ahNy39yTHVSEI1ndrlBj+IJ1vd+SHPZKS3/7DK1Fa/9
	 mJxeKugMbViuoV8Hn3D1C6c/Tr375at/zAuzynNOJL0Qoas+INS+AxJUwWBxhK58qzEZX
	 9QDM+mwApFaPUbBKvlQ6K7MR+RGJMiXxV4TmlKTSYHnbLNUVOzxyiGsp2X8HLBBYn0jMO
	 92CRO801EbhPBGcmO2QDVCpD92AAVM1QTbU8Z9OEZ4ia/18j5vRiZSnFVKB7u3/2bHEPU
	 byEyXOxFWY/zUSIXfRJlHIezmtv4Z52oALWRYlA868jnE6bTPLDXiJUbMzvKFPBQzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="0EDANjT/";
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE168606A31F
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 04:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE168606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0EDANjT/
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-37198ed3727so4583202eec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 20:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794804349; x=1795409149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UGuM+GPpkioXjAM+mOf4pqTWILy+sZBNY2NJm0f6pw8=;
        b=0EDANjT/a6/tIlLr5krCZTGw+nZr7wNl/9kxqE8XxywgSfc7DKpZ6dyvgHZ7OiA32a
         /QK0SJ/nhzxdRl8zEv6kroRO8DydgCi7FFHJbXdRTjWOWNZSDgSOXO4eUq/j7KbrFOPc
         cHPM3b1JG1hlpyMoSpObqbvjkoglB1tLVISIQiPcUB4aGOokJMdMPN26Hr4qvlFhFLTr
         4xHDwfjJrCn0BfkSEZYcp+pn9g+WC2KIee19UeqZkytzRdeqMQ2cmLoVq2aRji16DSNr
         nj0SMvELgDd1OOV3sh4kmSQgeHDyN7XCPmgHp4EvOwJA6rT8rG7faPkznZLleDFSqmGc
         JHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794804349; x=1795409149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UGuM+GPpkioXjAM+mOf4pqTWILy+sZBNY2NJm0f6pw8=;
        b=RE+M2exbkL8o/dF7OwbhcHnJN83i5BbHASxvHuRYXWxzoz2yfox0uHQmCmPSbu8Cqy
         695y19qxUAhhtIdWtmvPcxY8m3+JqyVZjEjOjXUkH5MJ3lrX/KBU8GTSMgSTTEVGW86a
         yoOKP6k2SUzoV7P6fj4C2ANoER4gZHSsuGvj20IHSp8I3iGYW9wqvr8jdwiTLzuMYeGg
         /2kAeOmRMPZnnzH9pEeb8OQjmrYeIaW4NhE1TwqGnZdihGYr6UqfBF9IE9ymc1BQaKD+
         EFJcZcUSnRnDXFUacc9PlGA2R2UnvwMWKQu9bA/bzSu9RSyT74SCA4Qpz/e+8HdHb/49
         nFlQ==
X-Forwarded-Encrypted: i=1; AL+hErEVE9QDuHRzxysVZb5AdrIZq1DrYezJlF34tOgHK9NYgpzqxFq0BJWkgcVoxtDspbZkkCVRuWtYIdeaow==@vger.kernel.org
X-Gm-Message-State: APuU4Z+WZJNZi+r/Of3C6mZQKbittFEFnqJnRpXyY0ANkVo+slxNK9XT
	vuWkzwYDws3ZlxFe6ccqoEG4Nw8qKcSr/AFmFHvHaIjFe9GRsYU0hble
X-Gm-Gg: AYBFou2jfkfwyuTtAjJdI2FGJTcFJAMUDhiYpPVXFW99D23o+AxlyOFWfzOqDqmoZdp
	OKBHdnuQ+3WctN8sUQ3Tp9n4lB+Wbl/EUsdfN+Un/jO/dhWjEdc/194V03Jhuxph8aGyPHRm0fY
	4fy0J8vn3j6m2ap0GJ6arJccKEoTlpWk55R7qKxWv/qGL3FHhobbBRI027Bqj/v1HQV6bCls5z6
	q08fATqqEmGmvcseyYmtn5OhcgVl63oUudsDyvp3gZuJmu7nlqOGUzYLfSxfSfVDMmGc6O6uZ56
	/rWBBkfPGYJATzKRf/EMcqFHTW9lAHeAPR+1G2/lm8HPjPgbOS31keCngyZ491qh5W49naipq4D
	WvdAeylUER6Nw83rs+Rz8Sdmo9xIbKEIinSvMbz+CYeZRztg2JqAuNJSBS7OUsVP72JXDaD4wDM
	ABZ8k42gwMRBZc8TOtKmBgvHe9i3ySwnkMdsIx8W5pNhXZVfJU+Hf5wjTolCFKV8PKhTrKGq5SJ
	Holi+qVwLkqIekEWMsrFOO0m2yPMe0rb4yUc7gddpMPsZMlbtpj4zqGy6mVkr7LB6edxRivpgCM
	jmujJLAT+XCbHMNPlimYU0NlQmkUx/aaLgLJsFUrTtoHvxG1kr/e97AQX/WQ/Ay7xFPK
X-Received: by 2002:a05:701b:4549:20b0:1b4:facd:5311 with SMTP id a92af1059eb24-1b4facd5aacmr10402552c88.8.1794804348767;
        Sun, 15 Nov 2026 20:45:48 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5329ec87bsm2649066c88.0.2026.11.15.20.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:45:48 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Sun, 15 Nov 2026 20:45:43 -0800
Message-Id: <20261116044543.282187-1-teel4res@gmail.com>
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
than BTRFS_MAX_COMPRESSED. An uncompressed extent is at most
BTRFS_MAX_EXTENT_SIZE for a regular write and 256MiB for preallocation.

Add BTRFS_MAX_PREALLOC_EXTENT_SIZE for the preallocation limit, and make
the tree checker reject a file extent whose disk_num_bytes is above
BTRFS_MAX_COMPRESSED if it is compressed, or above
BTRFS_MAX_PREALLOC_EXTENT_SIZE otherwise.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Report: https://lore.kernel.org/linux-btrfs/20261115163724.226922-1-teel4res@gmail.com/

On v7.3 both images from the report are rejected by the tree checker
with this patch, and 256MiB preallocated extents still pass.

 fs/btrfs/fs.h           |  3 +++
 fs/btrfs/inode.c        |  2 +-
 fs/btrfs/tree-checker.c | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..c65051a9f018 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -72,6 +72,9 @@ static_assert(BTRFS_MAX_FOLIO_SIZE > PAGE_SIZE);
 
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
+/* The maximum size of one extent created by btrfs_prealloc_file_range(). */
+#define BTRFS_MAX_PREALLOC_EXTENT_SIZE		SZ_256M
+
 /*
  * Maximum length to trim in a single iteration to avoid holding device list
  * mutex for too long.
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19b1eba2dd84..3f8889378d6a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9175,7 +9175,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 	u64 end = start + num_bytes - 1;
 
 	while (num_bytes > 0) {
-		cur_bytes = min_t(u64, num_bytes, SZ_256M);
+		cur_bytes = min_t(u64, num_bytes, BTRFS_MAX_PREALLOC_EXTENT_SIZE);
 		cur_bytes = max(cur_bytes, min_size);
 		/*
 		 * If we are severely fragmented we could end up with really
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..6e57f5969bf9 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -244,6 +244,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 max_disk_num_bytes;
 	u64 extent_end;
 	u8 fi_type;
 
@@ -377,6 +378,23 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	/*
+	 * A compressed extent is never larger than BTRFS_MAX_COMPRESSED on
+	 * disk. An uncompressed one is at most BTRFS_MAX_EXTENT_SIZE for a
+	 * regular write and BTRFS_MAX_PREALLOC_EXTENT_SIZE for preallocation.
+	 */
+	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)
+		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+	else
+		max_disk_num_bytes = BTRFS_MAX_PREALLOC_EXTENT_SIZE;
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

