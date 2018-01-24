Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52614 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbeAXXSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 18:18:08 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eeUGn-0002fD-DD
        for linux-btrfs@vger.kernel.org; Thu, 25 Jan 2018 00:15:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: bad key ordering - repairable?
Date: Wed, 24 Jan 2018 23:15:38 +0000 (UTC)
Message-ID: <pan$90574$4f3a26c9$e38a1488$c00f0eb7@cox.net>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
        <20180122212250.GY3807@carfax.org.uk>
        <CAEY8F1pstmMVaypLo31vkvOWZZw0L_-d4U4=3LpoQCcJHyZ91Q@mail.gmail.com>
        <CAEY8F1qBNg=_PszmbEMMTG83zzmpU4Qc=rQhHOjjVCCcOw3X6g@mail.gmail.com>
        <CAJCQCtS_=kK1L4ob1YsOO7G2LAGXBiweEMjuSFXw7NBK2OWoZg@mail.gmail.com>
        <CAEY8F1oUdNjvcx0DGqsdZqzfeRKEckf_a2KRAjcESyr1uuH1Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Claes Fransson posted on Wed, 24 Jan 2018 20:44:33 +0100 as excerpted:

> So, I have now some results from the PassMark Memtest86! I let the
> default automatic tests run for about 19 hours and 16 passes. It
> reported zero "Errors", but 4 lines of "[Note] RAM may be vulnerable to
> high frequency row hammer bit flips". If I understand it correctly,
> it means that some errors were detected when the RAM was tested at
> higher rates than guaranteed accurate by the vendors.

>From Wikipedia:

Row hammer (also written as rowhammer) is an unintended side effect in 
dynamic random-access memory (DRAM) that causes memory cells to leak 
their charges and interact electrically between themselves, possibly 
altering the contents of nearby memory rows that were not addressed in 
the original memory access. This circumvention of the isolation between 
DRAM memory cells results from the high cell density in modern DRAM, and 
can be triggered by specially crafted memory access patterns that rapidly 
activate the same memory rows numerous times.[1][2][3]

The row hammer effect has been used in some privilege escalation computer 
security exploits.

https://en.wikipedia.org/wiki/Row_hammer

So it has nothing to do with (generic) testing the RAM at higher rates 
than guaranteed by the vendors, but rather, with deliberate rapid 
repeated access (at normal clock rates) of the same cell rows in ordered 
to trigger a bitflip in nearby memory cells that could not normally be 
accessed due to process separation and insufficient privileges.

IOW, it's unlikely to be accidentally tripped, and thus is exceedingly 
unlikely to be relevant here, unless you're being hacked, of course.


That said, and entirely unrelated to rowhammer, I know one of the 
problems of memory test false-negatives from experience.

In my case, I was even running ECC RAM.  But the memory I had purchased 
(back in the day when memory was far more expensive and sub-GB memory was 
the norm) was cheap, and as it happened, marked as stable at slightly 
higher clock rates than it actually was.  But I couldn't afford more (or 
I'd have procured less dodgy RAM in the first place) and had little 
recourse but to live with it for awhile.  A year or so later there was a 
BIOS update that added better memory clocking control, and I was able to 
declock the RAM slightly from its rating (IIRC to PC-3000 level, it was 
PC3200 rated, this was DDR1 era), after which it was /entirely/ stable, 
even after reducing some of the wait-state settings somewhat to try to 
claw back some of what I lost due to the underclocking.

I run gentoo, and nearly all of my problems occurred when I was doing 
updates, building packages at 100% CPU with multiple cores accessing the 
same RAM.  FWIW, the most frequent /detected/ problem was bunzip checksum 
errors as it decompressed and verified the data in memory (before writing 
out)... that would move or go away if I tried again.  Occasionally I'd 
get machine-check errors (MCEs), but not frequently, and the ECC RAM 
subsystem /never/ reported errors.

But the memory tests gave that memory an all-clear.

The problem with the memory tests in this case is that they tend to work 
on an otherwise unloaded system, and test the retention of the memory 
cells, /not/ so much the speed and reliability at which they are accessed 
under fully loaded system stress -- and how could they when memory speed 
is normally set by the BIOS and not something the memory tester has 
access to?

But my memory problems weren't with the memory cells themselves -- they 
retained their data just fine and indeed it was ECC RAM so would have 
triggered ECC errors if they didn't -- but with the precision timing of 
memory IO -- it wasn't quite up to the specs it claimed to support and 
would occasionally produce in-transit errors (the ECC would have detected 
and possibly corrected errors in storage), and the memory testers simply 
didn't test that like a fully loaded system doing unpacks of sources and 
builds from them did.

As mentioned, once I got a BIOS update that let me declock the RAM a bit, 
everything was fine, and it remained fine when I did upgrade the RAM some 
years later, after prices had fallen, as well.

(The system was first-gen AMD Opteron, on a server-grade Tyan board, that 
I ran from purchase in late 2003 for over eight years, maxing out the 
pair of CPUs to dual-core Opteron 290s and the RAM to 8 gigs, over time, 
until the board finally died in 2012 due to burst capacitors.  Which 
reminds me, I'm still running the replacement, a Gigabyte with an fx6100 
overclocked a bit to 3.9 GHz and 16 gig RAM, and it's now nearing six 
years old, so I suppose I better start planning for the next upgrade...  
I've spent that six years upgrading to big-screen TVs as monitors, with a 
65inch/165cm 4K as my primary now and a 48inch/122cm as a secondary to 
put youtube or whatever on fullscreen, and to now my second generation of 
ssds, a pair of 1 TB samsung evos, but this reminds me that at nearing 
six years old the main system's aging too, so I better start thinking of 
replacing it again...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

