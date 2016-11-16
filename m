Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:40935 "EHLO
        mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbcKPKzg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 05:55:36 -0500
From: Martin Steigerwald <martin.steigerwald@teamix.de>
To: Roman Mamedov <rm@romanrm.net>
CC: <linux-btrfs@vger.kernel.org>, Martin <martin@lichtvoll.de>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Wed, 16 Nov 2016 11:55:32 +0100
Message-ID: <3374757.aMVjisyVFB@merkaba>
In-Reply-To: <20161116154336.543a326b@natsu>
References: <18970348.FUMEOFOSb3@merkaba> <20161116154336.543a326b@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Am Mittwoch, 16. November 2016, 15:43:36 CET schrieb Roman Mamedov:
> On Wed, 16 Nov 2016 11:25:00 +0100
> 
> Martin Steigerwald <martin.steigerwald@teamix.de> wrote:
> >     merkaba:~> mount -o degraded,clear_cache /dev/satafp1/backup /mnt/zeit
> >     mount: Falscher Dateisystemtyp, ungültige Optionen, der
> >     Superblock von /dev/mapper/satafp1-backup ist beschädigt, fehlende
> >     Kodierungsseite oder ein anderer Fehler
> >     
> >           Manchmal liefert das Systemprotokoll wertvolle Informationen –
> >           versuchen Sie  dmesg | tail  oder ähnlich
> >     
> >     merkaba:~#32> dmesg | tail -6
> >     [ 3080.120687] BTRFS info (device dm-13): allowing degraded mounts
> >     [ 3080.120699] BTRFS info (device dm-13): force clearing of disk cache
> >     [ 3080.120703] BTRFS info (device dm-13): disk space caching is
> >     enabled
> >     [ 3080.120706] BTRFS info (device dm-13): has skinny extents
> >     [ 3080.150957] BTRFS warning (device dm-13): missing devices (1)
> >     exceeds the limit (0), writeable mount is not allowed
> >     [ 3080.195941] BTRFS: open_ctree failed
> 
> I have to wonder did you read the above message? What you need at this point
> is simply "-o degraded,ro". But I don't see that tried anywhere down the
> line.
> 
> See also (or try): https://patchwork.kernel.org/patch/9419189/

Actually I read that one, but I read more into it than what it was saying:

I read into it that BTRFS would automatically use a read only mount.


merkaba:~> mount -o degraded,ro /dev/satafp1/daten /mnt/zeit

actually really works. *Thank you*, Roman.


I do think that above kernel messages invite such a kind of interpretation
tough. I took the "BTRFS: open_ctree failed" message as indicative to some
structural issue with the filesystem.


So mounting work although for some reason scrubbing is aborted (I had this
issue a long time ago on my laptop as well). After removing /var/lib/btrfs 
scrub status file for the filesystem:

    merkaba:~> btrfs scrub start /mnt/zeit
    scrub started on /mnt/zeit, fsid […] (pid=9054)
    merkaba:~> btrfs scrub status /mnt/zeit
    scrub status for […]
            scrub started at Wed Nov 16 11:52:56 2016 and was aborted after 
00:00:00
            total bytes scrubbed: 0.00B with 0 errors

Anyway, I will now just rsync off the files.

Interestingly enough btrfs restore complained about looping over certain
files… lets see whether the rsync or btrfs send/receive proceeds through.

Ciao,

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

