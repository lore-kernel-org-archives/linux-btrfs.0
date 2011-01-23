From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [regression?] hang with 2.6.37 on a BTRFS test machine
Date: Sun, 23 Jan 2011 14:44:03 +0100
Message-ID: <201101231444.10680.Martin@lichtvoll.de>
References: <BePhzVUT1uB@helmut.hullen.de> (sfid-20110123_143446_269000_092052A2)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1966746.u5WyidA4mI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BePhzVUT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1966746.u5WyidA4mI
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

CCs restored. Its usual to keep CCs on Linux kernel related mailing lists.

Am Sunday 23 January 2011 schrieb Helmut Hullen:
> Hallo, Martin,
>=20
> Du meintest am 23.01.11:
> > I have something I do not have the slightest clue on how to track
> > down:
> >=20
> > Occasionally with 2.6.37 plain vanilla my ThinkPad T23 freezes in
> > such a way, that when I type a command at the prompt, nothing will
> > happen anymore. Same goes for login into a tty. Even dmesg is not
> > executed anymore. My KDE session doesn't react to clicks anymore,
> > except for window movement. Most of the time the mouse pointer is
> > still movable, but sometimes it is frozen as well. But the latter
> > might be a different problem with X.org.
>=20
> Maybe it's the same problem ... I have (among my machines) a Thinkpad
> T22 on which I have run btrfs with kernel 2.6.37-rc4. Sometimes it
> hung, too. But it's an old machine, with old RAM, with some old disks.

Is the hung comparable to what I have seen? I.e. mouse pointer and stuff=20
still works, but when entering a command the shell does hang?

I can't completely rule out a hardware related problem as well, but then=20
with 2.6.36 the machine now just works again as if nothing happened - its=20
mostly running at 733 MHz instead of 1.13 GHz and the fan still expels a=20
steady stream of lukewarm air. I think I have to run it with 2.6.36 at=20
least a week to see whether its stable with that one. Its not important to=
=20
run it with 2.6.37 so thats not a problem. Its just my Amarok machine.

Maybe it would be a good idea when you compare with 2.6.36 as well...

> It has hung some time ago also without any btrfs partition and with
> older kernel(s).
>=20
> But I'll test again.

I will also continue to test with a 2.6.37 on a workstation at work, but=20
there only some scratch partition uses BTRFS. My T23 has / and /home on=20
it.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1966746.u5WyidA4mI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk08MKMACgkQmRvqrKWZhMcBdgCgrzacFG2D/XMD2DecbwKpFcqe
BzMAoIIttYuMf5TMG10NlgPUcZFC5LgH
=z9+z
-----END PGP SIGNATURE-----

--nextPart1966746.u5WyidA4mI--
