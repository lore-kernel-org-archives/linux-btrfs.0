Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsmx009.vodafonemail.xion.oxcs.net ([153.92.174.87]:57281 "EHLO
        vsmx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933070AbdEKUgV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 16:36:21 -0400
Received: from vsmx001.vodafonemail.xion.oxcs.net (unknown [192.168.75.191])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id 19524C01DB
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 20:36:20 +0000 (UTC)
Received: from [192.168.0.1] (p5b0a1541.dip0.t-ipconnect.de [91.10.21.65])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 9FB0F3004FC
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 20:36:17 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
References: <0e7ef6b4-7a81-fc66-942e-411f238d631e@arcor.de>
Subject: Creating btrfs RAID on LUKS devs makes devices disappear
From: Ochi <ochi@arcor.de>
Message-ID: <2a289986-4740-72ae-7e7a-8264ed55b435@arcor.de>
Date: Thu, 11 May 2017 22:36:16 +0200
MIME-Version: 1.0
In-Reply-To: <0e7ef6b4-7a81-fc66-942e-411f238d631e@arcor.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I should have added some more technical info. Here you go:

Arch Linux with systemd 233
Kernel linux-lts 4.9.27
btrfs-progs 4.10.2

Example session:

root@nas> ls /dev/dm-*
/dev/dm-0  /dev/dm-1  /dev/dm-2  /dev/dm-3  /dev/dm-4
root@nas> ls -l /dev/mapper
total 0
lrwxrwxrwx 1 root root       7 May 11 22:30 backup -> ../dm-1
crw------- 1 root root 10, 236 May 11 22:30 control
lrwxrwxrwx 1 root root       7 May 11 22:30 root -> ../dm-0
lrwxrwxrwx 1 root root       7 May 11 22:30 storage0 -> ../dm-2
lrwxrwxrwx 1 root root       7 May 11 22:30 storage1 -> ../dm-4
lrwxrwxrwx 1 root root       7 May 11 22:30 storage2 -> ../dm-3
root@nas> mkfs.btrfs -f -d raid1 -m raid1 /dev/dm-2 /dev/dm-3 /dev/dm-4
btrfs-progs v4.10.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               a32b3106-678f-448f-ade9-c48cd41a7dae
Node size:          16384
Sector size:        4096
Filesystem size:    10.92TiB
Block group profiles:
   Data:             RAID1             1.00GiB
   Metadata:         RAID1             1.00GiB
   System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  3
Devices:
    ID        SIZE  PATH
     1     3.64TiB  /dev/dm-2
     2     3.64TiB  /dev/dm-3
     3     3.64TiB  /dev/dm-4

root@nas> ls /dev/dm-*
/dev/dm-0  /dev/dm-1  /dev/dm-2  /dev/dm-4

Note that dm-3 is gone.
