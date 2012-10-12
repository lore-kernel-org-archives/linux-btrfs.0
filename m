Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52488 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2JLGu4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 02:50:56 -0400
Message-ID: <1350024619.5357.3.camel@nexus.lab.ntt.co.jp>
Subject: [PATCH 1/2] vfs: leverage bd_super in get_active_super
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando_b1@lab.ntt.co.jp>
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Fri, 12 Oct 2012 15:50:19 +0900
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subject: vfs: leverage bd_super in get_active_super

Using get_active_super will not work properly if the fs (like btrfs) does not
save its s_bdev with the device it is on.  Also it does not provide the entire
picture, since an filesystem can be contained on multiple disks (again like
btrfs).

Fortunately we now have a bd_super field in struct block_device were a pointer
to the superblock sitting on top of the block device can be stored.

Filesystems using the vfs helper mount_bdev (the ext filesystems, xfs, etc) and
gfs2 already do this (for the former it is a freebie), so for these there is
no need to iterate through the list of superblocks; we can get the superblock
directly from ->bd_super which is more efficient and what this patch
implements.

A multi-device filesystem (once again lile btrfs) can use that field to store
a pointer to the superblock for each block device in its storage pool. By
doing so it would get_active_super and, by extension, thaw_bdev initiated
freezes working.

Thanks go to Josef Bacik and Christoph Hellwig for initiating this effort
to fix btrfs and for suggesting the solution implemented here, respectively.

Cc: Josef Bacik <jbacik@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.6-orig/fs/super.c linux-3.6/fs/super.c
--- linux-3.6-orig/fs/super.c	2012-10-10 11:20:58.000122252 +0900
+++ linux-3.6/fs/super.c	2012-10-10 14:56:44.260186674 +0900
@@ -725,18 +725,22 @@ struct super_block *get_active_super(str
 
 restart:
 	spin_lock(&sb_lock);
+	if ((sb = bdev->bd_super) != NULL)
+		goto out_grabsuper;
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
-		if (sb->s_bdev == bdev) {
-			if (grab_super(sb)) /* drops sb_lock */
-				return sb;
-			else
-				goto restart;
-		}
+		if (sb->s_bdev == bdev)
+			goto out_grabsuper;
 	}
 	spin_unlock(&sb_lock);
 	return NULL;
+
+out_grabsuper:
+	if (grab_super(sb)) /* drops sb_lock */
+		return sb;
+	else
+		goto restart;
 }
  
 struct super_block *user_get_super(dev_t dev)


