From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH] btrfs: Handle NULL inode return from btrfs_lookup_dentry()
Date: Fri, 5 Aug 2011 09:48:28 -0700
Message-ID: <20110805164828.GB8482@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Right now in create_snapshot(), we'll BUG() if btrfs_lookup_dentry() returns
a NULL inode (negative dentry). Getting a negative dentry here probably
isn't ever expected to happen however two things lead me to believe that we
should trap this anyway:

- I don't see any possiblity of serious fs corruption from handling the
  error.  I do wonder though if we could have an "orphaned" snapshot?  Even
  if we did that doesn't strike me as needing to crash the machine. (Q:
  Perhaps going read-only is the eventual solution here?)

- It's very trivial to pass an -ENOENT back to userspace as we're pretty
  high up the call path at this point.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/ioctl.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cf0133..fc9525f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -498,14 +498,16 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (ret)
 		goto fail;
 
+	ret = 0;
 	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
 		goto fail;
-	}
-	BUG_ON(!inode);
+	} else if (inode == NULL)
+		ret = -ENOENT;
+
 	d_instantiate(dentry, inode);
-	ret = 0;
+
 fail:
 	kfree(pending_snapshot);
 	return ret;
-- 
1.7.6

