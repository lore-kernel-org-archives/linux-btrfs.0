Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60498 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758079AbdJMJ2L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 05:28:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: use %zu format string for size_t
Date: Fri, 13 Oct 2017 11:27:35 +0200
Message-Id: <20171013092759.712725-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We now get a harmless compile-time on 32-bit architectures:

fs/btrfs/tree-checker.c: In function 'check_extent_data_item':
fs/btrfs/tree-checker.c:189:70: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]

This changes the format string to use %zu instead of %lu for size_t.

Fixes: c1f6520bf360 ("btrfs: tree-checker: Enhance output for check_extent_data_item")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c7a09cc2a17c..388fb6553aa5 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -186,7 +186,7 @@ static int check_extent_data_item(struct btrfs_root *root,
 	/* Regular or preallocated extent has fixed item size */
 	if (item_size != sizeof(*fi)) {
 		file_extent_err(root, leaf, slot,
-			"invalid item size for reg/prealloc file extent, have %u expect %lu",
+			"invalid item size for reg/prealloc file extent, have %u expect %zu",
 			item_size, sizeof(*fi));
 		return -EUCLEAN;
 	}
-- 
2.9.0

