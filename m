Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36418 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdECSxP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 14:53:15 -0400
Received: by mail-it0-f52.google.com with SMTP id o5so123938ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 11:53:15 -0700 (PDT)
Subject: Re: Can I see what device was used to mount btrfs?
To: Andrei Borzenkov <arvidjaar@gmail.com>, kreijack@inwind.it,
        Adam Borowski <kilobyte@angband.pl>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
 <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
 <dd909c77-5014-3ec8-a976-7290145ad46d@gmail.com>
 <56861b10-fb38-518c-0448-58a329839093@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <87d64577-2753-63d1-453f-3395c9ee1215@gmail.com>
Date: Wed, 3 May 2017 14:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <56861b10-fb38-518c-0448-58a329839093@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-03 14:12, Andrei Borzenkov wrote:
> 03.05.2017 14:26, Austin S. Hemmelgarn пишет:
>> On 2017-05-02 15:50, Goffredo Baroncelli wrote:
>>> On 2017-05-02 20:49, Adam Borowski wrote:
>>>>> It could be some daemon that waits for btrfs to become complete.  Do we
>>>>> have something?
>>>> Such a daemon would also have to read the chunk tree.
>>>
>>> I don't think that a daemon is necessary. As proof of concept, in the
>>> past I developed a mount helper [1] which handled the mount of a btrfs
>>> filesystem:
>>> this handler first checks if the filesystem is a multivolume devices,
>>> if so it waits that all the devices are appeared. Finally mount the
>>> filesystem.
>>>
>>>> It's not so simple -- such a btrfs device would have THREE states:
>>>>
>>>> 1. not mountable yet (multi-device with not enough disks present)
>>>> 2. mountable ro / rw-degraded
>>>> 3. healthy
>>>
>>> My mount.btrfs could be "programmed" to wait a timeout, then it mounts
>>> the filesystem as degraded if not all devices are present. This is a
>>> very simple strategy, but this could be expanded.
>>>
>>> I am inclined to think that the current approach doesn't fit well the
>>> btrfs requirements.  The roles and responsibilities are spread to too
>>> much layer (udev, systemd, mount)... I hoped that my helper could be
>>> adopted in order to concentrate all the responsibility to only one
>>> binary; this would reduce the interface number with the other
>>> subsystem (eg systemd, udev).
>> The primary problem is that systemd treats BTRFS like a block-layer
>> instead of a filesystem (so it assumes all devices need to be present),
>> and that it doesn't trust the kernel's mount function to work correctly.
>
> My understanding is that before kernel mount can succeed for
> multi-device btrfs, kernel must be made aware of devices that comprise
> this filesystem. This is done by using (equivalent of) "btrfs device
> scan" or "btrfs device ready". Am I wrong here?
That is correct, the kernel needs to be notified about the devices via 
'btrfs device scan' (or directly with the ioctl that calls).  Udev calls 
this automatically on newly connected block devices though, so currently 
there is no reason manually run it on most systems.  Ideally, this 
should be in a mount helper and possibly triggered by 'btrfs filesystem 
show'.  Unless you're mounting a BTRFS volume or listing what the kernel 
knows about, there is no reason the kernel needs to be tracking the FS, 
so there is no point in regularly wasting time in udev processing by 
scanning all newly connected devices.

As far as 'btrfs device ready', that only tells you if the kernel thinks 
the filesystem is mountable _and_ not degraded.  It's usually correct, 
but watching that has the usual TOCTOU races present in any kind of 
status checking system, and it's useless if you want to mount degraded.
>
>>  As a result, it assumes that the mount operation will fail if it
>> doesn't see all the devices instead of just trying it like it should.
>
> So do you suggest that mount will succeed even if kernel is not made
> aware of all devices? If not, could you elaborate how btrfs should be
> mounted on boot - we must give mount command some device, right? How
> should we chose this device?
See my above comment on kernel awareness.

If you have 'degraded' in the mount options, the mount can succeed even 
if not all the devices are present.  Systemd refuses to even try the 
mount if it doesn't see all the devices, and then *unmounts* the FS if 
it gets mounted manually and not all devices are present.  Both of these 
are undesired behaviors for many people (the second more than the first).

I think I've outlined my thoughts on all of this somewhere before, but I 
can't find them, so I might as well do so here:

1. Device scanning should be done by a mount helper, not udev.  This 
closes a serious data safety/security issue present in the current 
combined implementation (if you plug in a device that has the same UUID 
as an existing BTRFS volume on the system and both volumes are marked as 
multi-device, you can cause data loss in the existing volume),  allows 
for more concise tracking of devices, and also eliminates the need for 
system-wide scanning in some cases (if you use 'device=' mount options 
that cover all the devices in the filesystem).  It also saves some time 
in processing of uevents for hot-plugged devices.

2. Systemd should not default to unmounting filesystems it thinks aren't 
ready yet when they've been manually mounted.  This behavior is highly 
counter-intuitive for most users ('The mount command didn't complain and 
returned 0 and dmesg has no errors, why the hell is the filesystem I 
just mounted not mounted?'), and more importantly in this context, makes 
it impossible to manually repair a BTRFS filesystem that's listed in a 
mount unit without dropping to emergency mode, which largely defeats the 
purpose of using a multi-device filesystem that can be repaired online.

3. For BTRFS, and possibly under special circumstances with other 
filesystems (partially present ZFS pool, partially assembled LVM or MD 
array that can run degraded, etc), systemd should try to mount the FS 
when it times out waiting for devices, and there should be an option to 
control this behavior.  While I don't advocate mounting filesystems 
degraded then letting the system run, some people do, and I still expect 
it to work, but currently it does not when using systemd. 
Alternatively, it could do a polling loop with a delay to call mount 
instead of using 'btrfs device ready'.
