Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34086 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdL3Uod (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Dec 2017 15:44:33 -0500
Received: by mail-it0-f66.google.com with SMTP id m11so6496738iti.1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Dec 2017 12:44:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171224045528.12991-2-nefelim4ag@gmail.com>
References: <20171224045528.12991-1-nefelim4ag@gmail.com> <20171224045528.12991-2-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 30 Dec 2017 23:43:52 +0300
Message-ID: <CAGqmi74VmyaOOt-_fux-92nLA2A8a6eqrsb7Xxdv1QUCo=h6-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: heuristic: replace workspace managment code by
 mempool API
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-24 7:55 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Currently compression code have custom workspace/memory cache
> for guarantee forward progress on high memory pressure.
>
> That api can be replaced with mempool API, which can guarantee the same.
> Main goal is simplify/cleanup code and replace it with general solution.
>
> I try avoid use of atomic/lock/wait stuff,
> as that all already hidden in mempool API.
> Only thing that must be racy safe is initialization of
> mempool.
>
> So i create simple mempool_alloc_wrap, which will handle
> mempool_create failures, and sync threads work by cmpxchg()
> on mempool_t pointer.
>
> Another logic difference between our custom stuff and mempool:
>  - ws find/free mosly reuse current workspaces whenever possible.
>  - mempool use alloc/free of provided helpers with more
>    aggressive use of __GFP_NOMEMALLOC, __GFP_NORETRY, GFP_NOWARN,
>    and only use already preallocated space when memory get tight.
>
> Not sure which approach are better, but simple stress tests with
> writing stuff on compressed fs on ramdisk show negligible difference on
> 8 CPU Virtual Machine with Intel Xeon E5-2420 0 @ 1.90GHz (+-1%).
>
> Other needed changes to use mempool:
>  - memalloc_nofs_{save,restore} move to each place where kvmalloc
>    will be used in call chain.
>  - mempool_create return pointer to mampool or NULL,
>    no error, so macros like IS_ERR(ptr) can't be used.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 197 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 106 insertions(+), 91 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 208334aa6c6e..02bd60357f04 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -34,6 +34,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched/mm.h>
>  #include <linux/log2.h>
> +#include <linux/mempool.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -768,46 +769,46 @@ struct heuristic_ws {
>         struct bucket_item *bucket;
>         /* Sorting buffer */
>         struct bucket_item *bucket_b;
> -       struct list_head list;
>  };
>
> -static void free_heuristic_ws(struct list_head *ws)
> +static void heuristic_ws_free(void *element, void *pool_data)
>  {
> -       struct heuristic_ws *workspace;
> +       struct heuristic_ws *ws = (struct heuristic_ws *) element;
>
> -       workspace = list_entry(ws, struct heuristic_ws, list);
> -
> -       kvfree(workspace->sample);
> -       kfree(workspace->bucket);
> -       kfree(workspace->bucket_b);
> -       kfree(workspace);
> +       kfree(ws->sample);
> +       kfree(ws->bucket);
> +       kfree(ws->bucket_b);
> +       kfree(ws);
>  }
>
> -static struct list_head *alloc_heuristic_ws(void)
> +static void *heuristic_ws_alloc(gfp_t gfp_mask, void *pool_data)
>  {
> -       struct heuristic_ws *ws;
> +       struct heuristic_ws *ws = kzalloc(sizeof(*ws), gfp_mask);
>
> -       ws = kzalloc(sizeof(*ws), GFP_KERNEL);
>         if (!ws)
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>
> -       ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
> +       /*
> +        * We can handle allocation failures and
> +        * slab have caches for 8192 byte allocations
> +        */
> +       ws->sample = kmalloc(MAX_SAMPLE_SIZE, gfp_mask);
>         if (!ws->sample)
>                 goto fail;
>
> -       ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), GFP_KERNEL);
> +       ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), gfp_mask);
>         if (!ws->bucket)
>                 goto fail;
>
> -       ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), GFP_KERNEL);
> +       ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), gfp_mask);
>         if (!ws->bucket_b)
>                 goto fail;
>
> -       INIT_LIST_HEAD(&ws->list);
> -       return &ws->list;
> +       return ws;
> +
>  fail:
> -       free_heuristic_ws(&ws->list);
> -       return ERR_PTR(-ENOMEM);
> +       heuristic_ws_free(ws, NULL);
> +       return NULL;
>  }
>
>  struct workspaces_list {
> @@ -821,9 +822,12 @@ struct workspaces_list {
>         wait_queue_head_t ws_wait;
>  };
>
> -static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
> +struct workspace_stor {
> +       mempool_t *pool;
> +};
>
> -static struct workspaces_list btrfs_heuristic_ws;
> +static struct workspace_stor btrfs_heuristic_ws_stor;
> +static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
>
>  static const struct btrfs_compress_op * const btrfs_compress_op[] = {
>         &btrfs_zlib_compress,
> @@ -835,21 +839,17 @@ void __init btrfs_init_compress(void)
>  {
>         struct list_head *workspace;
>         int i;
> +       mempool_t *pool = btrfs_heuristic_ws_stor.pool;
>
> -       INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
> -       spin_lock_init(&btrfs_heuristic_ws.ws_lock);
> -       atomic_set(&btrfs_heuristic_ws.total_ws, 0);
> -       init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);
> +       /*
> +        * Preallocate one workspace for heuristic so
> +        * we can guarantee forward progress in the worst case
> +        */
> +       pool = mempool_create(1, heuristic_ws_alloc,
> +                                heuristic_ws_free, NULL);
>
> -       workspace = alloc_heuristic_ws();
> -       if (IS_ERR(workspace)) {
> -               pr_warn(
> -       "BTRFS: cannot preallocate heuristic workspace, will try later\n");
> -       } else {
> -               atomic_set(&btrfs_heuristic_ws.total_ws, 1);
> -               btrfs_heuristic_ws.free_ws = 1;
> -               list_add(workspace, &btrfs_heuristic_ws.idle_ws);
> -       }
> +       if (pool == NULL)
> +               pr_warn("BTRFS: cannot preallocate heuristic workspace, will try later\n");
>
>         for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
>                 INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
> @@ -872,13 +872,67 @@ void __init btrfs_init_compress(void)
>         }
>  }
>
> +/*
> + * Handle mempool init failures
> + * Call resize of mempool if min_nr and ncpu differ
> + */
> +static void *mempool_alloc_wrap(struct workspace_stor *stor)
> +{
> +       int ncpu = num_online_cpus();
> +
> +       while (unlikely(stor->pool == NULL)) {
> +               mempool_t *pool;
> +               void *(*ws_alloc)(gfp_t gfp_mask, void *pool_data);
> +               void (*ws_free)(void *element, void *pool_data);
> +
> +               if (stor == &btrfs_heuristic_ws_stor) {
> +                       ws_alloc = heuristic_ws_alloc;
> +                       ws_free  = heuristic_ws_free;
> +               }
> +
> +               pool = mempool_create(1, ws_alloc, ws_free, NULL);
> +
> +               if (pool) {
> +                       pool = cmpxchg(&stor->pool, NULL, pool);
> +                       if (pool)
> +                               mempool_destroy(pool);
> +               }
> +
> +               if (stor->pool == NULL) {
> +                       /* once per minute, no burst */
> +                       static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, 1);
> +
> +                       if (__ratelimit(&_rs))
> +                               pr_warn("BTRFS: no compression workspaces, low memory, retrying\n");
> +               }
> +       }
> +
> +       /*
> +        * mempool_resize() can return error
> +        * but we can safely ignore it and try resize again
> +        * on next allocate request
> +        */
> +       if (stor->pool->min_nr != ncpu)
> +               mempool_resize(stor->pool, ncpu);
> +
> +       return mempool_alloc(stor->pool, GFP_KERNEL);
> +}

Just notice:
That may be a sense to specify also: __GFP_DIRECT_RECLAIM, as GFP flag,
Because for mempool, if:
1. General allocation fail
2. Mempool allocation have no free workspaces
3. Second try on 1 & 2 fail

Mempool will not wait return of element to pool and can return NULL.
By specify __GFP_DIRECT_RECLAIM we allow mempool to wait for free some element
and returning it to pool.

Thanks.

-- 
Have a nice day,
Timofey.
