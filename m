Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35059 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbcITTq5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 15:46:57 -0400
Received: by mail-oi0-f49.google.com with SMTP id w11so35002239oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 12:46:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e7ec5eb-7fb6-2d19-f29d-82461e2d0bd2@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com> <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com> <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com> <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com> <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com> <CAJCQCtTNiJ=E--v5gb5reyzTBqVeZx70-gUfj67EN+BjmcOTmw@mail.gmail.com>
 <4e7ec5eb-7fb6-2d19-f29d-82461e2d0bd2@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 13:46:55 -0600
Message-ID: <CAJCQCtQ=sjj9jWHQ+9Xm1FSmVtMVgNbqGC6Mc7r6ZuBZpJ8U1g@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 1:31 PM, Alexandre Poux <pums974@gmail.com> wrote:
>
>
> Le 20/09/2016 à 21:11, Chris Murphy a écrit :

>> And no backup? Umm, I'd resolve that sooner than anything else.
> Yeah you are absolutely right, this was a temporary solution which came
> to be not that temporary.
> And I regret it already...

Well on the bright side, if this were LVM or mdadm linear/concat
array, the whole thing would be toast because any other file system
would have lost too much fs metadata on the missing device.

>>  It
>> should be true that it'll tolerate a read only mount indefinitely, but
>> read write? Not sure. This sort of edge case isn't well tested at all
>> seeing as it required changing the kernel to reduce safe guards. So
>> all bets are off the whole thing could become unmountable, not even
>> read only, and then it's a scraping job.
> I'm not that crazy, I tried the patch inside a virtual machine on
> virtual drives...
> And since it's only virtual, it may not work on the real partition...

Are you sure the virtual setup lacked a CHUNK_ITEM on the missing
device? That might be what pinned it in that case.

You could try some sort of overlay for your remaining drives.
Something like this:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

Make sure you understand the gotcha about cloning which applies here:
https://btrfs.wiki.kernel.org/index.php/Gotchas

I think it's safe to use blockdev --setro on every real device  you're
trying to protect from changes. And when mounting you'll at least need
to use device= mount option to explicitly mount each of the overlay
devices. Based on the wiki, I'm wincing, I don't really know for sure
if device mount option is enough to compel Btrfs to only use those
devices and not go off the rails and still use one of the real
devices, but at least if they're setro it won't matter (the mount will
just fail somehow due to write failures).

So now you can try removing the missing device... and see what
happens. You could inspect the overlay files and see what changes were
made.

>> What do you get for btrfs-debug-tree -t 3 <dev>
>>
>> That should show the chunk tree, and what I'm wondering if if the
>> chunk tree has any references to chunks on the missing device. Even if
>> there are no extents on that device, if there are chunks, that might
>> be one of the safeguards.
>>
> You'll find it attached.
> The missing device is the devid 8 (since it's the only one missing in
> btrfs fi show)
> I found it only once line 63

Yeah bummer. Not used for system, data, or metadata chunks at all.


-- 
Chris Murphy
