From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 09:29:23 -0500
Message-ID: <20100113142923.GL14979@think>
References: <20100112202513.GA13414@localhost.localdomain>
 <20100113102503.GA6887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113102503.GA6887@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 05:25:03AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 12, 2010 at 03:25:13PM -0500, Josef Bacik wrote:
> > df is a very loaded question in btrfs.  This gives us a way to get the per-space
> > usage information so we can tell exactly what is in use where.  This will help
> > us figure out ENOSPC problems, and help users better understand where their disk
> > space is going.
> 
> Just as discussed before I think it's a really bad idea.  We always had
> df reporting inconsistencies due to the way metadata is managed, and
> btrfs isn't special in that way.

This is more than just df being inaccurate, it's a way to find out how
much space is used by each of the raid modes.  We've had a ton of
feature requests for this, and it really helps identify drives that have
a ton of free space tied up for data vs metadata.

-chris

