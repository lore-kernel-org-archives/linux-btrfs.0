Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:55502 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755292AbdLTQ6b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 11:58:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <wqu@suse.com>,
        Jeff Mahoney <jeffm@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: qgroups: remove unused label
Date: Wed, 20 Dec 2017 17:57:04 +0100
Message-Id: <20171220165717.2294915-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The recent revert left one unused label behind:

fs/btrfs/qgroup.c: In function 'qgroup_reserve':
fs/btrfs/qgroup.c:2432:1: error: label 'retry' defined but not used [-Werror=unused-label]

Let's remove it, too.

Fixes: b283738ab0ad ("Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/qgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index de3b96f1005b..2b89848e767d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2429,7 +2429,6 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 	    capable(CAP_SYS_RESOURCE))
 		enforce = false;
 
-retry:
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
-- 
2.9.0

