Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56564 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaGUXaa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 19:30:30 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0M2WgT-1WH8SH08Av-00sOfw for
 <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 01:30:28 +0200
Date: Tue, 22 Jul 2014 01:30:22 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140722013022.52b189ee@marcec>
In-Reply-To: <20140722003057.0f3b89f0@marcec>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
	<20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec>
	<20140721152216.27d8a4c4@marcec>
	<20140722003057.0f3b89f0@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SKy3TyUWfcWOgGfOcIHcB=S"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SKy3TyUWfcWOgGfOcIHcB=S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Tue, 22 Jul 2014 00:30:57 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> Am Mon, 21 Jul 2014 15:22:16 +0200
> schrieb Marc Joliet <marcec@gmx.de>:
>=20
> > Am Sun, 20 Jul 2014 21:44:40 +0200
> > schrieb Marc Joliet <marcec@gmx.de>:
> >=20
> > [...]
> > > What I did:
> > >=20
> > > - delete the single largest file on the file system, a 12 GB VM image=
, along
> > >   with all subvolumes that contained it
> > > - rsync it over again
> > [...]
> >=20
> > I want to point out at this point, though, that doing those two steps f=
reed a
> > disproportionate amount of space.  The image file is only 12 GB, and it=
 hadn't
> > changed in any of the snapshots (I haven't used this VM since June), so=
 that
> > "subvolume delete -c <snapshots>" returned after a few seconds. Yet del=
eting it
> > seems to have freed up twice as much. You can see this from the "filesy=
stem df"
> > output: before, "used" was at 229.04 GiB, and after deleting it and cop=
ying it
> > back (and after a day's worth of backups) went down to 218 GiB.
> >=20
> > Does anyone have any idea how this happened?
> >=20
> > Actually, now I remember something that is probably related: when I fir=
st
> > moved to my current backup scheme last week, I first copied the data fr=
om the
> > last rsnapshot based backup with "cp --reflink" to the new backup locat=
ion, but
> > forgot to use "-a".  I interrupted it and ran "cp -a -u --reflink", but=
 it had
> > already copied a lot, and I was too impatient to start over; after all,=
 the
> > data hadn't changed.  Then, when rsync (with --inplace) ran for the fir=
st time,
> > all of these files with wrong permissions and different time stamps wer=
e copied
> > over, but for some reason, the space used increased *greatly*; *much* m=
ore than
> > I would expect from changed metadata.
> >=20
> > The total size of the file system data should be around 142 GB (+ snaps=
hots),
> > but, well, it's more than 1.5 times as much.
> >=20
> > Perhaps cp --reflink treats hard links differently than expected?  I wo=
uld have
> > expected the data pointed to by the hard link to have been referenced, =
but
> > maybe something else happened?
>=20
> Hah, OK, apparently when my daily backup removed the oldest daily snapsho=
t, it
> freed up whatever was taking up so much space, so as of now the file syst=
em
> uses only 169.14 GiB (from 218).  Weird.

And now that the background deletion of the old snapshots is done, the file
system ended up at:

# btrfs filesystem df /run/media/marcec/MARCEC_BACKUP   =20
Data, single: total=3D219.00GiB, used=3D140.13GiB
System, DUP: total=3D32.00MiB, used=3D36.00KiB
Metadata, DUP: total=3D4.50GiB, used=3D2.40GiB
unknown, single: total=3D512.00MiB, used=3D0.00

I don't know how reliable du is for this, but I used it to estimate how much
used data I should expect, and I get 138 GiB.  That means that the snapshots
yield about 2 GiB "overhead", which is very reasonable, I think.  Obviously
I'll be starting a full balance now.

I still think this whole... thing is very odd, hopefully somebody can shed
some light on it for me (maybe it's obvious, but I don't see it).

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/SKy3TyUWfcWOgGfOcIHcB=S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzaKSAAoJEL/Q5oYsiHj03rEQAI+MmVb5lK5WSDdJGVjpB8bq
snIpdd9gVAQ73VvfpiXU6d8dI+Zs1nVOWMhI8x0jwJ1ueBdgkQqPGW+pH5dT9Y0A
yx2qPhqXua/TjwD/m4Kklm7eQOvFDaSHxKAa2CJFZQLb2zRUxwBbwnwQt8xYnLp3
HJsJcK1ZDCcpRD70W/KOh606fuF1IFm81ocR7zpJqts5hFDtOOv5RMchXImPJH+a
L5RTtfUgdT7e+lIqkC+cZ0UFBF6hGBV69QrBw1kmf3rZXeS2ycZx+3fBs7/VbqfB
gEAS41AyiwIgty+2mLXCesIxzhTbAwBgQg0vUtTfPyVyWgtXisWvs5JxWFbb4GU0
5eWTTIaOvtWdIwphlCgo8stJlDPMXtaYwMxLg7Wr14nrAz3DGZE6lgUEBxVbdTJ9
iCWKaOu4orwEB8yyyTMgseQBwkesFMU6vhozKetuNMzSMPnODIbc9iPRDMk9FDPw
HIRIDI2tC7OkchnTu0UHvum81BzY8etT9sgnc92kVpzLZn3HFs159HvBHUnBY2m3
xPpgTaMrCjuxjc5O28rAeGi/G7IB88+YLZzR+gK7Vlly+xHdOo/Z74jkuuQZHKor
1wmHOsbSogF1dneiHbkLTQaCaZCBLGx1t5goMtdsMDGhskl8hDQwsk7Di6Y61gfF
MztIYn8SI12WneLVdt3q
=TlQf
-----END PGP SIGNATURE-----

--Sig_/SKy3TyUWfcWOgGfOcIHcB=S--
