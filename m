Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:38659 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdG0Va4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 17:30:56 -0400
Received: by mail-pg0-f47.google.com with SMTP id k190so37298925pgk.5
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 14:30:56 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] btrfs: Remove extra parentheses from condition in copy_items()
Date: Thu, 27 Jul 2017 14:30:23 -0700
Message-Id: <20170727213023.68063-1-mka@chromium.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no need for the extra pair of parentheses, remove it. This
fixes the following warning when building with clang:

fs/btrfs/tree-log.c:3694:10: warning: equality comparison with extraneous
  parentheses [-Wparentheses-equality]
                if ((i == (nr - 1)))
                     ~~^~~~~~~~~~~

Also remove the unnecessary parentheses around the substraction.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
 - also remove parentheses around substraction

 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f20ef211a73d..385ec758df08 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3691,7 +3691,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 
 		src_offset = btrfs_item_ptr_offset(src, start_slot + i);
 
-		if ((i == (nr - 1)))
+		if (i == nr - 1)
 			last_key = ins_keys[i];
 
 		if (ins_keys[i].type == BTRFS_INODE_ITEM_KEY) {
-- 
2.14.0.rc0.400.g1c36432dff-goog

