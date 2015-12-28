Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42070 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbL1B6J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:58:09 -0500
Date: Mon, 28 Dec 2015 01:58:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] improve documentation of snapshot unaware defrag
Message-ID: <20151228015807.GM1586@carfax.org.uk>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
 <1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
 <pan$3bca9$74a60ba5$bf56792f$3c0040ca@cox.net>
 <1451263809.6320.9.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ie5iOtK4e9kgqh2F"
In-Reply-To: <1451263809.6320.9.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ie5iOtK4e9kgqh2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 28, 2015 at 01:50:09AM +0100, Christoph Anton Mitterer wrote:
> On Sun, 2015-12-27 at 07:09 +0000, Duncan wrote:
> > raid1 mode
> I wonder when that reaches my pain threshold... and I submit a patch
> that renames it "notreallyraid1" in all places ;-)

   Isn't this an FAQ already? There is already a patch to rename the
RAID modes. It's been sitting in the progs patch queue for about 2
years, because none of the senior devs has acked it yet (since it's a
big user-visible change).

   Hugo.

-- 
Hugo Mills             | Talking about music is like dancing about
hugo@... carfax.org.uk | architecture
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Frank Zappa

--Ie5iOtK4e9kgqh2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWgJcvAAoJEFheFHXiqx3krA0P/1U3Rcr5bHelopZcs2Jq+jSI
0XjAV3i32oAvi8afLsnozReCnCGaeAoQ88XzhHoBWTHyxUs7LBnpn+U9gGsXVi0W
TqVDtTk7KDC4mIwCdq3hCIJBc+j3Mli/2jYXizVHta5Zh6bXoHH0pp5TofcdnaO4
h0hWF+Wbzn9sYmybkS/AiJpHX4h3qhqBrgatKhLwD6M27e39eezJQOeNXu3ZpaME
1EZdva/FevYDOhE7O9l8fkwzG+SYO8e7C4ECAa0Hh9VDh4lSSbOaFDgO1sRqWXwL
QrP817hJS/muP/1l+xHPAAl46j4u3lYcH2g4E4CxwdIGq1luB2MoGafbq6jqO1sQ
qZeIHIQcDomSfC+EnSvBOJwXVCZq0FwgeJ3dVpiZTJC1Grc6S4Ohd4D5rgUTnT1f
5iynypED294J+3RARTJEdwi92KAdskj2EKkdHawQhdrNec20pK65VwZkDT2bPkUR
vwFAn6WB9dVyKOdaSq8GixHOadYFGj0lmGrCALFrrjFoH81Pe9Sy/TXsepaM87tW
IZkUALhxxOOLS6iSdO2LzfP7BgpStHH9AWYxRrgVL81QFvUeVEdrDbxkYVn1vscg
RthaicHWrURxdOzR/1dsN8GE0m3Mfu8eFPKxyxmNCyaUDoVQqCek8dvp9Kg7XP96
rvZjOcWJ3SsyVfWnKuwo
=wInH
-----END PGP SIGNATURE-----

--Ie5iOtK4e9kgqh2F--
