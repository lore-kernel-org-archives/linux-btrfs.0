Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47696 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757112AbdEVBf6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 21:35:58 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:49922 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1dCcGI-0003Ld-A9
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 18:35:57 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1dCcGH-000461-J2
        for linux-btrfs@vger.kernel.org; Sun, 21 May 2017 18:35:53 -0700
Date: Sun, 21 May 2017 18:35:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170522013553.hspdrwpmxe5kyoas@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
 <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 21, 2017 at 04:45:57PM -0700, Marc MERLIN wrote:
> On Sun, May 21, 2017 at 02:47:33PM -0700, Marc MERLIN wrote:
> > gargamel:~# btrfs check --repair /dev/mapper/dshelf1
> > enabling repair mode
> > Checking filesystem on /dev/mapper/dshelf1
> > UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
> > checking extents
> > 
> > This causes a bunch of these:
> > btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
> > btrfs-transacti cpuset=/ mems_allowed=0
> > 
> > What's the recommended way out of this and which code is at fault? I can't tell if btrfs is doing memory allocations wrong, or if it's just being undermined by the block layer dying underneath.
> 
> I went back to 4.8.10, and similar problem.
> It looks like btrfs check exercises the kernel and causes everything to come down to a halt :(
> 
> Sadly, I tried a scrub on the same device, and it stalled after 6TB. The scrub process went zombie
> and the scrub never succeeded, nor could it be stopped.

So, putting the btrfs scrub that stalled issue, I didn't quite realize
that btrs check memory issues actually caused the kernel to eat all the
memory until everything crashed/deadlocked/stalled.
Is that actually working as intended?
Why doesn't it fail and stop instead of taking my entire server down?
Clearly there must be a rule against a kernel subsystem taking all the
memory from everything until everything crashes/deadlocks, right?

So for now, I'm doing a lowmem check, but it's not going to be very
helpful since it cannot repair anything if it finds a problem.

At least my machine isn't crashing anymore, I suppose that's still an
improvement.
gargamel:~# btrfs check --mode=lowmem /dev/mapper/dshelf1
We'll see how many days it takes.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
