Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:34040 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753037AbdCFTBT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 14:01:19 -0500
Received: from [2001:470:28:88::100] (helo=fire)
        by demfloro.ru with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.88)
        (envelope-from <demfloro@demfloro.ru>)
        id 1ckxhI-0001RF-MO
        for linux-btrfs@vger.kernel.org; Mon, 06 Mar 2017 18:49:29 +0000
Date: Mon, 6 Mar 2017 21:49:16 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Chunk level degradable check
Message-ID: <20170306214916.23c6fd20@fire>
In-Reply-To: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Mar 2017 16:58:49 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

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

Hello,

Tested the patchset for raid1 and raid10. Successfully allows
degraded mount with single chunks on the filesystems without one drive.

Feel free to add Tested-By: Dmitrii Tcvetkov <demfloro@demfloro.ru>
