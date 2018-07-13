Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40027 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbeGMOWo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 10:22:44 -0400
Received: by mail-pl0-f67.google.com with SMTP id s17-v6so2862703plp.7
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 07:07:56 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
Cc: jbacik@fb.com, clm@fb.com, Naohiro Aota <naota@elisp.net>
Subject: [PATCH] btrfs: fix use-after-free of cmp workspace pages
Date: Fri, 13 Jul 2018 23:07:20 +0900
Message-Id: <20180713140720.4390-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_cmp_data_free() puts cmp's src_pages and dst_pages, but leaves
their page address intact. Now, if you hit "goto again" in
btrfs_extent_same_range() and hit some error in
btrfs_cmp_data_prepare(), you'll try to unlock/put already put pages.

This is simple fix to reset the address to avoid use-after-free.

Fixes: 67b07bd4bec5 ("Btrfs: reuse cmp workspace in EXTENT_SAME ioctl")
Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 43ecbe620dea..b077544b5232 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3327,11 +3327,13 @@ static void btrfs_cmp_data_free(struct cmp_pages *cmp)
 		if (pg) {
 			unlock_page(pg);
 			put_page(pg);
+			cmp->src_pages[i] = NULL;
 		}
 		pg = cmp->dst_pages[i];
 		if (pg) {
 			unlock_page(pg);
 			put_page(pg);
+			cmp->dst_pages[i] = NULL;
 		}
 	}
 }
-- 
2.18.0

