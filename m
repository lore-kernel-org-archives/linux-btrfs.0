Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFA93A3817
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 07:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777446650; cv=none; b=bDbQsqsc8TF+f8n8Kp68+e01AYK6/0j5efKsTUAD2Q+uMnmIJGk2+YrmGky20avyzbCD1hUftdHuVianmgC/7o9HnovYTg3E1Uch4xTaJYIcCyWOGY6l9e/CDYir/Nc+KRZciKJLuWzpfU+zyhMbixlYmkLV2e5avPsnfAJMpis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777446650; c=relaxed/simple;
	bh=lgJe9gJeU4AuKOrNjpDmrlMYpeUP928w/B1EnYLtuRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e02ZkMslk5C8dGD6GlSBhxl05IFca7RarUI93xe5Y0rh7cbXBka+MYrYm3kmOcd9kkOpr9Rn++xOIx9AKf5O8trBnnrBYvSzLOkn73nfzmpefsDvyEcLR8bGCIZBIb2cMwLJH793xLen+RNyor1NOesHe104JUkGHSEHAM9rqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org; spf=pass smtp.mailfrom=wbinvd.org; dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b=Qv9aln5w; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b="Qv9aln5w"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2d868d014a5so12100588eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 00:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wbinvd.org; s=wbinvd; t=1777446646; x=1778051446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JvMkiMSkoPoG3P9EaL3Cbb8ZOBvfwwRmrUF1MTc3Tso=;
        b=Qv9aln5w83XXYm3hyvK6DwbZ5IUWei3nwA0xwW8FmsG7juByfTcj36B5zUaDHE5uDp
         jyvIywfv8Plb1FvWWtl4OkqGRCwJ0U/y1qH16RPECnubFz5po4pfQkcnsXVj5J4CcgzC
         BnZD2ijUnjjjvl+qGPoUKrchhjwXReQplAYy/OOp2uKpe98BZIfoxZI6FtnvkhYvrmwL
         5lUoMYsBYZjYwFEztLgcBh1h5xk7aXsDOiodwvTLdheS8Ov9wTet+swR8iUfuDJV062G
         jFJNTWTTS2fmylWriGN98CgmgfJaMbSvrekq0jMzFvzmF+u3X4zEwDyF7J1i/4wSpJBw
         7Tpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777446646; x=1778051446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvMkiMSkoPoG3P9EaL3Cbb8ZOBvfwwRmrUF1MTc3Tso=;
        b=hEdVQaWqhHtmtV12ohGxZdhJ18ox9NvuaNzs4VeCvj1mAr1AHFL2oJC8m8ZdLFU7q3
         akIFTlJRCjrNREkfAuxSvGuWHrYhdzT/3ZCAvjtGde98rdx6mdBQJcVr4yIt3Q9Bh1hb
         jESqPpxtZzqaREvdiaTAW9gn69e2+haX3w7jdCL5DN0tJaRqLNo5SFe85b5EP1N8ux40
         j2b9/j5VyqMul5aYXMhU2Umo0Gb2k9OSpt9y0jdo810H5zog2Facfw40DgfVjZe/jI1F
         2Qz7um6dZujzEgNXmChI4kTPsZFM/FEkqQR9Rf6IPwh6f7Naq9h40rHzyZ/E6cYAE7Ya
         ceVw==
X-Gm-Message-State: AOJu0Yyx+eo5aT3b4C6qA0gvuJIKqLzTAUaaIHP74B0hQKrSO/nS5PLR
	4E1JYukPwyGbG23nsiuDOffsz/vddLjRRTXe4LvHOA8wjqP7LvvMRsE1MM/Y1sMHWNI=
X-Gm-Gg: AeBDietHbcMB02zCyMVXUiqH70Xq8ouU5Z4xn6kavlTeYb/uSIb488VGuO/ZaTEfdyY
	GmKK+9fJ0ojT+Nhni36FVqimSnqxDDNDtS9qonvzQpSFhn/TAh/+zdp9cDJByRLsau3yRHuwMRf
	kuyoDzE5HvFz5Pa9keh2EHh2rODrGt+AzBA3sg9FxmYTm+ZCLF0Xc6+RlxCgWt5R1PVdmDeXplO
	YQO1oHAEzzMExVqiRrjxMFBgV1JZblS5ysKTlMwa99pAzr+rVCeJsrkNsAQBnzX+hwZFNsAHGLI
	n5IVpmUda1kBefRAVC6bSdWV18J5R9gDH67KGjqHpwKwfLLvaGNYCPZNlBsPvu83z0zLfKfe/ON
	DR9DGpUmiuOFHY6s0GlHgiOD7zNfHC+3Q//inK5X5U9oRpY4SyD2dMxqgtvdSEUu6I9lY+A7sEE
	+E5uYYgoKuNHbUVPtytzVvntHGyzgjZTWUaTsA
