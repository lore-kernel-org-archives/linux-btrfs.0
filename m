Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbeEDF7W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 01:59:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3674AEBB
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 05:59:20 +0000 (UTC)
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
To: Jeff Mahoney <jeffm@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
 <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <14832abb-4d2c-c643-07e4-d81dc6ab8209@suse.com>
Date: Fri, 4 May 2018 08:59:19 +0300
MIME-Version: 1.0
In-Reply-To: <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.05.2018 01:27, Jeff Mahoney wrote:
> On 5/3/18 2:23 AM, Nikolay Borisov wrote:
>>
>>
>> On  3.05.2018 00:11, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> Hi Dave -
>>>
>>> Here's the updated patchset for the rescan races.  This fixes the issue
>>> where we'd try to start multiple workers.  It introduces a new "ready"
>>> bool that we set during initialization and clear while queuing the worker.
>>> The queuer is also now responsible for most of the initialization.
>>>
>>> I have a separate patch set start that gets rid of the racy mess surrounding
>>> the rescan worker startup.  We can handle it in btrfs_run_qgroups and
>>> just set a flag to start it everywhere else.
>> I'd be interested in seeing those patches. Some time ago I did send a
>> patch which cleaned up the way qgroup rescan was initiated. It was done
>> from "btrfs_run_qgroups" and I think this is messy. Whatever we do we
>> ought to really have well-defined semantics when qgroups rescan are run,
>> preferably we shouldn't be conflating rescan + run (unless there is
>> _really_ good reason to do). In the past the rescan from scan was used
>> only during qgroup enabling.
> 
> I think btrfs_run_qgroups is the place to do it.  Here's why:
> 
> 2773 int
> 2774 btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
> 2775 {
> 2776         int ret = 0;
> 2777         struct btrfs_trans_handle *trans;
> 2778
> 2779         ret = qgroup_rescan_init(fs_info, 0, 1);
> 2780         if (ret)
> 2781                 return ret;
> 2782
> 2783         /*
> 2784          * We have set the rescan_progress to 0, which means no more
> 2785          * delayed refs will be accounted by btrfs_qgroup_account_ref.
> 2786          * However, btrfs_qgroup_account_ref may be right after its call
> 2787          * to btrfs_find_all_roots, in which case it would still do the
> 2788          * accounting.
> 2789          * To solve this, we're committing the transaction, which will
> 2790          * ensure we run all delayed refs and only after that, we are
> 2791          * going to clear all tracking information for a clean start.
> 2792          */
> 2793
> 2794         trans = btrfs_join_transaction(fs_info->fs_root);
> 2795         if (IS_ERR(trans)) {
> 2796                 fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> 2797                 return PTR_ERR(trans);
> 2798         }
> 2799         ret = btrfs_commit_transaction(trans);
> 2800         if (ret) {
> 2801                 fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> 2802                 return ret;
> 2803         }
> 2804
> 2805         qgroup_rescan_zero_tracking(fs_info);
> 2806
> 2807         queue_rescan_worker(fs_info);
> 2808         return 0;
> 2809 }
> 
> The delayed ref race should exist anywhere we initiate a rescan outside of
> initially enabling qgroups.  We already zero the tracking and queue the rescan
> worker in btrfs_run_qgroups for when we enable qgroups.  Why not just always
> queue the worker there so the initialization and execution has a clear starting point?

This is no longer true in upstream as of commit 5d23515be669 ("btrfs:
Move qgroup rescan on quota enable to btrfs_quota_enable"). Hence my
asking about this. I guess if we make it unconditional it won't increase
the complexity, but the original code which was only run during qgroup
enable was rather iffy I Just don't want to repeat this.



> There are a few other races I'd like to fix as well.  We call btrfs_run_qgroups
> directly from btrfs_ioctl_qgroup_assign, which is buggy since
> btrfs_add_qgroup_relation only checks to see if the quota_root exists.  It will
> exist as soon as btrfs_quota_enable runs but we won't have committed the
> transaction yet.  The call will end up enabling quotas in the middle of a transaction.
> 
> -Jeff
> 
