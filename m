From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: [PATCH] Btrfs: fix arithmetic error in clone ioctl
Date: Wed, 26 Aug 2009 10:19:50 +0300
Message-ID: <bcf98daa0908260019k67716e05i1d205c61545ab6f8@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
	 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
	 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
	 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
	 <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
	 <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
	 <Pine.LNX.4.64.0908240956500.2289@cobra.newdream.net>
	 <bcf98daa0908250104j199d6e7ey705cc3b9913a5bbd@mail.gmail.com>
	 <Pine.LNX.4.64.0908251318450.1229@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Atila <atila.alr@dpf.gov.br>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0908251318450.1229@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/25 Sage Weil <sage@newdream.net>:
> Markus,
>
> This should fix your problem!
>

It works now , thanks!

-Markus


> ---
> Subject: [PATCH] Btrfs: fix arithmetic error in clone ioctl
>
> Fix an arithmetic error that was breaking extents cloned via the clon=
e
> ioctl starting in the second half of a file.
>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
> =A0fs/btrfs/ioctl.c | =A0 =A03 +--
> =A01 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e8e4ebe..63ca12a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1072,8 +1072,7 @@ static long btrfs_ioctl_clone(struct file *file=
, unsigned long srcfd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0datao +=3D off - key.offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0datal -=3D off - key.offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key=
=2Eoffset + datao + datal + key.offset >
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 off + len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key=
=2Eoffset + datao + datal > off + len)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0datal =3D off + len - key.offset - datao;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* dis=
ko =3D=3D 0 means it's a hole */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!d=
isko)
> --
> 1.5.6.5
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
