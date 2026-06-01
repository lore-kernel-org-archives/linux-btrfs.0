Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6E3AD501
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780323131; cv=none; b=Kf4cmHPT9WwstWVHH9zIMCPaXcOrkuiNtMWjVjvGnoV8BRKqjtmcHz1dzKevrlJ0VlHe3twpEMMADe1IruXFL/xy8A61zdMq/FaJnYmcTfrQF5z/g+OohdZn2YABo0MKhCS/4QGvmwE6QG6ONaw79U60B6oIfaQQgIP7Jh3eR5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780323131; c=relaxed/simple;
	bh=7NFsRasn8T3zyLqanO3jDYeY1SxFMHq38Y43WYMOIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TSAozkB7dvxmB4la3TMUafiQM7PY2sNnj0Z2K3DjGAnU4dDH8dkwnWaqph3rKaql1Sm1WQ17RkVIk/gEMdRaB1CC3MFGjY20463zgTlqiqAV5ytDWw600qnhMIPxR5Xq1CtNTiMyO05Y7f4uEVLJZODLzyvBQk09UUMRqy1hEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZ4+qZBR; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZ4+qZBR"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36bb3551f6eso3052907a91.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 07:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780323130; x=1780927930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BJkVFTFP++6lvX7D98bQzjb1G5a2yBkaBl1RBWQ2FC0=;
        b=HZ4+qZBRZVzTUgMLP0K5CSTOO9v0rSbMqWDFGETEzfLqsxR6FNDykhtzzbR1TSbLjT
         nXRAyNtrtFtZpivMRc2BBnCANrCFeiGlXQMtH/W0kDnqmDBvMo48rR0ELgHWSGx9Zr7h
         deUL/In7sEPUjfkCp6IYy8WUCF1ZZfJGcUSGBLgieBo2gBwLIAmfvxWKpmMc3hwQI76s
         v1wdS65VReoo5yHTm1O2mmqqbn3L93ukKLlmaHPP8UQwqp8UUmlTINV5xoVYbU2nLr/R
         kk0Y7N9n9RSl2lE1tyXDqOHJ7ptljJr1Dh1ricl8pbmTG62r6TpJ6fhY8gAtalvTnDk1
         BSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780323130; x=1780927930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJkVFTFP++6lvX7D98bQzjb1G5a2yBkaBl1RBWQ2FC0=;
        b=i5YfFwgkMLWa0SdyMX5JDceX/E6U1tSSAWiU3khhA2RNQxs2TZHyHllVtflfSQkH9t
         1a5nZl7/NOWc/WzpEB+WNyWZdDYDwBSSuFZn/1YMKEiCOZU5h/3G9iISlAbQKC8/RRxv
         B4Hcy0zBwXS+9y7c7WySQPxhpHGDm0UyduApsBJtzjNl9+HKBpQC9ijjzwDGzWCwXjaN
         2Ry+bdoX0oewIMcJfmjTawYSi7s6ZBDlVaTe42F21TV5vSfKWxXFiNXAobYb6UV9Ljuv
         MVwSvhGvLhqxBU//gsKpjAbCCpgtzahOMcmKDnnGM/jF5v6y23mSaSG9djh/bqHtVuVe
         uKog==
X-Forwarded-Encrypted: i=1; AFNElJ+ASMlcJF7XBOUG5V3p54vgwG/96r/m1E9wGfFlYMZdE65FndO0FI69MvLxO4dvJEG1I6GBnUkviVYwqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjdF5/d12RGWfUTQaan/QmUSYumhYbf/d9NdyuAyfTlXcJXw+X
	xkZZUcI8TqV5vnd3+2aAS78pWlct0iJhGdRoGfVcabrIhUaddBetzlzg
X-Gm-Gg: Acq92OE+8B+OtApscs7dT4BZmQkkIdKtH0b3/9Zq2s/LgvlPx7znErFDCdsmCjV8+An
	sHv6YtJI7GNvkcuU+I9GLjdC/d2Il1oONSM58mRkWLEWY00untoFaWrqzwpzz7SUyHgYfqCknDD
	c9fh316hrp2l5F+QYwjrwrNXYFxGi2lZ9Zww9qiNtP+ZRAbadXQIN/N09OcjS0UtngK0VrBimqA
	ecd2k6ikPiPBRkdJiwKntfaNOlB/NliGDTR1V0/l7162ct9a1OictMXtXlcTCAFdn8ydRin+Tjh
	jV2dwDc/kWJ1shOS+KGAcODGAdxtVNQLn7C6LnpAD2qqPkMR/FED57NDQLLmf8MmYix65Q2ZTZE
	rADtgpZ8rmJr9yXvtn/FJoA9YlblXsE8Fc6Oz0A3CROF49eVKQlMUYQjnzHSNPXkuOipieS2jaq
	iyB56cqWPrydCeGn2h
X-Received: by 2002:a17:90b:3e88:b0:368:341a:a925 with SMTP id 98e67ed59e1d1-36c5021a7c7mr12809400a91.23.1780323129515;
        Mon, 01 Jun 2026 07:12:09 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36dbe6ea489sm2820118a91.5.2026.06.01.07.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:12:09 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] btrfs: fix inline reflink deadlock at non-zero offset
Date: Mon,  1 Jun 2026 22:09:58 +0800
Message-ID: <20260601140958.1333017-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clone_copy_inline_extent() can copy an inline extent into a page of the
destination inode before starting a transaction. If that page is beyond
EOF, writeback started by a transaction commit with flushoncommit can
invalidate the folio and block on the same extent range lock held by the
reflink task, while the reflink task waits to start a transaction.

The copy_to_page path already updates i_size after copy_inline_to_page(),
so writeback no longer treats the copied page as beyond EOF. However,
clone_copy_inline_extent() has an earlier new_key->offset > 0 path that
also calls copy_inline_to_page() and then goes to out, where it starts a
transaction. That path still leaves i_size unchanged before starting the
transaction.

Update i_size after a successful copy_inline_to_page() in the early
non-zero offset path as well, matching the existing copy_to_page path.

Fixes: 05a5a7621ce66 ("Btrfs: implement full reflink support for inline extents")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/btrfs/reflink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 49865a463780..5722cccb53eb 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -185,6 +185,8 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
 	if (new_key->offset > 0) {
 		ret = copy_inline_to_page(inode, new_key->offset,
 					  inline_data, size, datal, comp_type);
+		if (ret == 0 && new_key->offset + datal > i_size_read(&inode->vfs_inode))
+			i_size_write(&inode->vfs_inode, new_key->offset + datal);
 		goto out;
 	}
 
-- 
2.43.0

