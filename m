Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18593 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdFADaU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 23:30:20 -0400
Subject: Re: [PATCH 1/3] btrfs: add memalloc_nofs protections around
 alloc_workspace callback
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496245064.git.dsterba@suse.com>
 <b5e9ce7c8b9b1a41adaaac883b15bf63c58dff93.1496245064.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b4796263-581c-2987-fc47-cfae943a31e6@oracle.com>
Date: Thu, 1 Jun 2017 11:36:23 +0800
MIME-Version: 1.0
In-Reply-To: <b5e9ce7c8b9b1a41adaaac883b15bf63c58dff93.1496245064.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/31/17 23:41, David Sterba wrote:
> The workspaces are preallocated at the beginning where we can safely use
> GFP_KERNEL, but in some cases the find_workspace might reach the
> allocation again, now in a more restricted context when the bios or
> pages are being compressed.
>
> To avoid potential lockup when alloc_workspace -> vmalloc would silently
> use the GFP_KERNEL, add the memalloc_nofs helpers around the critical
> call site.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/compression.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ba511dd454d5..39cd164e5a62 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -32,6 +32,7 @@
>  #include <linux/writeback.h>
>  #include <linux/bit_spinlock.h>
>  #include <linux/slab.h>
> +#include <linux/sched/mm.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -757,6 +758,7 @@ static struct list_head *find_workspace(int type)
>  	struct list_head *workspace;
>  	int cpus = num_online_cpus();
>  	int idx = type - 1;
> +	unsigned nofs_flag;
>
>  	struct list_head *idle_ws	= &btrfs_comp_ws[idx].idle_ws;
>  	spinlock_t *ws_lock		= &btrfs_comp_ws[idx].ws_lock;
> @@ -786,7 +788,15 @@ static struct list_head *find_workspace(int type)
>  	atomic_inc(total_ws);
>  	spin_unlock(ws_lock);
>
> +	/*
> +	 * Allocation helpers call vmalloc that can't use GFP_NOFS, so we have
> +	 * to turn it off here because we might get called from the restricted
> +	 * context of btrfs_compress_bio/btrfs_compress_pages
> +	 */
> +	nofs_flag = memalloc_nofs_save();
>  	workspace = btrfs_compress_op[idx]->alloc_workspace();
> +	memalloc_nofs_restore(nofs_flag);
> +
>  	if (IS_ERR(workspace)) {
>  		atomic_dec(total_ws);
>  		wake_up(ws_wait);
>



