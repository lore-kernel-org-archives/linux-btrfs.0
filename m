Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32916 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeIACqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 22:46:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id b92-v6so1035410plb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:36:49 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v5 2/6] mm: export add_swap_extent()
Date: Fri, 31 Aug 2018 15:36:37 -0700
Message-Id: <b0001941b7d21c3caec4878d035e95d08bf586b2.1535754957.git.osandov@fb.com>
In-Reply-To: <cover.1535754957.git.osandov@fb.com>
References: <cover.1535754957.git.osandov@fb.com>
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
