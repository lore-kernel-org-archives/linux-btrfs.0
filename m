Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:44193 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbeDPIFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 04:05:16 -0400
Received: by mail-yb0-f171.google.com with SMTP id z1-v6so2313802ybn.11
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 01:05:16 -0700 (PDT)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Mon, 16 Apr 2018 11:05:15 +0300
Message-ID: <CAJUuSvFzg1UyLLub1OdyBc-ctaZ-JsUouWiFj3ZVLWfJ4wzykw@mail.gmail.com>
Subject: Why btrfsInode -> root is null
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I maintain kernel module on top of VFS.
When action executes, e.g vfs_rename, i get dentry object.
I need to get the fsid from the dentry object.
Since I maintain the same code for alot of suse distro and kernels
(11.4, 12.0, 12.1, 12.2), i have many #if macros,

My question is in SLES 12.2 kernel 4.4.103*, How do i get BTRFS dentry FSID ?
In previous kernels I did:
1. dentry->d_inode->i_op->getattr(NULL, dentry, &kstat)
2. btrfsInode->root->anon_super.s_dev
3. btrfsInode->root->anon_dev

I cast Inode to btrfs inode:
    struct btrfs_inode *btrfsInode;
    btrfsInode = BTRFS_I(dentry->d_inode);


On this version 4.4.103*,, there is the operation:
dentry->d_inode->i_sb->s_op->get_inode_dev(dentry->d_inode);

I have 2 questions,
1. Is this the proper way to obtain it ?
2. In some dentries, after casting inode to btrfsInode, the
btrfsInode->root is null, how could that be ? shouldn't the cast fail
(return null) ?

Thanks
