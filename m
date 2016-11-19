Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:36978 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750958AbcKSJBt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 04:01:49 -0500
Reply-To: kreijack@inwind.it
Subject: Re: RFC: raid with a variable stripe size
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <CAGqmi76db-UQ-rVW4fySZ9QnLW7mHn0-R_yhsHokVwndoJ52QA@mail.gmail.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <8ba2537c-4a5b-61b2-8b1e-f32c7a7ff453@inwind.it>
Date: Sat, 19 Nov 2016 09:59:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAGqmi76db-UQ-rVW4fySZ9QnLW7mHn0-R_yhsHokVwndoJ52QA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-18 21:34, Timofey Titovets wrote:
[...]
>> For example, if a filesystem - RAID5 is composed by 4 DISK, the filesystem should have three BGs:
>> BG #1,composed by two disks (1 data+ 1 parity)
>> BG #2 composed by three disks (2 data + 1 parity)
>> BG #3 composed by four disks (3 data + 1 parity).
>>
>> If the data to be written has a size of 4k, it will be allocated to the BG #1.
>> If the data to be written has a size of 8k, it will be allocated to the BG #2
>> If the data to be written has a size of 12k, it will be allocated to the BG #3
>> If the data to be written has a size greater than 12k, it will be allocated to the BG3, until the data fills a full stripes; then the remainder will be stored in BG #1 or BG #2.
>>
>>
>> To avoid unbalancing of the disk usage, each BG could use all the disks, even if a stripe uses less disks: i.e
>>
>> DISK1 DISK2 DISK3 DISK4
>> S1    S1    S1    S2
>> S2    S2    S3    S3
>> S3    S4    S4    S4
>> [....]
>>
>> Above is show a BG which uses all the four disks, but has a stripe which spans only 3 disks.
>>
>>
>> Pro:
>> - btrfs already is capable to handle different BG in the filesystem, only the allocator has to change
>> - no more RMW are required (== higher performance)
>>
>> Cons:
>> - the data will be more fragmented
>> - the filesystem, will have more BGs; this will require time-to time a re-balance. But is is an issue which we already know (even if may be not 100% addressed).
>>
>>
>> Thoughts ?
>>
>> BR
>> G.Baroncelli
> 
> AFAIK, it's difficult to do such things with btrfs, because btrfs use
> chuck allocation for metadata & data,

BTRFS already is capable to use in the same filesystem different kind of chunk: i.e in case of adding a disk and a balance is not performed, a BTRFS filesystem still has the older chunks which doesn't use the last inserted disk.

Is the same thing, the only differences is that the allocator should select the chunk where to write on the basis data size to write.


> i.e. AFAIK ZFS work with storage more directly, so zfs directly span
> file to the different disks.
> 
> May be it's can be implemented by some chunk allocator rework, i don't know.
> 
> Fix me if i'm wrong, thanks.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
