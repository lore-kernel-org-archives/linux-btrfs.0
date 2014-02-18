Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37707 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751180AbaBRWCy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 17:02:54 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Read i/o errs and disk replacement
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <116064537.O3CH7laqNI@fuckup>
Date: Tue, 18 Feb 2014 15:02:51 -0700
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6B9DC823-92CF-4ECC-979F-C512072DF883@colorremedies.com>
References: <8051054.BLVnDBVVi7@fuckup> <4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com> <116064537.O3CH7laqNI@fuckup>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 18, 2014, at 2:33 PM, Wolfgang Mader <Wolfgang_Mader@brain-frog.de> wrote:
> 
> 
> Feb 18 13:14:09 deck kernel: ata2.00: failed command: READ DMA
> Feb 18 13:14:09 deck kernel: ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:00/e0 
> tag 0 dma 4096 in
>                                      res 51/04:08:60:f2:30/00:00:00:00:00/e0 
> Emask 0x1 (device error)
> Feb 18 13:14:09 deck kernel: ata2.00: status: { DRDY ERR }
> Feb 18 13:14:09 deck kernel: ata2.00: error: { ABRT }
> Feb 18 13:14:09 deck kernel: ata2.15: hard resetting link
> Feb 18 13:14:14 deck kernel: ata2.15: link is slow to respond, please be 
> patient (ready=0)
> Feb 18 13:14:19 deck kernel: ata2.15: SRST failed (errno=-16)
> Feb 18 13:14:19 deck kernel: ata2.15: hard resetting link
> Feb 18 13:14:24 deck kernel: ata2.15: link is slow to respond, please be 
> patient (ready=0)
> Feb 18 13:14:29 deck kernel: ata2.15: SATA link up 3.0 Gbps (SStatus 123 
> SControl F300)
> Feb 18 13:14:29 deck kernel: 
> Feb 18 13:14:30 deck kernel: ata2.01: hard resetting link
> Feb 18 13:14:31 deck kernel: ata2.02: hard resetting link
> Feb 18 13:14:31 deck kernel: ata2.03: hard resetting link
> Feb 18 13:14:32 deck kernel: ata2.04: hard resetting link
> Feb 18 13:14:32 deck kernel: ata2.05: hard resetting link
> Feb 18 13:14:33 deck kernel: ata2.06: hard resetting link
> Feb 18 13:14:34 deck kernel: ata2.07: hard resetting link
> Feb 18 13:14:34 deck kernel: ata2.00: configured for UDMA/133
> Feb 18 13:14:34 deck kernel: ata2.01: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.02: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.03: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.04: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.05: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.06: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2.07: configured for UDMA/133
> Feb 18 13:14:35 deck kernel: ata2: EH complete

Two things. The full dmesg includes useful information separate from the error messages, including the model drive to ata device mapping, and why there's a failed read to ATA2.00 yet there's a reset in sequence for ata2.01, 2.02, 2.03 and so on. So the entire dmesg would be useful.

In any case the actual problem might not be discoverable due to the hard resetting. I'm not finding any useful translation, in 5 minute search, for SRST. But it makes me suspicious of a configuration problem, like maybe an unnecessary jumper setting on a drive or with the enclosure itself. So I'd check for that. Also, what model drives are being used? If they are consumer drives, they almost certainly have long error recoveries over 30 minutes. And if the drive is trying to honor the read request for more than 30 seconds, the default SCSI block layer will time out and produce messages like what we see here. So you probably need to change the SCSI block layer timeout. To set the command timer to something else use:

echo <value> /sys/block/<device>/device/timeout

Where value is e.g. 121 since many consumer drives time out at 120 seconds this means the kernel will wait 121 seconds before starting its error handling (which includes resetting the drive and then the bus).



> -------end-------
> 
> This output it repeated several times and than end in this read error
> 
> [Tue Feb 18 13:15:48 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, 
> corrupt 0, gen 0
> [Tue Feb 18 13:15:48 2014] ata2: EH complete
> [Tue Feb 18 13:15:48 2014] btrfs read error corrected: ino 1 off 29184540672 
> (dev /dev/sdb sector 3207776)

Well that reads like Btrfs knows what sector had a read problem, without corruption being the cause, and corrected it. So the question then is whether /dev/sdb is the same as ata2.00. If ata2.00 isn't a drive but is the drive enclosure then you've got a different (or additional) problem.



Chris Murphy