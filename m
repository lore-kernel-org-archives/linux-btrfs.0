Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38870 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbcLTQTX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:19:23 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][V2] btrfs: remove redundant inode null check
Date: Tue, 20 Dec 2016 16:18:37 +0000
Message-Id: <20161220161837.24391-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for a null inode is redundant since the function
is a callback for exportfs, which will itself crash if
dentry->d_inode or parent->d_inode is NULL.  Removing the
null check makes this consistent with other file systems.

Also remove the redundant null dir check too.

Found with static analysis by CoverityScan, CID 1389472

Kudos to Jeff Mahoney for reviewing and explaining the error in
my original patch (most of this explanation went into the above
commit message) and David Sterba for pointing out that the dir
check is also redundant.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/export.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 340d907..4f77431 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -235,9 +235,6 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	int ret;
 	u64 ino;
 
-	if (!dir || !inode)
-		return -EINVAL;
-
 	if (!S_ISDIR(dir->i_mode))
 		return -EINVAL;
 
-- 
2.10.2

