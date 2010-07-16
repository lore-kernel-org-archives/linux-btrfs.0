From: Mathijs Kwik <bluescreen303@gmail.com>
Subject: Re: raid modes, balancing, and order in which data gets written
Date: Fri, 16 Jul 2010 08:09:00 +0200
Message-ID: <AANLkTinlgpz3N6QT8_uNUFgyMXTDB-v-XkvyJaXiRaBm@mail.gmail.com>
References: <AANLkTimPpNmiJ-sr4_DjsWHXAgfb2FUPDeEi6n86pKEH@mail.gmail.com>
	<20100715231920.GA12725@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Mathijs Kwik <bluescreen303@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100715231920.GA12725@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Ok, cool.
Thanks for clearing that up.

on-the-fly changing of raid-level sounds very useful.
So, the way you describe it, it should also (eventually) be possible
to change the raid-level on a per-file or per-directory basis?
It might be quite useful to have the majority of data on raid5/raid10
but have some "scratch dirs" available with very high performance
(raid0), without having to create a new filesystem and deciding how
big it needs to be.




On Fri, Jul 16, 2010 at 1:19 AM, Sean Bartell <wingedtachikoma@gmail.com> wrote:
> On Thu, Jul 15, 2010 at 10:29:07AM +0200, Mathijs Kwik wrote:
>> Hi all,
>>
>> I read that btrfs - in a raid mode - does not mimic the behavior of
>> traditional (hw/sw) raid.
>> After writing to a btrfs raid filesystem, data will only be
>> distributed the way you expect after running a rebalance.
>
> This is not the case. When you create a btrfs filesystem with RAID
> enabled, stuff written from then on will be written just like with
> traditional RAID.
>
> The difference with traditional RAID is that different parts of the FS
> can have different RAID settings. Btrfs reserves space in ~1GiB "block
> groups" for data or metadata, each of which has its own RAID settings.
> If you change the RAID mode for an existing filesystem (not yet
> supported IIUC) or add/remove devices, the existing block groups will
> keep their old RAID settings if at all possible.
>
> Rebalancing essentially moves everything into new block groups, which
> will use the new RAID settings and be more balanced between data and
> metadata. It isn't useful unless you change RAID settings, add/remove
> devices, or have too much space reserved for either data or metadata.
>
>> [...]
>
>> If you never rebalance manually, will the filesystem do this in the
>> background (when idle)?
>> Or will the fs never rebalance itself and only become "more balanced"
>> again after writing/changing some files, which it will then place on
>> the drive which has the lowest balance?
>
> Rebalancing isn't done automatically, and nothing can become "more
> balanced" until new block groups are created when you run out of space
> in the old ones.
>
>> Basically, I'm not sure I fully understood balancing, so any info on
>> this would be great.
>> In traditional raid0 and raid10 (block based), it is guaranteed that
>> any big file will always be stiped between disks equally, so a certain
>> performance can be assumed.
>> With non-automatic balancing, I'm afraid some files might not be
>> distributed as well as they could, resulting in lower performance.
>> Is this an issue to be aware of, or can I safely assume that for most
>> use cases the performance will roughly be the same as sw-raid?
>> 2 cases I'm interested in:
>> - big databases(lots of rewrites)
>> - real-time video-capturing (sustained write to 1 or more big files,
>> needing a guaranteed write throughput)
>
> If you initially create the filesystem with the right RAID settings, it
> will act just like normal software RAID. Balancing only comes into play
> when you start changing your mind :).
>
>> Any info on this or balancing in general will be greatly appreciated.
>
