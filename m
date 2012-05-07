From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: balancing metadata fails with no space left on device
Date: Mon, 7 May 2012 21:19:34 +0200
Message-ID: <201205072119.35039.Martin@lichtvoll.de>
References: <201205041835.39441.Martin@lichtvoll.de> <201205061319.38676.Martin@lichtvoll.de> <20120506184814.GA2932@zambezi.lan> (sfid-20120506_233731_149352_F65B4185)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120506184814.GA2932@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 6. Mai 2012 schrieb Ilya Dryomov:
> On Sun, May 06, 2012 at 01:19:38PM +0200, Martin Steigerwald wrote:
> > Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> > > Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> > > > Hi!
> > > >=20
> > > > merkaba:~> btrfs balance start -m /
> > > > ERROR: error during balancing '/' - No space left on device
> > > > There may be more info in syslog - try dmesg | tail
> > > > merkaba:~#19> dmesg | tail -22
> > > > [   62.918734] CPU0: Package power limit normal
> > > > [  525.229976] btrfs: relocating block group 20422066176 flags =
1
> > > > [  526.940452] btrfs: found 3048 extents
> > > > [  528.803778] btrfs: found 3048 extents
> >=20
> > [=E2=80=A6]
> >=20
> > > > [  635.906517] btrfs: found 1 extents
> > > > [  636.038096] btrfs: 1 enospc errors during balance
> > > >=20
> > > >=20
> > > > merkaba:~> btrfs filesystem show
> > > > failed to read /dev/sr0
> > > > Label: 'debian'  uuid: [=E2=80=A6]
> > > >=20
> > > >         Total devices 1 FS bytes used 7.89GB
> > > >         devid    1 size 18.62GB used 17.58GB path /dev/dm-0
> > > >=20
> > > > Btrfs Btrfs v0.19
> > > > merkaba:~> btrfs filesystem df /
> > > > Data: total=3D15.52GB, used=3D7.31GB
> > > > System, DUP: total=3D32.00MB, used=3D4.00KB
> > > > System: total=3D4.00MB, used=3D0.00
> > > > Metadata, DUP: total=3D1.00GB, used=3D587.83MB
> > >=20
> > > I thought data tree might have been to big, so out of curiousity =
I
> > > tried a full balance. It shrunk the data tree but it failed as
> > > well:
> > >=20
> > > merkaba:~> btrfs balance start /
> > > ERROR: error during balancing '/' - No space left on device
> > > There may be more info in syslog - try dmesg | tail
> > > merkaba:~#19> dmesg | tail -63
> > > [   89.306718] postgres (2876): /proc/2876/oom_adj is deprecated,
> > > please use /proc/2876/oom_score_adj instead.
> > > [  159.939728] btrfs: relocating block group 21994930176 flags 34
> > > [  160.010427] btrfs: relocating block group 21860712448 flags 1
> > > [  161.188104] btrfs: found 6 extents
> > > [  161.507388] btrfs: found 6 extents
> >=20
> > [=E2=80=A6]
> >=20
> > > [  335.897953] btrfs: relocating block group 1103101952 flags 1
> > > [  347.888295] btrfs: found 28458 extents
> > > [  352.736987] btrfs: found 28458 extents
> > > [  353.099659] btrfs: 1 enospc errors during balance
> > >=20
> > > merkaba:~> btrfs filesystem df /
> > > Data: total=3D10.00GB, used=3D7.31GB
> > > System, DUP: total=3D64.00MB, used=3D4.00KB
> > > System: total=3D4.00MB, used=3D0.00
> > > Metadata, DUP: total=3D1.12GB, used=3D587.20MB
> > >=20
> > > merkaba:~> btrfs filesystem show
> > > failed to read /dev/sr0
> > > Label: 'debian'  uuid: [=E2=80=A6]
> > >=20
> > >         Total devices 1 FS bytes used 7.88GB
> > >         devid    1 size 18.62GB used 12.38GB path /dev/dm-0
> > >=20
> > > For the sake of it I tried another time. It failed again:
> > >=20
> > > martin@merkaba:~> dmesg | tail -32
> > > [  353.099659] btrfs: 1 enospc errors during balance
> > > [  537.057375] btrfs: relocating block group 32833011712 flags 36
> >=20
> > [=E2=80=A6]
> >=20
> > > [  641.479140] btrfs: relocating block group 22062039040 flags 34
> > > [  641.695614] btrfs: relocating block group 22028484608 flags 34
> > > [  641.840179] btrfs: found 1 extents
> > > [  641.965843] btrfs: 1 enospc errors during balance
> > >=20
> > >=20
> > > merkaba:~#19> btrfs filesystem df /
> > > Data: total=3D10.00GB, used=3D7.31GB
> > > System, DUP: total=3D32.00MB, used=3D4.00KB
> > > System: total=3D4.00MB, used=3D0.00
> > > Metadata, DUP: total=3D1.12GB, used=3D586.74MB
> > > merkaba:~> btrfs filesystem show
> > > failed to read /dev/sr0
> > > Label: 'debian'  uuid: [=E2=80=A6]
> > >=20
> > >         Total devices 1 FS bytes used 7.88GB
> > >         devid    1 size 18.62GB used 12.32GB path /dev/dm-0
> > >=20
> > > Btrfs Btrfs v0.19
> > >=20
> > >=20
> > > Well, in order to be gentle to the SSD again I stop my experiment=
s
> > > now ;).
> >=20
> > I had subjective impression that the speed of the BTRFS filesystem
> > decreased after all these
> >=20
> > Anyway, after reading the a -musage hint by Ilya in thread
> >=20
> > Is it possible to reclaim block groups once they ar allocated to da=
ta
> > or metadata?
>=20
> Currently there is no way to reclaim block groups other than performi=
ng
> a balance.  We will add a kernel thread for this in future, but a
> couple of things have to be fixed before that can happen.

