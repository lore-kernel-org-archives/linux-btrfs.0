Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36054 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbcKRUfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 15:35:13 -0500
Received: by mail-it0-f50.google.com with SMTP id l8so44040543iti.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 12:35:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 18 Nov 2016 23:34:32 +0300
Message-ID: <CAGqmi76db-UQ-rVW4fySZ9QnLW7mHn0-R_yhsHokVwndoJ52QA@mail.gmail.com>
Subject: Re: RFC: raid with a variable stripe size
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-11-18 21:15 GMT+03:00 Goffredo Baroncelli <kreijack@libero.it>:
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

AFAIK, it's difficult to do such things with btrfs, because btrfs use
chuck allocation for metadata & data,
i.e. AFAIK ZFS work with storage more directly, so zfs directly span
file to the different disks.

May be it's can be implemented by some chunk allocator rework, i don't know.

Fix me if i'm wrong, thanks.

-- 
Have a nice day,
Timofey.
