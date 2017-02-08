Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36005 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbdBHKWn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 05:22:43 -0500
Received: by mail-lf0-f54.google.com with SMTP id z134so79142723lff.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 02:22:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
From: Vasco Visser <vasco.visser@gmail.com>
Date: Wed, 8 Feb 2017 10:55:55 +0100
Message-ID: <CALg=eG-2wMSjsBq6E68xqAiazC6rhnPB2OUoq2jAjtZe4vA9uQ@mail.gmail.com>
Subject: Re: understanding disk space usage
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the explanation. What I would still like to know is how
to relate the chunk level abstraction to the file level abstraction.
According to the btrfs output there is 2G of data space is available
and 24G of data space is being used. Does this mean 24G of data used
in files? How do I know which files take up most space? du seems
pretty useless as it reports only 9G of files on the volume.

--
Vasco


On Wed, Feb 8, 2017 at 4:48 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 02/08/2017 12:44 AM, Vasco Visser wrote:
>>
>> Hello,
>>
>> My system is or seems to be running out of disk space but I can't find
>> out how or why. Might be a BTRFS peculiarity, hence posting on this
>> list. Most indicators seem to suggest I'm filling up, but I can't
>> trace the disk usage to files on the FS.
>>
>> The issue is on my root filesystem on a 28GiB ssd partition (commands
>> below issued when booted into single user mode):
>>
>>
>> $ df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda3              28G   26G  2.1G  93% /
>>
>>
>> $ btrfs --version
>> btrfs-progs v4.4
>>
>>
>> $ btrfs fi usage /
>> Overall:
>>     Device size:  27.94GiB
>>     Device allocated:  27.94GiB
>>     Device unallocated:   1.00MiB
>
>
> So from chunk level, your fs is already full.
>
> And balance won't success since there is no unallocated space at all.
> The first 1M of btrfs is always reserved and won't be allocated, and 1M is
> too small for btrfs to allocate a chunk.
>
>>     Device missing:     0.00B
>>     Used:  25.03GiB
>>     Free (estimated):   2.37GiB (min: 2.37GiB)
>>     Data ratio:      1.00
>>     Metadata ratio:      1.00
>>     Global reserve: 256.00MiB (used: 0.00B)
>> Data,single: Size:26.69GiB, Used:24.32GiB
>
>
> You still have 2G data space, so you can still write things.
>
>>    /dev/sda3  26.69GiB
>> Metadata,single: Size:1.22GiB, Used:731.45MiB
>
>
> Metadata has has less space when considering "Global reserve".
> In fact the used space would be 987M.
>
> But it's still OK for normal write.
>
>>    /dev/sda3   1.22GiB
>> System,single: Size:32.00MiB, Used:16.00KiB
>>    /dev/sda3  32.00MiB
>
>
> System chunk can hardly be used up.
>
>> Unallocated:
>>    /dev/sda3   1.00MiB
>>
>>
>> $ btrfs fi df /
>> Data, single: total=26.69GiB, used=24.32GiB
>> System, single: total=32.00MiB, used=16.00KiB
>> Metadata, single: total=1.22GiB, used=731.48MiB
>> GlobalReserve, single: total=256.00MiB, used=0.00B
>>
>>
>> However:
>> $ mount -o bind / /mnt
>> $ sudo du -hs /mnt
>> 9.3G /mnt
>>
>>
>> Try to balance:
>> $ btrfs balance start /
>> ERROR: error during balancing '/': No space left on device
>>
>>
>> Am I really filling up? What can explain the huge discrepancy with the
>> output of du (no open file descriptors on deleted files can explain
>> this in single user mode) and the FS stats?
>
>
> Just don't believe the vanilla df output for btrfs.
>
> For btrfs, unlike other fs like ext4/xfs, which allocates chunk dynamically
> and has different metadata/data profile, we can only get a clear view of the
> fs from both chunk level(allocated/unallocated) and extent
> level(total/used).
>
> In your case, your fs doesn't have any unallocated space, this make balance
> unable to work at all.
>
> And your data/metadata usage is quite high, although both has small
> available space left, the fs should be writable for some time, but not long.
>
> To proceed, add a larger device to current fs, and do a balance or just
> delete the 28G partition then btrfs will handle the rest well.
>
> Thanks,
> Qu
>
>>
>> Any advice on possible causes and how to proceed?
>>
>>
>> --
>> Vasco
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
