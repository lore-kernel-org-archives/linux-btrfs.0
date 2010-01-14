From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 19:55:28 -0500
Message-ID: <20100114005528.GC3428@think>
References: <20100112202513.GA13414@localhost.localdomain>
 <20100113102503.GA6887@infradead.org>
 <20100113142923.GL14979@think>
 <20100113214620.GA27943@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113214620.GA27943@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 04:46:20PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 13, 2010 at 09:29:23AM -0500, Chris Mason wrote:
> > This is more than just df being inaccurate, it's a way to find out how
> > much space is used by each of the raid modes.  We've had a ton of
> > feature requests for this, and it really helps identify drives that have
> > a ton of free space tied up for data vs metadata.
> 
> Which again is not a fs specific feature.  Much better to add a statfs
> revision to the core that does this for everone.

Is anyone else splitting metadata and raid levels up like btrfs is?  As
far as I know we're the only snowflake in the kernel working like this.
I'm not against a generic revision, but I think btrfs needs to send out
significantly more data than the others.

> That would also
> have the nice side effect that we could actually make it statvfs and
> could get rid of the braindamage in glibc's current statvfs wrapper.
> 

-chris

