Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144F7C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 22:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02EEE20651
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 22:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKewEajy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02EEE20651
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbeJWGZo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbeJWGZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 02:25:44 -0400
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08EBA20665
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 22:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540245921;
        bh=8LVyl8CDg7ImQhIPOGMLHbObb7rRLOmRf3s4LN4MBc8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rKewEajyFqyP7whPgjjpq0xv4rklFo9LIh4vFO8lpfQumUstSYJwWpmz/XnvpILbQ
         kCZRgKC/hl5dXJ5M9VbjjI3JuPK9s0jaiJDnKlAgHCUcpQpYUOFkQpuAc5YokTd0+k
         KpVNOnsL//9Uv1cUtjPG2KtpZljyfRv/fIEVFBWI=
Received: by mail-vs1-f41.google.com with SMTP id l6so906205vsj.13
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 15:05:20 -0700 (PDT)
X-Gm-Message-State: ABuFfohU8HVi5uII4GVE/CROOk/+f3XI1/CetLJF831zLP1RFAELeN3i
        xlxYuGv0s26OZNcXqgFran6HIQWyN1RH2TXsWyw=
X-Google-Smtp-Source: ACcGV62vJ4U5Wdp2QIjdz2TPIpIq+NfenJxVO1lbWQMyMHN8750YSkEOwSIYUXpd30m5SSafoBr7ByJPjAWK4Eo+yGg=
X-Received: by 2002:a67:4c55:: with SMTP id z82mr9681986vsa.99.1540245919834;
 Mon, 22 Oct 2018 15:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181022191037.18471-1-fdmanana@kernel.org>
 <20181022191848.awvitym7tw24kpgx@destiny>
In-Reply-To: <20181022191848.awvitym7tw24kpgx@destiny>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 22 Oct 2018 23:05:08 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5Fk3+jh+jaMHkJpSZ5VdNJTN=nNTEiKyqRPerRRkqP7g@mail.gmail.com>
Message-ID: <CAL3q7H5Fk3+jh+jaMHkJpSZ5VdNJTN=nNTEiKyqRPerRRkqP7g@mail.gmail.com>
Subject: Re: [PATCH v3] Btrfs: fix deadlock on tree root leaf when finding
 free extent
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 8:18 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Mon, Oct 22, 2018 at 08:10:37PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When we are writing out a free space cache, during the transaction commit
> > phase, we can end up in a deadlock which results in a stack trace like the
> > following:
> >
> >  schedule+0x28/0x80
> >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> >  ? finish_wait+0x80/0x80
> >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> >  ? inode_insert5+0x119/0x190
> >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> >  ? kmem_cache_alloc+0x166/0x1d0
> >  btrfs_iget+0x113/0x690 [btrfs]
> >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> >  load_free_space_cache+0x7c/0x170 [btrfs]
> >  ? cache_block_group+0x72/0x3b0 [btrfs]
> >  cache_block_group+0x1b3/0x3b0 [btrfs]
> >  ? finish_wait+0x80/0x80
> >  find_free_extent+0x799/0x1010 [btrfs]
> >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> >  btrfs_cow_block+0xdc/0x180 [btrfs]
> >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> >  ? kmem_cache_alloc+0x166/0x1d0
> >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> >  cache_save_setup+0xe4/0x3a0 [btrfs]
> >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> >
> > At cache_save_setup() we need to update the inode item of a block group's
> > cache which is located in the tree root (fs_info->tree_root), which means
> > that it may result in COWing a leaf from that tree. If that happens we
> > need to find a free metadata extent and while looking for one, if we find
> > a block group which was not cached yet we attempt to load its cache by
> > calling cache_block_group(). However this function will try to load the
> > inode of the free space cache, which requires finding the matching inode
> > item in the tree root - if that inode item is located in the same leaf as
> > the inode item of the space cache we are updating at cache_save_setup(),
> > we end up in a deadlock, since we try to obtain a read lock on the same
> > extent buffer that we previously write locked.
> >
> > So fix this by skipping the loading of free space caches of any block
> > groups that are not yet cached (rare cases) if we are COWing an extent
> > buffer from the root tree and space caching is enabled (-o space_cache
> > mount option). This is a rare case and its downside is failure to
> > find a free extent (return -ENOSPC) when all the already cached block
> > groups have no free extents.
> >
> > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Great, thanks,
>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

So this makes many fstests occasionally fail with aborted transaction
due to ENOSPC.
It's late and I haven't verified yet, but I suppose this is because we
always skip loading the cache regardless of currently being COWing an
existing leaf or allocating a new one (growing the tree).
Needs to be fixed.

>
> Josef
