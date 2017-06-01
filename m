Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:32790 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdFAR4W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 13:56:22 -0400
Received: by mail-qt0-f178.google.com with SMTP id t26so42358355qtg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 10:56:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
References: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 1 Jun 2017 20:55:41 +0300
Message-ID: <CAGqmi755-pWkzROVcK1Qh2qa3-MQ6CbAFzAL85Lv0WVbjpBxFw@mail.gmail.com>
Subject: Re: understanding differences in recoverability of raid1 vs raid10
 and performance implications of unusual numbers of devices
To: Alexander Peganz <a.peganz@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-01 17:54 GMT+03:00 Alexander Peganz <a.peganz@gmail.com>:
> Hello,
>
> I am trying to understand what differences there are in using btrfs
> raid1 vs raid10 in terms of recoverability and also performance.
> This has proven itself to be more difficult than expected since all
> search results I could come up with generally suffer from one of three
> flaws: they either discuss terribly old versions of btrfs, only
> discuss 4 disk settings, or are about traditional HW (or mdadm) RAID
> modes.
>
> From what I gathered so far, with raid1 btrfs just puts the 2 copies
> of a file on 2 different devices.
> And raid10 splits files into stripes, then writes 2 copies of each
> stripe to 2 different devices. By splitting the files into stripes it
> can write stripe 1 to devices A and B, while at the same time writing
> stripe 2 to devices C and D, and so on. So a single copy of a file
> might end up split across all devices, as does the second, but with
> the stripes distributed in a way that the copies of each one stripe
> are never on the same device.
>
> So my first question is: is that actually correct? Or does btrfs raid1
> create copies of blocks or something akin to stripes instead of files?
> Because I imagine if it is at the file level there is a difference in
> recoverability if the "wrong" 2 devices die.
> For a raid1 I'd expect to only loose those files whose copies were
> located on those 2 devices. Every file with a copy on one of the still
> working devices would be recoverable. So the more devices there are
> the bigger the percentage of recoverable files could get.
> While with raid10 the copies of every file's first stripe might end up
> on device A and device B, damaging every single file if A and B die at
> the same time.
> This might just be a reason for me to choose raid1 over raid10, so I
> really appreciate if someone could enlighten me ;)

Btrfs use abstraction and not stripe files.
Btrfs have chunks, chunks store data, chunks can have some profile
raid1/10 & etc.
For profiles like single, dup, raid1 next chunk allocated on device
with less used space.
So in general case, yes raid 1 will be randomly striped over disks.
Btrfs have some problems with raid profiles so in general this must be
used with care.
(As example, if you lose 1 disk in raid1 with 2 disks, you will have a
problem with remount this fs RW after & etc)
In general, follow simple rule: you can't restore data if you lose 2
disks in btrfs raid1/10, anyway.

> As to performance, with raid1 write speed should (theoretically) be
> the same as a single disk (although writing the first half of the data
> to device A while at the same time writing the second half to device B
> would allow to write the first copy in half the time, and would allow
> to create the second copy at some later point in time I highly doubt
> btrfs is quite that adventurous). And read speeds should be up to
> twice that of a single device.

raid 1 write data on all disks synchronously all time, no tricks.
btrfs raid1 read data by PID%2
0 - first copy
1 - second copy

In general, think of raid 1 as it's a single disk in performance.

> With raid10 write speeds should be N times those of a single disk to
> create the first copy, and since of course a second one has to be
> written as well, effectively up to N/2. Read speeds should be up to N
> times that of a single disk. But I couldn't find useful comparisons
> using more than 4 devices. Should I expect any weirdness if I don't
> have a multiple of 4 devices? Or do I just need an even number of
> devices? Or is everything ok, even odd numbers?

Write speed always N/2, read speed N/2 - N.
raid10 - you need 4 or more disks, 5 also supported.

> And finally, could using raid10 cause me more headache than raid1
> farther down the line when adding additional devices? How about if
> those devices are not the same size as the original ones, any
> difference between raid1 and 10?

Btrfs create chunks, and data stored on chunks, in jeneral you will
have more flexability with raid1, because you don't need to rebalance
whole FS after adding new disks, and btrfs will be more predictable in
mean of space usage with mixed sized devices.

So, if you want performance - use raid 10, if data availability are
enough, use raid1.

Thanks.
-- 
Have a nice day,
Timofey.
