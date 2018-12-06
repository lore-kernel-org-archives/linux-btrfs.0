Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8855C65BAF
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 18:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B707620892
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 18:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B707620892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbeLFScQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:32:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:48724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbeLFScQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 13:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC34CB00B;
        Thu,  6 Dec 2018 18:32:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E1A06DAB92; Thu,  6 Dec 2018 19:31:51 +0100 (CET)
Date:   Thu, 6 Dec 2018 19:31:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH][v2] btrfs: run delayed items before dropping the snapshot
Message-ID: <20181206183148.GE23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
References: <20181205171221.28777-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205171221.28777-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 12:12:21PM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> With my delayed refs patches in place we started seeing a large amount
> of aborts in __btrfs_free_extent
> 
> BTRFS error (device sdb1): unable to find ref byte nr 91947008 parent 0 root 35964  owner 1 offset 0
> Call Trace:
>  ? btrfs_merge_delayed_refs+0xaf/0x340
>  __btrfs_run_delayed_refs+0x6ea/0xfc0
>  ? btrfs_set_path_blocking+0x31/0x60
>  btrfs_run_delayed_refs+0xeb/0x180
>  btrfs_commit_transaction+0x179/0x7f0
>  ? btrfs_check_space_for_delayed_refs+0x30/0x50
>  ? should_end_transaction.isra.19+0xe/0x40
>  btrfs_drop_snapshot+0x41c/0x7c0
>  btrfs_clean_one_deleted_snapshot+0xb5/0xd0
>  cleaner_kthread+0xf6/0x120
>  kthread+0xf8/0x130
>  ? btree_invalidatepage+0x90/0x90
>  ? kthread_bind+0x10/0x10
>  ret_from_fork+0x35/0x40
> 
> This was because btrfs_drop_snapshot depends on the root not being modified
> while it's dropping the snapshot.  It will unlock the root node (and really
> every node) as it walks down the tree, only to re-lock it when it needs to do
> something.  This is a problem because if we modify the tree we could cow a block
> in our path, which free's our reference to that block.  Then once we get back to
> that shared block we'll free our reference to it again, and get ENOENT when
> trying to lookup our extent reference to that block in __btrfs_free_extent.
> 
> This is ultimately happening because we have delayed items left to be processed
> for our deleted snapshot _after_ all of the inodes are closed for the snapshot.
> We only run the delayed inode item if we're deleting the inode, and even then we
> do not run the delayed insertions or delayed removals.  These can be run at any
> point after our final inode does it's last iput, which is what triggers the
> snapshot deletion.  We can end up with the snapshot deletion happening and then
> have the delayed items run on that file system, resulting in the above problem.
> 
> This problem has existed forever, however my patches made it much easier to hit
> as I wake up the cleaner much more often to deal with delayed iputs, which made
> us more likely to start the snapshot dropping work before the transaction
> commits, which is when the delayed items would generally be run.  Before,
> generally speaking, we would run the delayed items, commit the transaction, and
> wakeup the cleaner thread to start deleting snapshots, which means we were less
> likely to hit this problem.  You could still hit it if you had multiple
> snapshots to be deleted and ended up with lots of delayed items, but it was
> definitely harder.
> 
> Fix for now by simply running all the delayed items before starting to drop the
> snapshot.  We could make this smarter in the future by making the delayed items
> per-root, and then simply drop any delayed items for roots that we are going to
> delete.  But for now just a quick and easy solution is the safest.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> v1->v2:
> - check for errors from btrfs_run_delayed_items.
> - Dave I can reroll the series, but the second version of patch 1 is the same,
>   let me know what you want.

As this is a small update it's fine to send just that patch. You may
also use --in-reply-to so it threads to the original series. Resending
series makes most sense (to me) when there's a discussion and many
changes, so a fresh series makes it clear what's the current status.

Patch replaced in for-next topic branch, thanks.
