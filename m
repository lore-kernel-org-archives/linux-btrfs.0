Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24654 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbcC1F1C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 01:27:02 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Duncan'" <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <56F7B77F.9050306@gmail.com> <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
In-Reply-To: <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
Subject: RE: Raid 0 setup doubt.
Date: Mon, 28 Mar 2016 05:26:56 -0000
Message-ID: <001c01d188b2$732fbe40$598f3ac0$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry to interject here, but I think it's a bit overreaching to suggest
that swap isn't generally useful any more as a general-purpose member of
the memory hierarchy....

> Given that swap on spinning rust is slower than real
> RAM by several orders of magnitude, it'll still be far slower than real
> RAM, but twice as fast as it would be is better than otherwise, so...
> 
> 
> Tho how much RAM /do/ you have, and are you sure you really need swap at
> all?  Many systems today have enough RAM that they don't really need swap
> (at least as swap, see below), unless they're going to be used for
> something extremely memory intensive, where the much lower speed of swap
> isn't a problem.

For me, I use swap on an SSD, which is orders of magnitude faster than HDD.
Swap can still be useful on an SSD and can really close the gap between RAM
speeds and swap speeds.  (The original poster would do well to use one.)

So yeah, it's still "slow memory" but fast enough to be useful IMHO.

I find it's a useful safety net.  I'd rather have slower performance than
have outright failures.  Gives me time to react and free memory in a sane
fashion.  Why *not* use swap, if you have the drive capacity available?
The space is way cheaper than RAM, even for SSD.

> 
> Anyway, for systems with enough memory to not need swap in /normal/
> circumstances, in the event that something's actually leaking memory
> badly enough that swap is needed, there's a very good chance that you'll
> never outrun the leak with swap anyway, as if it's really leaking gigs of
> memory, it'll just eat up whatever gigs of swap you throw at it as well
> and /still/ run out of memory.

Often it's a slow leak and if you monitor the system, you have time to
identify the offending process and kill it before it impacts the rest of
the system.  Swap gives more time to do that.

> 
> Meanwhile, swap to spinning rust really is /slow/.  You're talking 16 GiB
> of swap, and spinning rust speeds of 50 MiB/sec for swap isn't unusual.
> That's ~20 seconds worth of swap-thrashing waiting per GiB, ~320 seconds
> or over five minutes worth of swap thrashing to use the full 16 GiB.  OK,
> so you take that priority= idea and raid0 over two devices, it'll still
> be ~2:40 worth of waiting, to fully use that swap.  Is 16 GiB of swap
> /really/ both needed and worth that sort of wait if you do actually use
> it?
>
> So swap, for its original use as slow memory at least, really isn't that
> much used any longer, tho it can still be quite useful in specific use-
> cases.

On my Windows boxes, I've exhausted system memory, and sometimes *not even
immediately noticed that I was out of physical RAM*.  The SSD-based swap
was that fast.  Eventually I realized the system was somewhat sluggish,
and closing some programs was easy to recover the system, and nothing ever
crashed.

Last week I ran chkdsk /R on a drive and apparently on Windows 7, chkdsk
will allocate all the free RAM it can get... apparently that is a
"feature" - anyway in my case, chkdsk allocates 26 GB on a 32 GB RAM
system that I heavily multitask on.  I never noticed the system was
swapping until an hour or two later when I had to start a VM and got an
error message (VirtualBox needed physical RAM to allocate)...

But before I had SSDs, HDD-based swap was.... very painful...  IMHO, HDDs
are obsolete for use for storing operating systems and swap.  I strongly
suggest the original poster add an SSD to the mix. :)

And now with things like bcache, we can put SSDs into their proper place
in the memory hierarchy: Registers > L1 cache > L2 > L3 > DRAM > SSD > HDD.
So conceivably the swap could be on both SSD and HDD, but you probably
don't need _that_ much swap...

Best regards,

James Johnston


