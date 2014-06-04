Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:50212 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaFDWPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 18:15:32 -0400
Received: by mail-qg0-f42.google.com with SMTP id q107so271071qgd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 15:15:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Jun 2014 00:15:31 +0200
Message-ID: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
Subject: Very slow filesystem
From: Igor M <igork20@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Why btrfs becames EXTREMELY slow after some time (months) of usage ?
This is now happened second time, first time I though it was hard
drive fault, but now drive seems ok.
Filesystem is mounted with compress-force=lzo and is used for MySQL
databases, files are mostly big 2G-8G.
Copying from this file system is unbelievable slow. It goes form 500
KB/s to maybe 5MB/s maybe faster some files.
hdparm -t or dd show 130MB/s+. There are no errors on drive.No errors in logs.

Can I somehow get position of file on disk, so I can try with raw read
with dd or something to make sure it's not drive fault ?
As I said I tried dd and speeds are normal but maybe there is problem
with only some sectors.

Below are btrfs version and info:

# uname -a
Linux voyager 3.14.2 #1 SMP Tue May 6 09:25:40 CEST 2014 x86_64
Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz GenuineIntel GNU/Linux
Currently but when filesystem was created it was some 3.x I don't remember.

# btrfs --version
Btrfs v0.20-rc1-358-g194aa4a (now I'm upgraded to Btrfs v3.14.2)

# btrfs fi show
Label: none  uuid: b367812a-b91a-4fb2-a839-a3a153312eba
        Total devices 1 FS bytes used 2.36TiB
        devid    1 size 2.73TiB used 2.38TiB path /dev/sde

Label: none  uuid: 09898e7a-b0b4-4a26-a956-a833514c17f6
        Total devices 1 FS bytes used 1.05GiB
        devid    1 size 3.64TiB used 5.04GiB path /dev/sdb

Btrfs v3.14.2

# btrfs fi df /mnt/old
Data, single: total=2.36TiB, used=2.35TiB
System, DUP: total=8.00MiB, used=264.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=8.50GiB, used=7.13GiB
Metadata, single: total=8.00MiB, used=0.00
