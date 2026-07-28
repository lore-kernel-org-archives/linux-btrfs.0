Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C280E41A515
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231841; cv=none; b=nl/ugnDMvZH2QLgVeo7hioc+RpoZhsSFxBRc99FX/w1I6AFOkR6d4h94tNCZJrbGBDQaFCcyKyqC7JTzLS+0BLnNEopfy3KvvRSy3fVsxGsEFTdKhle+KkuYCxE61y8fTjDzqpAwGbwSoioBKyUsXl8/eor62zhdNykEUfh06zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231841; c=relaxed/simple;
	bh=bywoMzHTwdCpQdXuFYNX/sRCaa2Zc33K3sdNf/t5cmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFXZ07t2mnRe1hz4ViBRca5vf4JKVDNe739xtAB/P82pX+ZPEejAFhXVG5Rn/UcEIizEqDjky3LT2of9nca7UKHiMWi41juTbVqnG2OVm4h2NNzGEYu8jPdNIHJRHuydve/O3bA+bqWDI8bwCbpmX1zGK2A6u8m69rju2oFXF50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJghm4uk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJghm4uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9FE1F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785231840;
	bh=46eSYUBPjhOyY0fBnfpC9SlaUoOzgayQlAD8QQDzHV4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VJghm4ukSuluBtouqx1dxmNv7lqWUX9uZRmnhz3HrZ4VrJJ8GiJR8AUkos50a8W5G
	 r5P5VzebAHEV7k3m+dYe7MBVkn4vDEJJdrv94HoIwxXrltt2jGxw0vEkaBo/VCqp4T
	 28/bCEiPHq4A/yJNBP+9dN53q85D4l3AP5LcA3eqrdL4j9Ds0Vkpf5cNBQ2fnGLlRH
	 YJsYLLWzB60tDDFL+1dtyZCMHiSrRD7DsbzpdGCc2emSSLzHvATXteekKYx4BFvMIy
	 bT3bYimwatWBJIm8+Nx7DF6z9DEGS3lCXMIdRjChzrfXe3EkjuyONUiHDpGQOtm1wh
	 Xe1wFBvlAojcA==
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bf94664327so1402130e0c.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:44:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YxptRESmA52Cj7dQ3vbkal4tdY5S4a/aEJ4FGmMRwi59Lx4uOSt
	MS6t/SP86tCGa3cSiN4UBnQRI+/Jdniu2rBVGnLe8VKAP0GRQwagBXRsUEVtXtxXYgBizQ5V3M7
	Uad2zVpumrQhURGWJOWs/wHVlcZsdIxs=
X-Received: by 2002:a05:6122:d90:b0:5a4:c20a:ba4d with SMTP id
 71dfb90a1353d-5c33f8d14efmr555358e0c.4.1785231839816; Tue, 28 Jul 2026
 02:43:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785229591.git.wqu@suse.com> <5cd4bb1a9e30e8d81f5ef51b36c416377725bf9b.1785229591.git.wqu@suse.com>
In-Reply-To: <5cd4bb1a9e30e8d81f5ef51b36c416377725bf9b.1785229591.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 28 Jul 2026 10:43:22 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6dSkvFVxT57fceUi3u+JcqXmudEf3_vLaRHKtssBbXqg@mail.gmail.com>
X-Gm-Features: AUfX_mzE6mWcL83KuXPLd-A8PdeqRbkjWodj7KtId7OlLbLXb8Tpu6e4aH1Aav0
Message-ID: <CAL3q7H6dSkvFVxT57fceUi3u+JcqXmudEf3_vLaRHKtssBbXqg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] btrfs: add validation for extent states
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 10:36=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Extent maps have the extra validation since commit 3f255ece2f1e ("btrfs:
> introduce extra sanity checks for extent maps"), but extent states do
> not have a similar check.
>
> Introduce a basic alignment check for the following call sites, so that
> we can cover all extent states inserted into the tree:
>
> - insert_state_fast()
> - insert_state()
> - split_state()
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-io-tree.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
> index c18ea5ef2974..c6e639d0fcc1 100644
> --- a/fs/btrfs/extent-io-tree.c
> +++ b/fs/btrfs/extent-io-tree.c
> @@ -334,6 +334,21 @@ static inline struct extent_state *tree_search(struc=
t extent_io_tree *tree, u64
>         return tree_search_for_insert(tree, offset, NULL, NULL);
>  }
>
> +static void validate_extent_state(const struct extent_io_tree *tree,
> +                                 struct extent_state *state)

Why isn't state marked as const as well?

With that change:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +{
> +       u32 blocksize;
> +
> +       if (tree->owner !=3D IO_TREE_INODE_IO)
> +               return;
> +
> +       blocksize =3D btrfs_extent_io_tree_to_fs_info(tree)->sectorsize;
> +       ASSERT(IS_ALIGNED(state->start, blocksize) &&
> +              IS_ALIGNED(state->end + 1, blocksize),
> +              "unaligned extent state, blocksize=3D%u start=3D%llu end=
=3D%llu state=3D0x%x",
> +              blocksize, state->start, state->end, state->state);
> +}
> +
>  #define extent_io_tree_panic(tree, state, opname, err)                  =
    \
>         btrfs_panic(btrfs_extent_io_tree_to_fs_info((tree)), (err),      =
   \
>                     "extent io tree error on %s state start %llu end %llu=
", \
> @@ -429,6 +444,8 @@ static struct extent_state *insert_state(struct exten=
t_io_tree *tree,
>         const u64 end =3D state->end + 1;
>         const bool try_merge =3D !(bits & (EXTENT_LOCK_BITS | EXTENT_BOUN=
DARY));
>
> +       validate_extent_state(tree, state);
> +
>         set_state_bits(tree, state, bits, changeset);
>
>         node =3D &tree->state.rb_node;
> @@ -481,6 +498,8 @@ static void insert_state_fast(struct extent_io_tree *=
tree,
>                               struct rb_node *parent, unsigned bits,
>                               struct extent_changeset *changeset)
>  {
> +       validate_extent_state(tree, state);
> +
>         set_state_bits(tree, state, bits, changeset);
>         rb_link_node(&state->rb_node, parent, node);
>         rb_insert_color(&state->rb_node, &tree->state);
> @@ -533,6 +552,8 @@ static int split_state(struct extent_io_tree *tree, s=
truct extent_state *orig,
>                 }
>         }
>
> +       validate_extent_state(tree, orig);
> +       validate_extent_state(tree, prealloc);
>         rb_link_node(&prealloc->rb_node, parent, node);
>         rb_insert_color(&prealloc->rb_node, &tree->state);
>
> --
> 2.54.0
>
>
