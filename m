Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47135 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3JKJzJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 05:55:09 -0400
Date: Fri, 11 Oct 2013 10:55:02 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro
 mounts
Message-ID: <20131011095502.GR28147@carfax.org.uk>
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
 <525750B4.4090009@cn.fujitsu.com>
 <5257C378.1060507@giantdisaster.de>
 <20131011153546.424d69c4@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ivHc2SZskddb40s2"
In-Reply-To: <20131011153546.424d69c4@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ivHc2SZskddb40s2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 11, 2013 at 03:35:46PM +0600, Roman Mamedov wrote:
> On Fri, 11 Oct 2013 11:23:04 +0200
> Stefan Behrens <sbehrens@giantdisaster.de> wrote:
> 
> > On Fri, 11 Oct 2013 09:13:24 +0800, Wang Shilong wrote:
> > > On 10/11/2013 01:40 AM, Ilya Dryomov wrote:
> > > 
> > > I have a question in my mind.
> > > 
> > > Can we reach a state that there is operation in progress when filesystem
> > > has been readonly?If we do cancel operations on a ro filesystem, we should
> > > get "No operations in progress" .
> > 
> > Well, it's arguable what ro means. No write to the devices at all?
> 
> If I had an FS image and mounted it as -o loop,ro I'd simply expect md5sum of
> that image to match before mount and after unmount, i.e. no writes at all.
> Really, how can one argue with what "read only" means? If it will mean
> something else than a complete absence of writes, then how can we mount
> devices or FS images to do forensics, etc? Or do a recovery from a difficult
> corruption or try to debug an FS crash.

   I think the issue here is that with ext3,4 the FS data structures
can be in an inconsistent (i.e. broken) state unless you do the
journal replay, so you're left with the choice of "replay the journal
and have a working filesystem that you can't write to", or "don't
modify anything, and have a useless filesystem with errors you could
fix with the information in the journal".

   Fortunately, we don't (well, shouldn't) have that issue in btrfs --
if we don't replay the log, we've still got a consistent FS, so it's
much easier conceptually to mount an FS read-only (with the proviso
that a RO mount may be missing some data that was saved earlier, but
you'll get that back if you allow the log reply with a rw mount
later).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Gentlemen!  You can't fight here! This is the War Room! ---     

--ivHc2SZskddb40s2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlfK9lheFHXiqx3kAQIWihAAnuK9CQlwYqyEmyfHi1+1pBpToImWbj1i
zHNDMW3uJMCamVH2XADD4uN1EoCMFakw1T/2AHHuPqnR1uIBByD47dnw3noKtWEn
P7GjD8kQoPvoBDOKP3Tp3+7CI3GnKxbcQ7QFswPKOmT/NmXDab8Aj0Qry4AENWff
0gFw7RrbPLhs1AIA4tOlhs4YlACOduEHc5g8tmTUkQMlcvQAW9+BbeS9+zDjHquk
BTwoo3w0q+Z7gI8ZYu4I7nDSLcF/83f3ARpXDU7eFSrLL8I7TjVMswoy/IcjBuCm
ZwZQCRdrtUC5duof8kD7Uozf4lUyWnaQkNnM3PuR6l0umsivKjYxSPHcOFEBdV9D
ptCvf23tNv20ZolUYKmN0LComzQxvcTfMyVQeSTlybckXhPjw9x4Siv1y3wYHN8+
Rymc6vV6LbFnyZY+Fc7LsFSsliBuydTWLILDTVytsu3GaL7Dqu3PQEVxgqa9upNO
2IqSuLpZtNEsJpDCOMPwSkwMFpu4uVGaew3nQ7NJDmnOPwBGpHflhDiVG/YWGgRA
7etMkKAEOoGBHOxVvB5ioW/J0iFHygQ7kEbNwqjq/MkIne+Qa3zoQXLrFmou4uE/
ZjzeYe51TPdcoLcotoDOZ2rdEehHtu5mqFgXVjA3ufE3NSUO9fBzP1ca23ZGpjD3
U+PQeFrngsk=
=HRCE
-----END PGP SIGNATURE-----

--ivHc2SZskddb40s2--
