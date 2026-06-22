Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1F363C6C
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127119; cv=none; b=fGLQMIBe6ugCIU9S49BPm8UwmQLoh+IYo2V0V7GFEzy5c7NpTaaC1kgAOKqwYg2CAPtfuJkMbtTbyVqWha2dhBybSCNG/U0yZXf3PghniI77wS6hIl221VyanlNEGIrnQ8W4Wr8lMFLaVTlejZyC1GPw5gPqlAcZ35VrX1EE3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127119; c=relaxed/simple;
	bh=WmURuebd5NtufnaWdrCwhWEgE9IS18NlVDwEk03tcdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CyQs+m2OIixhIDyv5z+NZ5RHyovrAtoK+iw95bBG/ljx8SetAeVyuUHIwiaA6YjvzzFiIuyQYdcl7OmfNh3w13TEvt7KG7YOl6EQuJUsGOursxjveolo1bLCwVKrdvS3VadpjU5iWhKOr3hmY9SyxTkhv1bAaqOcBQKzq+MJf1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caJNNJo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caJNNJo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209791F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127118;
	bh=PkuTlai8Pa/sHbqKYHax8Udriht6l7jXOBcW5jbBf9Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=caJNNJo1hOIt0Tpmd1q4pJD1M1gWsy+liXZtUxsEgFCmiuRzcxsFTs7mipmTlZ2AX
	 8+eQ++ZjuUtYZF+3HqP6rWTE40s2PG4kzFDNNXrf0TXAAkF4/nfT+6MOn3ypFyl0b9
	 HLYB90IdunILkbq2O0epyn8Y1InSWV0fh7DggFwD+D9A10bY/Zj2pLHwXcqdp4HvPT
	 Jysr76veN0NBr2LW+yk6aLzSUlhuPhLdTVgVHhCOcXeOnK4884bmwUO7wN3rTXaMNY
	 cioTMuSnQPhrQ9csz0TRu+51SIzobdRgDsBqH1u6bG8Ief95oIYKPxTxYuLhkmrA0G
	 LRFRmkorKv7ZA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c07a6520cafso465183966b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 04:18:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YxDWzFXJ8faKTyB7oCFy/Nhm4nPahauVR/8I1IEPUR3Y3KFFHB5
	LK4KhAIJFuD9z1zxmdp7kI6LDonM+gQNTFn10sYw6jjafai0OXlXgnkurmCJbJElU7aUR56n58A
	a6AP4BjkDeiVq0xSQLxhvnoqnaDrY4a0=
X-Received: by 2002:a17:907:6d0d:b0:c06:a4c4:ccae with SMTP id
 a640c23a62f3a-c0c666c0474mr424708466b.46.1782127116818; Mon, 22 Jun 2026
 04:18:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
In-Reply-To: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 22 Jun 2026 12:17:59 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4JZVzcp2X=Vf9_Vfu_cXOZhKZ2Pp4v6nWxpTZVJuPxLw@mail.gmail.com>
X-Gm-Features: AVVi8CdbyUDABgS3eSjLA_5G5jwfoHX-70P855moXg2eGj5ZvpP-VraJKLGb51w
Message-ID: <CAL3q7H4JZVzcp2X=Vf9_Vfu_cXOZhKZ2Pp4v6nWxpTZVJuPxLw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 21, 2026 at 10:12=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> When dumpping a tree block, btrfs_header::owner is printed as
> unsigned, which can result in numbers that are hard to read, e.g:
>
>  BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space =
1676 owner 18446744073709551607
>
> For the above output, 18446744073709551607 is (s64)-9, the root id of dat=
a
> reloc tree.
>
> Despite those pre-defined root ids that are already negative, existing
> subvolume trees will not have any negative values, as subvolume trees can
> only utilize the lower 48 bits, so there will be no output change for
> existing subvolumes, thus no extra confusion.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/print-tree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> index 87e60a2d4bd8..53e726119ca7 100644
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> @@ -449,9 +449,9 @@ void btrfs_print_leaf(const struct extent_buffer *l)
>         nr =3D btrfs_header_nritems(l);
>
>         btrfs_info(fs_info,
> -                  "leaf %llu gen %llu total ptrs %d free space %d owner =
%llu",
> +                  "leaf %llu gen %llu total ptrs %d free space %d owner =
%lld",
>                    btrfs_header_bytenr(l), btrfs_header_generation(l), nr=
,
> -                  btrfs_leaf_free_space(l), btrfs_header_owner(l));
> +                  btrfs_leaf_free_space(l), (s64)btrfs_header_owner(l));
>         print_eb_refs_lock(l);
>         for (i =3D 0 ; i < nr ; i++) {
>                 char key_buf[KEY_TYPE_BUF_SIZE];
> @@ -600,10 +600,10 @@ void btrfs_print_tree(const struct extent_buffer *c=
, bool follow)
>                 return;
>         }
>         btrfs_info(fs_info,
> -                  "node %llu level %d gen %llu total ptrs %d free spc %u=
 owner %llu",
> +                  "node %llu level %d gen %llu total ptrs %d free spc %u=
 owner %lld",
>                    btrfs_header_bytenr(c), level, btrfs_header_generation=
(c),
>                    nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
> -                  btrfs_header_owner(c));
> +                  (s64)btrfs_header_owner(c));
>         print_eb_refs_lock(c);
>         for (i =3D 0; i < nr; i++) {
>                 btrfs_node_key_to_cpu(c, &key, i);
> --
> 2.54.0
>
>
