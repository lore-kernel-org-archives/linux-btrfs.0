Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602967;
	b=w+tYK5wt3kkb+1Zp3Da7wI38ilW5b7klTZPrzlNkOIxIBJgq2qnSN3IGXRU2W80w6Zf5
	 o3s06znNo+LzRjqlCAjnAlE8Hp4DWxlubMMjOVSAu2E3PHX0iJZTF8BdDnKLXKBNZS9Xk
	 sAd3hsriyFv+35cpIwKE1XY2qYylOnI735+0AcUWg1UAcZWD/TtSJabZt46ck2bKgA8O0
	 YewRlVXDcGSEttXIFIrqo8/KvSeosxT8GBxzJakIn4JaACXi/JIi+DI0rZHJGIL4vFgdk
	 +P3VRDjHq8Dw1rFYWQZAEgmW5brh/2oLkkt+AhGIQkXWaiO3z2MrD0h7FSrlmk2HP3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602967;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=LcUIzQl7WedVAXasAbygzfNxSJ3Qhn6RAiBBX5Skbcc=;
	b=yLtNmseHciJe1lKwXASTj+PVTA/pC7m+PaQPxwMKVA2s6YP12zkQvaQzHyIV7clqyb1o
	 l6K83Gb8S9xXMGgkv3bPz6Id5JIZGQZaagXiub7OkgllKBQbfMvHmelM7mrl2SO3YUuR0
	 DS37OkcSb5aGIJ+Sf/YvyofPxN8x2gY3cZAGDvLjPjCEJloDeJ5PCW5LJBE7w0RPBUoPv
	 zQE+bx38/5GMGCyEaxwAQgQ9jETwvKPNilM+qqBteHBqb0TQZVsmBxAQmYioiW9uK/M1Q
	 P8tSJeyK8lroAE7nWK3R3KlTm3W6L7EAyC3esCRaBFIbLztvbmCJ70pEJ0aLKMMT20w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSZDkqPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAF1606A31B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSZDkqPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5221F000C6
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792602966;
	bh=LcUIzQl7WedVAXasAbygzfNxSJ3Qhn6RAiBBX5Skbcc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BSZDkqPcW5l6fGPbrY3JjgRGi9TybLPqsBFa4xcfUgHooLFqoenf8UyvQNNHti3Ja
	 IKjN0Fqz3PUO+XE4F8Yczzw9BIDPYeJbXH4x24nuqVs45W9PWFQjzsnKroGdbn8946
	 YH9LnVsadSA+AOeiRizqnfLrCw8zgRMscT5Wbh5qhJ7MgeAkVrHsAirn2N+XDpQMTn
	 LOH6tbOmKse1Mb5VQxEglzQKUhjXrh1/rPVbzB0IijlBC+6g9vS3gT/8mE7FH2ovD4
	 IardcZIX2Xaj5UYl1u/lotJjB3l1Th8Ea4pTq5vdb38vReF8NQ8+8vKSG5kcSzD/2f
	 0mu8GeNzfYdRg==
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eaaa9b1591so593102e0c.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 10:16:06 -0700 (PDT)
X-Gm-Message-State: AFq9FYJ1MeeEXo1N00ncbadEYcdmjBnw1fth4AeYc8yBJC6PgG64VzhY
	a/Nyc1CGceBcjd0+CwGGhWuLlxenPnYFIYTOEKAAuVxvAA+KfMz0iFn8xwantr/TPhxKSGRFs7W
	xRxyCWBNFAlVfFswHVGaniCmGTXhSs0o=
X-Received: by 2002:a05:6122:4b89:b0:5ea:c37b:450 with SMTP id
 71dfb90a1353d-5eaebe722c3mr1215332e0c.20.1792602966079; Wed, 21 Oct 2026
 10:16:06 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021164452.2439333-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261021164452.2439333-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 18:15:29 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7eF4j+r-cyU_B3jrE0qhFbvx1TduAgg1fp38+2nHEVRw@mail.gmail.com>
X-Gm-Features: AclHuK9QdsL7pLAXiyy5SQgSqFSYpWokSKcC3MpcG_CidhHf0rzpT1G-HPV0dbk
Message-ID: <CAL3q7H7eF4j+r-cyU_B3jrE0qhFbvx1TduAgg1fp38+2nHEVRw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: force a transaction commit when fsyncing stripe
 tree extents
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 5:46=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> An extent in a block-group that uses the RAID stripe tree has its logical=
 to
> physical mapping stored in that tree, which only becomes durable when the
> stripe tree is written out at transaction commit. But the RAID stripe
> tree is not logged in the log tree.
>
> A fast fsync therefore logs a file extent item whose logical range cannot=
 be
> resolved after a crash.

And why is only the fast fsync affected?

I can't see why the full fsync isn't affected.

Thanks.

> Replay restores the file extent item and the file has
> the correct size, but reading it fails with EIO and nothing is reported.
>
> Force a full commit when logging such an extent instead.
>
> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extent=
s")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/tree-log.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1d9dfb63fc5a..b758eea6ee5b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -30,6 +30,8 @@
>  #include "print-tree.h"
>  #include "tree-checker.h"
>  #include "delayed-inode.h"
> +#include "volumes.h"
> +#include "raid-stripe-tree.h"
>
>  #define MAX_CONFLICT_INODES 10
>
> @@ -5107,6 +5109,24 @@ static int log_extent_csums(struct btrfs_trans_han=
dle *trans,
>         return ret;
>  }
>
> +static bool log_extent_needs_stripe_tree(struct btrfs_fs_info *fs_info,
> +                                        const struct extent_map *em)
> +{
> +       struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) =3D NULL=
;
> +
> +       if (!btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> +               return false;
> +
> +       if (em->disk_bytenr >=3D EXTENT_MAP_LAST_BYTE)
> +               return false;
> +
> +       map =3D btrfs_find_chunk_map(fs_info, em->disk_bytenr, 1);
> +       if (!map)
> +               return false;
> +
> +       return btrfs_need_stripe_tree_update(fs_info, map->type);
> +}
> +
>  static int log_one_extent(struct btrfs_trans_handle *trans,
>                           struct btrfs_inode *inode,
>                           const struct extent_map *em,
> @@ -5124,6 +5144,9 @@ static int log_one_extent(struct btrfs_trans_handle=
 *trans,
>         u64 block_len;
>         int ret;
>
> +       if (log_extent_needs_stripe_tree(inode->root->fs_info, em))
> +               return BTRFS_LOG_FORCE_COMMIT;
> +
>         btrfs_set_stack_file_extent_generation(&fi, trans->transid);
>         if (em->flags & EXTENT_FLAG_PREALLOC)
>                 btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_P=
REALLOC);
> --
> 2.56.0
>
>
