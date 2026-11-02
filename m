Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649004;
	b=viuQJXjMf5jhHLCCCb4EGkPN0q352ZrKM5p56X0BLX+sScgrRm/vS4o1+XYiqPx81vaw
	 FHINx6qtuGtWZ8o04jRhWrNybVpLzX4KhvveML7EFEa0lgaGWcKjw4e0UiLk1BLA9E6I/
	 Yej83HnVQ8U6WvBijjW8nB44DH6mnA5NPyDB8Y14nkQARH1HxhPFdOm7tSfZt1W1DPRMu
	 RKWhzNqyFIvBOodPULnSmfgxEkHT/7ZjdpZEeLa7DRRcg5s+qa5lOvf0sPl5Orwuo9pQ9
	 DB048kbW4zfAcASgaq7txAmm6ECR7AArLb4fTLbjiUlJkrBog6KMsk+ugkPNPufu7yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649004;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=/jdFK+4e7wzlipO+6o8xk4On2aKOmTFJFX8Hn4EP9LU=;
	b=ZzIK3mroDDIW4matJ4yPF3j6l7ZSnfHG6npssNofJgAxXTh2A6msD2fKFHKbjoUVg9WC
	 Ei5c6qE9fmO2OrqLtirEZMYO4gPRMZfDYZ0078AMGXgfHUQbrW3E2WXuofamxJeTUsEmk
	 SdAH1PbUiWDaoqjjypgvsp1z9Lz+GtyDubx5xF+gC2nnP1zrIZuyEJkFyfpPgEpUSnE5P
	 jdTZ0RKpBNPUwsZyYwPOhEZwSR4wejnWbXfzny1ojpg1zEQURmi9zcBXj98PcbgcBei8e
	 xg4rwsj96sxAqGeKlRB54LJKjdWCzao2mz+6/R3b8tZ+MKxUh+R9vHMQxiMjq81p9iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VpZOolVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5DD606A326
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VpZOolVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425981F00A16
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793649003;
	bh=/jdFK+4e7wzlipO+6o8xk4On2aKOmTFJFX8Hn4EP9LU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VpZOolVvy0gaJtVVSJEPQ05nR8Ov59GP6KvWVjN1rDTSzT3+TEoeMw6gWKGMlRbsr
	 mCEG/sqyZ7IYBHhD4Yr4K6YxM+Sc9u+NiRVEy2yugKxl0YRiv1Hv9EBcnRO3pcMJUa
	 IOIQXGHacMuvhtiywVN7wyGVeYCJHkq+nsVNJ9GA1yFnRPC9AykSGy11+bGTntLsax
	 yrooq66tEwcbz091l8d7xkkLcIyl/JQCus5GtAPZbSfH2W49OSFZFa9uzxIOl/qduQ
	 dyHLXHLV3SXvFi3habO+pDWub8YFM1ztZQG/arQRi2FABlqdstfvbnD06XvleMS0nO
	 DXmYmhO/15U6w==
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-745497ac8fcso1443827137.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 11:50:03 -0800 (PST)
X-Gm-Message-State: APuU4Z/s58g8AXhMEArzy/FJbqWzLXewogV0euHiwRJcIL0FpgTVPWmn
	VmQbS3RF8Z4HxDV7fMA6c+C+1D8oBb9EAtCcmzfzdLctqfMZu0e7+hzKQUn3tjBFB6JhDYXbh4C
	E8XxrVyoC904nKP9qzjdBvMw4w5s5nkU=
X-Received: by 2002:a67:f403:0:b0:7d0:9587:1b90 with SMTP id
 ada2fe7eead31-7d0958732b2mr1760626137.13.1793649002439; Mon, 02 Nov 2026
 11:50:02 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793611601.git.wqu@suse.com> <737ab44fb9a8821281422f2bcdd6493c79b8853f.1793611601.git.wqu@suse.com>
In-Reply-To: <737ab44fb9a8821281422f2bcdd6493c79b8853f.1793611601.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 19:49:26 +0000
X-Gmail-Original-Message-ID: <CAL3q7H41bE7_b6jXQn5vj26eQavdqTkT5yqqF6XRX057MAnV=g@mail.gmail.com>
X-Gm-Features: AclHuK8EDY6Yk8GanMJ1OP2CWXSmq5evzDoTqstBDOSLZR2h_PMHEkFkA27mIxg
Message-ID: <CAL3q7H41bE7_b6jXQn5vj26eQavdqTkT5yqqF6XRX057MAnV=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: do not insert the data reloc tree into fs_roots_radix
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 9:29=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The reasons not to do so are:
>
> - There is already a global pointer fs_info->data_reloc_root
>   And data reloc tree itself has TRACK_DIRTY flag set, thus its treated
>   as a COW-only root, not a SHAREABLE root, unlike regular subvolume
>   trees.
>
> - 32-bit conflicts
>   For 32-bit systems, radix tree index is always truncated to 32 bits.

I think it's clearer to say that radix tree keys are unsigned longs,
and therefore on 32-bit platforms they are 32 bits wide.

