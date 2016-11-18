Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36214 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbcKRUcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 15:32:18 -0500
Received: by mail-yw0-f180.google.com with SMTP id a10so171568348ywa.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 12:32:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Fri, 18 Nov 2016 21:32:17 +0100
Message-ID: <CANznX5EvKzySaFrRFOULTkUqGGMRhKAQZEphMD9Kww_iOkN25A@mail.gmail.com>
Subject: Re: RFC: raid with a variable stripe size
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on the comments of this patch, stripe size could theoretically
go as low as 512 byte:
https://mail-archive.com/linux-btrfs@vger.kernel.org/msg56011.html
If these very small (0.5k-2k) stripe sizes could really work (it's
possible to implement such changes and it does not degrade performance
too much - or at all - to keep it so low), we could use RAID-5(/6) on
<=9(/10) disks with 512 byte physical sectors (assuming 4k filesystem
sector size + 4k node size, although I am not sure if node size is
really important here) without having to worry about RMW, extra space
waste or additional fragmentation.

On Fri, Nov 18, 2016 at 7:15 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hello,
>
> these are only my thoughts; no code here, but I would like to share it hoping that it could be useful.
>
> As reported several times by Zygo (and others), one of the problem of raid5/6 is the write hole. Today BTRFS is not capable to address it.
>
> The problem is that the stripe size is bigger than the "sector size" (ok sector is not the correct word, but I am referring to the basic unit of writing on the disk, which is 4k or 16K in btrfs).
> So when btrfs writes less data than the stripe, the stripe is not filled; when it is filled by a subsequent write, a RMW of the parity is required.
>
> On the best of my understanding (which could be very wrong) ZFS try to solve this issue using a variable length stripe.
>
> On BTRFS this could be achieved using several BGs (== block group or chunk), one for each stripe size.
>
> For example, if a filesystem - RAID5 is composed by 4 DISK, the filesystem should have three BGs:
> BG #1,composed by two disks (1 data+ 1 parity)
> BG #2 composed by three disks (2 data + 1 parity)
> BG #3 composed by four disks (3 data + 1 parity).
>
> If the data to be written has a size of 4k, it will be allocated to the BG #1.
> If the data to be written has a size of 8k, it will be allocated to the BG #2
> If the data to be written has a size of 12k, it will be allocated to the BG #3
> If the data to be written has a size greater than 12k, it will be allocated to the BG3, until the data fills a full stripes; then the remainder will be stored in BG #1 or BG #2.
>
>
> To avoid unbalancing of the disk usage, each BG could use all the disks, even if a stripe uses less disks: i.e
>
> DISK1 DISK2 DISK3 DISK4
> S1    S1    S1    S2
> S2    S2    S3    S3
> S3    S4    S4    S4
> [....]
>
> Above is show a BG which uses all the four disks, but has a stripe which spans only 3 disks.
>
>
> Pro:
> - btrfs already is capable to handle different BG in the filesystem, only the allocator has to change
> - no more RMW are required (== higher performance)
>
> Cons:
> - the data will be more fragmented
> - the filesystem, will have more BGs; this will require time-to time a re-balance. But is is an issue which we already know (even if may be not 100% addressed).
>
>
> Thoughts ?
>
> BR
> G.Baroncelli
>
>
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
