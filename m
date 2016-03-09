Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:38367 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbcCIVqO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:46:14 -0500
Received: from dslb-092-077-111-077.092.077.pools.vodafone-ip.de ([92.77.111.77] helo=[127.0.0.1])
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.84)
	(envelope-from <hendrik@friedels.name>)
	id 1adlvm-0004OX-Sj
	for linux-btrfs@vger.kernel.org; Wed, 09 Mar 2016 22:46:10 +0100
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Subject: How to move a btrfs volume to a smaller disk
Message-ID: <56E099A1.8040506@friedels.name>
Date: Wed, 9 Mar 2016 22:46:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I intend to move this subvolume to a new device.
btrfs fi show /mnt2/Data_Store/
Label: 'Data_Store'  uuid: 0ccc1e24-090d-42e2-9e61-d0a1b3101f93
         Total devices 1 FS bytes used 47.93GiB
         devid    1 size 102.94GiB used 76.03GiB path /dev/sdb4

(fi usage at the bottom of this message)

The new device (sda4) is 8G smaller unfortunately.
sda       8:0    0 111.8G  0 disk
└─sda4    8:4    0 103.5G  0 part
sdb       8:16   0 119.2G  0 disk
└─sdb4    8:20   0   111G  0 part  /mnt2/Data_Store

Thus, btrfs replace does not work

What would you suggest now to move the FS (it does contain many subvolumes)?

I tried btrfs send /mnt2/Data_Store/read_only_snapshot/ | btrfs receive 
/mnt/sda4/
but this only created an empty subvolume /mnt/sda4/read_only_snapshot/

So, then
btrfs device add /dev/sda4 /mnt/Data_Store
btrfs balance start /mnt/Data_Store
btrfs device remove /dev/sdb4 /mnt/Data_Store
?

Or is there a better option?

Regards,
Hendrik


  btrfs fi usage  /mnt2/Data_Store/
Overall:
     Device size:                 102.94GiB
     Device allocated:             74.03GiB
     Device unallocated:           28.91GiB
     Device missing:                  0.00B
     Used:                         47.96GiB
     Free (estimated):             53.24GiB      (min: 53.24GiB)
     Data ratio:                       1.00
     Metadata ratio:                   1.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:69.00GiB, Used:44.67GiB
    /dev/sdb4      69.00GiB

Metadata,single: Size:5.00GiB, Used:3.29GiB
    /dev/sdb4       5.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
    /dev/sdb4      32.00MiB

Unallocated:
    /dev/sdb4      28.91GiB


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

