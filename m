From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: v0.19-35-g1b444cd btrfsck says snapshots have errors
Date: Sun, 23 Jan 2011 14:28:09 +0000
Message-ID: <20110123142809.GE29985@carfax.org.uk>
References: <20110120225256.GA4161@idallen.ca>
 <AANLkTi=7aDgTUtRB3nyLsVvdQzkYHA6iQueN9Dv-4wFm@mail.gmail.com>
 <20110123104434.GU22519@idallen.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Cc: linux-btrfs@vger.kernel.org
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110123104434.GU22519@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 23, 2011 at 05:44:34AM -0500, Ian! D. Allen wrote:
> On Fri, Jan 21, 2011 at 09:15:49AM +0800, Yan, Zheng  wrote:
> > On Fri, Jan 21, 2011 at 6:52 AM, Ian! D. Allen <idallen@idallen.ca> wrote:
> > > Still getting btrfsck errors with this:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> > > unresolved ref root 256 dir 256 index 2 namelen 5 name snap1 error 600
> > > found 49152 bytes used err is 1
> > These is caused by a design flaw, you can safely ignore them.
> 
> If it isn't an error, shouldn't btrfsck be ignoring it, not me?
> At minimum it could say "warning" and not "err is 1".

   Yes, it probably should, but there's not a great deal of point in
fixing this particular issue, because Chris is working on the all-new
(offline) repairing fsck, which should replace the current
checking-only fsck very soon now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                     --- O tempura! O moresushi! ---                     

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNPDr5IKyzvlFcI40RAhkBAJ9guAruPTdWnSL+YGmzV3ID/u8+AQCgp8p5
Qf/3BrtM7OphBF6yCdcxTAA=
=DX6g
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
