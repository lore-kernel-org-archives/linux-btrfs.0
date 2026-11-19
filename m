Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111293;
	b=0OivI9vPUIFnB628GbRiEFMYOQwmJ0oXMuRqd/yWShL4Shw6ip3RK6Q7vqqKD6nlC3E+
	 ZgBjtQLXVRUs+n7IfSQL2V79lLaM5Y2JnvebYzwt/dW3mcJCth5jWXWxSj2yuj3m+GYYR
	 OsbDU76uJtsU0lHX8ylQ5FklXWDpjmksmhJ6L3+NHma8mbi2+PDk50tEtCrJrRQ9ieNiZ
	 PMmCX9N5zLR437Ce2zig7+uN/tEW/Y4sXeBDO1gCNhGUM0vcHlYw2aMR6KWN9xaVA+VjY
	 2lbkofxWiKE06ameuu8EXsy8F7/6j/a0wtKsMjFVVVUjr29xhuXs/52AKjkhY4WK3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111293;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=8EnvvZQFhm1GnF4YZWKxU0xt1U1d9UYT50bP6pkB9yM=;
	b=NXnWdtRD0rC3L1+8p67v7o+/RU2rC5RGrMqxgT7N1IfHFS5V6ab6iwsjJkkH7LO7jN+J
	 PIdtT73RYIoqVHHYkuX4F1h1dlwE0oS7leZbuM2XObhHXJ2lxBjGNspJ6S9Tr0TESIYn0
	 K6sSuXlZjJuOcgc5P2Fgyh6R4ZM2FguPVranHvV+s9d2grEagsmTd0ixzfZhLzBxT4Cyg
	 +1pHd8BPDl+2et4kv7gQ1ReJdqrByT6ttUPJIq7HKwagT+YlwxalNIDD00B+KNHg31nRY
	 h6AZzU4mZKEH7LZdDATTZgfwaToDSZg/+1dZs3hJsm5oMFvsTp1s9uwEU9X7AwDWj6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cLaW7Nm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B2606A336
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cLaW7Nm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACB71F000CB
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795111292;
	bh=8EnvvZQFhm1GnF4YZWKxU0xt1U1d9UYT50bP6pkB9yM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cLaW7Nm4infpGhBY9fepQ1CaTPhJ3FduNumxhlK7W//JngHpfjspS7R7pFCkjPrcf
	 yHfY10MKjoEHndKUmU9mZPg99OPiUq0CzYgF76QdEWd5UIGGYshLJa2V09o30JUtBl
	 mAxGmCaSlgL0bSxF2lp+xCEcK1McjK7AaaPfG3ijLm/x1UQezE+MpUU5ygf9+Wf8yg
	 S1TwSnTMUw3+wnqUr4Fi8mJFuUzy12U8O3O0UjV3UWdCN27Z/y27PP8CneDjZ3De11
	 T86LdZDHg4molVq4TzksXD67GTXhPFGdBTe8Xt2qNxhL2b/J5ExVFZIzhejbXkePhW
	 ll/8joLNF6/fA==
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5ee029fd76aso1647462e0c.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 10:01:32 -0800 (PST)
X-Gm-Message-State: APuU4Z9vI4MDoN9mKCu5+/cTKbj+XU1PKBZol9wg8E6ekR4CSuzclSrJ
	QktYTKx2uMwdtghE4ZCE7k60nl4A3a8oScE6uu1P3gH0HAztCHRFSJfghsaK/R5JwrKNjct5cW1
	yrz2xcKHUu05WnBsVsDUIEH0tPSNiY6U=
X-Received: by 2002:a05:6122:62e8:b0:5ea:9a2c:27a8 with SMTP id
 71dfb90a1353d-5ee8af7370bmr378599e0c.14.1795111291998; Thu, 19 Nov 2026
 10:01:31 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <a33cb143fe0af0cb689c69b949d954fa151f47cd.1795036063.git.wqu@suse.com>
In-Reply-To: <a33cb143fe0af0cb689c69b949d954fa151f47cd.1795036063.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 19 Nov 2026 18:00:55 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5BUAWgB-Wvco=b1i1LBu07VhBQG9OR19mdrpXw6KON9g@mail.gmail.com>
X-Gm-Features: Aa3M54pHyxEi0qRJaWM37bmZy9x4M56glcCmYwkpYvohixE0m2kZ-H4onZ-sQFs
Message-ID: <CAL3q7H5BUAWgB-Wvco=b1i1LBu07VhBQG9OR19mdrpXw6KON9g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: handle kobject_init_and_add() failure correctly
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Zheng Zheng <fengaojigui88@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 9:08=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a bug report that if error is injected into
> kobject_init_and_add(), later error handling at
> btrfs_sysfs_del_qgroups() will trigger a warning during
> kobject_del(fs_info->qgroups_kobj).
>
> The call trace looks like this:
>
>   btrfs_sysfs_add_qgroups()
>   |-kobject_init_and_add()
>   | \-kobject_add_varg()
>   |   \-kobject_add_internal()
>   |     \-create_dir()
>   |       \-sysfs_create_dir_ns()
>   |         Fails with -ENOMEM with error injection
>   |         kobj->sd stays NULL
>   |
>   \-out: btrfs_sysfs_del_qgroups()
>     \-kobject_del()
>       \-__kobject_del()
>         \-sysfs_remove_groups()
>           \-sysfs_remove_group()
>             |-kn =3D parent
>             | Which is kobj->sd, and it's still NULL
>             |
>             \-remove_files(kn, ..)
>               \-kernfs_remove_by_name_ns(parent, ...)
>                 Trigger the warning as @parent is NULL.
>
> Fix it by handle the kobject_init_add_add() error manually by kobject_put=
(),
> without relying on btrfs_sysfs_del_qgroups().
>
> Reported-by: Zheng Zheng <fengaojigui88@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAO-4RZ1DiPS2+=3D3WPxRGSEajO=3D=
dnsfYi4zDyjcVp3LBy2670AQ@mail.gmail.com/
> Fixes: ed2e35d85d61 ("btrfs: sysfs: introduce global qgroup attribute gro=
up")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/sysfs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 89b0a4ef4063..f87f828aff99 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -2487,8 +2487,16 @@ int btrfs_sysfs_add_qgroups(struct btrfs_fs_info *=
fs_info)
>
>         ret =3D kobject_init_and_add(fs_info->qgroups_kobj, &qgroups_ktyp=
e,
>                                    fsid_kobj, "qgroups");
> -       if (ret < 0)
> -               goto out;
> +       if (ret < 0) {
> +               /*
> +                * The kobject is not added into sysfs, so we can only fr=
ee it
> +                * manually. kobject_del() from btrfs_del_qgroups() will
> +                * trigger a warning.
> +                */
> +               kobject_put(fs_info->qgroups_kobj);
> +               fs_info->qgroups_kobj =3D NULL;
> +               return ret;
> +       }
>
>         rbtree_postorder_for_each_entry_safe(qgroup, next,
>                                              &fs_info->qgroup_tree, node)=
 {
> --
> 2.56.0
>
>
