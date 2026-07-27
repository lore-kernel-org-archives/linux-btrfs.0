Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A983B52E2
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 16:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168122; cv=none; b=Jv1roQWVPuW8thDQP7QkNT0s0OXoZQGLBdgs4JmJBL1/aDttmEOd/DGjINEw3Jc4A4ELSlUQg1p4TPAiKSosjTfc/TwcFUMoV+oOnV3JTmIRO2F4jlcXfi0ZYiM/mz/NHPLHAe9b6kNv4OCkW/jhCfAb2IpG018O0fUT+O27ncE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168122; c=relaxed/simple;
	bh=JCOKLibLkhd+H2dlt8TC4rIE37vo02r5LWIiC60wMMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h9IK/iOtg8U+5HRla4VhCowknHzVwzqpWZ6uVntJh/gqoWQws7GNCAYMDOExUVdMvtdJpUINzYXAiru8lZ8/7lkJwHt7vLTFSpCVIYbCrmfKydi1sUkqtmHCAGSM03C/jOSMOdgo6vGvBYkw0Vbwbkn9sAD5jK5gEty5typV0uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haFiDrz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haFiDrz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9791F00A3D
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785168120;
	bh=EVUNzdfpS4TB18Lf2ysG/rrsV7gtaX+dW+HH28MQMTw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=haFiDrz1guzB9k50rl3EwwGEENq50ejrPOsy5riutgg6GA6UPEoIL7pfhpWOXqoP5
	 8lqfNutwv7BLcMyRKhA2oin/ddXZEFau2iGFJr3c67lZ/Kj+x3gdO8ct79I7r0kDR6
	 wyyXftqBOORRjcSf5ozQXYC6GqFqaB6OfE6dKufOMX0syXSKpqp9951dQ8JcOOPRzV
	 q+dNYrIhdP4xUz23rUfMcZUR2HzllhoW0I1Tavf2VIXADN7v3Maqj/FYZtEHWJNvuA
	 2B13c04ON3bVLLduTEPDUrybvuNMKwj9jD7cZH9TdhEK8JkjTpKVPi6Ote5eeyq8v/
	 PjWX53UWOVlEQ==
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5bf95ade656so954157e0c.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 09:01:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YzXNEuWfvM1Re/5YwCd6w/aL6mmVBX8Bo5Z7NR+6F80yglh6IrD
	eiCyJfYGctUAZxub7tJ1M8rv9qsa3kKs6v0szDRsQUZwCToZ8zpI8JjcaXFCMrM1AZh4L/tayDs
	1kEM9QR5eHHk6/8IdYM+R2brrGLtPS9Q=
X-Received: by 2002:a05:6122:328f:b0:5bd:ddab:59a7 with SMTP id
 71dfb90a1353d-5c306db78e4mr3956536e0c.10.1785168118830; Mon, 27 Jul 2026
 09:01:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784673567.git.boris@bur.io> <ce1a151d14bc3162af23ef6d6bcdbd6210ce5a1e.1784673567.git.boris@bur.io>
