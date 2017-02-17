Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24319 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754386AbdBQBE7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 20:04:59 -0500
Subject: Re: [PATCH 00/10] Qgroup fixes for kdave/for-next-20161125 branch
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>,
        <chandan@linux.vnet.ibm.com>
References: <20161209022835.10168-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a4f56ef0-c43a-6443-4b53-065b61cd6fda@cn.fujitsu.com>
Date: Fri, 17 Feb 2017 09:04:47 +0800
MIME-Version: 1.0
In-Reply-To: <20161209022835.10168-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Any update about this patchset?

As I see a lot of cleanups related to qgroup is submitted to mail list, 
should I rebase this patchset to handle the conflicts using your latest 
for-next?

Or should I rebase them only after cleanups got merged into mainline?

Thanks,
Qu

At 12/09/2016 10:28 AM, Qu Wenruo wrote:
> The branch can be fetched from github:
> https://github.com/adam900710/linux.git for-david-next-qgroup-fixes
>
> If David wants to push these fixes to 4.10, then I can rebase these patches to
> Chris' for-linus branch.
>
> Recent qgroup fixes for several problems:
> 1) Qgroup reserved space underflow
>    Caused by several reasons, from buffer write happens before qgroup enable,
>    to freeing qgroup space not reserved by caller.
>
> 2) inode_cache mount option corruption
>
> 3) Enhance qgroup trace point
>    Used for debugging above problems.
>
> All patches are already submitted to mail list.
> The 1st patch is the diff between V4 and V5 patch which adds WARN_ON() for
> underflowing qgroup reserved space.
>
> Qu Wenruo (10):
>   btrfs: qgroup: Fix wrong qgroup passed to reserved space error report
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
>  fs/btrfs/ctree.h             |  14 +--
>  fs/btrfs/extent-tree.c       |  32 ++++---
>  fs/btrfs/extent_io.h         |  24 +++++-
>  fs/btrfs/file.c              |  45 ++++++----
>  fs/btrfs/inode-map.c         |   4 +-
>  fs/btrfs/inode.c             |  69 +++++++++------
>  fs/btrfs/ioctl.c             |   9 +-
>  fs/btrfs/qgroup.c            | 197 +++++++++++++++++++++++++++++++------------
>  fs/btrfs/qgroup.h            |  14 ++-
>  fs/btrfs/relocation.c        |  12 +--
>  fs/btrfs/transaction.c       |  20 ++---
>  include/trace/events/btrfs.h |  43 ++++++++++
>  12 files changed, 341 insertions(+), 142 deletions(-)
>


