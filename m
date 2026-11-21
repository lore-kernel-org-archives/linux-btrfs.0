Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795267526;
	b=jzfJXXDbsCMP0Z2YffhdIHHiL30PPyV/kKVJPd16bwzhljTuCJGfoFzoFaUz6xD/UBna
	 FwTj3BRYbY2MGP8AeOMr2FLEvmfiD05pGNGjq9DxCUB9G02T0QCJ8Fl0PGSD7QseveFnQ
	 saojxent/A95HFuyFcj+QE93buqGl+HCyUkSL1njV31lHYpI9uo1vRYly06iyblMIqDrX
	 aLHtaU06nMtwTVw5P7JhZBPbjPq8GycwZtVjGMa7a78E9SCHovLI41sx3rbiw+KTkWBxA
	 qIVsdlT+wyvPjIUIrYcYuGyB6+fcyc8PWRPHdO+04606je/qsLa5gcFSYiwpnvOVzMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267526;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Q64k/lxKzfUbYjglOjoXICquDEIU+gLL7GdLxP+v06A=;
	b=rLXD/46Rd2KI2sKSzbR4xnicQDSjhG3GfnB58fN9ckLO7Hyi2QZLs4Spb5iPn+oOJflq
	 iAMnphkza7E08fJtL/VLFNAHITL+APpwfDFMSPhFAJZahIVd/ytGzm30K+9a+I7L1TC4A
	 qg5pDSeDzVpGeayqT99tJd8O5JdtoGRy9IT1g8dFjBvd1tqS+FGUN8uxBoCH66+lcgZSW
	 t4VTmxupv98sCvWrOTCQ6cPbcbG6AcGJW0MfEna2BlkBQ+dexT+gYFlRSWG6SxaQu2aYD
	 sLwLxiYo1aztfCMLnB7M28haC4DSCGCVikdzn/G6OyHDNLpwzQACGs42PnRDTXjqTsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NmXWtpkK;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F51606A320
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 13:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5F51606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NmXWtpkK
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3917158eec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 05:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795267525; x=1795872325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q64k/lxKzfUbYjglOjoXICquDEIU+gLL7GdLxP+v06A=;
        b=NmXWtpkKy+eQd4Ug8YEo0iveU0Xhzt7pU1BSWIyhbuDOibVbXGfXYo6zAMZ+8AF/p0
         832gF4CNXO8aNvGRCgdoxwCr36AeynP11QOleUvX6jtUfgcd24b9v+nOtDnS0/L8URCe
         iZe/ohatu1exz3j3DYA20a29tznHk1V6g3qI75cTiyjJ/jKwOrBnCyEYaQO8Akj6w2om
         Q8ui349lmlnHJtAqOTtSUR7vwDnrMHyZe6EZ1Q4M0PJKD43QHun8oa5uIbFOB9NTlosz
         W1SXH1g3zYEBbQazE4zoocw3TLCgHzCiftncS5zt+Qx6VxzVNCRv4p7NCV+35w7V6ZMk
         oWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795267525; x=1795872325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q64k/lxKzfUbYjglOjoXICquDEIU+gLL7GdLxP+v06A=;
        b=qdgr+UE1P4nw94s52w9/MsCswTx0Kcl36fn8oGP/yPWB4/bLMZ9uHbQEXCWnvkmUSk
         9IL4GLonLknKKlYw3sB4xZNvUJTfInVF0Smu5fxn++wgEhF0btbNP1ifbKlr0rCAGeOU
         DfoFs+1Wbz0kgV/DOaa/dnJhgOW7LrY2RULPwHzZLQHVE55iciw9pEpV0rRhbuIzeI3z
         VCJT6gKz6CJoH8v+rwNtOAHqQWyflyM0zWus+raxoRigHbVUaasqzelsvOzjoP1rST6s
         EcouHonZA61TPvDmXsqkighhPqZNQPbbX84wLsEH5Zgg2NKPNKD5/5v59ibKi+r7VCB5
         10YA==
X-Forwarded-Encrypted: i=1; AL+hErHapqhZ+CHT5DQG+i9Q1uEreNXf4XzBDu/T8VFGoOxtKJudCZ3VqkePEcrF54Dfy4RMDv66n88UIb/zGQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9VrJZtz7QviHSoUuszr7+tUCbwvmLKKVbWMN4SlsWTLTPhBore
	dDh6uKoENAYqNesizkZ8ozp8YNP3zmc07Wm++i4KfqOmOFoxUAnuOccp
X-Gm-Gg: AZFdTZdLX4htqnlGFJLkL5lO3LPehXGQjej+d5uNERvL+KX10NQQJCxwpwuXrNWttOq
	6Xi5pjpoGB/s2XA3Uy+UVaVG3zLZT6izghuOEWQ6SCjnjGDxROLgl9i5heTimFrklsWcfVp7/PD
	d/z3ug6C4bJBP91ofuPsl4bQYKAV304OtqUTuzLakWqdFngrl2sNPUmb/lYDvzcESOHzSDwqfXv
	LeQJdgLK7HxTLaWJktrgFILOQNnt13LGTByoX722b8sKWRj3CErjj9Y7pamkOOR201d0L3SeF24
	MFQp6uEc/7ddLIMfUXmMbtvFv9SjLTFXR1j8gIUR4JSTVjVKbxo2i473qin1HSWRIFQDqEk59Vb
	rh0FkAZddK1S0zIIdQSqBPTjGO1GTgqa3s8eDsh8jVxONtZp/x35yx5NutQ7FzRiLabzVkUdfaE
	IbPrAPy3kt3dosQWY0HmEUz1Xb9bzFpy+BBdbzSRJtbdzT4vfWHNN/iLDfcsHbvCP7Bmaea6mki
	z6sP5iQxaOct9Qwyvrsbh51ZqC7dFfJhz88GnEEry18a34+L0/4A1oSwXZBiXu3ESn195R/qrlp
	A+j2ru1SCSvrFAEQSPOzsDbihAtQem5lzNUiMYnTdao+cCXBJ+1Uh+1Dai3bqtP7PG9C
