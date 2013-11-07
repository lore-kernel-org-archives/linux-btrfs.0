Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3KGRwT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 12:52:19 -0500
Date: Thu, 7 Nov 2013 18:52:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/17] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue_struct
Message-ID: <20131107175214.GK16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 01:51:50PM +0800, Qu Wenruo wrote:
> Qu Wenruo (17):
>   btrfs: Cleanup the unused struct async_sched.
>   btrfs: Added btrfs_workqueue_struct implemented ordered execution
>     based on kernel workqueue
>   btrfs: Add high priority workqueue support for btrfs_workqueue_struct
>   btrfs: Add threshold workqueue based on kernel workqueue
>   btrfs: Replace fs_info->workers with btrfs_workqueue.
>   btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
>   btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
>   btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
>   btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->readahead_workers workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->delayed_workers workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->qgroup_rescan_worker workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
>   btrfs: Cleanup the old btrfs_worker.

One comment to all patches: please try to stick to the kernel coding
style, you're changing code that will hopefully stay untouched for a
long time, please get the formatting right from the beginning.

- comment formatting
- blank line after declaration block

The patches need functional review, I'm not happy to point out such
things, but please understand that it distracts (and sometimes hurts
eyes) during review.

david
