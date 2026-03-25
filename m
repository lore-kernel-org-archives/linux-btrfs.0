Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D43A6F01
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 10:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774433065; cv=none; b=WyJORcFD0becq3lzBPyOJ7HsxM46DEOD2ekyKP+W7T5QZWEM47q7brCTfOdYseaeS9YpXMvgUKfXE4izoBKrFLBwLqpHOIcbTd+Co3qF1Ep+FuK1PDi8COwqxf2vaim/zjmq2XeJvm7hlzt6A3ydOgt7Z6obYgJ6/MfXL1Ngr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774433065; c=relaxed/simple;
	bh=cx6cZUtWXnbgDAYqH526B/SLiBF37AGCrp7peFlOGM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tZpdzx/hg42AtNygV7TCTOiqEj3pNAWEEVmPQVi/Uaf/Ybz1z3ED8sUOLXjFtpGTS6K24GNsJsQxAbKjubk3k3L/R9a07I7wFCle1DHpLDLF8AZysMT866kyZkokUN4Xsl1H0xCXHpDmIUtyTqZyVEYlCv51Sd66+qIXD/UDCRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WE5LSPNl; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WE5LSPNl"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35c0e7b751aso607923a91.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 03:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774433062; x=1775037862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Anl9pp+ZGMXwC7XIc0DqbvO58qkRpPIzKB25+EU45M=;
        b=WE5LSPNlijQ9V9GdFrPQWtfVlBIzpN2/cdEGTbrsBdzE/HzSNX2H3idvqrOZAn45eY
         JlyHP8LTsgTADfhB2ca/5YZFFFVWR/8C0ZDdjBT7w4tT+8MAtK85jYuLk/smKh9j+uOp
         aevef8WdOwksgH/uFraG17sCBQLd0cfSUNaOY2WlQQb1rw+m1yLHIDNhB6YNiG+z/Rrk
         BweGeux3j2YoqDoBEHzv9apUQkDEaATuWRl2km/M3cq/TW6vM9C/56w8bAEz9C/db+nA
         kDPsEyCGPcCn5NnwTHP0Y3nbPt1svtkdWnwfkcKyqr29f7Pyyua195E2nHk7trtcBBF7
         ZCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774433062; x=1775037862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Anl9pp+ZGMXwC7XIc0DqbvO58qkRpPIzKB25+EU45M=;
        b=swo4KA0nGHmbLS5zBOoSUcIHOxZwpV5HwIe6LeAARH+dKi3JLdjTACGxQ9TcjOWk46
         87b/T0gqV9WaPiRacSygpB3KzpTW2RQ4yfcRpJitnfw4chRBYkWunT9R4Oy0ESuYTq84
         3NpJL0Wkdo7yjDZiTFgKkqyTU4iU1Cvv8uJvcmxNNlg+BES3QEdh/fIdWfQbUsKktDWB
         k++8rM9rBNFEQdckK4adHUT4BiW7H9hHxNiDabhRVyaVIYwOg2oic0CEGq4wnYwdyQtf
         fbX8f1wlpp+7R0/rgHJN7dZPx+ATd7o/4ckByfaKkk1htHrRpOlm36+VT1WyGmTerWeM
         IOBg==
X-Gm-Message-State: AOJu0YzykmnpHaLBIcKZyiSm5zuYvFJ2htpVlCMem9+3HFm1L2+2Sq9Z
	UkhrNba24CoI/6wBEoLZTVKm13rL2SDrBo95c9qgcDdb9HwV5986xZjr
X-Gm-Gg: ATEYQzyK+ZAQkLxskv2S3vwWeHLg9ocDb9WKV1GqIqzbJ8RiHbeAYq+fnGTCn0Qa5/y
	zsJNkscHfoMIGTUxHH16UeVd/8bVcNtXCVieC8P8fQAQXplvY9d/lIVdCZlXnVFH+F2uMEUquP0
	jQ4eD8bpbLLtd2bsd1naDd2XI2M7I32LbdezwAy9PLiWxPbZIF7m7KHUc2/SHwiMmfvPzF7jAOM
	84mCA+LUxF5cpHf2QVOs60+mxtr3l9E8fTEnURWxnexhwQ+oorxwXblPtHUA8hoTzfjiyPBJN4o
	Hu0mXKs+R43TIPuw/VospJSJX+qTPVTBqYNBCnZAXjLrNkLJpQGNJkr7vUwHjQmlwSgerL0bpCv
	mBt41itmzbg8pQYKonCvpe0rDtGu9WJnePzbOYJESqGNo55yVxsfwmmRyORqC+0GjC95QOcAKi4
	TsAng3/DNessAMoYsNqfYvkuDseqL6n2ik09tVNDb/jXsrZnUE6FeCkHY853bT7oUSePpJn6M=
