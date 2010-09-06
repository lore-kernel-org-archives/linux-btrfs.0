From: Andre Nogueira <andre.neo.net@gmail.com>
Subject: Re: [PATCH] Function btree_get_extent: Incorrect if-else if statement
Date: Mon, 6 Sep 2010 14:51:11 +0100
Message-ID: <AANLkTi=fTMp+PthyKam-QHmJYfTC68LBEU_XKWhah4-O@mail.gmail.com>
References: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I sent this patch weeks ago. I would like to have some feedback about i=
t.

Thanks in advance.

2010/8/9 Andr=E9 Nogueira <andre.neo.net@gmail.com>:
> The btree_get_extent function (in file disk-io.c) calls the
> add_extent_mapping (in file extent_map.c). The add_extent_mapping
> function can return two values: 0 or -EEXIST.
>
> After the call, it is used an if-else if statement. If the result is
> -EEXIST, the if statement is executed. If the result is 0, the else i=
f
> statement will not be executed because it is false.
>
> Thank you.
>
> Signed-off-by: Andre Nogueira <andre.neo.net@gmail.com>
>
> ---
> =A0fs/btrfs/disk-io.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 34f7c37..76eb161 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -164,7 +164,7 @@ static struct extent_map *btree_get_extent(struct
> inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failed_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 } else if (ret) {
> + =A0 =A0 =A0 } else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free_extent_map(em);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0em =3D NULL;
> =A0 =A0 =A0 =A0}
> --
> 1.6.3.3
>



--=20
Andr=E9 Nogueira
http://sites.google.com/site/andrenogueirasite/
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
