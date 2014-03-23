Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58180 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaCWVUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 17:20:31 -0400
Date: Sun, 23 Mar 2014 14:20:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Message-ID: <20140323212030.GB18293@merlins.org>
References: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net> <20140323114712.GC25400@carfax.org.uk> <20140323162000.GK12833@merlins.org> <20140323162825.GF25400@carfax.org.uk> <20140323170314.GM12833@merlins.org> <20140323173409.GG25400@carfax.org.uk> <20140323191017.GB3732@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <20140323191017.GB3732@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 23, 2014 at 12:10:17PM -0700, Marc MERLIN wrote:
> On Sun, Mar 23, 2014 at 05:34:09PM +0000, Hugo Mills wrote:
> >    xaba on IRC has just pointed out that it looks like you're running
> > this on a mounted filesystem -- it needs to be unmounted for
> > btrfs-image to work reliably.
> =20
> Sorry, I didn't realize that, although it makes sense. btrfs-image really
> should fail though:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D72791
>=20
> I got the image, but it's 1.5GB (1TB filesystem), but kernel bugzilla tim=
es
> out after 1% of upload (repeatedly)
> Placeholder bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D72801

Here is the image:
http://marc.merlins.org/tmp/pool2.image

After taking that image for you, I got the filesysetm to recover:
legolas:/mnt/btrfs_pool2# for i in *weekly*; do btrfs subvolume delete $i;
done
Delete subvolume '/mnt/btrfs_pool2/home_weekly_20140309_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/home_weekly_20140316_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/root_weekly_20140309_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/root_weekly_20140316_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/tmp_weekly_20140309_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/tmp_weekly_20140316_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/usr_weekly_20140309_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/usr_weekly_20140316_00:06:01'
Delete subvolume '/mnt/btrfs_pool2/var_weekly_20140309_00:06:01'
^A Delete subvolume '/mnt/btrfs_pool2/var_weekly_20140316_00:06:01'

legolas:/mnt/btrfs_pool2# btrfs fi df .
Data, single: total=3D800.42GiB, used=3D636.91GiB
System, DUP: total=3D8.00MiB, used=3D92.00KiB
System, single: total=3D4.00MiB, used=3D0.00
Metadata, DUP: total=3D10.00GiB, used=3D9.50GiB
Metadata, single: total=3D8.00MiB, used=3D0.00
legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=3D0 /mnt/btrfs_poo=
l2

Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=3D0
  Done, had to relocate 91 out of 823 chunks

legolas:/mnt/btrfs_pool2# btrfs fi df .
Data, single: total=3D709.01GiB, used=3D603.85GiB
System, DUP: total=3D8.00MiB, used=3D88.00KiB
System, single: total=3D4.00MiB, used=3D0.00
Metadata, DUP: total=3D10.00GiB, used=3D7.39GiB
Metadata, single: total=3D8.00MiB, used=3D0.00

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBUy9QHn4xUKZ2O+kBAQJ6RwP/SYILovA0v91jBgs5QpmYUi0w0SMe7TEG
gnzBK3WMQtRKvQefQtDEFaTQgpdaFTtxFbDNiuU5cBZu4xY7pW1FIA8jo2MRS1Ev
rWcOBHtEN5qUxnskqvf8xLE3ZC3Muj+q4EObbr2lO+GY3Otna/WR55xZpwC2Q+MS
ogAcQIe9w0U=
=fqe+
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
