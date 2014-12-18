Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:46338 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaLRO77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:59:59 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so1153063lab.28
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 06:59:58 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Dec 2014 22:59:57 +0800
Message-ID: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
Subject: btrfs is using 25% more disk than it should
From: Daniele Testa <daniele.testa@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I am hoping you guys can shed some light on my issue. I know that it's
a common question that people see differences in the "disk used" when
running different calculations, but I still think that my issue is
weird.

root@s4 / # mount
/dev/md3 on /opt/drives/ssd type btrfs
(rw,noatime,compress=zlib,discard,nospace_cache)

root@s4 / # btrfs filesystem df /opt/drives/ssd
Data: total=407.97GB, used=404.08GB
System, DUP: total=8.00MB, used=52.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.25GB, used=672.21MB
Metadata: total=8.00MB, used=0.00

root@s4 /opt/drives/ssd # ls -alhs
total 302G
4.0K drwxr-xr-x 1 root         root           42 Dec 18 14:34 .
4.0K drwxr-xr-x 4 libvirt-qemu libvirt-qemu 4.0K Dec 18 14:31 ..
302G -rw-r--r-- 1 libvirt-qemu libvirt-qemu 315G Dec 18 14:49 disk_208.img
   0 drwxr-xr-x 1 libvirt-qemu libvirt-qemu    0 Dec 18 10:08 snapshots

root@s4 /opt/drives/ssd # du -h
0       ./snapshots
302G    .

As seen above, I have a 410GB SSD mounted at "/opt/drives/ssd". On
that partition, I have one single starse file, taking 302GB of space
(max 315GB). The snapshots directory is completely empty.

However, for some weird reason, btrfs seems to think it takes 404GB.
The big file is a disk that I use in a virtual server and when I write
stuff inside that virtual server, the disk-usage of the btrfs
partition on the host keeps increasing even if the sparse-file is
constant at 302GB. I even have 100GB of "free" disk-space inside that
virtual disk-file. Writing 1GB inside the virtual disk-file seems to
increase the usage about 4-5GB on the "outside".

Does anyone have a clue on what is going on? How can the difference
and behaviour be like this when I just have one single file? Is it
also normal to have 672MB of metadata for a single file?

Regards,
Daniele
