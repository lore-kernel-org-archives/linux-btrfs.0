Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686FEECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37EF21523
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:27:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37EF21523
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bcom.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbeJQQWQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:22:16 -0400
Received: from mail.webx.cz ([109.123.222.201]:59425 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbeJQQWQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:22:16 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2018 12:22:15 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.webx.cz (Postfix) with ESMTP id 5EBAF45573
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 10:22:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.webx.cz
Received: from mail.webx.cz ([127.0.0.1])
        by localhost (mail1.webx.cz [127.0.0.1]) (amavisd-new, port 10042)
        with LMTP id C9G2iXt3Fy8P for <linux-btrfs@vger.kernel.org>;
        Wed, 17 Oct 2018 10:22:12 +0200 (CEST)
Received: from libor-nb.localnet (unknown [77.48.255.132])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.webx.cz (Postfix) with ESMTPSA id 2FBE642DF8
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 10:22:12 +0200 (CEST)
From:   Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs send receive: No space left on device
Date:   Wed, 17 Oct 2018 10:22:11 +0200
Message-ID: <3074900.XK8U9Revzq@libor-nb>
Organization: Business Communication s.r.o.
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,
i have new 32GB SSD in my intel nuc, installed debian9 on it, using btrfs as a rootfs.
Then i created subvolumes /system and /home and moved system there.

System was installed using kernel 4.9.x and filesystem created using btrfs-progs 4.7.x
Details follow:
main filesystem

# btrfs filesystem usage /mnt/btrfs/ssd/
Overall:
    Device size:                  29.08GiB
    Device allocated:              4.28GiB
    Device unallocated:           24.80GiB
    Device missing:                  0.00B
    Used:                          2.54GiB
    Free (estimated):             26.32GiB      (min: 26.32GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,single: Size:4.00GiB, Used:2.48GiB
   /dev/sda3       4.00GiB

Metadata,single: Size:256.00MiB, Used:61.05MiB
   /dev/sda3     256.00MiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda3      32.00MiB

Unallocated:
   /dev/sda3      24.80GiB

#/etc/fstab
UUID=d801da52-813d-49da-bdda-87fc6363e0ac       /mnt/btrfs/ssd          btrfs noatime,space_cache=v2,compress=lzo,commit=300,subvolid=5         0       0
UUID=d801da52-813d-49da-bdda-87fc6363e0ac       /                       btrfs   noatime,space_cache=v2,compress=lzo,commit=300,subvol=/system         0       0
UUID=d801da52-813d-49da-bdda-87fc6363e0ac       /home                   btrfs   noatime,space_cache=v2,compress=lzo,commit=300,subvol=/home         0       0

-----
Then i installed kernel from backports:
4.18.0-0.bpo.1-amd64 #1 SMP Debian 4.18.6-1~bpo9+1
and btrfs-progs 4.17

For backups , i have created 16GB iscsi device on my qnap and mounted it, created filesystem, mounted like this:
LABEL=backup                                    /mnt/btrfs/backup       btrfs   noatime,space_cache=v2,compress=lzo,subvolid=5,nofail,noauto         0       0

After send-receive operation on /home subvolume, usage looks like this:

# btrfs filesystem usage /mnt/btrfs/backup/
Overall:
    Device size:                  16.00GiB
    Device allocated:              1.27GiB
    Device unallocated:           14.73GiB
    Device missing:                  0.00B
    Used:                        844.18MiB
    Free (estimated):             14.92GiB      (min: 14.92GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,single: Size:1.01GiB, Used:833.36MiB
   /dev/sdb        1.01GiB

Metadata,single: Size:264.00MiB, Used:10.80MiB
   /dev/sdb      264.00MiB

System,single: Size:4.00MiB, Used:16.00KiB
   /dev/sdb        4.00MiB

Unallocated:
   /dev/sdb       14.73GiB


Problem is, during send-receive of system subvolume, it runs out of space:

# btrbk run /mnt/btrfs/ssd/system/ -v      
btrbk command line client, version 0.26.1  (Wed Oct 17 09:51:20 2018)
Using configuration: /etc/btrbk/btrbk.conf
Using transaction log: /var/log/btrbk.log
Creating subvolume snapshot for: /mnt/btrfs/ssd/system
[snapshot] source: /mnt/btrfs/ssd/system
[snapshot] target: /mnt/btrfs/ssd/_snapshots/system.20181017T0951
Checking for missing backups of subvolume "/mnt/btrfs/ssd/system" in "/mnt/btrfs/backup/"
Creating subvolume backup (send-receive) for: /mnt/btrfs/ssd/_snapshots/system.20181016T2034
No common parent subvolume present, creating full backup...
[send/receive] source: /mnt/btrfs/ssd/_snapshots/system.20181016T2034
[send/receive] target: /mnt/btrfs/backup/system.20181016T2034
mbuffer: error: outputThread: error writing to <stdout> at offset 0x4b5bd000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
WARNING: [send/receive] (send=/mnt/btrfs/ssd/_snapshots/system.20181016T2034, receive=/mnt/btrfs/backup) At subvol /mnt/btrfs/ssd/_snapshots/system.20181016T2034
WARNING: [send/receive] (send=/mnt/btrfs/ssd/_snapshots/system.20181016T2034, receive=/mnt/btrfs/backup) At subvol system.20181016T2034
ERROR: rename o77417-5519-0 -> lib/modules/4.18.0-0.bpo.1-amd64/kernel/drivers/watchdog/pcwd_pci.ko failed: No space left on device
ERROR: Failed to send/receive btrfs subvolume: /mnt/btrfs/ssd/_snapshots/system.20181016T2034  -> /mnt/btrfs/backup
[delete] options: commit-after
[delete] target: /mnt/btrfs/backup/system.20181016T2034
WARNING: Deleted partially received (garbled) subvolume: /mnt/btrfs/backup/system.20181016T2034
ERROR: Error while resuming backups, aborting
Created 0/2 missing backups
WARNING: Skipping cleanup of snapshots for subvolume "/mnt/btrfs/ssd/system", as at least one target aborted earlier
Completed within: 116s  (Wed Oct 17 09:53:16 2018)
--------------------------------------------------------------------------------
Backup Summary (btrbk command line client, version 0.26.1)

    Date:   Wed Oct 17 09:51:20 2018
    Config: /etc/btrbk/btrbk.conf
    Filter: subvolume=/mnt/btrfs/ssd/system

Legend:
    ===  up-to-date subvolume (source snapshot)
    +++  created subvolume (source snapshot)
    ---  deleted subvolume
    ***  received subvolume (non-incremental)
    >>>  received subvolume (incremental)
--------------------------------------------------------------------------------
/mnt/btrfs/ssd/system
+++ /mnt/btrfs/ssd/_snapshots/system.20181017T0951
!!! /mnt/btrfs/backup/system.20181016T2034
!!! Target "/mnt/btrfs/backup" aborted: Failed to send/receive subvolume

NOTE: Some errors occurred, which may result in missing backups!
Please check warning and error messages above.
-----------------------------

With compression=none or compression=zlib , send-receive runs ok

Usage looks like this (after transfer):
# btrfs filesystem usage /mnt/btrfs/backup/
Overall:
    Device size:                  16.00GiB
    Device allocated:              2.27GiB
    Device unallocated:           13.73GiB
    Device missing:                  0.00B
    Used:                          1.64GiB
    Free (estimated):             14.15GiB      (min: 14.15GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,single: Size:2.01GiB, Used:1.59GiB
   /dev/sdb        2.01GiB

Metadata,single: Size:264.00MiB, Used:54.20MiB
   /dev/sdb      264.00MiB

System,single: Size:4.00MiB, Used:16.00KiB
   /dev/sdb        4.00MiB

Unallocated:
   /dev/sdb       13.73GiB


I will stick to zlib for now, i just wanted to report this

Thanks,
Libor



