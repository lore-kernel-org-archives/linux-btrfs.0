Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from server.roznica.com.ua ([91.194.72.3]:42794 "EHLO
	server.roznica.com.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaDKSAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 14:00:15 -0400
Received: from daemonw.roznica.com.ua (unknown [80.90.224.110])
	by server.roznica.com.ua (Postfix) with ESMTP id F30B248046F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 21:00:09 +0300 (EEST)
Message-ID: <53482DA9.4090101@roznica.com.ua>
Date: Fri, 11 Apr 2014 21:00:09 +0300
From: Michael <mclaud@roznica.com.ua>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v10 00/16] Online(inband) data deduplication
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

Thanks for your work.

Each test copy 2gb file from sdf (btrfs) to sde (btrfs with dedup 4k 
blocksize).
Before every test i recreate filesystem.
On second write all goods.

Test 1
Nodesize = leafsize = 4k
Write overhead ~ x1.5

Test 2
Nodesize = leafsize = 16k
Write overhead ~ x19



Test 1:

fs created label (null) on /dev/sde
         nodesize 4096 leafsize 4096 sectorsize 4096 size 931.32GiB
Btrfs v3.14-dirty
./btrfs dedup enable /mnt/backupkvm/ ; ./btrfs dedup on -b4k 
/mnt/backupkvm/

[root@hranilka2 ~]# cat /sys/block/sde/stat
   157149     3096  1285992   128900  6472058 12962342 718660664 
1511294062        0  1576195 1527264468
[root@hranilka2 ~]# cat /sys/block/sde/stat
   157149     3096  1285992   128900  6526802 13268740 724690168 
1512117500        0  1587233 1528090320
write sectors: 724690168 - 718660664 = 6029504 sector
write mbyte: 6029504 * 512 / 1024 / 1024 ~ 2944 mb

[root@hranilka2 ~]# cat /sys/block/sdf/stat
   338633      165 346540680  7043771        7        4 1496 35        
0   610795  7043095
[root@hranilka2 ~]# cat /sys/block/sdf/stat
   342737      165 350743176  7127546        7        4 1496 35        
0   618652  7126860
read sectors: 350743176 - 346540680 = 4202496 sector
read mbyte: 4202496 * 512 / 1024 / 1024 ~ 2052 mb



Test 2:

fs created label (null) on /dev/sde
         nodesize 16384 leafsize 16384 sectorsize 4096 size 931.32GiB
Btrfs v3.14-dirty
./btrfs dedup enable /mnt/backupkvm/ ; ./btrfs dedup on -b4k 
/mnt/backupkvm/


[root@hranilka2 ~]# cat /sys/block/sde/stat
   157440     3313  1290392   129277  6526912 13272046 724722864 
1512117920        0  1587500 1528091116
[root@hranilka2 ~]# cat /sys/block/sde/stat
   157440     3313  1290392   129277  6964494 13836479 803994376 
1514935880        0  1730081 1530910351
write sectors: 803994376 - 724722864 = 79271512 sector
write mbyte: 79271512 * 512 / 1024 / 1024 ~ 38706 mb

[root@hranilka2 ~]# cat /sys/block/sdf/stat
   342737      165 350743176  7127546        7        4 1496 35        
0   618652  7126860
[root@hranilka2 ~]# cat /sys/block/sdf/stat
   346841      165 354945672  7266231        7        4 1496 35        
0   629824  7265539
read sectors: 354945672 - 350743176 = 4202496 sector
read mbyte: 4202496 * 512 / 1024 / 1024 ~ 2052 mb

--
Michael Serikov
-- 
