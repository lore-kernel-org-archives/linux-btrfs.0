Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:54238 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdIOMXj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 08:23:39 -0400
Received: by mail-it0-f50.google.com with SMTP id 85so3341494ith.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 05:23:39 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <928da79f-4373-dd95-d458-1b136146b704@gmail.com>
 <CABB28Cwd2efbDzF3uK01VQcWdMJ_ABf8z_Q4MfWz30=xuLLCHw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ba8e41e4-018c-8a96-3688-bbad3b79a326@gmail.com>
Date: Fri, 15 Sep 2017 08:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <CABB28Cwd2efbDzF3uK01VQcWdMJ_ABf8z_Q4MfWz30=xuLLCHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-14 22:26, Tomasz Kłoczko wrote:
> On 14 September 2017 at 19:53, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> [..]
>> While it's not for BTRFS< a tool called e4rat might be of interest to you
>> regarding this.  It reorganizes files on an ext4 filesystem so that stuff
>> used by the boot loader is right at the beginning of the device, and I've
>> know people to get insane performance improvements (on the order of 20x in
>> some pathologicallyb ad cases) in the time taken from the BIOS handing
>> things off to GRUB to GRUB handing execution off to the kernel.
> 
> Do you know that what you've just wrote has nothing to do with fragmentation?
> Intentionally or not you just trying to change the subject.
As hard as it may be to believe, this _is_ relevant to the part of your 
reply that I was responding to, namely:

 > By how much it is possible to improve boot time?

Note that discussion of file ordering impacting boot times is almost 
always centered around the boot loader, and _not_ userspace (because as 
you choose to focus on in changing the subject for the rest of this 
message, it's trivially possible to improve performance in userspace 
with some really simple tweaks).

You wanted examples regarding reordering of data in a localized manner 
improving boot time, so I gave _the_ reference for this on Linux (e4rat 
is the only publicly available tool I know of that does this).
> 
> [..]
>> This shouldn't need examples.  It's trivial math combined with basic
>> knowledge of hardware behavior.  Every request to a device has a minimum
>> amount of overhead.  On traditional hard drives, this is usually dominated
>> by seek latency, but on SSD's, the request setup, dispatch, and completion
>> are the dominant factor.  Assumign you have a 2 micro-second overhead
>> per-request (not an exact number, just chosen for demonstration purposes
>> because it makes the math easy), and a 1GB file, the time difference between
>> reading ten 100MB extents and reading ten thousand 100kB extents is just
>> short of 0.02 seconds, or a factor of about one thousand (which, no surprise
>> here, is the factor of difference between the number of extents).
> 
> So to produce few seconds delay during boot you need to make few
> hundreds thousands if not millions more IOs  and on reading everything
> using ideal long sequential reads.
No, that isn't what I was talking about.  Quit taking things out of 
context and assuming all of someone's reply is about only part of yours.

This was responding solely to this:

 > That it may be an issue with using extents.
 > Again: please show some results of some test unit which anyone will be
 > able to reply and confirm or not that this effect really exist.

And has nothing to do with boot time.

> Almost every package upgrade on rewrite some files in 100% will
> produce by using COW fully continuous areas per file.
> You know .. there is no so many files in typical distribution
> installation to produce such measurable impact. > On my current laptop I have a lot of devel and debug stuff installed
> and still I have only
> 
> $ rpm -qal | wc -l
> 276489
> 
> files (from which only small fractions are ELF DSOs or executables)
> installed by:
> 
> $ rpm -qa | wc -l
> 2314
> 
> packages.
> 
> I can bet that during even very complicated boot process it will be
> touched (by read IOs) only few hundreds files. None of those files
> will be read sequentially because this is not how executable content
> is usually loaded into the buffer cache. Simple change block device
> read ahead may improve boot time enough without putting all blocks in
> perfect order. All what you need is start enough early "blockdev
> --setra N" where N is greater than default 256 blocks. All this can be
> done without thinking about fragmentation.
As I mentioned above, the primary argument for reordering data for boot 
is largely related to the boot-loader, which doesn't have intelligent 
I/O scheduling and doesn't do read ahead, and is primarily about usage 
with traditional hard drives, where seek latency caused by lack of data 
locality actually does have a significant (and well documented) impact.

> Seems you don't know that Linux by default is reading data from block
> dev using at least 256 blocks (1KB each one) chunks because such IO
> size is part of default RA settings, You can change those settings
> just for boot time and you will have way lower number of IOs and sill
> no significant improvement like few times shorter time. Fragmentation
> will be in such case secondary factor.
> All this could be done without bothering about fragmentation.
The block-level read-ahead done by the kernel has near zero impact on 
performance unless your data is already highly local (not necessarily 
ordered, but at least all in the same place), which will almost never be 
the case on BTRFS when dealing with an active data set because of its 
copy on write semantics.
> 
> In other words still you are talking about some institutionally
> possible results which will be falsified if you will try at least one
> time do some real tests and measurements.
> Last time when I've been doing some boot time measurements it was
> about using sequential start of all services vs. maximum
> palatalization. And yes by this it was possible to improve boot time
> by few times. All without bothering about fragmentation.
> 
> Current fedora systemd base services definition can be improved in
> many places by add more dependencies and execute many small services
> in parallel. All those corrections can be done without even thinking
> about fragmentation. Because these base sett of systemd services comes
> with systemd source code those improvements can be done for almost all
> Linux systemd based distros.
