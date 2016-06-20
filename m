Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41692 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754273AbcFTUlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 16:41:07 -0400
Date: Mon, 20 Jun 2016 16:40:49 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160620204049.GA1986@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
In-Reply-To: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2016 at 01:30:11PM -0600, Chris Murphy wrote:
> On Mon, Jun 20, 2016 at 1:11 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > On Mon, Jun 20, 2016 at 11:13:51PM +0500, Roman Mamedov wrote:
> >> On Sun, 19 Jun 2016 23:44:27 -0400
> Seems difficult at best due to this:
> >>The normal 'device delete' operation got about 25% of the way in,
> then got stuck on some corrupted sectors and aborting with EIO.
>=20
> In effect it's like a 2 disk failure for a raid5 (or it's
> intermittently a 2 disk failure but always at least a 1 disk failure).
> That's not something md raid recovers from. Even manual recovery in
> such a case is far from certain.
>=20
> Perhaps Roman's advice is also a question about the cause of this
> corruption? I'm wondering this myself. That's the real problem here as
> I see it. Losing a drive is ordinary. Additional corruptions happening
> afterward is not. And are those corrupt sectors hardware corruptions,
> or Btrfs corruptions at the time the data was written to disk, or
> Btrfs being confused as it's reading the data from disk?

> For me the critical question is what does "some corrupted sectors" mean?

On other raid5 arrays, I would observe a small amount of corruption every
time there was a system crash (some of which were triggered by disk
failures, some not).  It looked like any writes in progress at the time
of the failure would be damaged.  In the past I would just mop up the
corrupt files (they were always the last extents written, easy to find
with find-new or scrub) and have no further problems.  In the earlier
cases there were no new instances of corruption after the initial failure
event and manual cleanup.

Now that I did a little deeper into this, I do see one fairly significant
piece of data:

	root@host:~# btrfs dev stat /data | grep -v ' 0$'
	[/dev/vdc].corruption_errs 16774
	[/dev/vde].write_io_errs   121
	[/dev/vde].read_io_errs    4
	[devid:8].read_io_errs    16

Prior to the failure of devid:8, vde had 121 write errors and 4 read
errors (these counter values are months old and the errors were long
since repaired by scrub).  The 16774 corruption errors on vdc are all
new since the devid:8 failure, though.

>=20
>=20
> --=20
> Chris Murphy
>=20

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldoVNEACgkQgfmLGlazG5y2QQCffO7V0lSnmhdDSLj7WqZ39waO
hjwAmwQT8rfXy9AnrEeX3ZEZV88DZgmC
=yXrj
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
