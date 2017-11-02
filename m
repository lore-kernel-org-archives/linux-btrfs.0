Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:47982 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdKBShr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 14:37:47 -0400
Received: by mail-io0-f196.google.com with SMTP id h70so1099501ioi.4
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 11:37:46 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk>
 <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <23034.2305.527872.772343@tree.ty.sabi.co.uk>
 <CAH=dxU6bhi=xwugt+nynU5BSnvBzZ5L=C5nxPt39v14YwhcNCA@mail.gmail.com>
 <11db29b3-e421-2b0b-68d5-fb6c233d0767@gmail.com>
 <CAH=dxU4Rnhajhmq6j0B8t82_YUfUCSbestfSivm3JDwuV=6wYA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <cbb18834-342a-c724-35ac-8bb9dcfe0a35@gmail.com>
Date: Thu, 2 Nov 2017 14:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4Rnhajhmq6j0B8t82_YUfUCSbestfSivm3JDwuV=6wYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-02 14:09, Dave wrote:
> On Thu, Nov 2, 2017 at 7:17 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>>> And the worst performing machine was the one with the most RAM and a
>>> fast NVMe drive and top of the line hardware.
>>
>> Somewhat nonsensically, I'll bet that NVMe is a contributing factor in this
>> particular case.  NVMe has particularly bad performance with the old block
>> IO schedulers (though it is NVMe, so it should still be better than a SATA
>> or SAS SSD), and the new blk-mq framework just got scheduling support in
>> 4.12, and only got reasonably good scheduling options in 4.13.  I doubt it's
>> the entirety of the issue, but it's probably part of it.
> 
> Thanks for that news. Based on that, I assume the advice here (to use
> noop for NVMe) is now outdated?
> https://stackoverflow.com/a/27664577/463994
> 
> Is the solution as simple as running a kernel >= 4.13? Or do I need to
> specify which scheduler to use?
> 
> I just checked one computer:
> 
> uname -a
> Linux morpheus 4.13.5-1-ARCH #1 SMP PREEMPT Fri Oct 6 09:58:47 CEST
> 2017 x86_64 GNU/Linux
> 
> $ sudo find /sys -name scheduler -exec grep . {} +
> /sys/devices/pci0000:00/0000:00:1d.0/0000:08:00.0/nvme/nvme0/nvme0n1/queue/scheduler:[none]
> mq-deadline kyber bfq
> 
>  From this article, it sounds like (maybe) I should use kyber. I see
> kyber listed in the output above, so I assume that means it is
> available. I also think [none] is the current scheduler being used, as
> it is in brackets.
> 
> I checked this:
> https://www.kernel.org/doc/Documentation/block/switching-sched.txt
> Based on that, I assume I would do this at runtime:
> 
> echo kyber > /sys/devices/pci0000:00/0000:00:1d.0/0000:08:00.0/nvme/nvme0/nvme0n1/queue/scheduler
> 
> I assume this is equivalent:
> 
> echo kyber > /sys/block/nvme0n1/queue/scheduler
> 
> How would I set it permanently at boot time?
It's kind of complicated overall.  As of 4.14, there are four options 
for the blk-mq path.  The 'none' scheduler is the old behavior prior to 
4.13, and does no scheduling.  'mq-deadline' is the default AFAIK, and 
behaves like the old deadline I/O scheduler (not sure if it supports I/O 
priorities).  'bfq' is a blk-mq port of a scheduler originally designed 
to replace the default CFQ scheduler from the old block layer.  'kyber' 
I know essentially nothing about, I never saw the patches on LKML (not 
sure if I just missed them, or they only went to topic lists), and I've 
not tried it myself.

I have no personal experience with anything but the none scheduler on 
NVMe devices, so i can't really comment much more than saying that I've 
seen a huge difference on the SATA SSD's I use first when the deadline 
scheduler became the default and then again when I switched to BFQ on my 
systems, and the fact that I've seen reports of using the deadline 
scheduler improving things on NVMe.

As far as setting it at boot time, there's currently no kernel 
configuration option to set a default like there is for the old block 
interface, and I don't know of any kernel command line option to set it 
either, but a udev rule setting it as a attribute works reliably.  I'm 
using something like the following to set all my SATA devices to use BFQ 
by default:

KERNEL=="sd?", SUBSYSTEM=="block", ACTION=="add", 
ATTR{queue/scheduler}="bfq"
> 
>>> While Firefox and Linux in general have their performance "issues",
>>> that's not relevant here. I'm comparing the same distros, same Firefox
>>> versions, same Firefox add-ons, etc. I eventually tested many hardware
>>> configurations: different CPU's, motherboards, GPU's, SSD's, RAM, etc.
>>> The only remaining difference I can find is that the computer with
>>> acceptable performance uses LVM + EXT4 while all the others use BTRFS.
>>>
>>> With all the great feedback I have gotten here, I'm now ready to
>>> retest this after implementing all the BTRFS-related suggestions I
>>> have received. Maybe that will solve the problem or maybe this mystery
>>> will continue...
>>
>> Hmm, if you're only using SSD's, that may partially explain things.  I don't
>> remember if it was mentioned earlier in this thread, but you might try
>> adding 'nossd' to the mount options.  The 'ssd' mount option (which gets set
>> automatically if the device reports as non-rotational) impacts how the block
>> allocator works, and that can have a pretty insane impact on performance.
> 
> I will test the "nossd" mount option.
If you're not seeing any difference on the newest kernels (I hadn't 
realized you were running 4.13 on anything), you might not see any 
impact from doing this.  I'd also suggest running a full balance prior 
to testing _after_ switching the option, part of the performance impact 
is due to the resultant on-disk layout.
> 
>> Additionally, independently from that, try toggling the 'discard' mount
>> option.  If you have it enabled, disable it, if you have it disabled, enable
>> it.  Inline discards can be very expensive on some hardware, especially
>> older SSD's, and discards happen pretty frequently in a COW filesystem.
> 
> I have been following this advice, so I have never enabled discard for
> an NVMe drive. Do you think it is worth testing?
> 
> Solid State Drives/NVMe - ArchWiki
> https://wiki.archlinux.org/index.php/Solid_State_Drives/NVMe
> 
> Discards:
> Note: Although continuous TRIM is an option (albeit not recommended)
> for SSDs, NVMe devices should not be issued discards.
I've never heard this particular advice before, and it offers no source 
for the claim.  I have seen Intel's advice that they quote below that 
before though, and would tend to agree with it for most users.  The part 
that makes this all complicated is that different devices handle batched 
discards (what the Arch people call 'Periodic TRIM') and on-demand 
discards (what the Arch people call 'Continuous TRIM') differently. 
Some devices (especially old ones) do better with batched discards, 
while others seem to do better with on-demand discards.  On top of that, 
there's significant variance based on the actual workload (including 
that from the filesystem itself).

Based on my own experience using BTRFS on SATA SSD's, it's usually 
better to do batched discards unless you only write to the filesystem 
infrequently, because:
1. Each COW operation triggers an associated discard (this can seriously 
kill your performance).
2. Because old copies of blocks get discarded immediately, it's much 
harder to recover a damaged filesystem.

There are some odd exceptions though.  If for example you're running 
BTRFS on a ramdisk or ZRAM device, you should just use on-demand 
discards, as that will free up memory immediately.
