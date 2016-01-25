Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33206 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbcAYUsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 15:48:25 -0500
Received: by mail-io0-f174.google.com with SMTP id q21so165195388iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 12:48:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
References: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
Date: Mon, 25 Jan 2016 13:48:24 -0700
Message-ID: <CAJCQCtR3O3x2aFz-+LV8Jt5WAFY-i_V2r8B2ea2uDE+r54wtjg@mail.gmail.com>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrecovable
From: Chris Murphy <lists@colorremedies.com>
To: WillIam Thorne <will.thorne@me.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 7:58 AM, WillIam Thorne <will.thorne@me.com> wrote:
> Hi
>
> I have a WD 3TB external HD attached over USB to an arm based micro PC (rasp pi). I was experimenting with btrfs for storing email archives but recently encountered some problems which resulted in the filesystem becoming apparently unrecoverable. I’m not an expert and it was quicker to switch back to ext4 and restored from backup so no support needed. Here what appears to be the relevant part of the syslog including the stack trace in case it is useful:
>
> Best
> W
>
> pi@mail /var/log $ btrfs --version
> Btrfs Btrfs v0.19
>
> pi@mail /var/log $ uname -a
> Linux mail 4.1.7-v7+ #817 SMP PREEMPT Sat Sep 19 15:32:00 BST 2015 armv7l GNU/Linux
>
> Jan 20 09:42:08 mail kernel: [2762753.507576] usb 1-1.5: reset high-speed USB device number 4 using dwc_otg
> Jan 20 09:43:18 mail kernel: [2762823.972777] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.972806] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.972819] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.972837] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2c 20 00 00 f0 00
> Jan 20 09:43:18 mail kernel: [2762823.972851] blk_update_request: I/O error, dev sda, sector 16198688

These are not Btrfs errors, they're libata errors, it's having a
problem writing to the drive. That this is a USB connected drive it
could be related to insufficient power  or some incompatibility with
the bridge chipset in the enclosure and the USB controller in the
computer. I actually had a similar problem until I put a hub in
between the drive and computer (a NUC).








> Jan 20 09:43:18 mail kernel: [2762823.972867] BTRFS: bdev /dev/sda1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.976998] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.977015] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.977028] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.977042] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2d 10 00 00 f0 00
> Jan 20 09:43:18 mail kernel: [2762823.977052] blk_update_request: I/O error, dev sda, sector 16198928
> Jan 20 09:43:18 mail kernel: [2762823.977066] BTRFS: bdev /dev/sda1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.978226] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.978273] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.978286] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.978301] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f7 2e 00 00 00 20 00
> Jan 20 09:43:18 mail kernel: [2762823.978318] blk_update_request: I/O error, dev sda, sector 16199168
> Jan 20 09:43:18 mail kernel: [2762823.978339] BTRFS: bdev /dev/sda1 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.983241] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.983264] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.983277] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.983292] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c3 f8 00 00 f0 00
> Jan 20 09:43:18 mail kernel: [2762823.983304] blk_update_request: I/O error, dev sda, sector 16172024
> Jan 20 09:43:18 mail kernel: [2762823.983319] BTRFS: bdev /dev/sda1 errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.987799] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.987818] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.987830] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.987844] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c4 e8 00 00 f0 00
> Jan 20 09:43:18 mail kernel: [2762823.987855] blk_update_request: I/O error, dev sda, sector 16172264
> Jan 20 09:43:18 mail kernel: [2762823.987869] BTRFS: bdev /dev/sda1 errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.989136] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.989155] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.989168] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.989182] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 f6 c5 d8 00 00 20 00
> Jan 20 09:43:18 mail kernel: [2762823.989193] blk_update_request: I/O error, dev sda, sector 16172504
> Jan 20 09:43:18 mail kernel: [2762823.989207] BTRFS: bdev /dev/sda1 errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.993965] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.993988] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.994000] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.994015] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 17 53 68 00 00 c0 00
> Jan 20 09:43:18 mail kernel: [2762823.994028] blk_update_request: I/O error, dev sda, sector 1528680
> Jan 20 09:43:18 mail kernel: [2762823.994043] BTRFS: bdev /dev/sda1 errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.994058] BTRFS: bdev /dev/sda1 errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.994070] BTRFS: bdev /dev/sda1 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.997419] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> Jan 20 09:43:18 mail kernel: [2762823.997435] sd 0:0:0:0: [sda] Sense Key : 0x2 [current]
> Jan 20 09:43:18 mail kernel: [2762823.997448] sd 0:0:0:0: [sda] ASC=0x3a ASCQ=0x0
> Jan 20 09:43:18 mail kernel: [2762823.997461] sd 0:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 37 53 68 00 00 c0 00
> Jan 20 09:43:18 mail kernel: [2762823.997471] blk_update_request: I/O error, dev sda, sector 3625832
> Jan 20 09:43:18 mail kernel: [2762823.997484] BTRFS: bdev /dev/sda1 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> Jan 20 09:43:18 mail kernel: [2762823.997601] BTRFS: error (device sda1) in btrfs_commit_transaction:2068: errno=-5 IO failure (Error while writing out transaction)
> Jan 20 09:43:18 mail kernel: [2762824.011517] BTRFS info (device sda1): forced readonly
> Jan 20 09:43:18 mail kernel: [2762824.011537] BTRFS warning (device sda1): Skipping commit of aborted transaction.

Well this is nifty, I like that it's eventually giving up when it can't write!

-- 
Chris Murphy
