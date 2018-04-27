Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758594AbeD0QCQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:02:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E088AC07
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:02:15 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180427155608.GC21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <fbfbd98c-a7ee-4309-22ab-1e3a8416d27a@suse.com>
Date: Fri, 27 Apr 2018 12:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180427155608.GC21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/27/18 11:56 AM, David Sterba wrote:
> On Thu, Apr 26, 2018 at 03:23:49PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
>> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
>> ended up reintroducing the hang-on-unmount bug that the commit it
>> intended to fix addressed.
>>
>> The race this time is between qgroup_rescan_init setting
>> ->qgroup_rescan_running = true and the worker starting.  There are
>> many scenarios where we initialize the worker and never start it.  The
>> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
>> This can happen even without involving error handling, since mounting
>> the file system read-only returns between initializing the worker and
>> queueing it.
>>
>> The right place to do it is when we're queuing the worker.  The flag
>> really just means that btrfs_ioctl_quota_rescan_wait should wait for
>> a completion.
>>
>> This patch introduces a new helper, queue_rescan_worker, that handles
>> the ->qgroup_rescan_running flag, including any races with umount.
>>
>> While we're at it, ->qgroup_rescan_running is protected only by the
>> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
>> to take the spinlock too.
>>
>> Fixes: d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> I've added this to misc-next as I'd like to push it to the next rc. The
> Fixes is fixed.
> 
>> +	/* qgroup rescan worker is running or queued to run */
>>  	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
> 
> Comments merged.

Thanks.

>>  	/* filesystem state */
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index aa259d6986e1..be491b6c020a 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2072,6 +2072,30 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>  
>> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
>> +{
> 
> And this had to be moved upwards as there was earlier use of
> btrfs_queue_work that matched following the hunk.

Weird.  That must be exactly the kind of mismerge artifact that we were
talking about the other day.  In my tree it's in the right spot.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
