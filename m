Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:24593 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750885Ab3BMIKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 03:10:19 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com>
Date: Wed, 13 Feb 2013 01:10:11 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 12, 2013, at 11:18 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
> 
> 
>> smartctl -l scterc /dev/sdX
> 
> "Warning: device does not support SCT Error Recovery Control command"
> 
> Doesn't seem that way to me; partly because of the SMART data, and partly because of the errors that were logged as the drive failed:
> 
> Feb 12 16:36:49 nerv kernel: [36769.546522] ata6.00: Ata error. fis:0x21
> Feb 12 16:36:49 nerv kernel: [36769.550454] ata6: SError: { Handshk }
> Feb 12 16:36:51 nerv kernel: [36769.554129] ata6.00: failed command: WRITE FPDMA QUEUED
> Feb 12 16:36:51 nerv kernel: [36769.559375] ata6.00: cmd 61/00:00:00:ec:2e/04:00:cd:00:00/40 tag 0 ncq 524288 out
> Feb 12 16:36:51 nerv kernel: [36769.559375]          res 41/84:d0:00:98:2e/84:00:cd:00:00/40 Emask 0x10 (ATA bus error)
> Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
> Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }
> 
> That's not typical for actual media problems, in my experience. :)

Quite typical, because these drives don't support SCTERC which almost certainly means their error timeouts are well above that of the linux SCSI layer which is 30 seconds. Their timeouts are likely around 2 minutes. So in fact they never report back a URE because the command timer times out and resets the drive.
https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/task_controlling-scsi-command-timer-onlining-devices.html

For your use case, I'd reject these drives and get WDC Red, or even reportedly the Hitachi Deskstars still have a settable SCTERC. And set it for something like 70 deciseconds. Then if if a drive ECC hasn't recovered in 7 seconds, it will give up, and report a read error with the problem LBA. Either btrfs (or md) can recover the data from the other drive, and cause the read error to be fixed on the other drive.

However, in your case, with both the kernel message ICRC ABRT, and the following SMART entry, this is your cable problem. The ICRC and UCMA_CRC errors are the same problem reported by the actors at each end of the cable.

/dev/hdi
Serial Number:    WD-WMC1T1679668
199 UDMA_CRC_Error_Count    0x0032   200   192   000    Old_age   Always       -       91


So the question is whether the cable problem has actually been fixed, and if you're still getting ICRC errors from the kernel. As this is hdi, I'm wondering how many drives are connected, and if this could be power induced rather than just cable induced. Once that's solved, you should do a scrub, rather than a rebalance.

Chris Murphy