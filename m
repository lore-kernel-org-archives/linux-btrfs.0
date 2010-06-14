From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch 11/11] btrfs: The file argument for fsync() is never
	null
Date: Mon, 14 Jun 2010 23:11:20 +0200
Message-ID: <20100614211120.GB5483@bicker>
References: <20100529094907.GL5483@bicker> <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de> <20100614205849.GA26828@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100614205849.GA26828@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 14, 2010 at 10:58:49PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 10:07:23PM +0200, Johannes Hirte wrote:
> > I think you're wrong here. I've run into a kernel null pointer dereference at 
> > this point with a NFS exported btrfs filesystem:
> 
> Looks like you've applied the patch to a far too old kernel.  It can't
> be NULL for quite a while already.
> 

You're the expert, but it looks like it could be null in 2.6.34 like he
says.  I'm just looking at vfs_fsync_range() in
"git show v2.6.34:fs/sync.c".

> If you're testing patches posted to the mailinglists always make sure
> you have a recent enough kernel.

This actually was merged into the btrfs and the kernel.org trees
already.

I'm not sure how the btrfs backports work...

regards,
dan carpenter
