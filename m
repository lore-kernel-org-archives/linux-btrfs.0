Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932913AbdC3QxN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:53:13 -0400
Date: Thu, 30 Mar 2017 18:52:28 +0200
From: David Sterba <dsterba@ds.suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 0/5] raid56: scrub related fixes
Message-ID: <20170330165228.GA22556@ds.suse.cz>
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 09:33:17AM +0800, Qu Wenruo wrote:
> This patchset can be fetched from my github repo:
> https://github.com/adam900710/linux.git raid56_fixes
> 
> It's based on v4.11-rc2, the last two patches get modified according to
> the advice from Liu Bo.
> 
> The patchset fixes the following bugs:
> 
> 1) False alert or wrong csum error number when scrubbing RAID5/6
>    The bug itself won't cause any damage to fs, just pure race.
> 
>    This can be triggered by running scrub for 64K corrupted data stripe,
>    Normally it will report 16 csum error recovered, but sometimes it
>    will report more than 16 csum error recovered, under rare case, even
>    unrecoverable error an be reported.
> 
> 2) Corrupted data stripe rebuild corrupts P/Q
>    So scrub makes one error into another, not really fixing anything
> 
>    Since kernel scrub doesn't report parity error, so either offline
>    scrub or manual check is needed to expose such error.
> 
> 3) Use-after-free caused by cancelling dev-replace 
>    This is quite a deadly bug, since cancelling dev-replace can
>    cause kernel panic.
> 
>    Can be triggered by btrfs/069.
> 
> v2:
>   Use bio_counter to protect rbio against dev-replace cancel, instead of
>   original btrfs_device refcount, which is too restrict and must disable
>   rbio cache, suggested by Liu Bo.
> 
> v3:
>   Add fix for another possible use-after-free when rechecking recovered
>   full stripe
>   Squashing two patches as they are fixing the same problem, to make
>   bisect easier.
>   Use mutex other than spinlock to protect full stripe locks tree, this
>   allow us to allocate memory inside the critical section on demand.
>   Encapsulate rb_root and mutex into btrfs_full_stripe_locks_tree.
>   Rename scrub_full_stripe_lock to full_stripe_lock inside scrub.c.
>   Rename related function to have unified naming.
>   Code style change to follow the existing scrub code style.
> 
> Qu Wenruo (5):
>   btrfs: scrub: Introduce full stripe lock for RAID56
>   btrfs: scrub: Fix RAID56 recovery race condition
>   btrfs: scrub: Don't append on-disk pages for raid56 scrub
>   btrfs: Wait flighting bio before freeing target device for raid56
>   btrfs: Prevent scrub recheck from racing with dev replace

As Liu Bo reviewed 3-5 and otherwise look good to me, I'm going to add
them to 4.12 queue, and will fix the typos myself. Please update 1 and 2
and resend.
