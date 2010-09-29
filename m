From: Christoph Hellwig <hch@lst.de>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Wed, 29 Sep 2010 10:19:36 +0200
Message-ID: <20100929081936.GA23322@lst.de>
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <20100927222548.GG3610@quack.suse.cz> <20100927225452.GG4270@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
	linux-kernel@vger.kerne
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100927225452.GG4270@think>
List-ID: <linux-btrfs.vger.kernel.org>

Here is the patch that I already proposed a while ago.  I've tested
xfstests on btrfs and xfstests to make sure the btrfs issue is fixed,
and I've also tested the original dirtying of device files issue
and I/O operations on block device files to test the special case
in the patch.

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] writeback: always use sb->s_bdi for writeback purposes

We currently use struct backing_dev_info for various different purposes.
Originally it was introduced to describe a backing device which includes
an unplug and congestion function and various bits of readahead information
and VM-relevant flags.  We're also using for tracking dirty inodes for
writeback.

To make writeback properly find all inodes we need to only access the
per-filesystem backing_device pointed to by the superblock in ->s_bdi
inside the writeback code, and not the instances pointeded to by
inode->i_mapping->backing_dev which can be overriden by special devices
or might not be set at all by some filesystems.

Long term we should split out the writeback-relevant bits of struct
backing_device_info (which includes more than the current bdi_writeback)
and only point to it from the superblock while leaving the traditional
backing device as a separate structure that can be overriden by devices.

The one exception for now is the block device filesystem which really
wants different writeback contexts for it's different (internal) inodes
to handle the writeout more efficiently.  For now we do this with
a hack in fs-writeback.c because we're so late in the cycle, but in
the future I plan to replace this with a superblock method that allows
for multiple writeback contexts per filesystem.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-09-29 16:58:41.750557721 +0900
+++ linux-2.6/fs/fs-writeback.c	2010-09-29 17:11:35.040557719 +0900
@@ -72,22 +72,10 @@ int writeback_in_progress(struct backing
 static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
 
-	/*
-	 * For inodes on standard filesystems, we use superblock's bdi. For
-	 * inodes on virtual filesystems, we want to use inode mapping's bdi
-	 * because they can possibly point to something useful (think about
-	 * block_dev filesystem).
-	 */
-	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
-		/* Some device inodes could play dirty tricks. Catch them... */
-		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
-			"Dirtiable inode bdi %s != sb bdi %s\n",
-			bdi->name, sb->s_bdi->name);
-		return sb->s_bdi;
-	}
-	return bdi;
+	if (strcmp(sb->s_type->name, "bdev") == 0)
+		return inode->i_mapping->backing_dev_info;
+	return sb->s_bdi;
 }
 
 static void bdi_queue_work(struct backing_dev_info *bdi,
