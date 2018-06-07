Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36113 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbeFGHUD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 03:20:03 -0400
Received: by mail-oi0-f68.google.com with SMTP id 14-v6so7691838oie.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 00:20:03 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 03:20:02 -0400
Message-ID: <CA+X5Wn4GAp9cLqCKUiu4H6PSAvi9e0quDsQOjarZbS5EDWmspA@mail.gmail.com>
Subject: [PATCH v2 2/3] btrfs-progs: map-logical: Use btrfs_next_extent_item()
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_KEY,
which are the types we're looking for.

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 btrfs-map-logical.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 2451012b..8a41b037 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -83,7 +83,8 @@ again:
                        ret = btrfs_previous_extent_item(fs_info->extent_root,
                                                         path, 0);
                else
-                       ret = btrfs_next_item(fs_info->extent_root, path);
+                       ret = btrfs_next_extent_item(fs_info->extent_root,
+                                                    path);
                if (ret)
                        goto out;
                goto again;
--
2.17.0
