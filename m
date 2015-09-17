Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51829 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbIQTnQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 15:43:16 -0400
Date: Thu, 17 Sep 2015 19:43:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gert Menke <gert@menke.ac>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
Message-ID: <20150917194314.GA29926@carfax.org.uk>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
 <55FAFEB8.6030404@menke.ac>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
In-Reply-To: <55FAFEB8.6030404@menke.ac>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 17, 2015 at 07:56:08PM +0200, Gert Menke wrote:
> Hi,
> 
> thank you for your answers!
> 
> So it seems there are several suboptimal alternatives here...
> 
> MD+LVM is very close to what I want, but md has no way to cope with
> silent data corruption. So if I'd want to use a guest filesystem
> that has no checksums either, I'm out of luck.
> I'm honestly a bit confused here - isn't checksumming one of the
> most obvious things to want in a software RAID setup? Is it a
> feature that might appear in the future? Maybe I should talk to the
> md guys...
> 
> BTRFS looks really nice feature-wise, but is not (yet) optimized for
> my use-case I guess. Disabling COW would certainly help, but I don't
> want to lose the data checksums. Is nodatacowbutkeepdatachecksums a
> feature that might turn up in the future?
[snip]

   No. If you try doing that particular combination of features, you
end up with a filesystem that can be inconsistent: there's a race
condition between updating the data in a file and updating the csum
record for it, and the race can't be fixed.

   Hugo.

-- 
Hugo Mills             | I spent most of my money on drink, women and fast
hugo@... carfax.org.uk | cars. The rest I wasted.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            James Hunt

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV+xfRAAoJEFheFHXiqx3kBo8P/0rSqI8mJiKOd79WVGyNVtXI
A6xKZB6oNL1YUa+WXqc3kDk8zi2P+jMs9FVN+AUCCr51gkKhZKl8pXgVRLo9GYbb
TV5S4vdVYerp95379VNllVR9HkDMfPfX2RvfYzXnSbjm/QPUJQC3ESPzqbv/qGxe
c/cjWH/7m23/acvD+e6f1A3enrk42DDmE5bKGgdsple5nZlneqsMb/PvTWLJA2sz
wOpKu5yCbwZBs+/Tv4OZAWc626xQZrUhLRn+6PlLtbuYHHuOej6kMozZouuz6dFo
Yi17d/5zvPzZL0DFF9FTQlHDOglZCGbrxlHKuVr8XtdivgsnxFseiZWXW1iGfC7t
ixjqUfOZQWK3MEg0BIsMrqanpSiFdlDfwFyIx/mAllfwzQ7rLR+M/KFUQlurpO7O
NeaxqRmBNCaGE8E8jdCMm1AkiwxH3YJDFYG9469wrZmgUxVlkS68INVbjdwf/SG8
l53aHUr2j1pz+AZkp4GQMOqQDewpFu5jIgK1qXn0OPHqNEi+K9wfWGL5zGCQP0Dq
cvT/HCv0+Y5Nr3K8fN2aa7B/IFB5tEUhVGFv5BcklnkESjl8MYRxtYAbeUC7UVR0
9yPYreeHkA0vIEiEUelnvNqUx1fYRkpKj+jpqihdlVqXfnHvPFqaS62PK4BzAfS6
wLRz4VTOgoXeUs+84nf9
=bT6z
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
