Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C02E3438AD
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788173601; cv=none; b=iPg8k1Rs2XeJ5FZucGt72yQUewkNVz4TeajbYWOozoPs0wksFMnaRdZnUy6fdXz1POdHfT+Z86P2FebOaCVSpP+aswetdg77+Xv6TWICyIDqvO0iQQLXx2z/rxbrXUot1iYj3XnjYjn3uXRUVUWanmyy+5Qpd8r3dXc9mmq0Uf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788173601; c=relaxed/simple;
	bh=Bfc8bRFvhlyfWSIXLY19TrQqAAKUqK69Opcm01Kb20o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p2rmU3nBcsployd0uRPDrGFPlwGQL8l5OU2KXsVHGalYkttoSEaOKMusZtUCKSeiRQQuIBCUctpdamKsgCSwT+gXi7S+Q8uIgwnW2wu2ESbWmV6MyKFtGQQNODA7btC7v9kxyFIkXK17z59o1Tn0LSgQhovi3SBotmMA1MScVD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1Ai3btZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1Ai3btZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34FF1F00A3E
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 10:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788173599;
	bh=YTaCiacdaG4aFEw+8K76Z00j59NDxlKRxxkC8PekRIk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=o1Ai3btZbtYwL2hF+eziT9Z2xNQIYjszF6RzPJWU/N/BG7fqpcOSDyGfmYykvXSJe
	 +pr6RNlb3N5lNEIzvX7OzE6GAFRbc0RmWC/yzcLoc3QB/EfyysREJEFcIWDAjD9wWU
	 jP37lGndlZbpJucZ2Ji6AGxt6TIAjN6Et6qR5DnzJMAQhfQT1gtps5l/+y9zf+1Lpi
	 C6A5PdmlyNozMTpwkhp9uFtP+QbBo3Ug8c44owTvqKn66rRA3Elk3qXdSCOwbTAm4N
	 zkIhlAFEx1z2QZ1rBRfc3Igaye0Qji6XICRK7TqmR16lwn2nS7QoOuJVXjJBiPhDD5
	 ZVw6iLUKyRCdw==
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-74ab99038afso2286818137.3
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 03:53:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpDrPBdC+zgBEEO7SxmXWTjMzRehirY+9tpU4LHx6atw6z2qts88gKUW6RdstdAaUNamgWDBneEVkfbMw==@vger.kernel.org
X-Gm-Message-State: AFuF++mz4AGksirxSSUv/JDY28Z5c8/iWORNt19oGAfMJvvV0KpntpN7
	JW/qitSlUzaxY/AMzISItxnO9COqE8kmxfDAV4cfyMGSWTF8aHT0pswTqINwrDRHffw1zw477Xx
	XssszLQXVh5zVVZxY4Pn4w+tvfUzx0Ao=
X-Received: by 2002:a05:6102:5547:b0:785:b85f:2aa with SMTP id
 ada2fe7eead31-789fc12e60dmr22609137.2.1788173597954; Mon, 31 Aug 2026
 03:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc>
In-Reply-To: <a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 31 Aug 2026 11:52:41 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6Fqyo2bbHb6RnEpOk6Q6p5omDaepZcsb2N0LQCkk64aw@mail.gmail.com>
X-Gm-Features: AcwNN1XCoxq1YFctBdVARsz4wcEPIr135hN8atx0mFZf_x4JSE8uQGfoXcTiNqU
Message-ID: <CAL3q7H6Fqyo2bbHb6RnEpOk6Q6p5omDaepZcsb2N0LQCkk64aw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix deadlocks with transaction commit when cloning
 inline extents
To: Melon Liu <melon1335@163.com>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 8:40=E2=80=AFAM Melon Liu <melon1335@163.com> wrote=
:
>
> Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transactio=
n
> commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlock
> cloning inline extent when using flushoncommit") moved the destination
> i_size update before btrfs_start_transaction() to prevent
> extent_writepage() from invalidating a folio beyond EOF.  However, two
> deadlock windows remain.
>
> First, after the folio is dirtied but before i_size is updated,
> extent_writepage() can still see the folio beyond EOF.  It calls
> folio_invalidate(), and btrfs_invalidate_folio() waits for the destinatio=
n
> extent range lock held by the clone task.
>
> Second, if extent_writepage() sees the folio within EOF, it proceeds to
> writepage_delalloc(), which also waits for the destination extent range
> lock.
>
> In both cases the transaction commit waits for writeback to complete,
> while the clone task waits in btrfs_start_transaction() for the
> committing transaction to become unblocked.
>
> To close both windows, first call btrfs_start_transaction() after reservi=
ng
> delalloc space and before creating and dirtying the folio.
> However, a commit may still start writeback before all extwriters have le=
ft
> the transaction.  Therefore, when the copied range extends beyond EOF,
> update i_size while the folio is still locked and before marking it dirty=
,
> so that extent_writepage() cannot treat it as being beyond EOF.  The
> resulting ordering also makes BTRFS_INODE_NO_DELALLOC_FLUSH unnecessary, =
so
> remove the flag and its associated logic.

