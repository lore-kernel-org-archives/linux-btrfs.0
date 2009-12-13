From: sniper <s3c24xx@gmail.com>
Subject: Re: [PATCH][TRIVIAL] Improve the btrfsctl help
Date: Sun, 13 Dec 2009 16:05:35 +0800
Message-ID: <9bd6b5360912130005m2bf7993ar7df5244945504534@mail.gmail.com>
References: <200912121639.41192.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912121639.41192.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

2009/12/12 Goffredo Baroncelli <kreijack@gmail.com>:
> Hi all,
>
> I found the help of the btrfctl command very poor. I rewrite some hel=
p
> messages and correct (or added when needed) the check of the number o=
f
> parameter.
>
> Please apply.
>
>
> * Improve/correct the check of the arguments number
> * Revise the command help
> ---
> =C2=A0btrfsctl.c | =C2=A0 33 +++++++++++++++++++--------------
> =C2=A01 files changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/btrfsctl.c b/btrfsctl.c
> index 66c4e89..0e5ce79 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -45,17 +45,18 @@ static inline int ioctl(int fd, int define, void =
*arg) {
> return 0; }
>
> =C2=A0static void print_usage(void)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 printf("usage: btrfsctl [ -d file|dir] [ -s sn=
ap_name subvol|tree ]\n");
> - =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[-r size] [-A device] [-a] [-c] [-D dir .]\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("usage: btrfsctl [-d file|dir] [-s snap=
_name subvol]\n");
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[-S vol_name dir] [-a] [-r size subvol]\n");
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[-A device] [-c subvol] [-D name subvol]\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-d filename: defragments one fil=
e\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-d directory: defragments the en=
tire Btree\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-s snap_name dir: creates a new snap=
shot of dir\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-S subvol_name dir: creates a new su=
bvolume\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-r [+-]size[gkm]: resize the FS by s=
ize amount\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-A device: scans the device file for=
 a Btrfs filesystem\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-s snap_name subvol: creates a new s=
napshot of subvol\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-S subvol_name dir: creates a new su=
bvolume in dir\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-a: scans all devices for Btrfs =
filesystems\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-c: forces a single FS sync\n");
> - =C2=A0 =C2=A0 =C2=A0 printf("\t-D: delete snapshot\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-r [+-]size[gkm] subvol: resize the =
=46S by size amount\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-A device: scans the device file for=
 a Btrfs filesystem\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-c subvol: forces a single FS sync\n=
");
> + =C2=A0 =C2=A0 =C2=A0 printf("\t-D name dir: delete a snapshot or su=
bvolume of dir\n");

Hi, should it be "delete a snapshot or subvolume _in_ dir"?

I notice that I can only snapshot for a whole device but not a dir,
and the snapshot file can be moved to other place after created.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
