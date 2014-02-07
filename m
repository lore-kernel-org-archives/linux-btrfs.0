Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51129 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBGUdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 15:33:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBs6j-00054s-Bb
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 21:33:05 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 21:33:05 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 21:33:05 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Fri, 07 Feb 2014 21:32:42 +0100
Message-ID: <agsfsa-mks.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fb.com> schrieb:

> 
> On 02/05/2014 03:15 PM, Roman Mamedov wrote:
>> Hello,
>>
>> On a freshly-created RAID1 filesystem of two 1TB disks:
>>
>> # df -h /mnt/p2/
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2
>>
>> I cannot write 2TB of user data to that RAID1, so this estimate is
>> clearly misleading. I got tired of looking at the bogus disk free space
>> on all my RAID1 btrfs systems, so today I decided to do something about
>> this:
>>
>> --- fs/btrfs/super.c.orig	2014-02-06 01:28:36.636164982 +0600
>> +++ fs/btrfs/super.c	2014-02-06 01:28:58.304164370 +0600
>> @@ -1481,6 +1481,11 @@
>>   }
>>   
>>   kfree(devices_info);
>> +
>> +	if (type & BTRFS_BLOCK_GROUP_RAID1) {
>> +		do_div(avail_space, min_stripes);
>> +	}
>> +
>>   *free_bytes = avail_space;
>>   return 0;
>>   }
> 
> This needs to be more flexible, and also this causes the problem where
> now you show the actual usable amount of space _but_ you are also
> showing twice the amount of used space.  I'm ok with going in this
> direction, but we need to convert everybody over so it works for raid10
> as well and the used values need to be adjusted.  Thanks,

It should show the raw space available. Btrfs also supports compression and 
doesn't try to be smart about how much compressed data would fit in the free 
space of the drive. If one is using RAID1, it's supposed to fill up with a 
rate of 2:1. If one is using compression, it's supposed to fill up with a 
rate of maybe 1:5 for mostly text files.

However, btrfs should probably provide its own df utility (like "btrfs fi 
df") which is smart about disk usage and tries to predict the usable space. 
But df should stay with actually showing the _free_ space, not _usable_ 
space (the latter is unpredictable anyway based on the usage patterns 
applied to the drive, so it can be a rough guess as its best, like looking 
into the crystal ball).

The point here is about "free" vs. "usable" space, the first being a known 
number, the latter only being a prediction based on current usage. I'd like 
to stay with "free space" actually showing raw free space.

-- 
Replies to list only preferred.

