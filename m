Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33993 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbcGFMjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 08:39:22 -0400
Received: by mail-lf0-f67.google.com with SMTP id l102so9918573lfi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 05:39:21 -0700 (PDT)
Content-Type: text/plain;
	charset=windows-1251
Mime-Version: 1.0 (1.0)
Subject: Re: 64-btrfs.rules and degraded boot
From: Andrei Borzenkov <arvidjaar@gmail.com>
In-Reply-To: <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
Date: Wed, 6 Jul 2016 15:39:18 +0300
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com> <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com> <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com> <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com> <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com> <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com> <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



ќтправлено с iPhone

> 6 июл€ 2016 г., в 15:14, Austin S. Hemmelgarn <ahferroin7@gmail.com> написал(а):
> 
>> On 2016-07-06 07:55, Andrei Borzenkov wrote:
>> On Wed, Jul 6, 2016 at 2:45 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2016-07-06 05:51, Andrei Borzenkov wrote:
>>>> 
>>>> On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com>
>>>> wrote:
>>>>> 
>>>>> I started a systemd-devel@ thread since that's where most udev stuff
>>>>> gets talked about.
>>>>> 
>>>>> 
>>>>> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
>>>> 
>>>> Before discussing how to implement it in systemd, we need to decide
>>>> what to implement. I.e.
>>>> 
>>>> 1) do you always want to mount filesystem in degraded mode if not
>>>> enough devices are present or only if explicit hint is given?
>>>> 2) do you want to restrict degrade handling to root only or to other
>>>> filesystems as well? Note that there could be more early boot
>>>> filesystems that absolutely need same treatment (enters separate
>>>> /usr), and there are also normal filesystems that may need be mounted
>>>> even degraded.
>>>> 3) can we query btrfs whether it is mountable in degraded mode?
>>>> according to documentation, "btrfs device ready" (which udev builtin
>>>> follows) checks "if it has ALL of itТs devices in cache for mounting".
>>>> This is required for proper systemd ordering of services.
>>> 
>>> 
>>> To be entirely honest, if it were me, I'd want systemd to fsck off.  If the
>>> kernel mount(2) call succeeds, then the filesystem was ready enough to
>>> mount, and if it doesn't, then it wasn't, end of story.
>> 
>> How should user space know when to try mount? What user space is
>> supposed to do during boot if mount fails? Do you suggest
>> 
>> while true; do
>>  mount /dev/foo && exit 0
>> done
>> 
>> as part of startup sequence? And note that nowhere is systemd involved so far.
> Nowhere there, except if you have a filesystem in fstab (or a mount unit, which I hate for other reasons that I will not go into right now), and you mount it and systemd thinks the device isn't ready, it unmounts it _immediately_.  In the case of boot, it's because of systemd thinking the device isn't ready that you can't mount degraded with a missing device.  In the case of the root filesystem at least, the initramfs is expected to handle this, and most of them do poll in some way, or have other methods of determining this.  I occasionally have issues with it with dracut without systemd, but that's due to a separate bug there involving the device mapper.
> 

How this systemd bashing answers my question - how user space knows when it can call mount at startup?


>> 
>>> The whole concept
>>> of trying to track in userspace something the kernel itself tracks and knows
>>> a whole lot more about is absolutely stupid.
>> 
>> It need not be user space. If kernel notifies user space when
>> filesystem is mountable, problem solved. It could be udev event,
>> netlink, whatever. Until kernel does it, user space need to either
>> poll or somehow track it based on available events.
> THis I agree could be done better, but it absolutely should not be in userspace, the notification needs to come from the kernel, but that leads to the problem of knowing whether or not the FS can mount degraded, or only ro, or any number of other situations.
>> 
>>> It makes some sense when
>>> dealing with LVM or MD, because that is potentially a security issue
>>> (someone could inject a bogus device node that you then mount instead of
>>> your desired target),
>> 
>> I do not understand it at all. MD and LVM has exactly the same problem
>> - they need to know when they can assemble MD/VG. I miss what it has
>> to do with security, sorry.
> If you don't track whether or not the device is assembled, then someone could create an arbitrary device node with the same name and then get you to mount that, possibly causing all kinds of issues depending on any number of other factors.

Device node is created as soon as array is seen for the first time. If you imply someone may replace it, what prevents doing it at any arbitrary time in the future?

>> 
>>> but it makes no sense here, because there's no way to
>>> prevent the equivalent from happening in BTRFS.
>>> 
>>> As far as the udev rules, I'm pretty certain that _we_ ship those with
>>> btrfs-progs,
>> 
>> No, you do not. You ship rule to rename devices to be more
>> "user-friendly". But the rule in question has always been part of
>> udev.
> Ah, you're right, I was mistaken about this.
>> 
>>> I have no idea why they're packaged with udev in CentOS (oh
>>> wait, I bet they package every single possible udev rule in that package
>>> just in case, don't they?).
> 
