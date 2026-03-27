Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019A43D3D11
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 08:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774599875; cv=none; b=tYyZDJ8psD4JwToUEAOaU9jv+WdbmVWf9yUX9QHjLnEJTB2OSY8FUSY3e0wQJudh6wmn5k3FaJVHpRpRk6UULR1megOEZWEWXW1aDap93ELEG9/bAH71U9QOlm+wXlNGWYvkdDJAo8YW6Jka7yU0S+IUJ+UfRLDavc5d8uyb3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774599875; c=relaxed/simple;
	bh=3vNoqKe/aR8g29HWgPtyQ7y1TEApUPs4a92OYmUp+wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d617ZAV+4ZkTnfqw3DXY6lxE7QMyB+8ns6/IvsU18o1VugD1ALyzBkSycNeN7BXLZw3T+GNAHv2a+BSuKIEwfozZ2Bywxq+5az1DSYYCeCiR+B3OycKo6PndWgrE98RfWErhK1QkQgc6I7zKKu3iunqofPVTc4lfS9jr7bRogMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=NvSilcsf; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="NvSilcsf"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso985154a91.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 01:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1774599872; x=1775204672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9L57hTltiEsNstXFa51jdQMNN6vMySfO13WmKQYIEJU=;
        b=NvSilcsftwXriZ3Ow1j1G/IZkebeQKX8aW7Rgmb41u3LsFh7OxWerTzon7TVowcNxO
         YxlfcBQsCC9hUynBxM1bpC/R0gpTY1rNhMXRNDxbWkldHHcAD/Smed1s4lFizq1sItpv
         CjRq+Rt690R3EM/yvWXG/Y1d1fiP7350PRUGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774599872; x=1775204672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9L57hTltiEsNstXFa51jdQMNN6vMySfO13WmKQYIEJU=;
        b=HnZ789NsmrYDU/f712pz84RXwljkT8RkLAl9UoRL2eNHrtafzEAJLlB9FEfofXjlG0
         Ky+R//2/JuNPniK3MDfN4BQYyYnh3cCEHsH24XBR5OLWSfZT7e00XVJ9VwfxEnmA1+lP
         bRtD6miYiaccxdJXY3v4ndavjOEPD2+4Q6LSxGhF2DAQdzRZWWjNh1jWIhyOhHmlgFeX
         Ah21U+z1n3NF/6hdu38YAdycDQBVUNyM7gyaJrl7zwpiyg9xqJHIUdzdkBL+1L+1wrPb
         foN/+mJhidKa5mZ/4R1RH8x8ZZ46IE1gC0EVr+FM3aaMhUp2uvB4Qwak0MFgk60c3jL6
         6rIA==
X-Gm-Message-State: AOJu0YzLq+ja5LYNnuUbDurKp+DW5FPThtNmkfCVbB8s9gB6i3DA1Yad
	V51jYNCSpieNKxJRX37dCYI6KWruLpkZgIzGLMqdzUR8jzzhtoIImg6cVTDRzJS8E5E=
X-Gm-Gg: ATEYQzxUqoIfEIZRTbqP5bB5RtHZwxkI9On/UaVn1l/79UfUdN3SRLUQ26XX3jvjHuP
	xujY4nKfDG2/LMBwJOg0AFLqCJTLkzgiY6FZA9qfB2tdTRtz1v4+/FJGvSKzTwTKtzyml2G9GcU
	6NccWa6/JhgXlkmrjOEpFTRIDil/UwE3qRM73xz/73rJfjja2RIPwqM2RKGS3HmISD+Xka6wQSw
	RjBj8XELouwqvZwdyvVnv567lA8yeMMGnJmSJoELOc9meiU2xKJl84xk2SZYaOk8Yd6E27MsS6h
	A2EFfByYr71+jxymi0XNdmYDdZpDo1eQBNB71V5V4zhkxJR7mKqQBSsnpmlDbqUmnxXb/kBc9Ff
	GkcAyJZJIACwOa4RkPOT9iSftfEuzC7qfbDXpb1jr79ktv1819xPqxPZoiocU+Nd273S8f5/qxt
	fy9scQ2pltLTYD9bdZFPsLd67Psp/tLR1bOtNFc/sapU3od8cNaKm35YjgoR3uupw9D5TZ3Z3Cx
	vt/y74wyHDZOzS3mhB/bsw4D/lwowvGMyT75TTiYXna/xOW0bBjAFtxIWYMwSyd0NA4HcIDRf4R
	BMnFSWAsGRtWrcdNhrqKM3/KrycdnpJB0JW4ClzzFQFrXr/yhVcPwtu/4wk4gt3L
X-Received: by 2002:a17:90b:558d:b0:35b:9d97:63ac with SMTP id 98e67ed59e1d1-35c2ffa82e2mr1854768a91.7.1774599872214;
        Fri, 27 Mar 2026 01:24:32 -0700 (PDT)
Received: from aegis ([2001:fd8:4d01:cc02:cf55:4e55:9fc2:64c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22ba5700sm4114806a91.8.2026.03.27.01.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 01:24:31 -0700 (PDT)
From: Daniel J Blueman <daniel@quora.org>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Daniel J Blueman <daniel@quora.org>,
	stable@vger.kernel.org
Subject: [PATCH v3] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
Date: Fri, 27 Mar 2026 16:24:18 +0800
Message-ID: <20260327082419.12654-1-daniel@quora.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When booting Linux 7.0-rc5 on a Qualcomm Snapdragon X1 with KASAN
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

This occurs as allocation in btrfs_alloc_page_array is from multiple
discrete pages thus different KASAN tags by design, leading to a tag
mismatch when linear access is used where the pages are physically
contiguous.

Fix this by retagging all the EB pages with the same KASAN tag.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")
Changelog:
 v3: Retag only when contiguous; fix build failure when generic KASAN configured
 v2: https://lore.kernel.org/lkml/20260323061827.22903-1-daniel@quora.org/
  - Retag pages rather than bypass linear access optimisation
 v1: https://lore.kernel.org/lkml/20260319053413.14771-1-daniel@quora.org/
---
 fs/btrfs/extent_io.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5f97a3d2a8d7..141092da871b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3533,8 +3533,23 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	/* All pages are physically contiguous, can skip cross page handling. */
-	if (page_contig)
+	if (page_contig) {
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+		struct page *page = folio_page(eb->folios[0], 0);
+		u8 tag = page_kasan_tag(page);
+
+		/*
+		 * Since pages are from multiple allocations and physically
+		 * contiguous allowing linear access, prevent KASAN warnings
+		 * by retagging with the first tag
+		 */
+		for (int i = 1; i < num_extent_pages(eb); i++) {
+			page_kasan_tag_set(page + i, tag);
+			kasan_unpoison_range(page_address(page + i), PAGE_SIZE);
+      }
+#endif
 		eb->addr = folio_address(eb->folios[0]) + offset_in_page(eb->start);
+	}
 again:
 	xa_lock_irq(&fs_info->buffer_tree);
 	existing_eb = __xa_cmpxchg(&fs_info->buffer_tree,
-- 
2.53.0
