Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:40962 "EHLO
        mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbcKPLSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 06:18:05 -0500
From: Martin Steigerwald <martin.steigerwald@teamix.de>
To: Roman Mamedov <rm@romanrm.net>
CC: <linux-btrfs@vger.kernel.org>, Martin <martin@lichtvoll.de>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Wed, 16 Nov 2016 12:18:01 +0100
Message-ID: <51015243.zNEmreFU16@merkaba>
In-Reply-To: <3374757.aMVjisyVFB@merkaba>
References: <18970348.FUMEOFOSb3@merkaba> <20161116154336.543a326b@natsu> <3374757.aMVjisyVFB@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Am Mittwoch, 16. November 2016, 11:55:32 CET schrieben Sie:
> So mounting work although for some reason scrubbing is aborted (I had this
> issue a long time ago on my laptop as well). After removing /var/lib/btrfs 
> scrub status file for the filesystem:
> 
>     merkaba:~> btrfs scrub start /mnt/zeit
>     scrub started on /mnt/zeit, fsid […] (pid=9054)
>     merkaba:~> btrfs scrub status /mnt/zeit
>     scrub status for […]
>             scrub started at Wed Nov 16 11:52:56 2016 and was aborted after 
> 00:00:00
>             total bytes scrubbed: 0.00B with 0 errors
> 
> Anyway, I will now just rsync off the files.
> 
> Interestingly enough btrfs restore complained about looping over certain
> files… lets see whether the rsync or btrfs send/receive proceeds through.

I have an idea on why scrubbing may not work:

The filesystem is mounted read only and on checksum errors on one disk scrub 
would try to repair it with the good copy from another disk.

Yes, this is it:

    merkaba:~>  btrfs scrub start -r /dev/satafp1/daten
    scrub started on /dev/satafp1/daten, fsid […] (pid=9375)
    merkaba:~>  btrfs scrub status /dev/satafp1/daten 
    scrub status for […]
            scrub started at Wed Nov 16 12:13:27 2016, running for 00:00:10
            total bytes scrubbed: 45.53MiB with 0 errors

It would be helpful to receive a proper error message on this one.

Okay, seems today I learned quite something about BTRFS.

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

