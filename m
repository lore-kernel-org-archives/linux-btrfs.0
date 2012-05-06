From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: balancing metadata fails with no space left on device
Date: Sun, 6 May 2012 21:48:15 +0300
Message-ID: <20120506184814.GA2932@zambezi.lan>
References: <201205041835.39441.Martin@lichtvoll.de>
 <201205041852.29290.Martin@lichtvoll.de>
 <201205061319.38676.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205061319.38676.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 06, 2012 at 01:19:38PM +0200, Martin Steigerwald wrote:
> Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> > Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> > > Hi!
> > >=20
> > > merkaba:~> btrfs balance start -m /
> > > ERROR: error during balancing '/' - No space left on device
> > > There may be more info in syslog - try dmesg | tail
> > > merkaba:~#19> dmesg | tail -22
> > > [   62.918734] CPU0: Package power limit normal
> > > [  525.229976] btrfs: relocating block group 20422066176 flags 1
> > > [  526.940452] btrfs: found 3048 extents
> > > [  528.803778] btrfs: found 3048 extents
> [=E2=80=A6]
> > > [  635.906517] btrfs: found 1 extents
> > > [  636.038096] btrfs: 1 enospc errors during balance
> > >=20
> > >=20
> > > merkaba:~> btrfs filesystem show
> > > failed to read /dev/sr0
> > > Label: 'debian'  uuid: [=E2=80=A6]
> > >=20
> > >         Total devices 1 FS bytes used 7.89GB
> > >         devid    1 size 18.62GB used 17.58GB path /dev/dm-0
> > >=20
> > > Btrfs Btrfs v0.19
> > > merkaba:~> btrfs filesystem df /
> > > Data: total=3D15.52GB, used=3D7.31GB
> > > System, DUP: total=3D32.00MB, used=3D4.00KB
> > > System: total=3D4.00MB, used=3D0.00
> > > Metadata, DUP: total=3D1.00GB, used=3D587.83MB
> >=20
> > I thought data tree might have been to big, so out of curiousity I
> > tried a full balance. It shrunk the data tree but it failed as well=
:
> >=20
> > merkaba:~> btrfs balance start /
> > ERROR: error during balancing '/' - No space left on device
> > There may be more info in syslog - try dmesg | tail
> > merkaba:~#19> dmesg | tail -63
> > [   89.306718] postgres (2876): /proc/2876/oom_adj is deprecated,
> > please use /proc/2876/oom_score_adj instead.
> > [  159.939728] btrfs: relocating block group 21994930176 flags 34
> > [  160.010427] btrfs: relocating block group 21860712448 flags 1
> > [  161.188104] btrfs: found 6 extents
> > [  161.507388] btrfs: found 6 extents
> [=E2=80=A6]
> > [  335.897953] btrfs: relocating block group 1103101952 flags 1
> > [  347.888295] btrfs: found 28458 extents
> > [  352.736987] btrfs: found 28458 extents
> > [  353.099659] btrfs: 1 enospc errors during balance
> >=20
> > merkaba:~> btrfs filesystem df /
> > Data: total=3D10.00GB, used=3D7.31GB
> > System, DUP: total=3D64.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.12GB, used=3D587.20MB
> >=20
> > merkaba:~> btrfs filesystem show
> > failed to read /dev/sr0
> > Label: 'debian'  uuid: [=E2=80=A6]
> >         Total devices 1 FS bytes used 7.88GB
> >         devid    1 size 18.62GB used 12.38GB path /dev/dm-0
> >=20
> >=20
> > For the sake of it I tried another time. It failed again:
> >=20
> > martin@merkaba:~> dmesg | tail -32
> > [  353.099659] btrfs: 1 enospc errors during balance
> > [  537.057375] btrfs: relocating block group 32833011712 flags 36
> [=E2=80=A6]
> > [  641.479140] btrfs: relocating block group 22062039040 flags 34
> > [  641.695614] btrfs: relocating block group 22028484608 flags 34
> > [  641.840179] btrfs: found 1 extents
> > [  641.965843] btrfs: 1 enospc errors during balance
> >=20
> >=20
> > merkaba:~#19> btrfs filesystem df /
> > Data: total=3D10.00GB, used=3D7.31GB
> > System, DUP: total=3D32.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.12GB, used=3D586.74MB
> > merkaba:~> btrfs filesystem show
> > failed to read /dev/sr0
> > Label: 'debian'  uuid: [=E2=80=A6]
> >         Total devices 1 FS bytes used 7.88GB
> >         devid    1 size 18.62GB used 12.32GB path /dev/dm-0
> >=20
> > Btrfs Btrfs v0.19
> >=20
> >=20
> > Well, in order to be gentle to the SSD again I stop my experiments =
now
> > ;).
>=20
> I had subjective impression that the speed of the BTRFS filesystem=20
> decreased after all these
>=20
> Anyway, after reading the a -musage hint by Ilya in thread
>=20
> Is it possible to reclaim block groups once they ar allocated to data=
 or=20
> metadata?

Currently there is no way to reclaim block groups other than performing
a balance.  We will add a kernel thread for this in future, but a coupl=
e
of things have to be fixed before that can happen.

>=20
>=20
> I tried:
>=20
> merkaba:~> btrfs filesystem df /
> Data: total=3D10.00GB, used=3D7.34GB
> System, DUP: total=3D32.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.12GB, used=3D586.39MB
>=20
> merkaba:~> btrfs balance start -musage=3D1 /=20
> Done, had to relocate 2 out of 13 chunks
>=20
> merkaba:~> btrfs filesystem df /         =20
> Data: total=3D10.00GB, used=3D7.34GB
> System, DUP: total=3D32.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.00GB, used=3D586.39MB
>=20
> So this worked.
>=20
> But I wasn=C2=B4t able to specify less than a Gig:

A follow up to the -musage hint says that the argument it takes is the
percentage.  That is -musage=3DX will balance out block groups that are
less than X percent used.

>=20
> merkaba:~> btrfs balance start -musage=3D0.8 /
> Invalid usage argument: 0.8
> merkaba:~#1> btrfs balance start -musage=3D700M /
> Invalid usage argument: 700M
>=20
>=20
> When I try without usage I get the old behavior back:
>=20
> merkaba:~#1> btrfs balance start -m /         =20
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>=20
>=20
> merkaba:~> btrfs balance start -musage=3D1 /  =20
> Done, had to relocate 2 out of 13 chunks
> merkaba:~> btrfs balance start -musage=3D1 /
> Done, had to relocate 1 out of 12 chunks
> merkaba:~> btrfs balance start -musage=3D1 /
> Done, had to relocate 1 out of 12 chunks
> merkaba:~> btrfs balance start -musage=3D1 /
> Done, had to relocate 1 out of 12 chunks
> merkaba:~> btrfs filesystem df /
> Data: total=3D10.00GB, used=3D7.34GB
> System, DUP: total=3D32.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.00GB, used=3D586.41MB

Btrfs allocates space in chunks, in your case metadata chunks are
probably 512M in size.  Naturally, having 586M busy you can't make that
chunk go away, be it with or without auto-reclaim and usage filter
accepting size as its input.

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
