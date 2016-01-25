Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from st11p01im-asmtp002.me.com ([17.172.204.152]:47781 "EHLO
	st11p01im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbcAYP6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 10:58:38 -0500
Received: from bonobo.home
 (host86-142-71-68.range86-142.btcentralplus.com [86.142.71.68])
 by st11p01im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.36.0 64bit (built Sep  8 2015))
 with ESMTPSA id <0O1I0150PK9KZX20@st11p01im-asmtp002.me.com> for
 linux-btrfs@vger.kernel.org; Mon, 25 Jan 2016 14:58:35 +0000 (GMT)
From: WillIam Thorne <will.thorne@me.com>
Content-type: text/plain; charset=utf-8
Subject: suspected BTRFS errors resulting in file system becoming unrecovable
Message-id: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
Date: Mon, 25 Jan 2016 14:58:31 +0000
To: linux-btrfs@vger.kernel.org
MIME-version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi 

I have a WD 3TB external HD attached over USB to an arm based micro PC (rasp pi). I was experimenting with btrfs for storing email archives but recently encountered some problems which resulted in the filesystem becoming apparently unrecoverable. I’m not an expert and it was quicker to switch back to ext4 and restored from backup so no support needed. Here what appears to be the relevant part of the syslog including the stack trace in case it is useful:

Best
W

pi@mail /var/log $ btrfs --version
Btrfs Btrfs v0.19

pi@mail /var/log $ uname -a
Linux mail 4.1.7-v7+ #817 SMP PREEMPT Sat Sep 19 15:32:00 BST 2015 armv7l GNU/Linux

