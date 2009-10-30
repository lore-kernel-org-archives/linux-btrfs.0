From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: reserve space specifically for the extent root
Date: Fri, 30 Oct 2009 14:38:55 +0800
Message-ID: <3d0408630910292338r466b4501kf19ed2354b54a51f@mail.gmail.com>
References: <20091029203554.GA3940@dhcp231-156.rdu.redhat.com>
	 <3d0408630910291848r45c58405o7597bea892e6ff69@mail.gmail.com>
	 <20091030032414.GB3940@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091030032414.GB3940@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2009 at 11:24 AM, Josef Bacik <josef@redhat.com> wrote:
> On Fri, Oct 30, 2009 at 09:48:55AM +0800, Yan, Zheng =A0wrote:
>> On Fri, Oct 30, 2009 at 4:35 AM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > If there are alot of snapshots we could conceivably end up using m=
uch more
>> > metadata space than what the worst case calculation would come up =
with, so
>> > instead of trying to figure out how many extents will be modified =
by changing
>> > items, just calculate it per tree, and then reserve space specific=
ally for the
>> > extent root. =A0This patch does a max(size of extent root tree, 20=
% of free
>> > metadata space) reservation for the extent root, and then tracks h=
ow much
>> > space is used per transaction for the extent root. =A0Then if we g=
et close to
>> > this amount in our transaction we will force the commit of the tra=
nsaction to
>> > free up space. =A0This will help us better deal with the massive s=
pace
>> > requirements that will come when users have alot of snapshots. =A0=
This was
>> > tested with my normal enospc tests. =A0Thanks,
>> >
>> > Signed-off-by: Josef Bacik <josef@redhat.com>
>> > ---
>> > =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 =A02 +
>> > =A0fs/btrfs/extent-tree.c | =A0115 +++++++++++++++++++++++++++++++=
++++++++++-------
>> > =A0fs/btrfs/transaction.c | =A0 19 +++++++-
>> > =A0fs/btrfs/transaction.h | =A0 =A01 +
>> > =A04 files changed, 119 insertions(+), 18 deletions(-)
>> >
>> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> > index e5dd628..3e00df1 100644
>> > --- a/fs/btrfs/ctree.h
>> > +++ b/fs/btrfs/ctree.h
>> > @@ -2049,6 +2049,8 @@ void btrfs_delalloc_reserve_space(struct btr=
fs_root *root, struct inode *inode,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u6=
4 bytes);
>> > =A0void btrfs_delalloc_free_space(struct btrfs_root *root, struct =
inode *inode,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 byt=
es);
>> > +int btrfs_check_reserved_extent_space(struct btrfs_trans_handle *=
trans,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct btrfs_root *root);
>> > =A0/* ctree.c */
>> > =A0int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key=
 *key,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int level, int *slot);
>> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> > index c56f916..7a1f1a4 100644
>> > --- a/fs/btrfs/extent-tree.c
>> > +++ b/fs/btrfs/extent-tree.c
>> > @@ -2768,6 +2768,12 @@ static u64 calculate_bytes_needed(struct bt=
rfs_root *root, int num_items)
>> > =A0 =A0 =A0 =A0u64 num_bytes;
>> > =A0 =A0 =A0 =A0int level;
>> >
>> > + =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0* The level is the number of node level's we coul=
d possibly cow. =A0So
>> > + =A0 =A0 =A0 =A0* since we track root item reservations seperatel=
y we don't need that,
>> > + =A0 =A0 =A0 =A0* and we don't need to count the leaf level, so t=
he max number of
>> > + =A0 =A0 =A0 =A0* levels that could have nodes is MAX_LEVEL - 2.
>> > + =A0 =A0 =A0 =A0*/
>> > =A0 =A0 =A0 =A0level =3D BTRFS_MAX_LEVEL - 2;
>> > =A0 =A0 =A0 =A0/*
>> > =A0 =A0 =A0 =A0 * NOTE: these calculations are absolutely the wors=
t possible case.
>> > @@ -2776,17 +2782,11 @@ static u64 calculate_bytes_needed(struct b=
trfs_root *root, int num_items)
>> > =A0 =A0 =A0 =A0 */
>> >
>> > =A0 =A0 =A0 =A0/*
>> > - =A0 =A0 =A0 =A0* for every item we insert we could insert both a=
n extent item and a
>> > - =A0 =A0 =A0 =A0* extent ref item. =A0Then for ever item we inser=
t, we will need to cow
>> > - =A0 =A0 =A0 =A0* both the original leaf, plus the leaf to the le=
ft and right of it.
>> > - =A0 =A0 =A0 =A0*
>> > - =A0 =A0 =A0 =A0* Unless we are talking about the extent root, th=
en we just want the
>> > - =A0 =A0 =A0 =A0* number of items * 2, since we just need the ext=
ent item plus its ref.
>> > + =A0 =A0 =A0 =A0* For each item we need we'll assume that we're g=
oing to add a leaf for
>> > + =A0 =A0 =A0 =A0* it, and then we may cow the leaves on either si=
de to make room for
>> > + =A0 =A0 =A0 =A0* the items we're inserting, so multiply by 3.
>> > =A0 =A0 =A0 =A0 */
>> > - =A0 =A0 =A0 if (root =3D=3D root->fs_info->extent_root)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_bytes =3D num_items * 2;
>> > - =A0 =A0 =A0 else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_bytes =3D (num_items + (2 * num_=
items)) * 3;
>> > + =A0 =A0 =A0 num_bytes =3D num_items * 3;
>> >
>> > =A0 =A0 =A0 =A0/*
>> > =A0 =A0 =A0 =A0 * num_bytes is total number of leaves we could nee=
d times the leaf
>> > @@ -3031,6 +3031,64 @@ out:
>> > =A0}
>> >
>> > =A0/*
>> > + * This checks how many bytes we've allocated for the extent tree=
 vs. how much
>> > + * we reserved, and if we need to go ahead and force the transact=
ion to commit.
>> > + */
>> > +int btrfs_check_reserved_extent_space(struct btrfs_trans_handle *=
trans,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct btrfs_root *root)
>> > +{
>> > + =A0 =A0 =A0 struct btrfs_fs_info *info =3D root->fs_info;
>> > + =A0 =A0 =A0 struct btrfs_space_info *meta_sinfo;
>> > + =A0 =A0 =A0 u64 used;
>> > + =A0 =A0 =A0 u64 alloc_target;
>> > +
>> > + =A0 =A0 =A0 /* don't force a commit if this is an embedded trans=
action */
>> > + =A0 =A0 =A0 if (current->journal_info !=3D trans)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > +
>> > + =A0 =A0 =A0 /* get the space info for where the metadata will li=
ve */
>> > + =A0 =A0 =A0 alloc_target =3D btrfs_get_alloc_profile(root, 0);
>> > + =A0 =A0 =A0 meta_sinfo =3D __find_space_info(info, alloc_target)=
;
>> > +
>> > + =A0 =A0 =A0 spin_lock(&meta_sinfo->lock);
>> > +
>> > + =A0 =A0 =A0 if (unlikely(!meta_sinfo->bytes_root)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 bytes;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* somebody should have already re=
served space before starting
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the transaction, so WARN_ON so =
we can fix that person.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 used =3D meta_sinfo->bytes_used + me=
ta_sinfo->bytes_reserved +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 meta_sinfo->bytes_pi=
nned + meta_sinfo->bytes_readonly +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 meta_sinfo->bytes_su=
per + meta_sinfo->bytes_root +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 meta_sinfo->bytes_ma=
y_use + meta_sinfo->bytes_delalloc;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes =3D meta_sinfo->total_bytes - =
used;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 meta_sinfo->bytes_root =3D calculate=
_bytes_needed(root, 6);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes *=3D 20;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes =3D div64_u64(bytes, 100);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes =3D max(bytes,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_root_u=
sed(&info->extent_root->root_item));
>>
>> This won't work since the used space accounting in root item isn't a=
ccuracy.
>> We can fix the bug and use btrfsck to fix the accounting. But it int=
roduces
>> backwards compatibility issue. I think we can use 2% of total space =
as
>> a temporary substitution.
>>
> I didn't look too thoroughly at this, but it looked like the accounti=
ng was done
> properly, since we update it in btrfs_update_block_group. =A0Oh thoug=
h I guess we
> could always be using the extent_root, is that the problem? =A0If you=
 let me know
> what the issue is I will fix it tomorrow. =A0Thanks,

All space allocations and freeing are processed by delayed ref, so we a=
lways
pass extent_root  to update_block_group. The value of used space in roo=
t item
of extent tree should be close to total used space of the FS.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
