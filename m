Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:47654 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbcGWLP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 07:15:56 -0400
Received: from p4fce2fbc.dip0.t-ipconnect.de ([79.206.47.188] helo=[127.0.0.1])
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.84)
	(envelope-from <hendrik@friedels.name>)
	id 1bQuuO-0003T7-2X
	for linux-btrfs@vger.kernel.org; Sat, 23 Jul 2016 13:15:52 +0200
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Subject: Chances to recover with bad partition table?
Message-ID: <14e0b114-5c5b-77f6-2c10-cad5eb799f28@friedels.name>
Date: Sat, 23 Jul 2016 13:15:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

this morning I had to face an unusual prompt on my machine.

I found that the partition table of /dev/sda had vanished.

I restored it with testdisk. It found one partition, but I am quite sure 
there was a /boot partition in front of that which was not found.

Now, running btrfsck fails:

root@homeserver:~# fdisk -l /dev/sda

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util 
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders, total 234441648 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *     1026048   234440703   116707328   83  Linux
root@homeserver:~# btrfsck /dev/sda1
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=20987904, have=0
Couldn't read chunk root
Couldn't open file system


Is there a way to let btrfs search for the start of the partiton?

I do have a backup; thus it is not fatal. But some data on the disk is 
more recent than my back up (of course)

Regards,

Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

