Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46516 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaBGXF7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 18:05:59 -0500
Date: Fri, 7 Feb 2014 15:05:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Can you keep reflink relationship during a copy/backup to another filesystem?
Message-ID: <20140207230558.GA9265@merlins.org>
References: <20140129075025.GM14998@merlins.org> <20140129080514.GQ3314@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
In-Reply-To: <20140129080514.GQ3314@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2014 at 08:05:14AM +0000, Hugo Mills wrote:
> On Tue, Jan 28, 2014 at 11:50:25PM -0800, Marc MERLIN wrote:
> > So I used to use hardlinks to do historical backups of the same filesys=
tem
> > but I know it's preferable to use refllink with btrfs to avoid having t=
oo
> > many hardlinks.
>=20
>    If you use btrfstune to set the "extended inode refs" option on the
> device, then there's no hardlink limit (and the limit was only on the

I'm not too clear about that part:
https://btrfs.wiki.kernel.org/index.php/Btrfstune
doesn't seem to match what you're saying.

> number of hardlinks to the same thing *in the same directory*).

I didn't catch the 'same directory' part. I used hardlinks.py to compare
all my files from many backups across filesystems and hardlink files
together if they were the same.
You're saying that I could have 500 hardlinks to the same file as long as
they are in 500 different directories, and that this is not a performance
problem or limitation for btrfs (maybe anymore? I could swear I had issues
with this in the past).

If the limit is now hardlinking many times to the same file in the same
directory, I don't actually have a need for that use case.
=20
> > But if I need to backup this filesystem to another one some other way t=
han
> > btrfs send/receive (let's say cp -a, tar, or rsync), is it correct to s=
ay
> > that reflink relationships will be lost and my data will take more spac=
e?
> >=20
> > That is unless the target filesytem can do deduplication like btrs now =
can?
> > (I haven't tried it yet, but it's about time that I do)
>=20
>    Correct.

Thanks.
I just noticed that on the fly deduplication wasn't in 3.12 yet, so I'm
better off keeping my hardlinks for backups since it's easy to keep that
relationship when copying my backup tree to a backup device (backups of
backups, of course, y'all don't do that? :) ).

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBUvVm1n4xUKZ2O+kBAQJsVwP+KaGdnDnjF7AE6q8R5oWtD9Renlvh+yst
B7aqmpGf6L81zSfnKzRjb9gGMHogKrvgnIQegM1pAgjJ3GfMIPCtdWiOAJXserNr
rMz7EptSVVdkAwNUDYwLAJ5aWlDqm70d356R6eJdc2i3VR1uf0fBVxcs7/078qQ8
snjbhDVTkIE=
=wtBE
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
