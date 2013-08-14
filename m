Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:55543 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758089Ab3HNBRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 21:17:49 -0400
Message-ID: <520ADABB.4010304@parallels.com>
Date: Wed, 14 Aug 2013 10:17:47 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache is running on each reboot
References: <52098BDB.5010400@parallels.com> <20130813153719.GH2150@localhost.localdomain>
In-Reply-To: <20130813153719.GH2150@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2013 12:37 AM, Josef Bacik wrote:
> On Tue, Aug 13, 2013 at 10:28:59AM +0900, dima wrote:
>> Hello all,
>>
>> About a week or so ago I noticed that [btrfs-ino-cache] process was
>> appearing in the 'top' on each reboot and disk is spinning like crazy for
>> about five minutes or so. Quite so often this caused X failing to start
>> because all I/O was busy with caching.
>> Even after letting it to calm down and seeing [btrfs-ino-cache] disappearing
>> from the process list, on next reboot it starts all over again.
>>
>> Here is the fstab entry that I have
>>
>> UUID=430dca92-9541-4201-0f62-373e30beadac / btrfs subvol=root_subvolume,defaults,noatime,noacl,compress=lzo,inode_cache,space_cache,autodefrag
>> 0 0
>>
>> inode_cache was always enabled since the FS was created about a year or so
>> ago, and actually I have never had any problems with it up until recently.
>>
>> Removing inode_cache option from fstab solves the problem, but I am not sure
>> if it is the right choice.
>> I can observe the problem at least in the vanilla kernel 3.10.4 ~ 6 (did not
>> try older versions)
>>
>> What could be the reason for such behavior and how to avoid it?
>>
>
> That's odd.  Can you apply patches and build kernels so I can try and narrow
> down what is happening?  Thanks,
>
> Josef
>

Hi Josef,
Sure, I can do that. I am running archlinux with a vanilla kernel that I 
build myself.
Thanks
