From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and 1 billion small files
Date: Tue, 8 May 2012 16:54:39 -0400
Message-ID: <20120508205439.GE11876@shiny>
References: <1913174825.1910.1336382310577.JavaMail.root@zimbra.interconnessioni.it>
 <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
 <20120508123153.GS11876@shiny>
 <jobitp$lju$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Martin <m_btrfs@ml1.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jobitp$lju$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2012 at 05:51:05PM +0100, Martin wrote:
> On 08/05/12 13:31, Chris Mason wrote:
> 
> [...]
> > A few people have already mentioned how btrfs will pack these small
> > files into metadata blocks.  If you're running btrfs on a single disk,
> 
> [...]
> > But the cost is increased CPU usage.  Btrfs hits memmove and memcpy
> > pretty hard when you're using larger blocks.
> > 
> > I suggest using a 16K or 32K block size.  You can go up to 64K, it may
> > work well if you have beefy CPUs.  Example for 16K:
> > 
> > mkfs.btrfs -l 16K -n 16K /dev/xxx
> 
> Is that still with "-s 4K" ?

Yes, the data sector size should still be the same as the page size.

> 
> 
> Might that help SSDs that work in 16kByte chunks?

Most ssds today work in much larger chunks, so the bulk of the benefit
comes from better packing, and fewer extent records required to hold the
same amount of metadata.

> 
> And why are memmove and memcpy more heavily used?
> 
> Does that suggest better optimisation of the (meta)data, or just a
> greater housekeeping overhead to shuffle data to new offsets?

Inserting something into the middle of a block is more expensive because
we have to shift left and right first.  The bigger the block, the more
we have to shift.

-chris
