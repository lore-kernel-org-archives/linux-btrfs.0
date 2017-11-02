Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:54793 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbdKBSJp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 14:09:45 -0400
Received: by mail-wm0-f53.google.com with SMTP id r68so668962wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 11:09:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11db29b3-e421-2b0b-68d5-fb6c233d0767@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net> <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk> <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <23034.2305.527872.772343@tree.ty.sabi.co.uk> <CAH=dxU6bhi=xwugt+nynU5BSnvBzZ5L=C5nxPt39v14YwhcNCA@mail.gmail.com>
 <11db29b3-e421-2b0b-68d5-fb6c233d0767@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Thu, 2 Nov 2017 14:09:22 -0400
Message-ID: <CAH=dxU4Rnhajhmq6j0B8t82_YUfUCSbestfSivm3JDwuV=6wYA@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 2, 2017 at 7:17 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> And the worst performing machine was the one with the most RAM and a
>> fast NVMe drive and top of the line hardware.
>
> Somewhat nonsensically, I'll bet that NVMe is a contributing factor in this
> particular case.  NVMe has particularly bad performance with the old block
> IO schedulers (though it is NVMe, so it should still be better than a SATA
> or SAS SSD), and the new blk-mq framework just got scheduling support in
> 4.12, and only got reasonably good scheduling options in 4.13.  I doubt it's
> the entirety of the issue, but it's probably part of it.

Thanks for that news. Based on that, I assume the advice here (to use
noop for NVMe) is now outdated?
https://stackoverflow.com/a/27664577/463994

Is the solution as simple as running a kernel >= 4.13? Or do I need to
specify which scheduler to use?

I just checked one computer:

uname -a
Linux morpheus 4.13.5-1-ARCH #1 SMP PREEMPT Fri Oct 6 09:58:47 CEST
2017 x86_64 GNU/Linux

$ sudo find /sys -name scheduler -exec grep . {} +
/sys/devices/pci0000:00/0000:00:1d.0/0000:08:00.0/nvme/nvme0/nvme0n1/queue/scheduler:[none]
mq-deadline kyber bfq

>From this article, it sounds like (maybe) I should use kyber. I see
kyber listed in the output above, so I assume that means it is
available. I also think [none] is the current scheduler being used, as
it is in brackets.

I checked this:
https://www.kernel.org/doc/Documentation/block/switching-sched.txt
Based on that, I assume I would do this at runtime:

echo kyber > /sys/devices/pci0000:00/0000:00:1d.0/0000:08:00.0/nvme/nvme0/nvme0n1/queue/scheduler

I assume this is equivalent:

echo kyber > /sys/block/nvme0n1/queue/scheduler

How would I set it permanently at boot time?

>> While Firefox and Linux in general have their performance "issues",
>> that's not relevant here. I'm comparing the same distros, same Firefox
>> versions, same Firefox add-ons, etc. I eventually tested many hardware
>> configurations: different CPU's, motherboards, GPU's, SSD's, RAM, etc.
>> The only remaining difference I can find is that the computer with
>> acceptable performance uses LVM + EXT4 while all the others use BTRFS.
>>
>> With all the great feedback I have gotten here, I'm now ready to
>> retest this after implementing all the BTRFS-related suggestions I
>> have received. Maybe that will solve the problem or maybe this mystery
>> will continue...
>
> Hmm, if you're only using SSD's, that may partially explain things.  I don't
> remember if it was mentioned earlier in this thread, but you might try
> adding 'nossd' to the mount options.  The 'ssd' mount option (which gets set
> automatically if the device reports as non-rotational) impacts how the block
> allocator works, and that can have a pretty insane impact on performance.

I will test the "nossd" mount option.

> Additionally, independently from that, try toggling the 'discard' mount
> option.  If you have it enabled, disable it, if you have it disabled, enable
> it.  Inline discards can be very expensive on some hardware, especially
> older SSD's, and discards happen pretty frequently in a COW filesystem.

I have been following this advice, so I have never enabled discard for
an NVMe drive. Do you think it is worth testing?

Solid State Drives/NVMe - ArchWiki
https://wiki.archlinux.org/index.php/Solid_State_Drives/NVMe

Discards:
Note: Although continuous TRIM is an option (albeit not recommended)
for SSDs, NVMe devices should not be issued discards.
