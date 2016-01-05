Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:34132 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbcAEQfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 11:35:39 -0500
Subject: Re: device removal seems to be very slow (kernel 4.1.15)
To: David Goodwin <david@codepoets.co.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <568BBF5D.40304@codepoets.co.uk>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <568BF0D9.6030908@bouton.name>
Date: Tue, 5 Jan 2016 17:35:37 +0100
MIME-Version: 1.0
In-Reply-To: <568BBF5D.40304@codepoets.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 05/01/2016 14:04, David Goodwin a écrit :
> Using btrfs progs 4.3.1 on a Vanilla kernel.org 4.1.15 kernel.
>
> time btrfs device delete /dev/xvdh /backups
>
> real    13936m56.796s
> user    0m0.000s
> sys     1351m48.280s
>
>
> (which is about 9 days).
>
> Where :
>
> /dev/xvdh was 120gb in size.
>

That's very slow. Last week with a 4.1.12 kernel I just deleted a 3TB
SATA 7200rpm device with ~1.5TB used on a RAID10 filesystem (reduced
from 6 3TB devices to 5 devices in the process) in approximately 38
hours. This was without virtualisation though but there were some
damaged sectors to handle along the way which should have slowed the
delete a bit and it had more than 10 times the data to move than your
/dev/xvdh.

Note about the damaged sectors :
we use 7 disks for this BTRFS RAID10 arrays but to reduce the risk of
having to restore huge backups (see recent discussion about BTRFS RAID10
not protecting against 2-devices failure at all), as soon as numerous
damaged sectors appear on a drive we delete it from the RAID10 and add
it to a MD RAID1 array which is one of the devices on the BTRFS RAID10
(right now we have 5 devices in the RAID10 one of them being a 3-way md
RAID1 with disks having these numerous reallocated sectors)  : so the
reads from the deleted device had some errors to handle and the writes
on the md RAID1 device triggered some sector relocations too. Note that
ideally I would replace at least 2 of the disks in the md RAID1 because
I know from experience that they will fail in the short future (my
estimate is between right now and 6 months at best given the current
rate of reallocated sectors) but replacing a working drive with damaged
sectors costs us some downtime and a one time fee (unlike a drive which
is either unreadable or doesn't pass SMART tests anymore). We can live
with both the occasional slowdowns (SATA errors generated when the
drives detect new damaged sectors usually block IOs for a handful of
seconds) and the minor risk this causes : until now this worked OK for
this server, the md RAID1 array acts as a buffer for disks that are
slowly dying (and the monthly BTRFS scrub + md raid check helps getting
the worst ones up to the point where they fail fast enough to avoid
accumulating too much bad drives in this array for long periods of time).

>
> /backups is a single / "raid 0" volume that now looks like :
>
> Label: 'BACKUP_BTRFS_SNAPS'  uuid: 6ee08c31-f310-4890-8424-b88bb77186ed
>     Total devices 3 FS bytes used 301.09GiB
>     devid    1 size 100.00GiB used 90.00GiB path /dev/xvdg
>     devid    3 size 220.00GiB used 196.06GiB path /dev/xvdi
>     devid    4 size 221.00GiB used 59.06GiB path /dev/xvdj
>
>
> There are about 400 snapshots on it.

I'm not sure if the number of snapshots can impact the device delete
operation: the slow part of device delete is relocating block groups
which (AFAIK) seems to be one level down in the stack and shouldn't even
know about snapshots. If however you create or delete snapshots during
the delete operation you could probably slow down the delete.

Best regards,

Lionel