>
>   This means a subvolume with id 0xfffffff7, will conflict with the
>   truncated data reloc tree id (0xfffffffffffffff7 -> 0xfffffff7).
>
>   This will prevent btrfs from reading or creating such subvolume.
>   Thankfully this should be very rare, as the subvolume id is reusable,
>   and it's very hard to keep so many subvolumes before hitting other
>   limits (e.g. anon_dev limits).
>
> So change the code to not insert data reloc tree into fs_roots_radix:
>
> - Load the tree with a dedicated helper
>   The new helper, read_data_reloc_root() will call
>   btrfs_read_tree_root(), with refs check, then call
>   btrfs_init_fs_root().
>
>   It skips the fs_roots_radix tree insert completely.
>
> - Grab data_reloc_tree as a global root
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 51 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 42 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6afcd6ca2a8a..c47ac4eff28d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1169,6 +1169,8 @@ static struct btrfs_root *btrfs_get_global_root(str=
uct btrfs_fs_info *fs_info,
>                 return btrfs_grab_root(fs_info->stripe_root);
>         case BTRFS_REMAP_TREE_OBJECTID:
>                 return btrfs_grab_root(fs_info->remap_root);
> +       case BTRFS_DATA_RELOC_TREE_OBJECTID:
> +               return btrfs_grab_root(fs_info->data_reloc_root);
>         default:
>                 return NULL;
>         }
> @@ -1304,8 +1306,13 @@ static struct btrfs_root *btrfs_get_root_ref(struc=
t btrfs_fs_info *fs_info,
>          *
>          * This is namely for free-space-tree and quota tree, which can c=
hange
>          * at runtime and should only be grabbed from fs_info.
> +        *
> +        * The data reloc tree is also such a tree.  It is loaded at moun=
t time
> +        * by read_data_reloc_root() and never inserted into the radix tr=
ee, as
> +        * its objectid is truncated to the radix tree index on 32-bit sy=
stems

Same here, something like for example:

... as radix tree keys are of type `unsigned long`, which is 32 bits
wide on 32-bit platforms.
Casting the objectid to `unsigned long` can therefore result in a
conflict with a subvolume.

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.



> +        * and can conflict with a real subvolume.
>          */
> -       if (!btrfs_is_fstree(objectid) && objectid !=3D BTRFS_DATA_RELOC_=
TREE_OBJECTID)
> +       if (!btrfs_is_fstree(objectid))
>                 return ERR_PTR(-ENOENT);
>  again:
>         root =3D btrfs_lookup_fs_root(fs_info, objectid);
> @@ -1409,6 +1416,39 @@ struct btrfs_root *btrfs_get_new_fs_root(struct bt=
rfs_fs_info *fs_info,
>         return btrfs_get_root_ref(fs_info, objectid, anon_dev, true);
>  }
>
> +/* Read and initialize the data reloc tree. */
> +static struct btrfs_root *read_data_reloc_root(struct btrfs_fs_info *fs_=
info)
> +{
> +       struct btrfs_key key =3D {
> +               .objectid =3D BTRFS_DATA_RELOC_TREE_OBJECTID,
> +               .type =3D BTRFS_ROOT_ITEM_KEY,
> +               .offset =3D (u64)-1,
> +       };
> +       struct btrfs_root *root;
> +       int ret;
> +
> +       root =3D btrfs_read_tree_root(fs_info->tree_root, &key);
> +       if (IS_ERR(root))
> +               return root;
> +
> +       if (btrfs_root_refs(&root->root_item) =3D=3D 0) {
> +               ret =3D -ENOENT;
> +               goto fail;
> +       }
> +
> +       /*
> +        * This tree can share blocks with some other fs tree during
> +        * relocation and we need a proper setup by btrfs_init_fs_root().
> +        */
> +       ret =3D btrfs_init_fs_root(root, 0);
> +       if (ret)
> +               goto fail;
> +       return root;
> +fail:
> +       btrfs_put_root(root);
> +       return ERR_PTR(ret);
> +}
> +
>  /*
>   * Return a root for the given objectid.
>   *
> @@ -2275,12 +2315,7 @@ static int btrfs_read_roots(struct btrfs_fs_info *=
fs_info)
>                                    PTR_ERR(root));
>                 }
>         } else {
> -               /*
> -                * This tree can share blocks with some other fs tree dur=
ing
> -                * relocation and we need a proper setup by btrfs_get_fs_=
root().
> -                */
> -               root =3D btrfs_get_fs_root(tree_root->fs_info,
> -                                        BTRFS_DATA_RELOC_TREE_OBJECTID, =
true);
> +               root =3D read_data_reloc_root(fs_info);
>                 if (IS_ERR(root)) {
>                         if (!btrfs_test_opt(fs_info, IGNOREBADROOTS)) {
>                                 location.objectid =3D BTRFS_DATA_RELOC_TR=
EE_OBJECTID;
> @@ -3815,8 +3850,6 @@ int __cold open_ctree(struct super_block *sb, struc=
t btrfs_fs_devices *fs_device
>         btrfs_put_block_group_cache(fs_info);
>
>  fail_tree_roots:
> -       if (fs_info->data_reloc_root)
> -               btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_=
root);
>         free_root_pointers(fs_info, true);
>         invalidate_and_check_btree_folios(fs_info);
>
> --
> 2.56.0
>
>
