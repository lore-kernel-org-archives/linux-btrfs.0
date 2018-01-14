Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:40405 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751766AbeANQgy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 11:36:54 -0500
Received: by mail-qk0-f180.google.com with SMTP id d18so14293285qke.7
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jan 2018 08:36:54 -0800 (PST)
MIME-Version: 1.0
From: evan d <forumscollective@gmail.com>
Date: Sun, 14 Jan 2018 16:36:53 +0000
Message-ID: <CAG__1a5by0WZ+-LiJTAY9Y3qrpJY-drDt9BuGgCZgqaUuG+mAQ@mail.gmail.com>
Subject: Partionless Btrfs drives now return PTTYPE="PMBR"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I removed two partitionless Btrfs formatted drives from an Arch Linux
based PC and installed them in another Linux based PC also running
Arch.  The drives are independent of one another, each containing its
own Btrfs filesystem.  Both machines are running recent kernels and
the original host would be running whatever kernel was current in Arch
on 1 Jan 2018.

lsblk shows the two drives as partitionless as I'd expect, but
attempting to mount them returns an error saying they're not
recognised and btrfs filesystem show /dev/sdX also returns that the
devices do not contain a Brtfs partition.  1 Jan 2018 was the last
time I accessed these drives, which were mounted via the first
machine's fstab.

blkid returns PTTYPE="PMBR" for both.

For the current machine:
uname -a returns:
Linux ryzen 4.14.13-1-ARCH #1 SMP PREEMPT Wed Jan 10 11:14:50 UTC 2018
x86_64 GNU/Linux

btrfs --version returns:
btrfs-progs v4.14


Any ideas what could have gone wrong here?  I'm  hoping that
reinserting them in the original machine may allow me to access the
underlying data again, but that machine is in another country at
present.

Any help much appreciated.

Thanks
Evan
