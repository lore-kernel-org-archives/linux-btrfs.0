Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56118 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbbKXVzp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 16:55:45 -0500
Date: Tue, 24 Nov 2015 21:55:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: subvols and parents - how?
Message-ID: <20151124215542.GT24333@carfax.org.uk>
References: <1448340960.14125.51.camel@scientia.net>
 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
 <1448400350.21291.88.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kU1KBl72y3ES5hCz"
In-Reply-To: <1448400350.21291.88.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kU1KBl72y3ES5hCz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2015 at 10:25:50PM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 08:29 +0000, Duncan wrote:
> > OK, found it on the wiki.=A0=A0It wasn't under use-cases, where I
> > initially=20
> > thought to look, but under sysadmin guide.=A0=A0Specifically, see secti=
on
> > 4.2, managing snapshots, but I'd suggest reading the entire
> > subvolumes=20
> > discussion, section 4, or even most/all of the page.
> >=20
> > https://btrfs.wiki.kernel.org/index.php/SysadminGuide
> Well I've had read that, but it's pretty vague and especially doesn't
> mentioned any of the filesystem internal implications (if there are
> any)... like I wondered before, whether this has effects on ref-links
> not being used when e.g. sending/recieving ... or on future planned
> extensions like recursive snapshots.

   No, there's no particular implications one way or the other in
terms of reflinks. Obviously, if recursive snapshots get implemented,
it'll remove some of the current awkwardness with nested subvols, but
it won't invalidate any existing setups that use the recommendations
in the Sysadmin Guide.

> > Suppose you only want to rollback /, because some update screwed you
> > up,=20
> > but not /home, which is fine.=A0=A0If /home is a nested subvolume, then=
=20
> > you're now mounting the nested home subvolume from some other nesting
> > tree entirely,
> That's a bit unclear to me,... I thought when I make a snapshot, any
> nested subvols wouldn't be snapshotted and thus be empty dirs.

   Correct. This is actually a use-case for nested subvols, and one
which snapper uses -- the target for snapshots of /foo is
/foo/.snapshots/$date, where /foo/.snapshots is a subvol in its own
right. So, if you have a subdir which you won't want to include in
snapshots of a subvol, make it a subvol itself.

> So I'd have rather that if I would simply have no /home (if I didn't
> move it to the rolled-back subvol manually)

   Yup, this is one of the main reasons for not nesting subvols.

> > 5
> > >=20
> > +-roots (dir not subvol, note the s, rootS, plural)
> > > +-root (subvol, mountpoint /)
> > > > +-boot/ (dir)
> > > > +-root/ (dir)
> > > > +-lib/=A0=A0(dir)
> > > > +-home/ (empty dir as mountpoint)
> > > +-root-snapshot-2015.0301 (dated snapshot of root)
> > > +-root-snapshot-2015.0601 (dated snapshot of root)
> > > +-root-snapshot-2015.0901 (dated snapshot of root)
> > +-homes (dir not subvol)
> > > +-home (subvol, mountpoint /home)
> > > +-home-snapshot-2015.0301 (dated snapshot of home)
> > ...
> That's more what I've had in mind...
> Actually something like this:
> 5
> |
> +-root =A0 =A0 =A0 (=3Dsubvol)
> | +-boot
> | +-home =A0 =A0 (subvo=3D/home being mounted heron)
> | +-lib
> +-home =A0 =A0 =A0 (subvol, the current version)
> +-snapshots =A0(=3Ddir)
> =A0 +-root
> =A0 | +-2015-01-14 (subvol, snapshot)
> =A0 | +-2015-09-30 (subvol, snapshot)
> =A0 +-home
> =A0 =A0 +-2015-06-04 (subvol, snapshot)
> =A0 =A0 +-2015-09-01 (subvol, snapshot)
>=20
>=20
> And it once more points to the problem of the wiki... anyone can write
> (I think even I) and it's totally unclear at the first glance how
> "[non-]official" and outdated something may be.
> Apart from the problem that many important questions (from the PoV of
> an more advanced admin that doesn't just do mkfs.btrfs and then never
> again thinks about it) :-(

   In practice, new content is checked by a number of people when it's
put in, so the case of someone putting random poorly-thought-out crap
in the wiki isn't particularly likely to happen.

> > Meanwhile, if the intention for a subvolume is simply to exclude that
> > subtree from snapshotting of the parent, as might be the case for
> > example=20
> that is in fact also use case.. so in practise I'll probably have a mix
> of (a) and (b).
>=20
>=20
> > if you have a VMs subvol, with the VM image files set NOCOW to avoid=20
> > fragmentation, since snapshotting nocow files forces cow1 (a cow at
> > the=20
> > first write of that block, before returning to nocow, because a
> > snapshot=20
> > locks the existing extents in place for the snapshot, so initial
> > writes=20
> > to a block after a snapshot /can't be nocow or it'd change the
> > snapshot=20
> > too...)
> Ah that's good to know how that works (or better said, that it works at
> all)... I've already wondered myself several times what happens when I
> snapshot NOCOW files, ... something that's I guess also missing from
> the (missing ;-) ) btrfs-end-user overview and details documentation.

   Please feel free to add the things you'd like to see. As I said
