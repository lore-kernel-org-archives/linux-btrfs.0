Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:48817 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaIOPeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:34:07 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.9])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTYI2-0004ii-2m
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 11:34:06 -0400
Message-ID: <541706ED.4010901@intellasoft.net>
Date: Mon, 15 Sep 2014 11:34:05 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs balance enospc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I should have plenty of space for this operation, but it fails....

cartman {~} root# btrfs filesystem df /
Data, RAID1: total=7.59GiB, used=7.00GiB
System, RAID1: total=32.00MiB, used=4.00KiB
Metadata, RAID1: total=1.00GiB, used=438.45MiB
unknown, single: total=148.00MiB, used=0.00

Filesystem                                             Type   Size Used 
Avail Use% Mounted on
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa btrfs   19G 15G  
3.1G  84% /

cartman {~} root# btrfs fi show
Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
        Total devices 2 FS bytes used 7.43GiB
        devid    1 size 9.31GiB used 8.06GiB path 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
        devid    3 size 9.31GiB used 8.06GiB path /dev/sdd6

Label: 'Storage'  uuid: 179749c1-1bfb-4f28-9c69-72126c96cdef
        Total devices 8 FS bytes used 1.83TiB
        devid    1 size 149.05GiB used 149.04GiB path /dev/sde
        devid    2 size 149.05GiB used 149.05GiB path /dev/sdh
        devid    3 size 465.76GiB used 465.76GiB path /dev/sdc
        devid    4 size 465.76GiB used 461.70GiB path /dev/sdf
        devid    5 size 465.76GiB used 461.00GiB path /dev/sda
        devid    6 size 465.76GiB used 461.00GiB path /dev/sdb
        devid    7 size 920.34GiB used 843.00GiB path /dev/sdg7
        devid    9 size 1.81TiB used 755.00GiB path /dev/sdd7

Btrfs v3.16
cartman {~} root# btrfs balance start /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

Sep 13 16:35:42 localhost kernel: BTRFS info (device sdg6): found 33544 
extents
Sep 13 16:35:51 localhost kernel: BTRFS info (device sdg6): found 33541 
extents
Sep 13 16:35:52 localhost kernel: BTRFS info (device sdg6): relocating 
block group 80153214976 flags 18
Sep 13 16:35:53 localhost kernel: BTRFS info (device sdg6): found 1 extents
Sep 13 16:35:54 localhost kernel: BTRFS info (device sdg6): relocating 
block group 79680700416 flags 17
Sep 13 16:36:03 localhost kernel: BTRFS info (device sdg6): found 32545 
extents
Sep 13 16:36:09 localhost kernel: BTRFS info (device sdg6): found 32545 
extents
Sep 13 16:36:10 localhost kernel: BTRFS info (device sdg6): relocating 
block group 79412264960 flags 20
Sep 13 16:36:12 localhost kernel: BTRFS info (device sdg6): found 1114 
extents
Sep 13 16:36:13 localhost kernel: BTRFS info (device sdg6): relocating 
block group 79143829504 flags 20
Sep 13 16:36:37 localhost kernel: BTRFS info (device sdg6): found 59076 
extents
Sep 13 16:36:38 localhost kernel: BTRFS info (device sdg6): relocating 
block group 78875394048 flags 20
Sep 13 16:37:01 localhost kernel: BTRFS info (device sdg6): found 59268 
extents
Sep 13 16:37:02 localhost kernel: BTRFS info (device sdg6): 6 enospc 
errors during balance

