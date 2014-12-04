Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60246 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbaLDUzG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 15:55:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 48D565E2A7F
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 21:55:03 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WKlXwi-oh21y for <linux-btrfs@vger.kernel.org>;
	Thu,  4 Dec 2014 21:55:02 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 21:55:02 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 04 Dec 2014 21:55:02 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs device delete missing - Input/output error
Message-ID: <002540148940af9d5cad8d2ede3577b0@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs RAID-1, one of the drive failed and was replaced.

Unfortunately the second drive is also showing errors and "btrfs device 
delete missing" exits with error:

# btrfs device delete missing /home
ERROR: error removing the device 'missing' - Input/output error


Is there a way for btrfs to ignore these errors? I'd rather loose a few 
files here and there than the whole filesystem.


# btrfs fi show /home
Label: none  uuid: 92e93437-cc9f-475d-a739-085f3270896b
         Total devices 3 FS bytes used 1.40TiB
         devid    2 size 1.70TiB used 1.46TiB path /dev/sdb4
         devid    3 size 1.70TiB used 322.00GiB path /dev/sda4
         *** Some devices missing


# smartctl -a /dev/sdb | grep -i Reallocated
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always 
       -       0


# dmesg -c
[26677.752448] BTRFS info (device sdb4): relocating block group 
1375492636672 flags 17
[26684.803713] ata4.00: exception Emask 0x0 SAct 0x7c000003 SErr 0x0 
action 0x0
[26684.803786] ata4.00: irq_stat 0x40000008
[26684.803846] ata4.00: failed command: READ FPDMA QUEUED
[26684.803899] ata4.00: cmd 60/00:d0:00:89:db/04:00:86:00:00/40 tag 26 
ncq 524288 in
[26684.803899]          res 41/40:00:b0:8b:db/00:04:86:00:00/00 Emask 
0x409 (media error) <F>
[26684.805329] ata4.00: status: { DRDY ERR }
[26684.805388] ata4.00: error: { UNC }
[26684.876401] ata4.00: configured for UDMA/133
[26684.876499] sd 3:0:0:0: [sdb]
[26684.876564] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[26684.876628] sd 3:0:0:0: [sdb]
[26684.876687] Sense Key : Medium Error [current] [descriptor]
[26684.876749] Descriptor sense data with sense descriptors (in hex):
[26684.876810]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[26684.876871]         86 db 8b b0
[26684.876921] sd 3:0:0:0: [sdb]
[26684.876970] Add. Sense: Unrecovered read error - auto reallocate 
failed
[26684.877032] sd 3:0:0:0: [sdb] CDB:
[26684.877081] Read(16): 88 00 00 00 00 00 86 db 89 00 00 00 04 00 00 00
[26684.877143] end_request: I/O error, dev sdb, sector 2262535088
[26684.877196] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 15, flush 0, corrupt 
0, gen 0
[26684.877294] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 16, flush 0, corrupt 
0, gen 0
[26684.877393] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 17, flush 0, corrupt 
0, gen 0
[26684.877511] ata4: EH complete
[26687.978787] ata4.00: exception Emask 0x0 SAct 0x400 SErr 0x0 action 
0x0
[26687.978872] ata4.00: irq_stat 0x40000008
[26687.978937] ata4.00: failed command: READ FPDMA QUEUED
[26687.979006] ata4.00: cmd 60/80:50:80:8b:db/01:00:86:00:00/40 tag 10 
ncq 196608 in
[26687.979006]          res 41/40:80:b0:8b:db/00:01:86:00:00/00 Emask 
0x409 (media error) <F>
[26687.979250] ata4.00: status: { DRDY ERR }
[26687.979312] ata4.00: error: { UNC }
[26688.059820] ata4.00: configured for UDMA/133
[26688.059909] sd 3:0:0:0: [sdb]
[26688.059970] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[26688.060041] sd 3:0:0:0: [sdb]
[26688.060115] Sense Key : Medium Error [current] [descriptor]
[26688.060184] Descriptor sense data with sense descriptors (in hex):
[26688.060251]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[26688.060334]         86 db 8b b0
[26688.060399] sd 3:0:0:0: [sdb]
[26688.060462] Add. Sense: Unrecovered read error - auto reallocate 
failed
[26688.060530] sd 3:0:0:0: [sdb] CDB:
[26688.060590] Read(16): 88 00 00 00 00 00 86 db 8b 80 00 00 01 80 00 00
[26688.060677] end_request: I/O error, dev sdb, sector 2262535088
[26688.060744] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 18, flush 0, corrupt 
0, gen 0
[26688.060875] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 19, flush 0, corrupt 
0, gen 0
[26688.061011] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 20, flush 0, corrupt 
0, gen 0
[26688.061151] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 21, flush 0, corrupt 
0, gen 0
[26688.061275] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 22, flush 0, corrupt 
0, gen 0
[26688.061446] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 23, flush 0, corrupt 
0, gen 0
[26688.061602] ata4: EH complete
[26690.921047] ata4.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 
0x0
[26690.921119] ata4.00: irq_stat 0x40000008
[26690.921179] ata4.00: failed command: READ FPDMA QUEUED
[26690.921232] ata4.00: cmd 60/08:58:b0:8b:db/00:00:86:00:00/40 tag 11 
ncq 4096 in
[26690.921232]          res 41/40:08:b0:8b:db/00:00:86:00:00/00 Emask 
0x409 (media error) <F>
[26690.921426] ata4.00: status: { DRDY ERR }
[26690.921475] ata4.00: error: { UNC }
[26691.002497] ata4.00: configured for UDMA/133
[26691.002576] sd 3:0:0:0: [sdb]
[26691.002634] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[26691.002686] sd 3:0:0:0: [sdb]
[26691.002734] Sense Key : Medium Error [current] [descriptor]
[26691.002787] Descriptor sense data with sense descriptors (in hex):
[26691.002839]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[26691.002900]         86 db 8b b0
[26691.002951] sd 3:0:0:0: [sdb]
[26691.002999] Add. Sense: Unrecovered read error - auto reallocate 
failed
[26691.003053] sd 3:0:0:0: [sdb] CDB:
[26691.003101] Read(16): 88 00 00 00 00 00 86 db 8b b0 00 00 00 08 00 00
[26691.003163] end_request: I/O error, dev sdb, sector 2262535088
[26691.003215] btrfs_dev_stat_print_on_error: 36 callbacks suppressed
[26691.003268] BTRFS: bdev /dev/sdb4 errs: wr 0, rd 60, flush 0, corrupt 
0, gen 0
[26691.003383] ata4: EH complete



-- 
Tomasz Chmielewski
http://www.sslrack.com

