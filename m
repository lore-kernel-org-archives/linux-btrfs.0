Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:33032 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdGFMIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Jul 2017 08:08:32 -0400
Subject: Re: Btrfs Compression
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <MEXPR01MB2168F46962D1BFF8BC303A279ED50@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <3ae39509-7d12-807d-c827-f43401766fc1@gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <257debdb-4e71-d615-96af-3faec46226ba@bouton.name>
Date: Thu, 6 Jul 2017 14:02:06 +0200
MIME-Version: 1.0
In-Reply-To: <3ae39509-7d12-807d-c827-f43401766fc1@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 06/07/2017 à 13:51, Austin S. Hemmelgarn a écrit :
>
> Additionally, when you're referring to extent size, I assume you mean
> the huge number of 128k extents that the FIEMAP ioctl (and at least
> older versions of `filefrag`) shows for compressed files?  If that's
> the case, then it's important to understand that that's due to an
> issue with FIEMAP, it doesn't understand compressed extents in BTRFS
> correctly, so it shows one extent per compressed _block_ instead, even
> if they are internally an extent in BTRFS.  You can verify the actual
> number of extents by checking how many runs of continuous 128k
> 'extents' there are.

This is in fact the problem : compressed extents are far less likely to
be contiguous than uncompressed extents (even compensating for the
fiemap limitations). When calling defrag on these files BTRFS is likely
to ignore the fragmentation too : when I modeled the cost of reading a
file as stored vs the ideal cost if it were in one single block I got
this surprise. Uncompressed files can be fully defragmented most of the
time, compressed files usually reach a fragmentation cost of
approximately 1.5x to 2.5x the ideal case after defragmentation (it
seems to depend on how the whole filesystem is used).

Lionel
