Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB0E3909A4
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775498141; cv=none; b=S5fN+ma94uEgihZzReMKQ4yqZlFxiRWBtRAKIzo3oxXT+Gce9Aqk3TC2z+b5hM1IUR//U8Bmnypw1e5FAxZP+GDTnNQXw6Ddct/p8ggB7wS26aNvMPxSvTaRUXC4DFDyVIhS3wT9AO6/evvKVe9zTJxtTBaSr4UF+jD2gMCPEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775498141; c=relaxed/simple;
	bh=+LzrCDUQVwk0uezbj8bUHBMYkI2/0cDZKlp58sOa6lQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmLxIpzsHxrJJiUthxKdZ4fhDrkiYNFEJNxan82zoOxQhckG3rfzCqugVLreTIsysdzI6jgERmQA/3JtRpWfgTgkyVhUcd9qUzIk8JOqrfaTR6u5KHHRpPE6mBlXU5kXfseTqiov9qvX5wIIVDMHr+yuWI91BKOylTVP2uSuCdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spImaKkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spImaKkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA25C2BCB0
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775498141;
	bh=+LzrCDUQVwk0uezbj8bUHBMYkI2/0cDZKlp58sOa6lQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=spImaKkQnzIPEyoW6LiAgKL6vAT6eGkHwmLUi/YLVdKTuK2egzYfNmUys0tCxIQ+r
	 l4wFbEoiFBOc5czfZtbYDiCkxyeso7jV26rtYwaHl9073GULnTqPkcvYaI4hfrIp5S
	 A71WzycP3HPLc3MW/ol+vbLx0OLMIGEvgoRKG+gJQUBq+z5DNnnEuasCpGahI6swDF
	 9bIMJeTLSP7a/3JN84A8357w9kg75S3ebUKqoNPycwhBph5Eaoo9lRQSHYzKCatrJ2
	 G5cY3JtjmL1afktH8EEhjCK0c1R/yGKI6rM8kIAb8CgIkbo7KKpCRRWL8jXXsRCMqJ
	 hcnPJ3wEVkvCw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b982518b73fso680651866b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 10:55:41 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywft+3YuNZDAtOhfL1b1jP5b4XPyBHqW+k1NDWdVfhy5m/gyY7K
	jpnr7CyKZHCpsrm7lbKHFoHaejvaZpULV8GWkq2Z8oTmk4XDjRxNcgKTtTlQwjAmKwVwVtcTP13
	IScysyjGRZIKcBi/xQLzUMkkDzk+Feko=
X-Received: by 2002:a17:907:d08f:b0:b98:2462:959d with SMTP id
 a640c23a62f3a-b9c67979ee5mr685445566b.31.1775498139583; Mon, 06 Apr 2026
 10:55:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775255085.git.boris@bur.io> <2e52baa8f1c0513c4fa08b38a0bfd3c7d5e16108.1775255085.git.boris@bur.io>
