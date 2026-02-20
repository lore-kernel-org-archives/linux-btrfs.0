Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF12045AD
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 13:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771593259; cv=none; b=r5EbjvDFI/scmG+60EKJ2HbkjL/2L773KSVBAq2MmAEdbQV2NNlEx2g5aFJa5qdzlFSaA97AmI6lRy/068vu/kpbTDWLX7/j27VbDavISGvV0Vkl4A8mXFbAlo7YdqvnUnA106joka9J0mf2qBEp0rCjEmYcM3ZbK5QeGtHf334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771593259; c=relaxed/simple;
	bh=FG/lrIaFsFiL2Zi30/rQDX02s7/P7FXqZpvO5mscH+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mC31SsWSGF+YBXg6BLUp3JPXV5vLXSvtpUu9rjdHJOeSUzmiCz2luMzYQD3oZsHtFtNfQFGGaUS4jWIdZ91R5JEb1Td4ETRwhdA47M8aZq7DNDQH3oTUMptAS3GyJK7mlqQlc0p4cF7sEHFpqFD4OWPW3dVxWwACnXbzteO8qi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Brr3pPEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Brr3pPEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5228C116C6
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771593258;
	bh=FG/lrIaFsFiL2Zi30/rQDX02s7/P7FXqZpvO5mscH+8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Brr3pPEJ4xVh7sC7f+b/Wn1rXGd72E6CM0nUQLZ4IdJTUOdeih+ramGWD/k81bqA9
	 ebF2U1YTDpTUm/T/vXYxlnOS/zuweqitOt46IYjTWe4xkZ7vi5/D4b63eRqTdfRyW1
	 8jUR1zp3cTA6OjzqlPFnv7WJkFu+AmYNGebnegr4zjpa3QoRvz3VCkSNaKPjRCOuIG
	 osZRJCFMLZj81jlWBknHquRWFattWUC+FMvfdXitEBB7Bz1QUD3f1pY76XyLYPHXu8
	 XMILSXIrEuyTf6g+tmbSSydA7QLkzVmwyZIjTI7Bc+GgwmJ1uu4omSpTp+AJp+uAD1
	 /xzpHjwN4UaOA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f992167dcso264145166b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 05:14:18 -0800 (PST)
X-Gm-Message-State: AOJu0YwrUGr1ibwByt7U51UKrlvSUxiM4IvkzVixALynLD4FajRJj5RY
	92kttuOL6OEJmIch4ufI93Cy3rsJORbuOxfFZaWZve6XKEfvy3tEc4QZMad8BePIYl4MMIdC3HF
	8DoDDKkHhJrrtaqsNlm+kDzqUtkdwtbI=
X-Received: by 2002:a17:907:5c9:b0:b8f:79bc:b0d3 with SMTP id
 a640c23a62f3a-b903dc90488mr506792566b.37.1771593257275; Fri, 20 Feb 2026
 05:14:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220131002.6269-1-mark@harmstone.com>
In-Reply-To: <20260220131002.6269-1-mark@harmstone.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Feb 2026 13:13:40 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6v41ix4TutYANAQX7tkDmnx3YoYkpfRWaATiDZWB6wwQ@mail.gmail.com>
X-Gm-Features: AaiRm52UtiyNEO794lPn9GgMCCMz22YfZXJ4SOIU_85WB4Ox-oy9332TragoVyk
Message-ID: <CAL3q7H6v41ix4TutYANAQX7tkDmnx3YoYkpfRWaATiDZWB6wwQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix chunk map leak in btrfs_map_block() after btrfs_translate_remap()
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 20, 2026 at 1:10=E2=80=AFPM Mark Harmstone <mark@harmstone.com>=
 wrote:
>
> If the call to btrfs_translate_remap() in btrfs_map_block() returns an
> error code, we were leaking the chunk map. Fix it by jumping to out
> rather than returning directly.
>
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> Fixes: 18ba64992871 ("btrfs: redirect I/O for remapped block groups")
> Suggested-by: Chris Mason <clm@fb.com>

It's a bug fix so this is more a Reported-by rather than a Suggested-by.

Otherwise,

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> Link: https://lore.kernel.org/linux-btrfs/20260125125830.2352988-1-clm@me=
ta.com/
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 83e2834ea273..1bd3464ccdd8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7082,7 +7082,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, =
enum btrfs_map_op op,
>
>                 ret =3D btrfs_translate_remap(fs_info, &new_logical, leng=
th);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>
>                 if (new_logical !=3D logical) {
>                         btrfs_free_chunk_map(map);
> --
> 2.52.0
>
