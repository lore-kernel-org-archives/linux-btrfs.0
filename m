Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36017 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbcGYNsT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 09:48:19 -0400
Received: by mail-io0-f196.google.com with SMTP id y34so11826533ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jul 2016 06:48:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 25 Jul 2016 14:48:17 +0100
Message-ID: <CAL3q7H7sbHH16nFextVEwY_zYHyKhpSQE7phm687Viuq5U0k6A@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2016 at 8:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> This patch will disable clone detection of send.
>
> The main problem of clone detetion in send is its memory usage and long
> execution time.
>
> The clone detection is done by iterating all backrefs and adding backref
> whose root is the source.
>
> However iterating all backrefs is already quite a bad idea, we should
> never try to do it in a loop, and unfortunately in-band/out-of-band and
> reflink can easily create a file whose file extents are point to the
> same extent.
>
> In that case, btrfs will do backref walk for the same extent again and
> again, until either OOM or soft lockup is triggered.
>
> So disabling clone detection until we find a method that iterates
> backrefs of one extent only once, just like what balance/qgroup is doing.

Is this really a common scenario?
I don't recall ever seeing a report of such slow down or oom due to
the same file pointing to the same extent thousands of times.
Sure it's easy to create such scenario with artificial test data for
our inband deduplication feature (and we should really strive to make
what we have stable and reliable rather than add yet more features).

What needs to be fixed here is the common backref walking code, called
by send plus a few other places (fiemap and some ioctls at least), for
which IIRC there was
some recent patch from one of your colleagues.

Disabling this code makes the problem go away for the scenario of the
same file pointing to the same extent thousands of times (or tens or
hundreds of thousands, whatever).
But what happens if a file points to an extent once but the extent is
referenced by other 100k files (possibly in different snapshots or
subvolumes), isn't it the same problem? The backref code has to find
all such inodes/offsets/roots and take again the same long time...

Following your logic, it seems like everything that uses the backref
walking code should be disabled.

>
> Cc: Filipe Manana <fdmanana@gmail.com>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/send.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 2db8dc8..eed3f1c 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1166,6 +1166,7 @@ struct backref_ctx {
>         int found_itself;
>  };
>
> +#if 0
>  static int __clone_root_cmp_bsearch(const void *key, const void *elt)
>  {
>         u64 root = (u64)(uintptr_t)key;
> @@ -1177,6 +1178,7 @@ static int __clone_root_cmp_bsearch(const void *key, const void *elt)
>                 return 1;
>         return 0;
>  }
> +#endif
>
>  static int __clone_root_cmp_sort(const void *e1, const void *e2)
>  {
> @@ -1190,6 +1192,7 @@ static int __clone_root_cmp_sort(const void *e1, const void *e2)
>         return 0;
>  }
>
> +#if 0
>  /*
>   * Called for every backref that is found for the current extent.
>   * Results are collected in sctx->clone_roots->ino/offset/found_refs
> @@ -1445,6 +1448,7 @@ out:
>         kfree(backref_ctx);
>         return ret;
>  }
> +#endif
>
>  static int read_symlink(struct btrfs_root *root,
>                         u64 ino,
> @@ -5291,7 +5295,6 @@ static int process_extent(struct send_ctx *sctx,
>                           struct btrfs_path *path,
>                           struct btrfs_key *key)
>  {
> -       struct clone_root *found_clone = NULL;
>         int ret = 0;
>
>         if (S_ISLNK(sctx->cur_inode_mode))
> @@ -5333,12 +5336,27 @@ static int process_extent(struct send_ctx *sctx,
>                 }
>         }
>
> +       /*
> +        * Current clone detection is both time and memory consuming.
> +        *
> +        * Time consuming is caused by iterating all backref of extent.
> +        * Memory consuming is caused by allocating "found_clone" every
> +        * time for a backref.
> +        *
> +        * XXX: Disabling it is never the best method, but at least it
> +        * won't cause OOM nor super long execution time.
> +        * The root fix needs to change the iteration basis, from iterating
> +        * file extents to iterating extents, so find_parent_nodes() and
> +        * backref walk should be called only once for one extent.
> +        */
> +#if 0
>         ret = find_extent_clone(sctx, path, key->objectid, key->offset,
>                         sctx->cur_inode_size, &found_clone);
>         if (ret != -ENOENT && ret < 0)
>                 goto out;
> +#endif
>
> -       ret = send_write_or_clone(sctx, path, key, found_clone);
> +       ret = send_write_or_clone(sctx, path, key, NULL);
>         if (ret)
>                 goto out;
>  out_hole:
> --
> 2.9.0
>
>
>



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
