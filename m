Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20713 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752580AbdCFIWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 03:22:33 -0500
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>, <clm@fb.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
Date: Mon, 6 Mar 2017 16:08:41 +0800
MIME-Version: 1.0
In-Reply-To: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any response?

These patches are already here for at least 2 kernel releases.
And are all bug fixes, and fix bugs that are already reported.

I didn't see any reason why it should be delayed for so long time.

Thanks,
Qu

At 02/27/2017 03:10 PM, Qu Wenruo wrote:
> Pull request can be fetched from my github:
> https://github.com/adam900710/linux.git qgroup_fixes_for_4.11
>
> The base is 6288d6eabc7505f42dda34a2c2962f91914be3a4.
> Author: Liu Bo <bo.li.liu@oracle.com>
> Date:   Tue Feb 21 12:12:58 2017 -0800
>
>     Btrfs: use the correct type when creating cow dio extent
>
> These patches are already in mail list for almost 3 months.
> For example the tracepoint patch is last updated at 2016/12/09.
>
> With this patchset btrfs can pass all xfstest qgroup tests now.
>
> This pull request should be good for 4.11 as they are all bug fixes and
> has been delayed for several times.
>
> I don't know if these patchset will be delayed again if someone wants to
> cleanup something else, and cause rebase conflicts to delay such fixes.
> But I must say, that's very frustrating to see bug fixes just get dropped
> again and again just due to new cleanups and lack of reviewers.
>
> Despite all these pities, this pull request includes:
> 1) Fix for inode_cache mount option
>    Although no one really cares inode_cache mount option, it will screw
>    qgroup for a long time.
>    Not only it will screw up qgroup test uses golden output, but also
>    new test cases use btrfsck to verify qgroup.
>
> 2) Fix for btrfs/104 kernel warning
>    This is caused by quota enabling with dirty buffers not written to
>    disc.
>
>    Fixed by checking EXTENT_QGROUP_RESERVED flag other than just
>    decreasing qgroup->reserved.
>
> 3) Fix qgroup underflow caused by freeing ranges not reserved by caller
>    Mainly exposed by Chandan on PPC64.
>
>    It's possible that buffered write is blocked by reserving metadata,
>    and in error path we will release reserved space for both data and
>    metadata.
>
>    However the reserved data can already be reserved by another process
>    writing the same page.
>
>    In that case, data reserved space can be freed by two process, one
>    for error path, one for normal write routine, causing underflow.
>
>    Fixed by checking if that data range is reserved by ourselves and
>    only free it if it's reserved by ourselves.
>
> Update since 2016/12/09:
>   Rebased to latest for-linux-4.11.
>
>   Add missing reviewed-by and tested-by tags.
>
>   Add more comment for btrfs_qgroup_reserve_data() for error handling.
>
>   Add more comment for qgroup_free_reserved_data() for later
>   enhancement (not function enhancement).
>
> Qu Wenruo (9):
>   btrfs: qgroup: Add trace point for qgroup reserved space
>   btrfs: qgroup: Re-arrange tracepoint timing to co-operate with
>     reserved space tracepoint
>   btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
>     option
>   btrfs: qgroup: Add quick exit for non-fs extents
>   btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
>   btrfs: qgroup: Return actually freed bytes for qgroup release or free
>     data
>   btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered
>     write and quota enable
>   btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
>   btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
>     reserved ranges
>
>  fs/btrfs/ctree.h             |  12 ++-
>  fs/btrfs/extent-tree.c       |  31 +++---
>  fs/btrfs/extent_io.h         |  14 ++-
>  fs/btrfs/file.c              |  46 +++++----
>  fs/btrfs/inode-map.c         |   6 +-
>  fs/btrfs/inode.c             |  64 +++++++++----
>  fs/btrfs/ioctl.c             |  11 ++-
>  fs/btrfs/qgroup.c            | 221 ++++++++++++++++++++++++++++++++-----------
>  fs/btrfs/qgroup.h            |  14 +--
>  fs/btrfs/relocation.c        |  13 ++-
>  fs/btrfs/transaction.c       |  21 ++--
>  include/trace/events/btrfs.h |  43 +++++++++
>  12 files changed, 358 insertions(+), 138 deletions(-)
>


