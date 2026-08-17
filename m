Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F266431A37
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786972862; cv=none; b=Z0bxu+fIUN/nQR+yuegTUFloCYns364HjtowLvhUEi3hQsl5KY5NNjltyRS74ldyOF0yO4Vxf6VZg4WYqV6FWje+We2x5BoE0Fn9DKHd5hhIjrypCBUOkznORU88y9HpYBPzCDarnTS7q7Tf+CsctQAK1MWwJ8WOEE3RNyUhfJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786972862; c=relaxed/simple;
	bh=A0dpgGGaD7E+JzMUKW9jgv+RskM6OI+ISp/f2JOuZkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O5lyaiLmyPWCPLJC9dDj9gLsKJtP4WwzWng6ximGUjoxMOeQ/VHkFxhff1M7sU4fF+ayESEnVwPId07QzI88HG4H3XszZt4v/BwTdBxaX32KHpXSUJrMLR9qD7iKFmfyer6hJWRx87dhdHFrCH+3sEk5GxtC1rSbEmkGPS2EW5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T8L00sIg; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8L00sIg"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caf228a910so25689215ad.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 06:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786972861; x=1787577661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B1Uc7wojMG+g3MAFF5Q5D3MBvJR0GI+20kec6C9vh0Y=;
        b=T8L00sIgza12CdK8P0kqxcqwpIXD7WDDQCR+yXvUEhurVDNcllwjUwygHVYxHs+ZJ5
         M06k/NHJ/CBqrrMXdt6IPyYNchPeOmd9JP9RVr9a4y/R4GO2GnuyLFM9PnFr8Hb7/Uky
         IMc2xXD5cv+60M/LJ2Dqrl/ese2/13NNf70iE5zn6TQhMwR+oG/WoFIwEOm2IBHtIwXz
         j6q8OyBz64JWiMcp4MEhvoVIU0FyHGso0wZsba8HBVt33BFGy06/yQo44i9LqdIUotuN
         6pkDEG2QSSwLPP0fqx1b7Af6yWmWPPEgsD7JrTiNm3/1bp6jvW0+pdzl5NkkGRGAA7eU
         VnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786972861; x=1787577661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B1Uc7wojMG+g3MAFF5Q5D3MBvJR0GI+20kec6C9vh0Y=;
        b=Y6BEuu5WpuwgHNJlbhyLq1yy4Uc+hT4QYo76A1uP6dWrVfDzz/omh41j5RfzwepQtz
         TsGogSN2DhI07uhqkhDMR318BbtwPerR4DJ7gibZW5tqRW0EA3dGERYY04dRZ1HBmx5l
         jrrMD79LJSJLQtMeSdV0ZYOyMU1MSp6kQDytc7aoZ0j3JqhzUew5f2azDJtSqtdEnZca
         SCj+P1ZUZlYxLZUw+3QKJAEGCmU7tmVVz2yceAAJ34OY9yYsCi2Z3vlqjcpcNVeS+bfX
         yI+DZxahL10MKdYvGWYYOvZE+pty3JdyPoJ2IHdZQsbh2h2/tA6dxvOJyyI33fQwCBO5
         35YQ==
X-Gm-Message-State: AOJu0Yw6vgiKfx6AeYjLvcHV5t2UBQPXBgsug2QRuzBCRwTDCO6BEMD/
	m7Brj8R6KHynzZFa2CNXR+lJHGTwiEUZNGRGRQRRgBc04CpgVjrzXU8r
