From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: fstrim on BTRFS
Date: Fri, 30 Dec 2011 14:19:08 +0800
Message-ID: <4EFD57DC.30502@cn.fujitsu.com>
References: <201112281757.16019.Martin@lichtvoll.de>	<CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>	<4EFC356F.4060904@cn.fujitsu.com> <CAG1y0sceqdqqPUQBYEuL-2og=AVFfkEeJksbXyREHNQ5Xy40EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sceqdqqPUQBYEuL-2og=AVFfkEeJksbXyREHNQ5Xy40EQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha wrote:
> On Thu, Dec 29, 2011 at 4:39 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Fajar A. Nugraha wrote:
>>> On Wed, Dec 28, 2011 at 11:57 PM, Martin Steigerwald
>>> <Martin@lichtvoll.de> wrote:
>>>> But BTRFS does not:
>>>>
>>>> merkaba:~> fstrim -v /
>>>> /: 4431613952 bytes were trimmed
>>>> merkaba:~> fstrim -v /
>>>> /: 4341846016 bytes were trimmed
>>>
>>> .... and apparently it can't trim everything. Or maybe my kernel is
>>> just too old.
>>>
>>>
>>> $ sudo fstrim -v /
>>> 2258165760 Bytes was trimmed
>>>
>>> $ df -h /
>>> Filesystem            Size  Used Avail Use% Mounted on
>>> /dev/sda6              50G   34G   12G  75% /
>>>
>>> $ mount | grep "/ "
>>> /dev/sda6 on / type btrfs (rw,noatime,subvolid=258,compress-force=lzo)
>>>
>>> so only about 2G out of 12G can be trimmed. This is on kernel 3.1.4.
>>>
>>
>> That's because only free spaces in block groups will be trimmed. Btrfs
>> allocates space from block groups, and when there's no space availabe,
>> it will allocate a new block group from the pool. In your case there's
>> ~10G in the pool.
> 
> Thanks for your response.
> 
>>
>> You can do a "btrfs fi df /", and you'll see the total size of existing
>> block groups.
> 
> $ sudo btrfs fi df /
> Data: total=43.47GB, used=31.88GB
> System, DUP: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=3.25GB, used=619.88MB

This is DUP, so the actual physical size is (3.25 * 2) = 6.5G

> Metadata: total=8.00MB, used=0.00
> 
> That should mean existing block groups is at least 46GB, right? In

so the sum is 50G.

> which case my pool (a 50G partition) should only have about 4GB of
> space not allocated to block groups. The numbers don't seem to match.
> 

The pool has been emptied, so there're other reasons that you had only
~2GB trimmed, and the possible reason is fstrim in btrfs is buggy.

I sent a fix weeks ago, which is not merged yet:

	http://marc.info/?l=linux-btrfs&m=132212530410572&w=2

>>
>> You can empty the pool by:
>>
>>        # dd if=/dev/zero of=/mytmpfile bs=1M
>>
>> Then release the space (but it won't return back to the pool):
>>
>>        # rm /mytmpfile
>>        # sync
> 
> Is there a bad side effect of doing so? For example, since all free
> space in the pool would be allocated to data block group, would that
> mean my metadata block group is capped at 3.25GB?

You can config the ratio of data block groups and metadata block groups
via "metadata_ratio=" mount option.

> Or would some data
> block group can be converted to metadata, and vice versa?
> 

This won't happen. Also empty block groups won't be reclaimed, but it's
in TODO list.
