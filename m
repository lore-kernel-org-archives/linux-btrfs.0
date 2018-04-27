Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758236AbeD0QAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:00:09 -0400
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180426192351.473-1-jeffm@suse.com>
 <CAL3q7H6hJxE383ZkV4JhTr44_i5tQCtU4nPGGxeOb+_Y2mDzxQ@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e845aaf2-3b19-8b7f-7f6a-33b659276444@suse.com>
Date: Fri, 27 Apr 2018 12:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6hJxE383ZkV4JhTr44_i5tQCtU4nPGGxeOb+_Y2mDzxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/27/18 4:48 AM, Filipe Manana wrote:
> On Thu, Apr 26, 2018 at 8:23 PM,  <jeffm@suse.com> wrote:
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
> 
> The commit id and subjects don't match:
> 
> commit d2c609b834d62f1e91f1635a27dca29f7806d3d6
> Author: Jeff Mahoney <jeffm@suse.com>
> Date:   Mon Aug 15 12:10:33 2016 -0400
> 
>     btrfs: properly track when rescan worker is running
> 


Thanks.  Fixed.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
