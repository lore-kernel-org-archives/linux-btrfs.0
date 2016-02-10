Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45969 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcBJHob (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 02:44:31 -0500
Date: Wed, 10 Feb 2016 07:44:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ian Kelling <ian@iankelling.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to show current profile?
Message-ID: <20160210074429.GH30635@carfax.org.uk>
References: <1455089809.3460336.517032378.36A389A7@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gTtJ75FAzB1T2CN6"
In-Reply-To: <1455089809.3460336.517032378.36A389A7@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gTtJ75FAzB1T2CN6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 09, 2016 at 11:36:49PM -0800, Ian Kelling wrote:
> I searched the man pages, can't seem to find it. 
> btrfs-balance can change profiles, but not show
> the current profile... seems odd.

   btrfs fi df /mountpoint

   Hugo.

-- 
Hugo Mills             | Gentlemen! You can't fight here! This is the War
hugo@... carfax.org.uk | Room!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Dr Strangelove

--gTtJ75FAzB1T2CN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWuupdAAoJEFheFHXiqx3kRzwP/2yJkZoNFa23EImXR8bmb6vt
sqYTLUogBgsh7nybuUkYoJ3SwDh1AXaz0SVEnWCaTcERfIStOTUtOAYUq46DQK03
vXoqF20j3KLI8nbMJ3AgNBMxPOgK0MU6ku3bCS39921wdJcPEpnm4FUqNxLItV4R
LwBK0haNJHQTrhJZMm5begHoPu14IVxo+MeztO9fELQsOVNO32cpniNiQn22cNGC
OSHq/TQoxNZ3pmQ+6aISsLo3powQoTzbt6QBaxfKItOj8VCpZjSMORhfnwWLjOfp
K2dQOYdaTY1astTb3PD/XOcMSeKommBdTdwhrd2z7Vnp1LD3pP9ybSp8VQMtW6Jq
KWFWf8o7F7g32Pvg1iQg4ziHDQresbrEVMgLoaAxW/xZA3dpXX6JAVJ1Z0x5XZWK
SkAgV6fk05lFPpXdnKa1N+tMTDUsFWdotiBVS19rUwGCwpoizD7YHxCFZe6r5V/2
fXyyXzFLJ/1VymcNcdTdPGqhiFAqeSYYzVBPj5YMHfMtbyKGg1mYu2Fbbraidf5o
o/jOPhbIreLHhIJfyfC/xme4GC3q9DHSTOpZ65vxrkUJsdeLJAiJ34MlNmyhEbCG
AVq70SyBdAPJipw0M7aes0SEMOL5KmASPorZAf0YHCYxa+m6hHoUvdsqJol1f1sr
/pIT1/MIB/DOplyrNJss
=OMRI
-----END PGP SIGNATURE-----

--gTtJ75FAzB1T2CN6--
