Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:51512 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbcGGQwV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 12:52:21 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
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
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
Date: Thu, 7 Jul 2016 18:52:18 +0200
MIME-Version: 1.0
In-Reply-To: <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
Content-Type: text/plain; charset=windows-1251
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 14:48, Austin S. Hemmelgarn wrote:
> On 2016-07-06 08:39, Andrei Borzenkov wrote:
[....]
>>>>> 
>>>>> To be entirely honest, if it were me, I'd want systemd to
>>>>> fsck off.  If the kernel mount(2) call succeeds, then the
>>>>> filesystem was ready enough to mount, and if it doesn't, then
>>>>> it wasn't, end of story.
>>>> 
>>>> How should user space know when to try mount? What user space
>>>> is supposed to do during boot if mount fails? Do you suggest
>>>> 
>>>> while true; do mount /dev/foo && exit 0 done
>>>> 
>>>> as part of startup sequence? And note that nowhere is systemd
>>>> involved so far.
>>> Nowhere there, except if you have a filesystem in fstab (or a
>>> mount unit, which I hate for other reasons that I will not go
>>> into right now), and you mount it and systemd thinks the device
>>> isn't ready, it unmounts it _immediately_.  In the case of boot,
>>> it's because of systemd thinking the device isn't ready that you
>>> can't mount degraded with a missing device.  In the case of the
>>> root filesystem at least, the initramfs is expected to handle
>>> this, and most of them do poll in some way, or have other methods
>>> of determining this.  I occasionally have issues with it with
>>> dracut without systemd, but that's due to a separate bug there
>>> involving the device mapper.
>>> 
>> 
>> How this systemd bashing answers my question - how user space knows
>> when it can call mount at startup?
> You mentioned that systemd wasn't involved, which is patently false
> if it's being used as your init system, and I was admittedly mostly
> responding to that.
> 
> Now, to answer the primary question which I forgot to answer: 
> Userspace doesn't.  Systemd doesn't either but assumes it does and
> checks in a flawed way.  Dracut's polling loop assumes it does but
> sometimes fails in a different way.  There is no way other than
> calling mount right now to know for sure if the mount will succeed,
> and that actually applies to a certain degree to any filesystem
> (because any number of things that are outside of even the kernel's
> control might happen while trying to mount the device.

I think that there is no a simple answer, and the answer may depend by context. 
In the past, I made a prototype of a mount helper for btrfs [1]; the aim was to:

1) get rid of the actual btrfs volume discovery (udev which trigger btrfs dev scan) which has a lot of strange condition (what happens when a device disappear ?)
2) create a place where we develop and define strategies to handle all (or most) of the case of [partial] failure of a [multi-device] btrfs filesystem

By default, my mount.btrfs waited the needed devices for a filesystem, and mount in degraded mode if not all devices are appeared (depending by a switch); if a timeout is reached, and error is returned.

It doesn't need any special udev rule, because it performs a discovery of the devices using libuuid. I think that mounting a filesystem and handling all the possibles case relaying of the udev and its syntax of the udev rules is more a problem than a solution. Adding that udev and the udev rules are developed in a different project, the difficulties increase.

I think that BTRFS for its complexity and their peculiarities need a dedicated tool like a mount helper.

My mount.btrfs is not able to solve all the problem, but might be a starts for handling the issues.

BR
G.Baroncelli


[1] http://www.spinics.net/lists/linux-btrfs/msg28764.html



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
