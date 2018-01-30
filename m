Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751991AbeA3OWx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:22:53 -0500
Date: Tue, 30 Jan 2018 15:20:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: fix device order consistency
Message-ID: <20180130142040.GJ19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180122224937.3458-1-anand.jain@oracle.com>
 <20180122224937.3458-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180122224937.3458-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 22, 2018 at 02:49:36PM -0800, Anand Jain wrote:
> By maintaining the device order consistency it makes reproducing
> the problems related to missing chunk in the degraded mode much more
> consistent. So fix this by sorting the devices by devid within the
> kernel. So that we know which device is assigned to the struct
> fs_info::latest_bdev when all the devices are having and same
> SB generation.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 03f2685a5018..98e41d286283 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -27,6 +27,7 @@
>  #include <linux/raid/pq.h>
>  #include <linux/semaphore.h>
>  #include <linux/uuid.h>
> +#include <linux/list_sort.h>
>  #include <asm/div64.h>
>  #include "ctree.h"
>  #include "extent_map.h"
> @@ -1107,6 +1108,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  	return ret;
>  }
>  
> +static int device_sort(void *priv, struct list_head *a, struct list_head *b)

I'll rename that to devid_cmp as it's the comparator and not really a
sorting function.
