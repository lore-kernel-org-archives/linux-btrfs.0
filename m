From: Vladi Gergov <vgergov@gmail.com>
Subject: btrfs raid1 degraded does not mount or fsck
Date: Fri, 29 Oct 2010 13:53:42 -0700
Message-ID: <20101029205340.GA10326@gypsyops.denof.sin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

kernel: scratch git repo from today 10.29.10 @ 14:30 PST
Btrfs v0.19-35-g1b444cd-dirty

>>> gypsyops @ /mnt > sudo btrfs filesystem show
Label: 'das4'  uuid: d0e5137f-e5e7-49da-91f6-a9c4e4e72c6f
    Total devices 3 FS bytes used 1.38TB
    devid    3 size 1.82TB used 0.00 path /dev/sdb
    devid    2 size 1.82TB used 1.38TB path /dev/sdc
    *** Some devices missing

Btrfs v0.19-35-g1b444cd-dirty

>>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
Password: 
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

[  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
[  684.595150] btrfs: allowing degraded mounts
[  684.595594] btrfs: failed to read chunk root on sdb
[  684.604110] btrfs: open_ctree failed

>>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.

any help please?

-- 

,-| Vladi
`-| Gergov

!DSPAM:4ccb39a9191821603519226!


