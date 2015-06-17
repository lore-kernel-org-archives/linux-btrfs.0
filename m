Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59855 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbFQLBD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 07:01:03 -0400
Date: Wed, 17 Jun 2015 11:01:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sander <sander@humilis.net>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Message-ID: <20150617110101.GR9850@carfax.org.uk>
References: <20150617071654.GI16468@merlins.org>
 <20150617101121.GQ9850@carfax.org.uk>
 <20150617105835.GA28982@panda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMM+kVNHGkMezEqK"
In-Reply-To: <20150617105835.GA28982@panda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMM+kVNHGkMezEqK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 17, 2015 at 12:58:35PM +0200, Sander wrote:
> Hugo Mills wrote (ao):
> > On Wed, Jun 17, 2015 at 12:16:54AM -0700, Marc MERLIN wrote:
> > > I had a few power offs due to a faulty power supply, and my mdadm raid5
> > > got into fail mode after 2 drives got kicked out since their sequence
> > > numbers didn't match due to the abrupt power offs.
> 
> > > gargamel:~# btrfs fi df /mnt/btrfs_pool1
> > > Data, single: total=8.29TiB, used=8.28TiB
> > > System, DUP: total=8.00MiB, used=920.00KiB
> > > System, single: total=4.00MiB, used=0.00B
> > > Metadata, DUP: total=14.00GiB, used=10.58GiB
> > > Metadata, single: total=8.00MiB, used=0.00B
> > > GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> > > I'll do a scrub later, for now I have to wait 20 hours for the raid
> > > rebuild first.
> > 
> >    You'll probably find that the rebuild is equivalent to a scrub anyway.
> 
> He has mdadm raid, which is rebuilding. This is obviously not equivalent
> to a btrfs scrub.

   Ah, thanks for the correction. Note to self: read more carefully
before replying.

   Hugo.

-- 
Hugo Mills             | If you're not part of the solution, you're part of
hugo@... carfax.org.uk | the precipiate.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--XMM+kVNHGkMezEqK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgVNtAAoJEFheFHXiqx3kDE8P/0BtC0hF07QK+U9C5LJx/Cxy
adcoJj2qIsQaJ8m2WE3jmRA+I1fNWTS/mxwFK+tqEzha2294gYdFGStK29P4wwU2
7mlFvN7MalS8QAxAidZdFXNWzoAK6aimH1u8pXCVtW+Lzb2AzuZUZPGTMi7YnglK
aqXeolG6sYouBe//h+wtotunOReTS1sPlFo4bamGa8vC0Owc3h4vqOWITvvH9hLg
B6wZVX42nrFvaakqedPqjKUI7VYu22Vjaww3BaAlZvszu5Y6MKmLSNOpD7gaHs2h
LP114P27Lfnqz8gOHo2jTkfi00FtmnwgE+VfjEEsBtQeYXgjV6XqjOPPu6V5H2Lw
hXCPD0RHawQ+dpcR4yVXYbC29XGWUN1LQHWPYQoQIYK6jfR4nVqWqK6QZ0kI/iXV
oogOLCuPvkyjnhWlrNwtVsI9CE5vsOFeKoQM8wLImS7fsKJy6ISP+sYCtv22A0fA
dERn1gj5bEPm4rDIzV/COASs2i6Jj99uKh28b7DJgQhMsjoi7oHuz7j66vEZYL0e
aQNeD+4XAR4tHNKlTiQaXrpoWKDqKO3vetLVKCNQSJBeu/+L9WPzcoJg5TSe7FAi
v0sd8y+ChA+4lxS9LGVX2dPbyMTj6oZM0WC9aOFB7pqfA7+p2/49YPkDBknteFn6
wOTxBEmM0Q5Fjn/kawrk
=MaBt
-----END PGP SIGNATURE-----

--XMM+kVNHGkMezEqK--
