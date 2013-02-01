Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3BAF4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 00:56:06 -0500
Message-ID: <510B5912.7000908@cn.fujitsu.com>
Date: Fri, 01 Feb 2013 13:56:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: serialize unlocked dio reads with truncate
References: <510A3807.1040306@cn.fujitsu.com> <20130131164041.GP3660@localhost.localdomain>
In-Reply-To: <20130131164041.GP3660@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 31 Jan 2013 11:40:41 -0500, Josef Bacik wrote:
> On Thu, Jan 31, 2013 at 02:23:19AM -0700, Miao Xie wrote:
>> Currently, we can do unlocked dio reads, but the following race
>> is possible:
>>
>> dio_read_task			truncate_task
>> 				->btrfs_setattr()
>> ->btrfs_direct_IO
>>     ->__blockdev_direct_IO
>>       ->btrfs_get_block
>> 				  ->btrfs_truncate()
>> 				 #alloc truncated blocks
>> 				 #to other inode
>>       ->submit_io()
>>      #INFORMATION LEAK
>>
>> In order to avoid this problem, we must serialize unlocked dio reads with
>> truncate by inode_dio_wait().
>>
> 
> So I had thinking about this, are we sure we don't want to just lock the extent
> range when we truncate?  I'm good with this, but it seems like we might as well
> and be consistent and use the extent locks.  What do you think?  Thanks,

But comparing with the current approach, the extent lock has the following problem:
	Dio_Read_Task			Truncate_task
					truncate file
					  set isize to 4096
					  drop pages
	lock extent[4096, 8191]
	read extent[4096, 8191]
	unlock extent[4096, 8191]
					  lock extent[4096, -1ULL]
					  truncate item
					  unlock extent[4096, -1ULL]
	lock extent[8192, ...]
	read extent[8192, ...]
	  no extent item
	  zero the buffer
	unlock extent[8192, ...]

we get the data that is mixed with new data.(Punch hole also has this problem, we need
fix)

Thanks
Miao
