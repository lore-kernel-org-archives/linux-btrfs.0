From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sun, 19 Feb 2012 21:41:09 +1100
Message-ID: <201202192141.13497.chris@csamuel.org>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com> <201202191000.34819.chris@csamuel.org> <FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13043654.NYtZ5baVRO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Curtis Jones <curtis.jones@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart13043654.NYtZ5baVRO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Curtis,

On Sunday 19 February 2012 13:47:35 Curtis Jones wrote:

> I don't want to push this too far in the direction of being an
> Ubuntu support thread; but do you happen to know of any convenient
> methods for installing a 3.2.x kernel on Ubuntu? I'd like to
> minimize the chance of screwing up my existing Ubuntu
> installation....

My suggestion would be (given the uname -a info you supplied showed
you were running a PAE kernel):

1) First become root with:

sudo -i

2) Then download the current stable mainline kernel release:

wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.2.6-precise/linux-=
image-3.2.6-030206-generic-
pae_3.2.6-030206.201202131435_i386.deb

3) Install the deb package you just downloaded with:

dpkg -i ./linux-image-3.2.6-030206-generic-pae_3.2.6-030206.201202131435_i3=
86.deb

Then you should be able to reboot into it.

If you want to get rid of it you reboot and pick the latest 3.0 kernel
that grub offers you and then:

sudo -i
apt-get remove --purge linux-image-3.2.6-030206-generic-pae

Hope this helps!

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart13043654.NYtZ5baVRO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT0DRxY1yjaOTJg85AQJHWgf/ai/WHf0L9yy/LTrY/O21vkhUicj6yM0g
KisHWnDQJ/0ABuHBeeCWKHJ2EF7qtEJMLRcP1J+2u3Enrf/WkfFxsDTeprxF43H/
obBqQxwk0KrOTDdT0byOxFoBz/j0JnLVE2TXr4AvHuhZJaY/amTUG/RF+Sw0gV/K
sy+Dn5+9KhKcC9v6IOz21vpthlC2qm4bDlA/jiD68L4AFskLHekMqbA3M9T0y5Hg
cng3Lg1jyDtd8QruPbdUBBfwfEge2M/t1qGPoH/uGghIFxvCc3CVxckHtAzqGua5
0zhAkCtqzW7QnlkefjG3j5SNIEKHRzWBX2fVi+2bm9WMqlRLmbHJ/w==
=5F15
-----END PGP SIGNATURE-----

--nextPart13043654.NYtZ5baVRO--
