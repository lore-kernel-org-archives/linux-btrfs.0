From: "Helmut Hullen" <Hullen@t-online.de>
Subject: read error: how to fix?
Date: 07 Oct 2011 18:51:00 +0200
Message-ID: <BvO7vnJy1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I'm just copying about 1.5 TByte from a 3-disks-btrfs directory (data:  
raid0) to another disk. And there seem to be 2 damaged files, they stop  
the copying process.

Oct  7 18:16:55 Arktur kernel: ata5.00: exception Emask 0x0 SAct 0x0  
SErr 0x0 action 0x0
Oct  7 18:16:55 Arktur kernel: ata5.00: BMDMA2 stat 0x80d2009
Oct  7 18:16:55 Arktur kernel: ata5.00: failed command: READ DMA
Oct  7 18:16:55 Arktur kernel: ata5.00: cmd c8/00:40:57:d0:34/00:00:00:00:00/ee tag 0 dma 32768 in
Oct  7 18:16:55 Arktur kernel:          res 51/40:40:57:d0:34/00:03:0e:00:00/fe Emask 0x9 (media error)
Oct  7 18:16:55 Arktur kernel: ata5.00: status: { DRDY ERR }
Oct  7 18:16:55 Arktur kernel: ata5.00: error: { UNC }
Oct  7 18:16:55 Arktur kernel: ata5.00: configured for UDMA/100
Oct  7 18:16:55 Arktur kernel: ata5: EH complete

(repeating every 3 seconds)

The files contain no valuable data (*.mpeg files, reproducable). But how  
can I tell the disk not to use the damaged sector(s)?

On an ext2/3 system I used "badblocks" - is there some comparable tool  
for btrfs?

Viele Gruesse!
Helmut
