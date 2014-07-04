Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaGDLVx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 07:21:53 -0400
Message-ID: <53B68E42.1050109@oracle.com>
Date: Fri, 04 Jul 2014 19:21:38 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] btrfs: fix null pointer dereference in clone_fs_devices
 when name is null
References: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com> <53B135B2.5060405@cn.fujitsu.com> <53B17D0E.2050302@oracle.com> <53B370A7.6050108@cn.fujitsu.com>
In-Reply-To: <53B370A7.6050108@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Miao, Chris,

I appreciate your review comments, Miao. I am sorry for the delay,
was stuck on this issue for a long time. more below.

On 02/07/2014 10:38, Miao Xie wrote:
> On Mon, 30 Jun 2014 23:06:54 +0800, Anand Jain wrote:
>>
>>> The primary reason of this problem is that we didn't scan the system and
>>> find all the devices in the filesystem, if we scan the system, we can
>>> mount the filesystem successfully, needn't mount it with degraded option.
>>> so I think the right way to fix is to scan the system and find the device
>>> that is not registered into the fs device list.
>>
>> Thanks for commenting. Right. But I am testing the error
>> scenario. that is, when one of the disk is missing in the system.
>
> In fact, the disk is still in the system, but is not added into btrfs device list
> (we can add it by "btrfs device scan" command), and after you mount the fs with
> degraded option, the fs adds that disk as a missing device, so it doesn't has its
> name.

Correct.

> Though avoiding access a null pointer is right,

  yes. that would tightly plug the problem demonstrated in the reproducer
  with minimal changes.

> you didn't consider the missing
> device and forgot to set the missing device counter. I think the following code
> is better.
>
> if (orig_dev->missing) {
> 	device->missing = 1;
> 	fs_devices->missing_devices++;
> } else {
> 	ASSERT(orig_dev->name);
> 	......
> }

  Yes we need to associate the device->missing flag and
  device->name==NULL together, not just here but at quite a number of
  functions. As such there is no code which would mark
  device missing after its being mounted (there were some patch
  but those are yet to be reviewed).

  So for now this patch will address problem as in the reproducer.
  BUT BUT it would enable sections of code (with new parameters) which
  was _never_ run before due to this bug. That is in the following
  scenario..
    - A mounted (missing) degraded seed btrfs FS.
    - Add a seed disk.
    - For seeding purpose we would "clone a degraded seed FS".
      (before this patch - the code will panic here so rest of the
       code was never run).

  I have very intermittent null pointer deference issue as the code
  runs further, (with or without Miao suggested), more precisely at

  btrfs_run_dev_stats()
::
   list_for_each_entry(device, &fs_devices->devices, dev_list) the list

  device is NULL.

  looks like its time to comprehensively handle the missing device.

  So as of now NACK for this patch. Very Sorry.

Thanks, Anand

> Thanks
> Miao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
