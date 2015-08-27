Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34239 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbbH0R7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:59:51 -0400
Date: Thu, 27 Aug 2015 17:59:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: carlo von lynX <lynX@time.to.get.psyced.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Impossible to mount two different copies of the same btrfs
Message-ID: <20150827175947.GL23769@carfax.org.uk>
References: <20150827173229.GA30068@lo.psyced.org>
 <CAJCQCtQx+L1JauS=cC1crPQDpOO+t5SqHAg8Z8Q6K5KPKPW6TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
In-Reply-To: <CAJCQCtQx+L1JauS=cC1crPQDpOO+t5SqHAg8Z8Q6K5KPKPW6TQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2015 at 11:53:28AM -0600, Chris Murphy wrote:
> On Thu, Aug 27, 2015 at 11:32 AM, carlo von lynX
> <lynX@time.to.get.psyced.org> wrote:
> > Hi there. Excuse me if I didn't subscribe the list. Just wanted to
> > let you know of this behavior assuming you haven't noticed it yet.
> >
> > When mounting two copies of the same file system from two different
> > hard disks with the intention of syncing the older with the newer
> > one, btrfs behaves differently from ext4: it will mount the first
> > one twice rather than mounting each. I assume it has something to
> > do with all UUIDs being identical, which doesn't disturb ext4 though.
> 
> I'd say any file system that allows mount without warning when two fs
> volumes with the same UUID is a bug. I vastly prefer the XFS behavior
> in this regard which is warn and refusal to mount. You have to use -o
> nouuid to make it happen; and then I guess there's some separate
> handling to still keep the fs instances separate, but I don't know how
> that works at all or how ext4 and Btrfs differ.

   See my other email in this thread. :)

   Hugo.

-- 
Hugo Mills             | You know... I'm sure this code would seem a lot
hugo@... carfax.org.uk | better if I never tried running it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV31ATAAoJEFheFHXiqx3kaiUQAI/eh3i+dTtBw2sqkIbLKbUm
kWuN48dLHnBZMwzEDiJfA06GuCIKOk8wFyXJ8HquebtisLOGm7Aj7TgtNSM+pi9R
AuQt3lgAMMa7IAweOdhnpwRiTTR7hivrNs2oReu3bqZRL8ynMLO/BDIwswXEBymm
5ajjSfHy5T/VwVBd+jgVnpDQgSQBo4SDINd+tCKi1lWBa17jREJe4BZjc1wDdV1x
8Y7agpwTJ+0FCka9tLnumRlSd8arrpnOH3Q/ETSfI0RqCimspAEw1XdfHa7TXuHN
cwGtNvooxAzj5SuaV7Qt6C1YtkXv+qfZwXLFqIYKv3CfzpGkOGhg7T2Oyo04MWj7
bKtp+cu+YYcxwqRgdl0PSNimqDUj3Pj0T6N0/6i9kNMEoiL+rYqXrtH7HB4ji5aT
5C2lkAXBHcHuh6jXKc/XThbaA/uqY6WEkYPFYC/uuf2nHvw5Wbkwngx8hYWydf1c
yslLHNBBrhbbKHpRfEh/yhLWrfca++L/R3P3Vc1nYP9R+bdCm/aPQkTwbj+U2SBO
LBMi8mLi3E55W9gKYcICedIp1QHBqPk2kLSfeLY1Ze2SlZ7GgMN5zz69BopkYWVr
b6gklICUAyGxAvDQoS75CLBKeqtenFBoo3j0+vGVXatXJbnXlVgc3Vk1DXPCaEs9
r8a/p6mvP4hJSvlmfSNw
=U1Ne
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
