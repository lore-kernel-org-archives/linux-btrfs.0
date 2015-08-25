Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56188 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbbHYWie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 18:38:34 -0400
Date: Tue, 25 Aug 2015 22:38:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Message-ID: <20150825223832.GB23769@carfax.org.uk>
References: <2017000.AEG9PyVY17@zafu>
 <pan$d4557$9c42de4e$12e74017$2f692aea@cox.net>
 <1474026.LQOmDW8fG5@tethys>
 <2139681.geeI7cQtEN@tethys>
 <pan$d11ec$99fb59da$ae69a869$20c43d39@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
In-Reply-To: <pan$d11ec$99fb59da$ae69a869$20c43d39@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2015 at 10:29:15PM +0000, Duncan wrote:
> Sw=E2mi Petaramesh posted on Tue, 25 Aug 2015 16:03:55 +0200 as excerpted:
>=20
> > Le mardi 25 ao=FBt 2015 15:25:12 Sw=E2mi Petaramesh a =E9crit :
> >> Uh, I've started [btrfs check --repair] hours ago, and it has been
> >> eating 100% CPU on one of my cores since, without apparently yet
> >> finding a single error.
> >=20
> > btrfs check finally came to an end, and fixed dirs iszes.
> >=20
> > The 1st good news is that my FS didn't die in the process, the 2nd good
> > news is that I was then actually able to delete the "empty" directory
> > that couldn't be deleted before.
> >=20
> > So, it did the job ;-)
>=20
> =3D:^)
>=20
> FWIW, there was something in the corner of my mind about those root nnnnn=
=20
> numbers that was bothering me a bit, but I was focused on the errors 200=
=20
> dir isize wrong end and couldn't quite place it, so didn't mention it.
>=20
> Now I know what it was.  Roots above 256 (255?) are subvolume/snapshot=20
> roots.

   FS tree IDs for subvolumes start at 256. The rest of the metadata
trees (chunk, dev, extent, csum, UUID, top-level FS) are all small
integers under 20.

>  That's not bad in itself, indeed, it's normal (which was why I=20
> couldn't place what was bothering me about it), but with the output=20
> including a root over 24k, it does indicate that you're very likely a=20
> heavy snapshotter.

   It happens to us all eventually... ;)

> And that /can/ be a bit of a problem when doing btrfs maintenance, as=20
> btrfs is known to have scaling issues with large numbers of snapshots,=20
> dramatically increasing the time required for maintenance tasks such as=
=20
> check and balance.

   From something josef said on IRC about 6 months ago, I think
balancing is O(n^2) where n is the maximum number of shared
snapshots. I don't know what check is like for that, but I'd hazard a
guess at O(n) in the total size of the metadata.

> That's almost certainly why the check --repair took so long -- all those=
=20
> snapshots.
>=20
> My recommendation has been to try to keep the number of snapshots under=
=20
> 10K, worst-case, and preferably under 2K.  Even if you're doing automated=
=20
> snapshots at say half-hour intervals, a reasonable thinning program, say=
=20
> hourly after 12 hours, two-hourly after a day, six-hourly after two days,=
=20
> daily after a week, weekly after a quarter, ... and switch to longer term=
=20
> backups after six months or a year so older snapshots can be deleted, can=
=20
> easily keep per-subvolume snapshots to 250 or so.  250 snapshots per=20
> subvolume lets you do four subvolumes at a 1000 snapshot per filesystem=
=20
> cap, eight subvolumes at the 2000 snapshot cap.  Beyond that, and=20
> certainly beyond 10K, scaling really gets to be an issue, with btrfs=20
> maintenance time quickly increasing beyond the practical range.
>=20
> Hours for a btrfs check --repair?  You're actually lucky.  We've had=20
> reports of days, weeks... when people have tens of thousands of snapshots.
>=20
> If I'd have properly placed that nagging feeling about those root numbers=
=20
> that was in the back of my mind with the go-ahead post, I could at least=
=20
> have warned you about the time it could take.  Well, I guess I know for=
=20
> next time, anyway.  Talking about which... thanks for confirming the=20
> fix.  Very helpful for next time. =3D:^)
>=20
> Meanwhile, talking scaling, one more thing... btrfs quotas...
>=20
> Btrfs quotas just don't work well at this point, being both not always=20
> reliable, and dramatically increasing the scaling issues.

   Even after the recent rewrite? I'd expect that to drop back to
"unproven".

>  My=20
> recommendation is that if you really need them, use a more mature=20
> filesystem where they're known to work reliably.  If you can get by=20
> without them on btrfs, definitely do so, unless you're specifically=20
> working with the devs to develop and test that feature, because keeping=
=20
> quotas off will simplify your btrfs life considerably!  The devs are=20
> actively working on the problem and should eventually get it right, but=
=20
> it's just an incredibly difficult issue that has taken multiple tries.
>=20

--=20
Hugo Mills             | Great oxymorons of the world, no. 5:
hugo@... carfax.org.uk | Manifesto Promise
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV3O5oAAoJEFheFHXiqx3kX7AQALbVcVx26K9HVED+I/MxmM9s
0rcj8nwQZHf3ouPv6dLcaPxCA+0vbzYzhlvrlodhtZo5nxUdH9zHQ7QFI9YpBbbT
Alm1EMLg6WQFc7+ALpMZvAsowdT4D6Go5H2TCz3MP4DAamo/9V7TDBMr7eLtUxuJ
0+OOSziRpCt57iwgh4tJlrP2D9tjr9gKlWrvhrcKktE33N1WP2L7oEAWjzlbDVo2
U9DmUsErOXawAd+uXPsRbPfG2oclXS8GQcaRacotjGkHbl1WWiD5BmYcUn/KxegU
wrW6hrf3dD5IS0/uhUfZdEf/5fVqslFtOJT77B/dZ30FJq3bfxdyvoDUQ7RTL5g+
76jJtM1O6fgdISX1Dk9H0QdYW2qHcJlLQe7l06RN1hNeAwAvJuPNQA0dwtHgTek9
td8gGyR45jSBe4eUcN5wgsmv4SHhFkp35wprO0MP1BK9vMXPcN4RiCz4ANW9C+Ye
MT4Ud6K8pyZh6s1rJJX+oZPt/oCvKF00KZs6PkoWuiasQzR3PMgFA6uSVWg9++rl
myA0CPnX6MvXb2sZxmEBbBIs8B/gC05vgCth2XrTBZfNabqz+JOkpeGPk+LZCzVw
s6zYmkQH6Wv2uReoac+6XbURi2aF7UG4AxUVcYW85cPAzMYpQ6zTqLpCWGtXjg3c
PtFkX5QRjVxIXlJSeacG
=0GM5
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
