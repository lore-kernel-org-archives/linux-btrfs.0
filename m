Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38710 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbbJUTOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 15:14:11 -0400
Received: by igbdj2 with SMTP id dj2so44789395igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 12:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU437-SMTP66AE7103C3A5471C154844A9390@phx.gbl>
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
	<pan$55e2$eeada9c5$c7289131$4f093ca1@cox.net>
	<CAM9fjH6pcwZKWryNrJay_N98wmXWVXXqo3HJuupbJRE3MC9YKQ@mail.gmail.com>
	<BLU436-SMTP11853633E0AF118E66934D6A9390@phx.gbl>
	<BLU437-SMTP66AE7103C3A5471C154844A9390@phx.gbl>
Date: Wed, 21 Oct 2015 12:14:10 -0700
Message-ID: <CAM9fjH7WYUZHd4cZYB+cyT-4QBpx8oikJ-N27ymWDrbQfgiW4w@mail.gmail.com>
Subject: Re: How to remove missing device on RAID1?
From: Kyle Manna <2bluesc@gmail.com>
To: Henk Slager <hslager@hotmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Henk,

This trick/hack worked great for me.  After the rebalance was
complete, a sparse file + loop device, `btrfs replace` and `btrfs
delete` worked as expected.  Thanks.

In other news, I did hit a btrfs bug 3 times while attempting to
balance.  I've added my comments @
https://bugzilla.kernel.org/show_bug.cgi?id=105681#c14
ᐧ

On Tue, Oct 20, 2015 at 3:46 PM, Henk Slager <hslager@hotmail.com> wrote:
> copy-paste error corrected
> On Wed, Oct 21, 2015 at 12:40 AM, Henk Slager <hslager@hotmail.com> wrote:
>> I had a similar issue some time ago, around the time kernel 4.1.6 was
>> just there.
>> In case you don't want to wait for new disk or decide to just run the
>> filesystem with 1 disk less or maybe later on replace 1 of the still
>> healthy disks with a double/bigger sized one and use current/older
>> kernel+tools, you could do this (assuming the filesystem is not too
>> full of course):
>> - mount degraded
> - btrfs balance start -f -v -sdevid=1 -mdevid=1 -mdevid=1 <mountpoint>
>>   (where missing disk has devid 1)
>> After completion the (virtual/missing) device shall be fully unallocated
>> - create /dev/loopX with sparse file of same size as missing disk on
>> some other filesystem
>> - btrfs replace start 1 /dev/loopX <mountpoint>
>> - remove /dev/loopX from the filesystem
>> - remount filesystyem without degraded
>> And remove /dev/loopX
>>
>>
>> On Tue, Oct 20, 2015 at 11:48 PM, Kyle Manna <2bluesc@gmail.com> wrote:
>>> Thanks for the follow-up Duncan, that makes sense.  I assumed I was
>>> doing something wrong.
>>>
>>> I downloaded the devel branch of of btrfs-progs and got it running
>>> before I saw the need for a kernel patch and decided to wait.
>>>
>>> For anyone following this later, I needed to use the following to get
>>> the missing device ID:
>>>
>>> btrfs device usage <path>
>>> ᐧ
>>>
>>> On Tue, Oct 20, 2015 at 1:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>> Kyle Manna posted on Tue, 20 Oct 2015 10:24:48 -0700 as excerpted:
>>>>
>>>>> Hi all,
>>>>>
>>>>> I have a collection of three (was 4) 1-2TB devices with data and
>>>>> metadata in a RAID1 mirror.  Last night I was struck by the Click of
>>>>> Death on an old Samsung drive.
>>>>>
>>>>> I removed the device from the system, rebooted and mounted the volume
>>>>> with `-o degraded` and the file system seems fine and usable.  I'm
>>>>> waiting on a replacement, drive but want to remove the old drive and
>>>>> re-balance in the meantime.
>>>>>
>>>>> How do I remove the missing device?  I tried the `btrfs device delete
>>>>> missing /mnt` but was greeted with "ERROR: missing is not a block
>>>>> device".  A quick look at that btrfs-progs git repo shows that
>>>>> `stat("missing")` is called, which of course fails since missing isn't a
>>>>> block device.  Nothing other then `btrfs replace` seemed intuitive and
>>>>> all the docs mention the older command.  What's the move?
>>>>>
>>>>> Thanks!
>>>>> - Kyle
>>>>>
>>>>> Versions:
>>>>> Kernel: 4.2.3-1-ARCH
>>>>> btrfs-progs: 4.2.2-1 ᐧ
>>>>
>>>> I believe the current advice given here (that you were likely trying to
>>>> follow, wrapped link)...
>>>>
>>>> https://btrfs.wiki.kernel.org/index.php/
>>>> Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
>>>>
>>>> ... is dated and no longer works due to code change some time in the past.
>>>>
>>>> There's a set of (very) recent patches, to the kernel and userspace both
>>>> (I just updated userspace and it's in the git devel-branch v4.2.3-49-
>>>> g4db87a1 I just built, kernelspace, I don't see it in linus-mainline yet,
>>>> so I'd guess it's in the btrfs-integration patches, to land in the v4.4
>>>> commit window if not in 4.3 as it's getting late in the cycle for that.
>>>>
>>>> btrfs fi show <path>
>>>>
>>>> That will list the btrfs component devices together with their devids.
>>>>
>>>> Then use the appropriate devid like so:
>>>>
>>>> btrfs dev del <devid> <path>
>>>>
>>>> The -progs commit is d462081f, by Anand Jain, titled:
>>>>
>>>> btrfs-progs: Introduce device delete by devid
>>>>
>>>> According to it, the required kernel commit (title only listed) is
>>>> similar:
>>>>
>>>> Btrfs: Introduce device delete by devid
>>>>
>>>> You can probably find them on-list if you wish to cherry-pick them into a
>>>> current version.
>>>>
>>>> --
>>>> Duncan - List replies preferred.   No HTML msgs.
>>>> "Every nonfree program has a lord, a master --
>>>> and if you use the program, he is your master."  Richard Stallman
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
