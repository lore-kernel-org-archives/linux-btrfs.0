Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48372 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCKWSm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 17:18:42 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1aeVOK-0006aB-TG
	for linux-btrfs@vger.kernel.org; Fri, 11 Mar 2016 22:18:40 +0000
Date: Fri, 11 Mar 2016 22:18:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: The *right* algorithm for determining the amount of free space
Message-ID: <20160311221840.GK17196@carfax.org.uk>
References: <20160311221703.GJ17196@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2O+9B+xSKalj/wdD"
In-Reply-To: <20160311221703.GJ17196@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2O+9B+xSKalj/wdD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 11, 2016 at 10:17:03PM +0000, Hugo Mills wrote:
>    I know I promised this a while ago and didn't get round to it, but
> Henk's tinkering reminded me of it. I note specifically that the
> algorithm used to give the free space to plain old df gives incorrect
> results -- probably because it's not using the algorithm below.
> 
>    There is an algorithm that (seems to) give the correct number of
> block groups which can be allocated, given a current allocation state
> of the FS. I haven't been able to prove it correct, but it seems to
> work. Here's some pseudocode for it:

   I forgot to mention, there's a JavaScript implementation of this
algorithm at:

http://carfax.org.uk/btrfs-usage/js/btrfs-usage.js

   Hugo.

-- 
Hugo Mills             | You can play with your friends' privates, but you
hugo@... carfax.org.uk | can't play with your friends' childrens' privates.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       C++ coding rule

--2O+9B+xSKalj/wdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW40RAAAoJEFheFHXiqx3k7JYP/2binJxPiBbnW9xq1wvoTIzx
owbAQbeIsjQvPyMtYHgL2nV4K78y3H7ByGKEgjYpibw6uWu5ZaY3VpUOv+F97enb
ZMwp4TsBmbuHp1cRu5VYyUmU+fLUDF+pIKbr/PQ/Jju370ZohM1zsVkAWMmIBVV1
vwOYPXgXmEcdkK7VInegcf0DCYbVLjNZQkv1r6w6Ot9hrxGi/PMQz7e4EIGGvNQI
/VtdpJYhDJeyjI4h1hj8nxX6h459Isnd1i/jFEA7SxXh9kv2GgwXaGhqVtmEto7F
Df4gmvoI5XIVIWkEOjTF1kDHlWh1vWY3fG2iQbwIfGAFDL1Aix9vjdhHFiD9XgB7
h8rsjjgkFAHTn0eqKGMtzq9t25IbNgfOviTiJLL54bmZ1U3DMcz63DKnjsLqacj6
LFCuDq7n+VQvaipARJ9oiXte6I541Q76jFxxTX265PElxkvG7SRXM90lrVqxCwwf
7vKCAX1CfMyNYUM6IT1oEaBgGlMf8DPFlwUW1qDD6r3XGSOs+936SWgVyv5B0pYp
zagM3xuOj/F5cQ1QftYwQKpYUOjSJLPASRF2A5b9UWkuV6mVYnCLPQ1D2Awolnrk
kG9UgktITFhKPE9H0EPCi9MgR1L7gUiWeIdpjZGRn+517XjlmHstJ1qTqo/EMhdq
nqcjaupAuVqtoM7RcMLI
=Tmby
-----END PGP SIGNATURE-----

--2O+9B+xSKalj/wdD--
