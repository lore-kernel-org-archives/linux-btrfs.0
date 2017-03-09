Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37695 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbdCINzF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2017 08:55:05 -0500
Received: by mail-it0-f50.google.com with SMTP id g138so66768842itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Mar 2017 05:54:44 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
 <22712.48434.400550.346157@tree.ty.sabi.co.uk>
 <284e9d01-3e69-705e-dd88-ebe047e2e4b8@gmail.com>
 <22716.25419.146443.191478@tree.ty.sabi.co.uk>
 <0d731a6d-4677-1d58-9f79-a8d7d2bcac37@gmail.com>
 <22721.9515.564892.221096@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <50fa13c0-1b38-098c-edab-8ad4b0195773@gmail.com>
Date: Thu, 9 Mar 2017 08:54:38 -0500
MIME-Version: 1.0
In-Reply-To: <22721.9515.564892.221096@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-09 04:49, Peter Grandi wrote:
>>> Consider the common case of a 3-member volume with a 'raid1'
>>> target profile: if the sysadm thinks that a drive should be
>>> replaced, the goal is to take it out *without* converting every
>>> chunk to 'single', because with 2-out-of-3 devices half of the
>>> chunks will still be fully mirrored.
>
>>> Also, removing the device to be replaced should really not be
>>> the same thing as balancing the chunks, if there is space, to be
>>> 'raid1' across remaining drives, because that's a completely
>>> different operation.
>
>> There is a command specifically for replacing devices.  It
>> operates very differently from the add+delete or delete+add
>> sequences. [ ... ]
>
> Perhaps it was not clear that I was talking about removing a
> device, as distinct from replacing it, and that I used "removed"
> instead of "deleted" deliberately, to avoid the confusion with
> the 'delete' command.
Ah, sorry I misunderstood what you were saying.
>
> In the everyday practice of system administration it often
> happens that a device should be removed first, and replaced
> later, for example when it is suspected to be faulty, or is
> intermittently faulty. The replacement can be done with
> 'replace' or 'add+delete' or 'delete+add', but that's a
> different matter.
>
> Perhaps I should have not have used the generic verb "remove",
> but written "make unavailable".
>
> This brings about again the topic of some "confusion" in the
> design of the Btrfs multidevice handling logic, where at least
> initially one could only expand the storage space of a
> multidevice by 'add' of a new device or shrink the storage space
> by 'delete' of an existing one, but I think it was not conceived
> at Btrfs design time of storage space being nominally constant
> but for a device (and the chunks on it) having a state of
> "available" ("present", "online", "enabled") or "unavailable"
> ("absent", "offline", "disabled"), either because of events or
> because of system administrator action.
>
> The 'missing' pseudo-device designator was added later, and
> 'replace' also later to avoid having to first expand then shrink
> (or viceversa) the storage space and the related copying.
>
> My impression is that it would be less "confused" if the Btrfs
> device handling logic were changed to allow for the the state of
> "member of the multidevice set but not actually available" and
> the related consequent state for chunks that ought to be on it;
> that probably would be essential to fixing the confusing current
> aspects of recovery in a multidevice set. That would be very
> useful even if it may require a change in the on-disk format to
> distinguish the distinct states of membership and availability
> for devices and mark chunks as available or not (chunks of course
> being only possible on member devices).
>
> That is, it would also be nice to have the opposite state of "not
> member of the multidevice set but actually available to it", that
> is a spare device, and related logic.
OK, so expanding on this a bit, there are currently three functional 
device states in BTRFS right now (note that the terms I use here aren't 
official, they're just what I use to describe them):
1. Active/Online.  This is the normal state for a device, you can both 
read from it and write to it.
2. Inactive/Replacing/Deleting.  This is the state a device is in when 
it's either being deleted or replaced.  Inactive devices don't count 
towards total volume size, and can't be written to, but can be read from 
if they weren't missing prior to becoming inactive.
3. Missing/Offilne.  This is pretty self explanatory.  A device in this 
state can't be read from or written to, but it does count towards volume 
size.

Currently, the only transitions available to a sysadmin through BTRFS 
itself are temporary transitions from Active to Inactive (replace and 
delete).

In an ideal situation, there would be two other states:
4. Local hot-spare/Nearline.  Won't be read from and doesn't count 
towards total volume size, but may be written to (depending on how the 
FS is configured), and will be automatically used to replace a failed 
device in the filesystem it's associated with.
5. Global hot-spare.  Similar to local hot-spare, but can be used for 
any filesystem on the system, and won't be touched until it's needed.

The following manually initiated transitions would be possible for 
regular operation:
1. Active -> Inactive (persistently)
2. Inactive -> Active
3. Active -> Local hot-spare
4. Inactive -> Local hot-spare
5. Local hot-spare -> Active
6. Local hot-spare -> Inactive
7. Global hot-spare -> Active
8. Global hot-spare -> Inactive
9. Local hot-spare -> Global hot-spare
10. Global hot-spare -> Local hot-spare

And the following automatic transitions would be possible:
1. Local hot-spare -> Active
2. Global hot-spare -> Active
3. <any other state> -> Missing
4. Missing -> <any other state>

And there would be the option of manually triggering the automatic 
transitions for debugging purposes.
>
> Note: simply setting '/sys/block/$DEV/device/delete' is not a
> good option, because that makes the device unavailable not just
> to Btrfs, but also to the whole systems. In the ordinary practice
> of system administration it may well be useful to make a device
> unavailable to Btrfs but still available to the system, for
> example for testing, and anyhow they are logically distinct
> states. That also means a member device might well be available
> to the system, but marked as "not available" to Btrfs.

