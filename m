Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59442 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932234AbcKVJyU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 04:54:20 -0500
Subject: Re: [PATCH 0/3] introduce type based delalloc metadata reserve to fix
 some false enospc issues
To: <linux-btrfs@vger.kernel.org>
References: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <holger@applied-asynchrony.com>, <s.priebe@profihost.ag>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <58341408.3010004@cn.fujitsu.com>
Date: Tue, 22 Nov 2016 17:46:48 +0800
MIME-Version: 1.0
In-Reply-To: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

Any comments about this patchset?

The first two patches almost don't do any functional change which I think
could be review firstly.
     btrfs: improve inode's outstanding_extents computation
     btrfs: introduce type based delalloc metadata reserve


Regards,
Xiaoguang Wang

On 11/11/2016 04:39 PM, Wang Xiaoguang wrote:
> When having compression enabled, Stefan Priebe ofen got enospc errors
> though fs still has much free space. Qu Wenruo also has submitted a
> fstests test case which can reproduce this bug steadily, please see
> url: https://patchwork.kernel.org/patch/9420527
>
> First patch[1/3] "btrfs: improve inode's outstanding_extents computation" is to
> fix outstanding_extents and reserved_extents account issues. This issue was revealed
> by modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, When modifying
> BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often gets these warnings from
> btrfs_destroy_inode():
>          WARN_ON(BTRFS_I(inode)->outstanding_extents);
>          WARN_ON(BTRFS_I(inode)->reserved_extents);
> Please see this patch's commit message for detailed info, and this patch is
> necessary to patch2 and patch3.
>
> For false enospc, the root reasson is that for compression, its max extent size will
> be 128k, not 128MB. If we still use 128MB as max extent size to reserve metadata for
> compression, obviously it's not appropriate. In patch "btrfs: Introduce COMPRESS
> reserve type to fix false enospc for compression" commit message,
> we explain why false enospc error occurs, please see it for detailed info.
>
> To fix this issue, we introduce a new enum type:
> 	enum btrfs_metadata_reserve_type {
> 		BTRFS_RESERVE_NORMAL,
>          	BTRFS_RESERVE_COMPRESS,
> 	};
> For btrfs_delalloc_[reserve|release]_metadata() and
> btrfs_delalloc_[reserve|release]_space(), we introce a new btrfs_metadata_reserve_type
> argument, then if a path needs to go compression, we pass BTRFS_RESERVE_COMPRESS,
> otherwise pass BTRFS_RESERVE_NORMAL.
>
> With these patchs, Stefan no longer saw such false enospc errors, and Qu Wenruo's
> fstests test case will also pass. I have also run whole fstests multiple times,
> no regression occurs, thanks.
>
> Wang Xiaoguang (3):
>    btrfs: improve inode's outstanding_extents computation
>    btrfs: introduce type based delalloc metadata reserve
>    btrfs: Introduce COMPRESS reserve type to fix false enospc for
>      compression
>
>   fs/btrfs/ctree.h             |  36 +++++--
>   fs/btrfs/extent-tree.c       |  52 ++++++---
>   fs/btrfs/extent_io.c         |  61 ++++++++++-
>   fs/btrfs/extent_io.h         |   5 +
>   fs/btrfs/file.c              |  25 +++--
>   fs/btrfs/free-space-cache.c  |   6 +-
>   fs/btrfs/inode-map.c         |   6 +-
>   fs/btrfs/inode.c             | 246 ++++++++++++++++++++++++++++++++++---------
>   fs/btrfs/ioctl.c             |  16 +--
>   fs/btrfs/relocation.c        |  14 ++-
>   fs/btrfs/tests/inode-tests.c |  15 +--
>   11 files changed, 381 insertions(+), 101 deletions(-)
>



