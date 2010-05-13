From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Date: Thu, 13 May 2010 11:26:39 -0400
Message-ID: <20100513152639.GA30954@infradead.org>
References: <20100512204052.GD3597@localhost.localdomain> <20100513151429.GA16916@infradead.org> <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 13, 2010 at 11:31:45AM -0400, Josef Bacik wrote:
> AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> context as the btrfs completion handler, so if it's ok for aio_complete it
> should be ok for btrfs right?  Thanks,

aio_complete does a spin_lock_irqsave before that, which disables
interrupts on the local CPU.