Thanks. Yes, I got that. I just referenced the other thread for other=20
readers.

> > I tried:
> >=20
> > merkaba:~> btrfs filesystem df /
> > Data: total=3D10.00GB, used=3D7.34GB
> > System, DUP: total=3D32.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.12GB, used=3D586.39MB
> >=20
> > merkaba:~> btrfs balance start -musage=3D1 /
> > Done, had to relocate 2 out of 13 chunks
> >=20
> > merkaba:~> btrfs filesystem df /
> > Data: total=3D10.00GB, used=3D7.34GB
> > System, DUP: total=3D32.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.00GB, used=3D586.39MB
> >=20
> > So this worked.
>=20
> > But I wasn=C2=B4t able to specify less than a Gig:
>
> A follow up to the -musage hint says that the argument it takes is th=
e
> percentage.  That is -musage=3DX will balance out block groups that a=
re
> less than X percent used.

I missed that. Hmmm,  then the metadata at total=3D1.00GB was just a=20
coincidence?

> > merkaba:~> btrfs balance start -musage=3D0.8 /
> > Invalid usage argument: 0.8
> > merkaba:~#1> btrfs balance start -musage=3D700M /
> > Invalid usage argument: 700M
> >=20
> >=20
> > When I try without usage I get the old behavior back:
> >=20
> > merkaba:~#1> btrfs balance start -m /
> > ERROR: error during balancing '/' - No space left on device
> > There may be more info in syslog - try dmesg | tail
> >=20
> >=20
> > merkaba:~> btrfs balance start -musage=3D1 /
> > Done, had to relocate 2 out of 13 chunks
> > merkaba:~> btrfs balance start -musage=3D1 /
> > Done, had to relocate 1 out of 12 chunks
> > merkaba:~> btrfs balance start -musage=3D1 /
> > Done, had to relocate 1 out of 12 chunks
> > merkaba:~> btrfs balance start -musage=3D1 /
> > Done, had to relocate 1 out of 12 chunks
> > merkaba:~> btrfs filesystem df /
> > Data: total=3D10.00GB, used=3D7.34GB
> > System, DUP: total=3D32.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.00GB, used=3D586.41MB
>=20
> Btrfs allocates space in chunks, in your case metadata chunks are
> probably 512M in size.  Naturally, having 586M busy you can't make th=
at
> chunk go away, be it with or without auto-reclaim and usage filter
> accepting size as its input.

Hmmm, whatever it did tough: I believe I had the BTRFS performance go d=
own=20
by a big margin by my playing around.

I didn=C2=B4t to any measurements yet, but apt-cache search could so mu=
ch=20
slower as well as starting Iceweasel. The SSD tends to feel quite a bit=
=20
more like a harddisk. (It still feels faster tough.)

And startup time has also raised:

martin@merkaba:~> systemd-analyze=20
Startup finished in 6058ms (kernel) + 9285ms (userspace) =3D 15344ms

This has been about 8,5 seconds before.

I can=C2=B4t prove that this is due to a slower BTRFS, but I highly sus=
pect it.

So I think I learned that there is no guarentee that a BTRFS balance=20
improves the situation at all. It seemed to have worsened it a lot.

Well it was just my experimenting around. I didn=C2=B4t have a real pro=
blem=20
before and now I seemed I have to created me one.

Now I wonder whether there would be a way to fix up the perceived=20
performance regression except of creating a new logical volume with BTR=
=46S,=20
copying all the stuff to it and switching / to use the new volume.

(I doubt that the general Intel SSD 320 has regressed that much due to =
the=20
balances. The SSD is only one year old and according to data sheet can=20
take 20 GB a day for 5 years. Also I use fstrim from time to time and h=
ave=20
about 25 GB left free.)

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
