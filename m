Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2EVHs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 03:48:56 -0400
Received: by obbtb18 with SMTP id tb18so9268203obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 00:48:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBAEF1E.4050706@cn.fujitsu.com>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
	<20120518115041.GZ8938@carfax.org.uk>
	<CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>
	<4FB9A188.9090403@cn.fujitsu.com>
	<CAHf9xvZ8+ZXFLRM5R_xjekQOsf2Xaj0UEANMVW5BBJ2YjjhGuw@mail.gmail.com>
	<4FBA0BF1.1000901@cn.fujitsu.com>
	<CAHf9xvZDwjSJvJnaX9qmYyXJoM4t=E2zi=eH0bZpknYFpsAsjw@mail.gmail.com>
	<4FBAEF1E.4050706@cn.fujitsu.com>
Date: Tue, 22 May 2012 10:48:55 +0300
Message-ID: <CAHf9xvbRhUFM=C46O5xMUX2fTyV+RKOLfjC31-tTi+4r+71DwQ@mail.gmail.com>
Subject: Re: Newbie questions on some of btrfs code...
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Liu, that clarifies.

Alex.

On Tue, May 22, 2012 at 4:42 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 05/21/2012 06:05 PM, Alex Lyakas wrote:
>
>> Hi Liu,
>> thanks for the clarifications.
>>
>> I did not understand the dd example of yours, though.
>>
>>> So for the following situation:
>>>>       item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
>>>>               extent data disk byte 0 nr 0
>>>>               extent data offset 0 nr 4096 ram 8192
>>>>               extent compression 0
>>> As your case, after the first 'size 5' inline extent is written,
>>> "nr 4096 < ram 8192" could come from:
>>> 1) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=12 count=4 conv=notrunc;sync
>>> 2) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=8 count=4 conv=notrunc;sync
>>>
>>> 1) makes
>>>>       item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
>>>>               extent data disk byte 0 nr 0
>>>>               extent data offset 0 nr 8192 ram 8192
>>>>               extent compression 0
>>> 2) makes
>>>>       item 23 key (266 EXTENT_DATA 4096) itemoff 2269 itemsize 53
>>>>               extent data disk byte 0 nr 0
>>>>               extent data offset 0 nr 4096 ram 8192
>>>>               extent compression 0
>>
>> You talk about the "ram_bytes" field. But do I need to look at it, if
>> I don't use compression or another encoding? Shouldn't I always look
>> at btrfs_file_extent_item::offset/num_bytes for the real data, and at
>> btrfs_file_extent_item::disk_bytenr/disk_num_bytes for finding
>> CHUNK_ITEM? Any reason I should be aware of "ram_bytes" field?
>>
>
>> The first dd created a 4k extent at offset 12k. How did we end up with
>> "nr 8192 ram 8192" and offset 4k?
>> The second dd added a 4k extent at 8k offset. But still EXTENT_DATA
>> has 4k offset.
>> So now we should have have twp 4k extents or one 8k extent. What am I missing?
>>
>> Alex.
>>
>
>
> As I mentioned, disk_bytenr == 0 means dummy extents, which we have not yet allocate
> a range of space for it.
>
> After your first 'size=5' inline extent, we'll start allocating extents from _4096_, cause
> it is _4k aligned_.
>
>>> 1) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=12 count=4 conv=notrunc;sync
> : we need a dummy extent for [4k, 12k], which starts from 4096, and nr is 8192
>
>>> 2) dd if=/dev/zero of=/mnt/btrfs/foobar bs=1k seek=8 count=4 conv=notrunc;sync
> : we break [4k, 12k] into a dummy one [4k, 8k] and a real one [8k, 12k].
>
> More details, plz refer to btrfs_drop_extents();
>
> thanks,
> liubo
