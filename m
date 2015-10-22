Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from henninger.io ([144.76.155.217]:53560 "EHLO mail.henninger.io"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbbJVUqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 16:46:04 -0400
Received: from [IPv6:2003:66:8a32:5500:221:ccff:fe64:84ab] (p200300668A3255000221CCFFFE6484AB.dip0.t-ipconnect.de [IPv6:2003:66:8a32:5500:221:ccff:fe64:84ab])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.henninger.io (Postfix) with ESMTPSA id 88FB9460D18
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 22:38:57 +0200 (CEST)
From: Johannes Henninger <johannes+btrfs@henninger.io>
Subject: Exclusive quota of snapshot exceeded despite no space used
To: linux-btrfs@vger.kernel.org
Message-ID: <56294960.10406@henninger.io>
Date: Thu, 22 Oct 2015 22:38:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having a weird problem with snapshots and exclusive quotas. After
creating a snapshot of a subvolume and setting an exclusive quota of
50MB for the snapshot, everything seems to work fine. I can write
approximately 50MB before the quota kicks in.

However, if I create a snapshot, set an exclusive quota and just wait
for some time, I suddenly cannot even create an empty file because I'm
getting a "quota exceeded" error. The time until the bug appears seems
to vary. During the waiting time, I'm changing neither the snapshot nor
the original subvolume. "qgroup show -e" reports an exclusive use of
only a few kilobytes for the snapshot, which is nowhere near the limit.

Steps to reproduce (/media/extern is a fresh and empty btrfs partition):

Enable quota and create an empty subvolume:
    root@t420:/media/extern# btrfs quota enable .
    root@t420:/media/extern# btrfs subvolume create sub
    Create subvolume './sub'

Snapshot the subvolume and set a limit:
    root@t420:/media/extern# btrfs subvolume snapshot sub snap
    Create a snapshot of 'sub' in './snap'
    root@t420:/media/extern# cd snap/
    root@t420:/media/extern/snap# btrfs qgroup limit -e 50M .

Sometimes it takes "longer" for the quota to kick in, so I'm touching a
file every 5 minutes here:

    root@t420:/media/extern/snap# for file in {1..100}; do touch $file;
sleep 5m; done
    touch: cannot touch ‘7’: Disk quota exceeded
    ^C
    root@t420:/media/extern/snap# btrfs qgroup show -e .
    qgroupid         rfer         excl     max_excl
    --------         ----         ----     --------
    0/5          16.00KiB     16.00KiB         none
    0/257        16.00KiB     16.00KiB         none
    0/258        16.00KiB     16.00KiB     50.00MiB

Any idea why this happens?

Thanks,
Johannes

System info:
    
    Linux t420 4.3.0-rc5 #1 SMP Tue Oct 13 13:21:02 CEST 2015 x86_64
GNU/Linux
    
    Label: none  uuid: 9551e3ca-1608-469c-9d8c-77b99ce0e8ec
        Total devices 1 FS bytes used 816.00KiB
        devid    1 size 931.51GiB used 2.04GiB path /dev/sdb1

    btrfs-progs v4.1.2

    Data, single: total=8.00MiB, used=256.00KiB
    System, DUP: total=8.00MiB, used=16.00KiB
    System, single: total=4.00MiB, used=0.00B
    Metadata, DUP: total=1.00GiB, used=544.00KiB
    Metadata, single: total=8.00MiB, used=0.00B
    GlobalReserve, single: total=16.00MiB, used=0.00B

    [249174.151820]  sdb: sdb1
    [249184.387377]  sdb: sdb1
    [249184.573096]  sdb: sdb1
    [249184.656274] BTRFS: device fsid
9551e3ca-1608-469c-9d8c-77b99ce0e8ec devid 1 transid 3 /dev/sdb1
    [249186.323915]  sdb: sdb1
    [249186.534505]  sdb: sdb1
    [249186.538420]  sdb: sdb1
    [249196.781978] BTRFS info (device sdb1): disk space caching is enabled
    [249196.781986] BTRFS: has skinny extents
    [249196.781990] BTRFS: flagging fs with big metadata feature
    [249196.818164] BTRFS: creating UUID tree
    [249202.311983] BTRFS info (device sdb1): qgroup scan completed
(inconsistency flag cleared)

