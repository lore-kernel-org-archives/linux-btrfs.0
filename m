Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33892 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdCUHGL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Mar 2017 03:06:11 -0400
Received: by mail-wr0-f181.google.com with SMTP id l37so106057729wrc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Mar 2017 00:05:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJUuSvEgKYASA5BJnTUnZye8hytbOdQrQmcwg9DbV3xrEMHw-w@mail.gmail.com>
References: <CAJUuSvHU=O3NwKU_td+mxg003p_-UAVNR8uwqyJvMbSC5djpVg@mail.gmail.com>
 <CAOcd+r0_=CcvjnxV7GgbBEp6mRdp+YLgO+ucMZtLZLx0oEAC-A@mail.gmail.com> <CAJUuSvEgKYASA5BJnTUnZye8hytbOdQrQmcwg9DbV3xrEMHw-w@mail.gmail.com>
From: Ilan Schwarts <ilan84@gmail.com>
Date: Tue, 21 Mar 2017 09:05:15 +0200
Message-ID: <CAJUuSvFM2ssSS5udEGXCfyP7V6HnVh-JM1zC+ZBj1K265pJTSg@mail.gmail.com>
Subject: Fwd: include linux kernel headers for btrfs filesystem
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I read my question again, it was not perfectly clear, I am trying to
compile my own driver and not the btrfs module.

>From what I understand, it is considered "bad practice" in my driver
to make a call: btrfsInode = BTRFS_I(inode);
since it uses the internal btrfs API (in an outside driver such as mine..)

I guess another solution would be to download in my machine
kernel-source package and include /usr/src/linux/fs/btrfs/ in the
makefile.. then use #include <btrfs/ctree.h>
# Make arguments
PWD := $(shell pwd)
INCLUDE := -I/usr/include/asm/mach-default/
INCLUDE += -I/usr/src/linux/fs/
KDIR    := /lib/modules/$(KERNEL_HEADERS)/build

the problem I deal here is make compilation termination:

make -C /lib/modules/4.1.21.x86_64.1/build
-I/usr/include/asm/mach-default/ -I/usr/src/linux/fs/
SUBDIRS=/home/ilan/unix/v6.3/Filer/Linux modules
make[2]: Entering directory `/data/kernel/linux-4.1.21-x86_64'
  CC [M]  /home/ilan/unix/v6.3/Filer/Linux/XXXX_hooks.o
/home/ilan/unix/v6.3/Filer/Linux/XXXX_hooks.c:37:25: fatal error:
btrfs/ctree.h: No such file or directory
 #include <btrfs/ctree.h>
                         ^
compilation terminated.

The file "/usr/src/linux/fs/btrfs/ctree.h" ofcourse exists
