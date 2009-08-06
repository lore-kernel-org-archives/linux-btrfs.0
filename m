From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] btrfs: remove superfluous NULL pointer check in btrfs_rename()
Date: Thu, 6 Aug 2009 21:48:11 +0200
Message-ID: <200908062148.12946.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: Dan Carpenter <error27@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Eugene Teo <eteo@redhat.com>,
	Julia Lawall <julia@diku.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] btrfs: remove superfluous NULL pointer check in btrfs_rename()

This takes care of the following entry from Dan's list:

fs/btrfs/inode.c +4788 btrfs_rename(36) warning: variable derefenced before check 'old_inode'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/btrfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/fs/btrfs/inode.c
===================================================================
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4785,8 +4785,7 @@ static int btrfs_rename(struct inode *ol
 	 * and the replacement file is large.  Start IO on it now so
 	 * we don't add too much work to the end of the transaction
 	 */
-	if (new_inode && old_inode && S_ISREG(old_inode->i_mode) &&
-	    new_inode->i_size &&
+	if (new_inode && S_ISREG(old_inode->i_mode) && new_inode->i_size &&
 	    old_inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 		filemap_flush(old_inode->i_mapping);
 
