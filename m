Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33114 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcGGT7J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 15:59:09 -0400
Received: by mail-io0-f173.google.com with SMTP id t74so31559425ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 12:59:08 -0700 (PDT)
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
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
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
 <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e6f35e35-f2bd-03f6-5544-4fb8fa527042@gmail.com>
Date: Thu, 7 Jul 2016 15:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 14:58, Chris Murphy wrote:
> On Thu, Jul 7, 2016 at 12:23 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>>
>> Here's how I would picture the ideal situation:
>> * A device is processed by udev.  It detects that it's part of a BTRFS
>> array, updates blkid and whatever else in userspace with this info, and then
>> stops without telling the kernel.
>> * The kernel tracks devices until the filesystem they are part of is
>> unmounted, or a mount of that FS fails.
>> * When the user goes to mount the a BTRFS filesystem, they use a mount
>> helper.
>>   1. This helper queries udev/blkid/whatever to see which devices are part
>> of an array.
>>   2. Once the helper determines which devices are potentially in the
>> requested FS, it checks the following things to ensure array integrity:
>>     - Does each device report the same number of component devices for the
>> array?
>>     - Does the reported number match the number of devices found?
>>     - If a mount by UUID is requested, do all the labels match on each
>> device?
>>     - If a mount by LABEL is requested, do all the UUID's match on each
>> device?
>>     - If a mount by path is requested, do all the component devices reported
>> by that device have matching LABEL _and_ UUID?
>>     - Is any of the devices found already in-use by another mount?
>>   4. If any of the above checks fails, and the user has not specified an
>> option to request a mount anyway, report the error and exit with non-zero
>> status _before_ even talking to the kernel.
>>   5. If only the second check fails (the check verifying the number of
>> devices found), and it fails because the number found is less than required
>> for a non-degraded mount, ignore that check if and only if the user
>> specified -o degraded.
>>   6. If any of the other checks fail, ignore them if and only if the user
>> asks to ignore that specific check.
>>   7. Otherwise, notify the kernel about the devices and call mount(2).
>> * The mount helper parses it's own set of special options similar to the
>> bg/fg/retry options used by mount.nfs to allow for timeouts when mounting,
>> as well as asynchronous mounts in the background.
>> * btrfs device scan becomes a no-op
>> * btrfs device ready uses the above logic minus step 7 to determine if a
>> filesystem is probably ready.
>>
>> Such a situation would probably eliminate or at least reduce most of our
>> current issues with device discovery, and provide much better error
>> reporting and general flexibility.
>
> It might be useful to see where ZFS and LVM work and fail in this
> regard. And also plan for D-Bus support to get state notifications up
> to something like storaged or other such user space management tools.
> Early on in Fedora there were many difficulties between systemd and
> LVM, so avoiding whatever that was about would be nice.
D-Bus support needs to be optional, period.  Not everybody uses D-Bus (I 
have dozens of systems that get by just fine without it, and know 
hundreds of other people who do as well), and even people who do don't 
always use every tool needed (on the one system I manage that does have 
it, the only things I need it for are Avahi, ConsoleKit, udev, and 
NetworkManager, and I'm getting pretty close to the point of getting rid 
of NM and CK and re-implementing or forking Avahi).  You have to 
consider the fact that there are and always will be people who do not 
install a GUI on their system and want the absolute minimum of software 
installed.
>
> Also, tangentially related, Fedora is replacing udisks2 with storaged.
> Storaged already has a Btrfs plug-in so there should be better
> awareness there. I get all kinds of damn strange behaviors in GNOME
> with Btrfs multiple device volumes: volume names appearing twice in
> the UI, unmounting one causes umount errors with the other.
> https://fedoraproject.org/wiki/Changes/Replace_UDisks2_by_Storaged
> http://storaged.org/
Personally, I don't care what Fedora is doing, or even what GNOME (or 
any other DE for that matter, the only reason I use Xfce is because some 
things need a GUI (many of them unnecessarily), and that happens to be 
the DE I have the fewest complaints about) is doing.  The only reason 
that things like GNOME Disks and such exist is because they're trying to 
imitate Windows and OS X, which is all well and good for a desktop, but 
is absolute crap for many server and embedded environments (Microsoft 
finally realized this, and Windows Server 2012 added the ability to 
install without a full desktop, which actually means that they have 
_more_ options than a number of Linux distributions (yes you can rip out 
the desktop on many distros if you want, but that takes an insane amount 
of effort most of the time, not to mention storage space)).

Storaged also qualifies as something that _needs_ to be optional, 
especially because it appears to require systemd (and it falls into the 
same category as D-Bus of 'unnecessary bloat on many systems').  Adding 
a mandatory dependency on systemd _will_ split the community and 
severely piss off quite a few people (you will likely get some rather 
nasty looks from a number of senior kernel developers if you meet them 
in person).
