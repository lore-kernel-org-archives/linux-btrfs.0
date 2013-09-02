Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:18908 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3IBQXK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 12:23:10 -0400
Message-ID: <5224BB6A.7040900@giantdisaster.de>
Date: Mon, 02 Sep 2013 18:23:06 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Stuart Pook <slp644161@pook.it>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: uncorrectable errors after btrfs replace
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com> <434c716a-7687-4738-bb24-f4752ada1e3f@email.android.com> <52138852.3080605@giantdisaster.de> <521A80C5.70208@pook.it> <3E91F3EB-AE7F-47FE-AAD3-00B08F761911@colorremedies.com>
In-Reply-To: <3E91F3EB-AE7F-47FE-AAD3-00B08F761911@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 25 Aug 2013 20:07:32 -0600, Chris Murphy wrote:
> On Aug 25, 2013, at 4:10 PM, Stuart Pook <slp644161@pook.it> wrote:
>>
>> I emailed them to Stefan Behrens & Chris Murphy.  Please let me know if you did not get them (presumably because they are too big).
> 
> Observations:
> 
> 1. The problems started before the start of the provided log.
> 
> 2. smartd reports sdb at 100˚C. The spec sheet for WD2002FAEX is 60˚C. It's possible the raw value isn't actually ˚C so you'll need to look at smartctl -a columns VALUE, WORST and THRESH to determine if it is or has hit the threshold. Seems possible the drives are being cooked.
> 
> sdc is ST2000DL004 which google finds this
> http://forums.seagate.com/t5/Desktop-HDD-Desktop-SSHD/BEWARE-the-so-called-Samsung-HD204UI/m-p/166856
> 
> It also looks to be running hot. 
> 
> 3. the first ata error seems to be 8/10 encoding related, could be a connector problem, a port problem, a drive problem, or firmware bug - the Emask 0x10 implicates NCQ according to libata.h:
> AC_ERR_NCQ              = (1 << 10), /* marker for offending NCQ qc */
> 
> 4. Hundreds of these:
> ata10.00: failed command: READ FPDMA QUEUED
> 
> Implies it may be an incompatibility between this drive and the controller, possibly disabling NCQ on the drive will fix the problem (set queue depth to 1)
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/550559
> 
> https://ata.wiki.kernel.org/index.php/Libata_FAQ
> 
> echo 1 > /sys/block/sdX/device/queue_depth
> 
> 
> I can't tell you what /dev/ node applies to ata10:00 because the log is incomplete, so I don't know which drive is giving you a hard time with NCQ. Thing is, if you disable NCQ on just one drive, it'll slow it down compared to the others. I don't know how tolerant btrfs is when devices have different speeds.
> 
> 
> 
> 5. Tens of thousands of checksum errors on both dm-11 and dm-12. 
> 
> 6. Many instances of 
>  btrfs: unable to fixup (regular) error at logical 53281xxxxxx on dev /dev/dm-11
> 
> So kernel messages have been screaming of bus related problems for some time, they were ignored, btrfs did what it could, reported hundreds to thousands of errors in dmesg, but user space tools didn't warn the user operations effectively failed.

Right, I assume that the WD6400AAKS failed in reading the 250,000 blocks due to heat or SATA link issues. And in this case the user space tools should have warned and aborted the operations because there is hope that after cooling down the disk or after fixing the SATA link issues, the read errors disappear.

There is the other use case where such unrecoverable read errors are expected. This is the case when a disk is about to die.

The configuration option is missing whether to abort or continue on unrecoverable read errors. The even better solution is to implement an optional verify at the end or a scrub run, and to only declare the operation as being finished when this additional check succeeds.

