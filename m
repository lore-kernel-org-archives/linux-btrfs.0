Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51140 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaKRQEh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:04:37 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so344920qgd.30
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 08:04:37 -0800 (PST)
Message-ID: <546B6DF0.5090306@ubuntu.com>
Date: Tue, 18 Nov 2014 11:04:00 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Brendan Hide <brendan@swiftspirit.co.za>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>
In-Reply-To: <20141118153526.GS20972@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 10:35 AM, Marc MERLIN wrote:
> Try running hdrecover on your drive, it'll scan all your blocks and
> try to rewrite the ones that are failing, if any: 
> http://hdrecover.sourceforge.net/

He doesn't have blocks that are failing; he has blocks that are being
silently corrupted.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa23wAAoJEI5FoCIzSKrwXTMH/3KhuXuNbPBY0jALRS6kVAew
M3gfJ1kMeZgiBZzUlZb0GsB9J3i+Ei+nF7NQ7taMKey84sPxhQVjpYZV0LZxWNwe
RSga4/Kfnk8TGphwBBeK5e3tOypmv+ECCB4p4uQHXqPAvoFiIALdHYzZGYb0kM8e
ydTonqtUiR8WJ0uqy24/vl7uJyTkj0xz4Adk2ksrbVhW1Z8md2LesKOCtCLa3bVn
Qu8Um/KIBPNBbB21FYN1KyBUMvkx2uGDcu7YRfxXpPnZLwZ9NdMjlOzY8P+EnhFt
cW+tW3mYO9BMhONxi8m7hDI5wj+dsPFblqA5CRBwAOG5b4fsE2pwZwdqYoASmd4=
=2Ho1
-----END PGP SIGNATURE-----
