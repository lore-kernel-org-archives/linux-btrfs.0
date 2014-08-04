Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46940 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaHDGaK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 02:30:10 -0400
Received: by mail-ob0-f182.google.com with SMTP id wm4so4183930obc.13
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Aug 2014 23:30:09 -0700 (PDT)
MIME-Version: 1.0
From: rocwhite168 <rocwhite168@163.com>
Date: Mon, 4 Aug 2014 01:29:49 -0500
Message-ID: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
Subject: Unrecoverable errors when the btrfs file system was modified outside
 the running OS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I just had a very frustrating experience with btrfs, which I was only
able to resolve by rolling back to ext4 using the subvol btrfs-convert
created. The same type of situation occurred before when I was using
the ext file system and the result was far less disastrous.

The source of problem came from the fact that I have a Windows and
Ubuntu 14.04 dual-boot setup and within Windows I also use VirtualBox
to run the same Ubuntu with rawdisk. Today I updated Ubuntu to a new
kernel within VirtualBox. At this point, I would usually shutdown
VirtualBox before I let my machine go to hibernation. However, this
time I forgot. And when the machine started up, it went directly into
Ubuntu (because grub was updated and to avoid issues my VirtualBox
setup didn't allow Ubuntu to see my Windows partitions). I did a
grub-udpate, and rebooted back to Windows, where my VirtualBox was
still up and running fine. The tragedy happened when I now shut down
Ubuntu and VirtualBox. The btrfs file system was totally corrupted. I
tried various combinations ro, recovery, nospace_cache, and
clear_cache mount options, and it wouldn't mount. dmesg showed some
"transid verify failed", "open_ctree failed" error messages. btrfs
restore only retrieved three files.. btrfsck --repair and
btrfs-zero-log didn't help either.

To my very surprise, btrfs-convert -r was able to use the subvol it
created to roll back to ext4. But had I not converted from ext4 to
btrfs, this would be an unrecoverable situation. Whether or not I have
backups is a separate issue, being able to recover at least "somewhat"
in this situation seems to be a desired feature for any file system.

Roc