X-Received: by 2002:a05:7300:6c24:b0:2dd:5641:f01 with SMTP id 5a478bee46e88-2ed198bf5aamr1257642eec.28.1777446645843;
        Wed, 29 Apr 2026 00:10:45 -0700 (PDT)
Received: from mozart.vkv.me ([2001:5a8:468b:d015:6050:66c4:ba14:2c51])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c09c6e3sm1036260eec.25.2026.04.29.00.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 00:10:45 -0700 (PDT)
From: Calvin Owens <calvin@wbinvd.org>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	"JP Kobryn (Meta)" <jp.kobryn@linux.dev>,
	Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH] btrfs: always pass __GFP_NOWARN from add_ra_bio_pages()
Date: Wed, 29 Apr 2026 00:10:25 -0700
Message-ID: <fa015cf39d4dd9575052141e86bce7417c61d4e1.1777445157.git.calvin@wbinvd.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A build workload newly prints order-0 allocation failures on 7.1-rc1:

    sh: page allocation failure: order:0
    mode:0x14084a(__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_IO|__GFP_KSWAPD_RECLAIM|
                  __GFP_COMP|__GFP_HARDWALL)
    CPU: 27 UID: 1000 PID: 855540 Comm: sh Not tainted 7.1.0-rc1-llvm-00058-gdca922e019dd #1 PREEMPTLAZY
    Call Trace:
     <TASK>
     dump_stack_lvl+0x50/0x70
     warn_alloc+0xeb/0x100
     __alloc_pages_slowpath+0x567/0x5a0
     ? filemap_get_entry+0x11a/0x140
     __alloc_frozen_pages_noprof+0x249/0x2d0
     alloc_pages_mpol+0xe4/0x180
     folio_alloc_noprof+0x80/0xa0
     add_ra_bio_pages+0x13c/0x4b0
     btrfs_submit_compressed_read+0x229/0x300
     submit_one_bio+0x9e/0xe0
     btrfs_readahead+0x185/0x1a0
     [...]

    (lldb) source list -a add_ra_bio_pages+0x13c
    .../vmlinux.unstripped add_ra_bio_pages + 316 at .../fs/btrfs/compression.c:454:8
       451
       452                  folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, constraint_gfp),
       453                                              0, NULL);
    -> 454                  if (!folio)
       455                          break;

I can reproduce this consistently by running a memory hog concurrently
with a buffered writer on a machine with a very large amount of swap.

Commit 7ae37b2c94ed ("btrfs: prevent direct reclaim during compressed
readahead") clearly intended to suppress these warnings. But because the
mask set in the address_space with mapping_set_gfp_mask() doesn't include
__GFP_NOWARN, mapping_gfp_constraint() removes it from constraint_gfp
before it is passed to filemap_alloc_folio().

Fix by refactoring the code to add __GFP_NOWARN after the call to
mapping_gfp_constraint().

Fixes: 7ae37b2c94ed ("btrfs: prevent direct reclaim during compressed readahead")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
---
 fs/btrfs/compression.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b2393a48a8fe..d29a42ff8653 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -408,21 +408,19 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
 	/*
-	 * Avoid direct reclaim when the caller does not allow it.  Since
-	 * add_ra_bio_pages() is always speculative, suppress allocation warnings
-	 * in either case.
+	 * Avoid direct reclaim when the caller does not allow it.
 	 */
+	constraint_gfp = ~__GFP_FS;
+	cache_gfp = GFP_NOFS | __GFP_NOWARN;
 	if (!direct_reclaim) {
-		constraint_gfp = ~(__GFP_FS | __GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
-		cache_gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
-	} else {
-		constraint_gfp = (~__GFP_FS) | __GFP_NOWARN;
-		cache_gfp = GFP_NOFS | __GFP_NOWARN;
+		constraint_gfp &= ~__GFP_DIRECT_RECLAIM;
+		cache_gfp &= ~__GFP_DIRECT_RECLAIM;
 	}
 
 	while (cur < compressed_end) {
 		pgoff_t page_end;
 		pgoff_t pg_index = cur >> PAGE_SHIFT;
+		gfp_t masked_constraint_gfp;
 		u32 add_size;
 
 		if (pg_index > end_index)
@@ -449,8 +447,14 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			continue;
 		}
 
-		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, constraint_gfp),
-					    0, NULL);
+		/*
+		 * Since add_ra_bio_pages() is always speculative, suppress
+		 * allocation warnings.
+		 */
+		masked_constraint_gfp = mapping_gfp_constraint(mapping, constraint_gfp);
+		masked_constraint_gfp |= __GFP_NOWARN;
+
+		folio = filemap_alloc_folio(masked_constraint_gfp, 0, NULL);
 		if (!folio)
 			break;
 
-- 
2.47.3

