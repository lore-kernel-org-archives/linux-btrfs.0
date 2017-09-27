Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41413 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752408AbdI0NYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 09:24:04 -0400
Date: Wed, 27 Sep 2017 15:22:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 2/6] Btrfs: heuristic workspace add bucket and sample
 items
Message-ID: <20170927132229.GB31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
 <20170825091845.4120-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825091845.4120-3-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 12:18:41PM +0300, Timofey Titovets wrote:
> Heuristic workspace:
>  - Add bucket for storing byte type counters
>  - Add sample array for storing partial copy of
>    input data range
>  - Add counter for store current sample size to workspace
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/heuristic.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
> index 92f9335bafd4..e3924c87af08 100644
> --- a/fs/btrfs/heuristic.c
> +++ b/fs/btrfs/heuristic.c
> @@ -20,13 +20,29 @@
>  #include <linux/bio.h>
>  #include "compression.h"
> 
> +#define READ_SIZE 16
> +#define ITER_SHIFT 256
> +#define BUCKET_SIZE 256
> +#define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED*READ_SIZE/ITER_SHIFT)

All the defines need a short explanation what's the purpose. I've seen
that eg. READ_SIZE is used as sample size, so I suggest to rename it.

Style issue (here and in many other places): binary operators are
separate by a space from both sides:

#define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED * READ_SIZE / ITER_SHIFT)

> +
> +struct bucket_item {
> +	u32 count;
> +};
> +
>  struct workspace {
> +	u8  *sample;
> +	/* Partial copy of input data */
> +	u32 sample_size;
> +	/* Bucket store counter for each byte type */
> +	struct bucket_item bucket[BUCKET_SIZE];
>  	struct list_head list;
>  };
> 
>  static void heuristic_free_workspace(struct list_head *ws)
>  {
>  	struct workspace *workspace = list_entry(ws, struct workspace, list);
> +
> +	kvfree(workspace->sample);
>  	kfree(workspace);
>  }
> 
> @@ -38,9 +54,16 @@ static struct list_head *heuristic_alloc_workspace(void)
>  	if (!workspace)
>  		return ERR_PTR(-ENOMEM);
> 
> +	workspace->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
> +	if (!workspace->sample)
> +		goto fail;
> +
>  	INIT_LIST_HEAD(&workspace->list);
> 
>  	return &workspace->list;
> +fail:
> +	heuristic_free_workspace(&workspace->list);
> +	return ERR_PTR(-ENOMEM);
>  }

Regarding the workspaces: I think we'll need to separate them completely
from the compression workspaces. The size is different, the usage
pattern is different and they can be reused by all compression types.

The size is obvious, if the size is eg. 4k, and we have like 128k for
compression workspace, we'd waste too much space.

The heruistic workspace could be used more frequently, when we just
sample the data and maybe decide not to compress. Here the locks and
workspaces will not interfere with actuall compression and
decompression.

So the idea is to preallocate a few heuristic workspaces in a similar
way as we do for compression, and add similar fallback logic, when we
need them but all are used.

I'm hoping that the heuristic calculations will be fast enough that we
can avoid the fallback allocation at all.
