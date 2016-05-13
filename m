Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36298 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcEMLfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 07:35:05 -0400
Received: by mail-io0-f194.google.com with SMTP id k129so14363399iof.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 04:35:04 -0700 (PDT)
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
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
 <ef2e08cf-587c-4569-9600-9ad7bc45aab2@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org, Clemens Eisserer <linuxhippy@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, 1i5t5.duncan@cox.net
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <994b4fa5-c7ef-27e1-2fc2-386ab62a16c0@gmail.com>
Date: Fri, 13 May 2016 07:35:01 -0400
MIME-Version: 1.0
In-Reply-To: <ef2e08cf-587c-4569-9600-9ad7bc45aab2@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-13 07:07, Niccolò Belli wrote:
> On giovedì 12 maggio 2016 17:43:38 CEST, Austin S. Hemmelgarn wrote:
>> That's probably a good indication of the CPU and the MB being OK, but
>> not necessarily the RAM.  There's two other possible options for
>> testing the RAM that haven't been mentioned yet though (which I hadn't
>> thought of myself until now):
>> 1. If you have access to Windows, try the Windows Memory Diagnostic.
>> This runs yet another slightly different set of tests from memtest86
>> and memtest86+, so it may catch issues they don't.  You can start this
>> directly on an EFI system by loading /EFI/Microsoft/Boot/MEMTEST.EFI
>> from the EFI system partition.
>> 2. This is a Dell system.  If you still have the utility partition
>> which Dell ships all their per-provisioned systems with, that should
>> have a hardware diagnostics tool.  I doubt that this will find
>> anything (it's part of their QA procedure AFAICT), but it's probably
>> worth trying, as the memory testing in that uses yet another slightly
>> different implementation of the typical tests.  You can usually find
>> this in the boot interrupt menu accessed by hitting F12 before the
>> boot-loader loads.
>
> I tried the Dell System Test, including the enhanced optional ram tests
> and it was fine. I also tried the Microsoft one, which passed. BUT if I
> select the advanced test in the Microsoft One it always stops at 21% of
> first test. The test menus are still working, but fans get quiet and it
> keeps writing "test running... 21%" forever. I tried it many times and
> it always got stuck at 21%, so I suspect a test suite bug instead of a
> ram failure.
I've actually seen this before on other systems (different completion 
percentage on each system, but otherwise the same), all of them ended up 
actually having a bad CPU or MB, although the ones with CPU issues were 
fine after BIOS updates which included newer microcode.
>
> I also noticed some other interesting behaviours: while I was running
> the usual scrub+check (both were fine) from the livecd I noticed this in
> dmesg:
> [  261.301159] BTRFS info (device dm-0): bdev /dev/mapper/cryptroot
> errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> Corrupt? But both scrub and check were fine... I double checked scrub
> and check and they were still fine.
It's worth noting that these are running counts of errors since the last 
time the stats were reset (and they only get reset manually).  If you 
haven't reset the stats, then this isn't all that surprising.
>
> This is what happened another time:
> https://drive.google.com/open?id=0Bwe9Wtc-5xF1dGtPaWhTZ0w5aUU
> I was making a backup of my partition USING DD from the livecd. It
> wasn't even mounted if I recall correctly!
The fact that you're getting an OOPS involving core kernel threads 
(kswapd) is a pretty good indication that either there's a bug elsewhere 
in the kernel, or that something is wrong with your hardware.  it's 
really difficult to be certain if you don't have a reliable test case 
though.
>
> On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
>> That's what a RAM corruption problem looks like when you run btrfs scrub.
>> Maybe the RAM itself is OK, but *something* is scribbling on it.
>>
>> Does the Arch live usb use the same kernel as your normal system?
>
> Yes, except for the point release (the system is slightly ahead of the
> liveusb).
>
> On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
>> Did you try an older (or newer) kernel?  I've been running 4.5.x on a few
>> canary systems, but so far none of them have survived more than a day.
>
> No (except for point releases from 4.5.0 to 4.5.4), but I will try 4.4.
FWIW, I've been running 4.5 with almost no issues on my laptop since it 
came out (the few issues I have had are not unique to 4.5, and are all 
ultimately firmware issues (Lenovo has been getting _really_ bad 
recently about having broken ACPI and EFI implementations...)).  Of 
course, I'm also running Gentoo, so everything is built locally, but I 
doubt that that has much impact on stability.
>
> On giovedì 12 maggio 2016 18:48:17 CEST, Zygo Blaxell wrote:
>> It's possible there's a problem that affects only very specific chipsets
>> You seem to have eliminated RAM in isolation, but there could be a
>> problem
>> in the kernel that affects only your chipset.
>
> Funny considering it is sold as a Linux laptop. Unfortunately they only
> tested it with the ancient Ubuntu 14.04.
Sadly, this is pretty typical for anything sold as a 'Linux' system that 
isn't a server.  Even for the servers sold as such, it's not unusual for 
it to only be tested with with old versions of CentOS.

Now, I hadn't thought of this before, but it's a Dell system, so you're 
trapping out to SMBIOS for everything under the sun, and if they don't 
pass a correct memory map (or correct ACPI tables) to the OS during 
boot, then there may be some sections of RAM that both Linux and the 
firmware think they can use, which could definitely result in symptoms 
like bad RAM while still consistently passing memory tests (because they 
don't make BIOS calls after they have the system info they need).
