Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725745AbeIYGLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 02:11:18 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B9BDAD1A
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 00:06:33 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: tree-checker: Avoid using max() for stack array allocation
Date: Tue, 25 Sep 2018 08:06:26 +0800
Message-Id: <20180925000626.15474-2-wqu@suse.com>
In-Reply-To: <20180925000626.15474-1-wqu@suse.com>
References: <20180925000626.15474-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although BTRFS_NAME_LEN and XATTR_NAME_MAX is the same value (255),
max(BTRFS_NAME_LEN, XATTR_NAME_MAX) should be optimized as const at
runtime.

However S390x' arch dependent option "-mwarn-dynamicstack" could still
report it as dyanamic stack allocation.

Just use BTRFS_NAME_LEN directly to avoid such false alert.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index db835635372f..4c045609909b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -336,7 +336,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[BTRFS_NAME_LEN];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
-- 
2.19.0
