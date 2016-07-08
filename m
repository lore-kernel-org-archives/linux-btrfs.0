Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35543 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbcGHMO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 08:14:57 -0400
Received: by mail-it0-f67.google.com with SMTP id f6so1693486ith.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 05:14:57 -0700 (PDT)
Subject: Re: raid1 has failing disks, but smart is clear
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Corey Coughlin <corey.coughlin.cc3@gmail.com>
References: <577D82AE.3040005@gmail.com>
 <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
 <7d6827bd-a978-13ab-6732-b7cf7d21bdb8@gmail.com> <577F3107.6040806@gmail.com>
 <CAKinxcWScz6Azu=RDQPcnj4zr0jjyZ62QEQT18O7mOKz-E+jfQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8d9f3f42-4a96-6791-790d-89ce02e5caaf@gmail.com>
Date: Fri, 8 Jul 2016 08:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKinxcWScz6Azu=RDQPcnj4zr0jjyZ62QEQT18O7mOKz-E+jfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-08 07:14, Tomasz Kusmierz wrote:
>>
>> Well, I was able to run memtest on the system last night, that passed with
>> flying colors, so I'm now leaning toward the problem being in the sas card.
>> But I'll have to run some more tests.
>>
>
> Seriously use the "stres.sh" for couple of days, When I was running
> memtest it was running continuously for 3 days without the error, day
> of stres.sh and errors started showing up.
> Be VERY careful with trusting any sort of that tool, modern CPU's lye
> to you continuously !!!
> 1. You may think that you've wrote best on the planet code that
> bypasses a CPU cache, but in reality since CPU's are multicore you can
> end up with overzealous MPMD traping you inside of you cache memory
> and all you resting will do is write a page (trapped in cache) read it
> from cache (coherency mechanism, not the mis/hit one) will trap you
> inside of L3 so you have no clue you don't touch the ram, then CPU
> will just dump your page to RAM and "job done"
> 2. Since coherency problems and real problems with non blocking on
> mpmd you can have a DMA controller sucking pages out your own cache,
> due to ram being marked as dirty and CPU will try to spare the time
> and accelerate the operation to push DMA straigh out of L3 to
> somewhere else (mentioning that sine some testers use crazy way of
> forcing your ram access via DMA to somewhere and back to force droping
> out of L3)
> 3. This one is actually funny: some testers didn't claim the pages to
> the process so for some reason pages that the were using were not
> showing up as used / dirty etc so all the testing was done 32kB of L1
> ... tests were fast thou :)
>
> srters.sh will test operation of the whole system !!! it shifts a lot
> of data so disks are engaged, CPU keeps pumping out CRC32 all the time
> so it's busy, RAM gets hit nicely as well due to high DMA.
Agreed, never just trust memtest86 or memtest86+.

FWIW< here's the routine I go through to test new RAM:
1. Run regular memtest86 for at least 3 full cycles in full SMP mode (F2 
while starting up to force SMP).  On some systems this may hang, but 
that's an issue in the BIOS's setup of the CPU and MC, not the RAM, and 
is generally not indicative of a system which will have issues.
2. Run regular memtest86 for at least 3 full cycles in regular UP mode 
(the default on most non-NUMA hardware).
3. Repeat 1 and 2 with memtest86+.  It's diverged enough from regular 
memtest86 that it's functionally a separate tool, and I've seen RAM that 
passes one but not the other on multiple occasions before.
4. Boot SystemRescueCD, download a copy of the Linux sources, and run as 
many allmodconfig builds in parallel as I have CPU's, each with a number 
of make jobs equal to the twice number of CPU's (so each CPU ends up 
running at least two threads).  This forces enough context switching to 
completely trash even the L3 cache on almost any modern processor, which 
means it forces things out to RAM.  It won't hit all your RAM, but I've 
found it to be a relatively reliable way to verify the memory bus and 
the memory controller work properly.
5. Still from SystemRescueCD, use a tool called memtester (essentially 
memtest86, but run from userspace) to check the RAM.
6. Still from SystemRescueCD, use sha1sum to compute SHA-1 hashes of all 
the disks in the system, using at least 8 instances of sha1sum per CPU 
core, and make sure that all the sums for a disk match.
7. Do 6 again, but using cat to compute the sum of a concatenation of 
all the disks in the system (so the individual commands end up being 
`cat /dev/sd? | sha1sum`).  This will rapidly use all available memory 
on the system and keep it in use for quite a while.
8. If I'm using my home server system, I also have a special virtual 
runlevel set up where I spin up 4 times as many VM's as I have CPU cores 
(so on my current 8 core system, I spin up 32), all assigned a part of 
the RAM not used by the host (which I shrink to the minimum useable size 
of about 500MB), all running steps 1-3 in parallel.

It may also be worth mentioning that I've seen very poorly behaved HBA's 
that produce symptoms that look like bad RAM, including issues not 
related to the disks themselves, yet show no issues when regular memory 
testing is run.
>
> When come to think about it, if your device points change during
> operation of the system it might be an LSI card dying -> reinitialize
> -> rediscovering drives -> drives show up in different point. On my
> system I can hot swap sata and it will come up with different dev even
> thou it was connected to same place on the controller.
Barring a few odd controllers I've seen which support hot-plug but not 
hot-remove, that shouldn't happen unless the device is in use, and in 
that case it only happens because of the existing open references to the 
device being held by whatever is using it.
>
> I think, most important - I presume you run nonECC ?
And if not, how well shielded is your system?  You can often get by with 
non-ECC RAM if you have good EMI shielding and reboot regularly.  Most 
servers actually do have good EMI shielding, and many pre-built desktops 
do, but a lot of DIY systems don't (especially if ti's a gaming case, 
the poly-carbonate windows many of them have in the side panel are a 
_huge_ hole in the EMI shielding).
