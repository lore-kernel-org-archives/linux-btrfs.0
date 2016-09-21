Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36013 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbcIULO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 07:14:29 -0400
Received: by mail-io0-f169.google.com with SMTP id m79so49007224ioo.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 04:14:28 -0700 (PDT)
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Chris Murphy <lists@colorremedies.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
 <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
 <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com>
 <689d4d03-a122-502d-fda0-8b055ee4a182@gmail.com>
 <CAJCQCtQbF2NZVenPjikTQ7qWRjphj79ia-bLH0q7EFzkD=sGjw@mail.gmail.com>
Cc: Alexandre Poux <pums974@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1ad34ecb-5977-4ba2-f764-15b2e611ce59@gmail.com>
Date: Wed, 21 Sep 2016 07:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQbF2NZVenPjikTQ7qWRjphj79ia-bLH0q7EFzkD=sGjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-20 15:55, Chris Murphy wrote:
> On Tue, Sep 20, 2016 at 1:43 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>>> First off, as Chris said, if you can read the data and don't already have a
>> backup, that should be your first priority.  This really is an edge case
>> that's not well tested, and the kernel technically doesn't officially
>> support it.
>>
>> Now, beyond that and his suggestions, there's another option, but it's
>> risky, so I wouldn't even think about trying it without a backup (unless of
>> course you can trivially regenerate the data).  Multiple devices support and
>> online resizing allows for a rather neat trick to regenerate a filesystem in
>> place.  The process is pretty simple:
>> 1. Shrink the existing filesystem down to the minimum size possible.
>> 2. Create a new partition in the free space, and format it as a temporary
>> BTRFS filesystem.  Ideally, this FS should be mixed mode, and ideally single
>> profile.  If you don't have much free space, you can use a flash drive to
>> start this temporary filesystem instead.
>> 3. Start copying files from the old filesystem to the temporary one.
>> 4. Once the new filesystem is about 95% full, stop copying, shrink the old
>> filesystem again, create a new partition, and add that partition to the
>> temporary filesystem.
>> 5. Repeat steps 3-4 until you have everything off of the old filesystem.
>> 6. Re-format the remaining portion of the old filesystem using the
>> parameters you want for the replacement filesystem.
>> 7. Start copying files from the temporary filesystem to the new filesystem.
>> 8. As you empty out each temporary partition, remove it from the temporary
>> filesystem, delete the partition, and expand the new filesystem.
>>
>> This takes a while, and is only safe if you have reliable hardware, but I've
>> done it before and it works reliably as long as you don't have many big
>> files on the old filesystem (things can get complicated if you do). The
>> other negative aspect is that if you aren't careful, it's possible to get
>> stuck half-way, but in such a case, adding a flash drive to the temporary
>> filesystem can usually give you enough extra space to get things unstuck.
>
> Yes I thought of this also.
>
> Gotcha is that he'll need to apply the patch that allows degraded rw
> mounts with a device missing on the actual computer with these drives.
> He tested that patch in a VM with virtual devices.
>
> What might be easier is just 'btrfs dev rm /dev/sda6' because that one
> has the least amount of data on it:
>
> devid   12 size 728.32GiB used 312.03GiB path /dev/sda6
>
> which should fit on all remaining devices. But, does Btrfs get pissed
> at some point that there's this missing device it might want to write
> to? I have no idea to what degree this patched kernel permits a lot of
> degraded writing.
>
> The other quandary is the file system will do online shrink, but the
> kernel can sometimes get pissy about partition map changes on devices
> with active volumes, even when using partprobe to update the kernel's
> idea of the partition map.
>
Excellent point that I forgot to mention.  In my experience, the trick 
is to unmount filesystems from every partition that changed before 
running partprobe, and things usually work (I say usually because if 
your root filesystem is on the device you're re-partitioning, the kernel 
gets a whole lot pickier about changes).
