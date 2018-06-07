Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35023 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752996AbeFGHT6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 03:19:58 -0400
Received: by mail-oi0-f66.google.com with SMTP id e8-v6so7682043oii.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 00:19:58 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 03:19:57 -0400
Message-ID: <CA+X5Wn4Ygijhnc2m4zHeH+wOTvFNOGepk5g08_D4a0dQWWMfpQ@mail.gmail.com>
Subject: [PATCH v2 1/3] btrfs-progs: map-logical: look at next leaf if slot > items
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-map-logical -l 10955980800 -b 4096 <path>
No extent found at range [10955980800,10955984896)

But, this extent exists.  btrfs-debug-tree shows:

   item 202 key (10955976704 EXTENT_ITEM 4096) itemoff 8772 itemsize 37
           refs 1 gen 62656 flags DATA
           shared data backref parent 142655488 count 1
...
   item 0 key (10955980800 EXTENT_ITEM 4096) itemoff 16246 itemsize 37
           refs 1 gen 62656 flags DATA
           shared data backref parent 128958464 count 1

The code searches for (<logical>, 0, 0), and looks forward then backward.  It
needs to go to the next leaf when slot > number of items on this leaf.

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 btrfs-map-logical.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 7a8bcff9..2451012b 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -65,6 +65,14 @@ static int map_one_extent(struct btrfs_fs_info *fs_info,
        BUG_ON(ret == 0);
        ret = 0;

+       if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+               ret = btrfs_next_leaf(fs_info->extent_root, path);
+               if (ret > 0) {
+                       ret = -ENOENT;
+                       goto out;
+               }
+       }
+
 again:
        btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
        if ((search_foward && key.objectid < logical) ||
--
2.17.0
