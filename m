Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:43887 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966862AbeCAJ0s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 04:26:48 -0500
Received: by mail-ot0-f195.google.com with SMTP id m22so4949708otf.10
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Mar 2018 01:26:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com> <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
 <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
From: vinayak hegde <vinayakhegdev@gmail.com>
Date: Thu, 1 Mar 2018 14:56:46 +0530
Message-ID: <CAFmraXhRtUh-HPV4vpeE3-0B=vCeK40b2HfsOk_boSFu+EjQhg@mail.gmail.com>
Subject: Re: btrfs space used issue
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No, there is no opened file which is deleted, I did umount and mounted
again and reboot also.

I think I am hitting the below issue, lot of random writes were
happening and the file is not fully written and its sparse file.
Let me try with disabling COW.


file offset 0                                               offset 302g
[-------------------------prealloced 302g extent----------------------]

(man it's impressive I got all that lined up right)

On disk you have 2 things. First your file which has file extents which says

inode 256, file offset 0, size 302g, offset0, disk bytenr 123, disklen 302g

and then in the extent tree, who keeps track of actual allocated space has this

extent bytenr 123, len 302g, refs 1

Now say you boot up your virt image and it writes 1 4k block to offset
0. Now you have this

[4k][--------------------302g-4k--------------------------------------]

And for your inode you now have this

inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
disklen 4k inode 256, file offset 4k, size 302g-4k, offset 4k,
diskbytenr 123, disklen 302g

and in your extent tree you have

extent bytenr 123, len 302g, refs 1
extent bytenr whatever, len 4k, refs 1

See that? Your file is still the same size, it is still 302g. If you
cp'ed it right now it would copy 302g of information. But what you
have actually allocated on disk? Well that's now 302g + 4k. Now lets
say your virt thing decides to write to the middle, lets say at offset
12k, now you have thisinode 256, file offset 0, size 4k, offset 0,
diskebytenr (123+302g), disklen 4k

inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen 302g

inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
disklen 4k inode 256, file offset 16k, size 302g - 16k, offset 16k,
diskbytenr 123, disklen 302g

and in the extent tree you have this

extent bytenr 123, len 302g, refs 2
extent bytenr whatever, len 4k, refs 1
extent bytenr notimportant, len 4k, refs 1

See that refs 2 change? We split the original extent, so we have 2
file extents pointing to the same physical extents, so we bumped the
ref count. This will happen over and over again until we have
completely overwritten the original extent, at which point your space
usage will go back down to ~302g.We split big extents with cow, so
unless you've got lots of space to spare or are going to use nodatacow
you should probably not pre-allocate virt images

Vinayak

On Wed, Feb 28, 2018 at 8:52 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> On Wed, Feb 28, 2018 at 9:01 AM, vinayak hegde <vinayakhegdev@gmail.com> wrote:
>> I ran full defragement and balance both, but didnt help.
>
> Showing the same information immediately after full defragment would be helpful.
>
>> My created and accounting usage files are matching the du -sh output.
>> But I am not getting why btrfs internals use so much extra space.
>> My worry is, will get no space error earlier than I expect.
>> Is it expected with btrfs internal that it will use so much extra space?
>>
>
> Did you try to reboot? Deleted opened file could well cause this effect.
>
>> Vinayak
>>
>>
>>
>>
>> On Tue, Feb 27, 2018 at 7:24 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2018-02-27 08:09, vinayak hegde wrote:
>>>>
>>>> I am using btrfs, But I am seeing du -sh and df -h showing huge size
>>>> difference on ssd.
>>>>
>>>> mount:
>>>> /dev/drbd1 on /dc/fileunifier.datacache type btrfs
>>>>
>>>> (rw,noatime,nodiratime,flushoncommit,discard,nospace_cache,recovery,commit=5,subvolid=5,subvol=/)
>>>>
>>>>
>>>> du -sh /dc/fileunifier.datacache/ -  331G
>>>>
>>>> df -h
>>>> /dev/drbd1      746G  346G  398G  47% /dc/fileunifier.datacache
>>>>
>>>> btrfs fi usage /dc/fileunifier.datacache/
>>>> Overall:
>>>>      Device size:         745.19GiB
>>>>      Device allocated:         368.06GiB
>>>>      Device unallocated:         377.13GiB
>>>>      Device missing:             0.00B
>>>>      Used:             346.73GiB
>>>>      Free (estimated):         396.36GiB    (min: 207.80GiB)
>>>>      Data ratio:                  1.00
>>>>      Metadata ratio:              2.00
>>>>      Global reserve:         176.00MiB    (used: 0.00B)
>>>>
>>>> Data,single: Size:365.00GiB, Used:345.76GiB
>>>>     /dev/drbd1     365.00GiB
>>>>
>>>> Metadata,DUP: Size:1.50GiB, Used:493.23MiB
>>>>     /dev/drbd1       3.00GiB
>>>>
>>>> System,DUP: Size:32.00MiB, Used:80.00KiB
>>>>     /dev/drbd1      64.00MiB
>>>>
>>>> Unallocated:
>>>>     /dev/drbd1     377.13GiB
>>>>
>>>>
>>>> Even if we consider 6G metadata its 331+6 = 337.
>>>> where is 9GB used?
>>>>
>>>> Please explain.
>>>
>>> First, you're counting the metadata wrong.  The value shown per-device by
>>> `btrfs filesystem usage` already accounts for replication (so it's only 3 GB
>>> of metadata allocated, not 6 GB).  Neither `df` nor `du` looks at the chunk
>>> level allocations though.
>>>
>>> Now, with that out of the way, the discrepancy almost certainly comes form
>>> differences in how `df` and `du` calculate space usage.  In particular, `df`
>>> calls statvfs and looks at the f_blocks and f_bfree values to compute space
>>> usage, while `du` walks the filesystem tree calling stat on everything and
>>> looking at st_blksize and st_blocks (or instead at st_size if you pass in
>>> `--apparent-size` as an option).  This leads to a couple of differences in
>>> what they will count:
>>>
>>> 1. `du` may or may not properly count hardlinks, sparse files, and
>>> transparently compressed data, dependent on whether or not you use
>>> `--apparent-sizes` (by default, it does properly count all of those), while
>>> `df` will always account for those properly.
>>> 2. `du` does not properly account for reflinked blocks (from deduplication,
>>> snapshots, or use of the CLONE ioctl), and will count each reflink of every
>>> block as part of the total size, while `df` will always count each block
>>> exactly once no matter how many reflinks it has.
>>> 3. `du` does not account for all of the BTRFS metadata allocations,
>>> functionally ignoring space allocated for anything but inline data, while
>>> `df` accounts for all BTRFS metadata properly.
>>> 4. `du` will recurse into other filesystems if you don't pass the `-x`
>>> option to it, while `df` will only report for each filesystem separately.
>>> 5. `du` will only count data usage under the given mount point, and won't
>>> account for data on other subvolumes that may be mounted elsewhere (and if
>>> you pass in `-x` won't count data on other subvolumes located under the
>>> given path either), while `df` will count all the data in all subvolumes.
>>> 6. There are a couple of other differences too, but they're rather complex
>>> and dependent on the internals of BTRFS.
>>>
>>> In your case, I think the issue is probably one of the various things under
>>> item 6.  Items 1, 2 and 4 will cause `du` to report more space usage than
>>> `df`, item 3 is irrelevant because `du` shows less space than the total data
>>> chunk usage reported by `btrfs filesystem usage`, and item 5 is irrelevant
>>> because you're mounting the root subvolume and not using the `-x` option on
>>> `du` (and therefore there can't be other subvolumes you're missing).
>>>
>>> Try running a full defrag of the given mount point.  If what I think is
>>> causing this is in fact the issue, that should bring the numbers back
>>> in-line with each other.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
