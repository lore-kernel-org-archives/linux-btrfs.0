Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976D0C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 09:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3687D2075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 09:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qgqYJyR6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3687D2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbeJXRec (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbeJXRec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 13:34:32 -0400
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588C92082E
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 09:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540372035;
        bh=RsQKSS/UTCDnNbMgIPMOgokyh2iCsEDBF7Duf7QXeeU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qgqYJyR6965yxGjabDTk/skxbRBKzQ1e7ldJxXmnHu8339iOwt06+Mf2gk9ArffrC
         FlexpgvnakQ69p7H0R0kIZ+WcIcl8lkrbMjOkINVVfsUWuVbA0B9zwqJmwPX63HNGn
         Xdb8KhENYSDGQqLVpzmFQ+hhO1IYP0KT/8N2iEP0=
Received: by mail-ua1-f53.google.com with SMTP id z8so1571472uap.13
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 02:07:15 -0700 (PDT)
X-Gm-Message-State: AGRZ1gJaDXHehT7lSl/Jyy8haIB00wIisLPr/tqECqqkZ2ybhRMQW2iO
        tuGCmK5bJ0oYqADyoP0KfFaRE5EoFxUQRuFdbGY=
X-Google-Smtp-Source: AJdET5cw9JKR23aGyRAnP0D8SOBYYMxnezVZ3gALUhPP25Etp7lTJC0bIeiHApe5W+ILqQcrrepjyL98Ctb/tpu3foA=
X-Received: by 2002:ab0:2101:: with SMTP id d1mr720103ual.108.1540372034432;
 Wed, 24 Oct 2018 02:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181022191037.18471-1-fdmanana@kernel.org>
 <20181022191848.awvitym7tw24kpgx@destiny> <CAL3q7H5Fk3+jh+jaMHkJpSZ5VdNJTN=nNTEiKyqRPerRRkqP7g@mail.gmail.com>
 <20181024040228.3gpipdaohezdsrm2@MacBook-Pro-91.local>
In-Reply-To: <20181024040228.3gpipdaohezdsrm2@MacBook-Pro-91.local>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 24 Oct 2018 10:07:02 +0100
X-Gmail-Original-Message-ID: <CAL3q7H43pT85PG3dEvNKP5W1puPxfS3xY4PL0-zJ7Ku3RBUWxQ@mail.gmail.com>
Message-ID: <CAL3q7H43pT85PG3dEvNKP5W1puPxfS3xY4PL0-zJ7Ku3RBUWxQ@mail.gmail.com>
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

On Wed, Oct 24, 2018 at 5:08 AM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Mon, Oct 22, 2018 at 11:05:08PM +0100, Filipe Manana wrote:
> > On Mon, Oct 22, 2018 at 8:18 PM Josef Bacik <josef@toxicpanda.com> wrote:
> > >
> > > On Mon, Oct 22, 2018 at 08:10:37PM +0100, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > When we are writing out a free space cache, during the transaction commit
> > > > phase, we can end up in a deadlock which results in a stack trace like the
> > > > following:
> > > >
> > > >  schedule+0x28/0x80
> > > >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > > >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> > > >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> > > >  ? inode_insert5+0x119/0x190
> > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > >  btrfs_iget+0x113/0x690 [btrfs]
> > > >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> > > >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> > > >  load_free_space_cache+0x7c/0x170 [btrfs]
> > > >  ? cache_block_group+0x72/0x3b0 [btrfs]
> > > >  cache_block_group+0x1b3/0x3b0 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  find_free_extent+0x799/0x1010 [btrfs]
> > > >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > > >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> > > >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> > > >  btrfs_cow_block+0xdc/0x180 [btrfs]
> > > >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> > > >  cache_save_setup+0xe4/0x3a0 [btrfs]
> > > >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> > > >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> > > >
> > > > At cache_save_setup() we need to update the inode item of a block group's
> > > > cache which is located in the tree root (fs_info->tree_root), which means
> > > > that it may result in COWing a leaf from that tree. If that happens we
> > > > need to find a free metadata extent and while looking for one, if we find
> > > > a block group which was not cached yet we attempt to load its cache by
> > > > calling cache_block_group(). However this function will try to load the
> > > > inode of the free space cache, which requires finding the matching inode
> > > > item in the tree root - if that inode item is located in the same leaf as
> > > > the inode item of the space cache we are updating at cache_save_setup(),
> > > > we end up in a deadlock, since we try to obtain a read lock on the same
> > > > extent buffer that we previously write locked.
> > > >
> > > > So fix this by skipping the loading of free space caches of any block
> > > > groups that are not yet cached (rare cases) if we are COWing an extent
> > > > buffer from the root tree and space caching is enabled (-o space_cache
> > > > mount option). This is a rare case and its downside is failure to
> > > > find a free extent (return -ENOSPC) when all the already cached block
> > > > groups have no free extents.
> > > >
> > > > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > > > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > > > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > >
> > > Great, thanks,
> > >
> > > Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> >
> > So this makes many fstests occasionally fail with aborted transaction
> > due to ENOSPC.
> > It's late and I haven't verified yet, but I suppose this is because we
> > always skip loading the cache regardless of currently being COWing an
> > existing leaf or allocating a new one (growing the tree).
> > Needs to be fixed.
> >
>
> How about we just use path->search_commit_root?  If we're loading the cache we
> just want the last committed version, it's not like we read it after we've
> written it.  Then we can go back to business as usual.  Thanks,

Yeah, that works. It was an idea before sending v1 but it felt a bit
dirty at the time.
Left fstests running overnight using the commit root approach and
everything seems fine. Sending a v4.

Another alternative, which would solve similar problems for any tree,
would be to allow getting a read lock on an
already (spin) write locked eb, just like we do for blocking write
locks:  https://friendpaste.com/6XrGXb5p0RSJGixUFZ8lCt

thanks


>
> Josef
