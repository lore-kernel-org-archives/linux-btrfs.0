Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38012 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3ATNLg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 08:11:36 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so4207503wib.4
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 05:11:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130110171040.GG20089@twin.jikos.cz>
References: <50EEB880.4060308@cn.fujitsu.com>
	<20130110171040.GG20089@twin.jikos.cz>
Date: Sun, 20 Jan 2013 15:11:34 +0200
Message-ID: <CAOcd+r1ok5yUeYBfzkV2XTqp5ytvzT+fYBsv3STS9QTYqd9DHQ@mail.gmail.com>
Subject: Re: [PATCH 05/11] Btrfs: protect fs_info->alloc_start
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: dsterba@suse.cz
Cc: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,
do you think you can share this favorite stress-test that you have mentioned?

Thanks,
Alex.


On Thu, Jan 10, 2013 at 7:10 PM, David Sterba <dsterba@suse.cz> wrote:
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
>         mount -o remount,alloc_start=$(($i*1024*1024)) /mnt/sdc;done
>         #sleep 0 / 1 / 5
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
>
> My NAK for this patch.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
