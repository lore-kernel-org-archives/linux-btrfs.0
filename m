Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A426346E7A
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112596; cv=none; b=DLaCCP41bkI4ipFiBEr3jX1wBJMeFC9PYAYFTQTuy8TZcFqX+ADxzpXEJH0+zM4SlRDoOnFQHdeZ2rJpGews8Y1SRveKkuERkfiG33Iimsb3EYEEav+pMmPZF9BQRfW+owOdYVMWJ20z/zyH0jat870PyfrzXzPSyfhAgefzf2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112596; c=relaxed/simple;
	bh=XZfnN6ZNxwHS7fU7g8TzTldYmgQ7NvyTpBuR7s+jRiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k1EYuTKULRza6h0HtTJGcQMyg0+jy7aACtFDZP7DApcxllQCErUysOIji9HMW6u2MWb9Cy7WqGLyckr992Po47DGaFyKJCncj06Tn0lNjOG5xqbAji54oKFLYGWa3qCPksZcAD20WPaF7OnUJEcnOaqZ+OY6lU+tFw+dbQ2r8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=iIPkiBf8; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="iIPkiBf8"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c0c2a68d01so47673035ad.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 10:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781112594; x=1781717394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3wRjusoj4yCY+EA/COKpBZREn13VScyeq7V5TJXl1HQ=;
        b=iIPkiBf8wOUpUGeI/cO5DAFscFSswVIaBog7Lqete9fNfmopPLHUuHAlR2BdrxAtFs
         TO/Sw5DZoMfi5msVA+5072uOc1HNeaDrmugg9PEDgIEm3wrGENRBTT+o3PuBadoldHYl
         Q/UcEXCYNJgkdankAyv1KoBWFY8VrIWI53nj0TKKIGiBsOi3+aiylk2uwLol9i5dWV5F
         cL9Ldmw0177CmxEo+vvlmdDC2YsOTqO1OaMCHaEoXrh8LmVaBk9chIxdNYLBad1AzPtJ
         oNh9q8b8OfYCbCgqyMF6E8GEv69ZTJ3zdzs99IfQVW14FvpIW8sDPxNSeOjkasz8k73M
         kzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781112594; x=1781717394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wRjusoj4yCY+EA/COKpBZREn13VScyeq7V5TJXl1HQ=;
        b=DYMPw0jT9+pTl54e18kYFl9R1+08WTjVo7YAPaP9F9qwfSWtbj0umhIbmMFg6C0olw
         tguM6zQGxTeCp0679ee5tg0YoeLeF0DDVT/QbcNl1k/3E4g2UYwMn45rg4nnnXWvqm0X
         Gjhu1GQPPoHGdjReFxdHgcYOyehJa7GdQPYDLE2rRnvgrKNvi6xZOtSCW7cLOLLkRpFb
         czr5U5fIc8ImLlo/t+YpmJDlZ0YnBWCuzYpL0L2ufVFmwD8/FvFwwTfykGCZC7aew6Zo
         90399bzNVT5aNhMAQiIHpRkeB5aSHsfnffQncUOYYzGpVIyLDO2WWdViAd5gxUslkI4x
         dyPA==
X-Forwarded-Encrypted: i=1; AFNElJ9U+CXz0pMCXri/9085xHkVd6X7odenOTulBKJjbnBeKScO+9uQ08hfgfVSX5CQHnp7itFmHzD5ea+NqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwStlPmYICU/pGhYJ1+8FNhMnitmsqR2uxqfm43FYfIfUbwNE/E
	KFdzGYyG8SfBum/Expuvct6qvAIXRGlv7bII1ksbcIn2u84S1niz5ZoiEBhwa9V9IA==