Please don't mix fixing a bug with removing the no longer needed flag
BTRFS_INODE_NO_DELALLOC_FLUSH.

That makes backports more complex, not to mention the fact that it
could be the case some stable kernels use
BTRFS_INODE_NO_DELALLOC_FLUSH in other places, so it would make the
backport even less trivial - fortunately if memory serves me well,
there were never other users of the flag.

Always make one minimal patch that fixes only a bug, and leave
cleanups as separate followup patches please.

Looking at sashiko, its review is correct: if we clone a range that
has an inline extent followed by ohter extents (non-inline), we can
deadlock when starting a transaction at btrfs_replace_file_extent().
If you look at the comment I left over when setting
BTRFS_INODE_NO_DELALLOC_FLUSH, it explictly mentions this:

 "We will clear that flag when we finish cloning all extents, since a
transaction is started after finding each extent to clone."

>
> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline ex=
tents")
> Cc: stable@vger.kernel.org
> Signed-off-by: Melon Liu <melon1335@163.com>
> ---
>  fs/btrfs/btrfs_inode.h |  14 +----
>  fs/btrfs/dev-replace.c |   2 +-
>  fs/btrfs/disk-io.c     |   2 +-
>  fs/btrfs/inode.c       |  16 ++----
>  fs/btrfs/ioctl.c       |   4 +-
>  fs/btrfs/qgroup.c      |   4 +-
>  fs/btrfs/reflink.c     | 117 ++++++++++-------------------------------
>  fs/btrfs/send.c        |   4 +-
>  fs/btrfs/space-info.c  |   2 +-
>  9 files changed, 45 insertions(+), 120 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1082fa92c..aafe47b23 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -68,15 +68,6 @@ enum {
>          * to an inode.
>          */
>         BTRFS_INODE_NO_XATTRS,
> -       /*
> -        * Set when we are in a context where we need to start a transact=
ion and
> -        * have dirty pages with the respective file range locked. This i=
s to
> -        * ensure that when reserving space for the transaction, if we ar=
e low
> -        * on available space and need to flush delalloc, we will not flu=
sh
> -        * delalloc for this inode, because that could result in a deadlo=
ck (on
> -        * the file range, inode's io_tree).
> -        */
> -       BTRFS_INODE_NO_DELALLOC_FLUSH,
>         /*
>          * Set when we are working on enabling verity for a file. Computi=
ng and
>          * writing the whole Merkle tree can take a while so we want to p=
revent
> @@ -531,9 +522,8 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentr=
y);
>  int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 star=
t, u64 end);
>
> -int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_recla=
im_context);
> -int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> -                              bool in_reclaim_context);
> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root);
> +int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr);
>  int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 =
end,
>                               unsigned int extra_bits,
>                               struct extent_state **cached_state);
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index dc0834f92..ea1e43b9a 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -899,7 +899,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_f=
s_info *fs_info,
>          * flush all outstanding I/O and inode extent mappings before the
>          * copy operation is declared as being finished
>          */
> -       ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> +       ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX);
>         if (ret) {
>                 /* Stays started/resumable; keep both denied. */
>                 mutex_unlock(&dev_replace->lock_finishing_cancel_unmount)=
;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 819727460..fcd627251 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4403,7 +4403,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_in=
fo)
>          * getting delayed iputs than are never run. So flush delalloc an=
d wait
>          * for ordered extents.
>          */
> -       btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> +       btrfs_start_delalloc_roots(fs_info, LONG_MAX);
>         btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
>
>         /*
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3c10a0ef0..00795c3de 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8901,7 +8901,7 @@ static struct btrfs_delalloc_work *btrfs_alloc_dela=
lloc_work(struct inode *inode
>   * of all the inodes with pending delalloc and forces them to disk.
>   */
>  static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_wr=
ite,
> -                                bool snapshot, bool in_reclaim_context)
> +                                bool snapshot)
>  {
>         struct btrfs_delalloc_work *work, *next;
>         LIST_HEAD(works);
> @@ -8919,10 +8919,6 @@ static int start_delalloc_inodes(struct btrfs_root=
 *root, long *nr_to_write,
>
>                 list_move_tail(&inode->delalloc_inodes, &root->delalloc_i=
nodes);
>
> -               if (in_reclaim_context &&
> -                   test_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runti=
me_flags))
> -                       continue;
> -
>                 tmp_inode =3D igrab(&inode->vfs_inode);
>                 if (!tmp_inode) {
>                         cond_resched_lock(&root->delalloc_lock);
> @@ -8971,17 +8967,16 @@ static int start_delalloc_inodes(struct btrfs_roo=
t *root, long *nr_to_write,
>         return ret;
>  }
>
> -int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_recla=
im_context)
> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
>  {
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>
>         if (unlikely(BTRFS_FS_ERROR(fs_info)))
>                 return -EROFS;
> -       return start_delalloc_inodes(root, NULL, true, in_reclaim_context=
);
> +       return start_delalloc_inodes(root, NULL, true);
>  }
>
> -int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> -                              bool in_reclaim_context)
> +int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr)
>  {
>         long *nr_to_write =3D nr =3D=3D LONG_MAX ? NULL : &nr;
>         struct btrfs_root *root;
> @@ -9003,8 +8998,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info=
 *fs_info, long nr,
>                                &fs_info->delalloc_roots);
>                 spin_unlock(&fs_info->delalloc_root_lock);
>
> -               ret =3D start_delalloc_inodes(root, nr_to_write, false,
> -                               in_reclaim_context);
> +               ret =3D start_delalloc_inodes(root, nr_to_write, false);
>                 btrfs_put_root(root);
>                 if (ret < 0 || nr <=3D 0)
>                         goto out;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 72bc9d4f7..43a956a00 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -926,7 +926,7 @@ static noinline int btrfs_mksnapshot(struct dentry *p=
arent,
>          */
>         btrfs_drew_read_lock(&root->snapshot_lock);
>
> -       ret =3D btrfs_start_delalloc_snapshot(root, false);
> +       ret =3D btrfs_start_delalloc_snapshot(root);
>         if (ret)
>                 goto out;
>
> @@ -5586,7 +5586,7 @@ long btrfs_ioctl(struct file *file, unsigned int
>         case BTRFS_IOC_SYNC: {
>                 int ret;
>
> -               ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX, fal=
se);
> +               ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX);
>                 if (ret)
>                         return ret;
>                 ret =3D btrfs_sync_fs(inode->i_sb, 1);
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index f68b696b4..a4e01403c 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1321,7 +1321,7 @@ static int flush_reservations(struct btrfs_fs_info =
*fs_info)
>  {
>         int ret;
>
> -       ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> +       ret =3D btrfs_start_delalloc_roots(fs_info, LONG_MAX);
>         if (ret)
>                 return ret;
>         btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
> @@ -4228,7 +4228,7 @@ static int try_flush_qgroup(struct btrfs_root *root=
)
>                 return 0;
>         }
>
> -       ret =3D btrfs_start_delalloc_snapshot(root, true);
> +       ret =3D btrfs_start_delalloc_snapshot(root);
>         if (ret < 0)
>                 goto out;
>         btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a410191..11950a2cd 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -58,7 +58,8 @@ static int copy_inline_to_page(struct btrfs_inode *inod=
e,
>                                char *inline_data,
>                                const u64 size,
>                                const u64 datal,
> -                              const u8 comp_type)
> +                              const u8 comp_type,
> +                              struct btrfs_trans_handle **trans_out)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         const u32 block_size =3D fs_info->sectorsize;
> @@ -84,6 +85,18 @@ static int copy_inline_to_page(struct btrfs_inode *ino=
de,
>         if (ret)
>                 goto out;
>
> +       /*
> +        * Start the transaction before creating and dirtying the folio, =
otherwise
> +        * commit writeback can deadlock on the destination range locked =
by the

Let's be more clear here please. Instead of saying just "commit", say
"transaction commit", and be clear about how the deadlock happens:

1) In case the flushoncommit mount option is enabled
2) In case starting the transaction triggers the data async reclaim
task to reserve space

> +        * caller.
> +        */
> +       *trans_out =3D btrfs_start_transaction(inode->root, 1);

Before each call to btrfs_start_transaction(), we also have the good
practice of leaving a comment exlaining the unit count, just like in
the chunk you are removing in clone_copy_inline_extent():

"1 unit to update inode item"

Thanks.

> +       if (IS_ERR(*trans_out)) {
> +               ret =3D PTR_ERR(*trans_out);
> +               *trans_out =3D NULL;
> +               goto out_unlock;
> +       }
> +
>         folio =3D __filemap_get_folio(mapping, file_offset >> PAGE_SHIFT,
>                                         FGP_LOCK | FGP_ACCESSED | FGP_CRE=
AT,
>                                         btrfs_alloc_write_mask(mapping));
> @@ -100,19 +113,6 @@ static int copy_inline_to_page(struct btrfs_inode *i=
node,
>         if (ret)
>                 goto out_unlock;
>
> -       /*
> -        * After dirtying the page our caller will need to start a transa=
ction,
> -        * and if we are low on metadata free space, that can cause flush=
ing of
> -        * delalloc for all inodes in order to get metadata space release=
d.
> -        * However we are holding the range locked for the whole duration=
 of
> -        * the clone/dedupe operation, so we may deadlock if that happens=
 and no
> -        * other task releases enough space. So mark this inode as not be=
ing
> -        * possible to flush to avoid such deadlock. We will clear that f=
lag
> -        * when we finish cloning all extents, since a transaction is sta=
rted
> -        * after finding each extent to clone.
> -        */
> -       set_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> -
>         if (comp_type =3D=3D BTRFS_COMPRESS_NONE) {
>                 memcpy_to_folio(folio, offset_in_folio(folio, file_offset=
), data_start,
>                                         datal);
> @@ -140,6 +140,14 @@ static int copy_inline_to_page(struct btrfs_inode *i=
node,
>         if (datal < block_size)
>                 folio_zero_range(folio, datal, block_size - datal);
>
> +       /*
> +        * A commit may start writeback before all extwriters have left t=
he
> +        * transaction.  Update i_size while the folio is still locked an=
d before
> +        * marking it dirty, so that writeback cannot treat it as being b=
eyond EOF.
> +        */
> +       if (file_offset + datal > i_size_read(&inode->vfs_inode))
> +               i_size_write(&inode->vfs_inode, file_offset + datal);
> +
>         btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size)=
;
>         btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
>  out_unlock:
> @@ -150,6 +158,10 @@ static int copy_inline_to_page(struct btrfs_inode *i=
node,
>         if (ret)
>                 btrfs_delalloc_release_space(inode, data_reserved, file_o=
ffset,
>                                              block_size, true);
> +       if (ret && *trans_out) {
> +               btrfs_end_transaction(*trans_out);
> +               *trans_out =3D NULL;
> +       }
>         btrfs_delalloc_release_extents(inode, block_size);
>  out:
>         extent_changeset_free(data_reserved);
> @@ -180,12 +192,11 @@ static int clone_copy_inline_extent(struct btrfs_in=
ode *inode,
>         struct btrfs_drop_extents_args drop_args =3D { 0 };
>         int ret;
>         struct btrfs_key key;
> -       bool copied_inline_to_page =3D false;
>
>         if (new_key->offset > 0) {
>                 ret =3D copy_inline_to_page(inode, new_key->offset,
> -                                         inline_data, size, datal, comp_=
type);
> -               copied_inline_to_page =3D (ret =3D=3D 0);
> +                                         inline_data, size, datal, comp_=
type,
> +                                         &trans);
>                 goto out;
>         }
>
> @@ -290,73 +301,6 @@ static int clone_copy_inline_extent(struct btrfs_ino=
de *inode,
>         if (unlikely(ret))
>                 btrfs_abort_transaction(trans, ret);
>  out:
> -       if (!ret && !trans) {
> -               if (copied_inline_to_page &&
> -                   new_key->offset + datal > i_size_read(&inode->vfs_ino=
de)) {
> -                       /*
> -                        * If we copied the inline extent data to a page/=
folio
> -                        * beyond the i_size of the destination inode, th=
en we
> -                        * need to increase the i_size before we start a
> -                        * transaction to update the inode item. This is =
to
> -                        * prevent a deadlock when the flushoncommit moun=
t
> -                        * option is used, which happens like this:
> -                        *
> -                        * 1) Task A clones an inline extent from inode X=
 to an
> -                        *    offset of inode Y that is beyond Y's curren=
t
> -                        *    i_size. This means we copied the inline ext=
ent's
> -                        *    data to a folio of inode Y that is beyond i=
ts EOF,
> -                        *    using the call above to copy_inline_to_page=
();
> -                        *
> -                        * 2) Task B starts a transaction commit and call=
s
> -                        *    btrfs_start_delalloc_flush() to flush delal=
loc;
> -                        *
> -                        * 3) The delalloc flushing sees the new dirty fo=
lio of
> -                        *    inode Y and when it attempts to flush it, i=
t ends
> -                        *    up at extent_writepage() and sees that the =
offset
> -                        *    of the folio is beyond the i_size of inode =
Y, so
> -                        *    it attempts to invalidate the folio by call=
ing
> -                        *    folio_invalidate(), which ends up at btrfs'=
 folio
> -                        *    invalidate callback - btrfs_invalidate_foli=
o().
> -                        *    There it tries to lock the folio's range in=
 inode
> -                        *    Y's extent io tree, but it blocks since it'=
s
> -                        *    currently locked by task A - during reflink=
 we
> -                        *    lock the inodes and the source and destinat=
ion
> -                        *    ranges after flushing all delalloc and wait=
ing for
> -                        *    ordered extent completion - after that we d=
on't
> -                        *    expect to have dirty folios in the ranges, =
the
> -                        *    exception is if we have to copy an inline e=
xtent's
> -                        *    data (because the destination offset is not=
 zero);
> -                        *
> -                        * 4) Task A then does the 'goto out' below and a=
ttempts
> -                        *    to start a transaction to update the inode =
item,
> -                        *    and then it's blocked since the current
> -                        *    transaction is in the TRANS_STATE_COMMIT_ST=
ART
> -                        *    state. Therefore task A has to wait for the
> -                        *    current transaction to become unblocked (it=
s
> -                        *    state >=3D TRANS_STATE_UNBLOCKED).
> -                        *
> -                        * This leads to a deadlock - the task committing=
 the
> -                        * transaction waiting for the delalloc flushing =
which
> -                        * is blocked during folio invalidation on the in=
ode's
> -                        * extent lock and the reflink task waiting for t=
he
> -                        * current transaction to be unblocked so that it=
 can
> -                        * start a new one to update the inode item (whil=
e
> -                        * holding the extent lock).
> -                        */
> -                       i_size_write(&inode->vfs_inode, new_key->offset +=
 datal);
> -               }
> -               /*
> -                * No transaction here means we copied the inline extent =
into a
> -                * page of the destination inode.
> -                *
> -                * 1 unit to update inode item
> -                */
> -               trans =3D btrfs_start_transaction(root, 1);
> -               if (IS_ERR(trans)) {
> -                       ret =3D PTR_ERR(trans);
> -                       trans =3D NULL;
> -               }
> -       }
>         if (ret && trans)
>                 btrfs_end_transaction(trans);
>         if (!ret)
> @@ -376,8 +320,7 @@ static int clone_copy_inline_extent(struct btrfs_inod=
e *inode,
>         btrfs_release_path(path);
>
>         ret =3D copy_inline_to_page(inode, new_key->offset,
> -                                 inline_data, size, datal, comp_type);
> -       copied_inline_to_page =3D (ret =3D=3D 0);
> +                                 inline_data, size, datal, comp_type, &t=
rans);
>
>         goto out;
>  }
> @@ -665,8 +608,6 @@ static int btrfs_clone(struct btrfs_inode *src, struc=
t btrfs_inode *inode,
>         }
>
>  out:
> -       clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> -
>         return ret;
>  }
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index dca357016..e0febffaf 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -7908,7 +7908,7 @@ static int flush_delalloc_roots(struct send_ctx *sc=
tx)
>         int i;
>
>         if (root) {
> -               ret =3D btrfs_start_delalloc_snapshot(root, false);
> +               ret =3D btrfs_start_delalloc_snapshot(root);
>                 if (ret)
>                         return ret;
>                 btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> @@ -7916,7 +7916,7 @@ static int flush_delalloc_roots(struct send_ctx *sc=
tx)
>
>         for (i =3D 0; i < sctx->clone_roots_cnt; i++) {
>                 root =3D sctx->clone_roots[i].root;
> -               ret =3D btrfs_start_delalloc_snapshot(root, false);
> +               ret =3D btrfs_start_delalloc_snapshot(root);
>                 if (ret)
>                         return ret;
>                 btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 39a28e1be..7915819d7 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -770,7 +770,7 @@ static void shrink_delalloc(struct btrfs_space_info *=
space_info,
>                 long nr_pages =3D min_t(u64, temp, LONG_MAX);
>                 int async_pages;
>
> -               btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> +               btrfs_start_delalloc_roots(fs_info, nr_pages);
>
>                 /*
>                  * We need to make sure any outstanding async pages are n=
ow
> --
> 2.43.0
>
>
