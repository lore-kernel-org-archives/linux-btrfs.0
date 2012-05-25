Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59440
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387Ab2EYPSz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 11:18:55 -0400
Date: Fri, 25 May 2012 11:18:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Btrfs: add IO error device stats
Message-ID: <20120525151854.GA23362@infradead.org>
References: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can you explain why the device error counters should be in a filesystem
instead of generic block layer code?

On Fri, May 25, 2012 at 04:06:07PM +0200, Stefan Behrens wrote:
> Changes v1-v2:
> - Remove restriction that BTRFS_IOC_GET_DEVICE_STATS is a privileged
>   operation
> - Cast u64 to unsigned long long for printf()
> 
> Changes v2-v3:
> - Rebased on Chris' current master
> 
> Changes v3-v4:
> - Add padding at end of ioctl structure
> 
> Changes v4-v5:
> - The statistic members in the ioctl are now organized as an array of
>   64 bit values. Symbolic names for the array indexes are defined in
>   an enum, which also defines the max value. This change makes it
>   easier to add new statistic members in the future
> - Give ins_len = -1 to btrfs_search_slot() when an item might get
>   deleted
> - Introduce a helper function for the repeated sequence stat_int() +
>   dirty = 1 + stat_print()
> - Introduce a helper function for the code that shares the bio
>   bi_private member for two pieces of information
> 
> The goal is to detect when drives start to get an increased error rate,
> when drives should be replaced soon. Therefore statistic counters are
> added that count IO errors (read, write and flush). Additionally, the
> software detected errors like checksum errors and corrupted blocks are
> counted.
> 
> An ioctl interface is added to get the device statistic counters.
> A second ioctl is added to atomically get and reset these counters.
> 
> The device statistics are written into the device tree with each
> transaction commit. Only modified statistics are written.
> When a filesystem is mounted, the device statistics for each involved
> device are read from the device tree and used to initialize the
> counters.
> 
> A patch for the btrfs-progs world will also be sent.
> 
> Stefan Behrens (3):
>   Btrfs: add device counters for detected IO and checksum errors
>   Btrfs: add ioctl to get and reset the device stats
>   Btrfs: read device stats on mount, write modified ones during commit
> 
>  fs/btrfs/ctree.h       |   38 ++++++
>  fs/btrfs/disk-io.c     |   20 +++-
>  fs/btrfs/extent_io.c   |   18 ++-
>  fs/btrfs/ioctl.c       |   26 +++++
>  fs/btrfs/ioctl.h       |   33 ++++++
>  fs/btrfs/print-tree.c  |    3 +
>  fs/btrfs/scrub.c       |   65 ++++++++---
>  fs/btrfs/transaction.c |    4 +
>  fs/btrfs/volumes.c     |  304 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.h     |   52 +++++++++
>  10 files changed, 539 insertions(+), 24 deletions(-)
> 
> -- 
> 1.7.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
