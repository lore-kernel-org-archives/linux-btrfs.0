Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54720 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab2I2QVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 12:21:48 -0400
Date: Sat, 29 Sep 2012 18:21:40 +0200
From: David Sterba <dave@jikos.cz>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: shrink_delalloc check bdi write congested
Message-ID: <20120929162140.GI14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 29, 2012 at 10:20:09PM +0900, Itaru Kitayama wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3712,7 +3712,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 t
>         while (delalloc_bytes && loops < 3) {
>                 max_reclaim = min(delalloc_bytes, to_reclaim);
>                 nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
> -               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
> +               if (!bdi_write_congested(root->fs_info->sb->s_bdi)) writeback_in
>                                                WB_REASON_FS_FREE_SPACE);

malformed patch
