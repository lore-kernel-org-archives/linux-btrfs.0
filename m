From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: balancing metadata fails with no space left on device
Date: Thu, 10 May 2012 17:14:06 +0200
Message-ID: <201205101714.06634.Martin@lichtvoll.de>
References: <201205041835.39441.Martin@lichtvoll.de> <20120506184814.GA2932@zambezi.lan> <201205072119.35039.Martin@lichtvoll.de> (sfid-20120507_212056_161847_62ECC6F2)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205072119.35039.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Martin Steigerwald:
> Am Sonntag, 6. Mai 2012 schrieb Ilya Dryomov:
> > On Sun, May 06, 2012 at 01:19:38PM +0200, Martin Steigerwald wrote:
> > > Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
> > > > Am Freitag, 4. Mai 2012 schrieb Martin Steigerwald:
[=E2=80=A6]
> > > merkaba:~> btrfs balance start -musage=3D0.8 /
> > > Invalid usage argument: 0.8
> > > merkaba:~#1> btrfs balance start -musage=3D700M /
> > > Invalid usage argument: 700M
> > >=20
> > >=20
> > > When I try without usage I get the old behavior back:
> > >=20
> > > merkaba:~#1> btrfs balance start -m /
> > > ERROR: error during balancing '/' - No space left on device
> > > There may be more info in syslog - try dmesg | tail
> > >=20
> > >=20
> > > merkaba:~> btrfs balance start -musage=3D1 /
> > > Done, had to relocate 2 out of 13 chunks
> > > merkaba:~> btrfs balance start -musage=3D1 /
> > > Done, had to relocate 1 out of 12 chunks
> > > merkaba:~> btrfs balance start -musage=3D1 /
> > > Done, had to relocate 1 out of 12 chunks
> > > merkaba:~> btrfs balance start -musage=3D1 /
> > > Done, had to relocate 1 out of 12 chunks
> > > merkaba:~> btrfs filesystem df /
> > > Data: total=3D10.00GB, used=3D7.34GB
> > > System, DUP: total=3D32.00MB, used=3D4.00KB
> > > System: total=3D4.00MB, used=3D0.00
> > > Metadata, DUP: total=3D1.00GB, used=3D586.41MB
> >=20
> > Btrfs allocates space in chunks, in your case metadata chunks are
> > probably 512M in size.  Naturally, having 586M busy you can't make
> > that chunk go away, be it with or without auto-reclaim and usage
> > filter accepting size as its input.
>=20
> Hmmm, whatever it did tough: I believe I had the BTRFS performance go
> down by a big margin by my playing around.
>=20
> I didn=C2=B4t to any measurements yet, but apt-cache search could so =
much
> slower as well as starting Iceweasel. The SSD tends to feel quite a b=
it
> more like a harddisk. (It still feels faster tough.)
>=20
> And startup time has also raised:
>=20
> martin@merkaba:~> systemd-analyze
> Startup finished in 6058ms (kernel) + 9285ms (userspace) =3D 15344ms
>=20
> This has been about 8,5 seconds before.
>=20
> I can=C2=B4t prove that this is due to a slower BTRFS, but I highly s=
uspect
> it.
>=20
> So I think I learned that there is no guarentee that a BTRFS balance
> improves the situation at all. It seemed to have worsened it a lot.
>=20
> Well it was just my experimenting around. I didn=C2=B4t have a real p=
roblem
> before and now I seemed I have to created me one.
>=20
> Now I wonder whether there would be a way to fix up the perceived
> performance regression except of creating a new logical volume with
> BTRFS, copying all the stuff to it and switching / to use the new
> volume.

I did it the redo the filesystem way:

merkaba:~> systemd-analyze=20
Startup finished in 6602ms (kernel) + 4246ms (userspace) =3D 10848ms

Thats not the about 8.5 I seen already, but it was the first start afte=
r=20
activating inode_cache + space_cache, as I didn=C2=B4t want to activate=
 it on=20
GRML 2011.12 3.1 kernel. The filesystem has been mounted with compress=3D=
lzo=20
from the beginning. Which also made in space usage.

Also Iceweasel and apt-cache are way faster now again. Almost instant.

Next time I use an other BTRFS filesystem than my / one for experiments=
=20
with balancing ;).

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