above, we do check the docs on the wiki as they're changed, so if
you're wrong on some details, it won't be a major issue for very
long. If you want to discuss details before you write something, start
a conversation -- either on here, or on IRC (or even on the Talk pages
of the wiki).

> > OTOH, if there's a chance you might want to mount that subvolume in a
> > roll-back scenario, under the snapshot you're rolling back to, then
> > it=20
> > makes sense to put it directly under ID 5 again, and mount it in any
> > case.
> Yes.
>=20
>=20
> > Then there's the security angle to consider.=A0=A0With the (basically,=
=20
> > possibly modified as I suggested) flat layout, mounting something
> > doesn't=20
> > automatically give people in-tree access to nested subvolumes
> > (subject to=20
> > normal file permissions, of course), like nested layout does.=A0=A0And
> > with=20
> > (possibly modified) flat layout, the whole subvolume tree doesn't
> > need to=20
> > be mounted all the time either, only when you're actually working
> > with=20
> > subvolumes.
> Uhm, I don't get the big security advantage here... whether nested or
> manually mounted to a subdir,... if the permissions are insecure I'll
> have a problem... if they're secure, than not.
>=20
> Of course I use insecure permissions and don't mount the subvols then
> I'd be safe in flat setup, but not in a nested setup...(where they
> subvol is "auto-mounted")...
>=20
> But that seems pretty awkward.
>=20
>=20
>=20
> Mhh I think my main question turns out to be whether the different
> layouts would have any technical (i.e. not administrative) effects...
> like the aforementioned stuff of recursive snapshots (should such thing
> ever come to life).
> But at least from the userspace tools it seems that I can move subvols
> arbitrarily and they adapt their parent IDs accordingly...

   Pretty much, yes.

   Note that the "parent" of send -p and of snapshots is not the same
relationship as the "parent" (containing subvol) of the tree
structure. This is an awkward nomenclature problem, and I'm not sure
how to fix it.

   The first meaning is fixed between a subvol and its snapshot when
the snapshot is created, and won't change, regardless of how the
snapshots are renamed/moved.

   The second meaning... actually, that doesn't change either, because
you can't rename a subvol across another subvol boundary. (I only just
realised this, halfway through the explanation).

   They're still different things, though. :)

> So I guess whatever setup one uses nested/flat/mixed... doesn't rule
> out any functionalities for the future?!

   Correct, it doesn't.

   Hugo.

--=20
Hugo Mills             | Anyone who claims their cryptographic protocol is
hugo@... carfax.org.uk | secure is either a genius or a fool. Given the
http://carfax.org.uk/  | genius/fool ratio for our species, the odds aren't
PGP: E2AB1DE4          | good.                                  Bruce Schne=
ier

--kU1KBl72y3ES5hCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVNzeAAoJEFheFHXiqx3k43UP/32Tc3Ay1Q8NVxOkrqiPHzJ7
/q1u8oLEQCevs1rwYbQFW4zsP44R2OcXkBQM7hUoBBxn1pvg2WZF+sR252opTX1K
KG0KVr3uJwgsT+uHSlNViRbfy4iLYhHfVxyd7kB4SWFuMT2FvHV32nQ2/uYHvDgJ
fP7HLXpwEPKra2yUjRanbfhfLgtooVWClg28bjIxAo7uVycxr+4kuZvkKzlxiVDk
V37vNf/PeOWL3aqG5WIPM3PYCgN1AYn/fgqmppUHjQQmv/lf9mrb9xXnDLZeBccu
bk+rLGPT957kO1z5FkWbil6AR28bZ4ZA5MfRhQyiJKCf6lWv3tNJRRuNFyFbVrwt
lXGZ4TB10no/f2J8qf5gIi0Q5IQ6ukZMzDtZa+HYqZlsGNLPRRg8qgIpyAeZBCqE
wMQ9KEKpocqAqgtgrTmpCnfIuhYGtFssUSUfq+e02GOtaD5BbbGAc3Wae7O2OfBM
AxTOio5lKfwccleKRsMlOelY3kVqVQFFZTu/bdLkYiTgVngE8cq1dJnpGI/cAgaf
gel/iEg50RIal9SajOMwKPw/uTDdPnAZB7basDESXzKpWgDEecguOmuG39IBLJyd
zzvsBGwogiV66lxq7rcV4Ueao4yhW877Z5iyw7kAMQNT37mzGnz/ZXxWEeWRYOuk
+bUo4nvT3IsyuGwcoFKc
=QBAI
-----END PGP SIGNATURE-----

--kU1KBl72y3ES5hCz--
