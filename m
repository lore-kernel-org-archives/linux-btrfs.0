Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB73563DD
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561102; cv=none; b=na0ky3j9HbZY0dFc+JkPJ/SsHIoe5T1nP2HoR5dpsoF9Pa/HR+OIWD5jrtqlG9yRDEkIOPTdjeERCwWREFi4wDdWICKpF/QJVdhlrzr+pSnklTQwevwxztJDcjKRx+b+3XVR7ALRqNL8t0Ygm5WGyQ/2O6xVEr38cABBD1BH2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561102; c=relaxed/simple;
	bh=BV7kFxcGZiViEWUesU+tUbEDhNUoIbBaF+lH3Bl70f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1LsA+UHKQCWNzpwybZ/mkKoW/MLuT9LlL4G32bnF4tOfC8PIfhuLfUGMiUs/KUJ82RdnRvaOCFzzWC1TGP4vrPAWBb2QuVk7wCP47ztfSw6yn4d/3CP+zsc0YOpv1IdVMSKJMvCgLX32uuArYsrv5G3/QknpgO0ZS0A537WxG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9fcy2+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9fcy2+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA83C116C6
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561102;
	bh=BV7kFxcGZiViEWUesU+tUbEDhNUoIbBaF+lH3Bl70f0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k9fcy2+AHCpRWh7ATs51JAe833pX+rP8rmgQLD3TWlGXDMq11+e+8A7YvaAImpQwY
	 nFJm0bzIs+dOoZyL28gEMqexZh1Gv4HvusuvjONA65vWcTbea82CIb5x9S1VJbpD1q
	 jbqKn0f5bigc6cru+PzG0YwNChFJSxkLQTe7iS8+XhOi2A3ZgvY1CzckFsL3XgQKt1
	 v2fn+cSfA7u/BDo65OkPqaCs8jn1xvvwkSY3ZMNA9J3GI+0v2kxQ7uiY9alEy5hyKz
	 ooj32FwBAJTsjj+EKu/m3cgmZM45Y+4d7l1kyLDw0jhjJc19p95DflRT0nEcKEfZJD
	 CMhCmu5AK9Wgw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b886fc047d5so747537266b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 04:25:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHOaJbamfQwJFhppnLMPK9uYPY4pO5J//IKIJtjuC9abrgbHKb/7CHCs2gE/T+CtgA6aJ7Qww+U4P7Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwrYwylRhcFvhpWV9jchadjt8ye4ZQHc9q5H+rS3+VFUm0o0btq
	BKD5kAraFoN0gM8JXGYxoqjTA9BAP1C7h+rsEILwBi456zVPmPmr0npuArRMbY6bCBRt5we8iZT
	UF9tHEQZHv4BiLBXdEQf8tfTbAdnkKbQ=
X-Received: by 2002:a17:907:e106:b0:b83:95c8:15d0 with SMTP id
 a640c23a62f3a-b9c67b52acbmr563215266b.52.1775561101029; Tue, 07 Apr 2026
 04:25:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402064348.2807138-1-davechen@synology.com> <20260407033624.1218932-1-davechen@synology.com>
In-Reply-To: <20260407033624.1218932-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 7 Apr 2026 12:24:23 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5KZyvP+xr8ivTJZ218v6ekfxQf7M46d_wOn5PJtbYTTQ@mail.gmail.com>
X-Gm-Features: AQROBzAc-uooNkuIYK5-xBRun9467xNIzokzxgWfWrqggcf0tNBdUQWAaikY3bg
Message-ID: <CAL3q7H5KZyvP+xr8ivTJZ218v6ekfxQf7M46d_wOn5PJtbYTTQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: use BTRFS_FS_UPDATE_UUID_TREE_GEN flag for UUID
 tree rescan check
To: Dave Chen <davechen@synology.com>
Cc: cccheng@synology.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	robbieko@synology.com, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 4:36=E2=80=AFAM Dave Chen <davechen@synology.com> wr=
ote:
>
> The UUID tree rescan check in open_ctree() compares
> fs_info->generation with the superblock's uuid_tree_generation.
> This comparison is not reliable because fs_info->generation is
> bumped at transaction start time in join_transaction(), while
> uuid_tree_generation is only updated at commit time via
> update_super_roots().
>
> Between the early BTRFS_FS_UPDATE_UUID_TREE_GEN flag check and the
> late rescan decision, mount operations such as file orphan cleanup
> from an unclean shutdown start transactions without committing
> them. This advances fs_info->generation past uuid_tree_generation
> and produces a false-positive mismatch.
>
> Use the BTRFS_FS_UPDATE_UUID_TREE_GEN flag directly instead. The
> flag was already set earlier in open_ctree() when the generations
> were known to match, and accurately represents "UUID tree is up to
> date" without being affected by subsequent transaction starts.
>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Dave Chen <davechen@synology.com>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
> v2:
> - Drop Fixes tag, no benchmark numbers to justify it (Filipe)
> - Reword subject and commit message as a correctness improvement

Pushed to the for-next github branch, thanks.

>
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
