Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:43712 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaECJ7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 05:59:04 -0400
Received: from 233.33.70.115.static.exetel.com.au ([115.70.33.233] helo=office.waterlogic.com.au)
	by smtp.po.exetel.com.au with esmtp (Exim 4.80)
	(envelope-from <paul@pauljones.id.au>)
	id 1WgWKm-0005lV-Eg
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 19:34:18 +1000
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Help with csum failed errors
Date: Sat, 3 May 2014 09:34:14 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64592FCAF9ED@Server.waterlogic.com.au>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I'm getting some strange errors and I need some help diagnosing where the problem is. 
You can see from below that the error is "csum failed ino 5641".
This is a new SSD that is running in raid1. When I first noticed the error (on both drives) I copied all the data off the drives, reformatted
and copied the data back. I was running 3.13.11 and upgraded to 3.14.2 just incase there was a bugfix.
I still had the error on one drive so I converted the array back to single, ran dd if=/dev/zero of=/dev/sdd1
and readded sdd1 and rebalanced. No error was reported 
I'm also running the root and swap partitions on the same physical drives and they are ok (root is btrfs also), which makes me suspect
that the SSD is ok. I did a scrub on both drives and that found no errors. What do I try next?

[44778.232540] BTRFS info (device sdd1): relocating block group 333996621824 flags 1
[44780.458408] BTRFS info (device sdd1): found 339 extents
[44783.494674] BTRFS info (device sdd1): found 339 extents
[44783.546293] BTRFS info (device sdd1): relocating block group 331849138176 flags 1
[44786.143536] BTRFS info (device sdd1): found 164 extents
[44789.256777] BTRFS info (device sdd1): found 164 extents
[49217.915725] kvm: zapping shadow pages for mmio generation wraparound
[141968.885166] BTRFS error (device sdd1): csum failed ino 5641 off 54112157696 csum 2741395493 expected csum 3151521372
[141968.885216] BTRFS error (device sdd1): csum failed ino 5641 off 54412632064 csum 3489516372 expected csum 2741395493
[141968.887816] BTRFS error (device sdd1): csum failed ino 5641 off 27601571840 csum 1878206089 expected csum 3203096954
[141969.887794] BTRFS error (device sdd1): csum failed ino 5641 off 54112157696 csum 2741395493 expected csum 3151521372
[141970.895408] BTRFS error (device sdd1): csum failed ino 5641 off 7849897984 csum 2833474655 expected csum 2585631118
[141970.895437] BTRFS error (device sdd1): csum failed ino 5641 off 8398065664 csum 2001723841 expected csum 2913537154
[141970.895450] BTRFS error (device sdd1): csum failed ino 5641 off 10395713536 csum 2001723841 expected csum 2833474655
[141971.895529] BTRFS error (device sdd1): csum failed ino 5641 off 10395713536 csum 2913537154 expected csum 2833474655
[141971.895541] BTRFS error (device sdd1): csum failed ino 5641 off 7849897984 csum 2913537154 expected csum 2585631118
[141972.894867] BTRFS error (device sdd1): csum failed ino 5641 off 10395713536 csum 369396853 expected csum 2833474655
[145579.088097] BTRFS error (device sdd1): csum failed ino 5641 off 54317748224 csum 1538824619 expected csum 2260594561
[145579.088110] BTRFS error (device sdd1): csum failed ino 5641 off 54412632064 csum 257502146 expected csum 3543777931
[145580.087459] BTRFS error (device sdd1): csum failed ino 5641 off 54317748224 csum 3543777931 expected csum 2260594561
[171255.071570] 3w-9xxx: scsi0: AEN: INFO (0x04:0x0029): Verify started:unit=2.
[181556.516699] BTRFS error (device sdd1): csum failed ino 5641 off 54317748224 csum 1227121981 expected csum 4177569466
[181557.517271] BTRFS error (device sdd1): csum failed ino 5641 off 53179822080 csum 4130109553 expected csum 1722742324
[188752.222042] BTRFS error (device sdd1): csum failed ino 5641 off 54317748224 csum 50100434 expected csum 4177569466
[200568.511268] 3w-9xxx: scsi0: AEN: INFO (0x04:0x002B): Verify completed:unit=2.
[202095.611465] BTRFS error (device sdd1): csum failed ino 5641 off 12205871104 csum 910010336 expected csum 2948706421
[203143.317917] BTRFS error (device sdd1): csum failed ino 5641 off 55994003456 csum 648604663 expected csum 2485194978

vm-server ~ # btrfs scrub stat /dev/sdd1
scrub status for 9baf63f7-a9d6-456c-8fdd-1a8fdb21958f
        scrub started at Sat May  3 17:59:47 2014 and finished after 659 seconds
        total bytes scrubbed: 273.64GiB with 0 errors

vm-server ~ # btrfs scrub stat /
scrub status for 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        scrub started at Sat May  3 19:22:58 2014 and finished after 49 seconds
        total bytes scrubbed: 18.49GiB with 0 errors

vm-server ~ # uname -a
Linux vm-server 3.14.2-gentoo #1 SMP PREEMPT Thu May 1 00:02:32 EST 2014 x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linux

vm-server ~ #   btrfs --version
Btrfs v3.14.1

vm-server ~ #   btrfs fi show
Label: 'Root'  uuid: 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        Total devices 2 FS bytes used 18.49GiB
        devid    3 size 40.00GiB used 35.03GiB path /dev/sde3
        devid    4 size 40.00GiB used 35.03GiB path /dev/sdd3

Label: 'storage'  uuid: df3d4a9c-ed6c-4867-8991-a018276f6f3c
        Total devices 2 FS bytes used 1.13TiB
        devid    5 size 2.69TiB used 1.16TiB path /dev/sdb1
        devid    6 size 2.69TiB used 1.16TiB path /dev/sda1

Label: 'backup'  uuid: b24d05da-6b0a-4ab0-8f2f-21ea5416e9e9
        Total devices 3 FS bytes used 899.20GiB
        devid    3 size 901.92GiB used 616.03GiB path /dev/sdf1
        devid    4 size 892.25GiB used 606.00GiB path /dev/sdg1
        devid    5 size 892.25GiB used 606.03GiB path /dev/sdh1

Label: 'Fast'  uuid: 9baf63f7-a9d6-456c-8fdd-1a8fdb21958f
        Total devices 2 FS bytes used 273.65GiB
        devid    2 size 407.12GiB used 304.03GiB path /dev/sde1
        devid    3 size 407.12GiB used 304.03GiB path /dev/sdd1

Btrfs v3.14.1

vm-server ~ #   btrfs fi df /
Data, RAID1: total=33.00GiB, used=17.60GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=906.33MiB

vm-server ~ #   btrfs fi df /media/fast/
Data, RAID1: total=302.00GiB, used=273.23GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=2.00GiB, used=421.42MiB


Thanks,
Paul.
