Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E88A349CE4
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 23:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784417857; cv=none; b=n4SkqQ8S9etMo/RTCu4uP6w67jy/5INEdWZ2VmwBsDS+FDp1hXdXkmTjvpi5GiY8QLinnyTQ9qLn1cxlWlymC5g6np5wjnwG3YiqTMnwQggI/8AKHivU9tyUgGL55+kaUSvLqV5lAQhagLDLGohvNalHHKXCrEW3QPpaQgaWGr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784417857; c=relaxed/simple;
	bh=HWKjxDDo2CMACkIkPXsPGbRVg3irX3XWzzs7XBToljo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SEVeCfmye8XZa2br5gQkfGtrlH8wXK8B2G/KV6P9LY4IuzOb8w2ZdAX3pSfYpzH1wxEdVB5zWOMVarV3RG58ma3XWOV/H9JrIQaRiqPhMso8wYs2DghHjMOqkpmbh2EboxNnjuIGJSmPWScdHg3CKmdNp/ok6DvTihw+FQQPkl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PIYzIBsd; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIYzIBsd"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8486672f03cso8975026b3a.0
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 16:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784417855; x=1785022655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6q+CCRpDAQqdAMMHeOQyiD/gJgJeu1pHxCVEK914I8k=;
        b=PIYzIBsd6XVoBj9CXHaLPVUip2DNh+buAjZ9yFB3afi6xbaR8N8tA0BxxPX4NG6ZfT
         U+dXI5hIuMuC9Q6v/s2wvBU6ilXyePuhPJlhttROi2yiBAC6xrfH0i32D6h97ouSRKYb
         oT9hIb/2on/hTJyw6GvbiPCAh304yxqDD9hpv1I+uCPlEVoVYACAil71BdyMeunt97lV
         RWaxzjKwt+EgZS/5sCzngCiXxBbVjjfXPdFsC3PPgZXNgPIwkkdqBnXVCaoSxeOYiJdV
         9rs5kCuNCFtGy27XOwrN7tzCSoRKUMzCeLanF68DRBrCfV9jwI5y8g9S10kQX5zet4hw
         9ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784417855; x=1785022655;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6q+CCRpDAQqdAMMHeOQyiD/gJgJeu1pHxCVEK914I8k=;
        b=msSoNrTDrIgKfbqpt+sGbQHvGogMcI4Er2buDkR7Zb/JJZbr15xoBQz/X2qbI8s8rh
         mIBUPwjkyp+fRpGO4booJ3FdMkJl5OU9DL/ODtpjc+CCgGWTE0MUNRSF1YqPUwbCRgqo
         soqVeFVBftgkTBlcwAKSivUDHDRacAAJ4Y/Kvwlza5aUAHcxY5bHqAMlMc8xrhoOuquM
         BGi5Y5Qa1NZxhZrDOhBnyh8UBggoAcBJITJSxne6Y2YMZMBb3ajisRQeGCOWd/ENDpPz
         3sUli+aqCw5mrIzb5nKmd4+XtFIIy+qc+tCrVk7dSmftJAvil7l2TZV53uilbHFLyp48
         qGYg==
X-Gm-Message-State: AOJu0YzMnjqeC7NY95pgTWUNm9/mfTKg6ip/zlPTRQqgbByxhcnBScEq
	cGI/CYDSHcdrEVyrkqm4lOll5jkLxLLy8iFYbG1li/Gas5yviCUABSYuMCRQK07o
X-Gm-Gg: AfdE7ckekrD7YIVvpzjFNioDVMns7bmTgL9ShFYjag47VHysUC5yqVPKVmeA5dwJIM3
	vomZLzgWaDL6Jt9izsnKwb9Jo4Rf7EwKPMMi6ggjtintRXkRpX+HF14iBn/ONA7tzi1yqiuN62m
	nXL8/HFiHTJ8J7QI5cXgZgQo6eFS9LCfNECsp5jj2FfriTCW1DoWtOdDpPQsh1L5I+w+Uu4oboN
	gmQrFYs60u39l61Ip4kENMbUCN4NCXH0TuXYbKUTduhQTMcaLgXRAQwNll4N2oLHarEltP2IdeL
	lp9FZZ498A/zNu7KLFGAPmXp2Y8pwvF8eY7UeBJbn7tvGQZympHdNYHmmEcBWqcv/mCuq0MUNVY
	yciikRPzzf368x5m+fj0tkyeceVg97trZh2XhSC+yERZa+pt2IvEp1ZC21yN2bDuDwuGjmxpXGT
	+DKRgZFLUIzdjkrZqcb3jip2nzdKT+C8rk
