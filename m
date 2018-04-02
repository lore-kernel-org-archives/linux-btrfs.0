Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54916 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754429AbeDBWHC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 18:07:02 -0400
Date: Mon, 2 Apr 2018 22:07:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Fedja Beader <fedja@protonmail.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [wiki] Please clarify how to check whether barriers are properly
 implemented in hardware
Message-ID: <20180402220701.GK17966@carfax.org.uk>
References: <4qM6bqeIXt1jGOul3HmynOFezEQLL--S4mQQsyYaGU5u_eYiiCP9uLZnyuBYU4LyUbe9Yp32oYU1rY-wh6p5Jg==@protonmail.ch>
 <u_zEBVQVCIIoJiHQIDjqqi7rHOFPhczdc2XdtJiOWRo7_5ththeYDrz_jnkNaSirIpkV94nBhQAtzWP2viADYw==@protonmail.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sU4rRG038CsJurvk"
In-Reply-To: <u_zEBVQVCIIoJiHQIDjqqi7rHOFPhczdc2XdtJiOWRo7_5ththeYDrz_jnkNaSirIpkV94nBhQAtzWP2viADYw==@protonmail.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sU4rRG038CsJurvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2018 at 06:03:00PM -0400, Fedja Beader wrote:
> Is there some testing utility for this? Is there a way to extract this/tell with a high enough certainty from datasheets/other material before purchase?

   Given that not implementing barriers is basically a bug in the
hardware [for SATA or SAS], I don't think anyone's going to specify
anything other than "fully suppors barriers" in their datasheets.

   I don't know of a testing tool. It may not be obvious that barriers
aren't being honoured without doing things like power-failure testing.

   Hugo.

> https://btrfs.wiki.kernel.org/index.php/FAQ#How_does_this_happen.3F

-- 
Hugo Mills             | "Damn and blast British Telecom!" said Dirk,
hugo@... carfax.org.uk | the words coming easily from force of habit.
http://carfax.org.uk/  |                                        Douglas Adams,
PGP: E2AB1DE4          |               Dirk Gently's Holistic Detective Agency

--sU4rRG038CsJurvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJawqmFAAoJEFheFHXiqx3kdREP+QGxndg2wWdEck1wWHgyqx8h
xuhC0MNsnUpRkbZY1JF+wkHmlu2Cce+rsICq2ncBivBIgaLiaP9ckzZJHBdmlVL0
jP66uS7IaJrz/yTboZpF86chanWHyFYLZJaJq1KHbN0nRHwsvaK1nyv0Kp2yRQKg
VxNERDU3hGzbgYb93S5lXkvJQjcrc5D+ZjCQBSShFL/MHXq0E40ASrwyUJNRBmIy
HRpSbzPEeyts+JB2Mxx6bwOnAr1DVOe20MnEQqkhy2fTnK2ZF9ZsULkfnTzgrh+/
w4nluBiH38E0B6LHnVWz0BZkD6j3GP8QF5f85yLbdp/J2Z72IaYPMLKwssdqoACn
+CXMs5crhLLO+5HGdW8vPzFtn8B/xT5lqIINKAuE6s+KkEK7n4XdDKyt4huHVV28
+MUSf6XD8v2HS7hmYXqHdHucn/5zksLiYr0XCZJ4vPrXu/5Oo7DHllTT7UtMz0/F
c53WSYxX75oGOvY3qatpmhtvTAXmBezk9U+eIQqV/c7k0LIE6MZ59OQYaRnO46Xv
tRceuyZ1GHu4XkOb35np5XaeJQ+js14Iyonj0ao/Z9NBVDTPHFmndLPOUQ3JCvdy
mM7kcQUVO6QyA8i4lIbkllUtVfHfhqgwZNWnDzety6XINveFgS4Umjw1Xl9Xqq2Z
bo0TSPL5eDlvQ0R91TeA
=wHPX
-----END PGP SIGNATURE-----

--sU4rRG038CsJurvk--
