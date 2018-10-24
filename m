Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0248FC004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC39320651
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WJLYmT4K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC39320651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbeJXMes (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:34:48 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36747 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeJXMer (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:34:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id q184-v6so2338496qkd.3
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 21:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UfT8d/PWxRStfdSqPQHL3KYkSNpdlCVP5hz2NrKt1LU=;
        b=WJLYmT4KNgcVJKX3vVaGbqhtiuQ7rZx72O7VZ3Lewsj9/SAddlepIRAJEEMntL11U0
         ebJ0fjf3352QzpNiel3vfwYmToPUOzAIOGxBg2JA7uZbNf6x8JPYlYHf2W4V4JL2oYhN
         RpAgpxeg+vfC8cCifwcf44bJfw4INjgd/ryYIxYVLlI4g5tFbMwE5gRxmWq0KL7oyGGO
         EhQLbzsabLdVKtfwMIqENnYO4SyDArgsrgxsMVWlEGMcZWzPBIa7pbgezdGwqKLA27NN
         cwxW+2l5AIe/Y+3qIx314/4sodCOMRD73ofLBdw5rsb9gUtCsL9rUEDDlKqOpQ/M0gdl
         ic5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UfT8d/PWxRStfdSqPQHL3KYkSNpdlCVP5hz2NrKt1LU=;
        b=f+Iosz1rKzpCf8eaDiHTJf493cYh5SsgMmOFWTgWr4nU+byXl3pbISAqaSiE9uPtkF
         sfFaRwgiSPQYcTvABUhSaCmTT4LAprl1g4ghgGVL0Ei4DTYFFGYmtqzjeC/mVtxzr3cE
         WNRE4G4JRtcLs5DFBDBiEfKz9+e0vZ4JQ5U+6WbbgKDzkNdYtdt8g+6Rw19ctDPbCbqr
         2q4ROE8uu549P2IXgjN7TQUtRUWYuCTGDmW8UtqD4v1rJ3za+TQKlOmXByyOZSXdt2B9
         ajW6ECPMujgJUOJ/xi3AIvKCcWRlr0/50Y4QSwXhmmuGKN0nnxNaPcr0g43eSImUxmN8
         Rmtg==
X-Gm-Message-State: AGRZ1gKXoMCdWbhvH5btOhedmYVfDjhn4xiObmb3JCC0t4/9K6Cl9oYc
        HEAgWGNXYGjkH/q9TpJeP0efa3HsIZQOPg==
X-Google-Smtp-Source: AJdET5e5gtClFOAv9GkWXolRU7N9caxm9TRi+yBIGP8sbxfH0q/iy5ilnryCjx5S39knVk4GACCP8Q==
X-Received: by 2002:a37:86c1:: with SMTP id i184-v6mr842078qkd.209.1540354107750;
        Tue, 23 Oct 2018 21:08:27 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s71-v6sm2756581qkl.86.2018.10.23.21.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 21:08:26 -0700 (PDT)
Date:   Wed, 24 Oct 2018 00:08:25 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181024040228.3gpipdaohezdsrm2@MacBook-Pro-91.local>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181022191037.18471-1-fdmanana@kernel.org>
 <20181022191848.awvitym7tw24kpgx@destiny>
 <CAL3q7H5Fk3+jh+jaMHkJpSZ5VdNJTN=nNTEiKyqRPerRRkqP7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5Fk3+jh+jaMHkJpSZ5VdNJTN=nNTEiKyqRPerRRkqP7g@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 11:05:08PM +0100, Filipe Manana wrote:
> On Mon, Oct 22, 2018 at 8:18 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > On Mon, Oct 22, 2018 at 08:10:37PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > When we are writing out a free space cache, during the transaction commit
> > > phase, we can end up in a deadlock which results in a stack trace like the
> > > following:
> > >
> > >  schedule+0x28/0x80
> > >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> > >  ? finish_wait+0x80/0x80
> > >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> > >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> > >  ? inode_insert5+0x119/0x190
> > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > >  ? kmem_cache_alloc+0x166/0x1d0
> > >  btrfs_iget+0x113/0x690 [btrfs]
> > >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> > >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> > >  load_free_space_cache+0x7c/0x170 [btrfs]
> > >  ? cache_block_group+0x72/0x3b0 [btrfs]
> > >  cache_block_group+0x1b3/0x3b0 [btrfs]
> > >  ? finish_wait+0x80/0x80
> > >  find_free_extent+0x799/0x1010 [btrfs]
> > >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> > >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> > >  btrfs_cow_block+0xdc/0x180 [btrfs]
> > >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > >  ? kmem_cache_alloc+0x166/0x1d0
> > >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> > >  cache_save_setup+0xe4/0x3a0 [btrfs]
> > >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> > >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> > >
> > > At cache_save_setup() we need to update the inode item of a block group's
> > > cache which is located in the tree root (fs_info->tree_root), which means
> > > that it may result in COWing a leaf from that tree. If that happens we
> > > need to find a free metadata extent and while looking for one, if we find
> > > a block group which was not cached yet we attempt to load its cache by
> > > calling cache_block_group(). However this function will try to load the
> > > inode of the free space cache, which requires finding the matching inode
> > > item in the tree root - if that inode item is located in the same leaf as
> > > the inode item of the space cache we are updating at cache_save_setup(),
> > > we end up in a deadlock, since we try to obtain a read lock on the same
> > > extent buffer that we previously write locked.
> > >
> > > So fix this by skipping the loading of free space caches of any block
> > > groups that are not yet cached (rare cases) if we are COWing an extent
> > > buffer from the root tree and space caching is enabled (-o space_cache
> > > mount option). This is a rare case and its downside is failure to
> > > find a free extent (return -ENOSPC) when all the already cached block
> > > groups have no free extents.
> > >
> > > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >
> > Great, thanks,
> >
> > Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> 
> So this makes many fstests occasionally fail with aborted transaction
> due to ENOSPC.
> It's late and I haven't verified yet, but I suppose this is because we
> always skip loading the cache regardless of currently being COWing an
> existing leaf or allocating a new one (growing the tree).
> Needs to be fixed.
> 

How about we just use path->search_commit_root?  If we're loading the cache we
just want the last committed version, it's not like we read it after we've
written it.  Then we can go back to business as usual.  Thanks,

Josef
