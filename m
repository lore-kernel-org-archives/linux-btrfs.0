Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36414 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbcESK3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 06:29:49 -0400
Received: by mail-ig0-f196.google.com with SMTP id c3so7022287igl.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 03:29:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1463651050-6922-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1463651050-6922-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Date: Thu, 19 May 2016 11:29:48 +0100
Message-ID: <CAL3q7H4yj91ah-cRrjtOceUW02boRCv9_hazS7KGJr065R30Sg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove unnecessary btrfs_delalloc_release_metadata()
 call
From: Filipe Manana <fdmanana@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 10:44 AM, Wang Xiaoguang
<wangxg.fnst@cn.fujitsu.com> wrote:
> In __btrfs_write_out_cache(), we don't call btrfs_delalloc_reserve_metadata()
> or btrfs_delalloc_reserve_space() to reserve metadata space, so we also should
> not call btrfs_delalloc_release_metadata(), in which BTRFS_I(inode)->outstanding_extents
> will be decreased, then WARN_ON(BTRFS_I(inode)->outstanding_extents) in
> btrfs_destroy_inode() will be triggered.
>
> To be honest, I do not see this WARNING in real, but I think we should fix it.

No, this is wrong.

We do this call to release reserved metadata space at
btrfs_save_ino_cache() through btrfs_delalloc_reserve_space().
And it's btrfs_save_ino_cache() that calls btrfs_write_out_ino_cache().

If what you said were true, then it would be trivial to write a test
case (using the inode cache feature) to trigger the problem.



>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/free-space-cache.c | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 8f835bf..ababf56 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -3512,7 +3512,6 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>         struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
>         int ret;
>         struct btrfs_io_ctl io_ctl;
> -       bool release_metadata = true;
>
>         if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>                 return 0;
> @@ -3520,26 +3519,16 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>         memset(&io_ctl, 0, sizeof(io_ctl));
>         ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
>                                       trans, path, 0);
> -       if (!ret) {
> -               /*
> -                * At this point writepages() didn't error out, so our metadata
> -                * reservation is released when the writeback finishes, at
> -                * inode.c:btrfs_finish_ordered_io(), regardless of it finishing
> -                * with or without an error.
> -                */
> -               release_metadata = false;
> +       if (!ret)
>                 ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
> -       }
>
> -       if (ret) {
> -               if (release_metadata)
> -                       btrfs_delalloc_release_metadata(inode, inode->i_size);
>  #ifdef DEBUG
> +       if (ret) {
>                 btrfs_err(root->fs_info,
>                         "failed to write free ino cache for root %llu",
>                         root->root_key.objectid);
> -#endif
>         }
> +#endif
>
>         return ret;
>  }
> --
> 1.8.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
