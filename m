Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45183 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbKLFHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 00:07:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zwk6s-0003fx-G0
	for linux-btrfs@vger.kernel.org; Thu, 12 Nov 2015 06:07:46 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 06:07:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 06:07:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Potential to loose data in case of disk failure
Date: Thu, 12 Nov 2015 05:07:41 +0000 (UTC)
Message-ID: <pan$7387e$355c1b46$cb8e309e$12e649f4@cox.net>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
	<CAJCQCtTCzCOfdrvjNF2rs_VuHqVA4nU3jsgxKpkADd-+v7GtMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 11 Nov 2015 18:13:22 -0500 as excerpted:

> On Wed, Nov 11, 2015 at 12:30 PM, Jim Murphy <srlinuxadmin@gmail.com>
> wrote:
>> Hi all,
>>
>> What am I missing or misunderstanding?  I have a newly purchased laptop
>> I want/need to multi boot different OSs on.  As a result after
>> partitioning I have ended up with two partitions on each of the two
>> internal drives(sda3, sda8, sdb3 and sdb8).  FWIW, sda3 and sdb3 are
>> the same size and sda8 and sdb8 are the same size.  As an end result I
>> want one btrfs raid1 filesystem.  For lack of better terms,
>> sda3 and sda8 "concatenated" together, sdb3 and sdb8 "concatenated"
>> together and then mirroring "sda" to "sdb" using only btrfs.  So far
>> have found no use-case to cover this.

There isn't any... using ONLY btrfs (as the OP specified).  You need 
either mdraid or lvm to concatenate the two logical devices (partitions) 
on a single physical device into one, so then btrfs will see only two 
devices and put a raid1 copy on each.

This is because (reordering a bit of your quote from further below)...

> btrfs works strictly at the block device level, and considers different
> partitions different block devices, it doesn't grok the underlying
> physical device relationship.

[end of reordered bit]

> I'm going to assume that mkfs.btrfs -mraid1 -draid1 command is pointed
> at the two resulting /dev/mapper/X devices resulting from the linear
> concat.

Except, under the conditions he specified, there will be no such linear 
concat mapper device available.

>> If I create a raid1 btrfs volume using all 4 "devices" as I understand
>> it I would loose data if I were to loose a drive because two mirror
>> possibilities would be:
>>
>> sda3 mirrored to sda8 sdb3 mirrored to sdb8
> 
> Well you don't actually know how the mirroring will allocate is the
> problem with the arrangement. But yes, it's possible some chunks on sda3
> will be mirrored to sda8, which is not what you'd want so the linear
> concat idea is fine using either the md driver or lvm.
> 
>> Is what I want to do possible without using MD-RAID and/or LVM?
> 
> Yes, either are suitable for this purpose. The decision comes down to
> the user space tools, use the tool that you're most comfortable with.

It's not possible /without/ using them, no.  Using them, yes, but that's 
not the question that was asked.


As for the explanation, that's the part that I reordered above, btrfs 
only sees block devices.  It doesn't know nor care what they're from.


One workaround would be as Sean Greenslade's, using either a partitioning 
tool that can safely move partitions around without destroying the data 
in them, or simply copying off to backup, deleting the partitions and 
recreating them in a more workable layout, then restoring from backup to 
the new partitions, combining the two partitions on each physical device 
into one.

Another workaround would be putting btrfs on top of an mdraid or lvm 
setup as above, thereby using software to overcome the hardware layout 
limitations.

Yet another, the one I'd almost certainly use here unless the use-case 
made it too inconvenient or not even possible (one big file too big for 
either one alone), would be to simply create two entirely separate btrfs 
raid1 filesystems, each one composed of the two partitions of similar 
size.  I'm already a strong booster of using partitioning to avoid 
putting all my data eggs in one basket, and already use multiple separate 
btrfs raid1s on partitions of the same two physical devices, here, so 
this wouldn't even be beyond what I'm already doing, here.  And if the 
OP's already dealing with that many partitions, it sounds like he'd be 
able to handle it fairly well too.  After all there's always symlinks and 
bind-mounts available to make parts of one filesystem available in 
arbitrary locations on another, if the location of the directories 
themselves is hard-coded to such an extent that you can't simply move 
them and point everything that was pointed at the old location to the new 
one, instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

