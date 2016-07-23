Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbcGWP2v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 11:28:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bQyqu-0007oa-Mg
	for linux-btrfs@vger.kernel.org; Sat, 23 Jul 2016 17:28:33 +0200
Received: from 64.134.221.72 ([64.134.221.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 17:28:32 +0200
Received: from 1i5t5.duncan by 64.134.221.72 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 17:28:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Chances to recover with bad partition table?
Date: Sat, 23 Jul 2016 15:28:26 +0000 (UTC)
Message-ID: <pan$6f31c$e8a5bbc9$8a00e0e5$4ed13265@cox.net>
References: <14e0b114-5c5b-77f6-2c10-cad5eb799f28@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Sat, 23 Jul 2016 13:15:50 +0200 as excerpted:

> this morning I had to face an unusual prompt on my machine.
> 
> I found that the partition table of /dev/sda had vanished.
> 
> I restored it with testdisk. It found one partition, but I am quite sure
> there was a /boot partition in front of that which was not found.
> 
> Now, running btrfsck fails:
> 
> root@homeserver:~# fdisk -l /dev/sda
> 
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
> fdisk doesn't support GPT. Use GNU Parted.

There are two partition types in common usage on x86, the older MBR type 
and the newer GPT type, which you're running.  As it says, fdisk doesn't 
support the latter well, tho it does warn about it (and I think new 
fdisk /might/ actually support it, but if so you're not using new enough, 
obviously).

But you're in luck, because gpt stores a second copy of the partition 
table at the /end/ of the device, as well as the primary copy at the 
beginning, and good gpt tools will be able to restore the primary copy 
from the secondary one.

Try gdisk, aka gptfdisk.  It both supports gpt partition tables and has 
functionality that allows you to restore the primary from the secondary 
as above.  It has a good manpage, and there's more info about it on the 
home page as well.

http://www.rodsbooks.com/gdisk/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

