Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57163 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbFPMZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 08:25:48 -0400
Date: Tue, 16 Jun 2015 12:25:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 Balancing Request for Comments and Advices
Message-ID: <20150616122545.GI9850@carfax.org.uk>
References: <1434456557.89597618@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xGGVyNQdqA79rdfn"
In-Reply-To: <1434456557.89597618@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xGGVyNQdqA79rdfn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2015 at 08:09:17AM -0400, Vincent Olivier wrote:
> Hello,
>=20
> I have a Centos 7 machine with the latest EPEL kernel-ml (4.0.5) with a 6=
-disk 4TB HGST RAID10 btrfs volume. With the following mount options :
>=20
> noatime,compress=3Dzlib,space_cache 0 2
>=20
>=20
> "btrfs filesystem df=E2=80=9D gives :
>=20
>=20
> Data, RAID10: total=3D7.08TiB, used=3D7.02TiB
> Data, single: total=3D8.00MiB, used=3D0.00B
> System, RAID10: total=3D7.88MiB, used=3D656.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, RAID10: total=3D9.19GiB, used=3D7.56GiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

> My first question is this : is it normal to have =E2=80=9Csingle=E2=80=9D=
 blocks ?
> Why not only RAID10? I don=E2=80=99t remember the exact mkfs options I us=
ed
> but I certainly didn=E2=80=99t ask for =E2=80=9Csingle=E2=80=9D so this i=
s unexpected.

   Yes. It's an artefact of the way that mkfs works. If you run a
balance on those chunks, they'll go away. (btrfs balance start
-dusage=3D0 -musage=3D0 /mountpoint)

> My second question is : what is the best device add / balance sequence to=
 use if I want to add 2 more disks to this RAID10 volume? Also is a balance=
 necessary at all since I=E2=80=99m adding a pair?

   Add both devices first, then balance.

   For a RAID-1 filesystem, adding two devices wouldn't need a balance
to get full usage out of the new devices. However, you've got RAID-10,
so the most you'd be able to get on the FS without a balance is four
times the remaining space on one of the existing disks.

   The chunk allocator for RAID-10 will allocate as many chunks as it
can in an even number across all the devices, omitting the device with
the smallest free space if there's an odd number of devices. It must
have space on at least four devices, so adding two devices means that
it'll have to have free space on at least two of the existing ones
(and will try to use all of them).

   So yes, unless you're adding four devices, a rebalance is required
here.

> My third question is: given that this file system is an offline
> backup for another RAID0 volume with SMB sharing, what is the best
> maintenance schedule as long as it is offline? For now, I only have
> a weekly cron scrub now, but I think that the priority is to have it
> balanced after a send-receive or rsync to optimize storage space
> availability (over performance). Is there a =E2=80=9Clight=E2=80=9D balan=
cing method
> recommended in this case?

   You don't need to balance after send/receive or rsync. If you find
that you have lots of data space allocated but not used (the first
line in btrfs fi df, above), *and* metadata close to usage (within,
say, 700 MiB), *and* no unallocated space (btrfs fi show), then it's
worth running a filtered balance with -dlimit=3D3 or some similar small
value to free up some space that the metadata can expand into. Other
than that, it's pretty much entirely pointless.

   For maintenance, I would suggest running a scrub regularly, to
check for various forms of bitrot. Typical frequencies for a scrub
are once a week or once a month -- opinions vary (as do runtimes).

> My fourth question, still within the same context: are there best
> practices when using smartctl for periodically testing (long test,
> short test) btrfs RAID devices?

   I can't answer that one, I'm afraid.

   Hugo.

--=20
Hugo Mills             | Welcome to Rivendell, Mr Anderson...
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Machinae Supremacy, Hyb=
rid

--xGGVyNQdqA79rdfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgBXJAAoJEFheFHXiqx3kPsUQAIVhUdn0XRJX53BcvTiVHqMc
rmC0jtwNPg3UzobjZanoERgm9eVnXqppIyZJPzMF2FxIKVYNQ9zr1GUXSv9Oqaeq
UZxCCcbx3EVz8DBS9bWlLZ/wsJewA/IsY6uocPKlki96hpWuLRhF6WUT6yFx2Br3
p/5qzQQigK1APepCOC7dnWSqkkrq4cGfA6zvW8HeazGuI7otEthvJm/TAYJQwD+a
J9PPNSdm1U9hUY06pYVzIOfNwJZye+tlxr8oMfS2EkXaVJMz4EPSQlY5ihCV0jcC
V2tvRuI1/nZ97AAOpADHS2PxzPS3xU8danviYXtZvNx9LW8Gwsrvqieae8W0Z0wy
KMfwg9TmPbZ+OP3dVOy2jon/Uj2LO945aSWH60er6T5I5wRN63dywrRRxfDVck7L
WKrXhbXMXi+0wQdlLMbR2pI+wYwgnBTnqvzuDIhn1AA3QPfbJMXGvRgkQjY2RyMd
Kf6ZrpTGp2AJFyMegdfsL4ifzuthnKLhMSsjx5kyGQCoNuGdEbg2Oqp4bW0cZPwJ
3Fc3STVQhTn7cgq2mU0qkwjAiEtwV6nClWM92XqIxR22QCyYC9hVtAWIBG8km0f2
l8X3O1SeltdNm1MBvVKkeDaieM9vUuOXKPrhE9X2yOlpq2y0QtqVKO9L1vVpU8w1
B3wVaYw8TmbdxrQWkubB
=zORv
-----END PGP SIGNATURE-----

--xGGVyNQdqA79rdfn--
