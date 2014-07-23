Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59361 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750913AbaGWEDx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 00:03:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded, btrfs replace failure, then oops
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140723033649.GB4955@localhost.localdomain>
Date: Tue, 22 Jul 2014 22:03:50 -0600
Cc: Eric Sandeen <sandeen@redhat.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Message-Id: <3FD48392-BCCB-406F-B88F-147AA9B1FEB1@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com> <53CF235D.1040703@redhat.com> <FE022C52-674C-491B-AAC1-2A5B4576D8B3@colorremedies.com> <20140723033649.GB4955@localhost.localdomain>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 9:36 PM, Liu Bo <bo.li.liu@oracle.com> wrote:

> On Tue, Jul 22, 2014 at 09:28:52PM -0600, Chris Murphy wrote:
>> 
>> On Jul 22, 2014, at 8:52 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> 
>>> This one (your bug #4) was likely caused by:
>>> 
>>> commit 99994cde9c59c2b8bb67d46d531b26cc73e39747
>>> Author: Anand Jain <Anand.Jain@oracle.com>
>>> Date:   Tue Jun 3 11:36:00 2014 +0800
>>> 
>>>   btrfs: dev delete should remove sysfs entry
>>> 
>>> and hopefully fixed by:
>>> 
>>> commit 0bfaa9c5cb479cebc24979b384374fe47500b4c9
>>> Author: Eric Sandeen <sandeen@redhat.com>
>>> Date:   Mon Jul 7 12:34:49 2014 -0500
>>> 
>>>   btrfs: test for valid bdev before kobj removal in btrfs_rm_device
>> 
>> OK good. Hopefully the first one is reverted or the second one is accepted before 3.16 is released, replace appears to be broken at the moment.
>> 
> 
> Looks that they are not the same one, since you didn't use a btrfs_rm_device,
> 
> As we just skip adding a sysfs entry for a missing device(dev->bdev is NULL), we
> can do the same thing in removing a sysfs entry, could you please try this?

Normally yes, but not for a couple weeks this time. 

While replace cancel worked, and balance conversion back to single profile worked, I forgot to immediately device delete missing, and instead I rebooted. Now I can't mount degraded, and I run into this old bug:

[   71.064352] BTRFS info (device sdb): allowing degraded mounts
[   71.064812] BTRFS info (device sdb): enabling auto recovery
[   71.065210] BTRFS info (device sdb): disk space caching is enabled
[   71.072068] BTRFS warning (device sdb): devid 2 missing
[   71.097320] BTRFS: too many missing devices, writeable mount is not allowed
[   71.116616] BTRFS: open_ctree failed

Since I can't mount degraded rw I can't make read-only snapshots, and can't btrfs send receive the subvolumes, so this setup will need to be replaced. Not a big deal, just time, but maybe someone else can test it sooner than me.


Chris Murphy