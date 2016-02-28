Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dragon.async.com.br ([208.70.149.241]:56449 "EHLO
	dragon.async.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbcB1UXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 15:23:22 -0500
Received: from anthem.async.com.br (189-19-234-109.dsl.telesp.net.br [189.19.234.109])
	by dragon.async.com.br (Postfix) with ESMTPS id 37F814540F8
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 14:15:37 -0600 (CST)
Received: from anthem.async.com.br (kiko@localhost [127.0.0.1])
	by anthem.async.com.br (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id u1SKFWIm029480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 17:15:33 -0300
Received: (from kiko@localhost)
	by anthem.async.com.br (8.14.4/8.14.4/Submit) id u1SKFWAe029479
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 17:15:32 -0300
Date: Sun, 28 Feb 2016 17:15:32 -0300
From: Christian Robottom Reis <kiko@async.com.br>
To: linux-btrfs@vger.kernel.org
Subject: Replacing RAID-1 devices with larger disks
Message-ID: <20160228201532.GA26692@anthem.async.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

    I'm running a btrfs RAID-1 on two 128GB SSDs that were getting kind
of full. I found two 256GB SSDs that I plan to use to replace the 128TB
versions.

I've managed to do the actual swap using a series of btrfs replace
commands with no special arguments, and the system is now live and
booting from the 256GB drives. However, I haven't actually noticed any
difference in btrfs fi show output, and usage looks weird. Has anyone
seen this before or have a clue as to who?

The relevant partition sizes are now (sdb is identical):

    /dev/sda1   *        2048    83888127    41943040   83  Linux
    /dev/sda3        92276736   427821055   167772160   83  Linux

Here's the show output:

    Label: 'root'  uuid: 670d1132-00dc-4511-a2f6-d28ce08b4d3a
        Total devices 2 FS bytes used 9.33GiB
        devid    1 size 13.97GiB used 11.78GiB path /dev/sda1
        devid    2 size 13.97GiB used 11.78GiB path /dev/sdb1

    Label: 'var'  uuid: 815b3280-e90f-483a-b244-1d2dfe9b6e67
        Total devices 2 FS bytes used 56.14GiB
        devid    1 size 80.00GiB used 80.00GiB path /dev/sda3
        devid    2 size 80.00GiB used 80.00GiB path /dev/sdb3

Those sizes have not changed over the resize; i.e. the original sda1/sdb1 pair
was 14GB and the sda3/sdb3 pair was 80GB, and after the replace, they haven't
changed.

And usage for / is now weird:

    Overall:
        Device size:          27.94GiB
        Device allocated:         21.56GiB
        Device unallocated:        6.38GiB
        Device missing:          0.00B
        Used:             18.66GiB
        Free (estimated):          3.99GiB  (min: 3.99GiB)
        Data ratio:               2.00
        Metadata ratio:           2.00
        Global reserve:      208.00MiB  (used: 0.00B)

    Data,RAID1: Size:9.00GiB, Used:8.20GiB
       /dev/sda1       9.00GiB
       /dev/sdb1       9.00GiB

    Metadata,RAID1: Size:1.75GiB, Used:1.13GiB
       /dev/sda1       1.75GiB
       /dev/sdb1       1.75GiB

    System,RAID1: Size:32.00MiB, Used:16.00KiB
       /dev/sda1      32.00MiB
       /dev/sdb1      32.00MiB

Usage for /var also looks wrong, but in a different way:

    Overall:
        Device size:         160.00GiB
        Device allocated:        160.00GiB
        Device unallocated:        2.00MiB
        Device missing:          0.00B
        Used:            112.28GiB
        Free (estimated):         21.20GiB  (min: 21.20GiB)
        Data ratio:               2.00
        Metadata ratio:           2.00
        Global reserve:      512.00MiB  (used: 0.00B)

    Data,RAID1: Size:74.97GiB, Used:53.77GiB
       /dev/sda3      74.97GiB
       /dev/sdb3      74.97GiB

    Metadata,RAID1: Size:5.00GiB, Used:2.37GiB
       /dev/sda3       5.00GiB
       /dev/sdb3       5.00GiB

    System,RAID1: Size:32.00MiB, Used:16.00KiB
       /dev/sda3      32.00MiB
       /dev/sdb3      32.00MiB

    Unallocated:
       /dev/sda3       1.00MiB
       /dev/sdb3       1.00MiB


Version information:

    async@riff:~$ uname -a
    Linux riff 4.2.0-30-generic #36~14.04.1-Ubuntu SMP Fri Feb 26 18:49:23
    UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

    async@riff:~$ btrfs --version
    btrfs-progs v4.0

Thanks,
-- 
Christian Robottom Reis | [+55 16] 3376 0125   | http://async.com.br/~kiko

