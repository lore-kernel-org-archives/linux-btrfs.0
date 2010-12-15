From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Wed, 15 Dec 2010 23:49:39 +0100
Message-ID: <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
References: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 15, 2010 at 10:57 PM, Mariusz Kozlowski <mk@lab.zgora.pl> w=
rote:
> If posix_acl_from_xattr() fails we leak memory stored in 'value'.
>
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> ---
> =A0fs/btrfs/acl.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 2222d16..11c9561 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct inode=
 *inode, int type)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (size > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0acl =3D posix_acl_from=
_xattr(value, size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(acl))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v=
alue);

Be careful with the evil { }

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 acl;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_cached_acl(inode, =
type, acl);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
