Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59775 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbeEBN6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 09:58:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A439AAE76
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 13:58:31 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180502102928.GX21272@twin.jikos.cz> <20180502131543.GY21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <504675d4-2a5c-2972-afd7-17dfdad71845@suse.com>
Date: Wed, 2 May 2018 09:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <20180502131543.GY21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/2/18 9:15 AM, David Sterba wrote:
> On Wed, May 02, 2018 at 12:29:28PM +0200, David Sterba wrote:
>> On Thu, Apr 26, 2018 at 03:23:49PM -0400, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
>>> +{
>>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>>> +	if (btrfs_fs_closing(fs_info)) {
>>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>>> +		return;
>>> +	}
>>> +	if (WARN_ON(fs_info->qgroup_rescan_running)) {
>>
>> The warning is quite noisy, I see it after tests btrfs/ 017, 022, 124,
>> 139, 153. Is it necessary for non-debugging builds?
>>
>> The tested branch was full for-next so it could be your patchset
>> interacting with other fixes, but the warning noise level question still
>> stands.
> 
> So it must be something with the rest of misc-next or for-next patches,
> current for 4.17 queue does show the warning at all, and the patch is ok
> for merge.
>
You might have something that causes it to be more noisy but it looks
like it should be possible to hit on 4.16.  The warning is supposed to
detect and complain about multiple rescan threads starting.  What I
think it's doing here is (correctly) identifying a different race: at
the end of btrfs_qgroup_rescan_worker, we clear the rescan status flag,
drop the lock, commit the status item transaction, and then update
->qgroup_rescan_running.  If a rescan is requested before the lock is
reacquired, we'll try to start it up and then hit that warning.

So, the warning is doing its job.  Please hold off on merging this patch.

IMO the root cause is overloading fs_info->qgroup_flags to correspond to
the on-disk item and control runtime behavior.  I've been meaning to fix
that for a while, so I'll do that now.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
