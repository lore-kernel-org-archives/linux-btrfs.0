Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38860 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753047AbdCTIdx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 04:33:53 -0400
Received: by mail-wm0-f54.google.com with SMTP id t189so57911921wmt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Mar 2017 01:33:48 -0700 (PDT)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Mon, 20 Mar 2017 10:33:47 +0200
Message-ID: <CAJUuSvHU=O3NwKU_td+mxg003p_-UAVNR8uwqyJvMbSC5djpVg@mail.gmail.com>
Subject: include linux kernel headers for btrfs filesystem
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I need to cast struct inode to struct btrfs_inode.
in order to do it, i looked at implementation of btrfs_getattr.

the code is simple:
struct btrfs_inode *btrfsInode;
btrfsInode = BTRFS_I(inode);

in order to compile i must add the headers on top of the function:
#include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/ctree.h"
#include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/btrfs_inode.h"

What is the problem ?
I must manually download and include ctree.h and btrfs_inode.h, they
are not provided in the kernel-headers package.
On every platform I compile my driver, I have specific VM for the
distro/kernel version, so on every VM I usually download package
kernel-headers and everything compiles perfectly.

btrfs was introduced in kernel 3.0 above.
Arent the btrfs headers should be there ? do they exist in another
package ? maybe fs-headers or something like that ?
