Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34840 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbcGGSXt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 14:23:49 -0400
Received: by mail-it0-f66.google.com with SMTP id g4so4081536ith.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 11:23:48 -0700 (PDT)
Subject: Re: 64-btrfs.rules and degraded boot
To: kreijack@inwind.it, Andrei Borzenkov <arvidjaar@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
 <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
 <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
Date: Thu, 7 Jul 2016 14:23:40 -0400
MIME-Version: 1.0
In-Reply-To: <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 12:52, Goffredo Baroncelli wrote:
> On 2016-07-06 14:48, Austin S. Hemmelgarn wrote:
>> On 2016-07-06 08:39, Andrei Borzenkov wrote:
> [....]
>>>>>>
>>>>>> To be entirely honest, if it were me, I'd want systemd to
>>>>>> fsck off.  If the kernel mount(2) call succeeds, then the
>>>>>> filesystem was ready enough to mount, and if it doesn't, then
>>>>>> it wasn't, end of story.
>>>>>
>>>>> How should user space know when to try mount? What user space
>>>>> is supposed to do during boot if mount fails? Do you suggest
>>>>>
>>>>> while true; do mount /dev/foo && exit 0 done
>>>>>
>>>>> as part of startup sequence? And note that nowhere is systemd
>>>>> involved so far.
>>>> Nowhere there, except if you have a filesystem in fstab (or a
>>>> mount unit, which I hate for other reasons that I will not go
>>>> into right now), and you mount it and systemd thinks the device
>>>> isn't ready, it unmounts it _immediately_.  In the case of boot,
>>>> it's because of systemd thinking the device isn't ready that you
>>>> can't mount degraded with a missing device.  In the case of the
>>>> root filesystem at least, the initramfs is expected to handle
>>>> this, and most of them do poll in some way, or have other methods
>>>> of determining this.  I occasionally have issues with it with
>>>> dracut without systemd, but that's due to a separate bug there
>>>> involving the device mapper.
>>>>
>>>
>>> How this systemd bashing answers my question - how user space knows
>>> when it can call mount at startup?
>> You mentioned that systemd wasn't involved, which is patently false
>> if it's being used as your init system, and I was admittedly mostly
>> responding to that.
>>
>> Now, to answer the primary question which I forgot to answer:
>> Userspace doesn't.  Systemd doesn't either but assumes it does and
>> checks in a flawed way.  Dracut's polling loop assumes it does but
>> sometimes fails in a different way.  There is no way other than
>> calling mount right now to know for sure if the mount will succeed,
>> and that actually applies to a certain degree to any filesystem
>> (because any number of things that are outside of even the kernel's
>> control might happen while trying to mount the device.
>
> I think that there is no a simple answer, and the answer may depend by context.
> In the past, I made a prototype of a mount helper for btrfs [1]; the aim was to:
>
> 1) get rid of the actual btrfs volume discovery (udev which trigger btrfs dev scan) which has a lot of strange condition (what happens when a device disappear ?)
> 2) create a place where we develop and define strategies to handle all (or most) of the case of [partial] failure of a [multi-device] btrfs filesystem
>
> By default, my mount.btrfs waited the needed devices for a filesystem, and mount in degraded mode if not all devices are appeared (depending by a switch); if a timeout is reached, and error is returned.
>
> It doesn't need any special udev rule, because it performs a discovery of the devices using libuuid. I think that mounting a filesystem and handling all the possibles case relaying of the udev and its syntax of the udev rules is more a problem than a solution. Adding that udev and the udev rules are developed in a different project, the difficulties increase.
>
> I think that BTRFS for its complexity and their peculiarities need a dedicated tool like a mount helper.
>
> My mount.btrfs is not able to solve all the problem, but might be a starts for handling the issues.
FWIW, I've pretty much always been of the opinion that the device 
discovery belongs in a mount helper.  The auto-discovery from udev (and 
more importantly, how the kernel handles being told about a device) is 
much of the reason that it's so inherently dangerous to do block level 
copies.  There's obviously no way that can be changed now without 
breaking something, but that's on the really short list of things that I 
personally feel are worth breaking to fix a particularly dangerous 
pitfall.  The recent discovery that device ready state is write-once 
when set just reinforces this in my opinion.

Here's how I would picture the ideal situation:
* A device is processed by udev.  It detects that it's part of a BTRFS 
array, updates blkid and whatever else in userspace with this info, and 
then stops without telling the kernel.
* The kernel tracks devices until the filesystem they are part of is 
unmounted, or a mount of that FS fails.
* When the user goes to mount the a BTRFS filesystem, they use a mount 
helper.
   1. This helper queries udev/blkid/whatever to see which devices are 
part of an array.
   2. Once the helper determines which devices are potentially in the 
requested FS, it checks the following things to ensure array integrity:
     - Does each device report the same number of component devices for 
the array?
     - Does the reported number match the number of devices found?
     - If a mount by UUID is requested, do all the labels match on each 
device?
     - If a mount by LABEL is requested, do all the UUID's match on each 
device?
     - If a mount by path is requested, do all the component devices 
reported by that device have matching LABEL _and_ UUID?
     - Is any of the devices found already in-use by another mount?
   4. If any of the above checks fails, and the user has not specified 
an option to request a mount anyway, report the error and exit with 
non-zero status _before_ even talking to the kernel.
   5. If only the second check fails (the check verifying the number of 
devices found), and it fails because the number found is less than 
required for a non-degraded mount, ignore that check if and only if the 
user specified -o degraded.
   6. If any of the other checks fail, ignore them if and only if the 
user asks to ignore that specific check.
   7. Otherwise, notify the kernel about the devices and call mount(2).
* The mount helper parses it's own set of special options similar to the 
bg/fg/retry options used by mount.nfs to allow for timeouts when 
mounting, as well as asynchronous mounts in the background.
* btrfs device scan becomes a no-op
* btrfs device ready uses the above logic minus step 7 to determine if a 
filesystem is probably ready.

Such a situation would probably eliminate or at least reduce most of our 
current issues with device discovery, and provide much better error 
reporting and general flexibility.
