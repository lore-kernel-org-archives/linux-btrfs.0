Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:41610 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbeF2RoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 13:44:10 -0400
Received: by mail-lf0-f45.google.com with SMTP id y127-v6so7360965lfc.8
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 10:44:09 -0700 (PDT)
Subject: Re: Incremental send/receive broken after snapshot restore
To: Hannes Schweizer <schweizer.hannes@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOfGOYyT2F-6jtKgpgm6iX5aK-kP1Ryuz_rcTFs=s05_FeAPoQ@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <1115fcb3-4e07-6fd9-17cb-56a8ba46a7ab@gmail.com>
Date: Fri, 29 Jun 2018 20:44:06 +0300
MIME-Version: 1.0
In-Reply-To: <CAOfGOYyT2F-6jtKgpgm6iX5aK-kP1Ryuz_rcTFs=s05_FeAPoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

28.06.2018 23:09, Hannes Schweizer пишет:
> Hi,
> 
> Here's my environment:
> Linux diablo 4.17.0-gentoo #5 SMP Mon Jun 25 00:26:55 CEST 2018 x86_64
> Intel(R) Core(TM) i5 CPU 760 @ 2.80GHz GenuineIntel GNU/Linux
> btrfs-progs v4.17
> 
> Label: 'online'  uuid: e4dc6617-b7ed-4dfb-84a6-26e3952c8390
>         Total devices 2 FS bytes used 3.16TiB
>         devid    1 size 1.82TiB used 1.58TiB path /dev/mapper/online0
>         devid    2 size 1.82TiB used 1.58TiB path /dev/mapper/online1
> Data, RAID0: total=3.16TiB, used=3.15TiB
> System, RAID0: total=16.00MiB, used=240.00KiB
> Metadata, RAID0: total=7.00GiB, used=4.91GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Label: 'offline'  uuid: 5b449116-93e5-473e-aaf5-bf3097b14f29
>         Total devices 2 FS bytes used 3.52TiB
>         devid    1 size 5.46TiB used 3.53TiB path /dev/mapper/offline0
>         devid    2 size 5.46TiB used 3.53TiB path /dev/mapper/offline1
> Data, RAID1: total=3.52TiB, used=3.52TiB
> System, RAID1: total=8.00MiB, used=512.00KiB
> Metadata, RAID1: total=6.00GiB, used=5.11GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Label: 'external'  uuid: 8bf13621-01f0-4f09-95c7-2c157d3087d0
>         Total devices 1 FS bytes used 3.65TiB
>         devid    1 size 5.46TiB used 3.66TiB path
> /dev/mapper/luks-3c196e96-d46c-4a9c-9583-b79c707678fc
> Data, single: total=3.64TiB, used=3.64TiB
> System, DUP: total=32.00MiB, used=448.00KiB
> Metadata, DUP: total=11.00GiB, used=9.72GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> The following automatic backup scheme is in place:
> hourly:
> btrfs sub snap -r online/root online/root.<date>
> 
> daily:
> btrfs sub snap -r online/root online/root.<new_offline_reference>
> btrfs send -c online/root.<old_offline_reference>
> online/root.<new_offline_reference> | btrfs receive offline
> btrfs sub del -c online/root.<old_offline_reference>
> 
> monthly:
> btrfs sub snap -r online/root online/root.<new_external_reference>
> btrfs send -c online/root.<old_external_reference>
> online/root.<new_external_reference> | btrfs receive external
> btrfs sub del -c online/root.<old_external_reference>
> 
> Now here are the commands leading up to my problem:
> After the online filesystem suddenly went ro, and btrfs check showed
> massive problems, I decided to start the online array from scratch:
> 1: mkfs.btrfs -f -d raid0 -m raid0 -L "online" /dev/mapper/online0
> /dev/mapper/online1
> 
> As you can see from the backup commands above, the snapshots of
> offline and external are not related, so in order to at least keep the
> extensive backlog of the external snapshot set (including all
> reflinks), I decided to restore the latest snapshot from external.
> 2: btrfs send external/root.<external_reference> | btrfs receive online
> 
> I wanted to ensure I can restart the incremental backup flow from
> online to external, so I did this
> 3: mv online/root.<external_reference> online/root
> 4: btrfs sub snap -r online/root online/root.<external_reference>
> 5: btrfs property set online/root ro false
> 
> Now, I naively expected a simple restart of my automatic backups for
> external should work.
> However after running
> 6: btrfs sub snap -r online/root online/root.<new_external_reference>
> 7: btrfs send -c online/root.<old_external_reference>
> online/root.<new_external_reference> | btrfs receive external

You just recreated your "online" filesystem from scratch. Where
"old_external_reference" comes from? You did not show steps used to
create it.

> I see the following error:
> ERROR: unlink root/.ssh/agent-diablo-_dev_pts_3 failed. No such file
> or directory
> 
> Which is unfortunate, but the second problem actually encouraged me to
> post this message.
> As planned, I had to start the offline array from scratch as well,
> because I no longer had any reference snapshot for incremental backups
> on other devices:
> 8: mkfs.btrfs -f -d raid1 -m raid1 -L "offline" /dev/mapper/offline0
> /dev/mapper/offline1
> 
> However restarting the automatic daily backup flow bails out with a
> similar error, although no potentially problematic previous
> incremental snapshots should be involved here!
> ERROR: unlink o925031-987-0/2139527549 failed. No such file or directory
> 

Again - before you can *re*start incremental-forever sequence you need
initial full copy. How exactly did you restart it if no snapshots exist
either on source or on destination?

> I'm a bit lost now. The only thing I could image which might be
> confusing for btrfs,
> is the residual "Received UUID" of online/root.<external_reference>
> after command 2.
> What's the recommended way to restore snapshots with send/receive
> without breaking subsequent incremental backups (including reflinks of
> existing backups)?
> 
> Any hints appreciated...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

