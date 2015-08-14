Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:36404 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbbHNPQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:16:33 -0400
Received: by ykfw73 with SMTP id w73so17863703ykf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 08:16:33 -0700 (PDT)
MIME-Version: 1.0
From: Eduardo Bach <hellbach@gmail.com>
Date: Fri, 14 Aug 2015 12:16:13 -0300
Message-ID: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
Subject: The performance is not as expected when used several disks on raid0.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is my first email to this list, so please excuse any gaffe.

I am in the evaluation early stages of a new storage, an SGI MIS,
currently with two HBAs LSI and 32 disks.
The hba controllers are LSI 9207-8i and the disks are Seagate 6TB,
model ST6000NM0004-1FT17Z.

To evaluate the performance I am using IOzone over a raid0 using all
the 32 disks, with the parameters: iozone -i0 -i1 -t5 -s 20G  -P0.

With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
result reaches 6gb/s, which is the expected value when compared with
parallel dd made on discs.
When used btrfs with only half of the disc the result is about 3GB/s.

More information:

# uname -a
Linux spstrg13 4.2.0-999-generic #201508132200 SMP Fri Aug 14 02:01:52
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.0

# btrfs fi show
Label: none  uuid: be2a5671-87d1-4b89-ac4a-04efabb5912f
        Total devices 32 FS bytes used 3.66MiB
        devid    1 size 5.46TiB used 1.07GiB path /dev/sdc
        devid    2 size 5.46TiB used 1.06GiB path /dev/sdd
        devid    3 size 5.46TiB used 1.06GiB path /dev/sde
        devid    4 size 5.46TiB used 1.06GiB path /dev/sdf
        devid    5 size 5.46TiB used 1.06GiB path /dev/sdg
        devid    6 size 5.46TiB used 1.06GiB path /dev/sdh
        devid    7 size 5.46TiB used 1.06GiB path /dev/sdi
        devid    8 size 5.46TiB used 1.06GiB path /dev/sdj
        devid    9 size 5.46TiB used 1.06GiB path /dev/sdk
        devid   10 size 5.46TiB used 1.06GiB path /dev/sdl
        devid   11 size 5.46TiB used 1.06GiB path /dev/sdm
        devid   12 size 5.46TiB used 1.06GiB path /dev/sdn
        devid   13 size 5.46TiB used 1.06GiB path /dev/sdo
        devid   14 size 5.46TiB used 1.06GiB path /dev/sdp
        devid   15 size 5.46TiB used 1.06GiB path /dev/sdq
        devid   16 size 5.46TiB used 1.06GiB path /dev/sdr
        devid   17 size 5.46TiB used 1.06GiB path /dev/sds
        devid   18 size 5.46TiB used 1.06GiB path /dev/sdt
        devid   19 size 5.46TiB used 1.06GiB path /dev/sdu
        devid   20 size 5.46TiB used 1.06GiB path /dev/sdv
        devid   21 size 5.46TiB used 1.06GiB path /dev/sdw
        devid   22 size 5.46TiB used 1.06GiB path /dev/sdx
        devid   23 size 5.46TiB used 1.06GiB path /dev/sdy
        devid   24 size 5.46TiB used 1.06GiB path /dev/sdz
        devid   25 size 5.46TiB used 1.06GiB path /dev/sdaa
        devid   26 size 5.46TiB used 1.06GiB path /dev/sdab
        devid   27 size 5.46TiB used 1.06GiB path /dev/sdac
        devid   28 size 5.46TiB used 1.06GiB path /dev/sdad
        devid   29 size 5.46TiB used 1.06GiB path /dev/sdae
        devid   30 size 5.46TiB used 1.06GiB path /dev/sdaf
        devid   31 size 5.46TiB used 1.06GiB path /dev/sdag
        devid   32 size 5.46TiB used 1.06GiB path /dev/sdah

btrfs-progs v4.0

# btrfs fi df /root/backup/root/storageTestes/mbtr
Data, RAID0: total=30.00GiB, used=3.50MiB
System, RAID0: total=32.00MiB, used=16.00KiB
Metadata, RAID0: total=4.00GiB, used=128.00KiB
Metadata, single: total=8.00MiB, used=16.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

The dmesg is attached.

The result are about the same using kernel 3.16 and btrfs tools 3.12.
I am far from be able to isolate the problem, so please ask me any
information you think is relevant.
Thanks in advance.

Eduardo.
