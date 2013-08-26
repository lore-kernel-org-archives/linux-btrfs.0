Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:61411 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755052Ab3HZCHi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 22:07:38 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: uncorrectable errors after btrfs replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <521A80C5.70208@pook.it>
Date: Sun, 25 Aug 2013 20:07:32 -0600
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <3E91F3EB-AE7F-47FE-AAD3-00B08F761911@colorremedies.com>
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com> <434c716a-7687-4738-bb24-f4752ada1e3f@email.android.com> <52138852.3080605@giantdisaster.de> <521A80C5.70208@pook.it>
To: Stuart Pook <slp644161@pook.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2013, at 4:10 PM, Stuart Pook <slp644161@pook.it> wrote:
> 
> I emailed them to Stefan Behrens & Chris Murphy.  Please let me know if you did not get them (presumably because they are too big).

Observations:

1. The problems started before the start of the provided log.

2. smartd reports sdb at 100˚C. The spec sheet for WD2002FAEX is 60˚C. It's possible the raw value isn't actually ˚C so you'll need to look at smartctl -a columns VALUE, WORST and THRESH to determine if it is or has hit the threshold. Seems possible the drives are being cooked.

sdc is ST2000DL004 which google finds this
http://forums.seagate.com/t5/Desktop-HDD-Desktop-SSHD/BEWARE-the-so-called-Samsung-HD204UI/m-p/166856

It also looks to be running hot. 

3. the first ata error seems to be 8/10 encoding related, could be a connector problem, a port problem, a drive problem, or firmware bug - the Emask 0x10 implicates NCQ according to libata.h:
AC_ERR_NCQ              = (1 << 10), /* marker for offending NCQ qc */

4. Hundreds of these:
ata10.00: failed command: READ FPDMA QUEUED

Implies it may be an incompatibility between this drive and the controller, possibly disabling NCQ on the drive will fix the problem (set queue depth to 1)
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/550559

https://ata.wiki.kernel.org/index.php/Libata_FAQ

echo 1 > /sys/block/sdX/device/queue_depth


I can't tell you what /dev/ node applies to ata10:00 because the log is incomplete, so I don't know which drive is giving you a hard time with NCQ. Thing is, if you disable NCQ on just one drive, it'll slow it down compared to the others. I don't know how tolerant btrfs is when devices have different speeds.



5. Tens of thousands of checksum errors on both dm-11 and dm-12. 

6. Many instances of 
 btrfs: unable to fixup (regular) error at logical 53281xxxxxx on dev /dev/dm-11

So kernel messages have been screaming of bus related problems for some time, they were ignored, btrfs did what it could, reported hundreds to thousands of errors in dmesg, but user space tools didn't warn the user operations effectively failed.


Chris Murphy