Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57328 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbKJJSR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 04:18:17 -0500
Subject: Re: Ideas for btrfs-convert fix(or rework)
To: Roman Mamedov <rm@romanrm.net>
References: <56418E5D.9020604@gmx.com> <20151110125501.1aa6f155@natsu>
 <5641A7DA.6010102@gmx.com> <20151110140855.3ae7297c@natsu>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5641B64A.9020606@gmx.com>
Date: Tue, 10 Nov 2015 17:18:02 +0800
MIME-Version: 1.0
In-Reply-To: <20151110140855.3ae7297c@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Roman Mamedov wrote on 2015/11/10 14:08 +0500:
> On Tue, 10 Nov 2015 16:16:26 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>> So if things are correct, the btrfs you converted should still be in
>> mixed-bg mode.
>> A recent 'btrfs fi df' command should show things like:
>> Data+Metadata, DUP: total=512.00MiB, used=68.23MiB
>
> Actually not quite. After all the rebalancing, I currently have:
>
> Data, single: total=8.37TiB, used=7.50TiB
> System, DUP: total=32.00MiB, used=592.00KiB
> Metadata, DUP: total=8.00GiB, used=6.42GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>>> But as we know recently there were reports that it now causes corruption or
>>> does not work. So I wonder what happened that broke it, and is there really no
>>> simpler fix? Even if requiring the user to balance to get rid of the bloated
>>> Metadata like I had to.
>>>
>>
>> Yes, current btrfs-convert has problem on marking chunk meta or data.
>> Resulting some data extents may lay in metadata chunk, and vice verse.
>> At least it won't pass latest btrfsck.
>>
>> In that incorrect chunk layout, I'm not surprised any thing go wrong.
>
> Made an experiment:
>
> # dd if=/dev/zero bs=1M count=1 seek=100000 of=100G
> 1+0 records in
> 1+0 records out
> 1048576 bytes (1.0 MB) copied, 0.0023896 s, 439 MB/s
>
> # losetup /dev/loop7 100G
>
> # mkfs.ext4 /dev/loop7
>
> // Success
>
> # mount /dev/loop7 /mnt/tmp1/
>
> // Copy some files there
>
> # df -h /mnt/tmp1/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop7       96G  2.6G   89G   3% /mnt/tmp1
>
> # umount /mnt/tmp1/
>
> # btrfs-convert -d /dev/loop7
> creating btrfs metadata.
> creating ext2fs image file.
> cleaning up system chunk.
> conversion complete.

Here call 'btrfsck' from *latest* btrfs-progs.
You'll see tons of error, showing problems including:
1) stripes cross map boundary
    This will lead to kernel BUG_ON() when scrubbing.

2) Data extents in metadata chunks
    The problem causing the metadata accounting goes crazy.

>
> # mount /dev/loop7 /mnt/tmp1/
>
> # btrfs fi df /mnt/tmp1/
> Data, single: total=65.00GiB, used=1.32GiB
> System, single: total=32.00MiB, used=12.00KiB
> Metadata, single: total=32.63GiB, used=2.91GiB
> GlobalReserve, single: total=92.00MiB, used=0.00B
>

And your btrfs-convert is already broken, with wrong chunk allocation.

> # btrfs sub del /mnt/tmp1/ext2_saved
> Transaction commit: none (default)
> Delete subvolume '/mnt/tmp1/ext2_saved'
>
> # btrfs fi df /mnt/tmp1/
> Data, single: total=10.00GiB, used=120.12MiB
> System, single: total=32.00MiB, used=4.00KiB
> Metadata, single: total=4.00GiB, used=2.37GiB
> GlobalReserve, single: total=52.00MiB, used=0.00B
>
> // It has 2.6 GB of files, and most of them are now accounted as "Metadata".
>
> # btrfs fi balance start -m /mnt/tmp1/
> Done, had to relocate 5 out of 7 chunks
>
> // They are now reclassified as data:
>
> # btrfs fi df /mnt/tmp1/
> Data, single: total=10.00GiB, used=2.49GiB
> System, single: total=32.00MiB, used=4.00KiB
> Metadata, single: total=1.00GiB, used=468.00KiB
> GlobalReserve, single: total=4.00MiB, used=0.00B
>
> // Unmount, mount, checked all files integrity with 'cfv', all files are
> present and there is no corruption.
>
> So this behaves just like I remember it to, after conversion at first a large
> part of the data will show up as Metadata, but a balance fixes that. And most
> importantly no corruption issues. Maybe it's just because this is only a small
> test FS, but my production one earlier went through the same process without
> problems as well.

Yes, some problem can be fixed by such balance, as after balance, data 
and metadata will be relocated to correct new chunks.

But there may be a lot of hidden bugs here.
And we can't ignore such malfunction just because it's OK under some 
cases, or btrfs won't really become a production ready filesystem.

Thanks,
Qu

>
> Using btrfs-tools v3.17 and kernel 3.18.21
>
