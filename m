From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Date: Thu, 13 May 2010 11:14:30 -0400
Message-ID: <20100513151429.GA16916@infradead.org>
References: <20100512204052.GD3597@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100512204052.GD3597@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 12, 2010 at 04:40:53PM -0400, Josef Bacik wrote:
> V1->V2
> -Use __blockdev_direct_IO instead of helper
> -Use KM_IRQ0 for kmap instead of KM_USER0

I still don't think this is correct.  The completion can come from
softirq and hardirq context, and possibly even normal process context.
You either need to check for all these, or you need to use the generic
complete in user context helper btrfs has available for other types
of I/O.
