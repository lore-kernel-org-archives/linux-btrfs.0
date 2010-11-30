From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] btrfs: Correct printing of sector_t
Date: Tue, 30 Nov 2010 12:33:09 -0800
Message-ID: <20101130123309.d84cc69c.randy.dunlap@oracle.com>
References: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 30 Nov 2010 21:30:01 +0100 (CET) Geert Uytterhoeven wrote:

> If CONFIG_LBDAF=3Dy, `sector_t' becomes `u64' instead of `unsigned lo=
ng':
>=20
> fs/btrfs/inode.c: In function =E2=80=98btrfs_end_dio_bio=E2=80=99:
> fs/btrfs/inode.c:5717: warning: format =E2=80=98%lu=E2=80=99 expects =
type =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=80=
=98sector_t=E2=80=99
>=20
> Hence always cast it to `unsigned long long' for printing.
>=20
> Introduced by commit e65e1535542931e51189832264cd282e5899e4b9 ("btrfs=
: fix
> panic caused by direct IO")
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  fs/btrfs/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8039390..fbffe5f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5712,9 +5712,9 @@ static void btrfs_end_dio_bio(struct bio *bio, =
int err)
> =20
>  	if (err) {
>  		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
> -		      "disk_bytenr %lu len %u err no %d\n",
> -		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
> -		      bio->bi_size, err);
> +		      "disk_bytenr %llu len %u err no %d\n",
> +		      dip->inode->i_ino, bio->bi_rw,
> +		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
>  		dip->errors =3D 1;
> =20
>  		/*
> --=20
> 1.7.0.4
>=20
> Gr{oetje,eeting}s,
>=20
> 						Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linu=
x-m68k.org
>=20
> In personal conversations with technical people, I call myself a hack=
er. But
> when I'm talking to journalists I just say "programmer" or something =
like that.
> 							    -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
