Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39944 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaINAqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 20:46:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSxx3-0004Vs-A8
	for linux-btrfs@vger.kernel.org; Sun, 14 Sep 2014 02:46:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Sep 2014 02:46:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Sep 2014 02:46:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
Date: Sun, 14 Sep 2014 00:45:49 +0000 (UTC)
Message-ID: <pan$654be$d6b1d475$33035c3b$be242b8b@cox.net>
References: <20140911002241.201bc6c2@datenkhaos.de>
	<54110AEC.6040301@oracle.com> <54135AE7.40400@gmail.com>
	<5413D7E5.6080905@oracle.com> <20140913195525.333f93a4@datenkhaos.de>
	<20140913232320.64fd189c@datenkhaos.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Johannes Hirte posted on Sat, 13 Sep 2014 23:23:20 +0200 as excerpted:

> On Sat, 13 Sep 2014 19:55:25 +0200 Johannes Hirte
> <johannes.hirte@datenkhaos.de> wrote:
> 
>> On Sat, 13 Sep 2014 13:36:37 +0800 Anand Jain <Anand.Jain@oracle.com>
>> wrote:
>> 
>>> The quickest workaround for you will be to try to match
>>> the device path as in the btrfs fi show -m </mnt> output to your
>>> probably fstab/mnttab entry.
>> 
>> Doesn't work here. I don't even get a path with the affected kernels.
>> I'll get:
>> 
>> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>>         Total devices 1 FS bytes used 270.10GiB
>>         *** Some devices missing
>> 
>> Btrfs v3.16
>> 
>> with a working kernel:
>> 
>> Label: none  uuid: 02edbd6b-f044-4800-b21e-ca8982c2c2e5
>>         Total devices 1 FS bytes used 270.10GiB
>>         devid  1 size 293.89GiB used 289.06GiB path /dev/sda1
>> 
>> Btrfs v3.16

>> And now I was able to reproduce on a second machine. The main
>> difference between the affected and the unaffected systems is
>> initramfs. On the affected systems, I don't use one. On the working
>> systems, the rootfs is mounted via initramfs before. I'll test, if an
>> initramfs will solve the issue. Seems likely, cause if I put the disk
>> of an affected system into a working system and mount it there,
>> everything works.
> 
> Of course, with the initramfs it works.

I see a btrfs device scan in the initramfs script.  What happens if you 
simply run btrfs device scan manually, before doing btrfs filesystem show?

I'm guessing that'll fix it.

Explanation assuming it does: Without the scan and without an initr*, 
you're pointing the kernel directly at the single-device btrfs using the 
root= kernel commandline option and that works, but the kernel still 
doesn't really know what device it's dealing with until after a scan to 
tell it.

If that doesn't fix it, I'm guessing the same explanation, but for some 
reason the scan has to be run before the filesystem is mounted.  Thus 
running it from the initr* works, since it's before the real-root gets 
mounted, but running it directly from the mounted root after it's mounted 
using root= doesn't work, because it's already mounted by the time the 
scan is run.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

