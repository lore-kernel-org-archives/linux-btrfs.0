Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35527 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761615AbcLPPZ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 10:25:28 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove redundant inode null check
Date: Fri, 16 Dec 2016 15:24:46 +0000
Message-Id: <20161216152446.23361-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for a null inode is redundant since the function
is a callback for exportfs, which will itself crash if
dentry->d_inode or parent->d_inode is NULL.  Removing the
null check makes this consistent with other file systems.

Found with static analysis by CoverityScan, CID 1389472

Kudos to Jeff Mahoney for reviewing and explaining the error in
my original patch (most of this explanation went into the above
commit message).

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 340d907..e90f781 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -235,7 +235,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	int ret;
 	u64 ino;
 
-	if (!dir || !inode)
+	if (!dir)
 		return -EINVAL;
 
 	if (!S_ISDIR(dir->i_mode))
-- 
2.10.2

