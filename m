Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47304 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbdIHLCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 07:02:24 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:54826)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dqH3F-0008EV-2m
        for linux-btrfs@vger.kernel.org; Fri, 08 Sep 2017 12:02:21 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dqH39-0005wl-58
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 12:02:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22962.30901.85878.65754@tree.ty.sabi.co.uk>
Date: Fri, 8 Sep 2017 12:02:13 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.13: No space left with plenty of free space
 (/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989
 __btrfs_free_extent.isra.62+0xc2c/0xdb0)
In-Reply-To: <7459bb074e417c066b525d832d8006ca@wpkg.org>
References: <7459bb074e417c066b525d832d8006ca@wpkg.org>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
> [233787.921018] Call Trace:
> [233787.921031]  ? btrfs_merge_delayed_refs+0x62/0x550 [btrfs]
> [233787.921039]  __btrfs_run_delayed_refs+0x6f0/0x1380 [btrfs]
> [233787.921047]  btrfs_run_delayed_refs+0x6b/0x250 [btrfs]
> [233787.921054]  btrfs_write_dirty_block_groups+0x158/0x390 [btrfs]
> [233787.921063]  commit_cowonly_roots+0x221/0x2c0 [btrfs]
> [233787.921071]  btrfs_commit_transaction+0x46e/0x8d0 [btrfs]
[ ... ]
> [233787.921191] BTRFS: error (device md2) in 
> btrfs_run_delayed_refs:3009: errno=-28 No space left
> [233789.507669] BTRFS warning (device md2): Skipping commit of aborted 
> transaction.
> [233789.507672] BTRFS: error (device md2) in cleanup_transaction:1873: 
> errno=-28 No space left
[ ... ]

So the numbers that matter are:

> Data,single: Size:12.84TiB, Used:7.13TiB
>     /dev/md2       12.84TiB
> Metadata,DUP: Size:79.00GiB, Used:77.87GiB
>     /dev/md2      158.00GiB
> Unallocated:
>     /dev/md2        3.31TiB

The metadata allocations is nearly full, so it could be the
usual story with the two-level allocator that there are not
unallocated chunks for metadata expansion, but since you have
3TiB of 'unallocated' space there is no obvious reason why
allocation of the metadata to do a new root transaction flush
should abort, so this is about "guessing" which corner case or
bug applies:

* If you are using the 'space_cache' it has a known issue:
    https://btrfs.wiki.kernel.org/index.php/Gotchas#Free_space_cache
* Some versions of Btrfs (IIRC around 4.8-4.9) had some other
  allocator bug.
* Maybe some previous issue, hw or sw, had damaged internal
  filesystem structures.

I also notice that your volume's data free space seems to be
extremely fragmented, as the large difference here shows
"Data,single: Size:12.84TiB, Used:7.13TiB".

Which may mean that it is mounted with 'ssd' and/or has gone a
long time without a 'balance', and conceivably this can make it
easier for the free space cache to fail finding space (some
handwaving here).
