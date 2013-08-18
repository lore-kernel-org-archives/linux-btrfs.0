Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48879 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754970Ab3HRVnk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Aug 2013 17:43:40 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:51864 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VBAl9-000CqL-NP
	for linux-btrfs@vger.kernel.org; Sun, 18 Aug 2013 15:43:39 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: uncorrectable errors after btrfs replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52111C9D.3090704@pook.it>
Date: Sun, 18 Aug 2013 15:43:36 -0600
Message-Id: <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com>
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 18, 2013, at 1:12 PM, Stuart Pook <slp644161@pook.it> wrote:

>    6  btrfs filesystem resize 580g .

You first shrank a 2TB btrfs file system on dmcrypt device to 590GB. But then you didn't resize the dm device or the partition?

> 9  time btrfs  balance start -musage=1 -dusage=1 . && time  btrfs filesystem resize 580g .
>  10  time  btrfs filesystem resize 590g .


You followed the resize of the fs, but not the underlying devices, with a balance, then resized it two more times? This is weird, but also makes the sequence difficult to follow.

>   13  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
>   14  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups

Why is this command repeated? What's with the numbering system that skips numbers?

> 
> 
> [...]
> Aug 18 12:28:03 kooka kernel: [54125.020262] ata10: hard resetting link
> Aug 18 12:28:03 kooka kernel: [54125.512032] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 18 12:28:03 kooka kernel: [54125.523759] ata10.00: configured for UDMA/133
> Aug 18 12:28:03 kooka kernel: [54125.536380] ata10: EH complete
> Aug 18 12:28:04 kooka kernel: [54125.770176] ata10.00: exception Emask 0x10 SAct 0x7fffffff SErr 0x780100 action 0x6
> Aug 18 12:28:04 kooka kernel: [54125.770181] ata10.00: irq_stat 0x08000000
> Aug 18 12:28:04 kooka kernel: [54125.770184] ata10: SError: { UnrecovData 10B8B Dispar BadCRC Handshk }
> [...]
> Aug 18 12:28:17 kooka kernel: [54138.957095] ata10.00: status: { DRDY }
> Aug 18 12:28:17 kooka kernel: [54138.957100] ata10: hard resetting link
> Aug 18 12:28:17 kooka kernel: [54139.448029] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> Aug 18 12:28:17 kooka kernel: [54139.449972] ata10.00: configured for UDMA/133
> Aug 18 12:28:17 kooka kernel: [54139.464065] ata10: EH complete

Bad connection so libata is dropping the link from 3 Gbps to 1.5Gbps.
> 

> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       12080

This confirms that both ends of the cable are sensing communication problems between drive and controller. The cable needs to be replaced, likely it's the connector not the cable itself.


> I guess that /disks/backup is mostly dead and that I should just reformat it.  What do you think?

Well I think I'd try to simplify this drastically and see if you've got a reproducing bug. The steps you've got I find mostly incoherent, so I can't try to do what you did to see if it's reproducible.

> Next time I'll watch /var/log/syslog but I would have preferred that "btrfs replace" stop when getting errors.

The errors should be self correcting, but the mere fact they're happening means that some errors could be occurring but aren't detected. If the data is corrupting in-transit, but the drive or controller didn't report a problem, then btrfs has no way of knowing it was written incorrectly. There's only so much software can do to overcome blatant hardware problems.

But, it seems unlikely such a high percent of errors would go undetected to result in so many uncorrectable errors, so there may be user error here along with a bug.


Chris Murphy