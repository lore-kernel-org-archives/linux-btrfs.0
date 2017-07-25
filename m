Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:8895 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdGYR4X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 13:56:23 -0400
Received: from mordor.fritz.box (x5f74b90b.dyn.telefonica.de [95.116.185.11])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id q070b2t6PHuM2Bd
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Tue, 25 Jul 2017 19:56:22 +0200 (CEST)
Message-ID: <1501005382.3020.4.camel@cloud.haefemeier.eu>
Subject: Re: Best Practice: Add new device to RAID1 pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 25 Jul 2017 19:56:22 +0200
In-Reply-To: <20170724204257.GJ7140@carfax.org.uk>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
         <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
         <20170724204257.GJ7140@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 24.07.2017, 20:42 +0000 schrieb Hugo Mills:
> On Mon, Jul 24, 2017 at 02:35:05PM -0600, Chris Murphy wrote:
> > On Mon, Jul 24, 2017 at 5:27 AM, Cloud Admin <admin@cloud.haefemeie
> > r.eu> wrote:
> > 
> > > I am a little bit confused because the balance command is running
> > > since
> > > 12 hours and only 3GB of data are touched.
> > 
> > That's incredibly slow. Something isn't right.
> > 
> > Using btrfs-debug -b from btrfs-progs, I've selected a few 100%
> > full chunks.
> > 
> > [156777.077378] f26s.localdomain sudo[13757]:    chris : TTY=pts/2
> > ;
> > PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs balance start
> > -dvrange=157970071552..159043813376 /
> > [156773.328606] f26s.localdomain kernel: BTRFS info (device sda1):
> > relocating block group 157970071552 flags data
> > [156800.408918] f26s.localdomain kernel: BTRFS info (device sda1):
> > found 38952 extents
> > [156861.343067] f26s.localdomain kernel: BTRFS info (device sda1):
> > found 38951 extents
> > 
> > That 1GiB chunk with quite a few fragments took 88s. That's 11MB/s.
> > Even for a hard drive, that's slow. I've got maybe a dozen
> > snapshots
> > on this particular volume and quotas are not enabled. By definition
> > all of those extents are sequential. So I'm not sure why it's
> > taking
> > so long. Seems almost like a regression somewhere. A nearby chunk
> > with
> > ~23k extents only takes 45s to balance. And another chunk with
> > ~32000
> > extents took 55s to balance.
> 
>    In my experience, it's pretty consistent at about a minute per 1
> GiB for data on rotational drives on RAID-1. For metadata, it can go
> up to several hours (or more) per 256 MiB chunk, depending on what
> kind of metadata it is. With extents shared between lots of files, it
> slows down. In my case, with a few hundred snapshots of the same
> thing, my system was taking 4h per chunk for the chunks full of the
> extent tree.
After disabling quota the balancing is no working faster. After 27h
approx. 1.3TB are done. It has taken around 4h of rearrange the data on
the old three discs the process started to use the new one. Since there
it is processing much faster.

Bye
	Frank
