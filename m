Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37944 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2F2Nr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 09:47:29 -0400
Date: Fri, 29 Jun 2012 14:47:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can give some help?
Message-ID: <20120629134726.GK25572@carfax.org.uk>
References: <CAEH94LgsFojUrrMPCkzY+OMbq=SWCMpfvV_J0NzO7E58zXDXzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SCOJXUq1iwCn05li"
In-Reply-To: <CAEH94LgsFojUrrMPCkzY+OMbq=SWCMpfvV_J0NzO7E58zXDXzQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SCOJXUq1iwCn05li
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 09:41:47PM +0800, Zhi Yong Wu wrote:
> HI,
> 
> Can anyone let me know where the funtions are declared or defined,
> such as btrfs_header_nritems(), btrfs_header_level(), etc? thanks.

   ctree.h, somewhere around or after line 1550. They're all accessor
functions, defined by a set of macros. Look for the *_SETGET_* macros.
The actual definitions of BTRFS_SETGET_FUNCS are in struct-funcs.h

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 1: Family Holiday ---       

--SCOJXUq1iwCn05li
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP7bHtIKyzvlFcI40RAlxkAJ4gXnkW1eBRQSNgJxMregpSIBrEGACeL2U0
zBglu4IovObFETep5+bb9Ls=
=x1tg
-----END PGP SIGNATURE-----

--SCOJXUq1iwCn05li--
