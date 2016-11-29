Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from astarte.centershock.net ([5.45.98.111]:46554 "EHLO
        astarte.centershock.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755606AbcK2R3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 12:29:21 -0500
Received: from [172.18.51.229] (pool-123-46-zam9997.ext.kfa-juelich.de [134.94.46.123])
        by astarte.centershock.net (Postfix) with ESMTPSA id 0D9401099F3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 18:20:58 +0100 (CET)
From: Florian Lindner <mailinglists@xgm.de>
Subject: Convert from RAID 5 to 10
To: linux-btrfs@vger.kernel.org
Message-ID: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
Date: Tue, 29 Nov 2016 18:20:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have 4 harddisks with 3TB capacity each. They are all used in a btrfs RAID 5. It has come to my attention, that there
seem to be major flaws in btrfs' raid 5 implementation. Because of that, I want to convert the the raid 5 to a raid 10
and I have several questions.

* Is that possible as an online conversion?

* Since my effective capacity will shrink during conversions, does btrfs check if there is enough free capacity to
convert? As you see below, right now it's probably too full, but I'm going to delete some stuff.

* I understand the command to convert is

btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt

Correct?

* What disks are allowed to fail? My understanding of a raid 10 is like that

disks = {a, b, c, d}

raid0( raid1(a, b), raid1(c, d) )

This way (a XOR b) AND (c XOR d) are allowed to fail without the raid to fail (either a or b and c or d are allowed to fail)

How is that with a btrfs raid 10?

* Any other advice? ;-)

Thanks a lot,

Florian


Some information of my filesystem:

# btrfs filesystem show /
Label: 'data'  uuid: 57e5b9e9-01ae-4f9e-8a3d-9f42204d7005
        Total devices 4 FS bytes used 7.57TiB
        devid    1 size 2.72TiB used 2.72TiB path /dev/sda4
        devid    2 size 2.72TiB used 2.72TiB path /dev/sdb4
        devid    3 size 2.72TiB used 2.72TiB path /dev/sdc4
        devid    4 size 2.72TiB used 2.72TiB path /dev/sdd4

# btrfs filesystem df /
Data, RAID5: total=8.14TiB, used=7.56TiB
System, RAID5: total=96.00MiB, used=592.00KiB
Metadata, RAID5: total=12.84GiB, used=11.06GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# df -h
Filesystem      Size  Used Avail Use% Mounted on

/dev/sda4        11T  7.6T  597G  93% /