X-Gm-Gg: AR+sD12F+KhtfMcnBxoh1iXH/JMa/1XcTp4apEmk14a0hCXKcFgZAERLdBJi2n/BYjC
	/SuFzcvPtSkjNYcR1OFsQfhcento9IXxp30g00PqucqoUQYRkMhtPw//SBRR0NYlLFUPCuAVpDS
	iEKfqMZXcivvgT45rtbEE0FdQVYG4wo0Av04LJoHAeAbiDDbXneZEzIfeCCK/mYlrV06Tuv1mxH
	GbZMtIhU+WKJ6O7ssEleY0FAjRLy+tU7PKdIyRLUk/mJzawS+MLCrZQu0nbimoexSDfU4wUQcLd
	SiiA9BwfvD6/buOGQ+4vkBVvmEvEo+eGburIIlI7GLB/1rMHZd5EZ+qlFSCus6bQ8kcZzkr/QcB
	8pdemPEgHE24/JKD6F3my4fnofC8AnbosZn/bDr1pFVSZOCfn0zFxE9bPPg6edT89S8sYi7fWrS
	5+AVQa/q6Go5k1DtMq+7RZP4mhTtiiYCYQdkNau5EzIGy6cp9VR7zEeKjvStKIgq9l978H1QnQM
	4kWSTL8uvwpZLjZ/02xFG0zEwVlhw==
X-Received: by 2002:a17:90b:5805:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-3933b90d562mr25889790a91.16.1786972860581;
        Mon, 17 Aug 2026 06:21:00 -0700 (PDT)
Received: from gmail.com ([138.199.21.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3933b68adefsm4891951a91.3.2026.08.17.06.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 06:21:00 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] btrfs: send: reject extents for non-regular inodes
Date: Mon, 17 Aug 2026 21:20:51 +0800
Message-ID: <20260817132051.267646-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted subvolume tree can leave an EXTENT_DATA item attached to an
inode whose mode is not S_IFREG or S_IFLNK. During send, such an item can
be treated as file data and crash through a NULL address_space operation:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor instruction fetch in kernel mode
  #PF: error_code(0x0010) - not-present page
  Call Trace:
    <TASK>
    read_pages+0x80b/0xb30 mm/readahead.c:173
    page_cache_ra_unbounded+0x40d/0x890 mm/readahead.c:302
    do_page_cache_ra mm/readahead.c:332 [inline]
    page_cache_ra_order+0xa16/0xcd0 mm/readahead.c:535
    page_cache_sync_ra+0x5ce/0x9d0 mm/readahead.c:626
    page_cache_sync_readahead include/linux/pagemap.h:1379 [inline]
    put_file_data fs/btrfs/send.c:5224 [inline]
    send_write fs/btrfs/send.c:5291 [inline]
    send_extent_data+0x16b2/0x29b0 fs/btrfs/send.c:5715
    send_write_or_clone fs/btrfs/send.c:6135 [inline]
    process_extent+0x5d4/0x17b0 fs/btrfs/send.c:6504
    changed_extent fs/btrfs/send.c:7079 [inline]
    changed_cb+0x22f9/0x3cd0 fs/btrfs/send.c:7245
    full_send_tree fs/btrfs/send.c:7318 [inline]
    send_subvol fs/btrfs/send.c:7910 [inline]
    btrfs_ioctl_send+0x46a9/0x57f0 fs/btrfs/send.c:8248
    ...

[CAUSE]
process_extent() skips extent items for symlinks but assumes every other
inode with an extent item is a regular file. For a corrupted non-regular
inode, btrfs_iget() does not install the regular file address_space
operations. The readahead fallback can then call a NULL read_folio
callback before the existing validation in btrfs_get_extent() can run.

[FIX]
Reject extent items for inode types other than regular files and symlinks
at the common send extent-processing boundary. Symlink handling is left
unchanged because send emits symlink data from read_symlink(). This covers
full, incremental and new-generation sends without adding a check to the
regular I/O path.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/send.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index dca3570168c7..f88623bbc491 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6417,6 +6417,13 @@ static int process_extent(struct send_ctx *sctx,
 
 	if (S_ISLNK(sctx->cur_inode_mode))
 		return 0;
+	if (unlikely(!S_ISREG(sctx->cur_inode_mode))) {
+		btrfs_crit(sctx->send_root->fs_info,
+			   "send: extent for non-regular inode %llu root %llu mode 0%llo",
+			   key->objectid, btrfs_root_id(sctx->send_root),
+			   sctx->cur_inode_mode & S_IFMT);
+		return -EUCLEAN;
+	}
 
 	if (sctx->parent_root && !sctx->cur_inode_new) {
 		ret = is_extent_unchanged(sctx, path, key);
-- 
2.43.0

