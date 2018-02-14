Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:43345 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031640AbeBNPmC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:42:02 -0500
Received: by mail-yw0-f181.google.com with SMTP id p2so1369849ywg.10
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 07:42:02 -0800 (PST)
MIME-Version: 1.0
From: Ilan Schwarts <ilan84@gmail.com>
Date: Wed, 14 Feb 2018 17:42:01 +0200
Message-ID: <CAJUuSvFH1cAe2ivNP6i5pjqpgnba9NSgxNeuHiH+x2YEObrnPw@mail.gmail.com>
Subject: calling inode->i_op->getattr to get kstat structure to obtain device id
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I know you dont like it, but i need to get the device id as it appear
in user space from kernel space.
i know its anonymous device id and i should not get it. but i still need it.

I found there are 2 ways to get it:
1.  cast inode to btrfs_inode and get it from btrfs_inode->root->anon_dev
2. from dentry object: dentry->d_inode->i_op->getattr(NULL, dentry,kstat);

There is a problem !
Usually what I do on file system event is to take the
dentry->d_inode-... everything works fine.

BUT on rename operations, the signature for vfs_rename is dual of
inode-struct: (struct inode *, struct dentry *,struct inode *, struct
dentry *, unsigned int)
So what i do is take the 2nd dual dentry struct (destination dentry),
and when i look for d_inode, there is no inode.
And if i take the 2nd dual inode parameter from the vfs_rename
function and try to call it inode->i_op->getattr(...) with the 2nd
dual dentry -> I get btrfs_getattr exception.

Is there a solution ?
This happens on Suse kernel 3.12.69-60 - hello david s :)


-- 


-
Ilan Schwarts
