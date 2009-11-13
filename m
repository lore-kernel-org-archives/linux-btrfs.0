From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [PATCH] Btrfs: fix possible panic on unmount
Date: Fri, 13 Nov 2009 20:29:37 +0300
Message-ID: <2a31deca0911130929k4df4685fxddbedd44bada5e54@mail.gmail.com>
References: <20091113170651.GD26371@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091113170651.GD26371@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2009 at 8:06 PM, Josef Bacik <josef@redhat.com> wrote:
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

It would be slightly more informative/stylish if
atomic_inc(&cache->count) is replaced by a cal to
static inline void btrfs_get_block_group(struct btrfs_block_group_cache=
 *cache)
{
	atomic_inc(&cache->count);
}


Regards,
Andrey

>
> =A0 =A0 =A0 =A0tsk =3D kthread_run(caching_kthread, cache, "btrfs-cac=
he-%llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->key.objecti=
d);
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
