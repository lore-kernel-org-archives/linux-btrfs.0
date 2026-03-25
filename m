Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B94C323417
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462984; cv=none; b=OgDO/MPyzC123vYT8z5zMZ/BziBIJ3uaov6PRIThjTKpP0ceIXy4kZ2wqYDMfqxWcTHkbV+aL4ouTLncjd6Tb5+njWaOxpz7soCPjMIGdfSdVqknqTUvigeAucq7OtTDLhrGnNNdpKNZGrhtTKElFgOWaK+mIRNDotcI0e/XwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462984; c=relaxed/simple;
	bh=3ikzGm5rdjR98uwGDXeNtc5L0xRQauCuS5xjjT6JdP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FytNsJ8KuqvrKA1pt8jTtJO05ABj8PO8XOnx64IRCA5WH57/10SS77SM5N5+NlnXUqHHlcsygdT5rmw0PX5GUEgnnbJXUUbbKzI3gZIWhVsdVtToXC3bbbJaTx7AHf7HNjlrsMZsi/Kgyj4TTK9LRCPLA8s5jWPYMI3f5SaPClk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLA5dp0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLA5dp0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FEC2BCB1
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774462983;
	bh=3ikzGm5rdjR98uwGDXeNtc5L0xRQauCuS5xjjT6JdP4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hLA5dp0bjeiGh4i2FlMqf7DdJ+mceNZiOMjkm/0+wuACp7YLkr+x8uHXZxfsWtq8O
	 MbdkQ4QHLF6bxIpDYbT9QcMzNaZFD89Up3L3Fy7NlM6m40FjattS6I+Sw61S5JSXM2
	 vzRkq+NpdFSMY8H8Di13GHIdAU1ERzn8MQ4T2kbGJbyw/ix11A5qn7H4IwCBpQmj/h
	 JQRM91gJrkaBodQXqEWdglmWDOtEpcsKWYhoQ9ORWlXSoLlPT0cpbPSz1CbCPPZtzK
	 rN2MwHimtQ9iBrWq/F34ds+xcaiZa9XjcQP76vCDGTmvqgVnTuBLVzml2Z5J6gjdU+
	 yYqRSYEAXHqjw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b976536806cso19817366b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 11:23:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXRS0yeDyPTXNgc/kMmiw8oqBOJuWrltl+3MoRjsOlADb6NnPGGcl5Ugg33cLM0CB8GvKj9Rm1h92YQzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBhpi50pT4uwlXbLVhOv40X89nTpiw2UlK4GQyXEcQ3plPo0Fu
	w19EnY6MZGBq9E2ALqhk7vadTPZKO/oSunWdIEWcx2wXVCfJDz7yyxjcGCuoU/p+05wmEPv1TtF
	xd7tBVeZy5bsZOVC6tQbFSt7DnyS6kIM=
X-Received: by 2002:a17:906:a2d8:b0:b98:4c58:f499 with SMTP id
 a640c23a62f3a-b9a54253a96mr245867566b.28.1774462982274; Wed, 25 Mar 2026
 11:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260325101818.3474340-1-robbieko@synology.com>
In-Reply-To: <20260325101818.3474340-1-robbieko@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Mar 2026 18:22:25 +0000
X-Gmail-Original-Message-ID: <CAL3q7H71wE3L14DHYUZ+2cAK-GSd3aU5iY4qypXAdfNNyf9_WA@mail.gmail.com>
X-Gm-Features: AQROBzCCxKCSR8Kis4L9JLk4IdckGPvOJ5t5U9o__ilBgr5ixJ_zJhwBE2BGJwM
Message-ID: <CAL3q7H71wE3L14DHYUZ+2cAK-GSd3aU5iY4qypXAdfNNyf9_WA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix incorrect return value after crossing leaf
 boundary in lookup_extent_data_ref
To: robbieko <robbieko@synology.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 10:28=E2=80=AFAM robbieko <robbieko@synology.com> w=
rote:
>
> After commit 1618aa3c2e01 ("btrfs: simplify return variables in
> lookup_extent_data_ref()"), the err and ret variables were merged into
> a single ret variable. However, when btrfs_next_leaf() returns 0
> (success), ret is overwritten from -ENOENT to 0. If the first key in
> the next leaf does not match (different objectid or type), the function
> returns 0 instead of -ENOENT, making the caller believe the lookup
> succeeded when it did not. This can lead to operations on the wrong
> extent tree item, potentially causing extent tree corruption.
>
> Fix this by returning -ENOENT directly when the key does not match,
> instead of relying on the ret variable.
>
> Fixes: 1618aa3c2e01 ("btrfs: simplify return variables in lookup_extent_d=
ata_ref()")
> Signed-off-by: robbieko <robbieko@synology.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 85ee5c79759d..098e64106d02 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -495,7 +495,7 @@ static noinline int lookup_extent_data_ref(struct btr=
fs_trans_handle *trans,
>                 btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
>                 if (key.objectid !=3D bytenr ||
>                     key.type !=3D BTRFS_EXTENT_DATA_REF_KEY)
> -                       return ret;
> +                       return -ENOENT;
>
>                 ref =3D btrfs_item_ptr(leaf, path->slots[0],
>                                      struct btrfs_extent_data_ref);
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
