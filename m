Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:34016 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752195AbcKPKnj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 05:43:39 -0500
Date: Wed, 16 Nov 2016 15:43:36 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Steigerwald <martin.steigerwald@teamix.de>
Cc: <linux-btrfs@vger.kernel.org>, Martin <martin@lichtvoll.de>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable
 to find block group for 0
Message-ID: <20161116154336.543a326b@natsu>
In-Reply-To: <18970348.FUMEOFOSb3@merkaba>
References: <18970348.FUMEOFOSb3@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Nov 2016 11:25:00 +0100
Martin Steigerwald <martin.steigerwald@teamix.de> wrote:

>     merkaba:~> mount -o degraded,clear_cache /dev/satafp1/backup /mnt/zeit
>     mount: Falscher Dateisystemtyp, ungültige Optionen, der
>     Superblock von /dev/mapper/satafp1-backup ist beschädigt, fehlende
>     Kodierungsseite oder ein anderer Fehler
> 
>           Manchmal liefert das Systemprotokoll wertvolle Informationen –
>           versuchen Sie  dmesg | tail  oder ähnlich
>     merkaba:~#32> dmesg | tail -6
>     [ 3080.120687] BTRFS info (device dm-13): allowing degraded mounts
>     [ 3080.120699] BTRFS info (device dm-13): force clearing of disk cache
>     [ 3080.120703] BTRFS info (device dm-13): disk space caching is enabled
>     [ 3080.120706] BTRFS info (device dm-13): has skinny extents
>     [ 3080.150957] BTRFS warning (device dm-13): missing devices (1) exceeds the limit (0), writeable mount is not allowed
>     [ 3080.195941] BTRFS: open_ctree failed

I have to wonder did you read the above message? What you need at this point
is simply "-o degraded,ro". But I don't see that tried anywhere down the line.

See also (or try): https://patchwork.kernel.org/patch/9419189/

-- 
With respect,
Roman
