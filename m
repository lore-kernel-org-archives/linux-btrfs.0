Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36742 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933650AbdEVQcC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 12:32:02 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:59332 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1dCqFR-0004iU-Hk
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 09:32:01 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1dCqFQ-0000gk-VN
        for linux-btrfs@vger.kernel.org; Mon, 22 May 2017 09:31:56 -0700
Date: Mon, 22 May 2017 09:31:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
 <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170522013553.hspdrwpmxe5kyoas@merlins.org>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 21, 2017 at 06:35:53PM -0700, Marc MERLIN wrote:
> On Sun, May 21, 2017 at 04:45:57PM -0700, Marc MERLIN wrote:
> > On Sun, May 21, 2017 at 02:47:33PM -0700, Marc MERLIN wrote:
> > > gargamel:~# btrfs check --repair /dev/mapper/dshelf1
> > > enabling repair mode
> > > Checking filesystem on /dev/mapper/dshelf1
> > > UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
> > > checking extents
> > > 
> > > This causes a bunch of these:
> > > btrfs-transacti: page allocation stalls for 23508ms, order:0, mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
> > > btrfs-transacti cpuset=/ mems_allowed=0
> > > 
> > > What's the recommended way out of this and which code is at fault? I can't tell if btrfs is doing memory allocations wrong, or if it's just being undermined by the block layer dying underneath.
> > 
> > I went back to 4.8.10, and similar problem.
> > It looks like btrfs check exercises the kernel and causes everything to come down to a halt :(
> > 
> > Sadly, I tried a scrub on the same device, and it stalled after 6TB. The scrub process went zombie
> > and the scrub never succeeded, nor could it be stopped.
> 
> So, putting the btrfs scrub that stalled issue, I didn't quite realize
> that btrs check memory issues actually caused the kernel to eat all the
> memory until everything crashed/deadlocked/stalled.
> Is that actually working as intended?
> Why doesn't it fail and stop instead of taking my entire server down?
> Clearly there must be a rule against a kernel subsystem taking all the
> memory from everything until everything crashes/deadlocks, right?
> 
> So for now, I'm doing a lowmem check, but it's not going to be very
> helpful since it cannot repair anything if it finds a problem.
> 
> At least my machine isn't crashing anymore, I suppose that's still an
> improvement.
> gargamel:~# btrfs check --mode=lowmem /dev/mapper/dshelf1
> We'll see how many days it takes.

Well, at least it's finding errors, but of course it can't fix them
since lowmem doesn't have repair yet (yes, I know it's WIP)

I already have 24GB of RAM in that machine, adding more for the real
fsck repair to run, is going to be difficult and ndb would take days I
guess (then again I don't have a machine with 32 or 48 or 64GB of RAM
anyway).

I'm guessing my next step is to delete a lot of data from that array
until its metadata use gets back below something that fits in RAM :-/
But hopefully check --repair can be fixed not to crash your machine if
it needs more RAM than is available.

 
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking free space cache [.]
ERROR: root 53282 EXTENT_DATA[8244 4096] interrupt
ERROR: root 53282 EXTENT_DATA[50585 4096] interrupt
ERROR: root 53282 EXTENT_DATA[51096 4096] interrupt
ERROR: root 53282 EXTENT_DATA[182617 4096] interrupt
ERROR: root 53282 EXTENT_DATA[212972 4096] interrupt
ERROR: root 53282 EXTENT_DATA[260115 4096] interrupt
ERROR: root 53282 EXTENT_DATA[278370 4096] interrupt
ERROR: root 53282 EXTENT_DATA[323505 4096] interrupt
ERROR: root 53282 EXTENT_DATA[396923 4096] interrupt
ERROR: root 53282 EXTENT_DATA[419599 4096] interrupt
ERROR: root 53282 EXTENT_DATA[490602 4096] interrupt
ERROR: root 53282 EXTENT_DATA[555541 4096] interrupt
ERROR: root 53282 EXTENT_DATA[601942 4096] interrupt
ERROR: root 53282 EXTENT_DATA[682215 4096] interrupt
ERROR: root 53282 EXTENT_DATA[721729 4096] interrupt
ERROR: root 53282 EXTENT_DATA[916271 4096] interrupt
ERROR: root 53282 EXTENT_DATA[961074 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1118062 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1127879 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1142984 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1379975 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1398275 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1446265 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1459061 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1477900 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1477900 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1484265 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1509227 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1671096 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1692559 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1742832 4096] interrupt
ERROR: root 53282 EXTENT_DATA[1808649 4096] interrupt
ERROR: root 53292 EXTENT_DATA[57240 4096] interrupt
ERROR: root 53446 EXTENT_DATA[3554 4096] interrupt
ERROR: root 53446 EXTENT_DATA[64241 4096] interrupt
(...)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
