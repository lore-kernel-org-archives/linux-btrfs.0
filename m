Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdLLOQL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 09:16:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F1FE8AE36
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 14:16:09 +0000 (UTC)
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171212073436.16447-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4c56a262-51fb-b66d-3d1b-f4b0a906cef5@suse.com>
Date: Tue, 12 Dec 2017 16:16:08 +0200
MIME-Version: 1.0
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.12.2017 09:34, Qu Wenruo wrote:
> [Overall]
> The previous rework on qgroup reservation system put a lot of effort on
> data, which works quite fine.
> 
> But it takes less focus on metadata reservation, causing some problem
> like metadata reservation underflow and noisy kernel warning.
> 
> This patchset will try to address the remaining problem of metadata
> reservation.
> 
> The idea of new qgroup metadata reservation is to use 2 types of
> metadata reservation:
> 1) Per-transaction reservation
>    Life span will be inside a transaction. Will be freed at transaction
>    commit time.
> 
> 2) Preallocated reservation
>    For case where we reserve space before starting a transaction.
>    Operation like dealloc and delayed-inode/item belongs to this type.
> 
>    This works similar to block_rsv, its reservation can be
>    reserved/released at any timing caller like.
> 
>    The only point to notice is, if preallocated reservation is used and
>    finished without problem, it should be converted to per-transaction
>    type instead of just freeing.
>    This is to co-operate with qgroup update at commit time.
> 
> For preallocated type, this patch will integrate them into inode_rsv
> mechanism reworked by Josef, and delayed-inode/item reservation.
> 
> 
> [Problem: Over-reserve]
> Currently the patchset addresses metadata underflow quite well, but
> due to the over-reserve nature of btrfs and highly bounded to inode_rsv,
> qgroup metadata reservation also tends to be over-reserved.
> 
> This is especially obvious for small limit.
> For 128M limit, it's will only be able to write about 70M before hitting
> quota limit.
> Although for larger limit, like 5G limit, it can reach 4.5G or more
> before hitting limit.
> 
> Such over-reserved behavior can lead to some problem with existing test
> cases (where limit is normally less than 20M).
> 
> While it's also possible to be addressed by use more accurate space other
> than max estimations.
> 
> For example, to calculate metadata needed for delalloc, we use
> btrfs_calc_trans_metadata_size(), which always try to reserve space for
> CoW a full-height tree, and will also include csum size.
> Both calculate is way over-killed for qgroup metadata reservation.
In private chat with Chris couple of months ago we discussed making the
reservation a lot less pessimistic. One assumption which we could
exploit is the fact that upon a tree split it's unlikely we will create
more than 1 additional level in the tree. So we could potentially modify
btrfs_calc_trans_metadata_size to take a root parameter and instead of

BTRFS_MAX_LEVEL * 2 we could change this to root_level * 2. How does
that sound?


> 
> [Patch structure]
> The patch is consist of 2 main parts:
> 1) Type based qgroup reservation
>    The original patchset is sent several months ago.
>    Nothing is modified at all, just rebased. And not conflict at all.
> 
>    It's from patch 1 to patch 6.
> 
> 2) Split meta qgroup reservation into per-trans and prealloc sub types
>    The real work to address metadata underflow.
>    Due to the over-reserve problem, this part is still in RFC state.
>    But the framework should mostly be fine, only needs extra fine-tuning
>    to get more accurate qgroup rsv to avoid too early limit.
> 
>    It's from patch 7 to 14.
> 
> Qu Wenruo (14):
>   btrfs: qgroup: Skeleton to support separate qgroup reservation type
>   btrfs: qgroup: Introduce helpers to update and access new qgroup rsv
>   btrfs: qgroup: Make qgroup_reserve and its callers to use separate
>     reservation type
>   btrfs: qgroup: Fix wrong qgroup reservation update for relationship
>     modification
>   btrfs: qgroup: Update trace events to use new separate rsv types
>   btrfs: qgroup: Cleanup the remaining old reservation counters
>   btrfs: qgroup: Split meta rsv type into meta_prealloc and
>     meta_pertrans
>   btrfs: qgroup: Don't use root->qgroup_meta_rsv for qgroup
>   btrfs: qgroup: Introduce function to convert META_PREALLOC into
>     META_PERTRANS
>   btrfs: qgroup: Use separate meta reservation type for delalloc
>   btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and
>     item
>   btrfs: qgroup: Use root->qgroup_meta_rsv_* to record qgroup meta
>     reserved space
>   btrfs: qgroup: Update trace events for metadata reservation
>   Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"
> 
>  fs/btrfs/ctree.h             |  15 +-
>  fs/btrfs/delayed-inode.c     |  50 +++++--
>  fs/btrfs/disk-io.c           |   2 +-
>  fs/btrfs/extent-tree.c       |  49 +++---
>  fs/btrfs/file.c              |  15 +-
>  fs/btrfs/free-space-cache.c  |   2 +-
>  fs/btrfs/inode-map.c         |   4 +-
>  fs/btrfs/inode.c             |  27 ++--
>  fs/btrfs/ioctl.c             |  10 +-
>  fs/btrfs/ordered-data.c      |   2 +-
>  fs/btrfs/qgroup.c            | 350 ++++++++++++++++++++++++++++++++-----------
>  fs/btrfs/qgroup.h            | 102 ++++++++++++-
>  fs/btrfs/relocation.c        |   9 +-
>  fs/btrfs/transaction.c       |   8 +-
>  include/trace/events/btrfs.h |  73 ++++++++-
>  15 files changed, 537 insertions(+), 181 deletions(-)
> 
