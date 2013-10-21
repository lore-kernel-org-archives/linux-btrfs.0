Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38976 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3JUP6Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 11:58:16 -0400
Date: Mon, 21 Oct 2013 16:58:13 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: lilofile <lilofile@aliyun.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS_INODE_NODATACOW
Message-ID: <20131021155813.GF6598@carfax.org.uk>
References: <547ffa6f-f5d8-45d1-8412-ec9890928173@aliyun.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GV0iVqYguTV4Q9ER"
In-Reply-To: <547ffa6f-f5d8-45d1-8412-ec9890928173@aliyun.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GV0iVqYguTV4Q9ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2013 at 11:53:42PM +0800, lilofile wrote:
> 
> BTRFS_INODE_NODATACOW
> what does this macro means?

   A file with that attribute set will be modified in place, rather
than have extents CoWed when they're modified. This is the
implementation of the +C attribute.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Normaliser unix c'est comme pasteuriser le Camembert ---       

--GV0iVqYguTV4Q9ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmVPFVheFHXiqx3kAQLFSQ/7BifWj8bn797BbGdARNKrrEmIuVibnNyB
5SFn7ki3Rvppzg3wTn/PgXP7P3TGL7NFWfyatN5gOZ1dTlSwfaMtd8372k4AqJsZ
4s6qGEvNLVzkxCe6vKnAOjqOGsyG3xvKlBn1IRAhua3fXCc9JolJ835mjxKFKdvm
AS+ZSD468raK3u1IUSomrTsreBAl9XHj6wH0K93V/6xnJr2wN4PYW7wsgaSfFjx+
15q62XyDggzn67YCr20AhQ531hIdVwaeXify6P9gjB+yoLtK3kroYjVCJvAwgGb8
FOaTAm/FSkFv5Ix+aoK3y/B+ap7AB2Us2wbG9Ovpm0//fJ1KOQL9cOcf61+Whjtn
g+n0sSR4zYDSBwZWs9/yQ4e3GyRzIj0Q7Au+MUTw3p1g4gHiH0eMLZeadEwuyqVl
ZCDyhGB2nB9RCZAg9G+LcILf495aS3zlHMcnTcUPRaa15yje9cbPZ8e/hGlWet4T
pYtaT3Sl0Y2FL57JdlEmVHVm1BzwC1jrNLGZJNtW26BFLc5c+qFlwdKkqPsLmQRf
utzqmDnHFvyetBDIok2ddAbX8UkbzL2YY65ZMj56TwSmr9uu1PuuKmREBDov4mEx
GAhqVmdWQfSpNsoPsgoWcD9MAvFF5jVifZtTaf4djLKnkNGz1uUHsHABSEqhQ5IE
uPb/KJM9hzs=
=MX6Y
-----END PGP SIGNATURE-----

--GV0iVqYguTV4Q9ER--
