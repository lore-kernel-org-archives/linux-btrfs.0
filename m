Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:40588 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeB1GBt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 01:01:49 -0500
Received: by mail-ot0-f194.google.com with SMTP id l12so1219623otj.7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 22:01:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
From: vinayak hegde <vinayakhegdev@gmail.com>
Date: Wed, 28 Feb 2018 11:31:48 +0530
Message-ID: <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
Subject: Re: btrfs space used issue
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran full defragement and balance both, but didnt help.
My created and accounting usage files are matching the du -sh output.
But I am not getting why btrfs internals use so much extra space.
My worry is, will get no space error earlier than I expect.
Is it expected with btrfs internal that it will use so much extra space?

Vinayak




On Tue, Feb 27, 2018 at 7:24 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2018-02-27 08:09, vinayak hegde wrote:
>>
>> I am using btrfs, But I am seeing du -sh and df -h showing huge size
>> difference on ssd.
>>
>> mount:
>> /dev/drbd1 on /dc/fileunifier.datacache type btrfs
>>
>> (rw,noatime,nodiratime,flushoncommit,discard,nospace_cache,recovery,commit=5,subvolid=5,subvol=/)
>>
>>
>> du -sh /dc/fileunifier.datacache/ -  331G
>>
>> df -h
>> /dev/drbd1      746G  346G  398G  47% /dc/fileunifier.datacache
>>
>> btrfs fi usage /dc/fileunifier.datacache/
>> Overall:
>>      Device size:         745.19GiB
>>      Device allocated:         368.06GiB
>>      Device unallocated:         377.13GiB
>>      Device missing:             0.00B
>>      Used:             346.73GiB
>>      Free (estimated):         396.36GiB    (min: 207.80GiB)
>>      Data ratio:                  1.00
>>      Metadata ratio:              2.00
>>      Global reserve:         176.00MiB    (used: 0.00B)
>>
>> Data,single: Size:365.00GiB, Used:345.76GiB
>>     /dev/drbd1     365.00GiB
>>
>> Metadata,DUP: Size:1.50GiB, Used:493.23MiB
>>     /dev/drbd1       3.00GiB
>>
>> System,DUP: Size:32.00MiB, Used:80.00KiB
>>     /dev/drbd1      64.00MiB
>>
>> Unallocated:
>>     /dev/drbd1     377.13GiB
>>
>>
>> Even if we consider 6G metadata its 331+6 = 337.
>> where is 9GB used?
>>
>> Please explain.
>
> First, you're counting the metadata wrong.  The value shown per-device by
> `btrfs filesystem usage` already accounts for replication (so it's only 3 GB
> of metadata allocated, not 6 GB).  Neither `df` nor `du` looks at the chunk
> level allocations though.
>
> Now, with that out of the way, the discrepancy almost certainly comes form
> differences in how `df` and `du` calculate space usage.  In particular, `df`
> calls statvfs and looks at the f_blocks and f_bfree values to compute space
> usage, while `du` walks the filesystem tree calling stat on everything and
> looking at st_blksize and st_blocks (or instead at st_size if you pass in
> `--apparent-size` as an option).  This leads to a couple of differences in
> what they will count:
>
> 1. `du` may or may not properly count hardlinks, sparse files, and
> transparently compressed data, dependent on whether or not you use
> `--apparent-sizes` (by default, it does properly count all of those), while
> `df` will always account for those properly.
> 2. `du` does not properly account for reflinked blocks (from deduplication,
> snapshots, or use of the CLONE ioctl), and will count each reflink of every
> block as part of the total size, while `df` will always count each block
> exactly once no matter how many reflinks it has.
> 3. `du` does not account for all of the BTRFS metadata allocations,
> functionally ignoring space allocated for anything but inline data, while
> `df` accounts for all BTRFS metadata properly.
> 4. `du` will recurse into other filesystems if you don't pass the `-x`
> option to it, while `df` will only report for each filesystem separately.
> 5. `du` will only count data usage under the given mount point, and won't
> account for data on other subvolumes that may be mounted elsewhere (and if
> you pass in `-x` won't count data on other subvolumes located under the
> given path either), while `df` will count all the data in all subvolumes.
> 6. There are a couple of other differences too, but they're rather complex
> and dependent on the internals of BTRFS.
>
> In your case, I think the issue is probably one of the various things under
> item 6.  Items 1, 2 and 4 will cause `du` to report more space usage than
> `df`, item 3 is irrelevant because `du` shows less space than the total data
> chunk usage reported by `btrfs filesystem usage`, and item 5 is irrelevant
> because you're mounting the root subvolume and not using the `-x` option on
> `du` (and therefore there can't be other subvolumes you're missing).
>
> Try running a full defrag of the given mount point.  If what I think is
> causing this is in fact the issue, that should bring the numbers back
> in-line with each other.
