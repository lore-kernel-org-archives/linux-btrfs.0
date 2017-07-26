Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36266 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdGZUsI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 16:48:08 -0400
Received: by mail-pf0-f178.google.com with SMTP id z129so35685996pfb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 13:48:08 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] btrfs: Remove extra parentheses from condition in copy_items()
Date: Wed, 26 Jul 2017 13:47:59 -0700
Message-Id: <20170726204759.160649-1-mka@chromium.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need for the extra pair of parentheses, remove it. This
fixes the following warning when building with clang:

fs/btrfs/tree-log.c:3694:10: warning: equality comparison with extraneous
  parentheses [-Wparentheses-equality]
                if ((i == (nr - 1)))
                     ~~^~~~~~~~~~~

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f20ef211a73d..b92408a3f834 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3691,7 +3691,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 
 		src_offset = btrfs_item_ptr_offset(src, start_slot + i);
 
-		if ((i == (nr - 1)))
+		if (i == (nr - 1))
 			last_key = ins_keys[i];
 
 		if (ins_keys[i].type == BTRFS_INODE_ITEM_KEY) {
-- 
2.14.0.rc0.400.g1c36432dff-goog

