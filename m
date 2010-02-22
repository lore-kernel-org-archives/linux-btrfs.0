From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 0/3 V3] btrfs: a new tool to manage a btrfs filesystem
Date: Mon, 22 Feb 2010 19:47:40 +0100
Message-ID: <201002221947.40793.kreijack@libero.it>
References: <201002211740.13074.kreijack@libero.it> <93cdabd21002212133o3d257fa6t29d67059e80eb98a@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002212133o3d257fa6t29d67059e80eb98a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 22 February 2010, Mike Fedyk wrote:
> On Sun, Feb 21, 2010 at 8:40 AM, Goffredo Baroncelli <kreijack@gmail.=
com>=20
wrote:
> >       filesystem resize [+/-]<size>[gkm]|max <filesystem>
>=20
> -filesystem resize [+/-]<size>[gkm]|max <filesystem>
> +filesystem resize [+/-]<size>[gkm]|max <dev>
>=20
> This command works on devices, not paths.

Are you sure ? To me it results (test and code inspection) to work on p=
ath.

>=20
> >              Resize a filesystem identified by <path>.  The <size> =
parame=E2=80=90
>=20
> -Resize a filesystem identified by <path>.  The <size> parame=E2=80=90
> +Resize a filesystem identified by <dev>.  The <size> parame=E2=80=90
>=20
> >              ter  specifies the new size of the filesystem.  If the=
 prefix
> >              + or - is present the size is increased or decreased  =
by  the
> >              quantity  <size>.  If no units are specified, the unit=
 of the
> >              <size> parameter defaults  to  bytes.  Optionally,  th=
e  size
> >              parameter  may  be suffixed by one of the following th=
e units
> >              designators: 'K', 'M', or 'G', kilobytes, megabytes, o=
r giga=E2=80=90
> >              bytes, respectively.
> >
> >              If  'max' is passed, the filesystem will occupy all av=
ailable
> >              space on the volume(s).
> >
> >              The resize command does not manipulate the size of und=
erlying
> >              partitions.   If you wish to enlarge/reduce a filesyst=
em, you
>=20
> -partitions.   If you wish to enlarge/reduce a filesystem, you
> +partition.   If you wish to enlarge/reduce a filesystem, you
ok

> >              must make sure you can expand/reduce the size of  the =
 parti=E2=80=90
> >              tion also.
>=20
> -must make sure you can expand/reduce the size of  the  parti=E2=80=90
> -tion also.
> +must make sure you can expand the partition before enlarging
> +the filesystem and shrink the partition after reducing the size
> +of the filesystem.
ok

> >
> >
> >       filesystem show [<uuid>|<label>]
> >              Show  the  btrfs  filesystem with some additional info=
=2E If no
> >              UUID or label is passed, btrfs show info  of  all  the=
  btrfs
> >              filesystem.
> >
> >
> >       device balance|-b <path>
>=20
> -device balance|-b <path>
> +device balance <path>

ok

> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

I will update my repo

BR
Goffredo
--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
