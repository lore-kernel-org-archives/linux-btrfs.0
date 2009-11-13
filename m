From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix possible panic on unmount
Date: Fri, 13 Nov 2009 15:01:07 -0500
Message-ID: <20091113200107.GF26371@localhost.localdomain>
References: <20091113170651.GD26371@localhost.localdomain> <3d0408630911131156o1ebdefb2gdbd66fe95a760b3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630911131156o1ebdefb2gdbd66fe95a760b3a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 14, 2009 at 03:56:28AM +0800, Yan, Zheng  wrote:
> On Sat, Nov 14, 2009 at 1:06 AM, Josef Bacik <josef@redhat.com> wrote=
:
> > We can race with the unmount of an fs and the stopping of a kthread=
 where we
> > will free the block group before we're done using it. =A0The reason=
 for this is
> > because we do not hold a reference on the block group while its cac=
hing, since
> > the allocator drops its reference once it exits or moves on to the =
next block
> > group. =A0This patch fixes the problem by taking a reference to the=
 block group
> > before we start caching and dropping it when we're done to make sur=
e all
> > accesses to the block group are safe. =A0Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> > =A0fs/btrfs/extent-tree.c | =A0 =A03 +++
> > =A01 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 2a4cdce..197bc1b 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -399,6 +399,8 @@ err:
> >
> > =A0 =A0 =A0 =A0put_caching_control(caching_ctl);
> > =A0 =A0 =A0 =A0atomic_dec(&block_group->space_info->caching_threads=
);
> > + =A0 =A0 =A0 btrfs_put_block_group(block_group);
> > +
> > =A0 =A0 =A0 =A0return 0;
> > =A0}
> >
> > @@ -439,6 +441,7 @@ static int cache_block_group(struct btrfs_block=
_group_cache *cache)
> > =A0 =A0 =A0 =A0up_write(&fs_info->extent_commit_sem);
> >
> > =A0 =A0 =A0 =A0atomic_inc(&cache->space_info->caching_threads);
> > + =A0 =A0 =A0 atomic_inc(&cache->count);
> >
> > =A0 =A0 =A0 =A0tsk =3D kthread_run(caching_kthread, cache, "btrfs-c=
ache-%llu\n",
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->key.objec=
tid);
> > --
>=20
> This won't work since btrfs_free_block_groups call kfree without
> checking the reference
> count. I think the correct way to fix the race is waiting until
> caching threads exit
>=20

We do already do that, but the thing is we mark the block group as bein=
g
finished, and then go on and do other things with it, hence the race.  =
The
correct thing to do is do a put in btrfs_free_block_groups so this prob=
lem
doesn't happen.  I will fix that.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