X-Received: by 2002:a17:90b:518e:b0:34c:904a:d92 with SMTP id 98e67ed59e1d1-35c0dd7a69cmr2484525a91.26.1774433061926;
        Wed, 25 Mar 2026 03:04:21 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c11deb26esm1398670a91.12.2026.03.25.03.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:04:21 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	anand.jain@oracle.com,
	wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] btrfs: disk-io: reject misaligned tree blocks in btree_csum_one_bio
Date: Wed, 25 Mar 2026 18:04:11 +0800
Message-ID: <20260325100411.2483356-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running btrfs balance on a corrupt image can trigger a GPF, with KASAN
reporting a wild memory access:

  BTRFS warning: tree block not nodesize aligned, start 6179131392 nodesize 16384, can be resolved by a full metadata balance
  Oops: general protection fault, probably for non-canonical address 0xe0009d1000000052: 0000 [#1] SMP KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0x0005088000000290-0x0005088000000297]
  Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
  RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
  RIP: 0010:btrfs_header_bytenr fs/btrfs/accessors.h:647 [inline]
  RIP: 0010:btree_csum_one_bio+0x175/0xfe0 fs/btrfs/disk-io.c:263
  Call Trace:
	<TASK>
	btrfs_bio_csum fs/btrfs/bio.c:511 [inline]
	btrfs_submit_chunk+0x138d/0x1750 fs/btrfs/bio.c:744
	btrfs_submit_bbio+0x20/0x40 fs/btrfs/bio.c:814
	write_one_eb+0x9ea/0xd30 fs/btrfs/extent_io.c:2239
	btree_write_cache_pages+0x836/0xdc0 fs/btrfs/extent_io.c:2342
	btree_writepages+0x163/0x1c0 fs/btrfs/disk-io.c:512
	do_writepages+0x255/0x5c0 mm/page-writeback.c:2604
	filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
	filemap_fdatawrite_wbc+0xf2/0x150 mm/filemap.c:379
	__filemap_fdatawrite_range+0xd2/0x120 mm/filemap.c:422
	filemap_fdatawrite_range+0x2f/0x50 mm/filemap.c:440
	btrfs_write_marked_extents+0x13c/0x2d0 fs/btrfs/transaction.c:1157
	btrfs_write_and_wait_transaction+0xe5/0x250 fs/btrfs/transaction.c:1264
	btrfs_commit_transaction+0x28af/0x3d90 fs/btrfs/transaction.c:2533
	insert_balance_item.isra.0+0x392/0x3f0 fs/btrfs/volumes.c:3712
	btrfs_balance+0x1021/0x42b0 fs/btrfs/volumes.c:4582
	btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
	btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
	...

[CAUSE]
The corrupt image contains a tree block whose start address (6179131392)
is page-aligned (4 KiB) but NOT nodesize-aligned (16 KiB):

  6179131392 % 16384 == 4096

When alloc_extent_buffer() is called for such a block,
check_eb_alignment() detects the nodesize misalignment, but only emits
a one-time btrfs_warn() and returns false without failing the
allocation. This allows the extent buffer to be created with a
misaligned start.

Later, during transaction commit triggered by balance, write_one_eb()
submits the dirty extent buffer for writeback, and
btree_csum_one_bio() is called to checksum it before I/O submission.
That path calls btrfs_header_bytenr(eb), which expands via
BTRFS_SETGET_HEADER_FUNCS to:

  folio_address(eb->folios[0]) + offset_in_page(eb->start)

With a nodesize-misaligned start, eb->folios[0] does not correspond to
a valid direct-mapped kernel address. folio_address() returns the
garbage value 0x0005088000000260, and dereferencing +0x30 (the bytenr
field offset in struct btrfs_header) triggers the GPF.

[FIX]
Add a WARN_ON_ONCE() nodesize alignment check at the beginning of
btree_csum_one_bio() and return -EIO for misaligned tree blocks.

btree_csum_one_bio() already guards against corrupted extent buffer
state on the checksum path, and it also revalidates metadata on the
write path. The alignment check follows that pattern and must happen
before the first access to eb->folios[] via btrfs_header_bytenr().

Fixes: 6d3a61945b00 ("btrfs: warn on tree blocks which are not nodesize aligned")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
An alternative fix of promoting check_eb_alignment() from warn to error
would prevent the misaligned eb from being created at all, but would
break mount and repair workflows: users need to be able to read and
inspect a filesystem containing legacy misaligned tree blocks in order
to run "btrfs balance -m" and correct the alignment.
---
 fs/btrfs/disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0aa7e5d1b05f..5ca9e63e51d6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -260,6 +260,11 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
 {
 	struct extent_buffer *eb = bbio->private;
 	struct btrfs_fs_info *fs_info = eb->fs_info;
+
+	/* A nodesize-misaligned eb has corrupted folio mapping. */
+	if (WARN_ON_ONCE(!IS_ALIGNED(eb->start, fs_info->nodesize)))
+		return -EIO;
+
 	u64 found_start = btrfs_header_bytenr(eb);
 	u64 last_trans;
 	u8 result[BTRFS_CSUM_SIZE];
-- 
2.43.0

