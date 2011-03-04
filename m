From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 2/2] btrfs: check link counter overflow in link(2)
Date: Fri, 4 Mar 2011 17:15:18 +0000
Message-ID: <20110304171518.GB26708@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110304171353.GU22723@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/btrfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 099d64c..8a6df03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4826,6 +4826,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EPERM;
 
+	if (inode->i_nlink == ~0U)
+		return -EMLINK;
+
 	btrfs_inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME;
 
-- 
1.7.2.5
