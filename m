Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35068 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcDFQqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 12:46:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id a140so14890559wma.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 09:46:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Apr 2016 12:46:10 -0400
Message-ID: <CAFKQ2BsD1024hqwL4LHsaRmckYvxVhSi5gGnOHeC_Cm_-ru37g@mail.gmail.com>
Subject: 'btrfs filesystem df /mnt/point/of/btrfs/pool' can report misleadingly
From: Ank Ular <ankular.anime@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the mount point for a btrfs pool resides on an existing
independent btrfs pool and the first btrfs pool is not mounted,
running 'btrfs fi df /unmounted/pool' will show the btrfs df
information of the underlying mounted btrfs pool. This is most likely
undesirable.

The btrfs wiki has the following:

What information to provide when asking a support question

When reporting errors or asking for support always supply the output
of the following commands:
  uname -a
  btrfs --version
  btrfs fi show
  btrfs fi df /home # Replace /home with the mount point of your
btrfs-filesystem   <===
  dmesg > dmesg.log

Real world example:

>From /etc/fstab - /  {root level}
LABEL="PhoenixRootSSD" / btrfs  autodefrag,compress=lzo,space_cache,noatime 0 0

>From /etc/fstab - /PublicA
LABEL="FSgyroA" /PublicA btrfs
autodefrag,compress=lzo,space_cache,noatime,noauto 0 0

# btrfs fi df /PublicA
Data, single: total=107.00GiB, used=84.26GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=3.01GiB, used=1.27GiB
GlobalReserve, single: total=448.00MiB, used=0.00B

# btrfs fi df /
Data, single: total=107.00GiB, used=84.26GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=3.01GiB, used=1.27GiB
GlobalReserve, single: total=448.00MiB, used=0.00B

# btrfs fi show
Label: 'PhoenixRootSSD'  uuid: ed1790a7-87e6-466c-a68c-e375303fd99f
        Total devices 1 FS bytes used 85.53GiB
        devid    1 size 200.04GiB used 110.01GiB path /dev/sda5

Label: 'PhoenixRoot'  uuid: 7ba4f981-c2ff-4a70-96a6-4c4b25f96e96
        Total devices 1 FS bytes used 2.00TiB
        devid    1 size 2.71TiB used 2.38TiB path /dev/sdg5

Label: none  uuid: a7e2e4f6-e324-4cf4-8b76-33bb7dedf5d1
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 2.73TiB used 2.02GiB path /dev/sdab1

checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
checksum verify failed on 120890386268160 found 50ECAB17 wanted 2D8EEBCA
checksum verify failed on 120890386268160 found D7319043 wanted 33D22DF5
bytenr mismatch, want=120890386268160, have=65536
Label: 'FSgyroA'  uuid: 4dae41b0-a459-4c20-a09d-0aca9563b9ad
        Total devices 20 FS bytes used 53.15TiB
        devid    1 size 3.64TiB used 3.46TiB path /dev/sdb
        devid    2 size 3.64TiB used 3.46TiB path /dev/sdd
        devid    3 size 3.64TiB used 3.46TiB path /dev/sdc
        devid    4 size 2.73TiB used 2.73TiB path /dev/sdh
        devid    5 size 4.55TiB used 4.50TiB path /dev/sde
        devid    6 size 4.55TiB used 4.50TiB path /dev/sdf
        devid    7 size 4.55TiB used 4.49TiB path /dev/sdi
        devid    8 size 4.55TiB used 4.50TiB path /dev/sdj
        devid    9 size 5.46TiB used 5.19TiB path /dev/sdm
        devid   10 size 5.46TiB used 5.19TiB path /dev/sdn
        devid   11 size 5.46TiB used 5.19TiB path /dev/sds
        devid   12 size 5.46TiB used 5.19TiB path /dev/sdu
        devid   14 size 2.73TiB used 2.73TiB path /dev/sdag
        devid   15 size 2.73TiB used 2.73TiB path /dev/sdz
        devid   16 size 2.73TiB used 2.73TiB path /dev/sdy
        devid   17 size 2.73TiB used 2.73TiB path /dev/sdac
        devid   18 size 2.73TiB used 2.73TiB path /dev/sdaf
        devid   19 size 2.73TiB used 2.73TiB path /dev/sdx
        devid   20 size 2.73TiB used 2.73TiB path /dev/sdad
        *** Some devices missing
