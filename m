Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab3CIORH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 09:17:07 -0500
Message-ID: <513B4460.5090607@redhat.com>
Date: Sat, 09 Mar 2013 08:17:04 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] use rcu_barrier() to wait for bdev puts at unmount
References: <513AC735.1090500@redhat.com> <20130309122710.GA15521@shiny.masoncoding.com>
In-Reply-To: <20130309122710.GA15521@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/9/13 6:27 AM, Chris Mason wrote:
> On Fri, Mar 08, 2013 at 10:23:01PM -0700, Eric Sandeen wrote:
>> Doing this would reliably fail with -EBUSY for me:
>>
>> # mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
>> ...
>> unable to open /dev/sdb2: Device or resource busy
>>
>> because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.
>>
>> Using systemtap to track bdev gets & puts shows a kworker thread doing a
>> blkdev put after mkfs attempts a get; this is left over from the unmount.
>>
>> Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
>> until all blkdev_put()s are done, and the device is truly free once
>> unmount completes.
> 
> Thanks for tracking this down Eric.  

Sure thing, sorry it took so long.

> Is this kworker triggered by btrfs
> or is this something we should be doing for the other filesystems too?

It's all btrfs ;)

btrfs_close_devices
	__btrfs_close_devices
		call_rcu(&device->rcu, free_device);
			free_device
				INIT_WORK(&device->rcu_work, __free_device);
				schedule_work(&device->rcu_work);


The behavior came from:

commit 1f78160ce1b1b8e657e2248118c4d91f881763f0
Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date:   Wed Apr 20 10:09:16 2011 +0000

    Btrfs: using rcu lock in the reader side of devices list

Anyway, I can send V2 in close_ctree if you like. Thinking about it more
though, btrfs_close_devices is closer to the action, so now I think
I'd leave it there. :)

I probably should have put a comment in to say what the heck it's for,
too.  Feel free to fix on merge or I can send another patch.

Thanks,
-Eric


> I'd move it down to close_ctree, but I don't really have a good reason.
> 
> -chris
> 

