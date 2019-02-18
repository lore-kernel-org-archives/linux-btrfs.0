Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D703FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 14:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A814E2081B
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 14:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbfBROaa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:30:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:58432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387672AbfBROa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 09:30:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E016DB034;
        Mon, 18 Feb 2019 14:30:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 394EEDA870; Mon, 18 Feb 2019 15:31:49 +0100 (CET)
Date:   Mon, 18 Feb 2019 15:31:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: check for refs on snapshot delete resume
Message-ID: <20190218143148.GJ9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190206204615.5862-1-josef@toxicpanda.com>
 <20190206204615.5862-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206204615.5862-2-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 06, 2019 at 03:46:14PM -0500, Josef Bacik wrote:
> There's a bug in snapshot deletion where we won't update the
> drop_progress key if we're in the UPDATE_BACKREF stage.  This is a
> problem because we could drop refs for blocks we know don't belong to
> ours.  If we crash or umount at the right time we could experience
> messages such as the following when snapshot deletion resumes
> 
>  BTRFS error (device dm-3): unable to find ref byte nr 66797568 parent 0 root 258  owner 1 offset 0
>  ------------[ cut here ]------------
>  WARNING: CPU: 3 PID: 16052 at fs/btrfs/extent-tree.c:7108 __btrfs_free_extent.isra.78+0x62c/0xb30 [btrfs]
>  CPU: 3 PID: 16052 Comm: umount Tainted: G        W  OE     5.0.0-rc4+ #147
>  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./890FX Deluxe5, BIOS P1.40 05/03/2011
>  RIP: 0010:__btrfs_free_extent.isra.78+0x62c/0xb30 [btrfs]
>  Code: 45 90 48 8b 40 50 f0 48 0f ba a8 98 1a 00 00 02 0f 92 c0 84 c0 5e 75 14 8b b5 7c ff ff ff 48 c7 c7 08 a7 b6 a0 e8 04 d0 63 e0 <0f> 0b 48 8b 7d 90 b9 fe ff ff ff ba c4 1b 00 00 48 c7 c6 a0 dd b5
>  RSP: 0018:ffffc90005cd7b18 EFLAGS: 00010286
>  RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>  RDX: ffff88842fade680 RSI: ffff88842fad6b18 RDI: ffff88842fad6b18
>  RBP: ffffc90005cd7bc8 R08: 0000000000000000 R09: 0000000000000001
>  R10: 0000000000000001 R11: ffffffff822696b8 R12: 0000000003fb4000
>  R13: 0000000000000001 R14: 0000000000000102 R15: ffff88819c9d67e0
>  FS:  00007f08bb138fc0(0000) GS:ffff88842fac0000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f8f5d861ea0 CR3: 00000003e99fe000 CR4: 00000000000006e0
>  Call Trace:
>  ? _raw_spin_unlock+0x27/0x40
>  ? btrfs_merge_delayed_refs+0x356/0x3e0 [btrfs]
>  __btrfs_run_delayed_refs+0x75a/0x13c0 [btrfs]
>  ? join_transaction+0x2b/0x460 [btrfs]
>  btrfs_run_delayed_refs+0xf3/0x1c0 [btrfs]
>  btrfs_commit_transaction+0x52/0xa50 [btrfs]
>  ? start_transaction+0xa6/0x510 [btrfs]
>  btrfs_sync_fs+0x79/0x1c0 [btrfs]
>  sync_filesystem+0x70/0x90
>  generic_shutdown_super+0x27/0x120
>  kill_anon_super+0x12/0x30
>  btrfs_kill_super+0x16/0xa0 [btrfs]
>  deactivate_locked_super+0x43/0x70
>  deactivate_super+0x40/0x60
>  cleanup_mnt+0x3f/0x80
>  __cleanup_mnt+0x12/0x20
>  task_work_run+0x8b/0xc0
>  exit_to_usermode_loop+0xce/0xd0
>  do_syscall_64+0x20b/0x210
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> To fix this simply mark dead roots we read from disk as DEAD and then
> set the walk_control->restarted flag so we know we have a restarted
> deletion.  From here whenever we try to drop refs for blocks we check to
> verify our ref is set on them, and if it is not we skip it.  Once we
> find a ref that is set we unset walk_control->restarted since the tree
> should be in a normal state from then on, and any problems we run into
> from there are different issues.  I tested this with an existing broken
> fs and my reproducer that creates a broken fs and it fixed both file
> systems.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h       |  1 +
>  fs/btrfs/extent-tree.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/root-tree.c   |  8 ++++++--
>  3 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9306925b6790..3d0bf91e1941 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1207,6 +1207,7 @@ enum {
>  	 * Set for the subvolume tree owning the reloc tree.
>  	 */
>  	BTRFS_ROOT_DEAD_RELOC_TREE,
> +	BTRFS_ROOT_DEAD_TREE,

Can you please put some description here?

>  };
>  
>  /*
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a53a2b9d49e9..f40d6086c947 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8772,6 +8772,7 @@ struct walk_control {
>  	int keep_locks;
>  	int reada_slot;
>  	int reada_count;
> +	int restarted;
>  };
>  
>  #define DROP_REFERENCE	1
> @@ -8934,6 +8935,33 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +/*
> + * This is used to verify a ref exists for this root to deal with a bug where we
> + * would have a drop_progress key that hadn't been updated properly.
> + */
> +static int check_ref_exists(struct btrfs_trans_handle *trans,
> +			    struct btrfs_root *root, u64 bytenr, u64 parent,
> +			    int level)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_extent_inline_ref *iref;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = lookup_extent_backref(trans, path, &iref, bytenr,
> +				    root->fs_info->nodesize, parent,
> +				    root->root_key.objectid, level, 0);
> +	btrfs_free_path(path);
> +	if (ret == -ENOENT)
> +		return 0;
> +	if (ret < 0)
> +		return ret;
> +	return 1;
> +}
> +
>  /*
>   * helper to process tree block pointer.
>   *
> @@ -9088,6 +9116,23 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  			parent = 0;
>  		}
>  
> +		/*
> +		 * If we had a drop_progress we need to verify the refs are set
> +		 * as expected.  If we find our ref then we know that from here
> +		 * on out everything should be correct, and we can clear the
> +		 * ->restarted flag.
> +		 */
> +		if (wc->restarted) {
> +			ret = check_ref_exists(trans, root, bytenr, parent,
> +					       level - 1);
> +			if (ret < 0)
> +				goto out_unlock;
> +			if (ret == 0)
> +				goto no_delete;
> +			ret = 0;
> +			wc->restarted = 0;
> +		}
> +
>  		/*
>  		 * Reloc tree doesn't contribute to qgroup numbers, and we have
>  		 * already accounted them at merge time (replace_path),
> @@ -9109,7 +9154,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  		if (ret)
>  			goto out_unlock;
>  	}
> -
> +no_delete:
>  	*lookup_info = 1;
>  	ret = 1;
>  
> @@ -9426,6 +9471,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  		}
>  	}
>  
> +	wc->restarted = test_bit(BTRFS_ROOT_DEAD_TREE, &root->state);
>  	wc->level = level;
>  	wc->shared_level = -1;
>  	wc->stage = DROP_REFERENCE;
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 65bda0682928..02d1a57af78b 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -263,8 +263,10 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
>  		if (root) {
>  			WARN_ON(!test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
>  					  &root->state));
> -			if (btrfs_root_refs(&root->root_item) == 0)
> +			if (btrfs_root_refs(&root->root_item) == 0) {
> +				set_bit(BTRFS_ROOT_DEAD_TREE, &root->state);
>  				btrfs_add_dead_root(root);

This got me wondering why the set_bit is not inside btrfs_add_dead_root,
there are more calls that maybe don't neeed it. I don't see anything
wrong in principle to set the bit once the root is dead, ie. when the
root is added to fs_info::dead_roots.
