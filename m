Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859E62D73BD
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 06:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246829; cv=none; b=BeobYzLl1uTWGwuFT4nH9TPT6tzFXXZahiXaW2LLs7KdbnzAYDP90p8FclulGCvV30udgG5PCT0ZxngWg0eta3jUGA/71dKMp4H57fMUgWgnxjqzVcyu+/WqR/Y+0Ooq7eFNkpztlnzA/rNEBUsQpPikbM1EBgWYomhJeZyotFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246829; c=relaxed/simple;
	bh=EaqVAWQj1+JhnM0aduwM8TyiqVz99tNZ9GgCmbJeEd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LyEQ7BSSFz03Oaf1wvfwsihCQy8FgLANbeaBnZ+XRsTGKaoc2hZU00l4zzvPkQkJQ7aWhhNTCRbFjkx65kizACfWJ08j1HcP2hJa452WdcfbLm0JeyCeTSk8eW2BSAjbEZV4NeDEa8ztWoVWfaq7wZT2VQWIe6/BAST3y1tKhAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=QNXzDK8M; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="QNXzDK8M"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-829ac4670c4so2892548b3a.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2026 23:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1774246824; x=1774851624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=szc7+D5ToNJHA+7kPaHA4IjzMkDBvZLOp0vWoYKX35U=;
        b=QNXzDK8MQDh/t770ggkSVC69++yRKbf+ukgUpM/g7ewPNPIcvpGfl/qboqyBhOMHte
         vcJ/tApE3yMaFGm5llWW2uDLlWC8dRhZuDur9wyMa7x0P9M4p15NOufp1lewYd+yD2Bc
         hk3WkrtgMGI8qV42cCGteNjSuolr+T89TuhSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774246824; x=1774851624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=szc7+D5ToNJHA+7kPaHA4IjzMkDBvZLOp0vWoYKX35U=;
        b=IZWjCSKaTHw2f16Igy1QlB/T69oskVOG1/3XBweTY4r0K74tFejl03kCr6eedwsACO
         TML31tagG6eQN9dZZe81kAbiwnltDVuW+dSKYGdzNTc3n09zw9G4q14jiG2rI5Bz95s+
         rclyr4YMkOYeFm0C5aRLeEVaxuA26ODUNrTiTxADduZI3ZCbA5CmrT4DGsAI356T+rxl
         5M25wHm90dU466TuoeVslk6Lv95WqW0xMey3F03O/lq32CMbIyOPpK49iJ7gOd9x7GHF
         PdORhuS08wtz2Df3pGvAXb7fNPm1SPcW7f4sEbTTOIM1mgvkhHiCHJr/DqKroXQx2NsZ
         Vggw==
X-Gm-Message-State: AOJu0YxiakqsFclbJkSf57oYDpiu83qN4Z9l2g9Ui4j99Han9yZ6XJCH
	DXp6Ls1UjvqSueijgljyl7IPBGnGqL6JboK35aZsMxkPC/DgB6acnQGy3KsIeB3KFYk=
X-Gm-Gg: ATEYQzxynocvPWAmwJkpbZoJza9KC8j8zghFYwe06YlGXbIcH5StNuW5hirJmJ+Todg
	61FgYoTBtRDOxqwOTX4uvsUNmPLXzZQh6Eoea2yVn1T94jTzETkaIfzq5NJ7kq6j1xT55ewoJqz
	tVs7SORHpSK0R65JrPN1ZhssrWG2DsZSUFrNAQ2lMpvYdyNdImzKnY1ZH3RuA+EyLcBOD/mR9p1
	Udp3WL1KoGAZ9Xd9l41dfy+rPxn+/fJSKZy9pghvxXkEgPa7v8jUMBXqacf3yU6XPmYEqK5zL+I
	icndhppDFLwvuLRK/O+uE4Aq5bArEMPKNmm3+3eFVYSA+AEhfYK3Xq3d5kNPweDF73U7I6v3K55
	m+bp5iyGGXLh7h3tIz1nZXDZv4v1o6na2h7+vmnfgw6gMTJ1vgVmMnmmO7BAnQMXCg0gZfjaqgI
	xRZn8EBAFbRmpk4vt41/2cfIvNkr84turH2lS++21thp/TU73R0HKxnXpr1rwDCkINezcfCXQnM
	w/0ySYVNAMcdrzwl8R0GzUfjgN5XPKnvGCHX0kcVK+Xw3EGpGuUqmB3lrLqT0E5cV4jE8k6spae
	gL0QD0NxRgpXvj7ZvKC/+y2255C/R1KJWeyZufbXWH1Hohj5Bas9JWlJ0MLhZl2EzxVZIXM=
X-Received: by 2002:a05:6a00:300a:b0:82c:254b:79fb with SMTP id d2e1a72fcca58-82c254b86eamr6645766b3a.9.1774246823837;
        Sun, 22 Mar 2026 23:20:23 -0700 (PDT)
Received: from aegis ([131.226.111.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b040da9c3sm8305814b3a.44.2026.03.22.23.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 23:20:23 -0700 (PDT)
From: Daniel J Blueman <daniel@quora.org>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Daniel J Blueman <daniel@quora.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
Date: Mon, 23 Mar 2026 14:18:26 +0800
Message-ID: <20260323061827.22903-1-daniel@quora.org>
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
 v2: Retag pages rather than bypass linear access optimisation
 v1: https://lore.kernel.org/lkml/20260319053413.14771-1-daniel@quora.org/
---
 fs/btrfs/extent_io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5f97a3d2a8d7..37836d685f21 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/swap.h>
+#include <linux/kasan.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
@@ -706,6 +707,18 @@ static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Since separate page allocations are used for the same extent with
+	 * linear addressing where physically contiguous, apply the same KASAN
+	 * tag to prevent false-positive warnings when crossing page boundaries
+	 */
+	u8 tag = page_kasan_tag(page_array[0]);
+
+	for (int i = 1; i < num_pages; i++) {
+		page_kasan_tag_set(page_array[i], tag);
+		kasan_unpoison_range(page_address(page_array[i]), PAGE_SIZE);
+	}
+
 	for (int i = 0; i < num_pages; i++)
 		eb->folios[i] = page_folio(page_array[i]);
 	eb->folio_size = PAGE_SIZE;
-- 
2.53.0

