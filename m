Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:41935 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeANIdM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 03:33:12 -0500
Received: by mail-wm0-f49.google.com with SMTP id f71so4542381wmf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jan 2018 00:33:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz> <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
From: Ilan Schwarts <ilan84@gmail.com>
Date: Sun, 14 Jan 2018 10:33:10 +0200
Message-ID: <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
Subject: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs developers/users,

I was wondering regarding to fetching the correct fsid on btrfs from
the context of a kernel module.
if on suse11.3 kernel 3.0.101-0.47.71-default in order to get fsid, I
do the following:
convert inode struct to btrfs_inode struct (use btrfsInode =
BTRFS_I(inode)), then from btrfs_inode struct i go to root field, and
from root i take anon_dev or anon_super.s_dev.
        struct btrfs_inode *btrfsInode;
        btrfsInode = BTRFS_I(inode);
       btrfsInode->root->anon_super.s_dev    or
       btrfsInode->root->anon_dev    - depend on kernel.

In kernel 3.12.28-4-default in order to get the fsid, i need to go
to the inode -> superblock -> device id (inode->i_sb->s_dev)

Why is this ? and is there a proper/an official way to get it ?
