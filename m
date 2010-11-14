From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Sun, 14 Nov 2010 21:42:06 +0100
Message-ID: <20101114204206.GV6809@random.random>
References: <1289236257.3611.3.camel@mars>
 <1289310046-sup-839@think>
 <1289326892.4231.2.camel@mars>
 <1289764507.4303.9.camel@mars>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Shane Shrybman <shrybman@teksavvy.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289764507.4303.9.camel@mars>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Shane,

On Sun, Nov 14, 2010 at 02:55:07PM -0500, Shane Shrybman wrote:
> Hi Andrea!
> 
> Long time since our last bug fix :) I still have fond memories of
> 2.4.23-aa kernels, best of all time!

Nice memories of good times :)

> I couldn't find any other mention of this corruption issue with THP and
> btrfs, so I was just checking to see if there has been any progress?

btrfs misses this:

+       .migratepage    = btree_migratepage,

It's a bug that can trigger upstream too (not only with THP) if there
are hugepage allocations (like while incrasing nr_hugepages). Chris
already fixed it with an experimental patch.
