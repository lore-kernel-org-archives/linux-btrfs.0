Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35773 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbeAVLWE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 06:22:04 -0500
Received: by mail-wm0-f43.google.com with SMTP id r78so16100892wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 03:22:03 -0800 (PST)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Mon, 22 Jan 2018 13:22:02 +0200
Message-ID: <CAJUuSvFbxuXL=Tc9iLgbY=VPcho5XdQ_UCs+br+SwSHf=JiRbA@mail.gmail.com>
Subject: miss match in btrfs getattr
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If i stat a file from userspace:

      File: ‘/home/builder/leon10’
       Size: 0               Blocks: 0          IO Block: 4096   directory
      Device: 31h/49d Inode: 550109      Links: 1


Inode is 550109 and device id is 49.

When I am in the kernel, I try to get that device id (49), I call
vfs_stat("/home/builder/leon10"), this returns me also 49.
If i look at the vfs_stat implementation (located at fs/stat.c):

    vfs_stat(..) -> vfs_fstatat(..) -> vfs_getattr(..) -> this return:
inode->i_op->getattr(path->mnt, path->dentry, stat);

This is a btrfs file system, so i am looking at function getattr on
inode.c (in fs\btrfs\inode.c kernel sources)
static int btrfs_getattr(struct vfsmount *mnt,
struct dentry *dentry, struct kstat *stat)
{
u64 delalloc_bytes;
struct inode *inode = dentry->d_inode;
u32 blocksize = inode->i_sb->s_blocksize;

generic_fillattr(inode, stat);
stat->dev = BTRFS_I(inode)->root->anon_dev;
So look at stat->dev = BTRFS_I(inode)->root->anon_dev; carefully, When
on my kernel module code i take an inode i hold, and try to print
this:

    LOG( V_LOG_NOTICE, "BTRFS_I(inode)->root->anon_dev=%d",
BTRFS_I(inode)->root->anon_dev);
I get 0 or some wierd numbers like 1064756416.

Why is that miss match ? What am I missing ?

Isn't that the right getattr btrfs implementaion ?
