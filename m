Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37124 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3LRINe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 03:13:34 -0500
Date: Wed, 18 Dec 2013 08:13:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Garry T. Williams" <gtwilliams@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs RAID1 File System Grew Something Extra
Message-ID: <20131218081333.GJ11281@carfax.org.uk>
References: <1617587.38j2eTuIdt@vfr>
 <52B10C85.90405@oracle.com>
 <17576852.FmZ5tQlVm8@vfr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YPJ8CVbwFUtL7OFW"
In-Reply-To: <17576852.FmZ5tQlVm8@vfr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YPJ8CVbwFUtL7OFW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 11:12:25PM -0500, Garry T. Williams wrote:
> On 12-18-13 10:46:29 Anand Jain wrote:
> > On 12/18/2013 10:03 AM, Garry T. Williams wrote:
> > > I have been using btrfs for my /home partition on my home machine for
> > > a few years now.  I created the file system RAID1 using two disk
> > > partitions.  Recently I noticed btrfs fi df shows extra Data, System,
> > > and Metadata allocations.  And btrfs fi show indicates extra
> > > allocations on one of my disk drives accounting for the 20 MiB
> > > allocation in the df display.
> >
> >   this is a known bug in mkfs.btrfs, the workaround for now is
> >   to run balance on FS having some data. so that unused group-
> >   profile will go away.
> 
> Thanks.
> 
>     garry@vfr$ sudo btrfs balance start /home
>     Done, had to relocate 50 out of 50 chunks
>     garry@vfr$ sudo btrfs filesystem df /home
>     Data, RAID1: total=22.00GiB, used=21.02GiB
>     System, RAID1: total=32.00MiB, used=12.00KiB
>     System, single: total=4.00MiB, used=0.00
>     Metadata, RAID1: total=1.00GiB, used=419.60MiB
> 
> Hmmm.
> 
> Well, it's better, but the extra allocation for System is baffling.  I
> believe that this happened sometime after creating the file system.

   It won't be spontaneously created -- it'll have been there since
the beginning. The first system chunk is "special" and is skipped
during balances, so it won't get cleaned up like this.

> Also balance on a RAID1 file system with exactly two drives doesn't
> make much sense to me.  Why would any "chunks" have to be relocated?
> I'm clearly missing something here.

   That's what balance does -- it rewrites every single piece of data
on the filesystem. In this case, you could have used a filter to
balance (and hence remove) only the single chunks:

btrfs balance start -mprofiles=single -dprofiles=single -sprofiles=single /mountpoint

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- One of these days, I'll catch that man without a quotation, ---   
                        and he'll look undressed.                        

--YPJ8CVbwFUtL7OFW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrFZLFheFHXiqx3kAQIyDA/+LngnKRXOIMm6WOUVCkQvt6xv0voj2x0p
ZKWPdbnW5GWXJ7e3MaGASSreiZafs1ZNbDwWp5S8Mi2NWAvvTJFwtupVtROB8VYc
mTFwowrnK1Cty0DWDEB1nnjP6zXsSUh6OSUsaWVtyYIknP8DTAsRzwcMRChBBBwA
oixMr7e5hoKQRV+09rpDv3eqYi/lc7tANgP98MHflxS8pcOou676wrICnEADGNwR
QLmg+Rq4Q2+drhBAHLEMXGUS6og7SMu+81aryMjIM50uYznYkQU+tM1BAmbw97qX
5ZnZL/lOvmKqb318aeRTxXc39wAKQKX4hL681ljaB9fZesyUI8xnPZbQlEHIE2zi
RaNp3qUfMDxWJxhXM6m+Y/4Gneg46nABsxqEluQJKoYkHcNgNQGfmH5+K//sdtgx
iJcD0Sbcrhd+HoZ5cdh2G9+5DzE3EHDYD2ky9YFDvwVPDlvb7VH4nBInTxvJ7osW
zMgp3l6teotNo+Zz1HCZgYsHb4FiBtt2yLHBzB2POykbBkBC4qnTWwYSu7jNrFRN
RtNvBHAbtw+eqFrvcVZdBJn9QEDMd8ovS8TG7UrO9X4vNjaeXq6ti2eMPlsDWHqP
LwdKJxvcpp0Gq3GkriL8H7140OidcylY7kQ3dA4M3jIcMYjz2dibSD8IXS8Y5Ifv
LbiumZeE4lc=
=sF5c
-----END PGP SIGNATURE-----

--YPJ8CVbwFUtL7OFW--