In-Reply-To: <2e52baa8f1c0513c4fa08b38a0bfd3c7d5e16108.1775255085.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Apr 2026 18:55:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7S6szaom_EBENERCEA1X04UWU=Zv=xz-rPDn+onRxbMw@mail.gmail.com>
X-Gm-Features: AQROBzCey9AH_s1dz5CTNp8r6n6KW1BA0gfJpmJIFTqQIdP0W1ZeIjxPsGUHxHU
Message-ID: <CAL3q7H7S6szaom_EBENERCEA1X04UWU=Zv=xz-rPDn+onRxbMw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] btrfs: make inode->outstanding_extents a u64
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 11:30=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> The maximum file size is MAX_LFS_FILESIZE =3D (loff_t)LLONG_MAX
>
> As a result, the max extent size computation in btrfs has always been
> bounded above by LLONG_MAX / 128MiB, which is ~ 2^63 / 2^27. This has
> never fit in a u32. With the recent changes to also divide by 128KiB in
> compressed cases, that bound is even higher. Whether or not it is likely
> to happen, I think it is nice to try to capture the intent in the types,
> so change outstanding_extents to u64, and make mod_outstanding_extents
> try to capture some expectations around the size of its inputs.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h       | 14 ++++++++++----
>  fs/btrfs/delalloc-space.c    | 19 +++++++++----------
>  fs/btrfs/inode.c             | 14 +++++++-------
>  fs/btrfs/ordered-data.c      |  4 ++--
>  fs/btrfs/tests/inode-tests.c | 18 +++++++++---------
>  include/trace/events/btrfs.h |  8 ++++----
>  6 files changed, 41 insertions(+), 36 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index fad61b4d94a7..259af3f6ebb5 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -180,7 +180,7 @@ struct btrfs_inode {
>          * items we think we'll end up using, and reserved_extents is the=
 number
>          * of extent items we've reserved metadata for. Protected by 'loc=
k'.
>          */
> -       unsigned outstanding_extents;
> +       u64 outstanding_extents;
>
>         /* used to order data wrt metadata */
>         spinlock_t ordered_tree_lock;
> @@ -429,14 +429,20 @@ static inline bool is_data_inode(const struct btrfs=
_inode *inode)
>  }
>
>  static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *ino=
de,
> -                                                int mod)
> +                                                int mod, u64 nr_extents)
>  {
> +       s64 delta =3D mod * (s64)nr_extents;
> +
>         lockdep_assert_held(&inode->lock);
> -       inode->outstanding_extents +=3D mod;
> +       ASSERT(mod =3D=3D 1 || mod =3D=3D -1);
> +       ASSERT(nr_extents <=3D S64_MAX);
> +       ASSERT(mod =3D=3D -1 || inode->outstanding_extents <=3D U64_MAX -=
 nr_extents);
> +       ASSERT(mod =3D=3D 1 || inode->outstanding_extents >=3D nr_extents=
);

Please use extended assertions that print the checked values, so that
we can have useful output to debug if they fail.

Thanks.

> +       inode->outstanding_extents +=3D delta;
>         if (btrfs_is_free_space_inode(inode))
>                 return;
>         trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(=
inode),
> -                                                 mod, inode->outstanding=
_extents);
> +                                                 delta, inode->outstandi=
ng_extents);
>  }
>
>  /*
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 2c99e332e25b..f4851cc7e2a8 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -274,7 +274,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>         u64 reserve_size =3D 0;
>         u64 qgroup_rsv_size =3D 0;
> -       unsigned outstanding_extents;
> +       u64 outstanding_extents;
>
>         lockdep_assert_held(&inode->lock);
>         outstanding_extents =3D inode->outstanding_extents;
> @@ -301,7 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>          *
>          * This is overestimating in most cases.
>          */
> -       qgroup_rsv_size =3D (u64)outstanding_extents * fs_info->nodesize;
> +       qgroup_rsv_size =3D outstanding_extents * fs_info->nodesize;
>
>         spin_lock(&block_rsv->lock);
>         block_rsv->size =3D reserve_size;
> @@ -364,7 +364,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>         u64 meta_reserve, qgroup_reserve;
> -       unsigned nr_extents;
> +       u64 nr_extents;
>         enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_ALL;
>         int ret =3D 0;
>
> @@ -418,7 +418,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>          */
>         nr_extents =3D btrfs_inode_max_extents(inode, num_bytes);
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, nr_extents);
> +       btrfs_mod_outstanding_extents(inode, 1, nr_extents);
>         if (!(inode->flags & BTRFS_INODE_NODATASUM))
>                 inode->csum_bytes +=3D disk_num_bytes;
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
> @@ -480,11 +480,11 @@ void btrfs_delalloc_release_metadata(struct btrfs_i=
node *inode, u64 num_bytes,
>  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_b=
ytes)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       unsigned num_extents;
> +       u64 num_extents;
>
>         spin_lock(&inode->lock);
>         num_extents =3D btrfs_inode_max_extents(inode, num_bytes);
> -       btrfs_mod_outstanding_extents(inode, -num_extents);
> +       btrfs_mod_outstanding_extents(inode, -1, num_extents);
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>         spin_unlock(&inode->lock);
>
> @@ -498,16 +498,15 @@ void btrfs_delalloc_release_extents(struct btrfs_in=
ode *inode, u64 num_bytes)
>  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserv=
ed_len, u64 new_len)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       const u32 reserved_num_extents =3D btrfs_inode_max_extents(inode,=
 reserved_len);
> -       const u32 new_num_extents =3D btrfs_inode_max_extents(inode, new_=
len);
> -       const int diff_num_extents =3D new_num_extents - reserved_num_ext=
ents;
> +       const u64 reserved_num_extents =3D btrfs_inode_max_extents(inode,=
 reserved_len);