X-Received: by 2002:a05:6a00:a10:b0:847:926c:582c with SMTP id d2e1a72fcca58-84c292bc6aemr9369783b3a.29.1784417855456;
        Sat, 18 Jul 2026 16:37:35 -0700 (PDT)
Received: from powertower.tail474ae1.ts.net ([64.180.35.234])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af30b89sm3381350b3a.33.2026.07.18.16.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 16:37:34 -0700 (PDT)
From: Mykola Lysenko <nickolay.lysenko@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com,
	wqu@suse.com,
	clm@fb.com,
	josef@toxicpanda.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Mykola Lysenko <nickolay.lysenko@gmail.com>
Subject: [PATCH v2] btrfs: raid56: fix scrub read assembly submitting no reads
Date: Sat, 18 Jul 2026 16:37:10 -0700
Message-ID: <20260718233710.176782-1-nickolay.lysenko@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
converted the bio-list membership checks from sector pointers to
physical addresses. The two conversions in rmw_assemble_write_bios()
kept their polarity (skip the sector when it is NOT in the bio list,
i.e. when there is nothing to write), but scrub_assemble_read_bios()
has the opposite polarity -- skip the sector when it IS in the bio
list, because then there is nothing to read -- and the conversion
flipped it:

	-	sector = sector_in_rbio(rbio, stripe, sectornr, 1);
	-	if (sector)
	+	paddr = sector_paddr_in_rbio(rbio, stripe, sectornr, 1);
	+	if (paddr == INVALID_PADDR)
		continue;

Since a parity-scrub rbio's bio list only holds the empty completion
bio, the result is that scrub_assemble_read_bios() submits no reads at
all. finish_parity_scrub() then compares the parity it computes from
the (cached, correct) data stripes against whatever happens to be in
the freshly allocated, uninitialized stripe pages:

  - if the garbage differs from the computed parity, the sector is
    "repaired" and written back -- accidentally producing the correct
    on-disk result;
  - if a recycled page happens to still hold the old (correct) parity
    content, the sector is deemed clean, dropped from dbitmap, and the
    actually-corrupt on-disk parity is left in place. (Scrub reports
    no errors either way: there is no counter for P/Q corruption by
    design, so the bug here is purely the failure to read and repair.)

The second case is intermittent because it depends on page-allocator
recycling. Observed with fstests btrfs/297 (raid5, 2 devices): the
corrupted P stripe intermittently stays corrupt after a scrub --
roughly 1/10 runs on x86-64 KVM and up to 7/8 on a UML build whose
timing favors page reuse.

Since the bio-list check can never be true for a parity-scrub rbio --
raid56_parity_alloc_scrub_rbio() adds a single empty completion bio
(asserting bi_size == 0), bio_paddrs[] is only populated by
index_rbio_pages() which is never called for BTRFS_RBIO_PARITY_SCRUB,
and rbio_can_merge() refuses to merge rbios of different operations --
remove the dead check entirely and assert the invariant instead, as
suggested by Qu Wenruo.

After this fix the injected corruption is read, detected and repaired
in every run (8/8 UML, 10/10 KVM), and the new assertion never fires
across the full fstests raid group.

Fixes: 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
CC: stable@vger.kernel.org # 7.1+
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
---
v2: per Qu Wenruo's review -- the membership check is dead code in
either polarity for a scrub rbio, so remove it and ASSERT the
invariant instead of restoring the original polarity; clarify in the
message that the absence of P/Q error reporting is by design; move the
AI-usage disclosure to an Assisted-by tag per
Documentation/process/coding-assistants.rst.

v1: https://lore.kernel.org/linux-btrfs/20260716174511.8738-1-nickolay.lysenko@gmail.com/

Note: UML (User-Mode Linux) results above come from
https://github.com/mykola-lysenko/btrfs-uml-fstests/ -- for reference
only.

 fs/btrfs/raid56.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2909,13 +2909,12 @@ static int scrub_assemble_read_bios(struct btrfs_raid_bio *rbio)
 			continue;

 		/*
-		 * We want to find all the sectors missing from the rbio and
-		 * read them from the disk. If sector_paddr_in_rbio() finds a sector
-		 * in the bio list we don't need to read it off the stripe.
+		 * A parity-scrub rbio carries no data in its bio list: the
+		 * only bio there is the empty completion bio added by
+		 * raid56_parity_alloc_scrub_rbio().  Every sector is read
+		 * from the stripe, so only assert that invariant here.
 		 */
-		paddrs = sector_paddrs_in_rbio(rbio, stripe, sectornr, 1);
-		if (paddrs == NULL)
-			continue;
+		ASSERT(!sector_paddrs_in_rbio(rbio, stripe, sectornr, 1));

 		paddrs = rbio_stripe_paddrs(rbio, stripe, sectornr);
 		/*
--
2.43.0
