Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1629335BDAA
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426836; cv=none; b=JAo3S3aV3ply9tcWCzAqlS8mJnDUr7edXN3K0aBj42voaAIydzLNnqRrYTpm3FRs9W8DX1TnruWkPMq/jAP1NWA/0ykWWjU147QRWFH+GmIDWkV9Fa/R9yG0ExrsH+mISU79+PnqAyANMK7gl+hjmQhYqEHtQ0vdk82M9zek/eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426836; c=relaxed/simple;
	bh=p98wj3us8rZ/SbCuLpKv4eOjg9dOclzuU1zAQpPgYFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qsMvjam9whBit/sUe7I7cqn6pvqF5FPTouldPIHDTmE9WeAwX1aFciK6ugGlKM9Fj7YfHNoK2VBc93gWdinfg1ldb49rl/H4Ba3j0MpKdBEfqkNfJ+Lj1v5Kpi2lxCE2+aEmK8c74bYtHKyusQbkBd7816+bMdymT1/Gtt+BzGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4YxQXn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4YxQXn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD83D1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785426834;
	bh=rqeniC/nD+N2D7DQ1NXqKVsnh3fwapmmutlwmbI1l6U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I4YxQXn3P3xWOAaSf1Pug32daBeP7Ct7zjE/uedY41xZpCPo8omEgaKfE5cCMTJNW
	 BLydryc2KJew5RuxXDDa+3JI4DCkbfcyEKDFipzDLDiXQOGuw8w1qvG6qmEXOlhXo3
	 mojWYfSfRfHCxR03/G7FyPRyZcVOYcouoNxU0GT6UB3IOKGDOI2xijzmswn0P7Y7AK
	 m+4WXsGzqdm2exK5LK8A3iZBcLgT7itlcEsxeMW6JV5SqPdslw+3loIqvflmnXp0iX
	 2bsN88HUHCojwFlgR/z6nYsgr0LElIt6mHP+v1tNZcSGLYta0QWd6QcPuJcxJP6bhN
	 bDtUJrmWc/0yg==
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-74aa416ebb1so703288137.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 08:53:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YyPw38joGt1ZpVvifV9bypJEp9VLkHprkVVDgz1QKMVMVWCRN/A
	jPnjfFYbl/qvYil1d1utmVz3c/00XLb+B/MKrhg2AB9bKOkzhXHpwst5/vZfcssTanZ6XlAzlKo
	3cNx8bLbELrs74HoFtsPFXo/7BDrlfyM=
X-Received: by 2002:a05:6102:374f:b0:738:9c30:2bab with SMTP id
 ada2fe7eead31-7574fc60dc0mr955967137.24.1785426834033; Thu, 30 Jul 2026
 08:53:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7a79cac71ca43f63cdcf21ee9bba95be05f16230.1785395252.git.wqu@suse.com>
In-Reply-To: <7a79cac71ca43f63cdcf21ee9bba95be05f16230.1785395252.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 30 Jul 2026 16:53:17 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5tyWwfh79Zmk0ZYkrG=EJ=SFAUbw03os1mu+GO9c8Jnw@mail.gmail.com>
X-Gm-Features: AUfX_mzMapdaVVuCJEPweSNlkbPCQtVhuLS8bAiyzBMQFBgwW0fIG8lwZgAivIg
Message-ID: <CAL3q7H5tyWwfh79Zmk0ZYkrG=EJ=SFAUbw03os1mu+GO9c8Jnw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: disable bs > ps support if no transparent hugepage support
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 8:22=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Btrfs relies one mapping_set_folio_order_range() to set the minimal

one -> on

> folio order for all its data inodes, but that function will be nop if
> transparent hugepage is not enabled.
>
> Guard the bs > ps support behind CONFIG_TRANSPARENT_HUGEPAGE, just like
> all other filesystems.
>
> Fixes: 98077f7f2180 ("btrfs: enable experimental bs > ps support")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/Kconfig | 3 ++-
>  fs/btrfs/fs.c    | 6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 9de04c37e11a..4b10d78ed99b 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -106,7 +106,8 @@ config BTRFS_EXPERIMENTAL
>
>           - extent tree v2 - complex rework of extent tracking
>
> -         - block size > page size support
> +         - block size > page size support - needs transparent huge page =
and
> +                                            non-HIGHMEM system
>
>           - huge folios for data - folios can be as large as 2MiB now
>
> diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
> index 5015d0148841..77544ee5e6db 100644
> --- a/fs/btrfs/fs.c
> +++ b/fs/btrfs/fs.c
> @@ -155,8 +155,12 @@ bool __attribute_const__ btrfs_supported_blocksize(u=
32 blocksize)
>          *
>          * Considering HIGHMEM is such a pain to deal with and it's going
>          * to be deprecated eventually, just reject HIGHMEM && bs > ps ca=
ses.
> +        *
> +        * Finally, for bs > ps cases, we need to set the minimal folio o=
rder,
> +        * which requires transparent hugepage.
>          */
> -       if (IS_ENABLED(CONFIG_HIGHMEM) && blocksize > PAGE_SIZE)
> +       if (blocksize > PAGE_SIZE &&
> +           (IS_ENABLED(CONFIG_HIGHMEM) || !IS_ENABLED(CONFIG_TRANSPARENT=
_HUGEPAGE)))

This is quite hard to read now. How about something much easier to read lik=
e:

if (blocksize > PAGE_SIZE) {
    if (IS_ENABLED(CONFIG_HIGHMEM))
          return false;

   if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
         return false;
}

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>                 return false;
>         return true;
>  #endif
> --
> 2.54.0
>
>
