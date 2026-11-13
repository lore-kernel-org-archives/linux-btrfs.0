Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794593208;
	b=sduMRlZ5j22RuFAGNJXxBQQraj19BPac2Wqs9PopAb22yzX9kSvtmyKNRjib7isG8HOJ
	 GzZ8aK4ztuVMiTBd0rLI347NRo44qM3kGWh9dPEivzSnHdVSSprNXBfhy5zp+GDJ86BO0
	 tnkRktjTQ/AK6XeiQfSKsFiT2U9C0tijQkcMSPD+7ToRUPKXLKMoX3KhdmGyqgzAfnvv3
	 u8+ond0G7veIKa4iAz0Zz7IxJjZbq2yCK4uWTWD6UDg1vMbiYZnM6zC7RmG29/vsF9lYP
	 9qcRuDbwMJxLGJLRVUjELsHj6OW3eLaZlPiASqgWBVTuvBlDtn00htspZPPo7gQ0HLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794593208;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=UM/WxEIObsYRlERLVGpCK4nWDOmls3sraT1jqUYlJoU=;
	b=aXhce1E12jINKnbY3vAEXslxIUDAVvTbEMwefTj9pobDp43RMFIQ5o+TbQheMYM/nyT7
	 8BSQw8UJ43GrPyBjQ1ePrXe65s7uRvtKumw2y35BxSJp3+xVhsy5G5R9nP2NQrtQIn/Nr
	 SyqV9hiltiE7u9B9WcXlFKHbUHYrPFtblipL8KmqgPPpyNaUN8AUjFihZSu4W/4fLVr2P
	 BlmQezRHgGHoi3xygzMjfLeUXMW+X1WqcjZJJUnW1f4VktY0aD3JiiMiZ5pAtW4mzxNMZ
	 Hlowp+d5rWl6uolaA6bP1M6xTNnjjledd5KCjbfnrNRihgXlDSR2NNC7euYczZIK5Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATm2CLss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC62606A327
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATm2CLss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7628B1F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794593208;
	bh=UM/WxEIObsYRlERLVGpCK4nWDOmls3sraT1jqUYlJoU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ATm2CLssNR4SJFu0Y3dl+iyhkyc/S9M+BCGn3aCcN+1zTGWYgavTd7xwZb8Qgb5Ej
	 lFbLNhb48uoVHeTymQ7745wt2CYzut8aSZwS5aSpzH/kUt1I/wd8X23LyOGa4pONEc
	 kz+TrU19wLjr0toZgaPvkH8bqFqji4opaQObC+4+k6ffmWbF+Cx4S/uWeV/rngkh+5
	 rThM5c2TeI6Lki9Jquj47BAzuRAd2Fx9bhMcNaRzlZsgRpM0yBn8vuO/vYfzGSuLgi
	 OFeMk9euZem5BHwZ0kV08/Qqt+2qlyRfOUcbtWG/lg5XqibeOQatrh+d22mdGo58Yw
	 s6BRBb7+mw/7A==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5ed2f163a2fso394538e0c.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 10:06:48 -0800 (PST)
X-Gm-Message-State: APuU4Z/cnLz1Vfkmde03rQDCBEBarvr8QQ97pZcwLeAsn6JWZI239Oti
	trf5NkpgvNzxI7oJO/LfzLaJnDnytrFKNS4n8cJC0JuJYkn7Y50/xOjMwbRMxapV2M6jlA0n1ii
	Rj/kcoJIdICv0D0r1Svg2J7GGDjzoPlA=
X-Received: by 2002:a05:6122:4d18:b0:5ea:e188:a5af with SMTP id
 71dfb90a1353d-5ee34a5afe2mr1306983e0c.11.1794593207670; Fri, 13 Nov 2026
 10:06:47 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <ceaf35a5b7815d33480da620b5b5efe8cd028c70.1794549014.git.wqu@suse.com>
In-Reply-To: <ceaf35a5b7815d33480da620b5b5efe8cd028c70.1794549014.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 18:06:11 +0000
X-Gmail-Original-Message-ID: <CAL3q7H61rdWdy2Cjx9zEJJECWQg5sF4im9bkKwihZP8+wmSDVw@mail.gmail.com>
X-Gm-Features: AclHuK-Kop4DUnOJvqlKyZXAVDJcGusiqPKzeZe5qgjvlRz3zpz0vqAljMPEm0w
Message-ID: <CAL3q7H61rdWdy2Cjx9zEJJECWQg5sF4im9bkKwihZP8+wmSDVw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: handle errors of btrfs_next_leaf() in create_remap_tree_entries()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 12:04=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> In create_remap_tree_entries(), if the btrfs_next_leaf() returned an
> error, it only breaks the loop iterating the free space tree.
>
> Later we call "ret =3D add_remap_tree_entries();", which will overwrite
> the existing error code, silently hide the error.
>
> Fix it by adding a "if (ret < 0) goto out;" check after the free space
> tree iteration is finished, so the error can be caught and abort the
> transaction.
>
> Fixes: b56f35560b82 ("btrfs: handle setting up relocation of block group =
with remap-tree")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-93f4c09d-07d1-4919-b201-2d46f70adf3=
d
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
> Changelog:
> v2:
> - Goto out label after unlocking free_space_lock
>   Pointed out by Sashiko
> ---
>  fs/btrfs/relocation.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 94eda599b97b..934bb264cfbf 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4663,6 +4663,9 @@ static int create_remap_tree_entries(struct btrfs_t=
rans_handle *trans,
>         btrfs_release_path(path);
>
>         mutex_unlock(&bg->free_space_lock);
> +       if (ret < 0)
> +               goto out;
> +
>
>         max_entries =3D extent_count + 2;
>         entries =3D kmalloc_objs(*entries, max_entries, GFP_NOFS);
> --
> 2.56.0
>
>
