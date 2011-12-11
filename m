From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 0/3] Btrfs: add IO error device stats
Date: Sun, 11 Dec 2011 11:18:41 +0100
Message-ID: <3053163.ZxgpK7HNQ4@venice>
References: <cover.1323448299.git.sbehrens@giantdisaster.de>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1323448299.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 09 December, 2011 17:40:25 Stefan Behrens wrote:
> The goal is to detect when drives start to get an increased error rate,
> when drives should be replaced soon. Therefore statistic counters are
> added that count IO errors (read, write and flush). Additionally, the
> software detected errors like checksum errors and corrupted blocks are
> counted.
> 
> An ioctl interface is added to get the device statistic counters.
> A second ioctl is added to atomically get and reset these counters.

Hi Stefan, what about exporting these information under /sys ? Something like:

/sys/fs/btrfs/devices/<uuid>/error/cnt_write_io_errs
/sys/fs/btrfs/devices/<uuid>/error/cnt_read_io_errs
/sys/fs/btrfs/devices/<uuid>/error/cnt_flush_io_errs
/sys/fs/btrfs/devices/<uuid>/error/cnt_corruption_errs
/sys/fs/btrfs/devices/<uuid>/error/cnt_generation_errs

/sys/fs/btrfs/devices/<uuid>/error/cnt_write_io_errs_0
/sys/fs/btrfs/devices/<uuid>/error/cnt_read_io_errs_0
/sys/fs/btrfs/devices/<uuid>/error/cnt_flush_io_errs_0
/sys/fs/btrfs/devices/<uuid>/error/cnt_corruption_errs_0
/sys/fs/btrfs/devices/<uuid>/error/cnt_generation_errs_0

where the '_0' family are for "read and reset" behaviour.

This would be very flexible when another count will be added...



> The device statistics are written into the device tree with each
> transaction commit. Only modified statistics are written.
> When a filesystem is mounted, the device statistic for each involved
> device are read from the device tree and used to initialize the
> counters.
> 
> A patch for the btrfs-progs world will also be sent.
> 
> The patches are based on v3.1-161-gf4a8e65 (btrfs pull request from
> 12/1/2011).
> 
> Stefan Behrens (3):
>   Btrfs: add device counters for detected IO and checksum errors
>   Btrfs: add ioctl to get and reset the device stats
>   Btrfs: read device stats on mount, write modified ones during commit
> 
>  fs/btrfs/ctree.h       |   51 ++++++++
>  fs/btrfs/disk-io.c     |   25 +++-
>  fs/btrfs/extent_io.c   |   27 ++++-
>  fs/btrfs/ioctl.c       |   26 ++++
>  fs/btrfs/ioctl.h       |   27 ++++
>  fs/btrfs/print-tree.c  |    3 +
>  fs/btrfs/scrub.c       |   52 ++++++--
>  fs/btrfs/transaction.c |    4 +
>  fs/btrfs/volumes.c     |  335
> +++++++++++++++++++++++++++++++++++++++++++++++- fs/btrfs/volumes.h     |  
> 43 ++++++
>  10 files changed, 575 insertions(+), 18 deletions(-)
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
