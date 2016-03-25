Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36621 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbcCYD7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 23:59:01 -0400
Date: Fri, 25 Mar 2016 03:58:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: allow DUP on multidev fs, only warn
Message-ID: <20160325035858.GD29474@carfax.org.uk>
References: <1458834973-3199-1-git-send-email-dsterba@suse.com>
 <pan$83413$34f18f9e$a1606444$9239e69f@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
In-Reply-To: <pan$83413$34f18f9e$a1606444$9239e69f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 25, 2016 at 01:59:20AM +0000, Duncan wrote:
> David Sterba posted on Thu, 24 Mar 2016 16:56:13 +0100 as excerpted:
> 
> > The DUP profile can work on multiple filesystems, the limitation is
> > rather artificial. Let the user make the decision and print a warning.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> 
> I like the change, but typo in the commit comment... What filesystems 
> other than btrfs allow DUP? =:^)  It's correct in the posting subject.

   Class/instance problem. :)

   Is that class of filesystems, btrfs, or instance of a btrfs
filesystem? "Filesystem" covers both cases.

   Hugo, Ontologist(*).

(*) Yes, that's actually my job title these days.

-- 
Hugo Mills             | Be pure.
hugo@... carfax.org.uk | Be vigilant.
http://carfax.org.uk/  | Behave.
PGP: E2AB1DE4          |                                   Torquemada, Nemesis

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW9LeCAAoJEFheFHXiqx3k0YAP/R7tBHD850TKsP5CWMq6sTlF
xSMQOHYfohkgR0fwna7Js4IjrO+9BQjZUumeW62B8B6ojsJ7SEVzbzj94glI7PLF
2HEptUnmuNL31K7/w6ZtrJt3EAnM4mGihbC4lPHVfuuT2dfa5GnQiqabIrn6qx8c
J8hNBnaqTpGuDHTHNhfQyWBuNld3DB/RZLbrYdMXryvNfQ1sYaKEbNkabl5qr2Oh
yxNnAxz3nod9C8JNDQ/kc/VbzZDsx387eMZ3NDFtkDM4hmsuGzXY7ByJQpOO//is
GRG2gUdektDwu6TYl5LwwdrFNy3UZvxfvg0F3rRFqATy7mZw5MDWGvUiT/dCNXHE
f7EmMshRXjZv6DvLt7LfAz6JWDhSjlejb3sMPHXJIET/4VzhHo7E2kVLZlGokWkh
EZzvHe8h8PSRwlYNzEz+ZTsIsLD3YKTcZwiGFA8lc06o85c7gEZK/K6+/x7UnEwK
OFwgiUJOrhF3GtJrsbkZ+sIvgWwNlAKQecFiPv5Q4LUrUsNK72kYehinHRtOA6c0
etOlTSs/a/iduNe4jMmgV+/l2SNRLbda5X2ZCi8s2DQmFuqJH3AoQsDbNBmqDqxO
M9vpN6BOKpuvUXRCqh13x7ko7FVz3mZvcC+g5/braqIuWFL6u7PmR4MvS88SrlRI
kewdxH1DWn8UpJxmJwZ1
=YCWP
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
