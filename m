Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38864 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbeILDgl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:36:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id u11-v6so11988030plq.5
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 15:35:15 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-mm@kvack.org
Subject: [PATCH v7 2/6] mm: export add_swap_extent()
Date: Tue, 11 Sep 2018 15:34:45 -0700
Message-Id: <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
In-Reply-To: <cover.1536704650.git.osandov@fb.com>
References: <cover.1536704650.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Btrfs will need this for swap file support.

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
2.18.0
