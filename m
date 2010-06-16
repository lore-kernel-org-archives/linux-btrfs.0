From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 11/11] btrfs: The file argument for fsync() is never null
Date: Wed, 16 Jun 2010 20:04:07 +0200
Message-ID: <201006162004.08433.johannes.hirte@fem.tu-ilmenau.de>
References: <20100529094907.GL5483@bicker> <201006142345.42014.johannes.hirte@fem.tu-ilmenau.de> <20100614220804.GM18266@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Christoph Hellwig <hch@lst.de>, Dan Carpenter <error27@gmail.com>,
	linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100614220804.GM18266@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag 15 Juni 2010, 02:08:20 schrieb Chris Mason:
> On Mon, Jun 14, 2010 at 11:45:40PM +0200, Johannes Hirte wrote:
> > Am Montag 14 Juni 2010, 23:16:01 schrieb Christoph Hellwig:
> > > On Mon, Jun 14, 2010 at 11:11:20PM +0200, Dan Carpenter wrote:
> > > > > Looks like you've applied the patch to a far too old kernel.  It
> > > > > can't be NULL for quite a while already.
> > > > 
> > > > You're the expert, but it looks like it could be null in 2.6.34 like
> > > > he says.  I'm just looking at vfs_fsync_range() in
> > > > "git show v2.6.34:fs/sync.c".
> > > 
> > > 2.6.34 is far too old.
> > 
> > For the changes yes, but not for working. I needed the btrfs fixes
> > without all the other bugs introduced with 2.6.35-rc. I was to careless
> > and pulled to much changes in. My fault.
> 
> Well, my fault.  I usually keep the btrfs-unstable tree against one
> release old, and the users have come to expect it.
> 
> I'll make a .34 branch that works.
> 
> -chris

What about backporting only the important patches to the stable series? Or 
would this be to much work for a still experimental filesystem?

regards,
  Johannes
