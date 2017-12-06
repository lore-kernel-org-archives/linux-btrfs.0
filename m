Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:62705 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdLFOS6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 09:18:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <wqu@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: use %zu format string for size_t
Date: Wed,  6 Dec 2017 15:18:14 +0100
Message-Id: <20171206141844.788362-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return value of sizeof() is of type size_t, so we must print it
using the %z format modifier rather than %l to avoid this warning
on some architectures:

fs/btrfs/tree-checker.c: In function 'check_dir_item':
fs/btrfs/tree-checker.c:273:50: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'u32' {aka 'unsigned int'} [-Werror=format=]

Fixes: 005887f2e3e0 ("btrfs: tree-checker: Add checker for dir item")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 66dac0a4b01f..7c55e3ba5a6c 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -270,7 +270,7 @@ static int check_dir_item(struct btrfs_root *root,
 		/* header itself should not cross item boundary */
 		if (cur + sizeof(*di) > item_size) {
 			dir_item_err(root, leaf, slot,
-		"dir item header crosses item boundary, have %lu boundary %u",
+		"dir item header crosses item boundary, have %zu boundary %u",
 				cur + sizeof(*di), item_size);
 			return -EUCLEAN;
 		}
-- 
2.9.0