Jan 20 09:42:08 mail kernel: [2762753.507576] usb 1-1.5: reset high-speed USB device number 4 using dwc_otg
Jan 20 09:43:18 mail kernel: [2762823.972777] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.972806] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.972819] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.972837] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2c 20 00 00 f0 00
Jan 20 09:43:18 mail kernel: [2762823.972851] blk_update_request: I/O error, dev sda, sector 16198688
Jan 20 09:43:18 mail kernel: [2762823.972867] BTRFS: bdev /dev/sda1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.976998] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.977015] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.977028] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.977042] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2d 10 00 00 f0 00
Jan 20 09:43:18 mail kernel: [2762823.977052] blk_update_request: I/O error, dev sda, sector 16198928
Jan 20 09:43:18 mail kernel: [2762823.977066] BTRFS: bdev /dev/sda1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.978226] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.978273] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.978286] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.978301] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2e 00 00 00 20 00
Jan 20 09:43:18 mail kernel: [2762823.978318] blk_update_request: I/O error, dev sda, sector 16199168
Jan 20 09:43:18 mail kernel: [2762823.978339] BTRFS: bdev /dev/sda1 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.983241] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.983264] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.983277] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.983292] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c3 f8 00 00 f0 00
Jan 20 09:43:18 mail kernel: [2762823.983304] blk_update_request: I/O error, dev sda, sector 16172024
Jan 20 09:43:18 mail kernel: [2762823.983319] BTRFS: bdev /dev/sda1 errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.987799] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.987818] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.987830] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.987844] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c4 e8 00 00 f0 00
Jan 20 09:43:18 mail kernel: [2762823.987855] blk_update_request: I/O error, dev sda, sector 16172264
Jan 20 09:43:18 mail kernel: [2762823.987869] BTRFS: bdev /dev/sda1 errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.989136] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.989155] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.989168] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.989182] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c5 d8 00 00 20 00
Jan 20 09:43:18 mail kernel: [2762823.989193] blk_update_request: I/O error, dev sda, sector 16172504
Jan 20 09:43:18 mail kernel: [2762823.989207] BTRFS: bdev /dev/sda1 errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.993965] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.993988] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.994000] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.994015] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 17 53 68 00 00 c0 00
Jan 20 09:43:18 mail kernel: [2762823.994028] blk_update_request: I/O error, dev sda, sector 1528680
Jan 20 09:43:18 mail kernel: [2762823.994043] BTRFS: bdev /dev/sda1 errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.994058] BTRFS: bdev /dev/sda1 errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.994070] BTRFS: bdev /dev/sda1 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.997419] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Jan 20 09:43:18 mail kernel: [2762823.997435] sd 0:0:0:0: [sda] Sense Key : 0x2 [current] 
Jan 20 09:43:18 mail kernel: [2762823.997448] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0 
Jan 20 09:43:18 mail kernel: [2762823.997461] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 37 53 68 00 00 c0 00
Jan 20 09:43:18 mail kernel: [2762823.997471] blk_update_request: I/O error, dev sda, sector 3625832
Jan 20 09:43:18 mail kernel: [2762823.997484] BTRFS: bdev /dev/sda1 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
Jan 20 09:43:18 mail kernel: [2762823.997601] BTRFS: error (device sda1) in btrfs_commit_transaction:2068: errno=-5 IO failure (Error while writing out transaction)
Jan 20 09:43:18 mail kernel: [2762824.011517] BTRFS info (device sda1): forced readonly
Jan 20 09:43:18 mail kernel: [2762824.011537] BTRFS warning (device sda1): Skipping commit of aborted transaction.
Jan 20 09:43:18 mail kernel: [2762824.011576] ------------[ cut here ]------------
Jan 20 09:43:18 mail kernel: [2762824.011682] WARNING: CPU: 0 PID: 1318 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0xd8/0x128 [btrfs]()
Jan 20 09:43:18 mail kernel: [2762824.011709] BTRFS: Transaction aborted (error -5)
Jan 20 09:43:18 mail kernel: [2762824.011717] Modules linked in: cfg80211 rfkill snd_bcm2835 snd_pcm snd_seq snd_seq_device snd_timer snd btrfs xor xor_neon raid6_pq zlib_deflate sg bcm2835_gpiomem uio_pdrv_genirq uio
Jan 20 09:43:18 mail kernel: [2762824.011790] CPU: 0 PID: 1318 Comm: btrfs-transacti Not tainted 4.1.7-v7+ #817
Jan 20 09:43:18 mail kernel: [2762824.011797] Hardware name: BCM2709
Jan 20 09:43:18 mail kernel: [2762824.011832] [<80018440>] (unwind_backtrace) from [<80013e0c>] (show_stack+0x20/0x24)
Jan 20 09:43:18 mail kernel: [2762824.011852] [<80013e0c>] (show_stack) from [<80558548>] (dump_stack+0x98/0xe0)
Jan 20 09:43:18 mail kernel: [2762824.011872] [<80558548>] (dump_stack) from [<80026a4c>] (warn_slowpath_common+0x8c/0xc8)
Jan 20 09:43:18 mail kernel: [2762824.011892] [<80026a4c>] (warn_slowpath_common) from [<80026ac8>] (warn_slowpath_fmt+0x40/0x48)
Jan 20 09:43:18 mail kernel: [2762824.011971] [<80026ac8>] (warn_slowpath_fmt) from [<7f051790>] (__btrfs_abort_transaction+0xd8/0x128 [btrfs])
Jan 20 09:43:18 mail kernel: [2762824.012153] [<7f051790>] (__btrfs_abort_transaction [btrfs]) from [<7f082a84>] (btrfs_commit_transaction+0x330/0xd40 [btrfs])
Jan 20 09:43:18 mail kernel: [2762824.012353] [<7f082a84>] (btrfs_commit_transaction [btrfs]) from [<7f07e95c>] (transaction_kthread+0x174/0x1ec [btrfs])
Jan 20 09:43:18 mail kernel: [2762824.012463] [<7f07e95c>] (transaction_kthread [btrfs]) from [<80042498>] (kthread+0xe8/0x104)
Jan 20 09:43:18 mail kernel: [2762824.012481] [<80042498>] (kthread) from [<8000fa58>] (ret_from_fork+0x14/0x3c)
Jan 20 09:43:18 mail kernel: [2762824.012492] ---[ end trace 1c48a450ca505104 ]---
Jan 20 09:43:18 mail kernel: [2762824.012505] BTRFS: error (device sda1) in cleanup_transaction:1692: errno=-5 IO failure
Jan 20 09:43:18 mail kernel: [2762824.022734] BTRFS info (device sda1): delayed_refs has NO entry

