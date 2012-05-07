From: cwillu <cwillu@cwillu.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 15:27:32 -0600
Message-ID: <CAE5mzvgJy9VHROkY+AwNspdW5T3t4_bts9F5eWmNdxCH4FCwrA@mail.gmail.com>
References: <4FA835D7.3040207@gmail.com>
	<C8PDfzNPCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PDfzNPCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 7, 2012 at 3:17 PM, Helmut Hullen <Hullen@t-online.de> wrot=
e:
> Hallo, Daniel,
>
> Du meintest am 07.05.12:
>
>>> =C2=A0 =C2=A0mkfs.btrfs =C2=A0-m raid1 -d raid0
>>>
>>> with 3 disks gives me a "cluster" which looks like 1 disk/partition=
/
>>> directory.
>>> If one disk fails nothing is usable.
>
>> How is that different from putting ext on top of a raid0?
>
> Classic raid0 doesn't allow deleting/removing disks from a cluster.
>
>>> With ext2/3/4 I mount 2 disks/partitions into the first disk. If on=
e
>>> disk fails the contents of the 2 other disks is still readable,
>
>> There is nothing that prevents you from using this strategy with
>> btrfs.
>
> How?
> I've tried many installations of btrfs, sometimes 1 disk failed, and
> then the data on all other disks was inaccessible.

"With ext2/3/4 I mount 2 disks/partitions into the first disk. If one
disk fails the contents of the 2 other disks is still readable,"

There's nothing stopping you from using 3 btrfs filesystems mounted in
the same way as you would 3 ext4 filesystems.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
