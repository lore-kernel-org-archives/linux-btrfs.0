Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43663 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeITKn6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 06:43:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id j26-v6so3760009pfi.10
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 22:02:28 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v8 2/6] mm: export add_swap_extent()
Date: Wed, 19 Sep 2018 22:02:13 -0700
Message-Id: <c1d44e348e4bc5ae7a2bec803d5db33bcfb3f27c.1537419652.git.osandov@fb.com>
In-Reply-To: <cover.1537419652.git.osandov@fb.com>
References: <cover.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Btrfs currently does not support swap files because swap's use of bmap
does not work with copy-on-write and multiple devices. See commit
35054394c4b3 ("Btrfs: stop providing a bmap operation to avoid swapfile
corruptions"). However, the swap code has a mechanism for the filesystem
to manually add swap extents using add_swap_extent() from the
->swap_activate() aop. iomap has done this since commit 67482129cdab
("iomap: add a swapfile activation function"). Btrfs will do the same in
a later patch, so export add_swap_extent().

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 mm/swapfile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d3f95833d12e..51cb30de17bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2365,6 +2365,7 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(add_swap_extent);
 
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
-- 
2.19.0
