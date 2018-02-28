Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35483 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932435AbeB1PKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 10:10:47 -0500
Received: by mail-qk0-f195.google.com with SMTP id s188so3368539qkb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 07:10:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANT5p=rOsCQ1B1bLid2cUtefu4hnMNJbGrRBO_2RduJHzVKOAg@mail.gmail.com>
References: <CANT5p=q76WRoc8VHdLKqb8zZrGm3h4qpt2o4-zv=M-Mmd3rtBQ@mail.gmail.com>
 <3968047d-32ef-780c-5375-77c923d96f38@gmail.com> <CANT5p=rOsCQ1B1bLid2cUtefu4hnMNJbGrRBO_2RduJHzVKOAg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 28 Feb 2018 18:10:45 +0300
Message-ID: <CAA91j0X2tU0oR_8ym+dxbaxCh-KSWOrK5R9E1P2dMtvpQAOdSw@mail.gmail.com>
Subject: Re: Btrfs occupies more space than du reports...
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 28, 2018 at 2:26 PM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> Hi,
>
> Thanks for the reply.
>
>> * `df` calls `statvfs` to get it's data, which tries to count physical
>> allocation accounting for replication profiles.  In other words, data in
>> chunks with the dup, raid1, and raid10 profiles gets counted twice, data in
>> raid5 and raid6 chunks gets counted with a bit of extra space for the
>> parity, etc.
>
> We have data not using raid (single), metadata using dup, we've not
> used compression, subvols have not been created yet (other than the
> default subvol), there are no other mount points within the tree.
> Taking into account all that you're saying, the numbers don't make
> sense to me. "btrfs fi usage" tells that the data "used" is much more
> than what it should be. I agree more with what du is saying the disk
> usage is.
> I tried an experiment. Filled up the available space (as per what
> btrfs believes is available) with huge files. As soon as the usage
> reached 100%, further writes started to return ENOSPC. This is what
> I'm scared is what is going to happen when these filesystems
> eventually fill up. This would normally be the expected behaviour, but
> in many of these servers, the actual data that is being used is much
> lesser (60-70 GBs in some cases).
> To me, it looks like a btrfs internal refcounting has gone wrong.
> Maybe it's thinking that some data blocks (which are actually free)
> are in use?

One reason could be overwrites inside of extents. What happens is
btrfs does not (always) physically split extent when it is partially
overwritten. So some space remains free but unavailable.

Filesystem     1K-blocks  Used Available Use% Mounted on
/dev/sdb1        8387584 16704   7531456   1% /mnt
localhost:~ # dd if=/dev/urandom of=/mnt/file bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.580041 s, 181 MB/s
localhost:~ # sync
localhost:~ # df -k /mnt
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/sdb1        8387584 119552   7428864   2% /mnt
localhost:~ # dd if=/dev/urandom of=/mnt/file bs=1M count=1 conv=notrunc seek=25
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00781892 s, 134 MB/s
localhost:~ # dd if=/dev/urandom of=/mnt/file bs=1M count=1 conv=notrunc seek=50
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00780386 s, 134 MB/s
localhost:~ # dd if=/dev/urandom of=/mnt/file bs=1M count=1 conv=notrunc seek=75
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00761908 s, 138 MB/s
localhost:~ # sync
localhost:~ # df -k /mnt
Filesystem     1K-blocks   Used Available Use% Mounted on
/dev/sdb1        8387584 122624   7425792   2% /mnt

So 3M is lost. And if you write 50M in the middle you will get 50M "lost" space.

I do not know how btrfs decides when to split extent.

defragmenting file should free those partial extents again.

btrfs fi defrag -r /mnt

> Or some other refcounting issue?
> We've tried "btrfs check" as well as "btrfs scrub", so far. Both have
> not reported any errors.
>
> Regards,
> Shyam
>
> On Fri, Feb 23, 2018 at 6:53 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2018-02-23 06:21, Shyam Prasad N wrote:
>>>
>>> Hi,
>>>
>>> Can someone explain me why there is a difference in the number of
>>> blocks reported by df and du commands below?
>>>
>>> =====================
>>> # df -h /dc
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/drbd1      746G  519G  225G  70% /dc
>>>
>>> # btrfs filesystem df -h /dc/
>>> Data, single: total=518.01GiB, used=516.58GiB
>>> System, DUP: total=8.00MiB, used=80.00KiB
>>> Metadata, DUP: total=2.00GiB, used=1019.72MiB
>>> GlobalReserve, single: total=352.00MiB, used=0.00B
>>>
>>> # du -sh /dc
>>> 467G    /dc
>>> =====================
>>>
>>> df shows 519G is used. While recursive check using du shows only 467G.
>>> The filesystem doesn't contain any snapshots/extra subvolumes.
>>> Neither does it contain any mounted filesystem under /dc.
>>> I also considered that it could be a void left behind by one of the
>>> open FDs held by a process. So I rebooted the system. Still no
>>> changes.
>>>
>>> The situation is even worse on a few other systems with similar
>>> configuration.
>>>
>>
>> At least part of this is a difference in how each tool computes space usage.
>>
>> * `df` calls `statvfs` to get it's data, which tries to count physical
>> allocation accounting for replication profiles.  In other words, data in
>> chunks with the dup, raid1, and raid10 profiles gets counted twice, data in
>> raid5 and raid6 chunks gets counted with a bit of extra space for the
>> parity, etc.
>>
>> * `btrfs fi df` looks directly at the filesystem itself and counts how much
>> space is available to each chunk type in the `total` values and how much
>> space is used in each chunk type in the `used` values, after replication.
>> If you add together the data used value and twice the system and metadata
>> used values, you get the used value reported by regular `df` (well, close to
>> it that is, `df` rounds at a lower precision than `btrfs fi df` does).
>>
>> * `du` scans the directory tree and looks at the file allocation values
>> returned form `stat` calls (or just looks at file sizes if you pass the
>> `--apparent-size` flag to it).  Like `btrfs fi df`, it reports values after
>> replication, it has a couple of nasty caveats on BTRFS, namely that it will
>> report sizes for natively compressed files _before_ compression, and will
>> count reflinked blocks once for each link.
>>
>> Now, this doesn't explain the entirety of the discrepancy with `du`, but it
>> should cover the whole difference between `df` and `btrfs fi df`.
>
>
>
> --
> -Shyam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
