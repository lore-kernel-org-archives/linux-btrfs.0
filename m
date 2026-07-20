Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2945442378D
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563457; cv=none; b=bXaU8zyYrnjB0gThEutIPcuCVmQxUyVXm1tPV8/84NXPFeRix/OUJJ+78odb6UHUd7EfcNnUiroqVu+Uk6o2PSoP7CA4V9Aivo4+80pWhwmbB3H0H0nVCwUe+Jn8WDVjsB150QxGxtb94JKkKslYk2iNmXC7huH+WyCLQI0XxSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563457; c=relaxed/simple;
	bh=YZmEi6gZo4R7MCtu9Oe6CC/34IabkRvY7Zq8DxCAVnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XimVji/W2KaPQdd2eCrmJggO4iCxIkcsBPeQ48VN7a/eLnoTpl694a6GbXGTmwqV0edrgRZyUIc2Ss9Ie/ruN0xceEaVXhJuJBpSoA5qpfwJnVqiYBIYWDrtarheO4m4cu1eSYCxvcX9kiG/qbqnVUABqnMJ5V0+QLB++/bDFhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gv2z5JBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gv2z5JBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED431F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784563456;
	bh=DCgD3KrQvsa4q5XX53UJqVMe3LeHgHuohLoADGm3Pus=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Gv2z5JBSqA5STuvY3goa+L2nloEXqk2/4pf4GD45WH/pOgRdbBpTbZwnR4ol7Zi9Z
	 yUDEUR6eMEy1uj0cq4P5hnDLPSHor3ZX71StJdpgJpGo+J0kJDuuLU5H/nY3VlQ2gb
	 wKCIYXXFTh+QliF6HhgKx/PDUjhtSrqzUx2LHJvTTAgmEyO0XHk2pn2lvZHKTGXoBU
	 0eivKvLKXE/W+0oJa4bN6eOfsh/2ILfODrkYdF6t9Hplr7ANEuAdM4DWPoftHAnLeI
	 81RQylVgDbcsj35ukTbmb33GxW+RQ/PGFGNMtJnqBPepk9rjKiFRssReiXmRDq07Or
	 q3Ohi/z4ghd6g==
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5bf94664327so3823300e0c.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:04:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YwuYMnZN8R8Ld9HR6NVEUNuSFlAJwI/otxtoIAKa04gKMkziKSj
	0gfIHsQcHx/7NYlfsyLBEpEHBblN6boo5KfUDqH4aR5swUOxLxCXB3b9gPMbWEXDNmdoyuYH3uv
	9jBG8iwdA66X56yP7I3/5vGVlN3LPyZk=
X-Received: by 2002:a05:6122:4895:b0:5ab:26f:49e3 with SMTP id
 71dfb90a1353d-5c1b650ca9dmr3362878e0c.3.1784563455261; Mon, 20 Jul 2026
 09:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709082500.17907-2-sunk67188@gmail.com>
In-Reply-To: <20260709082500.17907-2-sunk67188@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Jul 2026 17:03:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5n5-TJMkFmUCnN5-xoVAcqDc7zNFNGR3ywF7Dx+PRetQ@mail.gmail.com>
X-Gm-Features: AUfX_mx2W2otwGTfV-_5Y46NBSqGXEgN-oSOhKtVCfYRcD9QqSGEnILCkrQYMsU
Message-ID: <CAL3q7H5n5-TJMkFmUCnN5-xoVAcqDc7zNFNGR3ywF7Dx+PRetQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: check if root is readonly when setting posix acl
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Sun YangKai <sunyangkai@fnnas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 9:26=E2=80=AFAM Sun YangKai <sunk67188@gmail.com> wr=
ote:
>
> From: Sun YangKai <sunyangkai@fnnas.com>
>
> For a filesystem which has btrfs read-only property set to true, all
> write operations including acl and xattr should be denied. However,
> acl can still be set even if btrfs ro property is true.
>
> This happens because no function on the set_acl code path checks the root
> is readonly or not. It was checked in btrfs_setxattr_trans() but got
> removed in
> commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrf=
s_setxattr_trans")

This can be split across multiple lines, the only place it shouldn't
be is in the Fixes tag.

>
> That commit didn't check if all the callers properly check the root's
> read-only flag. A previous fix is
> commit b51111271b03("btrfs: check if root is readonly while setting secur=
ity xattr")

Please always leave a space between the commit hash and the opening parenth=
esis.

I've amended that and pushed to for-next on github, thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

>
> Always check if the root is read-only before performing the set acl
> operation.
>
> Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrf=
s_setxattr_trans")
> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
> ---
> Changes to v1:
> - add the missing header file
>
> ---
>  fs/btrfs/acl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index e55b686fe1ab..662cdd1cbdef 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -15,6 +15,7 @@
>  #include "xattr.h"
>  #include "acl.h"
>  #include "misc.h"
> +#include "btrfs_inode.h"
>
>  struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu)
>  {
> @@ -107,6 +108,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct den=
try *dentry,
>         struct inode *inode =3D d_inode(dentry);
>         umode_t old_mode =3D inode->i_mode;
>
> +       if (btrfs_root_readonly(BTRFS_I(inode)->root))
> +               return -EROFS;
> +
>         if (type =3D=3D ACL_TYPE_ACCESS && acl) {
>                 ret =3D posix_acl_update_mode(idmap, inode,
>                                             &inode->i_mode, &acl);
> --
> 2.54.0
>
>
