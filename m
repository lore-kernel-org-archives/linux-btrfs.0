From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix ENOSPC accounting when max_extent is not maxed
	out V2
Date: Fri, 19 Mar 2010 11:09:25 +0800
Message-ID: <3d0408631003182009qaca6e9cp6c389dad257b987a@mail.gmail.com>
References: <20100318154730.GA20818@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100318154730.GA20818@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 18, 2010 at 11:47 PM, Josef Bacik <josef@redhat.com> wrote:
> A user reported a bug a few weeks back where if he set max_extent=3D1=
m and then
> did a dd and then stopped it, we would panic. =A0This is because I mi=
scalculated
> how many extents would be needed for splits/merges. =A0Turns out I di=
dn't actually
> take max_extent into account properly, since we only ever add 1 exten=
t for a
> write, which isn't quite right for the case that say max_extent is 4k=
 and we do
> 8k writes. =A0That would result in more than 1 extent. =A0So this pat=
ch makes us
> properly figure out how many extents are needed for the amount of dat=
a that is
> being written, and deals with splitting and merging better. =A0I've t=
ested this ad
> nauseum and it works well. =A0This version doesn't depend on my per-c=
pu stuff.
> Thanks,

Why not remove the the max_extent check. The max length of file extent
is also affected by fragmentation level of free space. It doesn't make =
sense
to introduce complex code to address one factor while lose sight of ano=
ther
factor. I think reserving one unit of metadata for each delalloc extent=
 in the
extent IO tree should be OK. because even a delalloc extent ends up wit=
h
multiple file extents, these file extents are adjacency in the b-tree.

Regards
Yan, Zheng

