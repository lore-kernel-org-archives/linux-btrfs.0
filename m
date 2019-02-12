Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4328AC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13C0820842
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbfBLPuM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:50:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:56758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728347AbfBLPuL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 10:50:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05922AF81;
        Tue, 12 Feb 2019 15:50:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52F22DA84E; Tue, 12 Feb 2019 16:49:27 +0100 (CET)
Date:   Tue, 12 Feb 2019 16:49:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] btrfs: scrub: fix circular locking dependency
 warning
Message-ID: <20190212154923.GC2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
 <20190130140758.GR2900@twin.jikos.cz>
 <be521dbc-0b2a-696a-7167-21d50c6c71a9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be521dbc-0b2a-696a-7167-21d50c6c71a9@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 02:34:54PM +0800, Anand Jain wrote:
> 
> 
> On 1/30/19 10:07 PM, David Sterba wrote:
> > On Wed, Jan 30, 2019 at 02:45:00PM +0800, Anand Jain wrote:
> >> v3->v4: Fix list corruption as reported by btrfs/073 by David.
> >>             [1]
> >>             https://patchwork.kernel.org/patch/10705741/
> >> 	Which I was able to reproduce with an instrumented kernel but not with
> >> 	btrfs/073.
> >>          In v3 patch, it releases the fs_info::scrub_lock to destroy the work queue
> >> 	which raced with new scrub requests, overwriting the scrub workers
> >> 	pointers. So in v4, it kills the function scrub_workers_put(), and
> >> 	performs the destroy_workqueue in two stages, with worker pointers
> >> 	copied locally.
> > 
> >> @@ -3932,9 +3925,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> >>   
> >>   	mutex_lock(&fs_info->scrub_lock);
> >>   	dev->scrub_ctx = NULL;
> >> -	scrub_workers_put(fs_info);
> >> +	if (--fs_info->scrub_workers_refcnt == 0) {
> >> +		scrub_workers = fs_info->scrub_workers;
> >> +		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
> >> +		scrub_parity = fs_info->scrub_parity_workers;
> >> +	}
> >>   	mutex_unlock(&fs_info->scrub_lock);
> >>   
> >> +	btrfs_destroy_workqueue(scrub_workers);
> >> +	btrfs_destroy_workqueue(scrub_wr_comp);
> >> +	btrfs_destroy_workqueue(scrub_parity);
> > 
> > https://lore.kernel.org/linux-btrfs/1543554924-17397-2-git-send-email-anand.jain@oracle.com/
> > 
> > Comparing to the previous version, it's almost the same I think. If
> > scrub_workers_get races between the unlock and destroy_workers, anything
> > that uses fs_info->scrub_wokers will soon use freed memory.
> > 
> > The difference is that the worker pointers are read from fs_info under a
> > lock but are still used outside. I haven't tested this version but from
> > the analysis of previous crash, I don't see how v4 is supposed to be
> > better.
> >
> 
> Consider v3 code as below:
> 
> When process-A is at [1] (below) start another
> btrfs scrub start, lets call it process-B.
> When process-A is at [1] it unlocks the fs_info::scrub_lock so the
> process-B can overwrite fs_info::scrub_workers,
> fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
> which the process-A at [1] has not yet called destroyed.
> 
> Process-A
> ---------
> 
> btrfs scrub start /mnt
> 
> ::
>          mutex_lock(&fs_info->scrub_lock);
> ::
>          if (dev->scrub_ctx ||
>              (!is_dev_replace &&
>               btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
>                  up_read(&fs_info->dev_replace.rwsem);
>                  mutex_unlock(&fs_info->scrub_lock);
>                  mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>                  ret = -EINPROGRESS;
>                  goto out_free_ctx;
>          }
> ::
>          ret = scrub_workers_get(fs_info, is_dev_replace);  <-- [2]
> ::
>          dev->scrub_ctx = sctx;
>          mutex_unlock(&fs_info->scrub_lock);
> 
> ::
>                  ret = scrub_enumerate_chunks(sctx, dev, start, end);
> ::
>          atomic_dec(&fs_info->scrubs_running);
> ::
> 
>          mutex_lock(&fs_info->scrub_lock);
>          dev->scrub_ctx = NULL;
>          scrub_workers_put(fs_info);
>          mutex_unlock(&fs_info->scrub_lock);
> 
> 
> 
> static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info 
> *fs_info)
> {
>          lockdep_assert_held(&fs_info->scrub_lock);
>          if (--fs_info->scrub_workers_refcnt == 0) {
>                  mutex_unlock(&fs_info->scrub_lock);
> 
> 		<wait for process-B>  [1]
> 
>                  btrfs_destroy_workqueue(fs_info->scrub_workers);
>  
> btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
>                  btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
>                  mutex_lock(&fs_info->scrub_lock);
>          }
>          WARN_ON(fs_info->scrub_workers_refcnt < 0);
> }
> 
> 
> 
> 
> Process-B
> ---------
> Start when process-A is at [1] (above)
> btrfs scrub start /mnt
> 
> ::
>   at [2] (above) the fs_info::scrub_workers,
> fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
> of process-A are overwritten.
> 
> 
> So in v4.
> --------
> 
> Similar to dev::scrub_ctx the fs_info::scrub_workers,
> fs_info::scrub_wr_completion_workers, fs_info::scrub_parity_workers
> are stored locally before fs_info::scrub_lock is released, so the
> list pointers aren't corrupted.
> 
> Hope this clarifies.

Yes, thanks. I'd like to add some assertions, to make the worker
pointers always NULL if the refcount is 0. Ie. initially they're 0 due
to kzalloc of fs_info, so the additional part would go to the block.

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3744,17 +3744,20 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
        lockdep_assert_held(&fs_info->scrub_lock);
 
        if (refcount_read(&fs_info->scrub_workers_refcnt) == 0) {
+               ASSERT(fs_info->scrub_workers == NULL);
                fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
                                flags, is_dev_replace ? 1 : max_active, 4);
                if (!fs_info->scrub_workers)
                        goto fail_scrub_workers;
 
+               ASSERT(fs_info->scrub_wr_completion_workers == NULL);
                fs_info->scrub_wr_completion_workers =
                        btrfs_alloc_workqueue(fs_info, "scrubwrc", flags,
                                              max_active, 2);
                if (!fs_info->scrub_wr_completion_workers)
                        goto fail_scrub_wr_completion_workers;
 
+               ASSERT(fs_info->scrub_parity_workers == NULL);
                fs_info->scrub_parity_workers =
                        btrfs_alloc_workqueue(fs_info, "scrubparity", flags,
                                              max_active, 2);
@@ -3934,6 +3937,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
                scrub_workers = fs_info->scrub_workers;
                scrub_wr_comp = fs_info->scrub_wr_completion_workers;
                scrub_parity = fs_info->scrub_parity_workers;
+
+               fs_info->scrub_workers = NULL;
+               fs_info->scrub_wr_completion_workers = NULL;
+               fs_info->scrub_parity_workers = NULL;
        }
        mutex_unlock(&fs_info->scrub_lock);
