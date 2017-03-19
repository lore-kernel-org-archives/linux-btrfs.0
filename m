Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:35372 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdCSPBB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Mar 2017 11:01:01 -0400
Received: by mail-wr0-f182.google.com with SMTP id g10so77964217wrg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Mar 2017 08:01:00 -0700 (PDT)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Sun, 19 Mar 2017 17:00:59 +0200
Message-ID: <CAJUuSvHkhpFSf_5V_KDev4i2AosQcgZTUvuF57YMng2kGpGVaw@mail.gmail.com>
Subject: 
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
sorry if this is a newbie question. I am newbie.

In my kernel driver, I get device id by converting struct inode struct
to btrfs_inode, I use the code:
struct btrfs_inode *btrfsInode;
btrfsInode = BTRFS_I(inode);

I usually download kernel-headers rpm package, this is not enough. it
fails to find the btrfs header files.

I had to download them not via rpm package and declare:
#include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/ctree.h"
#include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/btrfs_inode.h"

This is not good, why ctree.h and btrfs_inode.h are not in kernel headers?
Is there another package i need to download in order to get them, in
addition to kernel-headers? ?


I see they are not provided in kernel-header package, e.g:
https://rpmfind.net/linux/RPM/fedora/23/x86_64/k/kernel-headers-4.2.3-300.fc23.x86_64.html

Thanks!
