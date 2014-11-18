Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:53223 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaKRQDD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:03:03 -0500
Received: by mail-qg0-f49.google.com with SMTP id a108so5385744qge.8
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 08:03:00 -0800 (PST)
Message-ID: <546B6D8F.7090005@ubuntu.com>
Date: Tue, 18 Nov 2014 11:02:23 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <546B36A4.2030101@gmail.com>
In-Reply-To: <546B36A4.2030101@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 7:08 AM, Austin S Hemmelgarn wrote:
> In addition to the storage controller being a possibility as
> mentioned in another reply, there are some parts of the drive that
> aren't covered by SMART attributes on most disks, most notably the
> on-drive cache. There really isn't a way to disable the read cache
> on the drive, but you can disable write-caching, which may improve
> things (and if it's a cheap disk, may provide better reliability
> for BTRFS as well).  The other thing I would suggest trying is a
> different data cable to the drive itself, I've had issues with some
> SATA cables (the cheap red ones you get in the retail packaging for
> some hard disks in particular) having either bad connectors, or bad
> strain-reliefs, and failing after only a few hundred hours of use.

SATA does CRC the data going across it so if it is a bad cable, you
get CRC, or often times 8b10b coding errors and the transfer is
aborted rather than returning bad data.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa22PAAoJEI5FoCIzSKrwqlAH/3p1iftYkX3DAMgMmWra9AZT
2OA4PIwzgKIhANpy+ZQo4c+W1ZUwo2V6sxLvG8/oM3HfITGyfwNA5HgTbQrlx/iU
vdRHq+y60gCruIa0lRST5JCQMbez7eXvSNOWNAZYbtNH/BNyMxwFuav14zFZpNxO
QovXxhk1D5vLf+ID2jwa5mF1Zj7b5GEhb4zzqK+xU1QNeWppLFhB3da+llae8qxf
eFtNt8ebtknr7QMCFrbaYCq1z1I+Fy8EjskkdI4ZW6AgBRPQDDmB8gNCmAAbSaZC
2Ze/AB4Xr6uuGQ4iK7nprKXUtPJFLzGYx+JQ2EeBJtin9ivno1fEY45CMreuzv4=
=6Oy/
-----END PGP SIGNATURE-----
