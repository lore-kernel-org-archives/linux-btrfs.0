Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35294 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab3GWOnz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 10:43:55 -0400
Date: Tue, 23 Jul 2013 15:43:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Curtis Shimamoto <sugar.and.scruffy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Different size devices in RAID
Message-ID: <20130723144351.GF20517@carfax.org.uk>
References: <20130723143236.GA12119@thinkpad.home.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
In-Reply-To: <20130723143236.GA12119@thinkpad.home.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 07:32:36AM -0700, Curtis Shimamoto wrote:
> I am using btrfs to span across two SSDs at the moment.  One is a 256GB
> and the other is a 128GB.  So as of now, I have the data in "single" form
> and the metadata in a RAID1. I have heard that btrfs can adjust to some
> degree for devices in a RAID array that vary in sizes due to the way it
> handles things.  But I feel as though the size difference between those
> two would be too vast to compensate for whatsoever.
> 
> But I have an additional SSD in my machine, which is also a 128GB drive.
> I know that with RAID1, it will only duplicate the data no matter how
> many devices are present in the array.  So if that is the case, if I were
> to add all three of my SSDs into the filesystem, and then put the data
> into a RAID1, would it be able to make use of all the space?

   Yes. If the largest device is A, and the two smaller ones are B and
C, the system will allocate chunks in pairs, alternating A+B and A+C.

>  The two
> smaller ones are about equal to the size of the larger, so in my mind it
> would seem that it would be entirely possible for it to keep two copies
> of each extent while still utilizing all the space.  But I don't know if
> btrfs is set up to recognize this situation or how it would handle it.
> 
> I know that I could potentially put the two smaller drives in some kind
> of an LVM or mdadm, but I would like to avoid this if possible.  It just
> seems like an unnecessary layer of complexity.
> 
> Though my question is about RAID1 specifically, as I would like to use
> the potential of the self healing features, I guess it would also extend
> to RAID0 as well.  Would that be able to make efficient use of the space?

   No, because you only have one large device and two small ones, so
the "top" part of the largest device would be unusable with RAID-0.
(Or at least, not until we get stripe-width limitations, which should
be coming up Real Soon Now, as I believe it's part of Chris's work to
finish off the parity RAID implementation).

> Additionally, though not quite as much of a concern to me, the machine in
> which these drives live is an Ivy Bridge Laptop, so there are actually
> only two available SATA3 ports.  The odd drive out at this point in time
> is actually an mSATA which is the only SATA2 port.  If I were to add this
> to an array (assuming the above questions have favorable answers), how
> dramatically would the speed of the array be affected?  To be honest, the
> speed of even just the mSATA drive alone is enough to keep me happy.  But
> I have just been very curious about this.  The write speeds of all three
> are relatively close. But the read speeds on the SATA3 are significantly
> faster than the mSATA.

   This one I don't have an answer for, sorry.

   Hugo.

> Anyway, thanks for the fantastic filesystem.  Sorry for the long email,
> but these questions have been in the back of my mind for some time now.
> For the first question(s) at least I have not been able to find anything
> regarding that scenario.
> 
> Regards,

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUe6Wp1heFHXiqx3kAQIOGxAAhvNNDVoyac4jpUDIA/38rutkLpgMrF4y
IENM6fqFXxs2tzT825Z6j4O0fZ/dwkwyqqCuS8xeZAhOfs1lcNfRKHjF327vdC7o
39x0f/a+MhynUTMfVSF7nL0GXExqqPQXcKeuSomUKrlZt80sGs781j1fmBSwXuzM
og/nyAeczi3nIIEk4U9a7LlzGjjniJk7ihYGZA9Q2kdXscKcaBp7ltYV7lZwUUIY
X+NHohWqRkcupncM69ENQ1M6pi80K7Ek3E9FmkBM2yNjrFuDutTt5uIZpaND4MN0
ohr5SwFTd9s2jcPGYP7K/wJl7mjBsfW88n1nX/fOejTCl2+xJQD4BPJqoovj/T/M
goctVIuS1IxOB1BBqL8weKJIdoPIVGJibmmyK1UCjPXpIb96tMEcEJsTInl9nCgG
32LiuJq5Zbx7zSm3/ycETlO+8OivvNdCGG7x2PPIGzYBQeFUtloWg+o5DodPWynO
GiYGEL/GoZgVSctxkEA/DeGHI40YkETgK7iXyaoopaRnBY5+F8FifI/sMHtPfaAm
JhdB/iXtCff6YqEkCsBrBEIZv7fCQ04xFuvhLwBaPY8qEvHGXyHVNl8xdvVzRdV+
Tav7DPsK67z/Xc2ULT8NZAe7UOp9oG1NPR1x6FeSFOBgVFlrcJWhqZKDYSLQMN95
95c307wAfAA=
=EVAr
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
