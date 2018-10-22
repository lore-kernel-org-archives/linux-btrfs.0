Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CA8C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9DA20651
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CQXfqBiN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA9DA20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbeJWDPn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:15:43 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42634 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJWDPm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:15:42 -0400
Received: by mail-qk1-f194.google.com with SMTP id u20-v6so11475936qkk.9
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h3UF+Kx59VbBcvDJIBJKdXYpMBpxjMe4j4XgxyIby7E=;
        b=CQXfqBiNuca7AKISDK9gyG0L0LFctOdOXm6l//8TQPIjObYWEyei4yEdLmlRHbGyyf
         1MgCqZoUNcSnOdqb+LgC5zK+T5gsQ4xFvLpa1MbCBR8xJA4izWMuuR2X/ii8ZIqHdIYH
         r5CZDiK7lZBsuPN9zD+hgbAxbhW5boT3OxrgHrNJBF/W0YpDv5UKsEkREejq6BPvyV7Y
         Qew0aXJKzGjPc18VWDkKwHp7u7mKYNVqI0l67lW1wFsDn35YVFtvCcDVBQlLhgaaVTW8
         QsPoGiG1Ig7jQBkvO2OVaSLTkxGNPBQyILD5I33lfPf5tHL6ayyOPsNLZFvEo++ZoSBH
         0IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h3UF+Kx59VbBcvDJIBJKdXYpMBpxjMe4j4XgxyIby7E=;
        b=fUob1TUHTeuXaqs+01TqcT1ZLY1WJuVamGwrdl2gKOR3bLeMFdNWBgybZNRBiPxJ4+
         PmJRkH/YGs4LpQM7bLj8hQn5ayIxqXMMWcBULil/E4Gn4l5mAvHxXod4REz9j+1ef3Q6
         fbOkcLufoNVFyZuUNi69kvkrfbVO+b4jqlqm8fmGaHmo6nHjtfDbm67E6FW4bOCauvrZ
         g6wJsdecavn9IcsUdUyQZZ9vAxjb4CgQQ64QdDs2+IJlqs3lx+q7uERyn3uyKb6zAvaj
         EFLo+UXTK4SCMp85c9G/nFgCEJuRf3iQ7u0IX9epO9VR/mHi/W3jyVpUpTk6OQEsFNyP
         hyrw==
X-Gm-Message-State: ABuFfoihZEGvcMmkOKBuuQbrrOKQzTD0hx02gR1/RDTJl2eNiRdsNHTe
        ZuTs7P+IqN09oZXFFsfCbAw4sw==
X-Google-Smtp-Source: ACcGV62H0ZqD2a87mX6P30+GMssvoE2PR/Ku68xqlGnHlK2Ye9NSQuyUDHu9vKhixxNaX4bN0LymvA==
X-Received: by 2002:a37:655:: with SMTP id 82-v6mr43563815qkg.223.1540234559365;
        Mon, 22 Oct 2018 11:55:59 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p6-v6sm4432082qtc.61.2018.10.22.11.55.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 11:55:58 -0700 (PDT)
Date:   Mon, 22 Oct 2018 14:55:57 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181022185556.2bfuoijklvsdyzx6@destiny>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181022184830.415-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022184830.415-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 07:48:30PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we are writing out a free space cache, during the transaction commit
> phase, we can end up in a deadlock which results in a stack trace like the
> following:
> 
>  schedule+0x28/0x80
>  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
>  ? finish_wait+0x80/0x80
>  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
>  btrfs_search_slot+0xf6/0x9f0 [btrfs]
>  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
>  ? inode_insert5+0x119/0x190
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_iget+0x113/0x690 [btrfs]
>  __lookup_free_space_inode+0xd8/0x150 [btrfs]
>  lookup_free_space_inode+0x5b/0xb0 [btrfs]
>  load_free_space_cache+0x7c/0x170 [btrfs]
>  ? cache_block_group+0x72/0x3b0 [btrfs]
>  cache_block_group+0x1b3/0x3b0 [btrfs]
>  ? finish_wait+0x80/0x80
>  find_free_extent+0x799/0x1010 [btrfs]
>  btrfs_reserve_extent+0x9b/0x180 [btrfs]
>  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
>  __btrfs_cow_block+0x11d/0x500 [btrfs]
>  btrfs_cow_block+0xdc/0x180 [btrfs]
>  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_update_inode_item+0x46/0x100 [btrfs]
>  cache_save_setup+0xe4/0x3a0 [btrfs]
>  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
>  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> 
> At cache_save_setup() we need to update the inode item of a block group's
> cache which is located in the tree root (fs_info->tree_root), which means
> that it may result in COWing a leaf from that tree. If that happens we
> need to find a free metadata extent and while looking for one, if we find
> a block group which was not cached yet we attempt to load its cache by
> calling cache_block_group(). However this function will try to load the
> inode of the free space cache, which requires finding the matching inode
> item in the tree root - if that inode item is located in the same leaf as
> the inode item of the space cache we are updating at cache_save_setup(),
> we end up in a deadlock, since we try to obtain a read lock on the same
> extent buffer that we previously write locked.
> 
> So fix this by skipping the loading of free space caches of any block
> groups that are not yet cached (rare cases) if we are COWing an extent
> buffer from the root tree and space caching is enabled (-o space_cache
> mount option). This is a rare case and its downside is failure to
> find a free extent (return -ENOSPC) when all the already cached block
> groups have no free extents.
> 
> Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Made the solution more generic, since the problem could happen in any
>     path COWing an extent buffer from the root tree.
> 
>     Applies on top of a previous patch titled:
> 
>      "Btrfs: fix deadlock when writing out free space caches"
> 
>  fs/btrfs/ctree.c       |  4 ++++
>  fs/btrfs/ctree.h       |  3 +++
>  fs/btrfs/disk-io.c     |  2 ++
>  fs/btrfs/extent-tree.c | 15 ++++++++++++++-
>  4 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 089b46c4d97f..646aafda55a3 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1065,10 +1065,14 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  	    root == fs_info->chunk_root ||
>  	    root == fs_info->dev_root)
>  		trans->can_flush_pending_bgs = false;
> +	else if (root == fs_info->tree_root)
> +		atomic_inc(&fs_info->tree_root_cows);
>  
>  	cow = btrfs_alloc_tree_block(trans, root, parent_start,
>  			root->root_key.objectid, &disk_key, level,
>  			search_start, empty_size);
> +	if (root == fs_info->tree_root)
> +		atomic_dec(&fs_info->tree_root_cows);

Do we need this though?  Our root should be the root we're cow'ing the block
for, and it should be passed all the way down to find_free_extent properly, so
we really should be able to just do if (root == fs_info->tree_root) and not add
all this stuff.

Not to mention this will race with anybody else doing stuff, so if another
thread that isn't actually touching the tree_root it would skip caching a block
group when it's completely ok for that thread to do it.  Thanks,

Josef
