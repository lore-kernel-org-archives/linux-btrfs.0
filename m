Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45076 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaF0VuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 17:50:11 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so5126367pab.18
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 14:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140627204005.GB28692@merlins.org>
References: <20140627185009.GA21428@merlins.org>
	<20140627204005.GB28692@merlins.org>
Date: Fri, 27 Jun 2014 14:50:10 -0700
Message-ID: <CAN05THQznt1=7yDTbJcwZqB149E3VueoTALmfyKJALQR9dPSAw@mail.gmail.com>
Subject: Re: Also seeing full deadlocks with 3.15.1
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 1:40 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Fri, Jun 27, 2014 at 11:50:09AM -0700, Marc MERLIN wrote:
>> My laptop deadlocked some more times (everything works until it needs to
>> touch the filesystem, and then it's deadlocked).
>> Unfortunately, I can trigger sysrq, but it doesn't get committed to disk and
>> netconsole eats half of it because it goes too fast for UDP apparently
>>
>> Now, I just captured that on my server with serial console.
>>
>> 11005  1-16:11:10 wait_current_trans.isra.15     /usr/bin/zma -m 3
>> 14441  1-16:07:44 wait_current_trans.isra.15     /usr/bin/zma -m 1
>> 17045  1-23:53:33 wait_current_trans.isra.15     /usr/bin/zma -m 9
>> 22261  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 6
>> 22292  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 8
>>
>> 19911    09:29:35 wait_current_trans.isra.15     rm -f -- /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13 /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13.gz
>> 22848  1-05:18:35 wait_current_trans.isra.15     rm -f -- mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11 mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11.gz
>>
>> Those are 2 different filesystems (one single device mapper disk, the other one is btrfs raid1), so I'm not sure which one of the 2 caused the problem, but I'm perplexed as to why one would than hang the other, unless they both hit the same bug?
>
> Ok, soon after reboot, I'm already seeing this:
>   742       37:19 wait_current_trans.isra.15     /usr/bin/zma -m 9
>  5494       06:45 wait_current_trans.isra.15     /bin/rm -rf 1/14/06/27/13/10/18
> 11258    01:48:28 wait_current_trans.isra.15     /usr/bin/zma -m 3
> 14076       27:01 wait_current_trans.isra.15     /usr/bin/zma -m 1
> 21615       47:18 wait_current_trans.isra.15     /usr/bin/zma -m 8
>
> on this filesystem:
> gargamel:~# btrfs fi df /mnt/btrfs_raid0/
> Data, RAID0: total=1.47TiB, used=892.25GiB
> Data, single: total=8.00MiB, used=7.95MiB
> System, RAID1: total=8.00MiB, used=128.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=15.00GiB, used=6.09GiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=512.00MiB, used=64.00KiB
>
> If I don't hear anything by the end of today, I'll just delete the
> filesystem and start over.

At some stage it would be nice to see not only fixes but also changes
to fsck to make it able to repair these problems.
Blow it away and create a new filesystem from scratch is sub-optimal.

>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
