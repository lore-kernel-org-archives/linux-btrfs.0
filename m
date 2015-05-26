Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35730 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbEZRF6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 13:05:58 -0400
Received: by pdea3 with SMTP id a3so95063491pde.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 10:05:58 -0700 (PDT)
Date: Tue, 26 May 2015 10:05:47 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaoxie@huawei.com>, Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
Message-ID: <20150526170547.GA21342@mew.lv.cox.net>
References: <cover.1431330020.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1431330020.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 12:58:11AM -0700, Omar Sandoval wrote:
> A user reported on Bugzilla that they were seeing kernel BUGs when
> attempting to replace a missing device on a RAID 6 array. After
> identifying the apparent cause of the BUG, I reached the conclusion that
> there wasn't a quick fix. Maybe Miao Xie can point something out that I
> missed, as he originally implemented device replace on RAID 5/6 :)
> 
> Patch 4 has the details, but the main problem is that we can't create
> bios for a missing device, so the main scrub code path isn't very
> useful. On RAID 5/6, since we only have one mirror for any piece of
> data, the missing device is the only mirror we can use. Clearly, (unless
> I missed something), this case needs to be handled differently.
> 
> These patches are on top of v4.1-rc2. I ran the scrub and replace
> xfstests and the script below, which also reproduces the original BUG.
> 
> Thanks!
> 
> Omar Sandoval (4):
>   Btrfs: remove misleading handling of missing device scrub
>   Btrfs: count devices correctly in readahead during RAID 5/6 replace
>   Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation
>   Btrfs: fix device replace of a missing RAID 5/6 device
> 
>  fs/btrfs/raid56.c |  87 +++++++++++++++++++++++++----
>  fs/btrfs/raid56.h |  10 +++-
>  fs/btrfs/reada.c  |   4 +-
>  fs/btrfs/scrub.c  | 164 +++++++++++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 225 insertions(+), 40 deletions(-)
> 

Ping for review.

-- 
Omar