> +       const u64 new_num_extents =3D btrfs_inode_max_extents(inode, new_=
len);
>
>         ASSERT(new_len <=3D reserved_len);
>         if (new_num_extents =3D=3D reserved_num_extents)
>                 return;
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, diff_num_extents);
> +       btrfs_mod_outstanding_extents(inode, -1, reserved_num_extents - n=
ew_num_extents);
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>         spin_unlock(&inode->lock);
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1e53ff65d1a7..965c2739d33b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2536,7 +2536,7 @@ void btrfs_split_delalloc_extent(struct btrfs_inode=
 *inode,
>         }
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, 1);
> +       btrfs_mod_outstanding_extents(inode, 1, 1);
>         spin_unlock(&inode->lock);
>  }
>
> @@ -2566,7 +2566,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state
>         /* we're not bigger than the max, unreserve the space and go */
>         if (new_size <=3D max_extent_size) {
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, -1);
> +               btrfs_mod_outstanding_extents(inode, -1, 1);
>                 spin_unlock(&inode->lock);
>                 return;
>         }
> @@ -2597,7 +2597,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state
>                 return;
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, -1);
> +       btrfs_mod_outstanding_extents(inode, -1, 1);
>         spin_unlock(&inode->lock);
>  }
>
> @@ -2666,10 +2666,10 @@ void btrfs_set_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state *s
>         if (!(state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)=
) {
>                 u64 len =3D state->end + 1 - state->start;
>                 u64 prev_delalloc_bytes;
> -               u32 num_extents =3D btrfs_inode_max_extents(inode, len);
> +               u64 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, num_extents);
> +               btrfs_mod_outstanding_extents(inode, 1, num_extents);
>                 spin_unlock(&inode->lock);
>
>                 /* For sanity tests */
> @@ -2712,7 +2712,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode=
 *inode,
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 len =3D state->end + 1 - state->start;
> -       u32 num_extents =3D btrfs_inode_max_extents(inode, len);
> +       u64 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>         lockdep_assert_held(&inode->io_tree.lock);
>
> @@ -2732,7 +2732,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode=
 *inode,
>                 u64 new_delalloc_bytes;
>
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, -num_extents);
> +               btrfs_mod_outstanding_extents(inode, -1, num_extents);
>                 spin_unlock(&inode->lock);
>
>                 /*
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index d39f1c49d1cf..14b49cb33bb0 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -223,7 +223,7 @@ static struct btrfs_ordered_extent *alloc_ordered_ext=
ent(
>          * smallest the extent is going to get.
>          */
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, 1);
> +       btrfs_mod_outstanding_extents(inode, 1, 1);
>         spin_unlock(&inode->lock);
>
>  out:
> @@ -655,7 +655,7 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered=
_extent *entry)
>         btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
>         /* This is paired with alloc_ordered_extent(). */
>         spin_lock(&btrfs_inode->lock);
> -       btrfs_mod_outstanding_extents(btrfs_inode, -1);
> +       btrfs_mod_outstanding_extents(btrfs_inode, -1, 1);
>         spin_unlock(&btrfs_inode->lock);
>         if (root !=3D fs_info->tree_root) {
>                 u64 release;
> diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
> index b04fbcaf0a1d..e63afbb9be2b 100644
> --- a/fs/btrfs/tests/inode-tests.c
> +++ b/fs/btrfs/tests/inode-tests.c
> @@ -931,7 +931,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 1) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 1, got %u",
> +               test_err("miscount, wanted 1, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -946,7 +946,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -962,7 +962,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -978,7 +978,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -996,7 +996,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 4) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 4, got %u",
> +               test_err("miscount, wanted 4, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1013,7 +1013,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 3) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 3, got %u",
> +               test_err("miscount, wanted 3, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1029,7 +1029,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 4) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 4, got %u",
> +               test_err("miscount, wanted 4, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1047,7 +1047,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 3) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 3, got %u",
> +               test_err("miscount, wanted 3, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1061,7 +1061,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 0, got %u",
> +               test_err("miscount, wanted 0, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 8ad7a2d76c1d..caabdc8d9eed 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -2003,15 +2003,15 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_=
insert,
>  );
>
>  TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
> -       TP_PROTO(const struct btrfs_root *root, u64 ino, int mod, unsigne=
d outstanding),
> +       TP_PROTO(const struct btrfs_root *root, u64 ino, s64 mod, u64 out=
standing),
>
>         TP_ARGS(root, ino, mod, outstanding),
>
>         TP_STRUCT__entry_btrfs(
>                 __field(        u64, root_objectid      )
>                 __field(        u64, ino                )
> -               __field(        int, mod                )
> -               __field(        unsigned, outstanding   )
> +               __field(        s64, mod                )
> +               __field(        u64, outstanding        )
>         ),
>
>         TP_fast_assign_btrfs(root->fs_info,
> @@ -2021,7 +2021,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
>                 __entry->outstanding    =3D outstanding;
>         ),
>
> -       TP_printk_btrfs("root=3D%llu(%s) ino=3D%llu mod=3D%d outstanding=
=3D%u",
> +       TP_printk_btrfs("root=3D%llu(%s) ino=3D%llu mod=3D%lld outstandin=
g=3D%llu",
>                         show_root_type(__entry->root_objectid),
>                         __entry->ino, __entry->mod, __entry->outstanding)
>  );
> --
> 2.53.0
>
>
