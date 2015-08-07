Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from baraddur.eliasprobst.eu ([78.47.157.163]:43904 "EHLO
	eliasprobst.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946411AbbHGXa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 19:30:57 -0400
To: linux-btrfs@vger.kernel.org
Date: Sat, 08 Aug 2015 01:29:57 +0200
Subject: Re: Lockup in BTRFS_IOC_CLONE/Kernel 4.2.0-rc5
References: <55C1C915.4070106@eliasprobst.eu> <20150807040119.GA8887@localhost.localdomain>
Message-ID: <55C53F75.6060905@eliasprobst.eu>
From: "Elias Probst" <mail@eliasprobst.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="FtNskrpX8eb0FpHihFM0RseUh6Eiu9gf5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FtNskrpX8eb0FpHihFM0RseUh6Eiu9gf5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/07/2015 06:01 AM, Liu Bo wrote:
> Could you do 'echo w > /proc/sysrq-trigger' to gather the whole hang ca=
ll stack?

Thanks a lot for the feedback. Full call stack output is attached
(pasting inline makes no sense due to the size of 2423 lines/135k).

In case VGER will strip attachments of this size, I made it available as
a pastebin here: https://bpaste.net/show/e5e0fd4bbb9f


> Here's a quick patch that may address your problem, can you give it a s=
hot after
> getting sysrq-w output?

Will rebuild now with your patch and keep you updated about the outcome.

Thanks a lot again!

- Elias




--FtNskrpX8eb0FpHihFM0RseUh6Eiu9gf5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJVxT9/AAoJEILFEoJlEbrb7AQP/1HyH4dJeT+iqVjPZNSUPcBM
/w8z7qomxH1u8bO8QDI/1sbGQ0mYxwLXxA79ZpM7czIFEEUYM+k8NnJsSHvQw61N
6fV2nabRt6LLyr+BKCe+oJjwbA7VuVrqlXG4FWQej/u0/8TmIJyVqSUayD+clI4p
8eGIWebAKCLqkepiB25mOFfSvurCCYXQ4Z10VsJWC0n/Ra+ZfA9bRbvYh50RBS4b
0R3sw/AUEfccWmsVQwLiJvRCVbP0vp6mQibKYLBR2jrmbgbgay6SIfEMyVVehwQt
F6SnZr4duK8jsGQwe3WdYma0LWrW/AxvBl7zZG3vzChBeNQjS/ICvSH6pEsSgjMy
bLixYZI3K1L74oPsB9yHj61QkqRV6GQoO03nq9ERu6aXxwiKapADEG6D6hbQ+Q3j
9WeVZHjb1cRFy4PljQBzbMQF5M0v9M7MVg8qD8W2iqydYP5Ig7mES1Ndo5RJjp7D
rQoBjF2nnj3qMhP1mETMQcHILMGmXSjQ/CGairIll81Fu6mBAFt5PgGkVSOSbiSQ
fIUP0187nKmsVbRkQhkcF1++oHP8B6pyBYAmtdM+B/KN6THXdfItNaFlbx+iKOLA
vm7HUKJ1Th4YbQmJq5hhjSQkqAUgJeJJMoPiO6o5rBwpn4bmXR0/+zXGYoDIQSMd
J6vBd/gA5H66sPkZ9Txt
=OCyn
-----END PGP SIGNATURE-----

--FtNskrpX8eb0FpHihFM0RseUh6Eiu9gf5--
