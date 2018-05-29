Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32811 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934940AbeE2PgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 11:36:11 -0400
Date: Tue, 29 May 2018 17:33:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Message-ID: <20180529153326.GB4325@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180528054821.9092-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528054821.9092-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 01:48:20PM +0800, Ethan Lien wrote:
> [Problem description and how we fix it]
> We should balance dirty metadata pages at the end of
> btrfs_finish_ordered_io, since a small, unmergeable random write can
> potentially produce dirty metadata which is multiple times larger than
> the data itself. For example, a small, unmergeable 4KiB write may
> produce:
> 
>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
> 
> Although we do call balance dirty pages in write side, but in the
> buffered write path, most metadata are dirtied only after we reach the
> dirty background limit (which by far only counts dirty data pages) and
> wakeup the flusher thread. If there are many small, unmergeable random
> writes spread in a large btree, we'll find a burst of dirty pages
> exceeds the dirty_bytes limit after we wakeup the flusher thread - which
> is not what we expect. In our machine, it caused out-of-memory problem
> since a page cannot be dropped if it is marked dirty.
> 
> Someone may worry about we may sleep in btrfs_btree_balance_dirty_nodelay,
> but since we do btrfs_finish_ordered_io in a separate worker, it will not
> stop the flusher consuming dirty pages. Also, we use different worker for
> metadata writeback endio, sleep in btrfs_finish_ordered_io help us throttle
> the size of dirty metadata pages.
> 
> [Reproduce steps]
> To reproduce the problem, we need to do 4KiB write randomly spread in a
> large btree. In our 2GiB RAM machine:
> 1) Create 4 subvolumes.
> 2) Run fio on each subvolume:
> 
>    [global]
>    direct=0
>    rw=randwrite
>    ioengine=libaio
>    bs=4k
>    iodepth=16
>    numjobs=1
>    group_reporting
>    size=128G
>    runtime=1800
>    norandommap
>    time_based
>    randrepeat=0
> 
> 3) Take snapshot on each subvolume and repeat fio on existing files.
> 4) Repeat step (3) until we get large btrees.
>    In our case, by observing btrfs_root_item->bytes_used, we have 2GiB of
>    metadata in each subvolume tree and 12GiB of metadata in extent tree.
> 5) Stop all fio, take snapshot again, and wait until all delayed work is
>    completed.
> 6) Start all fio. Few seconds later we hit OOM when the flusher starts
>    to work.
> 
> It can be reproduced even when using nocow write.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

Added to misc-next, thanks.
