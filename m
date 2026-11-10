Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317265;
	b=uLj5yQe00c1oDWQf4drPmn9PuHJmh2svz5yB+GN38kCu9YVDllkPsI5p5NPhwUBlm0BP
	 /RtNr2DZTZXPSneQTXa9gjGiKoIiVRCGno0KKecgvg/U/OoiZTlWIGLpsLJ7pBoE8FeQ3
	 CcTbbEyQsvLYZ21mYWQg5nm9/wlFiHyBukqHYO4ZFBShrngpG096FsPcKTsAMMQNQ6T1N
	 ae7Lew6jUUiHDRmKHOfqMMvHCPHdmKTyd/Vq56dZUwX+AHvxQXrdVG+n74v2yPa7xqj5o
	 SE0ku6GWwkeTsqKIkFkltfDBPpEjq+IbK+92sAvFlE64S7NaN4Tf5MaygFhqKPHwmYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317265;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gfVOZJpqqEfR+PuELPNzntCYsTDJ4GvqCKcHAI5k46M=;
	b=4Bi+iXJKU8b/Pf+MaDWo0Lk4k0LuvhDaaYEamG1SelPqiof9TZL7HNilwT7mSMC9elGN
	 vYB+sXoxM5mXu+/2VPuhfGxAiS7sXGU+Xrv54YD1Z7z21zzrRO6eFmaKfd4nchWbD75sN
	 g6ISKeLfmjcgpUrvJ+iGScsQfbIfKHt6Jc7gDbBNPx8rlGOLbkmolsE5elTsYxzzt4tW7
	 3bB5vvL4l+TTjpr6JhR67zM3twaYlmvSGYKozjjQu5u6Yq93RJXWZj7yJTkuHqJZuALgU
	 I4n1zXXgu5G9SMrf5VkPdLlps0QEKLlDymetdTSdBiC8f9PQd5OF1QV3PD4rc/6wuNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FRPZQqoQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D8B606A33C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FRPZQqoQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF0E1F0089F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317264;
	bh=gfVOZJpqqEfR+PuELPNzntCYsTDJ4GvqCKcHAI5k46M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FRPZQqoQHcnVg/SFk/qyfUIkE1Ug9oU/nLivr4Ej2l+tw8hXx/KHtBbXlrYssxBe0
	 a4j+twTkeg2fkYwLhQXdQYRpYeq2fBt8iactlk7HbC6iVXq+1SZAwDFqi8znpGiNN7
	 oEEf9iTy0EM9Bm0wbhWWtagRxHSegNd11fnz9jlJyKIHjciqnyLv9H0R1UesPczwvA
	 9RmWTWlirAakcGaxl9p+7oTcNzm3gvlhoFFAWeGgonWYVqWwcyLx/dO6336MN38/w5
	 fPzCbd5/ZIVHHNRIGhMUE++IFSmCXgkawhpvPzdQSP/U2OFLEkB+UGS3W0jsz8o5dX
	 2oNLMK7lep8wA==
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7d2dc1ac787so635565137.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 05:27:44 -0800 (PST)
X-Gm-Message-State: APuU4Z/HoREX6I3ZZpB5XNTLnAIonqeGC46H71vjc8bX5WRL73ZXgIVA
	euP2FuRwGGA0h4LmjkDq2SoVTZacSOs5YsAqILXbtV0Xn55LLJXtpsRcAUTL8TJPTTXCJP9JsAa
	a+aAhnaR9BSYDeAeto+LsQwrUajPJVsQ=
X-Received: by 2002:a05:6102:50a0:b0:7cb:bb33:8412 with SMTP id
 ada2fe7eead31-7d301b8e853mr672491137.10.1794317263119; Tue, 10 Nov 2026
 05:27:43 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <54da67463c57f41302f8456a8a7a1190dcb65ae2.1794266796.git.loemra.dev@gmail.com>
In-Reply-To: <54da67463c57f41302f8456a8a7a1190dcb65ae2.1794266796.git.loemra.dev@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Nov 2026 13:27:06 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4VS-Sa5+xdJ5V1m33He0f6i=bm609ed_zdC1uaYokMJA@mail.gmail.com>
X-Gm-Features: AclHuK8yQYxkb3uLuJw4Kat7vFifzZafNHnoYTg6G5cp4uysLsWzNQC_95PR60s
Message-ID: <CAL3q7H4VS-Sa5+xdJ5V1m33He0f6i=bm609ed_zdC1uaYokMJA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: keep a logged extent allocated when its ordered
 extent fails
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 12:17=E2=80=AFAM Leo Martins <loemra.dev@gmail.com>=
 wrote:
