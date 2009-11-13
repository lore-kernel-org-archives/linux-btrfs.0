From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix possible panic on unmount
Date: Sat, 14 Nov 2009 03:56:28 +0800
Message-ID: <3d0408630911131156o1ebdefb2gdbd66fe95a760b3a@mail.gmail.com>
References: <20091113170651.GD26371@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091113170651.GD26371@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 14, 2009 at 1:06 AM, Josef Bacik <josef@redhat.com> wrote:
> We can race with the unmount of an fs and the stopping of a kthread w=
here we
> will free the block group before we're done using it. =A0The reason f=
or this is
> because we do not hold a reference on the block group while its cachi=
ng, since
> the allocator drops its reference once it exits or moves on to the ne=
xt block
> group. =A0This patch fixes the problem by taking a reference to the b=
lock group
> before we start caching and dropping it when we're done to make sure =
all
> accesses to the block group are safe. =A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0fs/btrfs/extent-tree.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2a4cdce..197bc1b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -399,6 +399,8 @@ err:
>
> =A0 =A0 =A0 =A0put_caching_control(caching_ctl);
> =A0 =A0 =A0 =A0atomic_dec(&block_group->space_info->caching_threads);
> + =A0 =A0 =A0 btrfs_put_block_group(block_group);
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -439,6 +441,7 @@ static int cache_block_group(struct btrfs_block_g=
roup_cache *cache)
> =A0 =A0 =A0 =A0up_write(&fs_info->extent_commit_sem);
>
> =A0 =A0 =A0 =A0atomic_inc(&cache->space_info->caching_threads);
> + =A0 =A0 =A0 atomic_inc(&cache->count);
>
> =A0 =A0 =A0 =A0tsk =3D kthread_run(caching_kthread, cache, "btrfs-cac=
he-%llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->key.objecti=
d);
> --

This won't work since btrfs_free_block_groups call kfree without
checking the reference
count. I think the correct way to fix the race is waiting until
caching threads exit

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
