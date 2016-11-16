Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35315 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbcKPM5R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:57:17 -0500
Received: by mail-it0-f67.google.com with SMTP id b123so7021512itb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 04:57:17 -0800 (PST)
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>
References: <18970348.FUMEOFOSb3@merkaba> <3374757.aMVjisyVFB@merkaba>
 <20161116160031.59041b46@natsu> <1672818.LEbdb7TNyD@merkaba>
Cc: linux-btrfs@vger.kernel.org, Martin <martin@lichtvoll.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com>
Date: Wed, 16 Nov 2016 07:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <1672818.LEbdb7TNyD@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-16 06:04, Martin Steigerwald wrote:
> Am Mittwoch, 16. November 2016, 16:00:31 CET schrieb Roman Mamedov:
>> On Wed, 16 Nov 2016 11:55:32 +0100
>>
>> Martin Steigerwald <martin.steigerwald@teamix.de> wrote:
>>> I do think that above kernel messages invite such a kind of interpretation
>>> tough. I took the "BTRFS: open_ctree failed" message as indicative to some
>>> structural issue with the filesystem.
>>
>> For the reason as to why the writable mount didn't work, check "btrfs fi df"
>> for the filesystem to see if you have any "single" profile chunks on it:
>> quite likely you did already mount it "degraded,rw" in the past *once*,
>> after which those "single" chunks get created, and consequently it won't
>> mount r/w anymore (without lifting the restriction on the number of missing
>> devices as proposed).
>
> That exactly explains it. I very likely did a degraded mount without ro on
> this disk already.
>
> Funnily enough this creates another complication:
>
>     merkaba:/mnt/zeit#1> btrfs send somesubvolume | btrfs receive /mnt/
> someotherbtrfs
>     ERROR: subvolume /mnt/zeit/somesubvolume is not read-only
>
> Yet:
>
>     merkaba:/mnt/zeit> btrfs property get somesubvolume
>     ro=false
>     merkaba:/mnt/zeit> btrfs property set somesubvolume ro true
>     ERROR: failed to set flags for somesubvolume: Read-only file system
>
> To me it seems right logic would be to allow the send to proceed in case
> the whole filesystem is readonly.
It should, but doesn't currently.  There was a thread about this a while 
back, but I don't think it ever resulted in anything changing.
>
> As there seems to be no force option to override the limitation and I
> do not feel like compiling my own btrfs-tools right now, I will use rsync
> instead.
In a case like this, I'd trust rsync more than send/receive.  The 
following rsync switches might also be of interest:
-a: This turns on a bunch of things almost everyone wants when using 
rsync, similar to the same switch for cp, just with even more added in.
-H: This recreates hardlinks on the receiving end.
-S: This recreates sparse files.
-A: This copies POSIX ACL's
-X: This copies extended attributes (most of them at least, there are a 
few that can't be arbitrarily written to).
Pre-creating the subvolumes by hand combined with using all of those 
will get you almost everything covered by send/receive except for 
sharing of extents and ctime.
