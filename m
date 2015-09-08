Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37293 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754076AbbIHJIa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 05:08:30 -0400
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
To: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55EEA58A.8050503@cn.fujitsu.com>
Date: Tue, 8 Sep 2015 17:08:26 +0800
MIME-Version: 1.0
In-Reply-To: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the confusing cover letter title.

This patch is no longer RFC now.
It's already a working one, and we're doing stress test to ensure it's 
completely OK, but seems quite good for now.

To Chris,

I know the timing I sent the patchset is quite awful, as there is only 
less than 1 week for rc1, and the merge window will close soon.

But I still hope there would be a small chance we can merge it into 
early v4.3-rc. Maybe rc2 or rc3?
As the reserve space leaking problem is quite annoying, sometimes even 
making qgroup limit unusable.

If that's not possible, I'm completely OK with that though, as Linus 
won't be happy about that without doubt.

Thanks,
Qu

Qu Wenruo wrote on 2015/09/08 16:56 +0800:
> [[BUG]]
> One of the most common case to trigger the bug is the following method:
> 1) Enable quota
> 2) Limit excl of qgroup 5 to 16M
> 3) Write [0,2M) of a file inside subvol 5 10 times without sync
>
> EQUOT will be triggered at about the 8th write.
>
> [[CAUSE]]
> The problem is caused by the fact that qgroup will reserve space even
> the data space is already reserved.
>
> In above reproducer, each time we buffered write [0,2M) qgroup will
> reserve 2M space, but in fact, at the 1st time, we have already reserved
> 2M and from then on, we don't need to reserved any data space as we are
> only writing [0,2M).
>
> Also, the reserved space will only be freed *ONCE* when its backref is
> run at commit_transaction() time.
>
> That's causing the reserved space leaking.
>
> [[FIX]]
> The fix is not a simple one, as currently btrfs_qgroup_reserve() follow
> the very bad btrfs space allocating principle:
>    Allocate as much as you needed, even it's not fully used.
>
> So for accurate qgroup reserve, we introduce a completely new framework
> for data and metadata.
> 1) Per-inode data reserve map
>     Now, each inode will have a data reserve map, recording which range
>     of data is already reserved.
>     If we are writing a range which is already reserved, we won't need to
>     reserve space again.
>
>     Also, for the fact that qgroup is only accounted at commit_trans(),
>     for data commit into disc and its metadata is also inserted into
>     current tree, we should free the data reserved range, but still keep
>     the reserved space until commit_trans().
>
>     So delayed_ref_head will have new members to record how much space is
>     reserved and free them at commit_trans() time.
>
> 2) Per-root metadata reserve counter
>     For metadata(tree block), it's impossible to know how much space it
>     will use exactly in advance.
>     And due to the new qgroup accounting framework, the old
>     free-at-end-trans may lead to exceeding limit.
>
>     So we record how much metadata space is reserved for each root, and
>     free them at commit_trans() time.
>     This method is not perfect, but thanks to the compared small size of
>     metadata, it should be quite good.
>
> More detailed info can be found in each commit message and source
> commend.
>
> Qu Wenruo (19):
>    btrfs: qgroup: New function declaration for new reserve implement
>    btrfs: qgroup: Implement data_rsv_map init/free functions
>    btrfs: qgroup: Introduce new function to search most left reserve
>      range
>    btrfs: qgroup: Introduce function to insert non-overlap reserve range
>    btrfs: qgroup: Introduce function to reserve data range per inode
>    btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
>    btrfs: qgroup: Introduce function to release reserved range
>    btrfs: qgroup: Introduce function to release/free reserved data range
>    btrfs: delayed_ref: Add new function to record reserved space into
>      delayed ref
>    btrfs: delayed_ref: release and free qgroup reserved at proper timing
>    btrfs: qgroup: Introduce new functions to reserve/free metadata
>    btrfs: qgroup: Use new metadata reservation.
>    btrfs: extent-tree: Add new verions of btrfs_check_data_free_space
>    btrfs: Switch to new check_data_free_space
>    btrfs: fallocate: Add support to accurate qgroup reserve
>    btrfs: extent-tree: Add new version of btrfs_delalloc_reserve_space
>    btrfs: extent-tree: Use new __btrfs_delalloc_reserve_space function
>    btrfs: qgroup: Cleanup old inaccurate facilities
>    btrfs: qgroup: Add handler for NOCOW and inline
>
>   fs/btrfs/btrfs_inode.h |   6 +
>   fs/btrfs/ctree.h       |   8 +-
>   fs/btrfs/delayed-ref.c |  29 +++
>   fs/btrfs/delayed-ref.h |  14 +
>   fs/btrfs/disk-io.c     |   1 +
>   fs/btrfs/extent-tree.c |  99 +++++---
>   fs/btrfs/file.c        | 169 +++++++++----
>   fs/btrfs/inode-map.c   |   2 +-
>   fs/btrfs/inode.c       |  51 +++-
>   fs/btrfs/ioctl.c       |   3 +-
>   fs/btrfs/qgroup.c      | 674 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   fs/btrfs/qgroup.h      |  18 +-
>   fs/btrfs/transaction.c |  34 +--
>   fs/btrfs/transaction.h |   1 -
>   14 files changed, 979 insertions(+), 130 deletions(-)
>
