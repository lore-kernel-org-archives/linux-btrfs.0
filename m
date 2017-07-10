Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:60326 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754225AbdGJSpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 14:45:10 -0400
Date: Mon, 10 Jul 2017 21:11:50 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <ahferroin7@gmail.com>,
        <kilobyte@angband.pl>
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
Message-ID: <20170710211150.7210ac36@fire>
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 28 Jun 2017 13:43:29 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> The patchset can be fetched from my github repo:
> https://github.com/adam900710/linux/tree/degradable
> 
> The patchset is based on David's for-4.13-part1 branch.
> 
> Btrfs currently uses num_tolerated_disk_barrier_failures to do global
> check for tolerated missing device.
> 
> Although the one-size-fit-all solution is quite safe, it's too strict
> if data and metadata has different duplication level.
> 
> For example, if one use Single data and RAID1 metadata for 2 disks, it
> means any missing device will make the fs unable to be degraded
> mounted.
> 
> But in fact, some times all single chunks may be in the existing
> device and in that case, we should allow it to be rw degraded mounted.
> 
> Such case can be easily reproduced using the following script:
>  # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
>  # wipefs -f /dev/sdc
>  # mount /dev/sdb -o degraded,rw
> 
> If using btrfs-debug-tree to check /dev/sdb, one should find that the
> data chunk is only in sdb, so in fact it should allow degraded mount.
> 
> This patchset will introduce a new per-chunk degradable check for
> btrfs, allow above case to succeed, and it's quite small anyway.
> 
> And enhance kernel error message for missing device, at least user
> can know what's making mount failed, other than meaningless
> "failed to read system chunk/chunk tree -5".
> 
> v2:
>   Update after almost 2 years.
>   Add the last patch to enhance the kernel output, so user can know
>   it's missing devices that prevents btrfs to be mounted.
> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in
> btrfs_device, but use a new structure extra_rw_degrade_errors, to
> record error when sending down/waiting device.
> v3.1:
>   Reduce the critical section in btrfs_check_rw_degradable(), follow
> other caller to only acquire the lock when searching, as extent_map
> has refcount to avoid concurrency already.
>   The modification itself won't affect the behavior, so tested-by
> tags are added to each patch.
> v4:
>   Thanks Anand for this dev flush work, which makes us more easier to
>   detect flush error in previous transaction.
>   Now this patchset won't need to alloc memory, and can just use
>   btrfs_device->last_flush_error to check if last flush finished
>   correctly.
>   New rebase, so old tested by tags are all removed, sorry guys.
> 
> Qu Wenruo (6):
>   btrfs: Introduce a function to check if all chunks a OK for degraded
>     rw mount
>   btrfs: Do chunk level rw degrade check at mount time
>   btrfs: Do chunk level degradation check for remount
>   btrfs: Allow barrier_all_devices to do chunk level device check
>   btrfs: Cleanup num_tolerated_disk_barrier_failures
>   btrfs: Enhance missing device kernel message
> 
>  fs/btrfs/ctree.h   |  2 --
>  fs/btrfs/disk-io.c | 81 ++++----------------------------------------
>  fs/btrfs/disk-io.h |  2 --
>  fs/btrfs/super.c   |  3 +-
>  fs/btrfs/volumes.c | 99
> +++++++++++++++++++++++++++++++++++++++++-------------
> fs/btrfs/volumes.h |  3 ++ 6 files changed, 85 insertions(+), 105
> deletions(-)
> 

Tested on top of current mainline master (commit af3c8d98508d37541d4bf57f13a984a7f73a328c). Didn't find any regressions.
