Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39300 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbJaWvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 18:51:54 -0400
Date: Sat, 31 Oct 2015 22:51:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Henk Slager <eye1tm@gmail.com>
Cc: Simon King <simon.king@uni-koeln.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
Message-ID: <20151031225151.GH21103@carfax.org.uk>
References: <5634DD93.9050605@uni-koeln.de>
 <20151031164112.GF21103@carfax.org.uk>
 <5634FB01.9030602@uni-koeln.de>
 <20151031183337.GG21103@carfax.org.uk>
 <56352AEA.7040907@uni-koeln.de>
 <CAPmG0jYNmTvuKnbRfYcViCQFnghL5LYnj_KyCOCLqVynseY2BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
In-Reply-To: <CAPmG0jYNmTvuKnbRfYcViCQFnghL5LYnj_KyCOCLqVynseY2BA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 31, 2015 at 11:45:15PM +0100, Henk Slager wrote:
> Hi Simon,
> 
> >>> linux-va3e:~ # btrfs balance start -dlimit=2 /
> >>> ERROR: error during balancing '/' - No space left on device
> >>> There may be more info in syslog - try dmesg | tail
> >>
> >>    And this is with a filesystem that's not fully allocated?
> >> (i.e. btrfs fi show indicates that used and total are different for
> >> each device). If that's the case, then you may have hit a known but
> >> unfixed bug to do with space allocation.
> >
> > linux-va3e:~ # btrfs fi show
> > Label: none  uuid: 656dc65f-240b-4137-a490-0175717dd7fa
> >         Total devices 1 FS bytes used 13.71GiB
> >         devid    1 size 20.00GiB used 16.88GiB path /dev/sda2
> >
> > btrfs-progs v4.0+20150429
> >
> > Is there a manual work-around?

   Not that we've found in the last year or so of poking at it, I'm
afraid.

> For 'No space left on device', a trick I once saw is to run:
> 
> btrfs balance start -dusage=0 -musage=0 /
> 
> Under certain circumstances (i don't remember which kernel, tools
> versions etc), this enables you to create files again on the
> filesystem.

   That's basically what Simon's been doing (although a little more
aggressively). It's not going to help here.

> Looking at the   btrfs fi df /  output, I don't see a real need for
> balancing, the numbers can be much different and then balance might be
> usefull.

   If you're hitting ENOSPC with unallocated space, then that's a
bug. In fact, it's a known bug that hasn't been fixed yet.

   Hugo.

-- 
Hugo Mills             | That's not rain, that's a lake with slots in it.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWNUYHAAoJEFheFHXiqx3k4fAP/jNXumPeBTGCQo7oZSrmL2ST
v/wb4/dkez/TG/WfvbqL7S4gz3bnSOCBmBhwEWSZo5B2kH3qbbrXGQJXEUhhwwNJ
6YDjO6ti8sK8lIAvbRgJgg+hnl4XCZXiY5RHQXD9b6ZcH3OTtDMmlTUi2VC+N/6s
hO9dluI1n8GAUHzlHgH30AOdNKCEE86AF/sirIyqZeMlndmnBQE6rXQr4X8LrLat
eMpTOjAA4a8RwNL+YV9GOwcRESqIJSNB46wW7pltU9CyHFfgiPq4uPd+tFKXEeee
U5fp50Qp+CL5snRZuIsZcTQM4C6xJiS+6ghpBUsQEoAWmkRqN7fWYVkzH+2Bj7ue
PAPHzxnSOReKmDnuAc4Ljj/BHVsxeaHWI5f/Rp1VRZP1C6WGpI6/nebv9F2oFt+1
zZXhELRLB4v64harJ3jweAsaLId3HpqnzpTqqLIBVL0jSHksDAE3dP89l7KX8mZL
597V2mC9HzCrDhqygQUXK7OHk2lmYYosV6I+jJvzlCUqOePKfzzcg3JGLVAuPRdI
P0ZKk/5WCEyGF22AJguqiycJGrlZNGmEr+khXz1XbQUkMUu67Nl1LSKc3K58OVQz
ewEKgS0aocSOqxdZFGRSqdi8RBzP2NYqWMgX1JqlGdONF88VFqTKKskoqNCB+gCj
HU3F6hqRmp62mcuRCW+D
=4C0m
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--
