Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:55410 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbdIQPC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 11:02:56 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 6B98AB3A6FB
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 15:02:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 15:02:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Sep 2017 00:02:46 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: how to run balance successfully (No space left on device)?
Message-ID: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to run balance on a 4.13.2 kernel without much luck:

# time btrfs balance start -v /var/lib/lxd -dusage=5 -musage=5
Dumping filters: flags 0x7, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=5
   METADATA (flags 0x2): balancing, usage=5
   SYSTEM (flags 0x2): balancing, usage=5
Done, had to relocate 1 out of 353 chunks

real    0m2.356s
user    0m0.005s
sys     0m0.175s


# time btrfs balance start -v /var/lib/lxd -dusage=0 -musage=0
Dumping filters: flags 0x7, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=0
   METADATA (flags 0x2): balancing, usage=0
   SYSTEM (flags 0x2): balancing, usage=0
Done, had to relocate 0 out of 353 chunks

real    0m0.076s
user    0m0.004s
sys     0m0.008s


# time btrfs balance start -v /var/lib/lxd
Dumping filters: flags 0x7, state 0x0, force is off
   DATA (flags 0x0): balancing
   METADATA (flags 0x0): balancing
   SYSTEM (flags 0x0): balancing
WARNING:

         Full balance without filters requested. This operation is very
         intense and takes potentially very long. It is recommended to
         use the balance filters to narrow down the balanced data.
         Use 'btrfs balance start --full-balance' option to skip this
         warning. The operation will start in 10 seconds.
         Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
ERROR: error during balancing '/var/lib/lxd': No space left on device
There may be more info in syslog - try dmesg | tail

real    284m58.541s
user    0m0.000s
sys     47m39.037s




# df -h /var/lib/lxd
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       424G  318G  105G  76% /var/lib/lxd


# btrfs fi df /var/lib/lxd
Data, RAID1: total=318.00GiB, used=313.82GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=5.00GiB, used=3.17GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi show /var/lib/lxd
Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
         Total devices 2 FS bytes used 316.98GiB
         devid    1 size 423.13GiB used 323.03GiB path /dev/sda3
         devid    2 size 423.13GiB used 323.03GiB path /dev/sdb3


# btrfs fi usage /var/lib/lxd
Overall:
     Device size:                 846.25GiB
     Device allocated:            646.06GiB
     Device unallocated:          200.19GiB
     Device missing:                  0.00B
     Used:                        633.97GiB
     Free (estimated):            104.28GiB      (min: 104.28GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:318.00GiB, Used:313.82GiB
    /dev/sda3     318.00GiB
    /dev/sdb3     318.00GiB

Metadata,RAID1: Size:5.00GiB, Used:3.17GiB
    /dev/sda3       5.00GiB
    /dev/sdb3       5.00GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
    /dev/sda3      32.00MiB
    /dev/sdb3      32.00MiB

Unallocated:
    /dev/sda3     100.10GiB
    /dev/sdb3     100.10GiB


Mount flags in /etc/fstab are:

LABEL=btrfs /var/lib/lxd btrfs 
defaults,noatime,space_cache=v2,device=/dev/sda3,device=/dev/sdb3,discard 
0 0



Last pieces logged in dmesg:

[46867.225334] BTRFS info (device sda3): relocating block group 
2996254998528 flags data|raid1
[46874.563631] BTRFS info (device sda3): found 9250 extents
[46894.827895] BTRFS info (device sda3): found 9250 extents
[46898.463053] BTRFS info (device sda3): found 201 extents
[46898.562564] BTRFS info (device sda3): relocating block group 
2995181256704 flags data|raid1
[46903.555976] BTRFS info (device sda3): found 7299 extents
[46914.188044] BTRFS info (device sda3): found 7299 extents
[46914.303476] BTRFS info (device sda3): relocating block group 
2947936616448 flags metadata|raid1
[46939.570810] BTRFS info (device sda3): found 42022 extents
[46945.053488] BTRFS info (device sda3): 2 enospc errors during balance



Tomasz Chmielewski
https://lxadm.com
