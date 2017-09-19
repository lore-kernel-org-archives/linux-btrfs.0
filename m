Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from s17634251.onlinehome-server.info ([87.106.5.14]:56626 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750973AbdISTJv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 15:09:51 -0400
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Storage and snapshots as historical yearly
Date: Tue, 19 Sep 2017 21:09:44 +0200
Message-ID: <2011839.WjnFlrvFTq@pcsenen>
In-Reply-To: <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
References: <9208764.SjP1vfhOIA@pcsenen>
 <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1670815.1mBKNYPJ9K";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1670815.1mBKNYPJ9K
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi Austin,
Thank you very much for your answer.
I comment a little on your suggestions in the context.

El lunes, 11 de septiembre de 2017 14:49:05 (CEST) Austin S. Hemmelgarn=20
escribi=C3=B3:
> On 2017-09-11 14:17, Sen=C3=A9n Vidal Blanco wrote:
> > I am trying to implement a system that stores the data in a unit (A) wi=
th
> > BTRFS format that is untouchable and that future files and folders crea=
ted
> > or modified are stored in another physical unit (B) with BTRFS format.
> > Each year the new files will be moved to store A and start over.
> >=20
> > The idea is that a duplicate of disk A can be made to keep it in a safe
> > place and that the files stored there can not be modified until the
> > mixture of (A) and (B) is made.
>=20
> Before I get into anything further, I would like to comment that this is
> a very odd use case.  Yearly granularity doesn't make sense for backups
> unless you generate very little data throughout the year (otherwise
> backups will take forever) and can afford to lose multiple months of
> that data.
>=20
> The timescale you're talking about combined with the requirement that
> files not be modifiable on A except during the times when you sync
> changes indicates you will probably be much better served by proper
> off-line archival storage than some online configuration as you appear
> to be trying to create.

Totally agree with you, although it really is not the objective, for that I=
=20
use Bareos as backup system. It is simply because I need to have stored alm=
ost=20
2 Terabytes and be able to have a copy of the data outside the enclosure an=
d 3=20
years of duplicate disks and be able to access almost instantaneously the o=
ld=20
data.
With a backup system it would take several days to restore the entire syste=
m=20
or several hours to rebuild the file system and restore the file you need. =
While=20
with an image from last year you would only have to restore a year at best.

>=20
> > I have looked for information on this but I do not see it very clear. B=
oth
> > "SEND" and "RECEIVE" do the opposite case to what interests me.
>=20
> If you can afford to operate at a shorter timescale (even monthly), then
> BTRFS snapshots plus send and receive probably are one of the best
> options.  Perhaps you could explain your understanding of send and
> receive and why you think it won't work, and I (and possibly other
> people on the list as well) could confirm whether or not you understand
> correctly.

That is another long-term goal that I would like to implement, since I have=
=20
seen that it can be combined with external storage and able to move the dat=
a=20
through snapshots. It uses little bandwidth and seems to be more immediate=
=20
than the Bareos, although it would leave both systems for security, since I=
=20
speak of very sensitive and important data to lose them.

>=20
> > I have also seen that you could try to get a RAID 0 but I am afraid that
> > the data in A will not remain intact if the system performs a "BALANCE"
> > at some point and mixes data between (A) and (B).
> >=20
> > It is assumed that both the (A) and (B) data will be displayed in the s=
ame
> > structure transparently, for example in "/ home".
> >=20
> > -------------------------------
> >=20
> > |             HOME            |
> > |=20
> > | ------------   ------------ |
> > |=20
> > | | DISK (A) |   | DISK (B) | |
> > | |=20
> > | |  BTRFS   |   |  BTRFS   | |
> > |=20
> > | ------------   ------------ |
> >=20
> > -------------------------------
>=20
> What you are describing here is called an overlay or union mount.
> Source A would be your lower directory, and B would be your upper
> directory.  Unmodified data is passed through from the lower directory
> until a file is changed.  When changes are made to the overlay mount,
> they are reflected on the upper directory.  Special files called
> 'whiteout' files are used in the upper directory to represent deleted ite=
ms.
>=20
> Unfortunately, I don't know of any overlay mount implementation that
> works correctly and reliably with BTRFS.  I know for a fact that
> OverlayFS (the upstream in-kernel implementation) does not work, and I
> believe that AUFS3 and UnionFS (the third-party options that are used by
> most LiveCD's) don't work either.  UnionFS-FUSE (a userspace
> implementation completely unrelated to UnionFS) might work, but I've
> never tested it and it will likely have performance issues because it's
> implemented in userspace.  As far as I know, whiteout support is the
> primary missing piece here, but I may be mistaken.
>=20
> Alternatively, this could be done with a seed device.  The concept is
> pretty similar to an overlay mount, but it operates at a lower level,
> and it's a BTRFS specific feature.  Unfortunately, it's not well
> documented, and I'm not confident that I could explain how to do it
> correctly.

This part does seem to me very interesting, since one of your colleagues ha=
s=20
commented on the topic of using "Seed" with BTRFS, which I am seeing its=20
operation; and I can see how this would be OverlayFS, since I think the oth=
er=20
options are not very generalized.

Thank you for the explanation and I will keep you informed if I can get=20
something clean, because if documenting my experience I can contribute=20
something and I will be satisfied.
Greetings.

=2D-=20
	Sen=C3=A9n Vidal Blanco - SGISoft S.L.
=20
	Tlf.: 986413322 - 660923711
	GPG ID 466431A8AF01F99A
	http://www.sgisoft.com/
=2D-
=20

--nextPart1670815.1mBKNYPJ9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWcFreAAKCRBGZDGorwH5
miuNAJ0T85UAION5nAbK6gDK1uk1JGGkVwCfW3yP65OrqIcnEFU94N+eUODGOs8=
=lshM
-----END PGP SIGNATURE-----

--nextPart1670815.1mBKNYPJ9K--

