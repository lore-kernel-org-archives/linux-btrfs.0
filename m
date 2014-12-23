Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40041 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754691AbaLWVQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 16:16:56 -0500
Date: Tue, 23 Dec 2014 16:16:09 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors on RAID-1?
Message-ID: <20141223211605.GC436@hungrycats.org>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
 <CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
In-Reply-To: <CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 05:25:47PM -0700, Chris Murphy wrote:
> For the kernel to automatically fix
> bad sectors by overwriting them, the drive needs to explicitly report
> read errors. If the SCSI command timer value is shorter than the
> drive's error recovery, the SATA link might get reset before the drive
> reports the read error and then uncorrected errors will persist
> instead of being automatically fixed.

Is there a way to tell the kernel to go ahead and assume that all timeouts
are effectively read errors?  For a simple non-removable hard disk (i.e.
not removable and not optical), that seems like a reasonable workaround
for an assortment of firmware brokenness.

I just did a quick survey of random drives here and found less than 10%
support "smartctl -l scterc".  A lot of server drives (or at least the
drives that shipped in servers) don't have it, but laptop drives do.
Drives with firmware that has horrifying known bugs do also have this
feature.  :-P


--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSZ25MACgkQgfmLGlazG5xitgCgtpaj3QcJWSEVXxJPaVIWtVnH
4OQAnA7cQfEIrfvOkpoLxQxdYMKWasYI
=NIAP
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
