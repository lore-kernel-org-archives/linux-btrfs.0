Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50844 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaEa4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 23:30:56 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYQ5f-0000jO-Bi
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 05:30:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs recovery
Date: Tue, 31 Jan 2017 04:30:41 +0000 (UTC)
Message-ID: <pan$99dce$133426d5$ab6dac5$a744519@cox.net>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
        <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
        <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Born posted on Mon, 30 Jan 2017 22:07:00 +0100 as excerpted:

> Am 30.01.2017 um 21:51 schrieb Chris Murphy:
>> On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de>
>> wrote:
>>> Hi btrfs experts.
>>>
>>> Hereby I apply for the stupidity of the month award.
>> 
>> There's still another day :-D
>> 
>> 
>>> Before switching from Suse 13.2 to 42.2, I copied my / partition with
>>> dd to an image file - while the system was online/running.
>>> Now, I can't mount the image.
>> 
>> That won't ever work for any file system. It must be unmounted.
> 
> I could mount and copy the data out of my /home image.dd (encrypted
> xfs). That was also online while dd-ing it.

There's another angle with btrfs that makes block device image copies 
such as that a big problem, even if the dd was done with the filesystem 
unmounted.  This hasn't yet been mentioned in this thread, that I've 
seen, anyway.

* Btrfs takes the filesystem UUID, universally unique ID, at face value, 
considering it *UNIQUE* and actually identifying the various components 
of a possibly multi-device filesystem by the UUID.  Again, this is 
because btrfs, unlike normal filesystems, can be composed of multiple 
devices, so btrfs needs a way to detect what devices form parts of what 
filesystems, and it does this by tracking the UUID and considering 
anything with that UUID (which is supposed to be unique to that 
filesystem, remember, it actually _says_ "unique" in the label, after 
all) to be part of that filesystem.

Now you dd the block device somewhere else, making another copy, and 
btrfs suddenly has more devices that have UUIDs saying they belong to 
this filesystem than it should!

That has actually triggered corruption in some cases, because btrfs gets 
mixed up and writes changes to the wrong device, because after all, it 
*HAS* to be part of the same filesystem, because it has the same 
universally *unique* ID.

Only the supposedly "unique" ID isn't so "unique" any more, because 
someone copied the block device, and now there's two copies of the 
filesystem claiming to be the same one!  "Unique" is no longer "unique" 
and it has created the all too predictable problems as a result.


There are ways to work around the problem.  Basically, don't let btrfs 
see both copies at the same time, and *definitely* don't let it see both 
copies when one is mounted or an attempt is being made to mount it.

(Btrfs "sees" a new device when btrfs device scan is run.  Unfortunately 
for this case, udev tends to run btrfs device scan automatically whenever 
it detects a new device that seems to have btrfs on it.  So it can be 
rather difficult to keep btrfs from seeing it, because udev tends to 
monitor for new devices and see it right away, and tell btrfs about it 
when it does.  But it's possible to avoid damage if you're careful to 
only dd the unmounted filesystem device(s) and to safely hide one copy 
before attempting to mount the other.)


Of course that wasn't the case here.  With the dd of a live-mounted btrfs 
device, it's quite possible that btrfs detected and started writing to 
the dd-destination device instead of the original at some point, screwing 
things up even more than they would have been for a normal filesystem 
live-mounted dd.

In turn, it's quite possible that's why the old xfs /home still mounted, 
but the btrfs / didn't, because the xfs, while potentially damaged a bit, 
didn't suffer the abuse of writes to the wrong device that btrfs may well 
have suffered, due to the non-uniqueness of the supposedly universally 
unique IDs and the very confused btrfs that may well have caused.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

