Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:17855 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbbHUTCB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 15:02:01 -0400
Subject: Re: [GIT PULL] Fujitsu pull part1: cleanup
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <55D68A6C.3010107@cn.fujitsu.com>
From: Stefan Behrens <sbehrens@giantdisaster.de>
Message-ID: <55D775A0.8030207@giantdisaster.de>
Date: Fri, 21 Aug 2015 21:01:52 +0200
MIME-Version: 1.0
In-Reply-To: <55D68A6C.3010107@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please send your patches to the mailing list for reviews by everybody.


On 8/21/2015 4:18 AM, Qu Wenruo wrote:
> Hi Chris,
>
> Would you please consider merging the following fixes for your
> integration-4.3 branch?
>
> https://github.com/adam900710/linux.git for_chris_4.3_part1_cleanup
>
> Most of them are harmless cleanups, like removing unused
> parameters/judgment, or comment/variant name change.
>
> We have already tested them for about 2 days, and it would be safe.
>
> Based on 46cd28555ffaa40162290dba203daad0ff6f7abd.
> And can be merged with pull from Filipe automatically without any conflict.
>
> P.S:
> Schedule for rest pull:
> Part2: btrfs/070 fix.
>    The patchset is already updated sometime ago, but we are using more
>    test to make sure it won't cause any new bug.
>
> PartN: qgroup reserve space leak fix. (maybe for 4.4)
>    This one will involve some huge change in btrfs qgroup reserve
>    mechanism.
>
>    The idea is to keep a per-inode map for which range of space is
>    already reserved, to avoid double reserve for same range but only
>    freed once case.
>
>    It's still under development, and it may not be able to meet
>    current merge windows.
>    So it's will be for 4.4.
>
> PartN+1: Metadata and data qgroup support. (maybe for 4.4 with PartN)
>    Some old patches from Yang, but needs some updates for new qgroup
>    accounting/reserve mechanism.
>
> Thanks,
> Qu
>
>
> Qu Wenruo (1):
>    btrfs: async_thread: Fix workqueue 'max_active' value when
>      initializing
>
> Tsutomu Itoh (1):
>    Btrfs: cleanup: remove unnecessary check before btrfs_free_path is
>      called
>
> Zhao Lei (6):
>    btrfs: Update out-of-date "skip parity stripe" comment
>    btrfs: Remove noused chunk_tree and chunk_objectid from
>      scrub_enumerate_chunks and scrub_chunk
>    btrfs: Cleanup for btrfs_calc_num_tolerated_disk_barrier_failures
>    btrfs: Add raid56 support for updating
>      num_tolerated_disk_barrier_failures in btrfs_balance
>    btrfs: Remove useless condition in start_log_trans
>    btrfs: Remove unused arguments in tree-log.c
>
>   fs/btrfs/async-thread.c | 57 ++++++++++++++++++++++---------------
>   fs/btrfs/async-thread.h |  2 +-
>   fs/btrfs/dev-replace.c  |  3 +-
>   fs/btrfs/disk-io.c      | 76
> +++++++++++++++++++++++--------------------------
>   fs/btrfs/disk-io.h      |  1 +
>   fs/btrfs/inode.c        |  3 +-
>   fs/btrfs/scrub.c        | 12 ++------
>   fs/btrfs/tree-defrag.c  |  3 +-
>   fs/btrfs/tree-log.c     | 68 ++++++++++++++++++-------------------------
>   fs/btrfs/volumes.c      | 21 +++-----------
>   10 files changed, 110 insertions(+), 136 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
