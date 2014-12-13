Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38940 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965106AbaLMFPK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 00:15:10 -0500
Date: Sat, 13 Dec 2014 00:15:09 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Erkki Seppala <flux-btrfs@inside.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
Message-ID: <20141213051457.GF22023@hungrycats.org>
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
 <5488F0A8.7070503@pobox.com>
 <44336672.dmUL7ANCyf@russell.coker.com.au>
 <548A4560.9010105@pobox.com>
 <m49egs5b515.fsf@coffee.modeemi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
In-Reply-To: <m49egs5b515.fsf@coffee.modeemi.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2014 at 11:17:58AM +0200, Erkki Seppala wrote:
> That may be sort of true, but I think even SMART is helped by the fact
> that the media is read through from the beginning to the end*, so it can
> detect even the errors that don't bubble through the IO layer. And BTRFS
> can indeed note errors that the media doesn't - two checksums is better
> than one checksum, assuming they aren't exactly the same algorithm ;).
>=20
> Do you alternatively execute SMART self tests?
>=20
> * scrub doesn't do this, it reads only through used data

I do both.  They operate at different layers of the storage stack, and have
access to different information.  They also have different (and hopefully
non-overlapping) bugs.

scrub pros:

	+ can compare data with the other copies in RAID1 or DUP mode

	+ can fix bad data when good copies available

	+ slows down when other processes want to use the disk

	+ can be suspended and resumed at will by software

	+ error data is impervious to drive firmware bugs

	+ straightforward error reports

	+ only scans allocated data

scrub cons:

	- only scans allocated data

	- btrfs filesystems only

	- CPU and I/O burden

	- error sources are not localized:  scrub errors could be software
	bugs, bad RAM, bad CPU cooling, bad cabling, bad power supply,
	or bad hard drive

smart pros:

	+ runs in the background

	+ no CPU or I/O required, just read results from previous run
	and launch new test daily

	+ access to electrical and mechanical data from the drive
	that are otherwise unavailable to the host

	+ 100% surface scan (including bad sector count)

	+ logs host I/O errors that OS might miss
	(e.g. because they occur during BIOS booting)

	+ works with any filesystems, partitions, swap, etc.

	+ error sources are localized to the drive in test

smart cons:

	- buggy firmware does not detect or report error events when
	significant failures occur

	- buggy firmware does detect and report error events when
	signficant failures do not occur

	- buggy firmware will make host accesses painfully slow during
	scan (WD Green is very bad for this)

	- firmware does not implement useful subset of SMART command set

	- SMART command set can be inaccessible through some SATA bridge
	chips (especially USB)

	- cannot fix anything, only report quantities of data already lost

	- cannot reliably detect RAM or CPU failure (on host or drive)

	- requires the drive to spin for 1-2 continuous hours during test

	- interpreting the raw data is a black art

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSLy1EACgkQgfmLGlazG5xlEwCgiDAH+jOIb27r+hm4I6HTUm1E
SP4An3cU1/ERj0Wxdja/qIJQj4J0QmVf
=mTsa
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
