Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8237A13B293
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 05:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773898496; cv=none; b=X0d/tq60GxPMheFLPa9Gm8EIZM0iP0YcUlZ30g9LC3VLKvC12zY3OOLX1/JZ0ZL8U7MOmlAAu9/pdYeV94AXfJxNWVp9qfCe1hnjyDyZ2ne98ZHzyxI8rFUOc7jlWQvZ2DlMYOU8KpU/ZmvT26ynmG62iPVH54OgRGs5wqbtyoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773898496; c=relaxed/simple;
	bh=ebcYlibnQMgwbONJX3gJzuuqgkdsCj7qpvO3JdrhDNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R4gIDxj+Xyni+9+nugpqKQGQdGXZPnsEMjGHZpR8LTB6WTGmxo1fMTRyPFtxLp8rJ1KSloYkcCqaq48xrOiHF2w3QSzFTlBxUcfR0jZ864g4nBXtxBXUf+dpNbgxahLh4qeu9DSTWvzZUA64g1PsLIvuGJsI3TbbyVPyUThkUA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=X5kUB4mr; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="X5kUB4mr"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ad21f437eeso4736835ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 22:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1773898493; x=1774503293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+QLegY1TKzloGHqrz7RaO2FC/oI0H2i3RKaQdTWGfw=;
        b=X5kUB4mr3q7c6qG8H+pUivDL6ry3CazsqFQoFTkB7ZkdPgr4srszfusTOBhy3kiWGG
         Hq7/GvGKgKO4CKvkguqndv8NFrReub0VaJsQ6e2Dwn5E23WBW/Spez4GZcdtup0D/Low
         PvswSXrHJXWf1o3HcBqHMUcME4/Q6nFJMALLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773898493; x=1774503293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+QLegY1TKzloGHqrz7RaO2FC/oI0H2i3RKaQdTWGfw=;
        b=A2kvvEhVVS+c4XcY7I6CB3uh0vDIsWHeH1yjKZ6gmUliS4WeqmQ+D2DFmQxPfIG8a6
         ThXM7Pje1Jp7LxxZNgqER3YX87f7HUbrfgSmTm7/2IV8+DANr/G/tGECbuoHmYr071Av
         MylYF449WWIkghVYjEo8AZdK5pBDBmy30VoIGV6njV0fmiJDnexHPbvUd9psS1lVVLvT
         by9dw1t/5mc0atTDHyQz4c8te+BPvgA3aLS9xfCpV1v+aEcsGVO3LrA6gxk8kwyh8PT2
         t9Wcg99Q9ak5U6k0nmAmCs3eJTHPJeRwD45uq2bk5YLm5nwoTzm7pVnaQkZDEU8qbMVA
         xSRg==
X-Forwarded-Encrypted: i=1; AJvYcCWe3vXpmWGwV8y9/zYNj99z7e52PkT8vcGuV18mr3zHzow7CDoKUjd9M8lNJBVEGPQvRafw0tI9Rz/5kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNY+4z4xKJZWc+lGRj8E4uHIOu6vfdFiXsBoHzTM3InP8ju8TS
	AFkoD7ppoafBdwMimnLwSnkE96uzrE+08mYSvJjsvAtsALF2BYXx3OC6GmUsjrWh8DU=
