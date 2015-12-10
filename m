Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49239 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbbLJMlb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 07:41:31 -0500
Date: Thu, 10 Dec 2015 12:41:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "S.J." <sorry@anonym.com>, linux-btrfs@vger.kernel.org
Subject: Re: attacking btrfs filesystems via UUID collisions?
Message-ID: <20151210124129.GI2376@carfax.org.uk>
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net>
 <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net>
 <5668A1CB.1020007@anonym.com>
 <56696B53.7070905@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HmK7y6O+lKZIGkr"
In-Reply-To: <56696B53.7070905@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+HmK7y6O+lKZIGkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 10, 2015 at 07:08:51AM -0500, Austin S Hemmelgarn wrote:
> On 2015-12-09 16:48, S.J. wrote:
> >> 1. better practices, we really need to tell users, and documentation
> >> writers, that using dd (or variant) to copy Btrfs volumes has a
> >> consequence and should not be used to make copies.
> > 
> >> 2. Btrfs needs a better way to make a copy of a volume when there are
> >> snapshots (including even rw snapshots); e.g. permit send/receive to
> >> work on rw snapshots if the fs is ro mounted; e.g. a way to do
> >> "recursive" send/receive.
> > 
> >> 3. Some way to fail gracefully, when there's ambiguity that cannot be
> >> resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
> >> then there's simply no way to resolve the ambiguity automatically, and
> >> the volume should just refuse to rw mount until the user resolves the
> >> ambiguity. I think it's OK to fallback to ro mount (maybe) by default
> >> in such a case rather than totally fail to mount.
> > 
> > About 3:
> > RO fallback for the second device/partitions is not good.
> > It won't stop confusing the two partitions, and even if both are RO,
> > thinking it's ok to read and then reading the wrong data is bad.
> > 
> > About 1 and 2 ... if 3 gets fulfilled, why?
> > DD itself is not a problem "if" the UUID is changed after it
> > (which is a command as simple as dd), and if someone doesn't
> > know that, he/she will notice when mount refuses to work
> > because UUID duplicate.
> Unless things have changed significantly, changing the UUID on a BTRFS
> image is not anywhere near as simple as copying it with dd.  The UUID
> gets used internally somehow, and changing it would require rewriting
> _all_ the metadata blocks.

   Indeed, but there is now a tool to do that. :) (btrfstune -u or -U)

   Hugo.

-- 
Hugo Mills             | Go not to the elves for counsel, for they will say
hugo@... carfax.org.uk | both no and yes.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--+HmK7y6O+lKZIGkr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWaXL5AAoJEFheFHXiqx3kIzwP/j4lDcD2bVHMkc1A+AT8bPQm
Njd2ybY1SCoJBi3qIYX6z0JBIt6BzeM41Ov6RbTffQ+s4ayIabdHEG43+6P/ShYd
EunaY+3XQcZ3cr18U3Au8/FK4/CxBIaGIqhfxNJRf+lRd/yqsdf5jjLc0JAEVJeH
pzWCX1LQhyce1TcpfWz+LG2OFcs3EZjqCvs7Y7qIk7sL1xZ6qK6Irwh8N/TjAQa2
gQ2auhQ7nlCyWks8C83/Rcu/BoabajJw+AMrKJQ0UtaoF6kWR3oKL31px0oZO6t9
0aj5ILbCpteFLvD2dv/VLZXuziNri9cgjD/soTVrM60zqizQN6DaXx+sN+aiwJRR
YNiYZNryFJDD+FVdTe9V8q5ghcHY/Mm79hDheW8lQLyiUAWYSgRb8g++OWORTXAx
GuXNq6KKGeLuE00v/R6fvqcw7CrWOeEMAsA+F5YlQp2WMhT5R9oF31tBbXIR098b
pIYaKbIefjVMVS0gK/Frx6jKyYNQGSk8HI+hC/gkc/OkB5wrYMOZFeCnj7YTt8hv
d75j3heAvPkieVypvu7Th8OSCfcvL8DEGb+5zlkLnSVZ3RbeBQ2EPWTIscJxJIjV
VsxJhkVKXUgiBX0m2zJnJHZNqMqNi7DlNpGDFs3038az81WHFQNHBOpfycIjeuou
5d4FnkUgAXViY/L4a7IC
=4GiZ
-----END PGP SIGNATURE-----

--+HmK7y6O+lKZIGkr--
