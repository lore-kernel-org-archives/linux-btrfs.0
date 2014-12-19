Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:42871 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaLSVxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 16:53:55 -0500
Received: by mail-qg0-f42.google.com with SMTP id q108so1293768qgd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 13:53:54 -0800 (PST)
Message-ID: <54949E60.7010201@ubuntu.com>
Date: Fri, 19 Dec 2014 16:53:36 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, Daniele Testa <daniele.testa@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>	<54947432.5010107@ubuntu.com> <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com> <5494955C.3020603@fb.com>
In-Reply-To: <5494955C.3020603@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/19/2014 4:15 PM, Josef Bacik wrote:
> Please God don't turn off of checksums.  Checksums are tracked in 
> metadata anyway, they won't show up in the data accounting.  Our
> csums are 8 bytes per block, so basic math says you are going to
> max out at 604 megabytes for that big of a file.

Yes, and it is exactly that metadata space he is complaining about.
So if you don't want to use up all of that space ( and have no use for
the checksums ), then you turn them off.

> Please people try to only take advice from people who know what
> they are talking about.  So unless it's from somebody who has
> commits in btrfs/btrfs-progs take their feedback with a grain of
> salt.  Thanks,

Well that is rather arrogant and rude.  For that matter, I *do* have
commits in btrfs-progs.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUlJ5gAAoJENRVrw2cjl5RZ5MIAI0Ok0q0hFTMcYYXu1U48R4Z
AsuRg6zQDMOa9C1SqZucH2cuiiaGU8XixKcscaquoJDzzaND2kuy+sxp0k2YQnGz
+/269OmZUtwjYil1NcSFTJiE2bYUAx1R+xWUGax/03NsXRr672f0EtAQ2sIitTaG
WsNUhiU0GREpQL6pK403fO79eD2vRmgCx2w50gB2OYPQYciJ+YN0YAJ7z8VEmUro
M9xqce2oc7haAHliDvazl+7IDRkkiZ7FcpSs2nBSqiHiUhgVaxuTzHZEXvUasE5l
LamJCwiSwuevWWPCDE4N/r7qVcamKM2K/DMvZCiOuPkSm3YkcVyrUd8x4i8OEJs=
=8R13
-----END PGP SIGNATURE-----
