Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:33369 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754836AbdCTT0X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 15:26:23 -0400
Received: by mail-ua0-f169.google.com with SMTP id u30so82018758uau.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Mar 2017 12:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJUuSvHU=O3NwKU_td+mxg003p_-UAVNR8uwqyJvMbSC5djpVg@mail.gmail.com>
References: <CAJUuSvHU=O3NwKU_td+mxg003p_-UAVNR8uwqyJvMbSC5djpVg@mail.gmail.com>
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
Date: Mon, 20 Mar 2017 21:25:38 +0200
Message-ID: <CAOcd+r0_=CcvjnxV7GgbBEp6mRdp+YLgO+ucMZtLZLx0oEAC-A@mail.gmail.com>
Subject: Re: include linux kernel headers for btrfs filesystem
To: Ilan Schwarts <ilan84@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ilan,

On Mon, Mar 20, 2017 at 10:33 AM, Ilan Schwarts <ilan84@gmail.com> wrote:
> I need to cast struct inode to struct btrfs_inode.
> in order to do it, i looked at implementation of btrfs_getattr.
>
> the code is simple:
> struct btrfs_inode *btrfsInode;
> btrfsInode = BTRFS_I(inode);
>
> in order to compile i must add the headers on top of the function:
> #include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/ctree.h"
> #include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/btrfs_inode.h"
>
> What is the problem ?
> I must manually download and include ctree.h and btrfs_inode.h, they
> are not provided in the kernel-headers package.
> On every platform I compile my driver, I have specific VM for the
> distro/kernel version, so on every VM I usually download package
> kernel-headers and everything compiles perfectly.
>
> btrfs was introduced in kernel 3.0 above.
> Arent the btrfs headers should be there ? do they exist in another
> package ? maybe fs-headers or something like that ?

Try using the below simple Makefile[1] to compile btrfs loadable
module. You need to have the kernel-headers package installed.
You can place the makefile anywhere you want, and compile via:
# make -f <path to makefile>

Thanks,
Alex.


[1]
obj-m += btrfs.o

# or substitute with hard-coded kernel version
KVERSION = $(shell uname -r)

SRC_DIR=<path to your kernel source>/fs/btrfs
BTRFS_KO=btrfs.ko

# or specify any other output directory
OUT_DIR=/lib/modules/$(KVERSION)/kernel/fs/btrfs

all: $(OUT_DIR)/$(BTRFS_KO)

$(OUT_DIR)/$(BTRFS_KO): $(SRC_DIR)/$(BTRFS_KO)
    cp $(SRC_DIR)/$(BTRFS_KO) $(OUT_DIR)/

$(SRC_DIR)/$(BTRFS_KO): $(SRC_DIR)/*.c $(SRC_DIR)/*.h
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(SRC_DIR) modules

clean:
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(SRC_DIR) clean
    test -f $(OUT_DIR)/$(BTRFS_KO) && rm $(OUT_DIR)/$(BTRFS_KO)    || true


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
