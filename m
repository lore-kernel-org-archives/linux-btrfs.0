Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD5CC004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57E612064A
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zFqgg3Z9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57E612064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbeJXVIC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 17:08:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41872 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbeJXVIC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 17:08:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id g13-v6so2994313qke.8
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 05:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W8TaJ1XNor4ngOYJH8OCIsY84dcYS5fRi9lP6xI1UmU=;
        b=zFqgg3Z9em16IhCrOdICvLHNmvTwjcaFEeLT8rM/26XZJSwZyCVSIE86ldiN10/erQ
         UtSUTCAyvtQqiShXfLGhhcBk6QGV+VeFwJLJ8fPRfDrONTlJm4JtyMvWz2y6Rc/dw2US
         82IDNrqcYSEOcfdg36Kd2c0CooWC6CxxKBfleOHNNuVm2/sbcrEgUNcOgixsMcOdAt2H
         EkDnbFj8cpLcMX9d8qF5SrTxddDqVUG90WU8dpuksAu8I8MlUf0H3E8ZfeL5I0mt2ovb
         970Wi+prSMpw8+3zPRprwoG6Upg99vcqa11aBSwtnaTAZWbtgK+TNQdcMvkaSsCuq2ch
         QaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W8TaJ1XNor4ngOYJH8OCIsY84dcYS5fRi9lP6xI1UmU=;
        b=rnja7d+qyDlyfY4VG3pclZCDmAjmZY1A2rCPRTvgSi3xLGDOmf+54Lc1I8bFGqbKnx
         Kcz12GV2NuuOMhi8T9oVNR3v0WLFqj6RzW1EPSGUiJf0Bu1YkRvzhASriqKiv+JtM3eH
         9yQI1ah5BQOnzu+d+blexp8BcqAwJNihoS3zK77IR5vp7hM7BzgOKsY6VWXfBGSAn2N6
         cEW+91NG96wIy407qNQ4ZA1Rv5Z94slQChoGssdAj8+lE+uScvcZYsOmYnCr7wwWidkS
         ggxaWE33j1Hr2uG3wWWuJs/Sosp4KWiR/upyjnd9xz+8TJPM1dsPJA70sIWMYqleWvJb
         /+xA==
X-Gm-Message-State: AGRZ1gJJCDTxKGlgmCivyWNb9w6XoMWFeQNGJpIct9IwmWV4WwdSljcm
        uTxonQoSUe1NSRl60k5qFKNMqt0SyHpN0A==
X-Google-Smtp-Source: AJdET5cHkCPfukYieSX2hLJwI22E5lfaZ8xPgES/Gdk/DRoxN1dJ4eIongU7GfZMdESXwcGq795rdw==
X-Received: by 2002:a37:72c1:: with SMTP id n184-v6mr2163604qkc.133.1540384803083;
        Wed, 24 Oct 2018 05:40:03 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q51-v6sm6642418qtq.6.2018.10.24.05.40.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 05:40:02 -0700 (PDT)
Date:   Wed, 24 Oct 2018 08:40:00 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
 <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 12:53:59PM +0100, Filipe Manana wrote:
> On Wed, Oct 24, 2018 at 12:37 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > On Wed, Oct 24, 2018 at 10:13:03AM +0100, fdmanana@kernel.org wrote:
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
> > > So fix this by using the tree root's commit root when searching for a
> > > block group's free space cache inode item when we are attempting to load
> > > a free space cache. This is safe since block groups once loaded stay in
> > > memory forever, as well as their caches, so after they are first loaded
> > > we will never need to read their inode items again. For new block groups,
> > > once they are created they get their ->cached field set to
> > > BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.
> > >
> > > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >
> >
> > Now my goal is to see how many times I can get you to redo this thing.
> >
> > Why not instead just do
> >
> > if (btrfs_is_free_space_inode(inode))
> >   path->search_commit_root = 1;
> >
> > in read_locked_inode?  That would be cleaner.  If we don't want to do that for
> > the inode cache (I'm not sure if it's ok or not) we could just do
> >
> > if (root == fs_info->tree_root)
> 
> We can't (not just that at least).
> Tried something like that, but we get into a BUG_ON when writing out
> the space cache for new block groups (created in the current
> transaction).
> Because at cache_save_setup() we have this:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/extent-tree.c?h=v4.19#n3342
> 
> Lookup for the inode in normal root, doesn't exist, create it then
> repeat - if still not found, BUG_ON.
> Could also make create_free_space_inode() return an inode pointer and
> make it call btrfs_iget().
> 

Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
take a path, and allocate it in btrfs_iget, that'll remove the ugly

if (path != in_path)

stuff.  Thanks,

Josef
