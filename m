Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56797 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdISPkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:40:17 -0400
Date: Tue, 19 Sep 2017 15:40:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Does btrfs use crc32 for error correction?
Message-ID: <20170919154016.GA8264@carfax.org.uk>
References: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
In-Reply-To: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 19, 2017 at 06:35:48PM +0300, Timofey Titovets wrote:
> Stupid question:
> Does btrfs use crc32 for error correction?

   It uses it for error _detection_. On read, it'll verify the data
(or metadata) against the checksum.

   With no reduncancy (single, RAID-0), a bad csum check will return
I/O error.

   With redundancy (RAID-1, 10, 5, 6), a bad csum check will try
reading the other copy. If that's good, it will use it and repair the
broken copy.

   Hugo.

> If no, why?
> 
> (AFAIK if using CRC that possible to fix 1 bit flip)
> 
> P.S. I try check that (i create image, create text file, flip bit, try
> read and btrfs show IO-error)
> 
> Thanks!

-- 
Hugo Mills             | Dullest spy film ever: The Eastbourne Ultimatum
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       The Thick of It

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZwTpgAAoJEFheFHXiqx3k0x0QAKKhJO4yPImqkZkaykfQOFnn
RTpN4GoXfJzWNJQHA9UL++EImvhbY4LJ9tXRe4lgkTFDlfAYN1EmysixBZE5zsz8
wLNThH+Oe9VfjYxcxwpX5SJyeY0TEO/HjBt4J/akCUvWuLp9mtCYimpPOg0azl1J
pFPT7BmQzh8NtUyFZTJcdKiWBQFgwdamVJK7J3v33wfQDYf5D7nV4iC2ZzrR5O+E
P4qWkcv2LvX4GGcM/EgEy3rpv8mfAPAQ3MOkTBBpNyqhd15zS4F+itkTBfrbVcYM
Q/4ktrBB8myo8gbZGfsuQr8B470869B0GYGqHIQmKr9KP5FyGMmp3ix47tMN6k3N
wuzXlIOrB4pSftaLa1QczkCdECkDMhn1WDgzOBVdNh4CGVg7CKQDOqflGTc0JMO4
6jrsC8ZdNHnCFux7XWpNCXZsZeRyJyq1/vzu6XIZUDIwY/PeL9kP7nC3oGqjWTXl
MB8RJerPpaKt+zPwGZ9vz/SXdFflxfjUhlbjrRUWsTbPwv0JnnnYCCQWgw5G7E1q
KnOpImIZDU+bcPJcRNfq3nUZ0si0I9nxz+7usNYhHzvGWip+PO1pblnFpfpjzhLc
p/dtZfpQ5s8sz5CwSBA7Cc0EYXYILe3dCuSsMFYdVx3hHmlPLoqSyJE25D1dLYOb
aSemQAmsGHDQis/oTJaQ
=EYGY
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
