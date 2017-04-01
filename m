Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36868 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbdDAQ3Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 12:29:24 -0400
Date: Sat, 1 Apr 2017 16:29:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lukas Tribus <lukyt@gmx.net>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: is send/receive
Message-ID: <20170401162923.GA11512@carfax.org.uk>
References: <f0776e88-95b6-de16-bc65-b016302b4e30@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <f0776e88-95b6-de16-bc65-b016302b4e30@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 01, 2017 at 05:25:06PM +0200, Lukas Tribus wrote:
> Hello experts,
> 
> 
> quick question about btrfs send/receive:
> 
> Is btrfs send/receive is prone to cause destination filesystem
> corruption/failure, when the source file system is bogus (due to
> bugs, or due to other factors like memory bit-flips happening, both
> *within* the source file system)?
> 
> Or asked differently: does send/receive transfer metadata/tree
> (which may be corrupt) from source to destination?

   Not at that level, no.

   A send stream consists of a sequence of FS operations (copy, mkdir,
reflink, mv, snapshot, etc) which can be used to create a subvolume
which is logically equivalent to the source subvolume. Thus, if there
are broken invariants in the metadata of the source FS, they cannot be
recreated in the destination FS, because you can't create broken
metadata using those operations.

> I would like to know if send/receive is a *completely* appropriate
> to backup data to a destination btrfs filesystem, or if there is a -
> even a one in a million - chance it may corrupt the destination FS.
> Would it be preferable to use a non-btrfs destination FS for backup
> purposes? What do you guys think?

   If you have corruption which results in otherwise valid POSIX
metadata (say, somehow a UID got changed, or some permissions bits got
set into a silly but valid configuration), then that could be
transferred. Corruption leading to a "broken" filesystem (say, an
undeletable directory), no.

> Also, if I understand correctly, checksum are not transferred
> through send/receive, therefor a corruption while transferring is
> possible (just like with rsync), right?

   Correct.

   Hugo.

-- 
Hugo Mills             | Dullest spy film ever: The Eastbourne Ultimatum
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       The Thick of It

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY39ViAAoJEFheFHXiqx3kyQQP/1uUk8N15tUqwyi386PW78kq
tLnX/b7A6ereMxvnf5++hMN0C92bvKxOCMou5B+uFKaczyTFjsEwzoCSI5XkIRXj
xATMpRUtTJH5GWwYhPm4z6nqoNfuWk5BpjfWXMW+iGV+jZLJiZxV0ehHO9vw8aYH
jcCw7TyzgsHJPeCU+M9+mz/X8GJ1lrqcGnfaxS/RgbfJ1nYRZXQNP1xBtnxQRisU
SUkZFbxjJXy2gENhZ2DtaTk3t3LgGRLhXP6fuWUFRAyA/neswJAfG6dBAyWezTHV
v781GKEP4OlYBq0HZOpILRhddecZ+Za4DWLDY1K+FuoZaXd/R2ASMATMFob4FUK3
DTOUosFDa8lSGFMTepcj15so6ZYYV+TAb2Vrxe8kNGcFDIZF2qMD0ZQOEaDPzUKe
5PgF4gz+E1aJJyEP+9F40peE4UUXbD7rZeZJBgrl4epbHwnJswxIxMp4W4BJuYud
rdQx0BFHFw0XCg+pSe6aoT8n3//T2OM0upCc1CopHi14rr4Z7RYmw9lvCsH5IE0H
NVKHN+77paA0s6pB5FSEWiW4soTClKaASR4OrYhZHCoHIG+YewkgB2EMTB7zioNa
Rj7aCEoyTCpsOnvBenuM/CzATcTTTq/47JGoLsrqvcfosbNAKU2eHe8NXWBCrhJp
kekzjFDlne3gWQS1Yrwo
=ZmJg
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
