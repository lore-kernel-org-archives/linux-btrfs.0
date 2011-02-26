From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix infinite loop in btrfs_shrink_device()
Date: Sat, 26 Feb 2011 10:05:40 +0800
Message-ID: <AANLkTik1J7q10fLp1js29_ge0HT0-=Bg9VOj6zYN-svW@mail.gmail.com>
References: <20110225234310.GA2567@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110225234310.GA2567@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 26, 2011 at 7:43 AM, Ilya Dryomov <idryomov@gmail.com> wrot=
e:
> In case of an ENOSPC error from btrfs_relocate_chunk() (line 2202) wh=
ile
> relocating a block group with offset 0 we end up endlessly looping.
> This happens because key.offset -=3D 1 statement then unconditionally
> brings us back to the beginnig of the loop (key.offset =3D=3D (u64)-1=
).
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
> =A0fs/btrfs/volumes.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dd13eb8..0cb94ce 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2212,7 +2212,8 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto done;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret =3D=3D -ENOSPC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key.offset -=3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (--key.offset =3D=3D -1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0}

it should be  if (--key.offset =3D=3D (u64) -1)

>
> =A0 =A0 =A0 =A0if (failed && !retried) {
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
