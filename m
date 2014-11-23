Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55282 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaKWAFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 19:05:10 -0500
Date: Sun, 23 Nov 2014 00:05:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Message-ID: <20141123000503.GQ32735@carfax.org.uk>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
 <20141122222606.GO8916@merlins.org>
 <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPSgZSQ6mfPWgZ9n"
In-Reply-To: <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yPSgZSQ6mfPWgZ9n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 23, 2014 at 12:26:38AM +0100, Patrik Lundquist wrote:
> On 22 November 2014 at 23:26, Marc MERLIN <marc@merlins.org> wrote:
> >
> > This one hurts my brain every time I think about it :)
> 
> I'm new to Btrfs so I may very well be wrong, since I haven't really
> read up on it. :-)
> 
> 
> > So, the bigger the -dusage number, the more work btrfs has to do.
> 
> Agreed.
> 
> 
> > -dusage=0 does almost nothing
> > -dusage=100 effectively rebalances everything
> 
> And -dusage=0 effectively reclaims empty chunks, right?
> 
> 
> > But saying saying "less than 95% full" for -dusage=95 would mean
> > rebalancing everything that isn't almost full,
> 
> But isn't that what rebalance does? Rewriting chunks <=95% full to
> completely full chunks and effectively defragmenting chunks and most
> likely reduce the number of chunks.
> 
> A -dusage=0 rebalance reduced my number of chunks from 1173 to 998 and
> dev_item.bytes_used went from 1593466421248 to 1491460947968.
> 
> 
> > Now, just to be sure, if I'm getting this right, if your filesystem is
> > 55% full, you could rebalance all blocks that have less than 55% space
> > free, and use -dusage=55
> 
> I realize that I interpret the usage parameter as operating on blocks
> (chunks? are they the same in this case?) that are <= 55% full while
> you interpret it as <= 55% free.
> 
> Which is correct?

   Less than or equal to 55% full.

   0 gives you less than or equal to 0% full -- i.e. the empty block
groups. 100 gives you less than or equal to 100% full, i.e. all block
groups.

   A chunk is the part of a block group that lives on one device, so
in RAID-1, every block group is precisely two chunks; in RAID-0, every
block group is 2 or more chunks, up to the number of devices in the
FS. A chunk is usually 1 GiB in size for data and 250 MiB for
metadata, but can be smaller under some circumstances.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- And what rough beast,  its hour come round at last / slouches ---  
                     towards Bethlehem,  to be born?                     

--yPSgZSQ6mfPWgZ9n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUcSSvAAoJEFheFHXiqx3ky/UQAIQJ6XO3f3PxO2DgSr86uUpi
711hITGsyQE19sgU2sEVF2+KW4WgKdHxNGVtPUQxk3gRpHdGLbr9Zi/8nAWkqVsa
4RjOouvDEHzBOTW2joi+YGmc9FhINaIBBivLU/6lp7gkyZshQPVvgC9HP02hEMws
Rh6CoZDYjurH/9sUyTiVMS4ZJDG8BsVDyTcZvUioIbinRXj1v1m1ZXpp7Z5jzChQ
yLVy0Q82qSaspV2FFHWslZTRNv8Ki+ulvvXxJvRDajkJgl7Y22w+zrl168vcmj4G
lTbLSkmw6amDkVyU61peLtT/2BQEt2qXf/uPLZUP2ZHvq0vK64PKEYPXziM1rXxP
y+V4fQ7FGyCI743nXOhLmLPS+iB2AlnYthui3quHNlnc8ck4z3rCTo7ANi9oIzcV
08Urkp56lCpRlBVcCx9GwxvaUWpbMGtAHcTq/WenSts0mqlsctGOh2xsZnLsX4Xz
+xjkqMS4wRzCO7WW4F41Vdw5iHLBtIrty//276TeVIElKgiYk58mJc3GwSfVkqwt
ra3PKpU4TpaXB6I3U3dyv/m4e52+E6K8Xd6igoWyfmKYe+3XcuJX/nalKqVqGL+J
aciMZoRxx7pLX+fKjoIEundt+2C6e+B6P+IGtRYZKN/41VsTBtaYcVt7nZH5NoNy
hlAfFXM0Ls9d18kJN18X
=CPTC
-----END PGP SIGNATURE-----

--yPSgZSQ6mfPWgZ9n--
