Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E301BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1810206C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbfBOSei (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 13:34:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:51442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389689AbfBOSei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 13:34:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 076FFB112;
        Fri, 15 Feb 2019 18:34:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0B79DA87D; Fri, 15 Feb 2019 19:35:59 +0100 (CET)
Date:   Fri, 15 Feb 2019 19:35:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: honor path->skip_locking in backref code
Message-ID: <20190215183558.GI9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
References: <20190213062704.25121-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213062704.25121-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 13, 2019 at 02:27:04PM +0800, Qu Wenruo wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Qgroups will do the old roots lookup at delayed ref time, which could be
> while walking down the extent root while running a delayed ref.  This
> should be fine, except we specifically lock eb's in the backref walking
> code irrespective of path->skip_locking, which deadlocks the system.
> Fix up the backref code to honor path->skip_locking, nobody will be
> modifying the commit_root when we're searching so it's completely safe
> to do.
> 
> This happens Since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup
> accounting time out of commit trans"), kernel may lockup with quota
> enabled.
> 
> There is one backref trace triggered by snapshot dropping along with
> write operation in the source subvolume.  The example can be reliably
> reproduced:
> 
>   btrfs-cleaner   D    0  4062      2 0x80000000
>   Call Trace:
>    schedule+0x32/0x90
>    btrfs_tree_read_lock+0x93/0x130 [btrfs]
>    find_parent_nodes+0x29b/0x1170 [btrfs]
>    btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
>    btrfs_find_all_roots+0x57/0x70 [btrfs]
>    btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
>    btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
>    btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
>    do_walk_down+0x541/0x5e3 [btrfs]
>    walk_down_tree+0xab/0xe7 [btrfs]
>    btrfs_drop_snapshot+0x356/0x71a [btrfs]
>    btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
>    cleaner_kthread+0x12b/0x160 [btrfs]
>    kthread+0x112/0x130
>    ret_from_fork+0x27/0x50
> 
> When dropping snapshots with qgroup enabled, we will trigger backref
> walk.
> 
> However such backref walk at that timing is pretty dangerous, as if one
> of the parent nodes get WRITE locked by other thread, we could cause a
> dead lock.
> 
> For example:
> 
>            FS 260     FS 261 (Dropped)
>             node A        node B
>            /      \      /      \
>        node C      node D      node E
>       /   \         /  \        /     \
>   leaf F|leaf G|leaf H|leaf I|leaf J|leaf K
> 
> The lock sequence would be:
> 
>       Thread A (cleaner)             |       Thread B (other writer)
> -----------------------------------------------------------------------
> write_lock(B)                        |
> write_lock(D)                        |
> ^^^ called by walk_down_tree()       |
>                                      |       write_lock(A)
>                                      |       write_lock(D) << Stall
> read_lock(H) << for backref walk     |
> read_lock(D) << lock owner is        |
>                 the same thread A    |
>                 so read lock is OK   |
> read_lock(A) << Stall                |
> 
> So thread A hold write lock D, and needs read lock A to unlock.
> While thread B holds write lock A, while needs lock D to unlock.
> 
> This will cause a deadlock.
> 
> This is not only limited to snapshot dropping case.
> As the backref walk, even only happens on commit trees, is breaking the
> normal top-down locking order, makes it deadlock prone.
> 
> Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting time out of commit trans")
> CC: stable@vger.kernel.org # 4.19+
> Reported-and-tested-by: David Sterba <dsterba@suse.com>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ copy logs and deadlock analysis from Qu's patch ]
> [ rebase to latest branch and fix lock assert bug ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> changelog:
> v2:
> - Rebased to latest misc-next branch.
> - Fix a lock assert by moving btrfs_set_lock_blocking_read() into the
>   same branch of btrfs_tree_read_lock().

Thanks for finding the fix and sending on Josef's behalf. If this
weren't an important bugfix I'd just wait for him to resend. I've added
your signed-off-by as 3/4 of the changelog were copied from your patch
anyway.
