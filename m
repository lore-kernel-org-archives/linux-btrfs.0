Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.sigma-it.ru ([212.65.87.1]:41033 "EHLO mail.sigma-it.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbcLFMkM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 07:40:12 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.sigma-it.ru (Postfix) with ESMTP id 35140B2F26
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 15:40:08 +0300 (MSK)
Received: from mail.sigma-it.ru ([127.0.0.1])
        by localhost (mail.sigma-it.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U5JaJOiKuiPj for <linux-btrfs@vger.kernel.org>;
        Tue,  6 Dec 2016 15:40:08 +0300 (MSK)
Received: from sigmakrv.sigma-it.local (unknown [10.196.4.222])
        (Authenticated sender: romank)
        by mail.sigma-it.ru (Postfix) with ESMTP id 222EBB2F22
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 15:40:08 +0300 (MSK)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?0JrRgNCw0LLRhtC+0LIg0KDQvtC80LDQvSDQktC70LDQtNC40LzQuNGA0L4=?=
         =?UTF-8?B?0LLQuNGH?= <r.kravtsov@sigma-it.ru>
Subject: Free space missing
Message-ID: <e0d82d3d-1379-854f-97c2-8a1f1dc7be33@sigma-it.ru>
Date: Tue, 6 Dec 2016 15:40:08 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

Why 'BTRFS used size' and 'du -s' are different?


[root@OraCI2 ~]# btrfs --version
btrfs-progs v4.8.3
[root@OraCI2 ~]# btrfs fi show /dev/nvme0n1
Label: 'OLD_PES'  uuid: bd542f37-6baa-4af8-b87a-20d4e335e4b3
     Total devices 1 FS bytes used 2.53TiB
     devid    1 size 2.91TiB used 2.90TiB path /dev/nvme0n1
[root@OraCI2 ~]# btrfs fi usage /mnt/OLD/
Overall:
     Device size:           2.91TiB
     Device allocated:           2.90TiB
     Device unallocated:           9.97GiB
     Device missing:             0.00B
     Used:               2.53TiB
     Free (estimated):         385.31GiB    (min: 385.31GiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         512.00MiB    (used: 0.00B)

Data,single: Size:2.89TiB, Used:2.53TiB <-------------------------
    /dev/nvme0n1       2.89TiB

Metadata,single: Size:6.01GiB, Used:3.52GiB
    /dev/nvme0n1       6.01GiB

System,single: Size:32.00MiB, Used:432.00KiB
    /dev/nvme0n1      32.00MiB

Unallocated:
    /dev/nvme0n1       9.97GiB

[root@OraCI2 ~]# df -h | grep nvme0n1
/dev/nvme0n1                              3,0T         2,6T 
386G           88% /mnt/OLD
[root@OraCI2 ~]# du -sh /mnt/OLD/
2,0T    /mnt/OLD/    <-------------------------
[root@OraCI2 ~]#
/dev/nvme0n1 on /mnt/OLD type btrfs 
(rw,relatime,ssd,discard,space_cache,subvolid=5,subvol=/)

WBR,
Roman Kravtsov

