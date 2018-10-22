Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B6BC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD25020651
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OywUSvS8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD25020651
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbeJWDLM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbeJWDLM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:11:12 -0400
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2204D20663
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540234291;
        bh=RmfzLYtTIFRIYaiVgU8b84uB+OF5fkwliBQPaJsfoMg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OywUSvS8e/zzhAmwpy8F6B4oJazGQeOJAnUehfE22IMei6Y4OXBHRWmJg39psTktB
         wVu1mmgHh8Z00H/yraJskKBBghFtoCzUOUK8VRW6D8PVCOyzdE0WsrnFOsUu634SNl
         DBipGouVNdg0OlZ8TzVQ3qZlDLRiKSKmtl5h/qqE=
Received: by mail-vs1-f51.google.com with SMTP id r83so30289940vsc.4
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 11:51:29 -0700 (PDT)
X-Gm-Message-State: ABuFfojXXmneR9QjWSvYve7viBXx/7+DHL9uTDFkYAJajP2LIu/o8ONO
        VtwIjV3OjmwampVahViPEF9GX/MQDNkVMX2gX/I=
X-Google-Smtp-Source: ACcGV60R4WmQ+1CgBPM1E/wUstpOY1RC9CQwsdhP+O6XKyGmv6zDMCwy7e0p7L9rqQCftmHl+OnOUTlzOn9sY9xrlVs=
X-Received: by 2002:a67:4c55:: with SMTP id z82mr9424904vsa.99.1540234288975;
 Mon, 22 Oct 2018 11:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181022180708.4x22arwdryxgkebz@destiny>
In-Reply-To: <20181022180708.4x22arwdryxgkebz@destiny>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 22 Oct 2018 19:51:17 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4-nhTcBc3K_XkhGgcYxG_Cko-Ncbz9gPoiokkb=wAU9Q@mail.gmail.com>
Message-ID: <CAL3q7H4-nhTcBc3K_XkhGgcYxG_Cko-Ncbz9gPoiokkb=wAU9Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock on tree root leaf when finding free extent
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 7:07 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Mon, Oct 22, 2018 at 10:09:46AM +0100, fdmanana@kernel.org wrote:
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
> > groups that are not yet cached (rare cases) if we are updating the inode
> > of a free space cache. This is a rare case and its downside is failure to
> > find a free extent (return -ENOSPC) when all the already cached block
> > groups have no free extents.
> >
>
> Actually isn't this a problem for anything that tries to allocate an extent
> while in the tree_root?  Like we snapshot or make a subvolume or anything?

Indeed. Initially I considered making it more generic (like the recent
fix for deadlock when cowing from extent/chunk/device tree) but I
totally forgot about the other cases like you mentioned.

>  We
> should just disallow if root == tree_root.  But even then we only need to do
> this if we're using SPACE_CACHE, using the ye-olde caching or the free space
> tree are both ok.  Let's just limit it to those cases.  Thanks,

Yep, makes all sense.

Thanks! V2 sent out.

>
> Josef
