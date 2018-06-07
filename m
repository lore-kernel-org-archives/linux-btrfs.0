Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:37476 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbeFGHUI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 03:20:08 -0400
Received: by mail-ot0-f195.google.com with SMTP id 101-v6so10353733oth.4
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 00:20:08 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 03:20:07 -0400
Message-ID: <CA+X5Wn5J-gF9VTYCvT=J7SQA3n3DP0PTExf7Zf8AcLzkkpG6OQ@mail.gmail.com>
Subject: [PATCH v2 3/3] Fix misspelling of forward
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 btrfs-map-logical.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 8a41b037..59ba731b 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -39,7 +39,7 @@
 static FILE *info_file;

 static int map_one_extent(struct btrfs_fs_info *fs_info,
-                         u64 *logical_ret, u64 *len_ret, int search_foward)
+                         u64 *logical_ret, u64 *len_ret, int search_forward)
 {
        struct btrfs_path *path;
        struct btrfs_key key;
@@ -75,11 +75,11 @@ static int map_one_extent(struct btrfs_fs_info *fs_info,

 again:
        btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-       if ((search_foward && key.objectid < logical) ||
-           (!search_foward && key.objectid > logical) ||
+       if ((search_forward && key.objectid < logical) ||
+           (!search_forward && key.objectid > logical) ||
            (key.type != BTRFS_EXTENT_ITEM_KEY &&
             key.type != BTRFS_METADATA_ITEM_KEY)) {
-               if (!search_foward)
+               if (!search_forward)
                        ret = btrfs_previous_extent_item(fs_info->extent_root,
                                                         path, 0);
                else
--
2.17.0
