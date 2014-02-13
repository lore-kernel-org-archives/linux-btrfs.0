Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41472 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBMQWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 11:22:06 -0500
Date: Thu, 13 Feb 2014 16:21:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
Message-ID: <20140213162140.GW6490@carfax.org.uk>
References: <52FCEF46.3070306@jrs-s.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glDgwcODtpHomn63"
In-Reply-To: <52FCEF46.3070306@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--glDgwcODtpHomn63
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 11:13:58AM -0500, Jim Salter wrote:
> This might be a stupid question but...
> 
> Are there any plans to make parity RAID levels in btrfs similar to
> the current implementation of btrfs-raid1?

   Yes.

> It took me a while to realize how different and powerful btrfs-raid1
> is from traditional raid1.  The ability to string together virtually
> any combination of "mutt" hard drives together in arbitrary ways and
> yet maintain redundancy is POWERFUL, and is seriously going to be a
> killer feature advancing btrfs adoption in small environments.
> 
> The one real drawback to btrfs-raid1 is that you're committed to n/2
> storage efficiency, since you're using pure redundancy rather than
> parity on the array.  I was thinking about that this morning, and
> suddenly it occurred to me that you ought to be able to create a
> striped parity array in much the same way as a btrfs-raid1 array.
> 
> Let's say you have five disks, and you arbitrarily want to define a
> stripe length of four data blocks plus one parity block per
> "stripe".  Right now, what you're looking at effectively amounts to
> a RAID3 array, like FreeBSD used to use.  But, what if we add two
> more disks? Or three more disks? Or ten more?  Is there any reason
> we can't keep our stripe length of four blocks + one parity block,
> and just distribute them relatively ad-hoc in the same way
> btrfs-raid1 distributes redundant data blocks across an ad-hoc array
> of disks?

   None whatsoever.

> This could be a pretty powerful setup IMO - if you implemented
> something like this, you'd be able to arbitrarily define your
> storage efficiency (percentage of parity blocks / data blocks) and
> your fault-tolerance level (how many drives you can afford to lose
> before failure) WITHOUT tying it directly to your underlying disks,
> or necessarily needing to rebalance as you add more disks to the
> array.  This would be a heck of a lot more flexible than ZFS'
> approach of adding more immutable vdevs.
> 
> Please feel free to tell me why I'm dumb for either 1. not realizing
> the obvious flaw in this idea or 2. not realizing it's already being
> worked on in exactly this fashion. =)

   The latter. :)

   One of the (many) existing problems with the parity RAID
implementation as it is is that with large numbers of devices, it
becomes quite inefficient to write data when you (may) need to modify
dozens of devices. It's been Chris's stated intention for a while now
to allow a bound to be placed on the maximum number of devices per
stripe, which allows a degree of control over the space-yield <->
performance knob.

   It's one of the reasons that the usage tool [1] has a "maximum
stripes" knob on it -- so that you can see the behaviour of the FS
once that feature's in place.

   Hugo.

[1] http://carfax.org.uk/btrfs-usage/

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--glDgwcODtpHomn63
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvzxFFheFHXiqx3kAQLEvxAApm8JHoTEv2pqlZ6x/xLAU9mtCLbYOuGa
U5nBzR82TyDsXAkcGejKg/uWH+vjqSV16MohwSa1FukgjbXul4Hi71DsNR2tT+4S
j0+jNapfWgr7N/fvRkooOn/ywnbLW90jdOUgpAP3zvAp5+JMAWgImBGzZHOIkfNW
D3Ea5olM5Gu8LAoJxKEj1biem0sWwahn6MUfOTWDt6+CO16s1CKEaWgqzL1Yz26W
SJv/ouCoj/vvjFy9PTzyqp8AGmIIAKkR1cNOpr5caucHEkNxBRxSnZXMONCQwB4X
jY5fSIFoF4TIJ/9He/AUnfnrD3MLQlUxrucS/n86aoZe0rowFrG4W9lSOAj7pqDV
7yFpyhu/lSLwRWb+DjsgLAKJtfOsPpmliiL1aRj8/xRozNdw1s5OOmN9UA+pdKDS
SOqccDidjO5TRnkL7CVZ3eHrrXoy6i/XgFh5j9JBU5yDCtPUPtrR+Z1Y60CW1UIN
lQyZ+MnWx4kCDfEZEDKxzFmT79taR80CeLfCAQsNucmDGBg+o3FL7lt+o5kBaA1a
tQ8vSBxAjO/vx0cXUxJDuW6m+D35gESgZb1XovrR3e5g/VKh8SZ96WAUAf+L9kev
e425F0WJtp7CdueaoaEWYegbFFYJWAonsHVOQwnwjZFyVIYMAQT6a4SrN2CCB1h7
emmB5yAOyc0=
=oq1k
-----END PGP SIGNATURE-----

--glDgwcODtpHomn63--
