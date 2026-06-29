Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134114028C3
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734928; cv=none; b=RW2NaT6tAWwSw6Ov3PmS8dFFel8OvcnktB+sGhklsZeiOk4Z1j0tEZX9HPDoWDCjaoXNLVQRGopNuxn+7Et4tu63tZ+EpgERpQmpSDp+14lWvHZJ98ykdNE+lK2PBURkbA0lywedwxS7ONznXraMiPOiUWcamRLTvQxE6dFC3kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734928; c=relaxed/simple;
	bh=wcHDdBEdZ9BqmZyPnjbyb5A39dtc63yNqnzfZjvvHfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PIkFuUOjj4bDLnRaPIkmxlyMX/MukwBlOeqwPIox4GI+VikpaGyeqvUwxblmIANdQ7T4eF+u9m/kRqYT3vwkOxW/J/CtAfN06FZTXMwzwhnuyQqFRkW5847xVtAubrAlDteSH19KosNi7qcRBXiByXsK6nUDtJn5Ir6gU0gx1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJc9F4Qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJc9F4Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960F41F00A3E
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 12:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782734925;
	bh=0PI+9H5y+wZDbWcbfACRuupbfWCyENWM/xNFS+jk1yA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oJc9F4Qi9Spe0isQqzUB7hNOi9EvGGAKyN5b5BGwwuweTMcv2CwZmGyVDeLDZAb7e
	 LpSdXKMnUvK177ewLvhAmgStDud0aXc8YjO5kikMrK+tmDdk8DyYGfKL/Vzo+XbfAp
	 Jlz/hd74sd35lhvsItZrDwrIP8vQwKueq0CQ1K/DHod/dyaeS5Dbw7qG4kKfD4h08d
	 VVr4AE0W1kxh0vUq9UvHeCsMVFUfUUTHenVMCnWACnJy/iccnXiQvcHhkM5SUXdj7z
	 PLDKi9VephluaOO4DHhcmPkAq6mi/oas+83LmVfreY1CL95jPw4PqrRlqbZZQw0E4G
	 //hQewUznefYg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c12614b81c9so192166366b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:08:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YzfMovaRgwkZ6yv5cENc89oGbYCmMy+1RXOfC5ehUZoaFFDHPw+
	vLnjBb2vFDaLg60sO5QxcMc4QYpIbe04zmv1z/jbB8UOTo2SMxYrXIB7Z/6SWJ5TvG/kHtznOhF
	ZoCMP3vS8RnX454DVVGfuy2MSs06FSH8=
X-Received: by 2002:a17:906:2092:b0:c12:21eb:a8b1 with SMTP id
 a640c23a62f3a-c1221ebc59emr428473466b.25.1782734924270; Mon, 29 Jun 2026
 05:08:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629070843.4116053-1-davechen@synology.com>
In-Reply-To: <20260629070843.4116053-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 13:08:05 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
X-Gm-Features: AVVi8CdmQvp6mL886C7fpA9wFGGw4JNvKv5tAZcH3zkqsTy3tvsgznU5nWytPBM
Message-ID: <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix u32 to s64 type conversion in
 dirty_metadata_bytes accounting
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 8:09=E2=80=AFAM Dave Chen <davechen@synology.com> w=
rote:
>
> The percpu_counter dirty_metadata_bytes is updated by negating eb->len
> and passing it to percpu_counter_add_batch(), whose amount parameter is
> s64.  Since commit 84cda1a6087d ("btrfs: cache folio size and shift in
> extent_buffer"), eb->len is u32.  The u32 result of -eb->len, when
> widened to the s64 parameter, becomes a large positive value instead of
> the intended negative value.  For eb->len =3D=3D 16384 the counter adds
> +4294950912 instead of subtracting 16384.
>
> The counter therefore grows on every metadata writeback instead of
> shrinking by the extent buffer size, permanently exceeding
> BTRFS_DIRTY_METADATA_THRESH and causing __btrfs_btree_balance_dirty()
> to trigger balance_dirty_pages_ratelimited() unconditionally, adding
> unnecessary writeback pressure.
>
> Cast eb->len to s64 before negation at both call sites so the
> subtraction is performed in signed 64-bit arithmetic.
>
> Signed-off-by: Dave Chen <davechen@synology.com>

Curious, do you have any performance data to give an idea of the impact?

I'm asking not only for clarity but also to determine if adding a
Fixes tag for stable backports makes sense.
The commit that caused this issue is 84cda1a6087d ("btrfs: cache folio
size and shift in extent_buffer"), which changed struct
extent_buffer::len from unsigned long (64-bit on 64 bits platforms) to
u32.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.


> ---
>  fs/btrfs/extent_io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 7d604524e83c..de5785117a47 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2004,7 +2004,7 @@ static noinline_for_stack bool lock_extent_buffer_f=
or_io(struct extent_buffer *e
>
>                 btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
>                 percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
> -                                        -eb->len,
> +                                        -(s64)eb->len,
>                                          fs_info->dirty_metadata_batch);
>                 ret =3D true;
>         } else {
> @@ -3774,7 +3774,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_ha=
ndle *trans,
>                 return;
>
>         buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
> -       percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -eb->len=
,
> +       percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb=
->len,
>                                  fs_info->dirty_metadata_batch);
>
>         for (int i =3D 0; i < num_extent_folios(eb); i++) {
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
