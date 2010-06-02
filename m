From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Wed, 2 Jun 2010 11:56:46 -0400
Message-ID: <20100602155646.GA4041@flcl.lan>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: ulmo@sonic.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 01, 2010 at 07:29:56PM -0700, ulmo@sonic.net wrote:
> Is there a more aggressive filesystem restorer than btrfsck?  It simply
> gives up immediately with the following error:
> 
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
> failed.

btrfsck currently only checks whether a filesystem is consistent. It
doesn't try to perform any recovery or error correction at all, so it's
mostly useful to developers. Any error handling occurs while the
filesystem is mounted.

> Yet, the filesystem has plenty of data on it, and the discs are good and I
> didn't do anything to the data except regular btrfs commands and normal
> mounting.  That's a wildly unreliable filesystem.

btrfs is under heavy development, so make sure you're using the latest
git versions of the kernel module and tools.

> BTW, is there a way to improve delete and copy performance of btrfs?  I'm
> getting about 50KB/s-500KB/s (per size of file being deleted) in deleting
> and/or copying files on a disc that usually can go about 80MB/s.  I think
> it's because they were fragmented.  That implies btrfs is too accepting of
> writing data in fragmented style when it doesn't have to.  Almost all the
> files on my btrfs partitions are around a gig, or 20 gigs, or a third of a
> gig, or stuff like that.  The filesystem is 1.1TB.
> 
> Brad
