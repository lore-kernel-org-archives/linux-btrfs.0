Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3ANIET (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 03:04:19 -0500
Message-ID: <50F3BC2B.2010407@cn.fujitsu.com>
Date: Mon, 14 Jan 2013 16:04:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 05/11] Btrfs: protect fs_info->alloc_start
References: <50EEB880.4060308@cn.fujitsu.com> <20130110171040.GG20089@twin.jikos.cz>
In-Reply-To: <20130110171040.GG20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Jan 2013 18:10:40 +0100, David Sterba wrote:
> On Thu, Jan 10, 2013 at 08:48:00PM +0800, Miao Xie wrote:
>> fs_info->alloc_start was not protected strictly, it might be changed while
>> we were accessing it. This patch fixes this problem by using two locks to
>> protect it (fs_info->chunk_mutex and sb->s_umount). On the read side, we
>> just need get one of these two locks, and on the write side, we must lock
>> all of them.
> 
> Can you please describe how this can theoretically cause any problems?
> 
> Out of curiosity I've been running this command on a 60G ssd disk for a while
> 
> for i in `seq 1 10000|shuf`;do
> 	mount -o remount,alloc_start=$(($i*1024*1024)) /mnt/sdc;done
> 	#sleep 0 / 1 / 5
> done
> 
> together with one of my favourite stresstests (heavy writes, subvolume
> activity).
> 
> There are two direct users of fs_info->alloc_start:
> 
> * statfs via btrfs_calc_avail_data_space
> * find_free_dev_extent
> 
> 960         search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
> 
> as remount calls sync, there is a very tiny window where an allocation could
> get the old value of alloc_start just between sync and do_remount. Theoretical
> and without any visible effect.

->alloc_start is a 64bits variant, on the 32bits machine, we have to load it
by two instructions.

Assuming -> alloc_start is 0x00010000 at the beginning, then we remount and
set ->alloc_start to 0x00000100
	Task0 			Task1
				load low 32 bits
	set high 32 bits
				load high 32 bits
	set low 32 bits

Task1 will get 0.

Thanks
Miao

> 
> My NAK for this patch.
> 
> david
> 

