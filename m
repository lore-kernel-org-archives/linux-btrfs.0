Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46807 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932493AbaJWDJa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 23:09:30 -0400
Date: Wed, 22 Oct 2014 23:09:28 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Message-ID: <20141023030928.GA17380@hungrycats.org>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
 <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
 <20141022200812.GA17395@hungrycats.org>
 <5448157B.8030102@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
In-Reply-To: <5448157B.8030102@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 01:37:15PM -0700, Robert White wrote:
> On 10/22/2014 01:08 PM, Zygo Blaxell wrote:
> >I have datasets where I record 14000+ snapshots of filesystem directory
> >trees scraped from test machines and aggregated onto a single server
> >for deduplication...but I store each snapshot as a git commit, not as
> >a btrfs snapshot or even subvolume.
> >
> >We do sometimes run queries like "in the last two years, how many times
> >did $CONDITION occur?" which will scan a handful files in all of the
> >snapshots.  The use case itself isn't unreasonable, although using the
> >filesystem instead of a more domain-specific tool to achieve it may be.
>=20
> Okay, sure. And as stated by others, there _are_ use cases that are
> exceptional.
>=20
> But such an archival system most likely does not _need_ to be
> balanced etc with any frequency, or likely ever because it isn't
> experiencing churn from dynamic use.
>=20
> In the world of trade-offs, trade-offs happen.
>=20
> The guy who cited the 5000 snapshots said they were hourly and taken
> because he might remove an important file or something. This is
> _way_ more action than the feared condition.
=20
> When an over-abundance of caution passes beyond reasonable
> expectations, performance will suffer. The system is immaterial, the
> rule holds.
>=20
> What's worse is it becomes very like "security theater" only its "a
> backup show" where no actual backing up is really happening in any
> useful sense. And god save you picking which version of a file was
> the last "good one".
>=20
> So in your use case, your git repository of snapshots isn't actually
> "live" on the production server you are archiving, right?

I'm not sure if this question is directed at me or 5000-snapshots-guy.
5000-snapshots-guy was not using git.  I'd say he's using btrfs snapshots
to do a job git is much better at.

My 14K-snapshot git repo is on my production server.  The data in the repo
is aggregated to that server from many other smaller (tiny) machines.
Each smaller machine's data is replicated to the git working directory
and a git commit generated from it.  After the commit is created,
we replace the working tree with the next machine's data and repeat.

The entire git repo is replicated by git fetch/push to a couple of other
servers, so if the main git repo goes down we just swap it with one of
the clone servers in a few minutes.  No btrfs snapshots are involved.
One of the clone servers doesn't even have btrfs at all.

git's packing algorithm does a much more thorough job of compression and
deduplication than a mere filesystem can.  We can store 3,000 current
snapshots of 15GB of raw data in 10GB of disk space, and another 11,000
older snapshots in 25GB.  I don't think btrfs snapshots can do better,
or even get close, to that kind of storage efficiency.

The point I was making was that btrfs snapshots aren't the best tool,
or even a reasonably good tool, for this particular use case (5000
snapshots of a single subvolume on one server).

> So too, it would be reasonable to btrfs send periodic snapshots to
> an archive system, retain lots and lots of them, and expect
> reasonable performance of your queries.
>=20
> And you cold expect reasonable performance in your maintenance.
>=20
> But "reasonable performance" in the maintenance case is massively
> different than reasonable performance in use cases. Indeed if you
> try to balance multiple terabytes of data spread across thousands of
> snapshots you'll be taking a lot of time. A _perfectly_ _reasonable_
> lot of time for the operation at hand.

=2E..unless you are balancing because you're replacing a RAID1 disk.
That's a good reason to be wary of too many snapshots even if the data
is fairly static.

> But if you expect to be able to do maintenance (like btrfsck your
> production box with its 5k snapshots) in just a few minutes when
> you've got logarithmic-rate meta data to shuffle through... well
> good luck with that.

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRIcWgACgkQgfmLGlazG5yslQCghDQNAdfEAKNohRQ46u0ekJdc
4UQAoL86STAnqdIdQNrxW74u3GWiqM3n
=MbhC
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
