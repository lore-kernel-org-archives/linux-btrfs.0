Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:32986 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754427AbdBVJ7x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 04:59:53 -0500
Received: by mail-wr0-f173.google.com with SMTP id 97so4542143wrb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 01:59:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJUuSvF-B1Fc5KJCZ+9FneqMXH5a5ohNn3h5E6pjuU9MnQJwXA@mail.gmail.com>
References: <CAJUuSvF-B1Fc5KJCZ+9FneqMXH5a5ohNn3h5E6pjuU9MnQJwXA@mail.gmail.com>
From: Ilan Schwarts <ilan84@gmail.com>
Date: Wed, 22 Feb 2017 11:59:50 +0200
Message-ID: <CAJUuSvH5MH+K4WdnVKj0v4YatbQJq3x9azsHn_FDB53pSCoQxQ@mail.gmail.com>
Subject: Fwd:
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I previously had a problem that the same device has 2 device Id on btrfs.

In order to solve it, i had to use
BTRFS_I(inode)->root->anon_super.s_dev instead
of inode->i_sb->s_dev

My question is, if there is something like that for inodes, All directories
on my top level device has the same inode (512), I get inode by:
inode->i_ino

Is there additional way to get the inode number ?

Thanks!
