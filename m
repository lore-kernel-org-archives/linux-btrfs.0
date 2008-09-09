From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: parity data
Date: Mon, 08 Sep 2008 18:46:46 -0600
Message-ID: <1220921206.7953.32.camel@telesto>
References: <1220766185.20018.7.camel@telesto>
	 <1220885271.8537.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/r6hTgPbjagqb0FIo9W4"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220885271.8537.31.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-/r6hTgPbjagqb0FIo9W4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 10:47 -0400, Chris Mason wrote:
> On Sat, 2008-09-06 at 23:43 -0600, Eric Anopolsky wrote:
> > Hi,
> >=20
> > A couple of questions.
> >=20
> > 1. Does btrfs currently have anything like raid 5 or 6?
> >=20
>=20
> Not yet, it might one day.
>=20
> > 2. One guy on my LUG's mailing list is really excited about the
> > potential for setting redundancy on a per-file basis.
> > I.e. /home/eric/criticalfile gets mirrored across all of the drives in
> > the filesystem but /home/eric/temporaryfile gets striped. I'm skeptical=
.
> > Is it a good idea to allow people/programs to do this?
>=20
> In general, yes.  Some files or directories are crucial, and some (swap
> for example) don't need to survive a crash.

If a disk dies in a redundant configuration, I'd like to be able to hot
replace the failed disk and keep going without any interruption. So
losing parts of the paging file would be pretty bad in that case.

Isn't a partially failed array (where some files are accessible and
others are not, without any additional filesystem damage) a weird
failure mode? Do people know how to deal with this? Do applications know
how to deal with this?

What kind of file would be important enough to keep around but
unimportant enough that it could be lost at any time while the system is
up without anyone knowing or caring?

> But, I think the flexibility should go a little further.  The goal is to
> be able to define drive groups and tie files or directory trees to the
> drive groups.  That way you can say these files go to the fastest drives
> and these files go to some other drive type, etc etc.

Let's say I have 4 100GB drives (2 fast ones and 2 slow ones). I've
restricted a performance critical directory to the two fastest drives,
currently totaling 100GB of performance critical data. The rest of the
data on the system is striped.

How much free space do I have on the filesystem? 100GB (the amount of
data I can store in the performance critical directory)? 200GB (the
amount of data I can store outside the performance critical directory if
the striping is guaranteed)? 300GB (the amount of data I can store
outside the performance critical directory if the striping is best
effort)?

I'm open to being convinced otherwise, but I think issues like this
would crop up any time the filesystem is artificially prevented from
load balancing the data across the drives.

Cheers,
Eric


--=-/r6hTgPbjagqb0FIo9W4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIxcd2e2L37HVup3ARAnKnAKDWqjj6dKsYvVWUbEaejvrq5pzvlQCbBUi2
+rqktlwVqlqE9fknZ6TtED4=
=CL0E
-----END PGP SIGNATURE-----

--=-/r6hTgPbjagqb0FIo9W4--

