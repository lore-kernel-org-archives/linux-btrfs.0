Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352876;
	b=Z3+sxFdRpqtu5aAjNxcSk3WKPMgfff5gQk+8L34jgKqFrQJKP6vct2VTs2HNoSsOdeVf
	 s+wX7XR6oaqhS6JxTSzADkfi/a9/fzJqicDVio6IjTEpol9Q2/WsoB3mJUpNsgU4IDsmY
	 S26pS00kU3vMLw+4EGQtAEHAXZUEk6PE9Yn4r0CKCPxjQzz6Up9SJ9jhRHuhmQiLdml9H
	 +GazbZKMPxcI9DXMNDD6Tgp0MY7R/7+3jhQAY6tuW5zqv3V6dfkN6AnQdLtDw4f5BMZWu
	 TVDwbrfVNGKljSERTTuZfPDb9pCQU+i62qDmxS74GDXSBW4Cu8immj0MDeNtTh6vA9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352876;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=QB8MbDWEyGVAfh+sMolcgor+trKpKEIlCi5B4QpJMt8=;
	b=UJ7OEFrVE1n2/I+UjTODzptNe8kP0+q69JUPhEi818fPUwd/4vGnY2Qz5QHeQqsKVmLg
	 ay/lCZpiT2N+6CiPDrDX2weh3HWvsbZo0SolHlxoAKIOdP7JLiKBmSTOb6DdE7J/nvHJ3
	 WULQiAqv6UAvAlg4ySjo+5TcBcVZfgw2TlvEyCHzYv10FlvJCh5LkOSrNwANX2c9LGhPM
	 bIBvU3mnPPp21gqmQjqm6Mw95gbtqBShxQw+FYXFQTDf/JIt5hPPo0D841muXzCK8nFpy
	 dnK/rlXmASTniiYzGIksrCVdQCcll/ah1+yPA31ZFwFbwXqEQDxHNRO3rx3QPxdBFLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bLBBQF3p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AB5606A334
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bLBBQF3p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950451F00A07
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 23:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352875;
	bh=QB8MbDWEyGVAfh+sMolcgor+trKpKEIlCi5B4QpJMt8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bLBBQF3plDwF/ZDiX6TQhNW5HRQZ1we1atfBv+Cv3Apu2MuIZNj9cdYLdYLJ7/0kp
	 4g15XezOBpusah2eW0YDH+ueZ3pvPP3Y884VkUMOsrW9YJE/96n1pw0Wlppx+Rbp2L
	 rqTc1YpNKFDt5A98iSEgBeIzYsw3imqD6w0nZ8czzYt830GdJtsQClMOe5INYNqeGS
	 ltzA4Yjqr/KFdm8suPgM8XkJXFIKz4GR1Vyp5C3CEYRSz+D6VJ8GRTNMpKMvD4qZea
	 UuWNNFjl8+dv1tAqvUUMOD0uyZLyy9sqcmPLqbs0Fug+cJDMLy1qiJfVwKEiQRTFNU
	 YTy+7LpfwwiOg==
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9999f21f617so720575241.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 15:21:15 -0800 (PST)
X-Gm-Message-State: APuU4Z+sJ54LW/fjUiFGmEz3uo2GW8YPjBeMLcsCuemIBqkfFSKCpKWU
	9yr6V+x/5kP+b4sbuxS6JtuwXJB6QJ5lhSIdOPLLWZraxBoEvkr/0TEXORmaJSj2nXjmaec7a0Z
	v1L/JR8wO0PqAXlvheiDSWGivaCzIu+A=
X-Received: by 2002:a05:6102:374f:b0:7d2:7827:c01 with SMTP id
 ada2fe7eead31-7d506101879mr190850137.28.1794352874777; Tue, 10 Nov 2026
 15:21:14 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <6e59a1f7c6493ec2aed4d01d8ee67acb1ae60588.1794349782.git.wqu@suse.com>
