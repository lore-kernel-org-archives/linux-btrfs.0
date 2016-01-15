Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa65.mailout.artfiles.de ([212.72.176.65]:39031 "EHLO
	mailout-afa65.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbcAOJLM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:11:12 -0500
Received: from [132.230.80.54] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1aK0PV-0002n2-UQ
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 10:11:10 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Recursive delete file from all subvolumes (snapshots)
Date: Fri, 15 Jan 2016 10:11:05 +0100
Message-ID: <1627987.rImNt6gQkd@discus>
In-Reply-To: <20160115140539.3afa66f0@natsu>
References: <15624885.ucZm0n36hp@discus> <20160115140539.3afa66f0@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2365233.xfFrd3z6jy"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2365233.xfFrd3z6jy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, January 15, 2016 2:05:39 PM CET Roman Mamedov wrote:
> On Fri, 15 Jan 2016 09:33:14 +0100
> 
> Wolfgang Mader <Wolfgang_Mader@brain-frog.de> wrote:
> > I have a btrfs raid 10 from which I take hourly snapshots using snapper.
> > Now, I wonder, if there is a way to delete a file together with all its
> > occurrences in all snapshots.
> > 
> > My use case is, that the file I want to delete is large, and I want to
> > free its space on disk. Thus, I have to get rid of its "live" version but
> > also of all references to it in snapshots.
> 
> E.g. if your file is at /path/to/file.dat, and your snapshot structure is
> /snapshots/YYYY-MM-DD@time/, you would simply do:
> 
> rm /snapshots/*/path/to/file.dat
> 
> In fact this is what I often do with my timed snapshots when deleting some
> files and wanting to recover free space immediately, not waiting for all
> their snapshots to expire and get deleted by the usual time-based deletion
> rules.
> 
> If your snapshots are read-only it becomes more complex, but still doable.

Neat idea.

Thx.

--nextPart2365233.xfFrd3z6jy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWmLepAAoJEGZtonfLCdqhy7EQALRM1SVqQK1n/0WbPD5bmdhU
HN4TR9C68hmMruTdJhVecrN4cXQw5aZGS7ZNNV2vL3DA5sEcFEI7qB0ve29VmYlH
+f3JA1GL5kcOVC0+zP+Yfl/YWEGyrefs7edcNS+854DmPCRRJxo4/ykLETnKInoa
Nq4MtdHphCWQSvGyo6oNaSBdCNnuR6SBWLIsX0EFC0c7776P3Rnpuc7YFNJwhEIs
V1pRQX3FUgaWi1yaNIVZnbugzCuY7DiWQa3VpTRhotWsCra9ISTP30pwrdNyu0PF
hmGuxMpFyecvY3BkrZvKExndDae9DyPYs/R/YU/2hiyMEdJKMHikd4jvYdmmvu+x
EWynMHuUyMMfAxtu8sisnnD9WyjvDleHmeQ8JUoOVGIIROV1oyxzGAshhOL94yWF
ZJ555HdZXMzB15nREzFaQJPygQEPaz21AjskydAOzbb0NlI6YV0Tv+VBVuWtLX5W
XP5zZSQP71c/EPAaid08ajsAhXeJ1U47NdTF18HpT4fNb1/AcvWeJWxKmQvUHtbd
J6IqPBAAgInpPxDFBXxyUbIFAyhLhEqioLKu98fL/2uppnt1s5gCVWHLfmMwQK4x
zy5Rryg6WUwsCqgWJSWsOpodTZsoRU6aK2LY8sC6VBVLycESo24k+NejnyBWG44C
6OCM3Ld4jlQZWDjn1t2D
=U2Oc
-----END PGP SIGNATURE-----

--nextPart2365233.xfFrd3z6jy--

