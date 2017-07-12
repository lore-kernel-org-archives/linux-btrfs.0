Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752617AbdGLPZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 11:25:33 -0400
Date: Wed, 12 Jul 2017 17:24:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, ahferroin7@gmail.com,
        kilobyte@angband.pl, demfloro@demfloro.ru
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
Message-ID: <20170712152419.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 01:43:29PM +0800, Qu Wenruo wrote:
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

I've seen wider testing coverage in replies to the previous patchset
iterations. Can we have that added to fstests?

I'm going to add this patchset to the devel queue (ie. not a separate
for-next branch anymore).
