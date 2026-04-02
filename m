Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970973EF0DD
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775142095; cv=none; b=Jzv0hFx1Vd2y0Y4m2dokMFonXY3wupQmrfSflFzXLI1szPorVmv31umRNx3qs0BNu6D1L3TL+dt4i4kzF66gKyqUDj6VaaJtz5pSMtGvlqXqZVdre0fLAu9IbEAlPL9BNTugvI/8EOrfs6QPvoEt0hmbwl4VC0zU7yqdK47hpTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775142095; c=relaxed/simple;
	bh=fgHyewvAJs5Z9E9Cw2r+c5hWlt9lazwquZfoSn6WqXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KnPlEvPmGG4+JBoypj7jd74xB1uCUhV/3QReLB/pjRkEytdjfmfcpyUKaM05up4sX9DMI9KQ4Lr2sYhV0q5vMaDYlBXLcB80580XwC684D26JKccTzgYOxo4cI+RL5zVeL/l1onq68RLYYOHuYJnBnmD8gJZoQaWtD95l+nXu28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbaNM7zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbaNM7zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E6DC2BCAF
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775142095;
	bh=fgHyewvAJs5Z9E9Cw2r+c5hWlt9lazwquZfoSn6WqXI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YbaNM7zFQFeDS91JFMf9qlp3WH0NhsUkXoiAkRNirICyHLfvgfKE9f3CIk5C+aFtF
	 jX+DPvY8dX152yFjuI9T/EVo19+AU+6/448llRb4aWyaQQFrY0zIgozi2H0QKATvsy
	 rsn81ntkOhOm6LvqbYUEwTcZyAODynGeZOqYCbALS3zYZncTTL/h2KQiVAJwQHqT5a
	 3bJ8EGfmoL10t4XGs82p4L7c34eRlau/dQzJwGmZJV16S1P3qyhINYwCtexKZNEiAv
	 LoXqhu2xWcOBYf6sLqROluKXDX+fzlN7K6ByAFgsvMP1s+N/te2OrGtDxIAZk3tZQI
	 euWCsRgaZkq6g==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-66bb4d4fcb4so1759107a12.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2026 08:01:35 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw9bn9C1zJd31rpT4O+EbKszIH6fnx0p5H562Qs725z4+ZEKzwL
	88lOEvq0LawgFmIDuMbrz+5B5lBt9HMjMjpMeTA0+zBD8rAOnt297lV2ay/U9FJsdigaaF48adW
	u7HvfJPPYcb8y4U5ZDWHtwOt5XY6M0/I=
X-Received: by 2002:a17:907:c789:b0:b83:95c8:15d0 with SMTP id
 a640c23a62f3a-b9c13cc8ddfmr503840066b.52.1775142093553; Thu, 02 Apr 2026
 08:01:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402064348.2807138-1-davechen@synology.com>
In-Reply-To: <20260402064348.2807138-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 2 Apr 2026 16:00:56 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4FMJxNtgsNcVGiETuPSQeiJhEy0KXeC7xRxdUT6h1NLA@mail.gmail.com>
X-Gm-Features: AQROBzDS3aujEZ24lfIoTDOkCQ5R3lzqGQpY6FG_J_AU0KMVUSLkPU0UayN4ckY
Message-ID: <CAL3q7H4FMJxNtgsNcVGiETuPSQeiJhEy0KXeC7xRxdUT6h1NLA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix unnecessary UUID tree rescan on mount
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com, 
	robbieko@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 2, 2026 at 7:54=E2=80=AFAM Dave Chen <davechen@synology.com> wr=
ote:
>
> The UUID tree rescan check in open_ctree() compares
> fs_info->generation with the superblock's uuid_tree_generation.
> This comparison can produce false positives because
> fs_info->generation is bumped at transaction start time in
> join_transaction(), while uuid_tree_generation is only updated at
> commit time via update_super_roots().
>
> Between the early BTRFS_FS_UPDATE_UUID_TREE_GEN flag check and the
> late rescan decision, mount operations such as orphan cleanup start
> transactions without committing them. This advances
> fs_info->generation past uuid_tree_generation, triggering an
> unnecessary full UUID tree rescan on every mount that recovers
> file orphans from an unclean shutdown.
>
> Fix this by using the BTRFS_FS_UPDATE_UUID_TREE_GEN flag directly,
> which was already set earlier when the generations were known to
> match, and is not invalidated by subsequent transaction starts.
>
> Fixes: 70f80175472 ("Btrfs: check UUID tree during mount if required")

Normally we only use the Fixes tag for functional bugs and performance
regressions that cause usability problems.

How much slowdown did you see because of the unnecessary rescan?
For this to make any significant difference we would probably need
several thousand subvolumes or snapshots.

The change looks good to me; however, thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> Signed-off-by: Dave Chen <davechen@synology.com>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1b0eb246b7147..70357b12508d0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3674,7 +3674,7 @@ int __cold open_ctree(struct super_block *sb, struc=
t btrfs_fs_devices *fs_device
>
>         if (fs_info->uuid_root &&
>             (btrfs_test_opt(fs_info, RESCAN_UUID_TREE) ||
> -            fs_info->generation !=3D btrfs_super_uuid_tree_generation(di=
sk_super))) {
> +            !test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))) =
{
>                 btrfs_info(fs_info, "checking UUID tree");
>                 ret =3D btrfs_check_uuid_tree(fs_info);
>                 if (ret) {
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
