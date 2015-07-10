Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52150 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbbGJTLK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 15:11:10 -0400
Date: Fri, 10 Jul 2015 19:11:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Send/Receive Use Case
Message-ID: <20150710191109.GK10539@carfax.org.uk>
References: <F2771637-3D78-4332-AB96-993069114030@up4.com>
 <20150627142132.GI16065@carfax.org.uk>
 <E737B6C9-CC16-490A-B14C-E2D364BA2805@up4.com>
 <5A05A6DE-A405-4C88-9F7D-C7510048E067@up4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/rDaUNvWv5XYRSKj"
In-Reply-To: <5A05A6DE-A405-4C88-9F7D-C7510048E067@up4.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/rDaUNvWv5XYRSKj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2015 at 03:03:27PM -0400, Vincent Olivier wrote:
> actually I have another question : is it posssible for a RAID0 fs to =E2=
=80=9Creceive=E2=80=9D from a =E2=80=9Csending=E2=80=9D RAID10 ?=20

   Yes, definitely. I do my backups from RAID-1 to single. The send
stream format is based on files, not on the underlying raw storage.

   Hugo.

>or do they need to be of the same replication scheme too ?
>=20
>=20
>=20
> > On Jun 27, 2015, at 10:34 AM, Vincent Olivier <vincent@up4.com> wrote:
> >=20
> > ok i=E2=80=99ll go home and rethink my life then ;)
> >=20
> >> On Jun 27, 2015, at 10:21 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >>=20
> >> On Sat, Jun 27, 2015 at 10:04:28AM -0400, Vincent Olivier wrote:
> >>> Hi,
> >>>=20
> >>> There are 4 things I=E2=80=99m not sure about re:send/receive.
> >>>=20
> >>> 1) Is it possible to first copy things on a file system using rsync a=
nd then use send-receive ? And to subsequently mix rsync and send-receive ?=
 Provided that snapshots are made accordingly.
> >>=20
> >>  Probably. It depends on exctly how you want to use them.
> >>=20
> >>> 2) Is possible to =E2=80=9Csend" a snapshot diff to disk and then =E2=
=80=9Creceive" it from the said disk into a remote filesystem ? I have two =
very large and physically distant btrfs filesystems. It would be more econo=
mical to juste dump snapshot diffs to disk for transport instead of the net=
work.
> >>=20
> >>  Yes, that's perfectly possible.
> >>=20
> >>> 3) How are =E2=80=9Cconflicts=E2=80=9D handled by send-receive if at =
all ?
> >>=20
> >>  There are no conflicts possible, due to the requirement of all the
> >> subvolumes involved in the send/receive process being read-only.
> >> (Actually, that's not quite true -- you can make a subvolume
> >> read/write, and then read-only again. In that case, the receive will
> >> probably fail, leaving the received subvolume in a partially-created
> >> state).
> >>=20
> >>> 4) If a file is created, modified and then deleted in-between two
> >>> snapshots is it ignored by send/receive or does send/receive
> >>> "re-enacts=E2=80=9D the journal exactly ?
> >>=20
> >>  It'll be ignored. The FS doesn't keep track of how it reached a
> >> particular state -- only what that state is.
> >>=20
> >>  Hugo.
> >>=20

--=20
Hugo Mills             | UNIX: Japanese brand of food containers
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--/rDaUNvWv5XYRSKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVoBjMAAoJEFheFHXiqx3kYPMP/1C+thBDlmy7ZSd2rlD5/qeB
qGc7ud2kJKgTy7rAeRVgWUdgKI9AiuOQexY7brpantJI9GLlYUWSWXtB5TZywLtf
kUZ9kLoZIYO9oa+hoNGnIsqNgrQTHMgUrCJ47LBjuC1TI3VyNWZeC8juPltGvBEr
P8KyGb+otIMFRSWehHMPu22TuwbuPZFMfOdG/5EFCYHraZiER89DUUnqqDxC9RSN
jp3TprWx3RGlvgPHBEI1kPvAV/gDO1SAfTz+mlzfdyxoPO/TdqBrizItAB1CnYHL
kPCawnZN0FNHn8xLg7xyrlz90H8p0mynGbEfyz29e43q1BVA7bJvO2qxNiTHr3zH
2BQRf0jDUfH7n9JAR4rbVi45dNXAYIJYIa+xydQEC/YECtqvZaAdQJsiVx+Joa2r
3qANYEoEKGCvVISjAZBfGotCeCB8u7zQzYx4w+o1tsvmilOYILeIb3Idlw1qj7wM
J9FWG9fw2RtmjEx1WoR48LfqzRPLpZgPhGQ8NAXxgYNs4JWN/F2CamQLvElzely9
E4m1ZyExs44HQuylDbb9lFk2PEt4pZNWCgisDupz3eZR41FBZZHVXFGq0rsrrTC/
ObGkudVEGlgNMIDYW51nKf9isZfMRNTq5S6dn5+xOSgXMD21ZsY6Slwb61M9qX8O
ir9NFlE1+pMJTA0VAumf
=d+bw
-----END PGP SIGNATURE-----

--/rDaUNvWv5XYRSKj--
