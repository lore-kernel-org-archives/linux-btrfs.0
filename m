Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6D1C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 11:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C072620824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 11:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnUkJGd0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C072620824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbeJXUWB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbeJXUWB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:22:01 -0400
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E370720824
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540382052;
        bh=Iw198AoA/6hvL0vAo0pIxWoZhWJCyovF9IF61EZ8oC0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qnUkJGd0a5ukHFc/Uy+WQXXy2dFHWN283LWkq8FJEeP95vhu1ewdKoVIs111WNvRH
         7+CWFB3CTsGPhfUpQiIp1Zs8grMdMvAaIsQXx9seVEQKfqqIbEmbURamRDH92QIWMK
         bK95MmLvn4t44G/Tw5Mx9jyPWVTM4EQQ3ZFQt4b4=
Received: by mail-vk1-f175.google.com with SMTP id b207so1168132vke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:54:11 -0700 (PDT)
X-Gm-Message-State: AGRZ1gLC2Rac47UhOPhsdJ4IPvCdbsCWWiL1Sb7ARABDeH/gLbc8DZYH
        RpAsugPLDnqe3oTlSLWbal9Js6TpOQjqzfOhTOU=
X-Google-Smtp-Source: AJdET5fyUkU5l7OtcVX7YfcMhAWEHyF6hOsaUXlxjBJDbKYSEMwrFrPZ8oMcvb7HL5NaCUCDzSlTBMKqam7PaFG1404=
X-Received: by 2002:a1f:850a:: with SMTP id h10-v6mr981796vkd.4.1540382051018;
 Wed, 24 Oct 2018 04:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
In-Reply-To: <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 24 Oct 2018 12:53:59 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
Message-ID: <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 12:37 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Wed, Oct 24, 2018 at 10:13:03AM +0100, fdmanana@kernel.org wrote:
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
> > So fix this by using the tree root's commit root when searching for a
> > block group's free space cache inode item when we are attempting to load
> > a free space cache. This is safe since block groups once loaded stay in
> > memory forever, as well as their caches, so after they are first loaded
> > we will never need to read their inode items again. For new block groups,
> > once they are created they get their ->cached field set to
> > BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.
> >
> > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
>
> Now my goal is to see how many times I can get you to redo this thing.
>
> Why not instead just do
>
> if (btrfs_is_free_space_inode(inode))
>   path->search_commit_root = 1;
>
> in read_locked_inode?  That would be cleaner.  If we don't want to do that for
> the inode cache (I'm not sure if it's ok or not) we could just do
>
> if (root == fs_info->tree_root)

We can't (not just that at least).
Tried something like that, but we get into a BUG_ON when writing out
the space cache for new block groups (created in the current
transaction).
Because at cache_save_setup() we have this:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/extent-tree.c?h=v4.19#n3342

Lookup for the inode in normal root, doesn't exist, create it then
repeat - if still not found, BUG_ON.
Could also make create_free_space_inode() return an inode pointer and
make it call btrfs_iget().

>
> instead.  Thanks,
>
> Josef
