From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3 V3] btrfs: a new tool to manage a btrfs filesystem
Date: Wed, 24 Feb 2010 18:35:38 -0500
Message-ID: <20100224233538.GH25641@think>
References: <201002211740.13074.kreijack@libero.it>
 <93cdabd21002212133o3d257fa6t29d67059e80eb98a@mail.gmail.com>
 <201002221947.40793.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002221947.40793.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2010 at 07:47:40PM +0100, Goffredo Baroncelli wrote:
> On Monday 22 February 2010, Mike Fedyk wrote:
> > On Sun, Feb 21, 2010 at 8:40 AM, Goffredo Baroncelli <kreijack@gmai=
l.com>=20
> wrote:
> > >       filesystem resize [+/-]<size>[gkm]|max <filesystem>
> >=20
> > -filesystem resize [+/-]<size>[gkm]|max <filesystem>
> > +filesystem resize [+/-]<size>[gkm]|max <dev>
> >=20
> > This command works on devices, not paths.
>=20
> Are you sure ? To me it results (test and code inspection) to work on=
 path.

The ioctl takes a path so that it knows which btrfs filesystem to
change.

>=20
> >=20
> > >              Resize a filesystem identified by <path>.  The <size=
> parame=E2=80=90
> >=20
> > -Resize a filesystem identified by <path>.  The <size> parame=E2=80=
=90
> > +Resize a filesystem identified by <dev>.  The <size> parame=E2=80=90
> >=20
> > >              ter  specifies the new size of the filesystem.  If t=
he prefix
> > >              + or - is present the size is increased or decreased=
  by  the
> > >              quantity  <size>.  If no units are specified, the un=
it of the
> > >              <size> parameter defaults  to  bytes.  Optionally,  =
the  size
> > >              parameter  may  be suffixed by one of the following =
the units
> > >              designators: 'K', 'M', or 'G', kilobytes, megabytes,=
 or giga=E2=80=90
> > >              bytes, respectively.
> > >
> > >              If  'max' is passed, the filesystem will occupy all =
available
> > >              space on the volume(s).
> > >
> > >              The resize command does not manipulate the size of u=
nderlying
> > >              partitions.   If you wish to enlarge/reduce a filesy=
stem, you
> >=20
> > -partitions.   If you wish to enlarge/reduce a filesystem, you
> > +partition.   If you wish to enlarge/reduce a filesystem, you
> ok
>=20
> > >              must make sure you can expand/reduce the size of  th=
e  parti=E2=80=90
> > >              tion also.
> >=20
> > -must make sure you can expand/reduce the size of  the  parti=E2=80=
=90
> > -tion also.
> > +must make sure you can expand the partition before enlarging
> > +the filesystem and shrink the partition after reducing the size
> > +of the filesystem.
> ok
>=20
> > >
> > >
> > >       filesystem show [<uuid>|<label>]
> > >              Show  the  btrfs  filesystem with some additional in=
fo. If no
> > >              UUID or label is passed, btrfs show info  of  all  t=
he  btrfs
> > >              filesystem.
> > >
> > >
> > >       device balance|-b <path>
> >=20
> > -device balance|-b <path>
> > +device balance <path>
>=20
> ok
>=20
> > Mike
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> I will update my repo

Thanks!

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
