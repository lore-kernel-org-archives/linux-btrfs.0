Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35371 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaKRQ0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:26:54 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so404364qgd.30
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 08:26:53 -0800 (PST)
Message-ID: <546B7329.4080007@ubuntu.com>
Date: Tue, 18 Nov 2014 11:26:17 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org> <546B6DF0.5090306@ubuntu.com> <20141118161115.GW20972@merlins.org>
In-Reply-To: <20141118161115.GW20972@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 11:11 AM, Marc MERLIN wrote:
> That seems to be the case, but hdrecover will rule that part out at
> least.

It's already ruled out: if the read failed that is what the error
message would have said rather than a bad checksum.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEbBAEBAgAGBQJUa3MpAAoJEI5FoCIzSKrwmu4H+IPNwUZMEES7vvA7WTPcrYgw
mO2x9uR/fQJFH1u4Urf3anKXoifsHUgvgyPHotRrm1OoiB3bQgYVapVEqZ0PEkre
la3zKydJ6ZuCa/TuEvATdOxBwvUhMKJCYcwYheja+1stqEBxD8mj6HY5+HqufoLo
VaSeEeBDWvQZtGrOC8JNxfzaeFmf46W+8dQIn7qI72WYvWRfVMhCun+dR4amS8hN
cXgxAe6ElnVV4TuGHLy0n4l2Hr6oWBYLWIJhDzM9IpkfjX9jsv78nLHcoWwtaw82
gv248OcCeLnZBwoN5Tepd5Av6uHh3x9MzlXDrqnWQBWulY3f0idrFGU1y1uZvw==
=AtDf
-----END PGP SIGNATURE-----
