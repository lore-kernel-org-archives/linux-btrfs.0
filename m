From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 16:52:15 +0700
Message-ID: <CAG1y0sceqdqqPUQBYEuL-2og=AVFfkEeJksbXyREHNQ5Xy40EQ@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
	<CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>
	<4EFC356F.4060904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFC356F.4060904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 29, 2011 at 4:39 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Fajar A. Nugraha wrote:
>> On Wed, Dec 28, 2011 at 11:57 PM, Martin Steigerwald
>> <Martin@lichtvoll.de> wrote:
>>> But BTRFS does not:
>>>
>>> merkaba:~> fstrim -v /
>>> /: 4431613952 bytes were trimmed
>>> merkaba:~> fstrim -v /
>>> /: 4341846016 bytes were trimmed
>>
>> .... and apparently it can't trim everything. Or maybe my kernel is
>> just too old.
>>
>>
>> $ sudo fstrim -v /
>> 2258165760 Bytes was trimmed
>>
>> $ df -h /
>> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
>> /dev/sda6 =A0 =A0 =A0 =A0 =A0 =A0 =A050G =A0 34G =A0 12G =A075% /
>>
>> $ mount | grep "/ "
>> /dev/sda6 on / type btrfs (rw,noatime,subvolid=3D258,compress-force=3D=
lzo)
>>
>> so only about 2G out of 12G can be trimmed. This is on kernel 3.1.4.
>>
>
> That's because only free spaces in block groups will be trimmed. Btrf=
s
> allocates space from block groups, and when there's no space availabe=
,
> it will allocate a new block group from the pool. In your case there'=
s
> ~10G in the pool.

Thanks for your response.

>
> You can do a "btrfs fi df /", and you'll see the total size of existi=
ng
> block groups.

$ sudo btrfs fi df /
Data: total=3D43.47GB, used=3D31.88GB
System, DUP: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D3.25GB, used=3D619.88MB
Metadata: total=3D8.00MB, used=3D0.00

That should mean existing block groups is at least 46GB, right? In
which case my pool (a 50G partition) should only have about 4GB of
space not allocated to block groups. The numbers don't seem to match.

>
> You can empty the pool by:
>
> =A0 =A0 =A0 =A0# dd if=3D/dev/zero of=3D/mytmpfile bs=3D1M
>
> Then release the space (but it won't return back to the pool):
>
> =A0 =A0 =A0 =A0# rm /mytmpfile
> =A0 =A0 =A0 =A0# sync

Is there a bad side effect of doing so? For example, since all free
space in the pool would be allocated to data block group, would that
mean my metadata block group is capped at 3.25GB? Or would some data
block group can be converted to metadata, and vice versa?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
