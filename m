Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:57787 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731655AbeGQO0K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:26:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix size_t format string
Date: Tue, 17 Jul 2018 15:52:27 +0200
Message-Id: <20180717135236.3673195-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The newly added check_block_group_item() function causes a build warning
on 32-bit architectures:

fs/btrfs/tree-checker.c: In function 'check_block_group_item':
fs/btrfs/tree-checker.c:404:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]

The type of a sizeof() expression is size_t, which is correctly printed
using the %zu format string.

Fixes: 9dc16aad5660 ("btrfs: tree-checker: Verify block_group_item")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index e9414c3f375e..4c82a628df85 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -401,7 +401,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 
 	if (item_size != sizeof(bgi)) {
 		block_group_err(fs_info, leaf, slot,
-			"invalid item size, have %u expect %lu",
+			"invalid item size, have %u expect %zu",
 				item_size, sizeof(bgi));
 		return -EUCLEAN;
 	}
-- 
2.9.0

