Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60700 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdCAUoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 15:44:00 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cjA4Z-0006mK-9M
        for linux-btrfs@vger.kernel.org; Wed, 01 Mar 2017 20:38:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Please add more info to dmesg output on I/O error
Date: Wed, 1 Mar 2017 20:38:00 +0100
Message-ID: <20170301203800.4f9cbfa0@jupiter.sol.kaishome.de>
References: <CAGqmi76oFUFtD1TDjns_BFujkRc8fHSpL6Wt5yYt3SX0QPf+5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 1 Mar 2017 19:04:26 +0300
schrieb Timofey Titovets <nefelim4ag@gmail.com>:

> Hi, today i try move my FS from old HDD to new SSD
> While processing i catch I/O error and device remove operation was
> canceled
> 
> Dmesg:
> [ 1015.010241] blk_update_request: I/O error, dev sda, sector 81353664
> [ 1015.010246] BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0,
> rd 23, flush 0, corrupt 0, gen 0
> [ 1015.010282] ata5: EH complete
> [ 1017.016721] ata5.00: exception Emask 0x0 SAct 0x10000 SErr 0x0
> action 0x0 [ 1017.016730] ata5.00: irq_stat 0x40000008
> [ 1017.016737] ata5.00: failed command: READ FPDMA QUEUED
> [ 1017.016748] ata5.00: cmd 60/08:80:c0:5b:d9/00:00:04:00:00/40 tag 16
> ncq dma 4096 in
>                        res 41/40:00:c0:5b:d9/00:00:04:00:00/40 Emask
> 0x409 (media error) <F>
> [ 1017.016754] ata5.00: status: { DRDY ERR }
> [ 1017.016757] ata5.00: error: { UNC }
> [ 1017.029479] ata5.00: configured for UDMA/133
> [ 1017.029506] sd 4:0:0:0: [sda] tag#16 UNKNOWN(0x2003) Result:
> hostbyte=0x00 driverbyte=0x08
> [ 1017.029511] sd 4:0:0:0: [sda] tag#16 Sense Key : 0x3 [current]
> [ 1017.029516] sd 4:0:0:0: [sda] tag#16 ASC=0x11 ASCQ=0x4
> [ 1017.029520] sd 4:0:0:0: [sda] tag#16 CDB: opcode=0x28 28 00 04 d9
> 5b c0 00 00 08 00
> 
> At now, i fixed this problem by doing scrub FS and delete damaged
> files, but scrub are slow, and if btrfs show me a more info on I/O
> error, it's will be more helpful
> i.e. something like i getting by scrub:
> [ 1260.559180] BTRFS warning (device sdb1): i/o error at logical
> 40569896960 on dev /dev/sda1, sector 81351616, root 309, inode 55135,
> offset 71278592, length 4096, links 1 (path:
> nefelim4ag/.config/skypeforlinux/Cache/data_3)
> 
> Thanks.

You should turn off SCT ERC with smartctl or set it to lower values, or
if that doesn't work with your HDD firmware, increase the timeout of
the scsi driver above 120s. This setup as it is, is not going to work
correctly with btrfs in case of errors.

# smartctl -l scterc,70,70 /dev/sdb

should do the trick if supported. It applies an error correction
timeout of 7 seconds for reading and writing, which is below the kernel
scsi layer timeout of 30 seconds. Otherwise, your drive will fail to
respond for two minutes until the kernel resets the drive. According to
dmesg, this is what happened.

NAS-ready drives usually support this setting, while desktop drives
don't or at least default to standard desktop timeouts.

-- 
Regards,
Kai

Replies to list-only preferred.

