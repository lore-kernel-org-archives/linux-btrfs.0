Return-Path: <SRS0=3GY2=BG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96008C433ED
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 14:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBB420775
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 14:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbgG0Obj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:31:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbgG0OUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E50ACAF21;
        Mon, 27 Jul 2020 14:20:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 686E1DA701; Mon, 27 Jul 2020 16:19:47 +0200 (CEST)
Date:   Mon, 27 Jul 2020 16:19:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: free fs roots on failed mount
Message-ID: <20200727141947.GN3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200722160722.8641-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722160722.8641-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 22, 2020 at 12:07:21PM -0400, Josef Bacik wrote:
> While testing a weird problem with -o degraded, I noticed I was getting
> leaked root errors
> 
> BTRFS warning (device loop0): writable mount is not allowed due to too many missing devices
> BTRFS error (device loop0): open_ctree failed
> BTRFS error (device loop0): leaked root -9-0 refcount 1
> 
> This is the DATA_RELOC root, which gets read before the other fs roots,
> but is included in the fs roots radix tree, and thus gets freed by
> btrfs_free_fs_roots.  Fix this by moving the call into fail_tree_roots:
> in open_ctree.  With this fix we no longer leak that root on mount
> failure.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c850d7f44fbe..f1fdbdd44c02 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3421,7 +3421,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  fail_trans_kthread:
>  	kthread_stop(fs_info->transaction_kthread);
>  	btrfs_cleanup_transaction(fs_info);
> -	btrfs_free_fs_roots(fs_info);
>  fail_cleaner:
>  	kthread_stop(fs_info->cleaner_kthread);
>  
> @@ -3441,6 +3440,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  	btrfs_put_block_group_cache(fs_info);
>  
>  fail_tree_roots:
> +	btrfs_free_fs_roots(fs_info);
>  	free_root_pointers(fs_info, true);

The data reloc tree is freed inside free_root_pointers, that it's also
in the radix tree is for convenience so I'd rather fix it inside
free_root_pointers and not reorder btrfs_free_fs_roots.

>  	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  
> -- 
> 2.24.1
