Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2CFECDE44
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 23:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBDB2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 23:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hq+P/Jdi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEBDB2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbeJYI2U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 04:28:20 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39846 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbeJYI2U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 04:28:20 -0400
Received: by mail-yw1-f68.google.com with SMTP id v1-v6so2848659ywv.6
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 16:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Le8/8mhCubDW0HVezWy/KAiarIkc/YVrlb+5C6v4F88=;
        b=hq+P/Jdip190lMxs55ZoH0BmjPZnYY0XS4vCGt+ZfnzD4gZX5DscFBalAxV5K7bgGQ
         lB2aRd7jWB97EhsQvA/rSjAF/qE47Kp5zvHTkBcyMqJda0Ndeu5J2VFmYE2/iPnW4sMU
         3cWzomr95UGpvuI+b1yoNAb4el6hFjEEeKMRPy0bXJRHkzbDW6jl3/e9bHfDKNiPuPME
         VIwwU1JXAi2JplSi8n7m+itn5XNqrEp/MuE3GlokqS/pW/te3arzZcQ6mlMbzCiobXxl
         QsvobQOkkRB/hkKBClWj3/ENwenj/Zlk04tZj4FYR2fPgwo9i0UPoCRvriaAYUCKaigz
         eabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Le8/8mhCubDW0HVezWy/KAiarIkc/YVrlb+5C6v4F88=;
        b=tP6GJXlvP4TYDtowIiCE1vfX4NAnJhaSc7eyeY7mx1jjtKj3lsZMzV2wV9ZAtt43sE
         iXgiP5bkQNo4fsDZa0q2PL6pl/ENKqVRA6B2hkIUrdQYdfbX/2L3sV2MI86YGQ3SHz3+
         ulzLGpCI06i7977qVW0K/XaUbgDZv4xqmPF1FRbXUn9Z4UWgHEzeIxn7jSk95N75naaK
         HVdgjBGsCzWKwVJ2H5xwSZlSZP3HE4jGC3ZijMqmU2RZgPFttJkMa1XCk6krN1CkIaec
         W/lgyN8SkDgVwZEei11L1h+fX2gmhXz6Sb7TJdpRnk39J+oVLQeCFUVVzci0LGviWvOR
         XLPA==
X-Gm-Message-State: AGRZ1gKes0u9qzHAtKTR8Y4VB8caNSE73+aUv+/GYq5Qdk8AOSsaicq5
        c9M3AuEAHWnMlh6DlcpS7LZqtg==
X-Google-Smtp-Source: AJdET5cMNuODiiU6kws2LiMJVM1cacIafAe/0z05WyyV/HEAcXXWjNF2kDylWgRkKoRl5s4XsGSkiA==
X-Received: by 2002:a81:441e:: with SMTP id r30-v6mr4339820ywa.48.1540425489114;
        Wed, 24 Oct 2018 16:58:09 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:600d])
        by smtp.gmail.com with ESMTPSA id b66-v6sm2242325ywf.31.2018.10.24.16.58.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 16:58:08 -0700 (PDT)
Date:   Wed, 24 Oct 2018 19:58:07 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181024235805.6fy4n2kryh7esbcg@macbook-pro-91.dhcp.thefacebook.com>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
 <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
 <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local>
 <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 01:48:40PM +0100, Filipe Manana wrote:
> On Wed, Oct 24, 2018 at 1:40 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > On Wed, Oct 24, 2018 at 12:53:59PM +0100, Filipe Manana wrote:
> > > On Wed, Oct 24, 2018 at 12:37 PM Josef Bacik <josef@toxicpanda.com> wrote:
> > > >
> > > > On Wed, Oct 24, 2018 at 10:13:03AM +0100, fdmanana@kernel.org wrote:
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > When we are writing out a free space cache, during the transaction commit
> > > > > phase, we can end up in a deadlock which results in a stack trace like the
> > > > > following:
> > > > >
> > > > >  schedule+0x28/0x80
> > > > >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> > > > >  ? finish_wait+0x80/0x80
> > > > >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > > > >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> > > > >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> > > > >  ? inode_insert5+0x119/0x190
> > > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > > >  btrfs_iget+0x113/0x690 [btrfs]
> > > > >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> > > > >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> > > > >  load_free_space_cache+0x7c/0x170 [btrfs]
> > > > >  ? cache_block_group+0x72/0x3b0 [btrfs]
> > > > >  cache_block_group+0x1b3/0x3b0 [btrfs]
> > > > >  ? finish_wait+0x80/0x80
> > > > >  find_free_extent+0x799/0x1010 [btrfs]
> > > > >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > > > >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> > > > >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> > > > >  btrfs_cow_block+0xdc/0x180 [btrfs]
> > > > >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> > > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > > >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> > > > >  cache_save_setup+0xe4/0x3a0 [btrfs]
> > > > >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> > > > >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> > > > >
> > > > > At cache_save_setup() we need to update the inode item of a block group's
> > > > > cache which is located in the tree root (fs_info->tree_root), which means
> > > > > that it may result in COWing a leaf from that tree. If that happens we
> > > > > need to find a free metadata extent and while looking for one, if we find
> > > > > a block group which was not cached yet we attempt to load its cache by
> > > > > calling cache_block_group(). However this function will try to load the
> > > > > inode of the free space cache, which requires finding the matching inode
> > > > > item in the tree root - if that inode item is located in the same leaf as
> > > > > the inode item of the space cache we are updating at cache_save_setup(),
> > > > > we end up in a deadlock, since we try to obtain a read lock on the same
> > > > > extent buffer that we previously write locked.
> > > > >
> > > > > So fix this by using the tree root's commit root when searching for a
> > > > > block group's free space cache inode item when we are attempting to load
> > > > > a free space cache. This is safe since block groups once loaded stay in
> > > > > memory forever, as well as their caches, so after they are first loaded
> > > > > we will never need to read their inode items again. For new block groups,
> > > > > once they are created they get their ->cached field set to
> > > > > BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.
> > > > >
> > > > > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > > > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > > > > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > > > > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > > ---
> > > > >
> > > >
> > > > Now my goal is to see how many times I can get you to redo this thing.
> > > >
> > > > Why not instead just do
> > > >
> > > > if (btrfs_is_free_space_inode(inode))
> > > >   path->search_commit_root = 1;
> > > >
> > > > in read_locked_inode?  That would be cleaner.  If we don't want to do that for
> > > > the inode cache (I'm not sure if it's ok or not) we could just do
> > > >
> > > > if (root == fs_info->tree_root)
> > >
> > > We can't (not just that at least).
> > > Tried something like that, but we get into a BUG_ON when writing out
> > > the space cache for new block groups (created in the current
> > > transaction).
> > > Because at cache_save_setup() we have this:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/extent-tree.c?h=v4.19#n3342
> > >
> > > Lookup for the inode in normal root, doesn't exist, create it then
> > > repeat - if still not found, BUG_ON.
> > > Could also make create_free_space_inode() return an inode pointer and
> > > make it call btrfs_iget().
> > >
> >
> > Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
> > take a path, and allocate it in btrfs_iget, that'll remove the ugly
> >
> > if (path != in_path)
> 
> You mean the following on top of v4:
> 
> https://friendpaste.com/6XrGXb5p0RSJGixUFYouHg
> 
> Not much different, just saves one such if statement. I'm ok with that.
> 

Yeah ok, thanks,

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
