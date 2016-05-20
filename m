Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:36563 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbcETW0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 18:26:54 -0400
Received: by mail-vk0-f42.google.com with SMTP id y2so90083036vka.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1c1358af-4549-618a-c408-b93832d33225@gmail.com>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
	<20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
	<e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
	<CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
	<1c1358af-4549-618a-c408-b93832d33225@gmail.com>
Date: Sat, 21 May 2016 00:26:53 +0200
Message-ID: <CAPmG0jbjdWf+98wr-NaL622wVAkfMJdHEij7feM9OK=AwZw68A@mail.gmail.com>
Subject: Re: Hot data tracking / hybrid storage
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>> bcache protective superblocks is a one-time procedure which can be done
>>>> online. The bcache devices act as normal HDD if not attached to a
>>>> caching SSD. It's really less pain than you may think. And it's a
>>>> solution available now. Converting back later is easy: Just detach the
>>>> HDDs from the SSDs and use them for some other purpose if you feel so
>>>> later. Having the bcache protective superblock still in place doesn't
>>>> hurt then. Bcache is a no-op without caching device attached.
>>>
>>>
>>> No, bcache is _almost_ a no-op without a caching device.  From a
>>> userspace
>>> perspective, it does nothing, but it is still another layer of
>>> indirection
>>> in the kernel, which does have a small impact on performance.  The same
>>> is
>>> true of using LVM with a single volume taking up the entire partition, it
>>> looks almost no different from just using the partition, but it will
>>> perform
>>> worse than using the partition directly.  I've actually done profiling of
>>> both to figure out base values for the overhead, and while bcache with no
>>> cache device is not as bad as the LVM example, it can still be a roughly
>>> 0.5-2% slowdown (it gets more noticeable the faster your backing storage
>>> is).
>>>
>>> You also lose the ability to mount that filesystem directly on a kernel
>>> without bcache support (this may or may not be an issue for you).
>>
>>
>> The bcache (protective) superblock is in an 8KiB block in front of the
>> file system device. In case the current, non-bcached HDD's use modern
>> partitioning, you can do a 5-minute remove or add of bcache, without
>> moving/copying filesystem data. So in case you have a bcache-formatted
>> HDD that had just 1 primary partition (512 byte logical sectors), the
>> partition start is at sector 2048 and the filesystem start is at 2064.
>> Hard removing bcache (so making sure the module is not
>> needed/loaded/used the next boot) can be done done by changing the
>> start-sector of the partition from 2048 to 2064. In gdisk one has to
>> change the alignment to 16 first, otherwise this it refuses. And of
>> course, also first flush+stop+de-register bcache for the HDD.
>>
>> The other way around is also possible, i.e. changing the start-sector
>> from 2048 to 2032. So that makes adding bcache to an existing
>> filesystem a 5 minute action and not a GBs- or TBs copy action. It is
>> not online of course, but just one reboot is needed (or just umount,
>> gdisk, partprobe, add bcache etc).
>> For RAID setups, one could just do 1 HDD first.
>
> My argument about the overhead was not about the superblock, it was about
> the bcache layer itself.  It isn't practical to just access the data
> directly if you plan on adding a cache device, because then you couldn't do
> so online unless you're going through bcache.  This extra layer of
> indirection in the kernel does add overhead, regardless of the on-disk
> format.

Yes, sorry, I took some shortcut in the discussion and jumped to a
method for avoiding this 0.5-2% slowdown that you mention. (Or a
kernel crashing in bcache code due to corrupt SB on a backing device
or corrupted caching device contents).
I am actually bit surprised that there is a measurable slowdown,
considering that it is basically just one 8KiB offset on a certain
layer in the kernel stack, but I haven't looked at that code.

> Secondarily, having a HDD with just one partition is not a typical use case,
> and that argument about the slack space resulting from the 1M alignment only
> holds true if you're using an MBR instead of a GPT layout (or for that
> matter, almost any other partition table format), and you're not booting
> from that disk (because GRUB embeds itself there). It's also fully possible
> to have an MBR formatted disk which doesn't have any spare space there too
> (which is how most flash drives get formatted).

I don't know other tables than MBR and GPT, but this bcache SB
'insertion' works with both. Indeed, if GRUB is involved, it can get
complicated, I have avoided that. If there is less than 8KiB slack
space on a HDD, I would worry about alignment/performance first, then
there is likely a reason to fully rewrite the HDD with a standard 1M
alingment.
If there is more partitions and the partition in front of the one you
would like to be bcached, I personally would shrink it by 8KiB (like
NTFS or swap or ext4 ) if that saves me TeraBytes of datatransfers.

> This also doesn't change the fact that without careful initial formatting
> (it is possible on some filesystems to embed the bcache SB at the beginning
> of the FS itself, many of them have some reserved space at the beginning of
> the partition for bootloaders, and this space doesn't have to exist when
> mounting the FS) or manual alteration of the partition, it's not possible to
> mount the FS on a system without bcache support.

If we consider a non-bootable single HDD btrfs FS, are you then
suggesting that the bcache SB could be placed in the first 64KiB where
also GRUB stores its code if the FS would need booting ?
That would be interesting, it would mean that also for btrfs on raw
device (and also multi-device) there is no extra exclusive 8KiB space
needed in front.
Is there someone who has this working? I think it would lead to issues
on the blocklayer, but I have currently no clue about that.

>> There is also a tool doing the conversion in-place (I haven't used it
>> myself, my python(s) had trouble; I could do the partition table edit
>> much faster/easier):
>> https://github.com/g2p/blocks#bcache-conversion
>>
> I actually hadn't known about this tool, thanks for mentioning it.
