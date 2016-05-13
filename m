Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:33064 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcEMLHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 07:07:43 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>, Clemens Eisserer <linuxhippy@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, <1i5t5.duncan@cox.net>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram =?iso-8859-1?Q?and_disk_are_ok._it_still_mounts,_but_I_cannot_repair?=
Date: Fri, 13 May 2016 13:07:30 +0200
MIME-Version: 1.0
Message-ID: <ef2e08cf-587c-4569-9600-9ad7bc45aab2@linuxsystems.it>
In-Reply-To: <a3a4e412-221d-c12b-284b-af53e4738211@gmail.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
 <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
 <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
 <20160509162940.GC15597@hungrycats.org>
 <c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
 <a3a4e412-221d-c12b-284b-af53e4738211@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On giovedì 12 maggio 2016 17:43:38 CEST, Austin S. Hemmelgarn wrote:
> That's probably a good indication of the CPU and the MB being 
> OK, but not necessarily the RAM.  There's two other possible 
> options for testing the RAM that haven't been mentioned yet 
> though (which I hadn't thought of myself until now):
> 1. If you have access to Windows, try the Windows Memory 
> Diagnostic. This runs yet another slightly different set of 
> tests from memtest86 and memtest86+, so it may catch issues they 
> don't.  You can start this directly on an EFI system by loading 
> /EFI/Microsoft/Boot/MEMTEST.EFI from the EFI system partition.
> 2. This is a Dell system.  If you still have the utility 
> partition which Dell ships all their per-provisioned systems 
> with, that should have a hardware diagnostics tool.  I doubt 
> that this will find anything (it's part of their QA procedure 
> AFAICT), but it's probably worth trying, as the memory testing 
> in that uses yet another slightly different implementation of 
> the typical tests.  You can usually find this in the boot 
> interrupt menu accessed by hitting F12 before the boot-loader 
> loads.

I tried the Dell System Test, including the enhanced optional ram tests and 
it was fine. I also tried the Microsoft one, which passed. BUT if I select 
the advanced test in the Microsoft One it always stops at 21% of first 
test. The test menus are still working, but fans get quiet and it keeps 
writing "test running... 21%" forever. I tried it many times and it always 
got stuck at 21%, so I suspect a test suite bug instead of a ram failure.

I also noticed some other interesting behaviours: while I was running the 
usual scrub+check (both were fine) from the livecd I noticed this in dmesg:
[  261.301159] BTRFS info (device dm-0): bdev /dev/mapper/cryptroot errs: 
wr 0, rd 0, flush 0, corrupt 4, gen 0
Corrupt? But both scrub and check were fine... I double checked scrub and 
check and they were still fine.

This is what happened another time: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1dGtPaWhTZ0w5aUU
I was making a backup of my partition USING DD from the livecd. It wasn't 
even mounted if I recall correctly!

On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
> That's what a RAM corruption problem looks like when you run btrfs scrub.
> Maybe the RAM itself is OK, but *something* is scribbling on it.
>
> Does the Arch live usb use the same kernel as your normal system?

Yes, except for the point release (the system is slightly ahead of the 
liveusb).

On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
> Did you try an older (or newer) kernel?  I've been running 4.5.x on a few
> canary systems, but so far none of them have survived more than a day.

No (except for point releases from 4.5.0 to 4.5.4), but I will try 4.4.

On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
> It's possible there's a problem that affects only very specific chipsets
> You seem to have eliminated RAM in isolation, but there could be a problem
> in the kernel that affects only your chipset.

Funny considering it is sold as a Linux laptop. Unfortunately they only 
tested it with the ancient Ubuntu 14.04.

Niccolò
