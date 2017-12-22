Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36032 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbdLVAzN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 19:55:13 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: remove unused label 'retry'
Date: Fri, 22 Dec 2017 00:55:08 +0000
Message-Id: <20171222005508.11975-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Label 'retry' is not used, remove it. Cleans up a clang build
warning:

warning: label ‘retry’ defined but not used [-Wunused-label]

Fixes: b283738ab0ad ("Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
2.14.1