X-Gm-Gg: ATEYQzzNT/gn0BHQuRZ7whThhLaodssjP8YAFy6F3hXALaHzqxXbBkt1+WzpQp9ENMM
	1hMPgTB0OXZLlTSUOanJSgnRil+QyH1d7RRtzK3aoQ+4BWhw60hnWO73eurGSSUetiC9aiRiWu1
	kKVm50C2jGXSlaAhmS1y1xjT/b52btilxdIGZWtm8irj+1uGILqbp4WreJGd+cGrLwF6i6aOppo
	R9DrZliMYl4VnGnTg+INFzw3SVxUjlSnnPEZ5xMgmdTCdJ/3Mi0VU3OOHlJIDeV+vVsWYrV7pAH
	tg25xSVxmzcVZYCldpKa0QBf6lDsXIT5jG9/IeuHnkPpMCGFtWAXjkBOhovNiVwnfZXdQ0XkJ7D
	FSieWZ27/OOOX8U4X/77HJhIu76vGAXvA7ZgY1Nggg4wV9JsNrgcrTLirFUHKDoE0TTkW3B1u9m
	1KxZfIzmTnwBit106zjaXW2u2TdO7XFASSg8Ug2h2Nxo5BnraFhMWY4HXoA3ebnyprUvsZc9HUE
	yDuZfjtr1QiQDGravmGKeZIjCVNfVPK6WmI8a1uZewb8SuE+QrvV2QHpELlhdRTLszvjOjUK6ze
	+3m0FW2L4OjMy7SeUdqleR4Y029D1tCYjwncBMZxpnmC8q//kImJArmK4a2E3isIs3hyl7OiWRT
	KKARfStq1
X-Received: by 2002:a17:902:f683:b0:2b0:5722:f89 with SMTP id d9443c01a7336-2b077143206mr19765715ad.7.1773898492916;
        Wed, 18 Mar 2026 22:34:52 -0700 (PDT)
Received: from aegis.localdomain ([49.148.247.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e441374sm44983075ad.29.2026.03.18.22.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 22:34:52 -0700 (PDT)
From: Daniel J Blueman <daniel@quora.org>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Cc: Daniel J Blueman <daniel@quora.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
Date: Thu, 19 Mar 2026 13:34:10 +0800
Message-ID: <20260319053413.14771-1-daniel@quora.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When booting Linux 7.0-rc4 on a Qualcomm Snapdragon X1 with KASAN
software tagging with a BTRFS filesystem, we see:

BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
Pointer tag: [7b], memory tag: [b2]

CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34 PREEMPTLAZY
Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
Workqueue: btrfs-endio-meta simple_end_io_work
Call trace:
show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
dump_stack_lvl (lib/dump_stack.c:122)
print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:597)
kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
__hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
btrfs_csum_update (fs/btrfs/fs.c:106)
csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
btrfs_bio_end_io (fs/btrfs/bio.c:152)
simple_end_io_work (fs/btrfs/bio.c:388)
process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/trace/events/workqueue.h:110 kernel/workqueue.c:3281)
worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workqueue.c:3440 (discriminator 2))
kthread (kernel/kthread.c:436)
ret_from_fork (arch/arm64/kernel/entry.S:861)

The buggy address belongs to the physical page:
page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd pfn:0x884fe1
memcg:51ff000800e68ec0 aops:btree_aops ino:1
flags: 0x9340000000004000(private|zone=2|kasantag=0x4d)
raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055dee8
raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68ec0
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
>ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
^
ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2

This occurs as contiguous pages may have different KASAN tags in the upper address
bits, leading to a tag mismatch if linear addressing is used.

Fix this by treating them as discontiguous.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")

---
 fs/btrfs/extent_io.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5f97a3d2a8d7..e2b241fb6c0e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3517,8 +3517,16 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		 * At this stage, either we allocated a large folio, thus @i
 		 * would only be 0, or we fall back to per-page allocation.
 		 */
-		if (i && folio_page(eb->folios[i - 1], 0) + 1 != folio_page(folio, 0))
-			page_contig = false;
+		if (i > 0) {
+			struct page *prev = folio_page(eb->folios[i - 1], 0);
+			struct page *curr = folio_page(folio, 0);
+
+			/*
+			 * Contiguous pages may have different tags; can't be treated as contiguous
+			 */
+			if (curr != prev + 1 || page_kasan_tag(curr) != page_kasan_tag(prev))
+				page_contig = false;
+		}
 
 		if (!btrfs_meta_folio_test_uptodate(folio, eb))
 			uptodate = 0;
-- 
2.53.0

