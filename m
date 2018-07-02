Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:38267 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753179AbeGBSfW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 14:35:22 -0400
Received: by mail-io0-f178.google.com with SMTP id v26-v6so3325084iog.5
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 11:35:22 -0700 (PDT)
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
 <20180702173438.7c2vhflvtncfb5gz@merlins.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
Date: Mon, 2 Jul 2018 14:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <20180702173438.7c2vhflvtncfb5gz@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-02 13:34, Marc MERLIN wrote:
> On Mon, Jul 02, 2018 at 12:59:02PM -0400, Austin S. Hemmelgarn wrote:
>>> Am I supposed to put LVM thin volumes underneath so that I can share
>>> the same single 10TB raid5?
>>
>> Actually, because of the online resize ability in BTRFS, you don't
>> technically _need_ to use thin provisioning here.  It makes the maintenance
>> a bit easier, but it also adds a much more complicated layer of indirection
>> than just doing regular volumes.
> 
> You're right that I can use btrfs resize, but then I still need an LVM
> device underneath, correct?
> So, if I have 10 backup targets, I need 10 LVM LVs, I give them 10%
> each of the full size available (as a guess), and then I'd have to
> - btrfs resize down one that's bigger than I need
> - LVM shrink the LV
> - LVM grow the other LV
> - LVM resize up the other btrfs
> 
> and I think LVM resize and btrfs resize are not linked so I have to do
> them separately and hope to type the right numbers each time, correct?
> (or is that easier now?)
> 
> I kind of linked the thin provisioning idea because it's hands off,
> which is appealing. Any reason against it?
No, not currently, except that it adds a whole lot more stuff between 
BTRFS and whatever layer is below it.  That increase in what's being 
done adds some overhead (it's noticeable on 7200 RPM consumer SATA 
drives, but not on decent consumer SATA SSD's).

There used to be issues running BTRFS on top of LVM thin targets which 
had zero mode turned off, but AFAIK, all of those problems were fixed 
long ago (before 4.0).
> 
>> You could (in theory) merge the LVM and software RAID5 layers, though that
>> may make handling of the RAID5 layer a bit complicated if you choose to use
>> thin provisioning (for some reason, LVM is unable to do on-line checks and
>> rebuilds of RAID arrays that are acting as thin pool data or metadata).
>   
> Does LVM do built in raid5 now? Is it as good/trustworthy as mdadm
> radi5?
Actually, it uses MD's RAID5 implementation as a back-end.  Same for 
RAID6, and optionally for RAID0, RAID1, and RAID10.

> But yeah, if it's incompatible with thin provisioning, it's not that
> useful.
It's technically not incompatible, just a bit of a pain.  Last time I 
tried to use it, you had to jump through hoops to repair a damaged RAID 
volume that was serving as an underlying volume in a thin pool, and it 
required keeping the thin pool offline for the entire duration of the 
rebuild.
> 
>> Alternatively, you could increase your array size, remove the software RAID
>> layer, and switch to using BTRFS in raid10 mode so that you could eliminate
>> one of the layers, though that would probably reduce the effectiveness of
>> bcache (you might want to get a bigger cache device if you do this).
> 
> Sadly that won't work. I have more data than will fit on raid10
> 
> Thanks for your suggestions though.
> Still need to read up on whether I should do thin provisioning, or not.
If you do go with thin provisioning, I would encourage you to make 
certain to call fstrim on the BTRFS volumes on a semi regular basis so 
that the thin pool doesn't get filled up with old unused blocks, 
preferably when you are 100% certain that there are no ongoing writes on 
them (trimming blocks on BTRFS gets rid of old root trees, so it's a bit 
dangerous to do it while writes are happening).