In-Reply-To: <ce1a151d14bc3162af23ef6d6bcdbd6210ce5a1e.1784673567.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 27 Jul 2026 17:01:21 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5gD5CjOEkJdvSx7AY-=2kDwMJVzJZ9fj8du9UtDe_ieg@mail.gmail.com>
X-Gm-Features: AUfX_mzvv2oPyUOl6bvGHyM-NsqJs0xEzl9Ne6tcjd7dH3QlAVPCdNr5HTOIwRU
Message-ID: <CAL3q7H5gD5CjOEkJdvSx7AY-=2kDwMJVzJZ9fj8du9UtDe_ieg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] btrfs: add struct btrfs_eb_prealloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 1:00=E2=80=AFAM Boris Burkov <boris@bur.io> wrote:
>
> In further preparation for supporting NOFAIL allocations with retries
> outside the critical section, add a struct to carry the extent_buffer
> and btrfs_folio_state we need to allocate.
>
> Refactor the allocation pathways to use the new struct but with no
> functional change. Wire empty prealloc structs in from callers.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/ctree.c       |  21 +++--
>  fs/btrfs/disk-io.c     |   6 +-
>  fs/btrfs/disk-io.h     |   2 +
>  fs/btrfs/extent-tree.c |   6 +-
>  fs/btrfs/extent_io.c   | 179 ++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.h   |  19 +++++
>  fs/btrfs/tree-log.c    |   3 +-
>  7 files changed, 168 insertions(+), 68 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 49fb6b816aa9..261ef4ec7d1b 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1460,6 +1460,7 @@ static noinline void unlock_up(struct btrfs_path *p=
ath, int level,
>   */
>  static int
>  read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
> +                     struct btrfs_eb_prealloc *pa,
>                       struct extent_buffer **eb_ret, int slot,
>                       const struct btrfs_key *key)
>  {
> @@ -1546,7 +1547,8 @@ read_block_for_search(struct btrfs_root *root, stru=
ct btrfs_path *p,
>         if (p->reada !=3D READA_NONE)
>                 reada_for_search(fs_info, p, parent_level, slot, key->obj=
ectid);
>
> -       tmp =3D btrfs_find_create_tree_block(fs_info, blocknr, check.owne=
r_root, check.level);
> +       tmp =3D btrfs_find_create_tree_block(fs_info, pa, blocknr,
> +                                          check.owner_root, check.level)=
;
>         if (IS_ERR(tmp)) {
>                 ret =3D PTR_ERR(tmp);
>                 tmp =3D NULL;
> @@ -2004,6 +2006,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>         u8 lowest_level =3D 0;
>         int min_write_lock_level;
>         int prev_cmp;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>
>         if (!root)
>                 return -EINVAL;
> @@ -2187,7 +2190,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>                         goto done;
>                 }
>
> -               ret2 =3D read_block_for_search(root, p, &b, slot, key);
> +               ret2 =3D read_block_for_search(root, p, &pa, &b, slot, ke=
y);
>                 if (ret2 =3D=3D -EAGAIN && !p->nowait) {
>                         trace_btrfs_search_slot_restart(root, level, "rea=
d_block");
>                         goto again;
> @@ -2234,6 +2237,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>                         ret =3D ret2;
>         }
>
> +       btrfs_free_eb_prealloc(&pa);
> +
>         return ret;
>  }
>  ALLOW_ERROR_INJECTION(btrfs_search_slot, ERRNO);
> @@ -2259,6 +2264,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, =
const struct btrfs_key *key,
>         int level;
>         int lowest_unlock =3D 1;
>         u8 lowest_level =3D 0;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>
>         lowest_level =3D p->lowest_level;
>         WARN_ON(p->nodes[0] !=3D NULL);
> @@ -2316,7 +2322,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, =
const struct btrfs_key *key,
>                         goto done;
>                 }
>
> -               ret2 =3D read_block_for_search(root, p, &b, slot, key);
> +               ret2 =3D read_block_for_search(root, p, &pa, &b, slot, ke=
y);
>                 if (ret2 =3D=3D -EAGAIN && !p->nowait)
>                         goto again;
>                 if (ret2) {
> @@ -2339,6 +2345,8 @@ int btrfs_search_old_slot(struct btrfs_root *root, =
const struct btrfs_key *key,
>         if (ret < 0)
>                 btrfs_release_path(p);
>
> +       btrfs_free_eb_prealloc(&pa);
> +
>         return ret;
>  }
>
> @@ -4780,6 +4788,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
>         struct extent_buffer *next;
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         struct btrfs_key key;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         bool need_commit_sem =3D false;
>         u32 nritems;
>         int ret;
> @@ -4880,7 +4889,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
>                 }
>
>                 next =3D c;
> -               ret =3D read_block_for_search(root, path, &next, slot, &k=
ey);
> +               ret =3D read_block_for_search(root, path, &pa, &next, slo=
t, &key);
>                 if (ret =3D=3D -EAGAIN && !path->nowait)
>                         goto again;
>
> @@ -4923,7 +4932,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
>                 if (!level)
>                         break;
>
> -               ret =3D read_block_for_search(root, path, &next, 0, &key)=
;
> +               ret =3D read_block_for_search(root, path, &pa, &next, 0, =
&key);
>                 if (ret =3D=3D -EAGAIN && !path->nowait)
>                         goto again;
>
> @@ -4956,6 +4965,8 @@ int btrfs_next_old_leaf(struct btrfs_root *root, st=
ruct btrfs_path *path,
>                         ret =3D ret2;
>         }
>
> +       btrfs_free_eb_prealloc(&pa);
> +
>         return ret;
>  }
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 37fc0d6b960d..f7fa2c4bcac8 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -590,12 +590,13 @@ static const struct address_space_operations btree_=
aops =3D {
>
>  struct extent_buffer *btrfs_find_create_tree_block(
>                                                 struct btrfs_fs_info *fs_=
info,
> +                                               struct btrfs_eb_prealloc =
*pa,
>                                                 u64 bytenr, u64 owner_roo=
t,
>                                                 int level)
>  {
>         if (btrfs_is_testing(fs_info))
>                 return alloc_test_extent_buffer(fs_info, bytenr);
> -       return alloc_extent_buffer(fs_info, bytenr, owner_root, level);
> +       return alloc_extent_buffer(fs_info, pa, bytenr, owner_root, level=
);
>  }
>
>  /*
> @@ -608,12 +609,13 @@ struct extent_buffer *btrfs_find_create_tree_block(
>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64=
 bytenr,
>                                       struct btrfs_tree_parent_check *che=
ck)
>  {
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         struct extent_buffer *buf =3D NULL;
>         int ret;
>
>         ASSERT(check);
>
> -       buf =3D btrfs_find_create_tree_block(fs_info, bytenr, check->owne=
r_root,
> +       buf =3D btrfs_find_create_tree_block(fs_info, &pa, bytenr, check-=
>owner_root,
>                                            check->level);
>         if (IS_ERR(buf))
>                 return buf;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 9185f8f02eeb..290508894f7c 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -15,6 +15,7 @@
>  struct block_device;
>  struct super_block;
>  struct extent_buffer;
> +struct btrfs_eb_prealloc;
>  struct btrfs_device;
>  struct btrfs_fs_devices;
>  struct btrfs_fs_info;
> @@ -48,6 +49,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_i=
nfo *fs_info, u64 bytenr,
>                                       struct btrfs_tree_parent_check *che=
ck);
>  struct extent_buffer *btrfs_find_create_tree_block(
>                                                 struct btrfs_fs_info *fs_=
info,
> +                                               struct btrfs_eb_prealloc =
*pa,
>                                                 u64 bytenr, u64 owner_roo=
t,
>                                                 int level);
>  int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 235381b31298..0c28fa07f370 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5260,10 +5260,11 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>                       enum btrfs_lock_nesting nest)
>  {
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         struct extent_buffer *buf;
>         u64 lockdep_owner =3D owner;
>
> -       buf =3D btrfs_find_create_tree_block(fs_info, bytenr, owner, leve=
l);
> +       buf =3D btrfs_find_create_tree_block(fs_info, &pa, bytenr, owner,=
 level);
>         if (IS_ERR(buf))
>                 return buf;
>
> @@ -5917,6 +5918,7 @@ static noinline int do_walk_down(struct btrfs_trans=
_handle *trans,
>                                  struct walk_control *wc)
>  {
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         u64 bytenr;
>         u64 generation;
>         u64 owner_root =3D 0;
> @@ -5939,7 +5941,7 @@ static noinline int do_walk_down(struct btrfs_trans=
_handle *trans,
>
>         bytenr =3D btrfs_node_blockptr(path->nodes[level], path->slots[le=
vel]);
>
> -       next =3D btrfs_find_create_tree_block(fs_info, bytenr, btrfs_root=
_id(root),
> +       next =3D btrfs_find_create_tree_block(fs_info, &pa, bytenr, btrfs=
_root_id(root),
>                                             level - 1);
>         if (IS_ERR(next))
>                 return PTR_ERR(next);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 3ab6b143dbc4..373bdf2db0d5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3428,7 +3428,7 @@ static bool check_eb_alignment(struct btrfs_fs_info=
 *fs_info, u64 start)
>   * The caller needs to free the existing folios and retry using the same=
 order.
>   */
>  static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
> -                                     struct btrfs_folio_state *prealloc,
> +                                     struct btrfs_eb_prealloc *pa,
>                                       struct extent_buffer **found_eb_ret=
)
>  {
>
> @@ -3450,6 +3450,7 @@ static int attach_eb_folio_to_filemap(struct extent=
_buffer *eb, int i,
>         if (!ret)
>                 goto finish;
>
> +       /* ret =3D=3D -EEXIST: a folio already lives at this index. */
>         existing_folio =3D filemap_lock_folio(mapping, index + i);
>         /* The page cache only exists for a very short time, just retry. =
*/
>         if (IS_ERR(existing_folio))
> @@ -3458,7 +3459,27 @@ static int attach_eb_folio_to_filemap(struct exten=
t_buffer *eb, int i,
>         /* For now, we should only have single-page folios for btree inod=
e. */
>         ASSERT(folio_nr_pages(existing_folio) =3D=3D 1);
>
> +       /*
> +        * TODO: Special handling for a corner case where the order of
> +        * folios mismatch between the new eb and filemap.
> +        *
> +        * This happens when:
> +        *
> +        * - the new eb is using higher order folio
> +        *
> +        * - the filemap is still using 0-order folios for the range
> +        *   This can happen at the previous eb allocation, and we don't
> +        *   have higher order folio for the call.
> +        *
> +        * - the existing eb has already been freed
> +        *
> +        * In this case, we have to free the existing folios first, and
> +        * re-allocate using the same order.
> +        * Thankfully this is not going to happen yet, as we're still
> +        * using 0-order folios.
> +        */
>         if (folio_size(existing_folio) !=3D eb->folio_size) {
> +               DEBUG_WARN("folio order mismatch between new eb and filem=
ap");
>                 folio_unlock(existing_folio);
>                 folio_put(existing_folio);
>                 return -EAGAIN;
> @@ -3489,8 +3510,10 @@ static int attach_eb_folio_to_filemap(struct exten=
t_buffer *eb, int i,
>         eb->folio_size =3D folio_size(eb->folios[i]);
>         eb->folio_shift =3D folio_shift(eb->folios[i]);
>         /* Should not fail, as we have preallocated the memory. */
> -       ret =3D attach_extent_buffer_folio(eb, eb->folios[i], prealloc);
> +       ret =3D attach_extent_buffer_folio(eb, eb->folios[i], pa->bfs);
>         ASSERT(!ret);
> +       /* The subpage state, if any, is now attached to the folio or fre=
ed. */
> +       pa->bfs =3D NULL;
>         /*
>          * To inform we have an extra eb under allocation, so that
>          * detach_extent_buffer_page() won't release the folio private wh=
en the
> @@ -3505,17 +3528,94 @@ static int attach_eb_folio_to_filemap(struct exte=
nt_buffer *eb, int i,
>         return 0;
>  }
>
> +/*
> + * Allocate the extent_buffer, its folios, and btrfs_folio_state, if nee=
ded.
> + *
> + * Return 0 on success and a negative errno otherwise. On failure, pa->e=
b/bfs
> + * will be NULL.
> + */
> +int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
> +                          struct btrfs_eb_prealloc *pa)
> +{
> +       int ret;
> +
> +       ASSERT(!pa->eb, "unexpected non-null eb: %p", pa->eb);
> +       ASSERT(!pa->bfs, "unexpected non-null bfs: %p", pa->bfs);
> +
> +       pa->eb =3D kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GF=
P_NOFAIL);
> +       /* alloc_eb_folio_array() needs len; init_extent_buffer() sets it=
 again later. */
> +       pa->eb->len =3D fs_info->nodesize;
> +
> +       /*
> +        * Preallocate folio private for subpage case, so that we won't
> +        * allocate memory with i_private_lock nor page lock hold.
> +        *
> +        * The memory will be freed by attach_extent_buffer_page() or fre=
ed
> +        * manually if we exit earlier.
> +        */
> +       if (btrfs_meta_is_subpage(fs_info)) {
> +               pa->bfs =3D btrfs_alloc_folio_state(fs_info, PAGE_SIZE,
> +                                                 BTRFS_SUBPAGE_METADATA)=
;
> +               if (IS_ERR(pa->bfs)) {
> +                       ret =3D PTR_ERR(pa->bfs);
> +                       pa->bfs =3D NULL;
> +                       goto free_eb;
> +               }
> +       }
> +
> +       /*
> +        * Allocate all pages first. These will be attached to btree_inod=
e->i_mapping
> +        * below (added to LRU, served by btree_migrate_folio), so reques=
t

below where?

The function returns without doing that, so the comment is confusing.
The comment should be updated to tell that caller is responsible for
doing that by calling attach_eb_folio_to_filemap().

> +        * __GFP_MOVABLE so the page allocator places them in MOVABLE pag=
eblocks.
> +        */
> +       ret =3D alloc_eb_folio_array(pa->eb, GFP_NOFS | __GFP_NOFAIL | __=
GFP_MOVABLE);
> +       if (ret < 0)
> +               goto free_bfs;
> +
> +       return 0;
> +
> +free_bfs:
> +       btrfs_free_folio_state(pa->bfs);
> +       pa->bfs =3D NULL;
> +free_eb:
> +       kmem_cache_free(extent_buffer_cache, pa->eb);
> +       pa->eb =3D NULL;
> +       return ret;
> +}
> +
> +/*
> + * Used to cleanup a btrfs_eb_prealloc which had its contents allocated =
but
> + * folios not yet attached and eb/bfs consumed, and refs still 0.
> + *
> + * Safe to call on a fully used btrfs_eb_prealloc as the internal struct=
s will
> + * be null once they are owned by the context using them.
> + */
> +void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa)
> +{
> +       if (!pa->eb)
> +               return;
> +
> +       for (int i =3D 0; i < num_extent_pages(pa->eb); i++) {
> +               if (pa->eb->folios[i])
> +                       folio_put(pa->eb->folios[i]);
> +       }
> +       btrfs_free_folio_state(pa->bfs);
> +       kmem_cache_free(extent_buffer_cache, pa->eb);
> +       pa->eb =3D NULL;
> +       pa->bfs =3D NULL;
> +}
> +
>  struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> +                                         struct btrfs_eb_prealloc *pa,
>                                           u64 start, u64 owner_root, int =
level)
>  {
>         int attached =3D 0;
>         struct extent_buffer *eb;
>         struct extent_buffer *existing_eb =3D NULL;
> -       struct btrfs_folio_state *prealloc =3D NULL;
>         u64 lockdep_owner =3D owner_root;
>         bool page_contig =3D true;
>         bool uptodate =3D true;
> -       int ret;
> +       int ret =3D 0;

This seems an unncessary and accidental change, there's no change
below that reads 'ret' without setting it first.
>
>         if (check_eb_alignment(fs_info, start))
>                 return ERR_PTR(-EINVAL);
> @@ -3535,7 +3635,13 @@ struct extent_buffer *alloc_extent_buffer(struct b=
trfs_fs_info *fs_info,
>         if (eb)
>                 return eb;
>
> -       eb =3D kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NO=
FAIL);
> +       if (!pa->eb) {
> +               ret =3D btrfs_init_eb_prealloc(fs_info, pa);
> +               if (ret)
> +                       return ERR_PTR(ret);
> +       }
> +       eb =3D pa->eb;
> +       pa->eb =3D NULL;
>         init_extent_buffer(fs_info, eb, start);
>
>         /*
> @@ -3547,66 +3653,18 @@ struct extent_buffer *alloc_extent_buffer(struct =
btrfs_fs_info *fs_info,
>
>         btrfs_set_buffer_lockdep_class(lockdep_owner, eb, level);
>
> -       /*
> -        * Preallocate folio private for subpage case, so that we won't
> -        * allocate memory with i_private_lock nor page lock hold.
> -        *
> -        * The memory will be freed by attach_extent_buffer_page() or fre=
ed
> -        * manually if we exit earlier.
> -        */
> -       if (btrfs_meta_is_subpage(fs_info)) {
> -               prealloc =3D btrfs_alloc_folio_state(fs_info, PAGE_SIZE, =
BTRFS_SUBPAGE_METADATA);
> -               if (IS_ERR(prealloc)) {
> -                       ret =3D PTR_ERR(prealloc);
> -                       goto out;
> -               }
> -       }
> -
> -reallocate:
> -       /*
> -        * Allocate all pages first. These will be attached to btree_inod=
e->i_mapping
> -        * below (added to LRU, served by btree_migrate_folio), so reques=
t
> -        * __GFP_MOVABLE so the page allocator places them in MOVABLE pag=
eblocks.
> -        */
> -       ret =3D alloc_eb_folio_array(eb, GFP_NOFS | __GFP_NOFAIL | __GFP_=
MOVABLE);
> -       if (ret < 0) {
> -               btrfs_free_folio_state(prealloc);
> -               goto out;
> -       }
> -
>         /* Attach all pages to the filemap. */
>         for (int i =3D 0; i < num_extent_folios(eb); i++) {
>                 struct folio *folio;
>
> -               ret =3D attach_eb_folio_to_filemap(eb, i, prealloc, &exis=
ting_eb);
> +               ret =3D attach_eb_folio_to_filemap(eb, i, pa, &existing_e=
b);
>                 if (ret > 0) {
>                         ASSERT(existing_eb);
>                         goto out;
>                 }
> -
> -               /*
> -                * TODO: Special handling for a corner case where the ord=
er of
> -                * folios mismatch between the new eb and filemap.
> -                *
> -                * This happens when:
> -                *
> -                * - the new eb is using higher order folio
> -                *
> -                * - the filemap is still using 0-order folios for the ra=
nge
> -                *   This can happen at the previous eb allocation, and w=
e don't
> -                *   have higher order folio for the call.
> -                *
> -                * - the existing eb has already been freed
> -                *
> -                * In this case, we have to free the existing folios firs=
t, and
> -                * re-allocate using the same order.
> -                * Thankfully this is not going to happen yet, as we're s=
till
> -                * using 0-order folios.
> -                */
> -               if (unlikely(ret =3D=3D -EAGAIN)) {
> -                       DEBUG_WARN("folio order mismatch between new eb a=
nd filemap");
> -                       goto reallocate;
> -               }
> +               /* -EAGAIN: folio order mismatch, unreachable with 0-orde=
r folios. */
> +               if (ret < 0)
> +                       goto out;
>                 attached++;
>
>                 /*
> @@ -3683,6 +3741,10 @@ struct extent_buffer *alloc_extent_buffer(struct b=
trfs_fs_info *fs_info,
>  out:
>         WARN_ON(!refcount_dec_and_test(&eb->refs));
>
> +       /* attach hands off pa->bfs; free it if we bailed first. */

Please capitalize the first word in the comment, that's the style we
follow nowadays.

Otherwise it looks fine, thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>


> +       btrfs_free_folio_state(pa->bfs);
> +       pa->bfs =3D NULL;
> +
>         /*
>          * Any attached folios need to be detached before we unlock them.=
  This
>          * is because when we're inserting our new folios into the mappin=
g, and
> @@ -4737,6 +4799,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_inf=
o *fs_info,
>                 .level =3D level,
>                 .transid =3D gen
>         };
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         struct extent_buffer *eb;
>         int ret;
>
> @@ -4745,7 +4808,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_inf=
o *fs_info,
>                 check.has_first_key =3D true;
>         }
>
> -       eb =3D btrfs_find_create_tree_block(fs_info, bytenr, owner_root, =
level);
> +       eb =3D btrfs_find_create_tree_block(fs_info, &pa, bytenr, owner_r=
oot, level);
>         if (IS_ERR(eb))
>                 return;
>
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 869925337699..5722864e0411 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -119,6 +119,21 @@ struct extent_buffer {
>  #endif
>  };
>
> +/*
> + * Wrapper struct for managing preallocating an extent_buffer, its folio=
s and a
> + * btrfs_folio_state if needed.
> + *
> + * Only used to mediate allocation, do not refer to the eb directly if n=
ot
> + * returned from a successful eb allocating API.
> + *
> + * The eb folios and bfs should generally not be fully attached, except =
briefly
> + * before they are NULLed in the struct after successful attachment.
> + */
> +struct btrfs_eb_prealloc {
> +       struct extent_buffer *eb;
> +       struct btrfs_folio_state *bfs;
> +};
> +
>  struct btrfs_eb_write_context {
>         struct writeback_control *wbc;
>         struct extent_buffer *eb;
> @@ -271,7 +286,11 @@ int set_folio_extent_mapped(struct folio *folio);
>  void clear_folio_extent_mapped(struct folio *folio);
>
>  struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> +                                         struct btrfs_eb_prealloc *pa,
>                                           u64 start, u64 owner_root, int =
level);
> +int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
> +                          struct btrfs_eb_prealloc *pa);
> +void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa);
>  struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs=
_info,
>                                                 u64 start);
>  struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buff=
er *src);
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 875e4ddc68ea..fd5bd593389c 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2986,6 +2986,7 @@ static noinline int walk_down_log_tree(struct btrfs=
_path *path, int *level,
>  {
>         struct btrfs_trans_handle *trans =3D wc->trans;
>         struct btrfs_fs_info *fs_info =3D wc->log->fs_info;
> +       struct btrfs_eb_prealloc pa =3D { 0 };
>         u64 bytenr;
>         u64 ptr_gen;
>         struct extent_buffer *next;
> @@ -3010,7 +3011,7 @@ static noinline int walk_down_log_tree(struct btrfs=
_path *path, int *level,
>                 check.has_first_key =3D true;
>                 btrfs_node_key_to_cpu(cur, &check.first_key, path->slots[=
*level]);
>
> -               next =3D btrfs_find_create_tree_block(fs_info, bytenr,
> +               next =3D btrfs_find_create_tree_block(fs_info, &pa, byten=
r,
>                                                     btrfs_header_owner(cu=
r),
>                                                     *level - 1);
>                 if (IS_ERR(next)) {
> --
> 2.55.0
>
>
