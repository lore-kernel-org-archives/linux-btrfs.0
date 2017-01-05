Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35126 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967817AbdAEEXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 23:23:46 -0500
Received: by mail-yw0-f176.google.com with SMTP id v81so231173671ywb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jan 2017 20:23:46 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 4 Jan 2017 21:14:49 -0700
Message-ID: <CAJCQCtQQoP=53Dwsa4Evep7RZuVUJQTqdKDbWebNn1eYzD_ZJQ@mail.gmail.com>
Subject: btrfs fi du, cannot check space, inappropriate ioctl
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[root@f25h mnt]# btrfs fi du -s home.20170104
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of 'home.20170104': Inappropriate ioctl for device

The command works on this snapshot's parent.

kernel 4.8.15
btrfs-progs 4.8.5

What's interesting is the parent contains nested subvolumes and
snapshots of those subvolumes. Whereas the snapshot of course doesn't
contain those nested subvolumes or snapshots. So it's almost like the
fact there's a "missing" nested snapshot is what's causing the error.
A strace suggests that's the problem...

newfstatat(4, "gits", {st_mode=S_IFDIR|0755, st_size=0, ...}, 0) = 0
stat("home.20170104/chris/gits", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
open("home.20170104/chris/gits", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 5
fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
ioctl(5, BTRFS_IOC_INO_LOOKUP, {treeid=0, objectid=256 /*
BTRFS_FIRST_FREE_OBJECTID */}) = -1 ENOTTY (Inappropriate ioctl for
device)
close(5)                                = 0
getdents(4, /* 0 entries */, 32768)     = 0
close(4)                                = 0
getdents(3, /* 0 entries */, 32768)     = 0
close(3)                                = 0
write(2, "ERROR: ", 7)                  = 7
write(2, "cannot check space of 'home.2017"..., 69) = 69


home.20170104/chris/gits is an empty directory (in the subvolume
that's having the btrfs du command run on). But in the original home,
this is home/chris/gits which is a subvolume that's not empty.

-- 
Chris Murphy
