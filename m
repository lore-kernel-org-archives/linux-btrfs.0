Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbdLLSD7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 13:03:59 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26552AF6E
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 18:03:58 +0000 (UTC)
Date: Tue, 12 Dec 2017 19:01:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        jeffm@suse.com
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
Message-ID: <20171212180157.GO3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171212073436.16447-1-wqu@suse.com>
 <4c56a262-51fb-b66d-3d1b-f4b0a906cef5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4c56a262-51fb-b66d-3d1b-f4b0a906cef5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 12, 2017 at 04:16:08PM +0200, Nikolay Borisov wrote:
> 
> 
> On 12.12.2017 09:34, Qu Wenruo wrote:
> > [Overall]
> > The previous rework on qgroup reservation system put a lot of effort on
> > data, which works quite fine.
> > 
> > But it takes less focus on metadata reservation, causing some problem
> > like metadata reservation underflow and noisy kernel warning.
> > 
> > This patchset will try to address the remaining problem of metadata
> > reservation.
> > 
> > The idea of new qgroup metadata reservation is to use 2 types of
> > metadata reservation:
> > 1) Per-transaction reservation
> >    Life span will be inside a transaction. Will be freed at transaction
> >    commit time.
> > 
> > 2) Preallocated reservation
> >    For case where we reserve space before starting a transaction.
> >    Operation like dealloc and delayed-inode/item belongs to this type.
> > 
> >    This works similar to block_rsv, its reservation can be
> >    reserved/released at any timing caller like.
> > 
> >    The only point to notice is, if preallocated reservation is used and
> >    finished without problem, it should be converted to per-transaction
> >    type instead of just freeing.
> >    This is to co-operate with qgroup update at commit time.
> > 
> > For preallocated type, this patch will integrate them into inode_rsv
> > mechanism reworked by Josef, and delayed-inode/item reservation.
> > 
> > 
> > [Problem: Over-reserve]
> > Currently the patchset addresses metadata underflow quite well, but
> > due to the over-reserve nature of btrfs and highly bounded to inode_rsv,
> > qgroup metadata reservation also tends to be over-reserved.
> > 
> > This is especially obvious for small limit.
> > For 128M limit, it's will only be able to write about 70M before hitting
> > quota limit.
> > Although for larger limit, like 5G limit, it can reach 4.5G or more
> > before hitting limit.
> > 
> > Such over-reserved behavior can lead to some problem with existing test
> > cases (where limit is normally less than 20M).
> > 
> > While it's also possible to be addressed by use more accurate space other
> > than max estimations.
> > 
> > For example, to calculate metadata needed for delalloc, we use
> > btrfs_calc_trans_metadata_size(), which always try to reserve space for
> > CoW a full-height tree, and will also include csum size.
> > Both calculate is way over-killed for qgroup metadata reservation.
> In private chat with Chris couple of months ago we discussed making the
> reservation a lot less pessimistic. One assumption which we could
> exploit is the fact that upon a tree split it's unlikely we will create
> more than 1 additional level in the tree. So we could potentially modify
> btrfs_calc_trans_metadata_size to take a root parameter and instead of
> 
> BTRFS_MAX_LEVEL * 2 we could change this to root_level * 2. How does
> that sound?

That sounds unsafe for low levels, because the reservations can be made
with level N and the tree height can increase at commit time to > N,
then we'd go ENOSPC. But BTRFS_MAX_LEVEL can be reduced to
min(root_level + 1, 4) and even the +1 can be dropped for higher levels
if the root node is filled up to some percent (say < 50%). The 4 is a
guess and could be possibly 3, with some more precise calculations.
