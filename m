Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA30D33439A
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771351909; cv=none; b=fpHvG8dESztWE/UJpGz18Pb0Rb9nPpbL0GTDKt810wpomkir9P+VLs+yfIIeZTWM+PCJPrKSdpOjAvOovJXgb1MC4m4jqI6NR0kr+JFL0qQwXjnmy7kN3tJEAWXDTM95tkyF8ErzlC/+kUe7KUu+peaBWFpYiyK3VEvDfmaaK1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771351909; c=relaxed/simple;
	bh=as76waPOyXCkLc6XwoOiG2UmuHSESRee6XfdHM9ZUVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COgx9CXmMJpV947k6EFZdn483ShDmAhG+APnNVmsB7rQguVthVAvKyj9z4i2BiV8tFttwpuMiBoo181nm2MWyIQMGqC5N+kPdreEnB7FeUb9PqT2YHgcUgM1Z9mjswrIZEhYhIMYApRkRE2PzxXRmA0RilplND73DNxhhIWYeso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NC1HK1KH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC1HK1KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBDCC2BC86
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771351909;
	bh=as76waPOyXCkLc6XwoOiG2UmuHSESRee6XfdHM9ZUVU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NC1HK1KHWfZsFB7gqUah6ZN7DVUTJbA9ZIre686LA8tC+3A32V5l24aRxBS+pk/lK
	 +tGAYum7uqEHcMzeJI/n0MNgTVDbQu5HxaCAYplorc1Z5vA24AEMsNksRdXMxHLdXE
	 2UeCMrieXrlgkTnermWU2XkHST0xu4+OGEiNMU73EWb6v7YQdVsACneuEujtNSzwX8
	 bckAKZKWmYhthYQ1zStTepSug8V+IZirPomHnYJKTevHhboEobte7h9cotRWcKN3Xb
	 WD9MmNKCeWlGaTfqzqicDC7pEjrCcNcKSOQ5Y/d02H9V3zpmsfqosvstEdJA/YRbIg
	 TYfg0lJxioKeA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65a1970b912so138955a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 10:11:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNrfqm1uQsjDUdP83/jk0LuHvt4haSg9TKvNNQLtc4GvSdxDRwsmXqrVuyDqoH6v0zEtguHsjt+8Fa4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJnZAVdHRsALFWeG2dftNIu3iNKcQ4qyC39dZU3nNBsCs18K+A
	00zQ+BVA2uB50OGDSTumFI2OAN4sWcS709rzvQt/F9757kgdLo1MdpR/QyJDaVbInfifi49ZR2V
	7poGthfV+I4bh14Ol+K6in9DVziJgVg8=
X-Received: by 2002:a17:907:6d22:b0:b84:3fab:4251 with SMTP id
 a640c23a62f3a-b8fc0662227mr852170866b.15.1771351907959; Tue, 17 Feb 2026
 10:11:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260216002252.3831277-1-mssola@mssola.com>
In-Reply-To: <20260216002252.3831277-1-mssola@mssola.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Feb 2026 18:11:10 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7ezZL_HMsa2SthbPg-muM85Jc7OwiD2nh7-w0XOXH3tw@mail.gmail.com>
X-Gm-Features: AZwV_QjsBP83haKB_S8MNbFy2Q-wnRUR-ckDij7MBFW-0b1YtJrnjbtr-DZZtAg
Message-ID: <CAL3q7H7ezZL_HMsa2SthbPg-muM85Jc7OwiD2nh7-w0XOXH3tw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't commit the super block when unmounting a
 shutdown filesystem
To: =?UTF-8?B?TWlxdWVsIFNhYmF0w6kgU29sw6A=?= <mssola@mssola.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2026 at 12:23=E2=80=AFAM Miquel Sabat=C3=A9 Sol=C3=A0 <msso=
la@mssola.com> wrote:
>
> When unmounting a filesystem we will try, among many other things, to
> commit the super block. On a filesystem that was shutdown, though, this
> will always fail with -EROFS as writes are forbidden on this context;
> and an error will be reported.
>
> Don't commit the super block on this situation, which should be fine as
> the filesystem is frozen before shutdown and, therefore, it should be at
> a consistent state.
>
> Signed-off-by: Miquel Sabat=C3=A9 Sol=C3=A0 <mssola@mssola.com>
> ---
>  fs/btrfs/disk-io.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 600287ac8eb7..cd2ce6348d88 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4380,9 +4380,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_i=
nfo)
>                  */
>                 btrfs_flush_workqueue(fs_info->delayed_workers);
>
> -               ret =3D btrfs_commit_super(fs_info);
> -               if (ret)
> -                       btrfs_err(fs_info, "commit super ret %d", ret);
> +               /*
> +                * If the filesystem is shutdown, then an attempt to comm=
it the
> +                * super block (or any write) will just fail. Since we fr=
eeze
> +                * the filesystem before shutting it down, the filesystem=
 should
> +                * be in a consistent state and not committing the super =
block
> +                * should be fine.

Looks good to me, but I'll rephrase this with:

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cd2ce6348d88..84829f5e97a8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4383,9 +4383,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info=
)
                /*
                 * If the filesystem is shutdown, then an attempt to commit=
 the
                 * super block (or any write) will just fail. Since we free=
ze
-                * the filesystem before shutting it down, the filesystem s=
hould
-                * be in a consistent state and not committing the super bl=
ock
-                * should be fine.
+                * the filesystem before shutting it down, the filesystem i=
s in
+                * a consistent state and we don't need to commit super blo=
cks.
                 */

The way it's phrased gives the reader an idea that we are not sure
about what we are doing, which sounds bad.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to the github for-next branch, thanks.

> +                */
> +               if (!btrfs_is_shutdown(fs_info)) {
> +                       ret =3D btrfs_commit_super(fs_info);
> +                       if (ret)
> +                               btrfs_err(fs_info, "commit super ret %d",=
 ret);
> +               }
>         }
>
>         kthread_stop(fs_info->transaction_kthread);
> --
> 2.53.0
>
>
