Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB480C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 11:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A79782075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 11:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NjNp7VOl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A79782075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbeJXUFI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:05:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39146 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbeJXUFI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:05:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id g10-v6so5240810qtq.6
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i+BpTNjyieb5ytlGycR62udmGP+tMkfm8Nq8g/BbRWI=;
        b=NjNp7VOlqrkBZDZcBrXL5LOz2biZ10hft7EWwHHmpO2/vzR0uLay2Wq7DaU+9Iixd+
         XeMAETC/kaUknhuZSNP28n5eNp6Tf751+NBFiBar5OFPqWmIfaJGetRbbQt4smysaJ8U
         6SACV0OiuYP2SgNiutvxY8Yk0Ui/FWO0lzXSqMB5p2Jh8ZyYbfQQmzrGnVJfBbdH7IKp
         Rb021odDnia+eUh5tZCi1WMZAfl1NVHPxoK97pNd0OWGeqJHuWDEj/z+2LHk2dWXvtTY
         tH7REJ9WpaUwvJk4IyewkkjdpD0Z28UOqCCa1PS+SvVwH2uMnDwCCaEhXRDW1nD/YyPd
         YnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i+BpTNjyieb5ytlGycR62udmGP+tMkfm8Nq8g/BbRWI=;
        b=L9F5RH9IWlw/QoR962advRr1OQhNVhkBn8kbYOI4dFJNSWZuQFUvg+lOiPQLo9sfkJ
         Lu7Vy9sxxE7/vLqqTXAHLGHWniQdanPvccOABb+MviYUwks3qVI9aprN4qt8f6APv8FH
         +Q5XDqkmTVXhlbIbefljDv+REPsQ8b/SFisT2bSK82qygRew9aAtKEL5lkjL0gDhWwwI
         6W5TwIR7IMrHBl6yCdVwriZL0H7cRZXYDLvgBVODJgqLuh4AgNFDz4hdYheH8P7kX83V
         YcnrkE7Xmoyi2Sw5YnjWduIh7RvwMyOiFCYCayQCV/xsZEmmDEaXEuOgneIrnUvNRF0+
         lQ+Q==
X-Gm-Message-State: AGRZ1gI49tBLVgsaxJhZzw30iKnSP0FbFYExc7nYzVbcvSdJJC48LMgs
        pZ+HVPm+SAcdUDVfZIac/VWazQ==
X-Google-Smtp-Source: AJdET5cIVg2uLVr4e9BzHFMrvSy0qv5aAvAN+Tw4qEqZ6j1YTlTBrUlwrCO+Y0tNiL3+NLpFSOUBiw==
X-Received: by 2002:a0c:9b89:: with SMTP id o9mr1979975qve.25.1540381041172;
        Wed, 24 Oct 2018 04:37:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b5-v6sm2902911qkf.4.2018.10.24.04.37.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 04:37:20 -0700 (PDT)
Date:   Wed, 24 Oct 2018 07:37:19 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181024091303.20324-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024091303.20324-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 10:13:03AM +0100, fdmanana@kernel.org wrote:
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
> So fix this by using the tree root's commit root when searching for a
> block group's free space cache inode item when we are attempting to load
> a free space cache. This is safe since block groups once loaded stay in
> memory forever, as well as their caches, so after they are first loaded
> we will never need to read their inode items again. For new block groups,
> once they are created they get their ->cached field set to
> BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.
> 
> Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 

Now my goal is to see how many times I can get you to redo this thing.

Why not instead just do 

if (btrfs_is_free_space_inode(inode))
  path->search_commit_root = 1;

in read_locked_inode?  That would be cleaner.  If we don't want to do that for
the inode cache (I'm not sure if it's ok or not) we could just do

if (root == fs_info->tree_root)

instead.  Thanks,

Josef
