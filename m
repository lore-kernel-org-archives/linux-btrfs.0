Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35062 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3FGOgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 10:36:51 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AC69B7C0353
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Jun 2013 08:36:50 -0600 (MDT)
Date: Fri, 7 Jun 2013 10:36:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 5/8] Btrfs: fill UUID tree initially
Message-ID: <20130607143647.GD29248@localhost.localdomain>
References: <cover.1370534937.git.sbehrens@giantdisaster.de>
 <9c19309fec3f04b1f0c0dc0d8081568759ea3582.1370534938.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9c19309fec3f04b1f0c0dc0d8081568759ea3582.1370534938.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 07, 2013 at 04:27:50AM -0600, Stefan Behrens wrote:
> When the UUID tree is initially created, a task is spawned that
> walks through the root tree. For each found subvolume root_item,
> the uuid and received_uuid entries in the UUID tree are added.
> This is such a quick operation so that in case somebody wants
> to unmount the filesystem while the task is still running, the
> unmount is delayed until the UUID tree building task is finished.
> 

What if we crash?  Then we'll think we have a perfectly good uuid tree when its
half full.

> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/ctree.h   |   3 ++
>  fs/btrfs/disk-io.c |   5 ++
>  fs/btrfs/volumes.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 157 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a635dbf..9393228 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -23,6 +23,7 @@
>  #include <linux/highmem.h>
>  #include <linux/fs.h>
>  #include <linux/rwsem.h>
> +#include <linux/semaphore.h>
>  #include <linux/completion.h>
>  #include <linux/backing-dev.h>
>  #include <linux/wait.h>
> @@ -1645,6 +1646,8 @@ struct btrfs_fs_info {
>  	struct btrfs_dev_replace dev_replace;
>  
>  	atomic_t mutually_exclusive_operation_running;
> +
> +	struct semaphore uuid_scan_sem;
>  };
>  
>  /*
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 00bac63..89f99aa 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -31,6 +31,7 @@
>  #include <linux/migrate.h>
>  #include <linux/ratelimit.h>
>  #include <linux/uuid.h>
> +#include <linux/semaphore.h>
>  #include <asm/unaligned.h>
>  #include "compat.h"
>  #include "ctree.h"
> @@ -2288,6 +2289,7 @@ int open_ctree(struct super_block *sb,
>  	init_rwsem(&fs_info->extent_commit_sem);
>  	init_rwsem(&fs_info->cleanup_work_sem);
>  	init_rwsem(&fs_info->subvol_sem);
> +	sema_init(&fs_info->uuid_scan_sem, 1);
>  	fs_info->dev_replace.lock_owner = 0;
>  	atomic_set(&fs_info->dev_replace.nesting_level, 0);
>  	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> @@ -3543,6 +3545,9 @@ int close_ctree(struct btrfs_root *root)
>  	fs_info->closing = 1;
>  	smp_mb();
>  
> +	/* wait for the uuid_scan task to finish */
> +	down(&fs_info->uuid_scan_sem);
> +

Need to re-up it again right?  Thanks,

Josef
