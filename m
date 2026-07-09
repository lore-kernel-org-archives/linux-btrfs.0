Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7F39903B
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 10:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593867; cv=none; b=bjzWqMDGeo1ftewr0QEX9aE/lqSe55KQ2c59bdtXKJ65rXXEsuL/V7k/pupYFDbiKhIxTZSeFQmvhMsqpuva6IzYFHdLJVl8DSU6alR5n9oSGShHsaiSB5mXR9NMj83Vv5rw3tO69go2NwjwlRogDL+XNYZlNES072zrBh5pHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593867; c=relaxed/simple;
	bh=JXbjgXHwH1D9lha7iIspzK6ZXbOFbz6eTIK1CZVmdoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IEXgrPHlu+sHLeSjT0b3su4U9JKeebuNCHqM9fa+msyKaJTMOdnYsQUYHNPM4jzIiw6Weha2hR0X3u25ip/BszQ8/1YU5mMIFbHCFN3u/DA8jA1ljU6gnKxpy1QhS7b7cXja159zceUzPuCZtnzhBsr4/vPCR1aiI0FzjN9qtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lN+njiMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lN+njiMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2651F00A3D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783593863;
	bh=+qnItNUpIbDwkSvyBTX+tSjurkCx50rjvnSTUILLxJ4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lN+njiMz6wUSxVPgqgO7verLvDmhJOE7DGnWrgSeiR/2cx1dVRBFfIuyNNlKCf5pI
	 7tLm1ZcKbm920TDvEXNNgvVObCMeSjlcBJCRrbbCIVI3MuaIXmkQs7kH5t+yYb02A8
	 CR56qcyzAe+gLRx1Kx3CdYLu3OaCRxJ+Bdr27tVneaz4QptvTwZXBKSrJPvVaqa/6L
	 co1QwahKPwnZJz4lycZ/AdcKTZrYbY8b6UDNjOQHBnElu73taN78CRgoYbRV1/Ww0V
	 rpY3sgRYaxTD0c2xxKSJFdBscsT8X2moBpkmneqRdHkRCXM6LpGeeAH5BovltcGSDe
	 sdsFI0Axdj7ew==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15e592da74so77317766b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 03:44:23 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy1ttvf6G2gqqlkZz5nit/CkgZn5xLYZvGD2Iz23er/dng0c6Hy
	VRWn+Y6cm9NEqHCpFlB58Vqpq76NVzh73ZrBFEyAP0sluK7b3yNcuSQ+XRRMg5bEmrHxWOJ3zaD
	n1fRYNxqZJ6gBkM2NdIMVEO3QgQFc3Zg=
X-Received: by 2002:a17:907:c05:b0:c12:508a:2b49 with SMTP id
 a640c23a62f3a-c15ce06069emr283729366b.33.1783593862376; Thu, 09 Jul 2026
 03:44:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709082500.17907-2-sunk67188@gmail.com>
In-Reply-To: <20260709082500.17907-2-sunk67188@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 9 Jul 2026 11:43:45 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6wxWNKWcXD7u58O4JJ_0z0_XMpAHc6eQfAiBOPNbKkQw@mail.gmail.com>
X-Gm-Features: AVVi8Cf4OVr_R9byzZNAOLTK97BLbwn3XbjMlMnEAaxX5-fiwWFW9dz6F8LqKRU
Message-ID: <CAL3q7H6wxWNKWcXD7u58O4JJ_0z0_XMpAHc6eQfAiBOPNbKkQw@mail.gmail.com>
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
>
> That commit didn't check if all the callers properly check the root's
> read-only flag. A previous fix is
> commit b51111271b03("btrfs: check if root is readonly while setting secur=
ity xattr")
>
> Always check if the root is read-only before performing the set acl
> operation.
>
> Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrf=
s_setxattr_trans")
> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>

Test case please (fstests).

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
