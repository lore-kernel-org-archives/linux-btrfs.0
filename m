Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45683 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753376AbdDDNs7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 09:48:59 -0400
Date: Tue, 4 Apr 2017 13:48:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Brian B <brian@sd85.net>
Cc: Robert Krig <robert.krig@render-wahnsinn.de>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
Message-ID: <20170404134855.GB11512@carfax.org.uk>
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
 <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
 <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
In-Reply-To: <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 09:29:11AM -0400, Brian B wrote:
> On 04/04/2017 12:02 AM, Robert Krig wrote:
> > My storage array is BTRFS Raid1 with 4x8TB Drives.
> > Wouldn't it be possible to simply disconnect two of those drives, mount
> > with -o degraded and still have access (even if read-only) to all my data?
> Just jumping on this point: my understanding of BTRFS "RAID1" is that
> each file (block?) is randomly assigned to two disks of the array (no

   Arbitrarily assigned, rather than randomly assigned (there is a
deterministic algorithm for it, but it's wise not to rely on the exact
behaviour of that algorithm, because there are a number of factors
that can alter its behaviour).

> matter how many disks are in the array).  So if you remove two disks,
> you will probably have files that were "assigned" to both of those
> disks, and will be missing.
> 
> In short, you can't remove more than one disk of a BTRFS RAID1 and still
> have all of your data.

   Indeed.

   Hugo.

-- 
Hugo Mills             | Some days, it's just not worth gnawing through the
hugo@... carfax.org.uk | straps
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY46RHAAoJEFheFHXiqx3kvh4QALAh2pWhv+Cr6GvjCicChwTt
ULsFJEJpN24qi9IyQN2K+RRqsmD7dLs2XvJs6JT6lqxp+WaOfYt+sRVj2+93pZ3B
CJNwjq0f46Ht1oLqDz7Jy0ICtKDAu6IgwVRM8n180Nd6+hDtRM9EanxUdwpYoU33
/O7VW33qU1WLaK+YR569F7bmbYgo5x5wWLtdQ6i+HccQht0sVEdH+XCwFHDC/aDB
W1y8EN03//Ko0aBj+rqJJG45JO76UWB2Pjj0ZJNJJ3qQTb34qvxX1cjVIq2UWHS8
mdzVZFjJ/lP0F/YG6wwzX6dVxc3FMB+zzrAcK7tuUMN4X+nK3LtgwFM9dXTYlqxY
6+fPEiLpO0mmpBY8ZJ+fSPcClcDPps8t9obChgunRyeKp5QDjbrctp3P6f15BRZp
YbuOb+LEjGqtfc+qaE1ZhVJwTmpS4VuoAYx5EoNe1F6JBgrnZZOg0wsMljskxpzj
C1KhjxC/SptIboBK0Lu2QC2ub83tkVX3zcrGv1htp8kX6eW9Edc8tyaviSmC88jj
Joo10P6+XCJdNQfMrXfI29Upi7Z3YbVNiJA+Gkkdk1JtQLs9hr0KBx1NmUNnwaww
FuF5jW7tKIxmzijmMuupBDS+9OxkSlwX1S1U/EQ74roySIyFEDvd3F/xeZm3LI64
La3uz40o7JK0jToJMN0N
=O1Ot
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
