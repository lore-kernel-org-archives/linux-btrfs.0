Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:32977 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbdEQI1z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 04:27:55 -0400
Received: by mail-qk0-f179.google.com with SMTP id y201so4000531qka.0
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 01:27:54 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?=C5=81ukasz_Wr=C3=B3blewski?= <lw@nri.pl>
Date: Wed, 17 May 2017 10:27:53 +0200
Message-ID: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
Subject: RAID 6 corrupted
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

About two years ago I created RAID 6 consisting of 5 disks with BTRFS.
One of the disks has crashed.
I started to exchange it for another, but I did something wrong.
Or at the time, RAID56 support was experimental in BTRFS.
There was a situation where I could not mount the partition again.

I decided to put the disks aside and wait for the better tools.
A newer version of BTRFS in the hope that I can retrieve the data.

Currently the situation looks like this:
 ~ # uname -a
Linux localhost 4.10.12-coreos #1 SMP Tue Apr 25 22:08:35 UTC 2017
x86_64 AMD FX(tm)-6100 Six-Core Processor AuthenticAMD GNU/Linux
 ~ # btrfs --version
btrfs-progs v4.4.1
 ~ # btrfs fi show
warning devid 1 not found already
warning devid 4 not found already
bytenr mismatch, want=2373780258816, have=0
warning, device 7 is missing
warning, device 1 is missing
bytenr mismatch, want=2093993689088, have=0
ERROR: cannot read chunk root
Label: none  uuid: 50127310-d15c-49ca-8cdd-8798ea0fda2e
Total devices 5 FS bytes used 5.44TiB
devid    2 size 1.82TiB used 1.82TiB path /dev/sde
devid    3 size 1.82TiB used 1.82TiB path /dev/sdc
devid    5 size 1.82TiB used 1.82TiB path /dev/sdb
*** Some devices missing

Label: 'DDR'  uuid: 4a9f6a0f-e41f-48a5-a566-507349d47b30
Total devices 7 FS bytes used 477.15GiB
devid    4 size 1.82TiB used 7.00GiB path /dev/sdd
*** Some devices missing

 ~ # mount /dev/sdb /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
 ~ # dmesg | tail
[ 2612.350751] BTRFS info (device sde): disk space caching is enabled
[ 2612.378507] BTRFS error (device sde): failed to read chunk tree: -5
[ 2612.393729] BTRFS error (device sde): open_ctree failed
 ~ # mount -o usebackuproot /dev/sdb /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
 ~ # dmesg | tail
[ 2675.427445] BTRFS info (device sde): trying to use backup root at mount time
[ 2675.434528] BTRFS info (device sde): disk space caching is enabled
[ 2675.442031] BTRFS error (device sde): failed to read chunk tree: -5
[ 2675.457321] BTRFS error (device sde): open_ctree failed
 ~ #


"fi show" shows two systems.
It should really be one, but devid 4 should belong to
uuid: 50127310-d15c-49ca-8cdd-8798ea0fda2e


I tried
./btrfs restore /dev/sdb /mnt/restore

...
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
Trying another mirror
bytenr mismatch, want=2373682249728, have=0
bytenr mismatch, want=2373682233344, have=0
bytenr mismatch, want=2373682249728, have=0
Error searching -5
Error searching /mnt/....

But little data has been recovered.



Can I retrieve my data?
How can I do this?