>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 =A0| =A0 =A08 ++++
> =A0fs/btrfs/extent-tree.c =A0| =A0 =A04 +-
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0 | =A0 =A05 +-
> =A0fs/btrfs/inode.c =A0 =A0 =A0 =A0| =A0 95 +++++++++++++++++++++++++=
++++++---------------
> =A0fs/btrfs/ordered-data.c | =A0 =A06 ++-
> =A05 files changed, 81 insertions(+), 37 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1111584..7d478b4 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1960,6 +1960,14 @@ static inline struct dentry *fdentry(struct fi=
le *file)
> =A0 =A0 =A0 =A0return file->f_path.dentry;
> =A0}
>
> +static inline int calculate_extents(struct btrfs_root *root, u64 byt=
es)
> +{
> + =A0 =A0 =A0 if (bytes <=3D root->fs_info->max_extent)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 return (int)div64_u64(bytes + root->fs_info->max_extent=
 -1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->fs_in=
fo->max_extent);
> +}
> +
> =A0/* extent-tree.c */
> =A0void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
> =A0int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 826120f..7bb97de 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2848,7 +2848,7 @@ int btrfs_unreserve_metadata_for_delalloc(struc=
t btrfs_root *root,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&BTRFS_I(inode)->accounting_lock);
>
> - =A0 =A0 =A0 BTRFS_I(inode)->reserved_extents--;
> + =A0 =A0 =A0 BTRFS_I(inode)->reserved_extents -=3D num_items;
> =A0 =A0 =A0 =A0BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
>
> =A0 =A0 =A0 =A0if (meta_sinfo->bytes_delalloc < num_bytes) {
> @@ -3110,7 +3110,7 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOSPC;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 BTRFS_I(inode)->reserved_extents++;
> + =A0 =A0 =A0 BTRFS_I(inode)->reserved_extents +=3D num_items;
> =A0 =A0 =A0 =A0check_force_delalloc(meta_sinfo);
> =A0 =A0 =A0 =A0spin_unlock(&meta_sinfo->lock);
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index d146dde..a457a94 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -838,6 +838,7 @@ static ssize_t btrfs_file_write(struct file *file=
, const char __user *buf,
> =A0 =A0 =A0 =A0unsigned long first_index;
> =A0 =A0 =A0 =A0unsigned long last_index;
> =A0 =A0 =A0 =A0int will_write;
> + =A0 =A0 =A0 int reserved =3D calculate_extents(root, count);
>
> =A0 =A0 =A0 =A0will_write =3D ((file->f_flags & O_SYNC) || IS_SYNC(in=
ode) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(file->f_flags & O_DIRECT)=
);
> @@ -855,7 +856,7 @@ static ssize_t btrfs_file_write(struct file *file=
, const char __user *buf,
> =A0 =A0 =A0 =A0/* do the reserve before the mutex lock in case we hav=
e to do some
> =A0 =A0 =A0 =A0 * flushing. =A0We wouldn't deadlock, but this is more=
 polite.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 err =3D btrfs_reserve_metadata_for_delalloc(root, inode=
, 1);
> + =A0 =A0 =A0 err =3D btrfs_reserve_metadata_for_delalloc(root, inode=
, reserved);
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_nolock;
>
> @@ -975,7 +976,7 @@ out:
> =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ret;
> - =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
> + =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode, rese=
rved);
>
> =A0out_nolock:
> =A0 =A0 =A0 =A0kfree(pages);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2a337a0..52cb47f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1235,19 +1235,37 @@ static int btrfs_split_extent_hook(struct ino=
de *inode,
>
> =A0 =A0 =A0 =A0size =3D orig->end - orig->start + 1;
> =A0 =A0 =A0 =A0if (size > root->fs_info->max_extent) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 num_extents;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 new_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 left_extents, right_extents;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 orig_extents;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 left_size, right_size;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_size =3D orig->end - split + 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_extents =3D div64_u64(size + root->=
fs_info->max_extent - 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 root->fs_info->max_extent);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 left_size =3D orig->end - split + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 right_size =3D split - orig->start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 left_extents =3D calculate_extents(root=
, left_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 right_extents =3D calculate_extents(roo=
t, right_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 orig_extents =3D calculate_extents(root=
, size);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if we break a large extent up then=
 leave oustanding_extents
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* be, since we've already accounted =
for the large extent.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If we are splitting off a max_exte=
nt multiple of space, then
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we don't need to account for anoth=
er extent. =A0However if we
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* take off less than a max_extent, w=
e need to add another
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* outstanding_extent, because we wil=
l likely still have the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* original amount of extents needed =
for the big chunk left
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* over.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Think of it this way. =A0We have 4=
 outstanding extents for the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* original giant chunk of data. =A0I=
f we split off a max_extent
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* sized chunk, then the remaining ch=
unk has 3 outstanding
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* extens, and the new little chunk h=
as 1 outstanding extents
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* worth, so we're even.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* But if we carve off < max_extent, =
thats its own extent still.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* So the left over chunk still needs=
 4 extents to describe it
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* on disk, and the chunk we just spl=
it off needs 1 extent, so
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* thats 5 total extents, so we need =
to add 1 to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* outstanding_extents.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (div64_u64(new_size + root->fs_info-=
>max_extent - 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->fs_in=
fo->max_extent) < num_extents)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (left_extents + right_extents =3D=3D=
 orig_extents)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> @@ -1269,18 +1287,16 @@ static int btrfs_merge_extent_hook(struct ino=
de *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct extent_state *other)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_root *root =3D BTRFS_I(inode)->root;
> - =A0 =A0 =A0 u64 new_size, old_size;
> - =A0 =A0 =A0 u64 num_extents;
> + =A0 =A0 =A0 u64 new_size, size1, size2;
> + =A0 =A0 =A0 u64 extents1, extents2;
>
> =A0 =A0 =A0 =A0/* not delalloc, ignore it */
> =A0 =A0 =A0 =A0if (!(other->state & EXTENT_DELALLOC))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> - =A0 =A0 =A0 old_size =3D other->end - other->start + 1;
> - =A0 =A0 =A0 if (new->start < other->start)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_size =3D other->end - new->start + =
1;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_size =3D new->end - other->start + =
1;
> + =A0 =A0 =A0 size1 =3D other->end - other->start + 1;
> + =A0 =A0 =A0 size2 =3D new->end - new->start + 1;
> + =A0 =A0 =A0 new_size =3D size1 + size2;
>
> =A0 =A0 =A0 =A0/* we're not bigger than the max, unreserve the space =
and go */
> =A0 =A0 =A0 =A0if (new_size <=3D root->fs_info->max_extent) {
> @@ -1290,14 +1306,20 @@ static int btrfs_merge_extent_hook(struct ino=
de *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 extents1 =3D calculate_extents(root, size1);
> + =A0 =A0 =A0 extents2 =3D calculate_extents(root, size2);
> +
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* If we grew by another max_extent, just return, we =
want to keep that
> - =A0 =A0 =A0 =A0* reserved amount.
> + =A0 =A0 =A0 =A0* So if the number of extents required for the two c=
hunks of space we
> + =A0 =A0 =A0 =A0* are merging equals the number of extents we need f=
or the entire space
> + =A0 =A0 =A0 =A0* we now have, just return.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* The idea here is if max extent is say 1M, and the =
first chunk was
> + =A0 =A0 =A0 =A0* exactly 1M and the second chunk was 4k, we now nee=
d 2 extents to
> + =A0 =A0 =A0 =A0* cover that area, so we keep the reservation we got=
 from adding the 4k
> + =A0 =A0 =A0 =A0* extent.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 num_extents =3D div64_u64(old_size + root->fs_info->max=
_extent - 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->f=
s_info->max_extent);
> - =A0 =A0 =A0 if (div64_u64(new_size + root->fs_info->max_extent - 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->fs_info->max_extent) =
> num_extents)
> + =A0 =A0 =A0 if (calculate_extents(root, new_size) =3D=3D extents1 +=
 extents2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0spin_lock(&BTRFS_I(inode)->accounting_lock);
> @@ -1323,11 +1345,13 @@ static int btrfs_set_bit_hook(struct inode *i=
node, u64 start, u64 end,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLO=
C)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *root =3D BTRFS_I(in=
ode)->root;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int extents =3D calculate_extents(root,=
 end - start + 1);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&BTRFS_I(inode)->accounting_=
lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_I(inode)->outstanding_extents++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_I(inode)->outstanding_extents +=3D=
 extents;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&BTRFS_I(inode)->accountin=
g_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_delalloc_reserve_space(root, ino=
de, end - start + 1);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&root->fs_info->delalloc_loc=
k);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BTRFS_I(inode)->delalloc_bytes +=3D en=
d - start + 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->delalloc_bytes +=3D end=
 - start + 1;
> @@ -1355,10 +1379,15 @@ static int btrfs_clear_bit_hook(struct inode =
*inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *root =3D BTRFS_I(in=
ode)->root;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bits & EXTENT_DO_ACCOUNTING) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int extents =3D calcula=
te_extents(root, state->end -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state->start + 1);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&BTRFS_I(ino=
de)->accounting_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_I(inode)->outstan=
ding_extents--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(BTRFS_I(inode)-=
>outstanding_extents < extents);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BTRFS_I(inode)->outstan=
ding_extents -=3D extents;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&BTRFS_I(i=
node)->accounting_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_unreserve_metadat=
a_for_delalloc(root, inode, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_unreserve_metadat=
a_for_delalloc(root, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extents);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&root->fs_info->delalloc_loc=
k);
> @@ -3106,7 +3135,8 @@ static int btrfs_truncate_page(struct address_s=
pace *mapping, loff_t from)
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_for_delalloc(root, inode=
, 1);
> + =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_for_delalloc(root, inode=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calcula=
te_extents(root, PAGE_CACHE_SIZE));
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> @@ -3115,7 +3145,8 @@ again:
> =A0 =A0 =A0 =A0page =3D grab_cache_page(mapping, index);
> =A0 =A0 =A0 =A0if (!page) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_free_reserved_data_space(root, i=
node, PAGE_CACHE_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(r=
oot, inode, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(r=
oot, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calcula=
te_extents(root, PAGE_CACHE_SIZE));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> @@ -3179,7 +3210,8 @@ again:
> =A0out_unlock:
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_free_reserved_data_space(root, i=
node, PAGE_CACHE_SIZE);
> - =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
> + =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calcula=
te_extents(root, PAGE_CACHE_SIZE));
> =A0 =A0 =A0 =A0unlock_page(page);
> =A0 =A0 =A0 =A0page_cache_release(page);
> =A0out:
> @@ -5098,7 +5130,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *v=
ma, struct vm_fault *vmf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_for_delalloc(root, inode=
, 1);
> + =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_for_delalloc(root, inode=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calcula=
te_extents(root, PAGE_CACHE_SIZE));
> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_free_reserved_data_space(root, i=
node, PAGE_CACHE_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D VM_FAULT_SIGBUS;
> @@ -5182,7 +5215,8 @@ again:
> =A0 =A0 =A0 =A0unlock_extent_cached(io_tree, page_start, page_end, &c=
ached_state, GFP_NOFS);
>
> =A0out_unlock:
> - =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
> + =A0 =A0 =A0 btrfs_unreserve_metadata_for_delalloc(root, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calcula=
te_extents(root, PAGE_CACHE_SIZE));
> =A0 =A0 =A0 =A0if (!ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return VM_FAULT_LOCKED;
> =A0 =A0 =A0 =A0unlock_page(page);
> @@ -5384,7 +5418,6 @@ free:
> =A0void btrfs_drop_inode(struct inode *inode)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -
> =A0 =A0 =A0 =A0if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_=
item) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_delete_inode(inode);
> =A0 =A0 =A0 =A0else
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index a8ffecd..5c99882 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -303,6 +303,7 @@ static int __btrfs_remove_ordered_extent(struct i=
node *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 btrfs_ordered_extent *entry)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_ordered_inode_tree *tree;
> + =A0 =A0 =A0 struct btrfs_root *root =3D BTRFS_I(inode)->root;
> =A0 =A0 =A0 =A0struct rb_node *node;
>
> =A0 =A0 =A0 =A0tree =3D &BTRFS_I(inode)->ordered_tree;
> @@ -312,12 +313,13 @@ static int __btrfs_remove_ordered_extent(struct=
 inode *inode,
> =A0 =A0 =A0 =A0set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
>
> =A0 =A0 =A0 =A0spin_lock(&BTRFS_I(inode)->accounting_lock);
> + =A0 =A0 =A0 WARN_ON(!BTRFS_I(inode)->outstanding_extents);
> =A0 =A0 =A0 =A0BTRFS_I(inode)->outstanding_extents--;
> =A0 =A0 =A0 =A0spin_unlock(&BTRFS_I(inode)->accounting_lock);
> =A0 =A0 =A0 =A0btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->=
root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0inode, 1);
>
> - =A0 =A0 =A0 spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_exten=
t_lock);
> + =A0 =A0 =A0 spin_lock(&root->fs_info->ordered_extent_lock);
> =A0 =A0 =A0 =A0list_del_init(&entry->root_extent_list);
>
> =A0 =A0 =A0 =A0/*
> @@ -329,7 +331,7 @@ static int __btrfs_remove_ordered_extent(struct i=
node *inode,
> =A0 =A0 =A0 =A0 =A0 =A0!mapping_tagged(inode->i_mapping, PAGECACHE_TA=
G_DIRTY)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&BTRFS_I(inode)->ordered=
_operations);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_ext=
ent_lock);
> + =A0 =A0 =A0 spin_unlock(&root->fs_info->ordered_extent_lock);
>
> =A0 =A0 =A0 =A0return 0;
> =A0}
> --
> 1.6.6
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
