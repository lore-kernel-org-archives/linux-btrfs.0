Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36095 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbcFCOVQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 10:21:16 -0400
Received: by mail-it0-f51.google.com with SMTP id f67so10025555ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 07:21:16 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: Martin <rc6encrypted@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
Date: Fri, 3 Jun 2016 10:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-03 09:31, Martin wrote:
>> In general, avoid Ubuntu LTS versions when dealing with BTRFS, as well as
>> most enterprise distros, they all tend to back-port patches instead of using
>> newer kernels, which means it's functionally impossible to provide good
>> support for them here (because we can't know for sure what exactly they've
>> back-ported).  I'd suggest building your own kernel if possible, with Arch
>> Linux being a close second (they follow upstream very closely), followed by
>> Fedora and non-LTS Ubuntu.
>
> Then I would build my own, if that is the preferred option.
If you do go this route, make sure to keep an eye on the mailing list, 
as this is usually where any bugs get reported.  New bugs have 
thankfully been decreasing in number each release, but they do still 
happen, and it's important to know what to avoid and what to look out 
for when dealing with something under such active development.
>
>> Do not use BTRFS raid6 mode in production, it has at least 2 known serious
>> bugs that may cause complete loss of the array due to a disk failure.  Both
>> of these issues have as of yet unknown trigger conditions, although they do
>> seem to occur more frequently with larger arrays.
>
> Ok. No raid6.
>
>> That said, there are other options.  If you have enough disks, you can run
>> BTRFS raid1 on top of LVM or MD RAID5 or RAID6, which provides you with the
>> benefits of both.
>>
>> Alternatively, you could use BTRFS raid1 on top of LVM or MD RAID1, which
>> actually gets relatively decent performance and can provide even better
>> guarantees than RAID6 would (depending on how you set it up, you can lose a
>> lot more disks safely).  If you go this way, I'd suggest setting up disks in
>> pairs at the lower level, and then just let BTRFS handle spanning the data
>> across disks (BTRFS raid1 mode keeps exactly two copies of each block).
>> While this is not quite as efficient as just doing LVM based RAID6 with a
>> traditional FS on top, it's also a lot easier to handle reshaping the array
>> on-line because of the device management in BTRFS itself.
>
> Right now I only have 10TB of backup data, but this is grow when
> urbackup is roled out. So maybe I could get a way with plain btrfs
> raid10 for the first year, and then re-balance to raid6 when the two
> bugs have been found...
>
> is the failed disk handling in btrfs raid10 considered stable?
>
I would say it is, but I also don't have quite as much experience with 
it as with BTRFS raid1 mode.  The one thing I do know for certain about 
it is that even if it theoretically could recover from two failed disks 
(ie, if they're from different positions in the striping of each 
mirror), there is no code to actually do so, so make sure you replace 
any failed disks as soon as possible (or at least balance the array so 
that you don't have a missing device anymore).

Most of my systems where I would run raid10 mode are set up as BTRFS 
raid1 on top of two LVM based RAID0 volumes, as this gets measurably 
better performance than BTRFS raid10 mode at the moment (I see roughly a 
10-20% difference on my home server system), and provides the same data 
safety guarantees as well.  It's worth noting for such a setup that the 
current default block size in BTRFS is 16k except on very small 
filesystems, so you may want a larger stripe size than you would on a 
traditional filesystem.

As far as BTRFS raid10 mode in general, there are a few things that are 
important to remember about it:
1. It stores exactly two copies of everything, any extra disks just add 
to the stripe length on each copy.
2. Because each stripe has the same number of disks as it's mirrored 
partner, the total number of disks in any chunk allocation will always 
be even, which means that if your using an odd number of disks, there 
will always be one left out of every chunk.  This has limited impact on 
actual performance usually, but can cause confusing results if you have 
differently sized disks.
3. BTRFS (whether using raid10, raid0, or even raid5/6) will always try 
to use as many devices as possible for a stripe.  As a result of this, 
the moment you add a new disk, the total length of all new stripes will 
adjust to fit the new configuration.  If you want maximal performance 
when adding new disks, make sure to balance the rest of the filesystem 
afterwards, otherwise any existing stripes will just stay the same size.