X-Gm-Gg: Acq92OFEl9ZROCQecXSu8yyE1ENqL0q+vegcqOsZLu7PyqnQJNDqIJbIbEWVVMI+/z4
	lJzIiaE3KfV0c0Fy7U2IgaOywoXO+VBYLcnxzs/B7O5eVF7eYtB+qV0Je3JVsjN+Zp0IGy1O0mY
	d5HG41b06f7utSMHwjRZSezpI8Z9HSaGD2C0tM2r1y6XBfknEUl9Eyk+Qqu9L+N3+lIHWPP559n
	dmgcTUUSF0iuwqg0w5HEM33bJOC5vYrriIVN8ZdLQG63rfo9EwUv7IPFuaPnE9trxcVwxpkGebE
	Qdx8YifugKXDvtn/xl+EHfk7y4TUWtJYGKZvxu6TTd1b+kHrbuRmMRMTauImOF44RdlFIMcW0XF
	+RgiNJG/kheTmTYIzIitFXpNbDGFoof+vp5oclfk7+JwB3ob5WTFXZotqlro/1Rb8OzGbsPyQxZ
	VD8vxIe7mi4ROWkhYYiA0=
X-Received: by 2002:a17:903:19e6:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2c1e79e1fd3mr271789045ad.5.1781112593535;
        Wed, 10 Jun 2026 10:29:53 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec2a:d56a:f3c0:4361:94a8:6696])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609df6esm275109775ad.48.2026.06.10.10.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 10:29:53 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>,
	Weiming Shi <bestswngs@gmail.com>,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH btrfs v2] btrfs: reject free space cache with more entries than pages
Date: Wed, 10 Jun 2026 10:29:26 -0700
Message-ID: <20260610172926.844265-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When loading a v1 free space cache, __load_free_space_cache() takes
num_entries and num_bitmaps straight from the on-disk
btrfs_free_space_header. That header is stored in the tree_root under a key
with type 0, which the tree-checker has no case for, so neither count is
validated before the load trusts it.

The load loops num_entries times and maps the next page whenever the current
one runs out, going through io_ctl_check_crc() -> io_ctl_map_page(), which
does io_ctl->pages[io_ctl->index++]. But pages[] is allocated in
io_ctl_init() from the cache inode's i_size, not from num_entries:

	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
	io_ctl->pages = kcalloc(num_pages, sizeof(struct page *), GFP_NOFS);

So if num_entries claims more records than the pages can hold, io_ctl->index
runs off the end of pages[]. The write side never hits this because
io_ctl_add_entry() and io_ctl_add_bitmap() both stop once
io_ctl->index >= io_ctl->num_pages; the read side just never had the same
check.

To trigger it, take a clean cache (num_entries = <N> here), set num_entries
in the header to 0x10000, and fix up the leaf checksum so it still passes
the tree-checker. The cache inode has i_size = 65536, so num_pages is 16 and
pages[] is a 16-pointer (kmalloc-128) array. The load now tries to read
65536 entries, io_ctl->index walks up to 16, and pages[16] is read past the
array:

  BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
  Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
   io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
   __load_free_space_cache (fs/btrfs/free-space-cache.c:655 fs/btrfs/free-space-cache.c:820)
   load_free_space_cache (fs/btrfs/free-space-cache.c:1017)
   caching_thread (fs/btrfs/block-group.c:880)
   btrfs_work_helper (fs/btrfs/async-thread.c:312)
   process_one_work
   worker_thread
   kthread
   ret_from_fork

free-space-cache.c:420 is io_ctl_map_page(), inlined into io_ctl_check_crc()
at line 565, which is why that is the frame KASAN names. The out-of-bounds
slot is then treated as a struct page and handed to crc32c(), so the bad
read turns into a GP fault.

Add the missing check to io_ctl_check_crc(), which is where both the entry
loop and the bitmap loop end up. When num_entries is too large the load now
fails like any corrupt cache: __load_free_space_cache() drops it and rebuilds
the free space from the extent tree, so a valid cache is never rejected.

Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
v2: add more details in the commit message

 fs/btrfs/free-space-cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..bbc4db7fe74b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
+	if (index >= io_ctl->num_pages)
+		return -EIO;
+
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-- 
2.43.0

