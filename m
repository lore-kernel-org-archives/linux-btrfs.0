Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40988 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaCMT2f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 15:28:35 -0400
Date: Thu, 13 Mar 2014 19:28:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael Schuerig <michael.lists@schuerig.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
Message-ID: <20140313192832.GE6151@carfax.org.uk>
References: <1564384.fRV1HUkfCq@fuchsia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
In-Reply-To: <1564384.fRV1HUkfCq@fuchsia>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
> 
> My backup use case is different from the what has been recently 
> discussed in another thread. I'm trying to guard against hardware 
> failure and other causes of destruction.
> 
> I have a btrfs raid1 filesystem spread over two disks. I want to backup 
> this filesystem regularly and efficiently to an external disk (same 
> model as the ones in the raid) in such a way that
> 
> * when one disk in the raid fails, I can substitute the backup and 
> rebalancing from the surviving disk to the substitute only applies the 
> missing changes.
> 
> * when the entire raid fails, I can re-build a new one from the backup.
> 
> The filesystem is mounted at its root and has several nested subvolumes 
> and snapshots (in a .snapshots subdir on each subvol).
> 
> Is it possible to do what I'm looking for?

   For point 2, yes. (Add new disk, balance -oconvert from single to
raid1).

   For point 1, not really. It's a different filesystem, so it'll have
a different UUID. You *might* be able to get away with rsync of one of
the block devices in the array to the backup block device, but you'd
have to unmount the FS (or halt all writes to it) for the period of
the rsync to ensure a consistent image, and the rsync would have to
read all the data in the device being synced to work out what to send.
Probably not what you want.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Do not meddle in the affairs of system administrators,  for ---   
                  they are subtle,  and quick to anger.                  

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUyIG4FheFHXiqx3kAQIicQ//RSAWRoQ77sf4vmM1vMqR92gfnw0Z5bFX
7+FrZ3ad+v/fn6RNrdfjPDF8AhKH7jzfQK6aqOdb+g1KbOPtP+NBYRulCtzj46WK
THeru/lwd4/YpHuRdtdWI2+SI7IRlZCe0P0T8204cfpJ2L8EE+eb4clJ/89oZdw8
saDxNPRaten9kaT5uBvbJgsvm5XPULFlY4wA0d+wA5dnrzYdQYF7YUwywNruFApD
LJiYWlzd/i2ePzaR6unMpyZm12yRRTTiRBKl02XLlmEuDI6tpzZDd8C2w2eYCHbo
JL3DPZDPOFoIlHkJucUwxDdTNxyfN+fq0qsR89h0Eg8TIrCCvvDeezhHHofwEvvG
WftgR2R8dS7XJ6aFMiQUfBN5Zpnx3Q6TXrlsx974m2BFDkhKPiLLvirHve2hHZf+
V8iO7Vqq5F14Ia+LMmckxZTDEG891c6sAFHJNQ+HjTHVxUpHG0/0TocYlFiy5jG5
8yxBrpjvmK/gRcmhkeeekKbNTPjg3Y6VX9pK/PTCiqp7v2Lp0iVgHsGQrTWVueR+
gLSnOAzpeoTUU+HbVdY3ntVBDNWTc0bXiFxYSNlkiWi1er2S9lc14cc4FK46vumO
1dv6wdxXQwFGZ6UxJO5rLu4Udvus/4IvrN62nAQ+joalktf6TpUUdsM63NCk59gd
zV29o2PY6ZQ=
=X8Ut
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
