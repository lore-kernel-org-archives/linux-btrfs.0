Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3KHAyj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:54:39 -0500
Message-ID: <527C367F.6070803@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 08:55:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/17] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue_struct
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <20131107175214.GK16662@twin.jikos.cz>
In-Reply-To: <20131107175214.GK16662@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 7 Nov 2013 18:52:14 +0100, David Sterba wrote:
> On Thu, Nov 07, 2013 at 01:51:50PM +0800, Qu Wenruo wrote:
>> Qu Wenruo (17):
>>    btrfs: Cleanup the unused struct async_sched.
>>    btrfs: Added btrfs_workqueue_struct implemented ordered execution
>>      based on kernel workqueue
>>    btrfs: Add high priority workqueue support for btrfs_workqueue_struct
>>    btrfs: Add threshold workqueue based on kernel workqueue
>>    btrfs: Replace fs_info->workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
>>    btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->readahead_workers workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->delayed_workers workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->qgroup_rescan_worker workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
>>    btrfs: Cleanup the old btrfs_worker.
> One comment to all patches: please try to stick to the kernel coding
> style, you're changing code that will hopefully stay untouched for a
> long time, please get the formatting right from the beginning.
>
> - comment formatting
> - blank line after declaration block
>
> The patches need functional review, I'm not happy to point out such
> things, but please understand that it distracts (and sometimes hurts
> eyes) during review.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Thanks for pointing out the coding style problem.
I'll check them again to fix the problem.

Thanks.

Qu

-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

