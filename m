Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:43715 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbeAVIHk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 03:07:40 -0500
Received: by mail-wr0-f171.google.com with SMTP id t16so7551510wrc.10
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 00:07:39 -0800 (PST)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Mon, 22 Jan 2018 10:07:38 +0200
Message-ID: <CAJUuSvHutOWxR7FhtG_SCyHh=_u5EWyJAJNU_pkgHRdEJnqcyA@mail.gmail.com>
Subject: btrfs inode is different across file systems ?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

If I get btrfs inode in this way: btrfs_ino(inode)
implemented at btrfs_inode.h:
static inline u64 btrfs_ino(struct inode *inode)
{
u64 ino = BTRFS_I(inode)->location.objectid;
if (!ino || BTRFS_I(inode)->location.type == BTRFS_ROOT_ITEM_KEY)
ino = inode->i_ino;
return ino;
}

Is that inode number is unique between 2 btrfs file systems ?
Lets assume, i have 2 btrfs file systems on my machine, file system A
and file system B, each of these file system has volumes.
is the inode obtained via BTRFS_I(inode)->location.objectid is
guaranteed to be unique across all the btrfs file systems, or just per
the file system this inode is at ?
