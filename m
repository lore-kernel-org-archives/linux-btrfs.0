Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34888 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdIKVe0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:34:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1drWLE-0003Yp-7Q
        for linux-btrfs@vger.kernel.org; Mon, 11 Sep 2017 23:34:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Please help with exact actions for raid1 hot-swap
Date: Mon, 11 Sep 2017 21:33:37 +0000 (UTC)
Message-ID: <pan$ede39$9eefb5ae$db7f6b30$6ff19121@cox.net>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
        <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
        <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
        <bfaeaf8d-609d-924b-7389-b6c8733745a9@rqc.ru>
        <9f53f866-bb99-72dd-7419-0728147732b0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 11 Sep 2017 11:11:01 -0400 as
excerpted:

> On 2017-09-11 09:16, Marat Khalili wrote:
>> Patrik, Duncan, thank you for the help. The `btrfs replace start
>> /dev/sdb7 /dev/sdd7 /mnt/data` worked without a hitch (though I didn't
>> try to reboot yet, still have grub/efi/several mdadm partitions to
>> copy).

>> Does this mean:
>> * I should not be afraid to reboot and find /dev/sdb7 mounted again?
>> * I will not be able to easily mount /dev/sdb7 on a different computer
>> to do some tests?
> This depends.  I don't remember if the replace command wipes the
> super-block on the old device after the replace completes or not.

AFAIK it does.

> If it
> does not, then you can't safely mount the filesystem while that device
> is still in the system, but can transfer it to another system and mount
> it degraded (probably, not a certainty).

It's worth noting that while this shouldn't be a problem here (because 
the magic should be gone), the problem does appear in other contexts.  In 
particular, any context that does device duplication is a problem.

This means dd-ing the content of a device to another device is a problem, 
because once btrfs device scan is triggered (and udev can trigger it 
automatically/unexpectedly), btrfs will see the second device and 
consider it part of the same filesystem as the first, causing problems if 
either one is mounted.

dd-ing to a file tends to be less of a problem, because it's just a file 
until activated as a loopback device, and that doesn't tend to happen 
automatically.

Similarly, lvm's device mirroring modes can be problematic, with udev 
again sometimes unexpectedly triggering btrfs device scan on device 
appearance, unless measures are taken to hide the new device.  I tried 
lvm some time ago and decided I didn't find it useful for my on use-
cases, so I don't know the details here, in particular, I'm not sure of 
the device hiding options, but there have certainly been threads on the 
list discussing the problem and the option to hide the device to prevent 
it came up in one of them.

> if it does, then you can
> safely keep the device in the system, but won't be able to move it to
> another computer and get data off of it.

This should be the case.  Tho it may be as simple as restoring the btrfs 
magic in the superblock to restore it to mountability, but I believe the 
replace process deletes chunks as they are transfered, so actually 
getting data off it may be more complicated than simply making it 
mountable again.

> Regardless of which is the
> case, you won't see /dev/sdb7 mounted as a separate filesystem when you
> reboot.

>> Also, although /dev/sdd7 is much larger than /dev/sdb7 was, `btrfs fi
>> show` still displays it as 2.71TiB, why?

> `btrfs replace` is functionally equivalent to using dd to copy the
> contents of the device being replaced to the new device, albeit a bit
> smarter (as mentioned above).  This means in particular that it does not
> resize the filesystem (although i think I saw some discussion and
> possibly patches to handle that with a command-line option).

This is documented.  From the btrfs-replace manpage (from btrfs-progs 
4.12, reformatted a bit here for posting):

>>>>>>

The <targetdev> needs to be same size or larger than the <srcdev>.

Note:
The filesystem has to be resized to fully take advantage of a larger 
target device, this can be achieved with

btrfs filesystem resize <devid>:max /path

<<<<<<

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

