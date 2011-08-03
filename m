From: Simon Kirby <sim@hostway.ca>
Subject: Re: Hot rb_next, setup_cluster_no_bitmap
Date: Wed, 3 Aug 2011 16:10:59 -0700
Message-ID: <20110803231059.GB20056@hostway.ca>
References: <20110803220655.GE20966@hostway.ca> <20110803223949.GA20056@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110803223949.GA20056@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 03, 2011 at 03:39:49PM -0700, Simon Kirby wrote:

> On Wed, Aug 03, 2011 at 03:06:55PM -0700, Simon Kirby wrote:
> 
> > I see Josef's 86d4a77ba3dc4ace238a0556541a41df2bd71d49 introduced the
> > bitmaps list. I could try temporarily reverting this (some fixups needed)
> > if anybody thinks my cache bouncing idea might be slightly possible.
> 
> I'll try the attached and see how the profile changes.

Hmm, I bound the SMP affinity of all of the btrfs processes to one CPU,
and the page dirtying rate got slower, so I suspect the writes aren't
really a big deal, and the problem is just that there is way too much
walking going on after rsync has ran for a while and loads everything
into memory.

Any ideas?

Simon-