>
> A fast fsync doesn't wait for its ordered extents to complete. Once their
> IO is done it logs the new extents, with the checksums from the ordered
> extents, and syncs the log. Until an ordered extent completes and inserts
> its file extent item, the log is the only thing referencing its extent.
>
> If the transaction aborts before that, the ordered extent fails to join
> the transaction and its error path returns the extent to the free space
> cache, even though the log still points at it. Writeback keeps going
> after the abort, so a page dirtied earlier can get allocated that range
> and overwrite it. When the log is replayed on the next mount, the file
> points at the overwritten blocks with the old checksums, and every read
> fails with a csum error while btrfs check reports no problems.
>
>   fsync                    completion of X            writeback
>
>   write X, wait for IO
>   log X, sync the log
>                            transaction aborts,
>                            X returned to the
>                            free space cache
>                                                       allocate X,
>                                                       overwrite X
>   mount: log replay points the file at X, with X's logged checksums
>
> Fix this by not freeing the extent of a failed ordered extent that a fast
> fsync logged (BTRFS_ORDERED_LOGGED). Release its reservation but keep the
> range out of the free space cache until the next mount, when log replay
> takes a real reference. clean_log_buffer() already does the same for log
> tree blocks when it has no transaction.
>
> The transaction that logged the extent also must not commit, since the
> commit would drop the log, the only record of the fsynced data. It can't
> have committed yet because it waits for this ordered extent. Every
> failure after joining the transaction already aborts it, and a failed
> join means the transaction already aborted or the filesystem already has
> an error, unless allocating the handle failed. In that case there's no
> handle to abort with, so set the error with btrfs_handle_fs_error().
> Once the filesystem has an error, the commit fails to write its tree
> blocks and never writes a superblock.
>
> A completion can also fail while the fsync is logging: the log already
> points at the extent, but the completion checks BTRFS_ORDERED_LOGGED
> before the fsync sets it and frees the extent. To close that window, set
> BTRFS_ORDERED_LOGGED and check BTRFS_ORDERED_IOERR under the ordered
> tree lock. The error path sets IOERR before checking LOGGED, so either
> it sees LOGGED and keeps the extent, or the fsync sees IOERR and fails
> logging, which forces a full commit instead of a log sync.
>
> This depends on "btrfs: wait for ordered extent IO in fast fsync", which
> stops a fast fsync from logging ordered extents whose write failed. So
> only failures after the IO is done, from an abort or a failed join, reach
> the new path, and a plain write error doesn't force the filesystem
> read-only.
>
> Without this patch, delaying and then failing reads on the device while
> fsync-heavy writers and writers that never sync are running left
> persistent csum errors after log replay in 5 of 24 runs where the
> transaction aborted.
>
> Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback")
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
> This applies on for-next with Josef's "btrfs: data integrity fixes" v2 [1=
]
> and depends on "btrfs: wait for ordered extent IO in fast fsync" from it.
> That patch keeps a fast fsync from logging an ordered extent whose write
> failed. Without it, a plain write error with no abort could reach the
> new path with BTRFS_ORDERED_LOGGED set, and this patch would force the
> filesystem read-only over it. With it, only an abort (already read-only)
> or a failed handle allocation gets there, so a backport needs both.
>
> [1] https://lore.kernel.org/linux-btrfs/20261103-b4-btrfs-data-integrity-=
v2-0-577dc2690061@toxicpanda.com/
>
>  fs/btrfs/inode.c    | 57 +++++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/tree-log.c | 21 ++++++++++-------
>  2 files changed, 60 insertions(+), 18 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 19b1eba2dd84..c8af19a05405 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3170,6 +3170,30 @@ static int insert_ordered_extent_file_extent(struc=
t btrfs_trans_handle *trans,
>                                            update_inode_bytes, oe->qgroup=
_rsv);
>  }
>
> +/*
> + * The log may already reference this extent, so keep it out of the free=
 space
> + * cache until log replay at the next mount.
> + *
> + * The transaction that logged it must not commit either, since that wou=
ld drop
> + * the log. Every failure after joining it aborts it, and a failed join =
means it
> + * already aborted or the filesystem already has an error, unless alloca=
ting
> + * the handle failed. In that case set the error here, so the commit fai=
ls to
> + * write its tree blocks and never writes a superblock.
> + */
> +static void keep_logged_extent(struct btrfs_ordered_extent *oe, int erro=
r)
> +{
> +       struct btrfs_fs_info *fs_info =3D oe->inode->root->fs_info;
> +       struct btrfs_block_group *bg;
> +
> +       if (!BTRFS_FS_ERROR(fs_info))
> +               btrfs_handle_fs_error(fs_info, error, NULL);
> +
> +       bg =3D btrfs_lookup_block_group(fs_info, oe->disk_bytenr);
> +       ASSERT(bg);
> +       btrfs_free_reserved_bytes(bg, oe->disk_num_bytes, true);
> +       btrfs_put_block_group(bg);
> +}
> +
>  /*
>   * As ordered data IO finishes, this gets called so we can finish
>   * an ordered extent if the range of bytes in the file it covers are
> @@ -3373,18 +3397,31 @@ int btrfs_finish_one_ordered(struct btrfs_ordered=
_extent *ordered_extent)
>                     clear_reserved_extent &&
>                     !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags=
) &&
>                     !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->fl=
ags)) {
> +                       const u64 disk_bytenr =3D ordered_extent->disk_by=
tenr;
> +                       const u64 disk_num_bytes =3D ordered_extent->disk=
_num_bytes;
> +                       bool logged;
> +
>                         /*
> -                        * Discard the range before returning it back to =
the
> -                        * free space pool
> +                        * A fast fsync may have logged this extent. Pair=
s with
> +                        * the end of btrfs_log_changed_extents().
>                          */
> -                       if (ret && btrfs_test_opt(fs_info, DISCARD_SYNC))
> -                               btrfs_discard_extent(fs_info,
> -                                               ordered_extent->disk_byte=
nr,
> -                                               ordered_extent->disk_num_=
bytes,
> -                                               NULL, true);
> -                       btrfs_free_reserved_extent(fs_info,
> -                                       ordered_extent->disk_bytenr,
> -                                       ordered_extent->disk_num_bytes, t=
rue);
> +                       spin_lock(&inode->ordered_tree_lock);
> +                       logged =3D test_bit(BTRFS_ORDERED_LOGGED, &ordere=
d_extent->flags);
> +                       spin_unlock(&inode->ordered_tree_lock);
> +
> +                       if (ret && logged) {
> +                               keep_logged_extent(ordered_extent, ret);
> +                       } else {
> +                               /*
> +                                * Discard the range before returning it =
back to
> +                                * the free space pool

Since we are here, we can fix the original comment and add punctuation.

Looks good in general, but there are some valid points from Sashiko
regarding writes into prealloc extents:

https://sashiko.dev/#/patchset/54da67463c57f41302f8456a8a7a1190dcb65ae2.179=
4266796.git.loemra.dev%40gmail.com

Thanks.

> +                                */
> +                               if (ret && btrfs_test_opt(fs_info, DISCAR=
D_SYNC))
> +                                       btrfs_discard_extent(fs_info, dis=
k_bytenr,
> +                                                            disk_num_byt=
es, NULL, true);
> +                               btrfs_free_reserved_extent(fs_info, disk_=
bytenr,
> +                                                          disk_num_bytes=
, true);
> +                       }
>                         /*
>                          * Actually free the qgroup rsv which was release=
d when
>                          * the ordered extent was created.
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index e15b26f9b920..bd04dceca700 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5455,23 +5455,28 @@ static int btrfs_log_changed_extents(struct btrfs=
_trans_handle *trans,
>          * before it commits and wipes out the log trees, otherwise we wo=
uld
>          * lose data if an ordered extents completes after the transactio=
n
>          * commits and a power failure happens after the transaction comm=
it.
> +        *
> +        * A failed ordered extent keeps its extent allocated only if it =
sees
> +        * BTRFS_ORDERED_LOGGED. It sets BTRFS_ORDERED_IOERR before check=
ing, so
> +        * if we see IOERR here it may have already freed the extent, and=
 this
> +        * log must not be synced.
>          */
>         list_for_each_entry_safe(ordered, tmp, &ctx->ordered_extents, log=
_list) {
>                 list_del_init(&ordered->log_list);
> -               set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags);
>
> +               spin_lock(&inode->ordered_tree_lock);
> +               set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags);
> +               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
> +                       ret =3D -EIO;
>                 if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->flags)) {
> -                       spin_lock(&inode->ordered_tree_lock);
> -                       if (!test_bit(BTRFS_ORDERED_COMPLETE, &ordered->f=
lags)) {
> -                               set_bit(BTRFS_ORDERED_PENDING, &ordered->=
flags);
> -                               atomic_inc(&trans->transaction->pending_o=
rdered);
> -                       }
> -                       spin_unlock(&inode->ordered_tree_lock);
> +                       set_bit(BTRFS_ORDERED_PENDING, &ordered->flags);
> +                       atomic_inc(&trans->transaction->pending_ordered);
>                 }
> +               spin_unlock(&inode->ordered_tree_lock);
>                 btrfs_put_ordered_extent(ordered);
>         }
>
> -       return 0;
> +       return ret;
>  }
>
>  static int get_inode_size_to_log(struct btrfs_trans_handle *trans,
>
> base-commit: 5e79ca7342fb6e8c7ead78abc422d24396cff1cf
> prerequisite-patch-id: 4a028e5abff0520f479d35aa5cb8a1bc5091d1ac
> --
> 2.53.0-Meta
>
>
