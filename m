From: ulmo@sonic.net
Subject: Is there a more aggressive fixer than btrfsck?
Date: Tue, 1 Jun 2010 19:29:56 -0700
Message-ID: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: ulmo@sonic.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a more aggressive filesystem restorer than btrfsck?  It simply
gives up immediately with the following error:

btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
failed.

Yet, the filesystem has plenty of data on it, and the discs are good and I
didn't do anything to the data except regular btrfs commands and normal
mounting.  That's a wildly unreliable filesystem.

BTW, is there a way to improve delete and copy performance of btrfs?  I'm
getting about 50KB/s-500KB/s (per size of file being deleted) in deleting
and/or copying files on a disc that usually can go about 80MB/s.  I think
it's because they were fragmented.  That implies btrfs is too accepting of
writing data in fragmented style when it doesn't have to.  Almost all the
files on my btrfs partitions are around a gig, or 20 gigs, or a third of a
gig, or stuff like that.  The filesystem is 1.1TB.

Brad

