Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mar44-4-88-161-154-132.fbx.proxad.net ([88.161.154.132]:35595
	"EHLO arthur.lutz.im" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaAMWdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 17:33:07 -0500
Received: from [192.168.0.11] (unknown [192.168.0.254])
	by arthur.lutz.im (Postfix) with ESMTPSA id 0DE9F38CE0BC
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 23:23:25 +0100 (CET)
Message-ID: <52D46759.2090000@lutz.im>
Date: Mon, 13 Jan 2014 23:23:21 +0100
From: Arthur Lutz <arthur@lutz.im>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Add speed profiles to devices
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

It would be a great feature to have speed profiles linked to devices so
that btrfs could differentiate write or read operations according to
some metrics collected over time.

The use case would be : one has 3 disks as RAID1 but one of the disks is
older and slower than the two other disks. In this configuration the
third disk serves a bit as an online backup but it would be nice for a
write to be considered as done when the two fast disks have completed
the write, the third one acting asynchronously. If one of the two fast
disks fails we fall back to syncronous writing on that third device.

This would be great for mixing SSD and traditional drives too.

Issue submitted on https://bugzilla.kernel.org/show_bug.cgi?id=68671

Thanks.

Arthur
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJS1GdZAAoJELB9duUjqo16KxIQALNLqogzuJyaNDHuyHezJvrf
fSHC3vjyEsGjTc8H/lC+VqbetzEep0w7do1yF0blZVrAbqJVArY1kCOXkb7dUHuA
BzWHVIgGD3JBvYnU4tEJML35zPBXsHtV+ouCp+h7P30RASDDRdtDnRo7CtP7nEJO
T75ZyUfHyZmUnEMWTkrdoFJT1xI+6TeMS+5ACHLe8bz7+rgUXyyjDUBdmTNJ87+8
/ya7Mjc8ICHhAkmzFtXUwMcoIwjBo872pgffQxNGLxvX6/f9cVpo1foc+TPuMkat
1rRjtksNx36n7yX4DeNH3c2qvg9wB2BFFlCGcD+bL5xr87ql9l/UlyVxvFMCtCrK
UVXXDU56V51kk75wJu4QssxKcQ80I7zj2/aHVDEr/+OnAkRWTYs/2KKGv+1kih3u
qNaz0fm5aWF6MHlFhtOHCVMEy68evpzGddMPgMDM+pmxrfzdbhPdSL5UAX5WXuHQ
YKo2qzYsew19/nE6OomWCR+0m+FoVokbERNqcsPfSANcghyQ+QWWytPGOlxPFdB9
uL8vZ+GoErMH78Q0b6ZNlona+cIH0bWmmh54RCWw24KyagXU9KPx33zOd/TnI847
2LNhXStkMKWNMEhErblwSK3RqOr8jUJ111HviQCQO5B/TfaAHoV+0VNhaLIhR25Y
oLKcrGti8FiKhDiVySN1
=AJ4Y
-----END PGP SIGNATURE-----