In-Reply-To: <6e59a1f7c6493ec2aed4d01d8ee67acb1ae60588.1794349782.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Nov 2026 23:20:38 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4z=zutVAbjzPjEOReNwpCreOa-O7V8ssMuDdSwDk_h1Q@mail.gmail.com>
X-Gm-Features: AclHuK-L_DFf_clFj5MUyvo7qtgwpfI8ZxOatqNovmYT2C3nx0v-mbaE8cKLeh4
Message-ID: <CAL3q7H4z=zutVAbjzPjEOReNwpCreOa-O7V8ssMuDdSwDk_h1Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: tree-checker: validate qgroup info and limit items
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	Noah Weinberger <NoahWeinberger2003@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 10:32=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> Add tree-checker entries for them. Both items check:
>
> - The key objectid must be 0
>   They are always created with (0, QGROUP_INFO/QGROUP_LIMIT, qgroupid),
>   the qgroup id is stored in the key offset.
>
> - The item size must be exactly the size of the item structure
>   The items are always inserted with that size and there is no extension
>   of the structures.
>
> For the qgroup info item there is one more check:
>
> - The generation must not exceed the super block generation + 1
>
> All of them are always satisfied by items created by the kernel, so there
> is no compatibility concern.
>
> The limit flags and values are not checked intentionally, the reasons are=
:
>
> - The kernel has no runtime rejection for invalid limit flags
>   So some one can use qgroup inherit to intentionally pass some invalid
>   values. If we apply strict checks before runtime validation, this can
>   easily flips the fs RO, causing a DoS attack.
>
> - The mkfs.btrfs is generating garbage for limit item
>   Because we didn't zero the limit item, all kinds of garbage can be
>   there if using "mkfs.btrfs -O quota".
>   That will be fixed, but we can not reject such fses yet.
>
> Reported-by: Noah Weinberger <NoahWeinberger2003@proton.me>
> Link: https://lore.kernel.org/linux-btrfs/B_lvw-WNI1mnHnK011Sfk_ZNaL0eg5u=
OfD2T3q-vOfWv8426VwPA4NPpWaAcHxRZf3OrzGzwZjckHqKEKUS7UQJk6TEN_7xD1SkwM5q8hs=
w=3D@proton.me/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/tree-checker.c | 59 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14babf..5f1c7622f07a 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2117,6 +2117,59 @@ static int check_qgroup_status_item(const struct e=
xtent_buffer *leaf, int slot)
>         return 0;
>  }
>
> +static int check_qgroup_info_item(const struct extent_buffer *leaf,
> +                                 const struct btrfs_key *key, int slot)
> +{
> +       const u32 item_size =3D btrfs_item_size(leaf, slot);
> +       const u64 super_gen =3D btrfs_super_generation(leaf->fs_info->sup=
er_copy);
> +       struct btrfs_qgroup_info_item *ptr;
> +       u64 generation;
> +
> +       if (unlikely(key->objectid !=3D 0)) {
> +               generic_err(leaf, slot,
> +               "invalid key objectid for qgroup info item, have %llu exp=
ect 0",
> +                           key->objectid);
> +               return -EUCLEAN;
> +       }
> +       if (unlikely(item_size !=3D sizeof(struct btrfs_qgroup_info_item)=
)) {
> +               generic_err(leaf, slot,
> +               "invalid item size for qgroup info item, have %u expect %=
zu",
> +                           item_size, sizeof(struct btrfs_qgroup_info_it=
em));
> +               return -EUCLEAN;
> +       }
> +
> +       ptr =3D btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_info_item)=
;
> +       /* Use super block generation + 1 to cover the transaction being =
committed. */
> +       generation =3D btrfs_qgroup_info_generation(leaf, ptr);
> +       if (unlikely(generation > super_gen + 1)) {
> +               generic_err(leaf, slot,
> +               "invalid qgroup info generation, have %llu expect no more=
 than %llu",
> +                           generation, super_gen + 1);
> +               return -EUCLEAN;
> +       }
> +       return 0;
> +}
> +
> +static int check_qgroup_limit_item(const struct extent_buffer *leaf,
> +                                  const struct btrfs_key *key, int slot)
> +{
> +       const u32 item_size =3D btrfs_item_size(leaf, slot);
> +
> +       if (unlikely(key->objectid !=3D 0)) {
> +               generic_err(leaf, slot,
> +               "invalid key objectid for qgroup limit item, have %llu ex=
pect 0",
> +                           key->objectid);
> +               return -EUCLEAN;
> +       }
> +       if (unlikely(item_size !=3D sizeof(struct btrfs_qgroup_limit_item=
))) {
> +               generic_err(leaf, slot,
> +               "invalid item size for qgroup limit item, have %u expect =
%zu",
> +                           item_size, sizeof(struct btrfs_qgroup_limit_i=
tem));
> +               return -EUCLEAN;
> +       }
> +       return 0;
> +}
> +
>  static int check_remap_key(const struct extent_buffer *leaf,
>                            const struct btrfs_key *key, int slot)
>  {
> @@ -2512,6 +2565,12 @@ static enum btrfs_tree_block_status check_leaf_ite=
m(struct extent_buffer *leaf,
>         case BTRFS_QGROUP_STATUS_KEY:
>                 ret =3D check_qgroup_status_item(leaf, slot);
>                 break;
> +       case BTRFS_QGROUP_INFO_KEY:
> +               ret =3D check_qgroup_info_item(leaf, key, slot);
> +               break;
> +       case BTRFS_QGROUP_LIMIT_KEY:
> +               ret =3D check_qgroup_limit_item(leaf, key, slot);
> +               break;
>         case BTRFS_IDENTITY_REMAP_KEY:
>         case BTRFS_REMAP_KEY:
>         case BTRFS_REMAP_BACKREF_KEY:
> --
> 2.56.0
>
>
