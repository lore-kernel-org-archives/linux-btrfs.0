Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33591 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbLOOUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 09:20:35 -0500
Received: by mail-ig0-f178.google.com with SMTP id mv3so103915435igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 06:20:35 -0800 (PST)
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net> <566EC2D7.3000101@gmail.com>
 <1450138105.701.24.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5670218C.2010104@gmail.com>
Date: Tue, 15 Dec 2015 09:19:56 -0500
MIME-Version: 1.0
In-Reply-To: <1450138105.701.24.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 19:08, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 08:23 -0500, Austin S. Hemmelgarn wrote:
>> The reason that this isn't quite as high of a concern is because
>> performing this attack requires either root access, or direct
>> physical
>> access to the hardware, and in either case, your system is already
>> compromised.
> No necessarily.
> Apart from the ATM image (where most people wouldn't call it
> compromised, just because it's openly accessible on the street)
Um, no you don't have direct physical access to the hardware with an 
ATM, at least, not unless you are going to take apart the cover and 
anything else in your way (and probably set off internal alarms).  And 
even without that, it's still possible to DoS an ATM without much 
effort.  Most of them have a 3.5mm headphone jack for TTS for people 
with poor vision, and that's more than enough to overload at least part 
of the system with a relatively simple to put together bit of 
electronics that would cost you less than 10 USD.
> imageine you're running a VM hosting service, where you allow users to
> upload images and have them deployed.
> In the cheap" case these will end up as regular files, where they
> couldn't do any harm (even if colliding UUIDs)... but even there one
> would have to expect, that the hypervisor admin may losetup them for
> whichever reason.
> But if you offer more professional services, you may give your clients
> e.g. direct access to some storage backend, which are then probably
> also seen on the host by its kernel.
> And here we already have the case, that a client could remotely trigger
> such collision.
In that particular situation, it's not relevant unless the host admin 
goes to mount them.  UUID collisions are only an issue if the 
filesystems get mounted.
>
> And remember, things only sounds far-fetched until it actually happens
> the first time ;)
>
>
>> I still think that that isn't a sufficient excuse for not fixing the
>> issue, as there are a number of non-security related issues that can
>> result from this (there are some things that are common practice with
>> LVM or mdraid that can't be done with BTRFS because of this).
> Sure, I guess we agree on that,...
>
>
>>> Apart from that, btrfs should be a general purpose fs, and not just
>>> a
>>> desktop or server fs.
>>> So edge cases like forensics (where it's common that you create
>>> bitwise
>>> identical images) shouln't be forgotten either.
>> While I would normally agree, there are ways to work around this in
>> the
>> forensics case that don't work for any other case (namely, if BTRFS
>> is
>> built as a module, you can unmount everything, unload the module,
>> reload
>> it, and only scan the devices you want).
> see below (*)
>
>
>> On that note, why exactly is it better to make the filesystem UUID
>> such
>> an integral part of the filesystem?
> Well I think it's a proper way to e.g. handle the multi-device case.
> You have n devices, you want to differ them,... using a pseudo-random
> UUID is surely better than giving them numbers.
That's debatable, the same issues are obviously present in both cases 
(individual numbers can collide too).
> Same for the fs UUID, e.g. when used for mounting devices whose paths
> aren't stable.
In the case of a sanely designed system using LVM for example, device 
paths are stable.
>
> As said before, using the UUID isn't the problem - not protecting
> against collisions is.
No, the issues are:
1. We assume that the UUID will be unique for the life of the 
filesystem, which is not a safe assumption.
2. We don't sanely handle things if it isn't unique.
>
>
>> The other thing I'm reading out of
>> this all, is that by writing a total of 64 bytes to a specific
>> location
>> in a single disk in a multi-device BTRFS filesystem, you can make the
>> whole filesystem fall apart, which is absolutely absurd.
> Well,... I don't think that writing *into* the filesystem is covered by
> common practise anymore.
For end users, I agree.  Part of the discussion involves attacks on the 
system, and for a attacker it's not a far stretch to write directly to 
the block device if possible (and it's even common practice for 
bypassing permission checks done in the VFS layer).
>
> In UNIX, a device (which holds the filesystem) is a file. Therefore one
> can argue: if one copies/duplicates one file (i.e. the fs) neither of
> the two's contents should get corrupted.
> But if you actively write *into* the file by yourself,... then you're
> simply on your own, either you know what you do, or just may just
> corrupt *that* specific file. Of course it should again not lead to any
> of it's clones or become corrupted as well.
My point is that by changing the UUID in a superblock (and properly 
updating the checksum for the superblock), you can trivially break a 
multi-device filesystem.  And it's a whole lot easier to do that than it 
is to do the equivalent for LVM.
>
>
>> And some recovery situations (think along the lines of no recovery
>> disk,
>> and you only have busybox or something similar to work with).
> (*) which is however also, why you may not be able to unmount the
> device anymore or unload btrfs.
> Maybe you have reasons you must/want to do any forensics in the running
> system.
>
>
>>> AFAIK, there's not even a solution right now, that copies a
>>> complete
>>> btrfs, with snapshots, etc. preserving all ref-links. At least
>>> nothing
>>> official that works in one command.
>> Send-receive kind of works for that
> I've added the "in one command" for that... O:-)
> In case the btrfs would have subvols/snapshots... the user would need
> to make the recursion himself...

