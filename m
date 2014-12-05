Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51360 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaLEKDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 05:03:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 05 Dec 2014 11:03:03 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: lists@colorremedies.com
Subject: Re: btrfs device delete missing - Input/output error
Message-ID: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The first way to try to recover the current volume would be to
> overwrite LBA 2262535088 which you should only do with the filesystem
> unmounted. That's the sector causing the read error. If this is a 512
> byte drive:
> 
> dd if=/dev/zero of=/dev/sdb count=1 seek=2262535088

It is a 512 byte drive.

Unfortunately overwriting that fails - which is quite weird, given that 
there are 0 reallocated sectors, according to SMART.

Is there a way to determine what's stored there (i.e. if it's a file?).


# dd if=/dev/zero of=/dev/sdb count=1 seek=2262535088
dd: writing to `/dev/sdb': Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 2.88439 s, 0.0 kB/s

# dmesg -c
[ 8177.713212] ata4.00: exception Emask 0x0 SAct 0x400 SErr 0x0 action 
0x0
[ 8177.713285] ata4.00: irq_stat 0x40000008
[ 8177.713349] ata4.00: failed command: READ FPDMA QUEUED
[ 8177.713419] ata4.00: cmd 60/08:50:b0:8b:db/00:00:86:00:00/40 tag 10 
ncq 4096 in
[ 8177.713419]          res 41/40:08:b0:8b:db/00:00:86:00:00/00 Emask 
0x409 (media error) <F>
[ 8177.713662] ata4.00: status: { DRDY ERR }
[ 8177.713725] ata4.00: error: { UNC }
[ 8177.755099] ata4.00: configured for UDMA/133
[ 8177.755175] sd 3:0:0:0: [sdb]
[ 8177.755252] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 8177.755318] sd 3:0:0:0: [sdb]
[ 8177.755380] Sense Key : Medium Error [current] [descriptor]
[ 8177.755449] Descriptor sense data with sense descriptors (in hex):
[ 8177.755516]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 8177.755600]         86 db 8b b0
[ 8177.755667] sd 3:0:0:0: [sdb]
[ 8177.755729] Add. Sense: Unrecovered read error - auto reallocate 
failed
[ 8177.757316] sd 3:0:0:0: [sdb] CDB:
[ 8177.757377] Read(16): 88 00 00 00 00 00 86 db 8b b0 00 00 00 08 00 00
[ 8177.757463] end_request: I/O error, dev sdb, sector 2262535088
[ 8177.757542] ata4: EH complete

-- 
Tomasz Chmielewski
http://www.sslrack.com

