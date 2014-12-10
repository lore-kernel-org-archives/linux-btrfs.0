Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaLJNVn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:21:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyhD4-0005GY-K0
	for linux-btrfs@vger.kernel.org; Wed, 10 Dec 2014 14:21:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 14:21:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 14:21:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
Date: Wed, 10 Dec 2014 13:21:22 +0000 (UTC)
Message-ID: <pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com>
	<54882634.4000809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 10 Dec 2014 02:53:40 -0800 as excerpted:

> On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
>> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>>> Hi Dongsheng On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>>> When function btrfs_statfs() calculate the tatol size of fs, it is
>>>> calculating the total size of disks and then dividing it by a factor.
>>>> But in some usecase, the result is not good to user.
>>>>
>>>> Example:
>>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>>     # mount /dev/vdf1 /mnt
>>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>>     # df -h /mnt
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>>
>>>>     # btrfs fi show /dev/vdf1
>>>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>>>>     Total devices 2 FS bytes used 1001.53MiB
>>>>     devid    1 size 2.00GiB  used 1.85GiB path /dev/vdf1
>>>>     devid    2 size 4.00GiB  used 1.83GiB path /dev/vdf2
>>>>
>>>> a. df -h should report Size as 2GiB rather than as 3GiB.
>>>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>>> I agree
> 
> NOPE.
> 
> The model you propose is too simple.
> 
> While the data portion of the file system is set to RAID1 the metadata
> portion of the filesystem is still set to the default of DUP.

Metadata defaults to DUP only on a single-device filesystem.  On a multi-
device filesystem, metadata defaults to raid1.  (FWIW, for both, data 
defaults to single.)

And in the example, the mkfs was supplied with two devices, so there's no 
dup metadata remaining from a formerly single-device filesystem, either.  
(Tho there will be the small single-mode stubs, empty, remaining from the 
mkfs process, as no balance has been run to delete them yet, but those 
are much smaller and empty.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

