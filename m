Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32809 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933381AbdAJPrz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 10:47:55 -0500
Date: Tue, 10 Jan 2017 15:47:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
Message-ID: <20170110154753.GK19585@carfax.org.uk>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
 <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
 <20170110152905.GJ19585@carfax.org.uk>
 <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
In-Reply-To: <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 10:42:51AM -0500, Austin S. Hemmelgarn wrote:
> Most of the issue in this case is with the size of the initial
> chunk. That said, I've got quite a few reasonably sized filesystems
> (I think the largest is 200GB) with moderate usage (max 90GB of
> data), and none of them are using more than the first 16kB block in
> the System chunk. While I'm not necessarily a typical user, I'd be
> willing to bet based on this that in general, most people who aren't
> storing very large amounts of data or taking huge numbers of
> snapshots aren't going to need a system chunk much bigger than 1MB.

   Again, the system chunk has *nothing* to do with snapshots.

   Agreed with everything else, though.

   Hugo.

-- 
Hugo Mills             | I'm always right. But I might be wrong about that.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYdQIpAAoJEFheFHXiqx3kiOIP/3HNgt3rRQ/56yA/FfSFSpsB
cndyGD4tOpPAZm0Y4tmcfe7M61igBQtaXhZCWry/l5AEPW+JvagZAYIgNjot0sGS
vh+WhT17wrqZFtkEXTg9rIpyKWVQMWZuUFIQJUnYN5qh/kM8qjkT8XCToJcgUDaZ
MXQFyYIPHtVxaQ/br3cQqLvB60Yb0mtviaiDiZu1z08Kx9lrh8INzisf6cQ6v9ld
k20seoHEyyiZhqsms8sfpcJ22xnSl6GhO0sp6yMfNah61f/9Dr7YwuVKNVkUygex
VpI4U627VPKpDqnUZicd/0u/gNVDL2msyC3iA9sdMvNzMd6wBfiRdRN2pEBALMN3
OvgmW2qeew5v/i7hqiDeuElze9a1jKr42M+MvbIJb1V7n13plHpaESeBgtgdNKeC
Jv/QJ8SScIRfPNh+P/xmKOCH709MB4Yh5Nk6WP53fphiko1Lv1eBaeqEQTg4MQ2R
2wvMiryQIONV4oS4ZiC+7wXNcM0fGBXcM0jY2gp5HUZf0Hjb+oMjxC0P875Fj255
rmQZhRPCysDE53ITZi/gQPM9EjSWXugKmNOlmotEez5IcEV0iiipXytGLMIBdK9e
h41ZazPw1RfNE8gROTSWs9/YmSEPmCNZ93nEC2b2qcxVFLHn8Ry4gMnxBecxWxES
eIql8Zl+3tdr9bJx04jd
=jSOo
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
