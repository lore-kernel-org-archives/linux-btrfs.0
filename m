Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296552;
	b=KXb+MgntyUx7gXbCtsC3bvwCyt1qRJ3G1xvGLFUtfbX1hXqX4Rn3FK1QNruwXO8ifFs+
	 oiJP4I2cw5zPYJ7wFIfJwulTYscRdZVnMVrVuPX8p7J/Ke62SncxXTXewY6kh+YX9OVis
	 XP2DZLnsWFbQ2+SBMEg0aRbsV1hiXTLLKOz5I000II/020wTEx6vMuy3zD9k+Y0GwtN2A
	 lUS8NCsG75dugAvy0P2NRVQgU1I7+1S/ZJ62nmdzjshgoB+uZM4FMcQwu0LjggSi9G1An
	 Zi3/ACjFGqDS6MQ59Kjnl5PTTkXzB68HAq5FjBFLfNRyjPAA0m6Zs8P66OzB15DDTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296552;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UiXZ9BgIzQkn6EFH4P+iWCgrsRcbki8OlT8PLa/j/7E=;
	b=lQ2sjbAZ+Nmr14alsGj1nM5KpdHs84Pc3nkRK96uynFKBBwdm82EzBYXOHeU39/yYTOO
	 WCDzyjuhAk7OMb+cWeWirESA9zYuqXTKtuT8aeub7rmbSDYQkUjB291XG/+eTur1ui4hP
	 Ad2tLYIkr+Y4l7ASKaIdiCaWARheuRsOUoaiMFsPCdV4ZN4+9S4BaOi1tynM389oDpOzc
	 17iTuUPdnPzBrrKr4bYCZGLvLORx4YbsCMPb6ReDucSi58MID0ehfVtcsDp9OMndCHIzC
	 rurT3D1H6b1Q8ZqJmCaG6zt8jnH5ce2lGl2dJSY8oWoqVruYRBRZEEyFnKxIIbnLtkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R5hhTu3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02B606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R5hhTu3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360F11F031E5
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793296542;
	bh=UiXZ9BgIzQkn6EFH4P+iWCgrsRcbki8OlT8PLa/j/7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R5hhTu3SoE9opfct55crD7fQtBfueBPQGTuE0axnr8cWrs2Vu8io1eoKt6eUAYiPm
	 +c8yqPwtJGPpCsajSwfTS7LsdcG6T9IE12bBkRlIWom3tRPUsQs+nIslW+MHgGvZz1
	 4Z2KN0f9P6Ch4omAm/dJEqL8dL/Y1hV0EPuccLVdVZz5PCz3embGuzP7D3sV1ee8/P
	 j83FuPU9GLY9VDYurvzf8/28SdLYhV69nhdpv5iQjycBRLLeCeJUGZFlcJeSk9OJ5v
	 NRrSyJXJc1NrET0TTOWCgeZCDQDG4BdkocAR5+V6/cfiEoM1EnPMzywKpp+lhhFKIW
	 Un4js9OGTHOhw==
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9906a5410f5so927822241.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:55:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxgwvpy4o/mfTAvGXpz5Zzu9QwjcAAsK4koV1s09P9uTitF1sAPpIVj6ulju+wzCv62mgbsNqRPWnvprQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL76/4m0wZb1jD10lHuPcumjuRQXesr2dwTplDyYW4xmqytZZZe
	vlPCfWdqNTm3SQhH7iwN5Gc08TiVQ7ZjcwOdeZWqbbcl53rtfkLwoD3s+SvprBTaBozcYlLgwGK
	wHWyPpRPmEJGkmULLVyt/V1A07cm1DBQ=
X-Received: by 2002:a05:6102:370d:b0:7cb:cfcf:3d01 with SMTP id
 ada2fe7eead31-7d05432ac0amr1157160137.33.1793296541426; Thu, 29 Oct 2026
 10:55:41 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179328314071.648427.12527832319954042748@gmail.com>
In-Reply-To: <179328314071.648427.12527832319954042748@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 29 Oct 2026 17:55:04 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6tz-YXxtTk3MVm7cLAQh1coBAkcF7KkH+GUwZnznnFrQ@mail.gmail.com>
X-Gm-Features: AclHuK86Gn4r3KoV1EZing1H0aYPBgdIG60MDZvYx2WshoVoFo2GdhtUwvldtTk
Message-ID: <CAL3q7H6tz-YXxtTk3MVm7cLAQh1coBAkcF7KkH+GUwZnznnFrQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 2:12=E2=80=AFPM Cheng Yongkang <teel4res@gmail.com>=
 wrote:
>
> validate_sys_chunk_array() reads the on-disk num_stripes and passes it to
> btrfs_chunk_item_size() to check that the chunk item fits in the system
> chunk array.  btrfs_chunk_item_size() has ASSERT(num_stripes), and the
> only num_stripes =3D=3D 0 rejection is in btrfs_check_chunk_valid(), whic=
h is
> called later.  A crafted superblock with a BTRFS_CHUNK_ITEM_KEY entry
> whose btrfs_chunk has num_stripes =3D=3D 0 therefore trips the assertion
> before the invalid chunk is rejected:
>
>   assertion failed: num_stripes, in fs/btrfs/volumes.h:714
>   kernel BUG at fs/btrfs/volumes.h:714!
>   RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
>   Call Trace:
>    open_ctree
>    btrfs_get_tree
>    vfs_get_tree
>    do_new_mount
>
> Commit 2a9bb78cfd36 ("btrfs: validate system chunk array at
> btrfs_validate_super()") moved the validation out of
> btrfs_read_sys_array(), which rejected num_stripes =3D=3D 0 explicitly.
> Reject zero stripes in validate_sys_chunk_array() before calling
> btrfs_chunk_item_size(), so the crafted superblock is rejected with
> -EUCLEAN before the assertion is evaluated.  open_ctree() turns the
> validation failure into -EINVAL for the mount.
>
> Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validat=
e_super()")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
>  fs/btrfs/disk-io.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c628c50..920ca4b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2389,6 +2389,19 @@ static int validate_sys_chunk_array(const struct b=
trfs_fs_info *fs_info,
>
>                 chunk =3D (struct btrfs_chunk *)(sb->sys_chunk_array + cu=
r);
>                 num_stripes =3D btrfs_stack_chunk_num_stripes(chunk);
> +               /*
> +                * btrfs_chunk_item_size() cannot represent a chunk witho=
ut

I find this puzzling, using the "represent" word since
btrfs_chunk_item_size() does not represent anything, it just does a
calculation.

> +                * stripes; such a chunk is also invalid in the system ch=
unk
> +                * array (system chunks are never remapped).  Check befor=
e

Also the "remapped" detail is also confusing and I can't grasp the
intention or why it matters.

> +                * btrfs_chunk_item_size() so a crafted super block is re=
jected
> +                * with -EUCLEAN instead of tripping its ASSERT().

Something simpler and more clear for the whole comment:

"We can not have 0 stripes, and passing 0 to btrfs_chunk_item_size()
triggers an ASSERT(), so fail immediately if we have 0 stripes."

Codewise it looks good, thanks.

> +                */
> +               if (unlikely(num_stripes =3D=3D 0)) {
> +                       btrfs_err(fs_info,
> +                                 "invalid chunk num_stripes 0 in sys_arr=
ay at offset %u",
> +                                 cur);
> +                       return -EUCLEAN;
> +               }
>                 if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > s=
ys_array_size))
>                         goto short_read;
>                 type =3D btrfs_stack_chunk_type(chunk);
> --
> 2.34.1
>
>
