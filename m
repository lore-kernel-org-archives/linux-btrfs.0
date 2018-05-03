Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbeECGXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 02:23:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D6ABAC61
        for <linux-btrfs@vger.kernel.org>; Thu,  3 May 2018 06:23:38 +0000 (UTC)
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
To: jeffm@suse.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
Date: Thu, 3 May 2018 09:23:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180502211156.9460-1-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.05.2018 00:11, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Hi Dave -
> 
> Here's the updated patchset for the rescan races.  This fixes the issue
> where we'd try to start multiple workers.  It introduces a new "ready"
> bool that we set during initialization and clear while queuing the worker.
> The queuer is also now responsible for most of the initialization.
> 
> I have a separate patch set start that gets rid of the racy mess surrounding
> the rescan worker startup.  We can handle it in btrfs_run_qgroups and
> just set a flag to start it everywhere else.
I'd be interested in seeing those patches. Some time ago I did send a
patch which cleaned up the way qgroup rescan was initiated. It was done
from "btrfs_run_qgroups" and I think this is messy. Whatever we do we
ought to really have well-defined semantics when qgroups rescan are run,
preferably we shouldn't be conflating rescan + run (unless there is
_really_ good reason to do). In the past the rescan from scan was used
only during qgroup enabling.

> 
> -Jeff
> 
> ---
> 
> Jeff Mahoney (3):
>   btrfs: qgroups, fix rescan worker running races
>   btrfs: qgroups, remove unnecessary memset before btrfs_init_work
>   btrfs: qgroup, don't try to insert status item after ENOMEM in rescan
>     worker
> 
>  fs/btrfs/async-thread.c |   1 +
>  fs/btrfs/ctree.h        |   2 +
>  fs/btrfs/qgroup.c       | 100 +++++++++++++++++++++++++++---------------------
>  3 files changed, 60 insertions(+), 43 deletions(-)
> 