X-Received: by 2002:a05:7022:b0c4:b0:1b3:b455:93db with SMTP id a92af1059eb24-1b5568eec9fmr6015203c88.24.1795267524795;
        Sat, 21 Nov 2026 05:25:24 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm15112714c88.6.2026.11.21.05.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 05:25:24 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5] btrfs: tree-checker: add more checks for file extent items
Date: Sat, 21 Nov 2026 05:25:19 -0800
Message-Id: <20261121132519.2182511-1-teel4res@gmail.com>
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

check_extent_data_item() only checks the alignment of most members of a
regular or preallocated file extent. Add the following checks, based on
what btrfs writes:

- An explicit hole (disk_bytenr == 0) must be an uncompressed regular
  extent with zero disk_num_bytes. Its offset is not checked, as
  btrfs_drop_extents() can trim the front of a hole extent.

- A preallocated extent must not be compressed.

- An extent with data on disk must have a non-zero disk_num_bytes. If it
  is compressed, disk_num_bytes must not exceed BTRFS_MAX_COMPRESSED and
  ram_bytes must not exceed BTRFS_MAX_UNCOMPRESSED, as compression and
  encoded writes never create larger ones. Otherwise both must not
  exceed U32_MAX. Uncompressed extents can be larger than 256MiB, for
  example preallocated extents from kernels before v3.9, but they should
  never get close to U32_MAX.

- offset + num_bytes of an extent with data on disk must not exceed its
  ram_bytes.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Note that before v3.9, __btrfs_prealloc_file_range() reserved the whole
fallocate range at once, so on a RAID0 or RAID10 filesystem with five or
more data stripes a preallocated extent can be up to the 10G data chunk
limit, above U32_MAX. Such a filesystem would fail the new check. If it
should still be accepted, BTRFS_MAX_DATA_CHUNK_SIZE could be used as the
uncompressed limit instead, as a data extent never crosses a chunk.

Changes in v5:
- Drop the crash reports from the commit message, the patch is a
  tree-checker hardening.
- Add a dedicated check for explicit holes: they must be uncompressed
  regular extents with zero disk_num_bytes, as Sashiko pointed out on
  v4 that a hole bypassed all the new checks.
- Reject compressed preallocated extents, also pointed out by Sashiko.
- Check offset + num_bytes against ram_bytes for uncompressed extents
  too.
- Only use preallocated extents from kernels before v3.9 as the example
  of uncompressed extents larger than 256MiB. A direct I/O write
  reserves its whole range, but each bio gets its own ordered extent, so
  its file extents are only as large as its bios.
- Change the subject, as the patch no longer only checks disk_num_bytes.

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

 fs/btrfs/tree-checker.c | 64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..0a99e628d37c 100644
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
@@ -377,6 +380,67 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
 		return -EUCLEAN;
 
+	if (!btrfs_file_extent_disk_bytenr(leaf, fi)) {
+		/* Explicit holes are uncompressed regular extents without disk space. */
+		if (unlikely(fi_type != BTRFS_FILE_EXTENT_REG ||
+			     btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE ||
+			     btrfs_file_extent_disk_num_bytes(leaf, fi))) {
+			file_extent_err(leaf, slot,
+"invalid hole file extent, have type %u compression %u disk_num_bytes %llu expect type %u compression 0 disk_num_bytes 0",
+					fi_type, btrfs_file_extent_compression(leaf, fi),
+					btrfs_file_extent_disk_num_bytes(leaf, fi),
+					BTRFS_FILE_EXTENT_REG);
+			return -EUCLEAN;
+		}
+	} else {
+		if (unlikely(fi_type == BTRFS_FILE_EXTENT_PREALLOC &&
+			     btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)) {
+			file_extent_err(leaf, slot,
+		"invalid compression for preallocated file extent, have %u expect 0",
+					btrfs_file_extent_compression(leaf, fi));
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Compressed extents are at most 128K both on disk and
+		 * uncompressed. Uncompressed extents should never get close to
+		 * U32_MAX.
+		 */
+		if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
+			max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
+			max_ram_bytes = BTRFS_MAX_UNCOMPRESSED;
+		} else {
+			max_disk_num_bytes = U32_MAX;
+			max_ram_bytes = U32_MAX;
+		}
+		if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) == 0 ||
+			     btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
+			file_extent_err(leaf, slot,
+		"invalid disk_num_bytes for file extent, have %llu expect (0, %u]",
+					btrfs_file_extent_disk_num_bytes(leaf, fi),
+					max_disk_num_bytes);
+			return -EUCLEAN;
+		}
+		if (unlikely(btrfs_file_extent_ram_bytes(leaf, fi) > max_ram_bytes)) {
+			file_extent_err(leaf, slot,
+		"invalid ram_bytes for file extent, have %llu expect <= %u",
+					btrfs_file_extent_ram_bytes(leaf, fi),
+					max_ram_bytes);
+			return -EUCLEAN;
+		}
+		if (unlikely(check_add_overflow(btrfs_file_extent_offset(leaf, fi),
+						btrfs_file_extent_num_bytes(leaf, fi),
+						&ram_end) ||
+			     ram_end > btrfs_file_extent_ram_bytes(leaf, fi))) {
+			file_extent_err(leaf, slot,
+	"invalid offset + num_bytes for file extent, have %llu + %llu expect <= ram_bytes %llu",
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

base-commit: 0e6c0a834a2329b3a2767a4485f9891348725c0b
-- 
2.34.1

