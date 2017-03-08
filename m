Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35253 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751603AbdCHMen (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 07:34:43 -0500
Received: by mail-it0-f68.google.com with SMTP id f203so4870175itf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Mar 2017 04:34:06 -0800 (PST)
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        anand.jain@oracle.com, kilobyte@angband.pl, demfloro@demfloro.ru
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ffde6cef-d1a7-b96f-c0cd-7fa06094a4cd@gmail.com>
Date: Wed, 8 Mar 2017 07:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-07 21:41, Qu Wenruo wrote:
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
> And enhance kernel error message for missing device, at least kernel
> can know what's making mount failed, other than meaningless
> "failed to read system chunk/chunk tree -5".
>
> v2:
>   Update after almost 2 years.
>   Add the last patch to enhance the kernel output, so user can know
>   it's missing devices prevent btrfs to mount.
> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in btrfs_device,
>   but use a new structure extra_rw_degrade_errors, to record error when
>   sending down/waiting device.
>
> Sorry Dmitrii Tcvetkov and Adam Borowski, I'm afraid I can't add your
> tested-by tags in v3, as the 4th and 4th patches have quite a big change,
> so you may need to retest the new patchset.
> Sorry for the trouble.
>
> Qu Wenruo (7):
>   btrfs: Introduce a function to check if all chunks a OK for degraded
>     rw mount
>   btrfs: Do chunk level rw degrade check at mount time
>   btrfs: Do chunk level degradation check for remount
>   btrfs: Introduce extra_rw_degrade_errors parameter for
>     btrfs_check_rw_degradable
>   btrfs: Allow barrier_all_devices to do chunk level device check
>   btrfs: Cleanup num_tolerated_disk_barrier_failures
>   btrfs: Enhance missing device kernel message
>
>  fs/btrfs/ctree.h   |   2 -
>  fs/btrfs/disk-io.c |  87 ++++++------------------------
>  fs/btrfs/disk-io.h |   2 -
>  fs/btrfs/super.c   |   5 +-
>  fs/btrfs/volumes.c | 156 ++++++++++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/volumes.h |  37 +++++++++++++
>  6 files changed, 188 insertions(+), 101 deletions(-)
>
Everything appears to work as advertised here, so for the patcheset as a 
whole, you can add:

Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Also, I've added a couple of specific cases to my automated test scripts 
to make sure this keeps working, so going forwards we'll have some 
regression testing for this.
