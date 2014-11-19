Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33887 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaKSPLy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 10:11:54 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so510397qae.27
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 07:11:54 -0800 (PST)
Message-ID: <546CB332.3080705@ubuntu.com>
Date: Wed, 19 Nov 2014 10:11:46 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org> <47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com> <546BB2EA.5080809@ubuntu.com> <E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
In-Reply-To: <E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 9:40 PM, Chris Murphy wrote:
> It’s well known on linux-raid@ that consumer drives have well over
> 30 second "deep recoveries" when they lack SCT command support. The
> WDC and Seagate “green” drives are over 2 minutes apparently. This
> isn’t easy to test because it requires a sector with enough error
> that it requires the ECC to do something, and yet not so much error
> that it gives up in less than 30 seconds. So you have to track down
> a drive model spec document (one of those 100 pagers).
> 
> This makes sense, sorta, because the manufacturer use case is 
> typically single drive only, and most proscribe raid5/6 with such 
> products. So it’s a “recover data at all costs” behavior because
> it’s assumed to be the only (immediately) available copy.

It doesn't make sense to me.  If it can't recover the data after one
or two hundred retries in one or two seconds, it can keep trying until
the cows come home and it just isn't ever going to work.

> I don’t see how that’s possible because anything other than the
> drive explicitly producing  a read error (which includes the
> affected LBA’s), it’s ambiguous what the actual problem is as far
> as the kernel is concerned. It has no way of knowing which of
> possibly dozens of ata commands queued up in the drive have
> actually hung up the drive. It has no idea why the drive is hung up
> as well.

IIRC, this is true when the drive returns failure as well.  The whole
bio is marked as failed, and the page cache layer then begins retrying
with progressively smaller requests to see if it can get *some* data out.

> No I think 30 is pretty sane for servers using SATA drives because
> if the bus is reset all pending commands in the queue get
> obliterated which is worse than just waiting up to 30 seconds. With
> SAS drives maybe less time makes sense. But in either case you
> still need configurable SCT ERC, or it needs to be a sane fixed
> default like 70 deciseconds.

Who cares if multiple commands in the queue are obliterated if they
can all be retried on the other mirror?  Better to fall back to the
other mirror NOW instead of waiting 30 seconds ( or longer! ).  Sure,
you might end up recovering more than you really had to, but that
won't hurt anything.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbLMyAAoJEI5FoCIzSKrwSM8IAJO2cwhHyxK4LFjINEbNT+ij
fT4EpyzOCs704zhOTgssgSQ8ym85PRQ8VyAIrz338m+lHqKbktZtRt7vWaealmOp
6eleIDJ/I7kggnlhkqg1V8Nctap8qBeRE34K/PaGtTrkRzBYnYxbGdDDz+rXaDi6
CSEMLJBo3I69Oj9qSOV4O18ntV/S3eln0sQ8+w2btbc3xGkG3X2FwVIJokb6IAmu
ngHUeDGXUgkEOvzw3aGDheLueGDPe+V3YlsjSbw2rH75svzXqFCUO8Jcg4NfxT0q
Nl03eoTEGlyf8x2geMWfhoKFatJ7sCMy48K0ZFAAX1k8j0ssjNaEC+q6pwrA/xU=
=Gehg
-----END PGP SIGNATURE-----
