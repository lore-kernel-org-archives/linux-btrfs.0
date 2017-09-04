Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46804 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdIDKyp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 06:54:45 -0400
Date: Mon, 4 Sep 2017 10:54:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is autodefrag recommended?
Message-ID: <20170904105444.GA23980@carfax.org.uk>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
In-Reply-To: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 04, 2017 at 12:31:54PM +0300, Marat Khalili wrote:
> Hello list,
> good time of the day,
> 
> More than once I see mentioned in this list that autodefrag option
> solves problems with no apparent drawbacks, but it's not the
> default. Can you recommend to just switch it on indiscriminately on
> all installations?
> 
> I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's
> Ubuntu that gives us this strange choice, no idea why it's not 4.9).
> Only spinning rust here, no SSDs.

   autodefrag effectively works by taking a small region around every
write or cluster of writes and making that into a stand-alone extent.

   This has two consequences:

 - You end up duplicating more data than is strictly necessary. This
   is, IIRC, something like 128 KiB for a write.

 - There's an I/O overhead for enabling autodefrag, because it's
   increasing the amount of data written.

   Hugo.

-- 
Hugo Mills             | The future isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZrTD0AAoJEFheFHXiqx3k6coP/RYnVyUr9t1vpXCXMOM4Lp3j
i+g+fVKILq32tEpXRxWXEGj7wCl7W0aFSaI0vWIc1ZGpGOeF9kkJRykfSyRTg/4b
tsCa58DEmAdJ3kGxu3hgtQ6SoxT7/z6V2DlWI5VM6EmBYbhnOOCOVeWJNa/kjHpa
ejZiqAertS9lHKMcwYvb1+JwpQwwGLPQsQz0sXDcfrovpcSxeXNkNynflB9gkqwg
BgTbCqwtQWLsAZ+4oa5fj0ESLkFpKxvG6i2en+56CWJtZ9opgayGl0HswH6c1Vcz
A7FVgEMwySeZRqDXE1ev4mjWtXUwwFDiIbg3W5MCBpr0wWQmzeEP0/aTuUEzeIgT
2Vko80O2bFdCYgeHl1D8CYEZ+uN9rWUk/25mRerq49QQSAC0e8pmmcRREueLudlh
v4qo63wZedWvxR7pK3/o7alqDAdaYhxGOP29m3hbmQJV7DiqHPFEjB1oYz5d5u3S
vCBhY3DnF2VlXBu1Nt3KDo+BR3sczjx4XHKkHO7Dz/5azbLNNmOwgAwE3FX0Ta4Y
Bmzc2z7/+J0wSftxF2Uo1c7ZsqyNpATSxiT89f4r9Jskedh3gTl9ysnETIm/FUaB
hf2fwCXLahBE+IlzoxEOzaknMdYy5jyWLQlOysAoR0rLVbmOafCcaABVuwADT5yT
eA24Dr7iVbRRNLzWJDCc
=wbzW
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
