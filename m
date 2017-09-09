Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:57299 "EHLO
        smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753250AbdIIHqV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 03:46:21 -0400
Received: from smtp1.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp1.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 108DE20377
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 03:46:21 -0400 (EDT)
Received: by smtp1.relay.ord1c.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id A059520375
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 03:46:20 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 152FB10417
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 07:46:10 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Subject: Please help with exact actions for raid1 hot-swap
Message-ID: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
Date: Sat, 9 Sep 2017 10:46:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I'm going to replace one hard drive (partition actually) of a btrfs 
raid1. Can you please spell exactly what I need to do in order to get my 
filesystem working as RAID1 again after replacement, exactly as it was 
before? I saw some bad examples of drive replacement in this list so I 
afraid to just follow random instructions on wiki, and putting this 
system out of action even temporarily would be very inconvenient.

For this filesystem:

> $ sudo btrfs fi show /dev/sdb7
> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>     Total devices 2 FS bytes used 106.23GiB
>     devid    1 size 2.71TiB used 126.01GiB path /dev/sda7
>     devid    2 size 2.71TiB used 126.01GiB path /dev/sdb7
> $ grep /mnt/data /proc/mounts
> /dev/sda7 /mnt/data btrfs 
> rw,noatime,space_cache,autodefrag,subvolid=5,subvol=/ 0 0
> $ sudo btrfs fi df /mnt/data
> Data, RAID1: total=123.00GiB, used=104.57GiB
> System, RAID1: total=8.00MiB, used=48.00KiB
> Metadata, RAID1: total=3.00GiB, used=1.67GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> $ uname -a
> Linux host 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC 
> 2017 x86_64 x86_64 x86_64 GNU/Linux

I've got this in dmesg:

> [Sep 8 20:31] ata6.00: exception Emask 0x0 SAct 0x7ecaa5ef SErr 0x0 
> action 0x0
> [  +0.000051] ata6.00: irq_stat 0x40000008
> [  +0.000029] ata6.00: failed command: READ FPDMA QUEUED
> [  +0.000038] ata6.00: cmd 60/70:18:50:6c:f3/00:00:79:00:00/40 tag 3 
> ncq 57344 in
>                        res 41/40:00:68:6c:f3/00:00:79:00:00/40 Emask 
> 0x409 (media error) <F>
> [  +0.000094] ata6.00: status: { DRDY ERR }
> [  +0.000026] ata6.00: error: { UNC }
> [  +0.001195] ata6.00: configured for UDMA/133
> [  +0.000030] sd 6:0:0:0: [sdb] tag#3 FAILED Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE
> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 Sense Key : Medium Error 
> [current] [descriptor]
> [  +0.000004] sd 6:0:0:0: [sdb] tag#3 Add. Sense: Unrecovered read 
> error - auto reallocate failed
> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 CDB: Read(16) 88 00 00 00 00 00 
> 79 f3 6c 50 00 00 00 70 00 00
> [  +0.000003] blk_update_request: I/O error, dev sdb, sector 2045996136
> [  +0.000047] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0, rd 
> 1, flush 0, corrupt 0, gen 0
> [  +0.000062] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0, rd 
> 2, flush 0, corrupt 0, gen 0
> [  +0.000077] ata6: EH complete

There's still 1 in Current_Pending_Sector line of smartctl output as of 
now, so it probably won't heal by itself.

--

With Best Regards,
Marat Khalili
