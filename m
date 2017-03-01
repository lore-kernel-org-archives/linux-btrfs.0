Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33782 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdCAQNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 11:13:48 -0500
Received: by mail-qk0-f172.google.com with SMTP id n127so77683072qkf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 08:13:47 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 1 Mar 2017 19:04:26 +0300
Message-ID: <CAGqmi76oFUFtD1TDjns_BFujkRc8fHSpL6Wt5yYt3SX0QPf+5A@mail.gmail.com>
Subject: Please add more info to dmesg output on I/O error
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, today i try move my FS from old HDD to new SSD
While processing i catch I/O error and device remove operation was canceled

Dmesg:
[ 1015.010241] blk_update_request: I/O error, dev sda, sector 81353664
[ 1015.010246] BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0,
rd 23, flush 0, corrupt 0, gen 0
[ 1015.010282] ata5: EH complete
[ 1017.016721] ata5.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x0
[ 1017.016730] ata5.00: irq_stat 0x40000008
[ 1017.016737] ata5.00: failed command: READ FPDMA QUEUED
[ 1017.016748] ata5.00: cmd 60/08:80:c0:5b:d9/00:00:04:00:00/40 tag 16
ncq dma 4096 in
                       res 41/40:00:c0:5b:d9/00:00:04:00:00/40 Emask
0x409 (media error) <F>
[ 1017.016754] ata5.00: status: { DRDY ERR }
[ 1017.016757] ata5.00: error: { UNC }
[ 1017.029479] ata5.00: configured for UDMA/133
[ 1017.029506] sd 4:0:0:0: [sda] tag#16 UNKNOWN(0x2003) Result:
hostbyte=0x00 driverbyte=0x08
[ 1017.029511] sd 4:0:0:0: [sda] tag#16 Sense Key : 0x3 [current]
[ 1017.029516] sd 4:0:0:0: [sda] tag#16 ASC=0x11 ASCQ=0x4
[ 1017.029520] sd 4:0:0:0: [sda] tag#16 CDB: opcode=0x28 28 00 04 d9
5b c0 00 00 08 00

At now, i fixed this problem by doing scrub FS and delete damaged
files, but scrub are slow, and if btrfs show me a more info on I/O
error, it's will be more helpful
i.e. something like i getting by scrub:
[ 1260.559180] BTRFS warning (device sdb1): i/o error at logical
40569896960 on dev /dev/sda1, sector 81351616, root 309, inode 55135,
offset 71278592, length 4096, links 1 (path:
nefelim4ag/.config/skypeforlinux/Cache/data_3)

Thanks.
-- 
Have a nice day,
Timofey.
