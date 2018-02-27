Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbeB0RxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 12:53:16 -0500
Date: Tue, 27 Feb 2018 18:50:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: fix NPD when target device is missing
Message-ID: <20180227175057.GE27791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180220144625.8909-1-anand.jain@oracle.com>
 <20180223225545.GP1469@twin.jikos.cz>
 <3924655c-6f90-7528-0b76-c775c9eb3acf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3924655c-6f90-7528-0b76-c775c9eb3acf@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 24, 2018 at 10:07:33PM +0800, Anand Jain wrote:
> >> IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
> >> Call Trace:
> >> btrfs_dev_replace_cancel+0x15f/0x180 [btrfs]
> >> btrfs_ioctl+0x2216/0x2590 [btrfs]
> >> do_vfs_ioctl+0x625/0x650
> >> SyS_ioctl+0x4e/0x80
> >> do_syscall_64+0x5d/0x160
> >> entry_SYSCALL64_slow_path+0x25/0x25
> > 
> > Do you have a reproducer for that?
> 
>   For now, I used a tweaked btrfs.ko [1], then
> 
>   mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs
>   btrfs rep start -B /dev/sdb /dev/sdc
>     after reboot, we have the replace target device
>     and now use non-tweaked btrfs.ko
>   mount -o degraded /dev/sdb /btrfs
> 
> [1]
> -----------
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 476981c2cf55..8ea4856b6368 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -25,6 +25,7 @@
>   #include <linux/capability.h>
>   #include <linux/kthread.h>
>   #include <linux/math64.h>
> +#include <linux/reboot.h>
>   #include <asm/div64.h>
>   #include "ctree.h"
>   #include "extent_map.h"
> @@ -419,6 +420,8 @@ int btrfs_dev_replace_start(struct btrfs_fs_info 
> *fs_info,
>                                btrfs_device_get_total_bytes(src_device),
>                                &dev_replace->scrub_progress, 0, 1);
> 
> +       emergency_restart();

Ok, not something that we can easily turn into a regression test.

I'll reorder this fix before patch "btrfs: log, when replace, is
canceled by the user", so it is bisectable. Thanks.
