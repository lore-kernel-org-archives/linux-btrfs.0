From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: Mount via /etc/fstab constant failure
Date: Fri, 1 Jan 2010 14:51:26 +0100
Message-ID: <201001011451.32725@fortytwo.ch>
References: <200912311822.57397.regomodo@googlemail.com> <m3hbr73q1v.fsf@pullcord.laptop.org> <200912312044.58341.regomodo@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5306060.NSr72NcaKX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: regomodo <regomodo@googlemail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912312044.58341.regomodo@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5306060.NSr72NcaKX
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 31 December 2009 21.44:58 regomodo wrote:
> On Thursday 31 December 2009 19:24:12 Chris Ball wrote:
> > Hi Reg,
> >
> >    > Hi, I have a btrfs 'pool' of x2 Samsung 500GB HDD's in non-raid
> >    > format. It works fine for the most part except for mounting on
> >    > bootup. Every bootup I have to change the block-device to and fro
> >    > /dev/sda & /dev/sdb. This happens on linux-2.6.32.2 and
> >    > 2.6.33-rc2.
> >
> > Are you running "btrfsctl -a" in an initrd?  It's necessary to do that
> > before the mount call on a multi-disk volume.
>=20
> I did not know that. I've just given it a try on Funtoo and Ubuntu and it
> makes no difference. On Funtoo, my small script runs 'btrfsctl -a' at the
>  boot runlevel but I still get those 3 errors. I even try running
>  'btrfsctl -a' again before I try 'mount -av' but still no luck.

I had a similar issue and discovered that "btrfsctl -a" doesn't load the=20
btrfs module.  So I do "modprobe btrfs; btrfsctl -a"

cheers
=2D- vbi


=2D-=20
The idea is that you can only get in trouble for what you actually did.
What a concept.
        -- Pam Jones, Groklaw

--nextPart5306060.NSr72NcaKX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAks9/d9gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l67MUAoIB7SZP3xVG77gEQm4lMaXCN
qAzHAJ9TS/75kRvauFVjuAGOGScwdCXMog==
=ehod
-----END PGP SIGNATURE-----

--nextPart5306060.NSr72NcaKX--
