Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43528 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3D1TVH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Apr 2013 15:21:07 -0400
Received: by mail-lb0-f177.google.com with SMTP id x10so5091685lbi.36
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 12:21:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHgo1R+A+n4TJj9fQ5HhOeeqZ943f+==gv8Ak9kFBhVZv7pXEw@mail.gmail.com>
References: <CAHgo1RLE6RuSvHsBrGUvmMv6f1kE12oNdMgAVtZ3mJMu+U-5fw@mail.gmail.com>
 <CAFWF=anMBZGRqbykcASeimq=SO=GXjipN5uJoi-LGvURONXDow@mail.gmail.com>
 <CAHgo1RJz6E0pX99t8boj1MvtcV=hUveBrUcA-cV5bjRO7EVK=A@mail.gmail.com>
 <CAFWF=anbQg07mDDQQSZSSN4JTEMS43vi2cfu3CuW35uxH=TbSA@mail.gmail.com> <CAHgo1R+A+n4TJj9fQ5HhOeeqZ943f+==gv8Ak9kFBhVZv7pXEw@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 28 Apr 2013 21:20:45 +0200
Message-ID: <CAFWF=amYEOnT=vu6VH6hn7uHr+0k6deseT+GrvJzZHNJb--ypA@mail.gmail.com>
Subject: Re: Btrfs performance problem; metadata size to blame?
To: "John ." <btrfsprob@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 28, 2013 at 9:18 PM, John . <btrfsprob@gmail.com> wrote:
> I use Ubuntu with kernel 3.8.0-19-generic. I also tested with the
> latest live disk of Arch Linux; write performance was the same (bad).
>
> My mount options: rw,compress=lzo.
> Iotop does not show any strange disk activity.
>
> 2013/4/28 Harald Glatt <mail@hachre.de>:
>> On Sun, Apr 28, 2013 at 9:10 PM, John . <btrfsprob@gmail.com> wrote:
>>> Hi Harald,
>>>
>>> I did perform a defrag of the volume a few hours ago. This did not
>>> make a difference. :(
>>>
>>> Yours,
>>>
>>> John
>>>
>>> 2013/4/28 Harald Glatt <mail@hachre.de>:
>>>> On Sun, Apr 28, 2013 at 9:04 PM, John . <btrfsprob@gmail.com> wrote:
>>>>> Hi guys,
>>>>>
>>>>> My Btrfs fs has a performance problem which I hope you can help me
>>>>> solve. I have a dataset of around 3.15 TiB, that has lived on a ZFS
>>>>> volume for almost two years (ZRAID1, 4 2TiB disks). In order to move
>>>>> to Btrfs I bought myself a 4TiB disk with the idea of buying a new one
>>>>> next week and balance it to a RAID1 of 2 4TiB disks.
>>>>>
>>>>> I created a single disk Btrfs volume with the default mkfs options (no
>>>>> data duplication, metadata duplication on). Next I transferred my
>>>>> dataset to this disk (no problems there). Today when I tried to create
>>>>> a directory and I noticed the Btrfs volume was awefully slow; it took
>>>>> a few seconds to create the directory and a few to delete it (which
>>>>> should be milliseconds as you know). In fact each and every operation
>>>>> on the volume grinded the fs down to a halt.
>>>>>
>>>>> FS information:
>>>>>
>>>>> # btrfs fi df /storage
>>>>> Data: total=3.29TB, used=3.15TB
>>>>> System, DUP: total=8.00MB, used=360.00KB
>>>>> System: total=4.00MB, used=0.00
>>>>> Metadata, DUP: total=4.00GB, used=3.88GB
>>>>> Metadata: total=8.00MB, used=0.00
>>>>>
>>>>> # btrfs fi show
>>>>> Label: 'storage'  uuid: 3fa262cd-baa9-46dc-92a8-318c87166186
>>>>>         Total devices 1 FS bytes used 3.16TB
>>>>>         devid    1 size 3.64TB used 3.30TB path /dev/sdb
>>>>>
>>>>> I suspect my performance blow has everything to do with the abysmally
>>>>> low amount of space for metadata that is left, but since I am not a
>>>>> Btrfs guru I don't now whether this is truly the case and/or how to
>>>>> solve it. btrfs fi balance start -dusage=5 did not help.
>>>>>
>>>>> Yours,
>>>>>
>>>>> John
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> Try to defragment the root of the volume (e.g the mountpoint). While
>>>> it's mounted:
>>>> btrfs fi defrag /path/to/mnt
>>>>
>>>> Then try performance again
>>
>> What kernel version do you use? What are your mount options? Try to
>> run iotop and see if there is any unusual activity...

Try mount -o inode_cache,space_cache,autodefrag - first mount with the
new options might take a while, also there might be disk activity for
a while after mounting with this...
