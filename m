Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46947 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761AbaJ0Ej0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 00:39:26 -0400
Date: Mon, 27 Oct 2014 00:39:25 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141027043924.GI17395@hungrycats.org>
References: <20141016113337.GC22943@twin.jikos.cz>
 <20141020163403.GW22943@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
In-Reply-To: <20141020163403.GW22943@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 06:34:03PM +0200, David Sterba wrote:
> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
> > I'd like to make it default with the 3.17 release of btrfs-progs.
> > Please let me know if you have objections.
>=20
> For the record, 3.17 will not change the defaults. The timing of the
> poll was very bad to get enough feedback before the release. Let's keep
> it open for now.

I don't have hard data, but I do have disturbing soft data:

	12 btrfs filesystems with various mixed workloads

	4 of those w/skinny metadata (converted with btrfstune -x)

	3 of those have processes or the entire filesystem hanging
	every few days, triggering watchdog reboots

I'm still trying to find the smoking gun, but it looks like there's a
problem that only shows up when skinny metadata is enabled (or possibly
one that only shows up when both skinny and non-skinny are mixed?).

One thing that may be significant is _when_ those 3 hanging filesystems
are hanging:  when using rsync to update local files.  These machines are
using the traditional rsync copy-then-rename method rather than --inplace
updates.  There's no problem copying data into an empty directory with
rsync, but as soon as I start updating existing data, some process (not
necessarily rsync) using with the filesystem gets stuck within 36 hours,
and stays stuck for days.  If I don't run rsync on the skinny filesystems,
they'll run for a week or more without incident--and if I then start
running rsync again, they hang later the same day.

When I get kernel stacks they show ~50 processes stuck all over the
btrfs metadata manipulation code.  If someone wants to wade through
these I can collect them easily enough.

The 4th skinny-metadata machine--the one that doesn't hang often--is
the only one that isn't using rsync to receive files from elsewhere.
It's also the busiest filesystem (in iops/sec) with the largest variety
in its workload, so all things being equal it should be encountering
more random btrfs problems than the other three.

Some of my machines have multiple filesystems, some with skinny and
some without.  I've tried moving the rsync destination tree to the
non-skinny filesystems on those machines, and in those cases I was able
to complete several rsync updates without incident.  That seems to rule
out any system-level problem.

The 8 filesystems without skinny don't have the hang problem.  They have
had a variety of other issues, but not hangs alone.  Currently 3.17 +
stable-queue patches fixes all the problems I've encountered so far with
the non-skinny filesystems, so the skinny filesystems are now earning
most of my attention.

With this small sample size and data collection rate I admit I could
just have a spurious correlation.  The data also supports conclusions
such as "Western Digital hard drives cause hangs" or "filesystems
created in August 2014 cause hangs."  I'd encourage anyone with the
intrastructure set up to do a larger-scale test to see if this is--or
is not--reproducible.

--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRNzHwACgkQgfmLGlazG5yahgCg5e6kbO9NxIGL4sbfIGeHQ6mK
kjIAoKcahGP2oeC5TgpjvMVmSL63R/Dr
=78LD
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
