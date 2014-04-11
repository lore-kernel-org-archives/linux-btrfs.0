Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35859 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaDKP3m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 11:29:42 -0400
Date: Fri, 11 Apr 2014 16:29:38 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: George Mitchell <george@chinilu.com>
Cc: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to make BTRFS crawl
Message-ID: <20140411152938.GG27956@carfax.org.uk>
References: <4171851.75rN5oGIof@zafu>
 <5347F828.9090306@chinilu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
In-Reply-To: <5347F828.9090306@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 07:11:52AM -0700, George Mitchell wrote:
> Well, Akonadi brought my system to its knees long before I converted to
> btrfs, so somehow I am not surprised.  I have kept akonadi disabled ever
> since.for everything except a portion of Thunderbird and that ONLY with
> sql-lite. Mysql will kill it in no time.  So I am not sure that btrfs is =
the
> root of the problem here.  Just my two cents, perhaps others have differe=
nt
> experience with akonadi.

   My opinion (and it is purely opinion, since I haven't used any part
of KDE since the last millennium) is that akonadi probably isn't
massively efficient, *and* that it happens to hit a particular write
pattern that btrfs isn't handling too well. So I don't think it's fair
to point the blame solely at one or the other, but at the interaction
between bad (or awkward) behaviours of the two together.

   I'm surprised that it's showing very poor performance with the SSD,
though -- I'd have thought most of the performance loss would be in
additional seeks from the very fragmented file. Although with lots of
snapshots (e.g. snapper) going on, the benefits of reduced
fragmentation from the nodatacow are largely going to be lost because
each snapshot forces another round of CoWing and fragmentation.

   Hugo.

> On 04/11/2014 02:42 AM, Sw=E2mi Petaramesh wrote:
> >Hi,
> >
> >I was asked about situations "use cases" that would cause BTRFS to slow =
down
> >to a crawl.
> >
> >And it's exactly what happened to me yesterday when I was trying, on the
> >contrary, to speed it up.
> >
> >So here's the recipe for getting a "slow to the point it is unusable" BT=
RFS.
> >
> >
> >1/ Perform a clean, fresh install of a recent distro with a 3.13 kernel =
(i.e.
> >Fedora 20) and a BTRFS root filesystem.
> >
> >2/ Choose the version with a KDE interface
> >
> >3/ Configure fstab mountpoints using such options (space_cache will have=
 been
> >manually activated once):
> >
> >/ btrfs   subvol=3DFEDORA,noatime,compress=3Dlzo,autodefrag
> >
> >/home btrfs   subvol=3DHOME,noatime,compress=3Dlzo,autodefrag
> >
> >
> >4/ Use "chattr +C" to make the following directories NOCOW (move the old
> >directory elsewhere, create a new dir, make it nocow, copy files from th=
e old
> >one so they are recreated with nocow, check permissions...):
> >
> >- /home/yourself/.cache
> >- /home/yourself/.local/share/akonadi
> >
> >5/ Use IMAP mail in Kmail. Seriously process your email (it will be stor=
ed
> >using akonadi mysql)
> >
> >6/ Surf normally the web using Firefox
> >
> >7/ Install SuSE "snapper" package that will perform a FS snapshot every =
hour.
> >Configure it so it will snapshot both the root FS subvol and the /home s=
ubvol
> >
> >8/ Use the system for 24 hours and you will know that "hardly usable" me=
ans...
> >Especially every hour-on-the-hour when Kmail or Firefox will try to acce=
ss
> >files that have been recently snapshotted... Your system will be dead wi=
th
> >saturated HD access for several *minutes*
> >
> >...Hope this may help hunting this down...
> >
> >Kind regards.
> >
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Geek, n.: Circus sideshow performer specialising in the ---    =20
                         eating of live animals.                        =20

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0gKYVheFHXiqx3kAQImmBAAr/62+Gw9Y//i7qs19fK3UGCcpDpUHx9+
uULs07xVD8Vk+Lf3YmNtxGOY/KTETeto60erd4BgCIOU01Kc1WzP0dB40f4Q4XgN
V7HhmnjaCNsDoN6+yj9l/eu68/zpPIjZ/QauUex7O+iR4uUy3q4IXld42PNJ3i+1
sNsgQzIs0ex/ypN7P8qGTmLvwhd8jPb5mwpAWsLH5EbXh7ct6kD7xQPt+6/zDwHb
qGNiQ/rnNM6EBk+n3bhK2gDnINBYAq+6/SVAusDrxWNmMFP24K84H44TF91dGxK1
DvRGa0M98f16OTTCupnskjRTDqSI+C0sUF5g1/Zw99pjsmOT/cv4V7OhcDrBwIb2
vqyX0kVtJIWzmtOXUhRdeRkxMCXYY6HsTlpjYveKsjikMRFIL0XpVcq9UDVRw7MK
N6IFEz1yT+NO7qcL+29wFVgHXAho+x35vIJN0z/J/EHfbJEsl6nVowhYxn9YOPmP
9+lO8+fNwXWw7KoA5/CnCe1B+VHUK4y05+7ikH1hiBfXGgOZ5SbjoIoXWexsr8gZ
/USO86EsUSmkyaMP/NR1x/KF3bmLeHJY1vEm1qVPSMzkApbj2ySUEownt4mnhS+1
weX98f3FOZU4nJ0ER+TtoP7bG/vNmcg9F6Kj3iHyG/Ul0NZk2JO698v3SaKRT+LW
cIFUr4XJXj8=
=3c3e
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
