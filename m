Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rae.mywh.net ([62.109.39.45]:55369 "EHLO rae.mywh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbcKYVFP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 16:05:15 -0500
Received: from [128.77.16.244] (port=37274 helo=[192.168.1.169])
        by rae.mywh.net with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
        (Exim 4.87)
        (envelope-from <btrfs+list@olstad.com>)
        id 1cAMyA-0002e9-Nu
        for linux-btrfs@vger.kernel.org; Fri, 25 Nov 2016 21:19:42 +0100
From: Kai Stian Olstad <btrfs+list@olstad.com>
Subject: mount raid1 gives open_ctree failed
To: linux-btrfs@vger.kernel.org
Message-ID: <603b293e-8b74-a8ed-893b-c9c041af20ef@olstad.com>
Date: Fri, 25 Nov 2016 21:19:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have problem mounting my 3 disk raid1.
This happened after upgrading from Kubuntu 14.04 to 16.04.

The raid1 started as a 2 disk raid1 and was gowned to 3 disks raid1 a
while back. The physical disk has dm-crypt LUKS on top.

Does anyone have any advise?

Information about the system follow, if you need more information please
let me know.


$ sudo mount /mnt/nydata
------------------------
mount: wrong fs type, bad option, bad superblock on /dev/mapper/cdisk20,
       missing codepage or helper program, or other error

The output in syslog after the failed mount:

/var/log/syslog
---------------
Nov 25 20:25:35 cb kernel: [13486.074249] BTRFS info (device dm-11):
enabling auto defrag
Nov 25 20:25:35 cb kernel: [13486.074257] BTRFS info (device dm-11):
disk space caching is enabled
Nov 25 20:25:35 cb kernel: [13486.139842] attempt to access beyond end
of device
Nov 25 20:25:35 cb kernel: [13486.139847] dm-10: rw=32, want=5263951296,
limit=4294963198
Nov 25 20:25:35 cb kernel: [13486.139868] attempt to access beyond end
of device
Nov 25 20:25:35 cb kernel: [13486.139870] dm-9: rw=32, want=5261815232,
limit=4294963198
Nov 25 20:25:35 cb kernel: [13486.139880] BTRFS: failed to read tree
root on dm-11
Nov 25 20:25:35 cb kernel: [13486.160009] BTRFS: open_ctree failed


$ sudo btrfs filesystem show
----------------------------
Label: none  uuid: 6554e692-6c1c-4a69-8ff8-cb5615fb9200
        Total devices 3 FS bytes used 6.38TiB
        devid    1 size 5.46TiB used 4.38TiB path /dev/mapper/cdisk20
        devid    2 size 5.46TiB used 4.38TiB path /dev/mapper/cdisk21
        devid    3 size 5.46TiB used 4.38TiB path /dev/mapper/cdisk22

$ ls -l /dev/mapper/cdisk2[0-2]
-------------------------------
lrwxrwxrwx 1 root root 8 nov.  25 17:28 /dev/mapper/cdisk20 -> ../dm-10
lrwxrwxrwx 1 root root 7 nov.  25 17:28 /dev/mapper/cdisk21 -> ../dm-9
lrwxrwxrwx 1 root root 8 nov.  25 17:28 /dev/mapper/cdisk22 -> ../dm-11


$ sudo btrfs check /dev/mapper/cdisk20
--------------------------------------
bytenr mismatch, want=11817687138304, have=0
Couldn't read tree root
Couldn't open file system



$ sudo btrfs-find-root /dev/mapper/cdisk20 | head
-------------------------------------------------
Couldn't read tree root
Superblock thinks the generation is 743329
Superblock thinks the level is 1
Well block 11197008461824(gen: 743302 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196999434240(gen: 743301 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196990472192(gen: 743292 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196989538304(gen: 743291 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196988424192(gen: 743290 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196987424768(gen: 743289 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196986736640(gen: 743288 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1
Well block 11196985982976(gen: 743287 level: 1) seems good, but
generation/level doesn't match, want gen: 743329 level: 1



/etc/fstab
----------
/dev/mapper/cdisk20   /mnt/nydata   btrfs
defaults,autodefrag,space_cache               0 0
/dev/mapper/cdisk20   /data/film    btrfs
defaults,autodefrag,space_cache,subvol=film   0 0


-- 
Kai Stian Olstad
