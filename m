From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Wed, 24 Aug 2011 12:06:24 -0500
Message-ID: <CAKcLGm8wYKKZ-yEX3_A612MJPLND3DnM-7+N_hw3LUxwQe837w@mail.gmail.com>
References: <4E54F884.9090004@cyberwizzard.nl>
	<4E54FD31.1050003@gmx.net>
	<4E551242.6000508@cyberwizzard.nl>
	<4E55130F.2000507@gmx.net>
	<4E551529.1000200@cyberwizzard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
To: Berend Dekens <btrfs@cyberwizzard.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E551529.1000200@cyberwizzard.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2011 at 10:13 AM, Berend Dekens <btrfs@cyberwizzard.nl> wrote:
> On 24/08/11 17:04, Arne Jansen wrote:
>>
>> On 24.08.2011 17:01, Berend Dekens wrote:
>>>
>>> On 24/08/11 15:31, Arne Jansen wrote:
>>>>
>>>> On 24.08.2011 15:11, Berend Dekens wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I have followed the progress made in the btrfs filesystem over time and
>>>>> while I have experimented with it a little in a VM, I have not yet used it
>>>>> in a production machine.
>>>>>
>>>>> While the lack of a complete fsck was a major issue (I read the update
>>>>> that the first working version is about to be released) I am still worried
>>>>> about an issue I see popping up.
>>>>>
>>>>> How is it possible that a copy-on-write filesystem becomes corrupted if
>>>>> a power failure occurs? I assume this means that even (hard) resetting a
>>>>> computer can result in a corrupt filesystem.
>>>>>
>>>>> I thought the idea of COW was that whatever happens, you can always
>>>>> mount in a semi-consistent state?
>>>>>
>>>>> As far as I can see, you wind up with this:
>>>>> - No outstanding writes when power down
>>>>> - File write complete, tree structure is updated. Since everything is
>>>>> hashed and duplicated, unless the update propagates to the highest level,
>>>>> the write will simply disappear upon failure. While this might be rectified
>>>>> with a fsck, there should be no problems mounting the filesystem (read-only
>>>>> if need be)
>>>>> - Writes are not completed on all disks/partitions at the same time.
>>>>> The checksums will detect these errors and once again, the write disappears
>>>>> unless it is salvaged by a fsck.
>>>>>
>>>>> Am I missing something? How come there seem to be plenty people with a
>>>>> corrupt btrfs after a power failure? And why haven't I experienced similar
>>>>> issues where a filesystem becomes unmountable with say NTFS or Ext3/4?
>>>>
>>>> Problems arise when in your scenario writes from higher levels in the
>>>> tree hit the disk earlier than updates on lower levels. In this case
>>>> the tree is broken and the fs is unmountable.
>>>> Of course btrfs takes care of the order it writes, but problems arise
>>>> when the disk is lying about whether a write is stable on disk, i.e.
>>>> about cache flushes or barriers.
>>>
>>> Ah, I see. So the issue is not with the software implementation at all
>>> but only arises when hardware acknowledges flushes and barriers before they
>>> actually complete?
>>
>> It doesn't mean there aren't any bugs left in the software stack ;)
>
> Naturally, but the fact that its very likely that the corruption stories
> I've been reading about are caused by misbehaving hardware set my mind at
> ease about experimenting further with btrfs (although I will await the fsck
> before attempting things in production).
>>>
>>> Is this a common problem of hard disks?
>>
>> Only of very cheap ones. USB enclosures might add to the problem, too.
>> Also some SSDs are rumored to be bad in this regard.
>> Another problem are layers between btrfs and the hardware, like
>> encryption.
>
> I am - and will be - using btrfs straight on hard disks, no lvm, (soft)raid,
> encryption or other layers.
>
> My hard drives are not that fancy (no 15k raptors here); I usually buy
> hardware from the major suppliers (WD, Maxtor, Seagate, Hitachi etc). Also,
> until the fast cache mode for SSDs in combination with rotating hardware
> becomes stable, I'll stick to ordinary hard drives.
>
> Thank you for clarifying things.
>

I have to admit I've been beginning to wonder if we picked up a
regression somewhere along the way with respect to corruptions after
power outages.

I'm lucky enough to have very unreliable power.  Btrfs was always
robust for me on power outages until recently.  Now I've recently had
two corrupted volumes on unclean shutdowns and power outages.
