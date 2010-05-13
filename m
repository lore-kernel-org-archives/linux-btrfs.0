From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Date: Thu, 13 May 2010 08:41:00 -0400
Message-ID: <20100513084100.d06b266b.akpm@linux-foundation.org>
References: <20100512204052.GD3597@localhost.localdomain>
	<20100513151429.GA16916@infradead.org>
	<20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 May 2010 11:31:45 -0400 Josef Bacik <josef@redhat.com> wrote:

> On Thu, May 13, 2010 at 11:14:30AM -0400, Christoph Hellwig wrote:
> > On Wed, May 12, 2010 at 04:40:53PM -0400, Josef Bacik wrote:
> > > V1->V2
> > > -Use __blockdev_direct_IO instead of helper
> > > -Use KM_IRQ0 for kmap instead of KM_USER0
> > 
> > I still don't think this is correct.  The completion can come from
> > softirq and hardirq context, and possibly even normal process context.
> > You either need to check for all these, or you need to use the generic
> > complete in user context helper btrfs has available for other types
> > of I/O.
> > 
> 
> AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> context as the btrfs completion handler, so if it's ok for aio_complete it
> should be ok for btrfs right?  Thanks,
> 

Using KM_USERx from irq context is a horrid, horrid bug.

Using KM_IRQx with local interrupts enabled is a ditto.

It's OK to use KM_IRQx from process context as long as local interrupts
are disabled.

kmap slots are just per-cpu variables.  Each one has a particular usage
convention: process-context-only, must-be-irq-safe, etc.

