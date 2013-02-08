Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:49151 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945909Ab3BHKzv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 05:55:51 -0500
Received: by mail-yh0-f52.google.com with SMTP id q46so403104yhf.25
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 02:55:50 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 8 Feb 2013 11:55:50 +0100
Message-ID: <CA+PhV5YWiMJmMhph7kSBS1MPbmxcjGAZRO43AJF7MMGck8WkMw@mail.gmail.com>
Subject: Very slow BTRFS
From: Jaroslav Tvrdy <jtvrdy@jaroslav-tvrdy.info>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi i am very very slow BTRFS, when i am start use this FS, work OK,
but now is unusable
it is on SWraid and LVM, not problem in RAID

Copy 12MB (~30 6 subdirs jpegs)
# time cp -r directory ../../src/delme2
real	2m13.965s
user	0m0.008s
sys	0m0.191s
(91 kB/sec)

Fedora 18
kernel: 3.7.2-204.fc18.x86_64

modinfo:
filename:       /lib/modules/3.7.2-204.fc18.x86_64/kernel/fs/btrfs/btrfs.ko
license:        GPL
alias:          devname:btrfs-control
alias:          char-major-10-234
depends:        libcrc32c,zlib_deflate
intree:         Y
vermagic:       3.7.2-204.fc18.x86_64 SMP mod_unload

# btrfs fi df /ontap
Data: total=2.23TB, used=2.22TB
System, DUP: total=32.00MB, used=248.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=5.00GB, used=4.82GB

/dev/mapper/vol-data on /ontap type btrfs
(rw,noatime,nobarrier,space_cache)   ... i am don't use compression,
snapshots, subvolumes etc.

When i am upgrade distro kernel from 3.6 to 3.7 BTRFS run these process:
[ 7152.787631] btrfs: found 129 extents
[ 7154.094930] btrfs: relocating block group 20971520 flags 34
[ 7178.283544] btrfs: found 62 extents
[ 7179.230863] btrfs: relocating block group 4194304 flags 4
Yes i am waiting after process done, i am run test.

# btrfs filesystem show
Label: 'ontap'  uuid: bdfb22ce-0475-4e51-9726-62e76636763a
	Total devices 1 FS bytes used 2.23TB
	devid    1 size 2.73TB used 2.24TB path /dev/dm-0
Btrfs Btrfs v0.19


Jarda
