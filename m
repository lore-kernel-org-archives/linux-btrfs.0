Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F0DC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D8E205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="n8w637gV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9D8E205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbeJWC0q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:26:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42019 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbeJWC0q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 22:26:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id j46-v6so47390407qtc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 11:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BnSEM5Yxn/whgbK4X3EFuYeSK4jMxHMpE3wKoT2pvtA=;
        b=n8w637gVRsKR51ZwaaIVT0MTdpGW0d18BU7W/2IxkcAbxIvHG7fKEV5Jktj82Ob+j1
         W/f92PG1nMB1wc7zb2ioMFp5qDSpDl1XJnmShJz1Ws7jLZUOThxB5gjL/Bd/ev4U3ldR
         KTJpT1Twk6sx4oSZVWISRWYbEs9ghyuccHfpxeEmtBZYmSjvzZv3omrEHZhFft4RlNQk
         LF6uIgmbwjI1oxh0AxsRBsK1Whk8zDqjNOx+mAtmCHxsWqZ/SjQmXPWrl6EqfrMqoD9Y
         peGm1WAcPB5te2KJjRZCpj0RlivtgAcxKLTI2iIK+vBXCEzEgsnMHdkhC2tbshZEG5tq
         FY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BnSEM5Yxn/whgbK4X3EFuYeSK4jMxHMpE3wKoT2pvtA=;
        b=WUrTXl8mM4tJcMFJ0XKXxaltl2/RUmL6T/fznp7ZGHgI+/qvmz9gdKrSuf6tr3vDS+
         mp1vAyohbc3LMOE2E97m7A5BztSaYiwf4xVCRFKOAO+GGuAOqUEnQtAHMSaZsaQH/EP0
         bdS0uUoy568aHg8ethVmLTDPKFsSqlsab3/hCITn9QsCRfvfZHB6O7NnTLZ4z7WP0Jew
         VDJMhr1JgzgzDI+bGPdJ7babrVNYpTB4bTNganOxNyhu6e9DIBSMBjvWLr/2MhQFDQz9
         qOThsOazwpEtNY8qEGkPuVyWvDwFVACYAlXJwJO+QyKrGaYW/sbOpCidadg/+9k65i2v
         44HQ==
X-Gm-Message-State: ABuFfohBUmaqQGSyy03Jf8/8AEhctHZhqprrZ7+Na9VtWU5B0WI+gcfA
        X1R+r5LMsZu17Atdd9cJPdqU/t6nn1vF9Q==
X-Google-Smtp-Source: ACcGV63CptDnLqQ+dECoxnY0zXv1z0Q+HX+xFelC67sIYq2p3x2YLXHeAD+j6t/dSyWA7Q8dwdt6Ag==
X-Received: by 2002:aed:3968:: with SMTP id l95-v6mr42837807qte.96.1540231631765;
        Mon, 22 Oct 2018 11:07:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r186-v6sm2680272qkd.13.2018.10.22.11.07.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 11:07:10 -0700 (PDT)
Date:   Mon, 22 Oct 2018 14:07:09 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix deadlock on tree root leaf when finding free
 extent
Message-ID: <20181022180708.4x22arwdryxgkebz@destiny>
References: <20181022090946.1150-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022090946.1150-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 10:09:46AM +0100, fdmanana@kernel.org wrote:
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
> groups that are not yet cached (rare cases) if we are updating the inode
> of a free space cache. This is a rare case and its downside is failure to
> find a free extent (return -ENOSPC) when all the already cached block
> groups have no free extents.
> 

Actually isn't this a problem for anything that tries to allocate an extent
while in the tree_root?  Like we snapshot or make a subvolume or anything?  We
should just disallow if root == tree_root.  But even then we only need to do
this if we're using SPACE_CACHE, using the ye-olde caching or the free space
tree are both ok.  Let's just limit it to those cases.  Thanks,

Josef
