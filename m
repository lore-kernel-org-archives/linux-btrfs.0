Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39151 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751567AbaKKUId convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 15:08:33 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53695 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XoHjr-000AIU-Ix
	for linux-btrfs@vger.kernel.org; Tue, 11 Nov 2014 13:08:31 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: open_ctree failed after ATA errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141111155153.GZ5944@lupin>
Date: Tue, 11 Nov 2014 13:08:30 -0700
Message-Id: <F3B39B1C-07DE-4D6E-97CF-81ACB3B9FD3A@colorremedies.com>
References: <20141111155153.GZ5944@lupin>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 11, 2014, at 8:51 AM, Florian Bruhin <me@the-compiler.org> wrote:

> I have the following setup:
> 
> - Two harddisks
>    - Both individually encrypted using LUKS
>    - Both combined into a btrfs using the btrfs raid1 feature
> 
> - The above duplicated twice:
>    - /dev/mapper/data1 and /dev/mapper/data2 -> /mnt/data
>    - /dev/mapper/secdata1 and /dev/mapper/secdata2 -> /mnt/secdata
> 
> Recently, I saw the following messages in my kernel logs all few days:
> 
>    ata6.00: exception Emask 0x10 SAct 0x40000 SErr 0x400000 action 0x6 frozen
>    ata6.00: irq_stat 0x08000000, interface fatal error
>    ata6: SError: { Handshk }
>    ata6.00: failed command: WRITE FPDMA QUEUED
>    ata6.00: cmd 61/08:90:e8:29:85/01:00:03:00:00/40 tag 18 ncq 135168 out
>             res 40/00:94:e8:29:85/00:00:03:00:00/40 Emask 0x10 (ATA bus error)
>    ata6.00: status: { DRDY }
>    ata6: hard resetting link
>    ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata6.00: configured for UDMA/133
>    ata6: EH complete
>    ata6.00: exception Emask 0x10 SAct 0x800000 SErr 0x400000 action 0x6 frozen
>    ata6.00: irq_stat 0x08000000, interface fatal error
>    ata6: SError: { Handshk }
>    ata6.00: failed command: WRITE FPDMA QUEUED
>    ata6.00: cmd 61/00:b8:f0:2a:85/02:00:03:00:00/40 tag 23 ncq 262144 out
>             res 40/00:bc:f0:2a:85/00:00:03:00:00/40 Emask 0x10 (ATA bus error)
>    ata6.00: status: { DRDY }
>    ata6: hard resetting link
>    ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata6.00: configured for UDMA/133
>    ata6: EH complete
> 
> I thought maybe it was just a temporary problem or related to
> upgrading the kernel recently (3.17.1 -> 3.17.2) and not rebooting
> yet, so I rebooted.
> 
> Since then, I could run cryptsetup luksOpen without problems, but
> mounting the devices hanged for ~15 seconds and then returned without
> error, but didn't mount anything.
> 
> When strace'ing mount, it hanged here:
> 
>    mount("/dev/mapper/data1", "/mnt/data", "btrfs", MS_MGC_VAL, NULL)
> 
> (which then returned 0). I didn't see anything in the kernel logs.
> 
> I then tried the following:
> 
>    # cryptsetup luksClose ... # for all 4 disks
>    # cryptsetup luksOpen ...  # for all 4 disks
>    # btrfs device scan --all-devices
>    # mount /dev/mapper/data1 /mnt/data
>    # mount /dev/mapper/secdata1 /mnt/data
> 
> The same thing happened, and I then saw this in the kernel logs:
> 
>    [Nov11 15:33] BTRFS info (device dm-3): disk space caching is enabled
>    [Nov11 15:34] BTRFS info (device dm-3): disk space caching is enabled
>    [Nov11 15:35] BTRFS info (device dm-3): disk space caching is enabled
>    [Nov11 15:36] BTRFS info (device dm-3): disk space caching is enabled
>    [Nov11 15:37] BTRFS info (device dm-3): disk space caching is enabled
>    [ +16.054127] BTRFS: open_ctree failed
>    [Nov11 15:38] BTRFS info (device dm-3): disk space caching is enabled
>    [Nov11 16:02] BTRFS info (device dm-2): disk space caching is enabled
> 
> How could I mount these volumes again? Is it a good idea to use
> btrfs-zero-log as described in [1]?

First sort out the cause of the hardware problems reported. Persistent errors are going to make things worse. Then you can try -o ro,recovery and see if that works while likely also not altering anything on the drive. If it works, take the opportunity to update backups. Then you can see whether -o recovery works and fixes the problem permanently.


Chris Murphy