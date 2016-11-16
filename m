Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:40943 "EHLO
        mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422662AbcKPLEj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 06:04:39 -0500
From: Martin Steigerwald <martin.steigerwald@teamix.de>
To: Roman Mamedov <rm@romanrm.net>
CC: <linux-btrfs@vger.kernel.org>, Martin <martin@lichtvoll.de>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Wed, 16 Nov 2016 12:04:37 +0100
Message-ID: <1672818.LEbdb7TNyD@merkaba>
In-Reply-To: <20161116160031.59041b46@natsu>
References: <18970348.FUMEOFOSb3@merkaba> <3374757.aMVjisyVFB@merkaba> <20161116160031.59041b46@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Am Mittwoch, 16. November 2016, 16:00:31 CET schrieb Roman Mamedov:
> On Wed, 16 Nov 2016 11:55:32 +0100
> 
> Martin Steigerwald <martin.steigerwald@teamix.de> wrote:
> > I do think that above kernel messages invite such a kind of interpretation
> > tough. I took the "BTRFS: open_ctree failed" message as indicative to some
> > structural issue with the filesystem.
> 
> For the reason as to why the writable mount didn't work, check "btrfs fi df"
> for the filesystem to see if you have any "single" profile chunks on it:
> quite likely you did already mount it "degraded,rw" in the past *once*,
> after which those "single" chunks get created, and consequently it won't
> mount r/w anymore (without lifting the restriction on the number of missing
> devices as proposed).

That exactly explains it. I very likely did a degraded mount without ro on 
this disk already.

Funnily enough this creates another complication:

    merkaba:/mnt/zeit#1> btrfs send somesubvolume | btrfs receive /mnt/
someotherbtrfs        
    ERROR: subvolume /mnt/zeit/somesubvolume is not read-only

Yet:

    merkaba:/mnt/zeit> btrfs property get somesubvolume
    ro=false
    merkaba:/mnt/zeit> btrfs property set somesubvolume ro true                  
    ERROR: failed to set flags for somesubvolume: Read-only file system

To me it seems right logic would be to allow the send to proceed in case
the whole filesystem is readonly.

As there seems to be no force option to override the limitation and I
do not feel like compiling my own btrfs-tools right now, I will use rsync
instead.

Thanks,

-- 
Martin Steigerwald  | Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller

teamix Support Hotline: +49 911 30999-112
 
 *** Bitte liken Sie uns auf Facebook: facebook.com/teamix ***

