Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcmd15176.aruba.it ([62.149.156.176]:51181 "EHLO
        smtpcmd10101.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750772AbdHaKuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 06:50:21 -0400
To: linux-btrfs@vger.kernel.org
From: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Subject: mount time for big filesystems
Message-ID: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
Date: Thu, 31 Aug 2017 12:43:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
this 37T filesystem took some times to mount. It has 47 
subvolumes/snapshots and is mounted with 
noatime,compress=zlib,space_cache. Is it normal, due to its size?

# time mount /data/R6HW

real	1m32.383s
user	0m0.000s
sys	0m1.348s

# time umount /data/R6HW

real	0m2.562s
user	0m0.000s
sys	0m0.466s


# df -h
/dev/sdo                          37T   20T     18T  53% /data/R6HW

# btrfs fi df /data/R6HW/
Data, single: total=19.12TiB, used=19.12TiB
System, DUP: total=8.00MiB, used=2.05MiB
Metadata, DUP: total=37.50GiB, used=36.52GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs device usage /data/R6HW/
/dev/sdo, ID: 1
    Device size:            36.38TiB
    Device slack:              0.00B
    Data,single:            19.12TiB
    Metadata,DUP:           75.00GiB
    System,DUP:             16.00MiB
    Unallocated:            17.18TiB

Regards,

-- 
Marco Crociani
