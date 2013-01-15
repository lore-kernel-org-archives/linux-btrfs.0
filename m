Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50097 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab3AOXoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 18:44:16 -0500
Date: Tue, 15 Jan 2013 18:44:11 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Tom Kusmierz <tom.kusmierz@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
Message-ID: <20130115234411.GA30647@shiny.int.fusionio.com>
References: <50F3E77B.2030901@gmail.com>
 <20130114145904.GA1387@shiny>
 <50F422BC.4000901@gmail.com>
 <20130114155718.GC1387@shiny>
 <50F43319.9040009@gmail.com>
 <20130114163433.GD1387@shiny>
 <50F5E6FA.60803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50F5E6FA.60803@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 04:32:10PM -0700, Tom Kusmierz wrote:
> Chris & all,
> 
> Sorry for not replying for that long but Chris old friend "stress.sh" 
> have proven that all my storage is affected with this bug and first 
> thing was to bring everything down before corruptions will spread any 
> further. Anyway for subject sake btrfs stress have failed after 2h, ext4 
> stress have failed after 8h (according to "time ./stress.sh blablabla" ) 
> - so it might be related to that ext4 always seamed slower on my machine 
> than btrfs.

Ok, great.  These problems are really hard to debug, and I'm glad we've
nailed it down to the lower layers.

> 
> 
> Anyway I wanted to use this opportunity to thank Chris and everybody 
> related to btrfs development - your file system found a hidden bug in my 
> set up that would be there until it would pretty much corrupt 
> everything. I don't even want to think how much my main storage got 
> corrupted over time (etx4 over lvm over md raid 5).
> 
> p.s. bizzare that when I "fill" ext4 partition with test data everything 
> check's up OK (crc over all files), but with Chris tool it gets 
> corrupted - for both Adaptec crappy pcie controller and for mother board 
> built in one.

One really hard part of tracking down corruptions is that our boxes have
so much ram right now that they are often hidden by the page cache.  My
first advice is to boot with much less ram (1G/2G) or pin down all your
ram for testing.  A problem that triggers in 10 minutes is a billion
times easier to figure out than one that triggers in 8 hours.

> Also since courses of history proven that my testing 
> facilities are crap - any suggestion's on how can I test ram, cpu & 
> controller would be appreciated.

Step one is to figure out if you've got a CPU/memory problem or an IO problem.
memtest is often able to find CPU and memory problems, but if you pass
memtest I like to use gcc for extra hard testing.

If you have the ram, make a copy of the linux kernel tree in /dev/shm or
any ramdisk/tmpfs mount.  Then run make -j ; make clean in a loop until
your box either crashes, gcc reports an internal compiler error, or 16
hours go by.  Your loop will need to check for failed makes and stop
once you get the first failure.

Hopefully that will catch it.  Otherwise we need to look at the IO
stack.

-chris
