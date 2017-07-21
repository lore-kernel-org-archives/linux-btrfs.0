Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56704 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbdGUX6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 19:58:53 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 9E3256002C
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 01:58:51 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v8
To: linux-btrfs@vger.kernel.org
Message-ID: <704d6357-228d-b525-3e1f-1c5b029f6874@mendix.com>
Date: Sat, 22 Jul 2017 01:58:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last week, I tagged v8 of the python btrfs library:

https://github.com/knorrie/python-btrfs

Here's the summary of changes:

python-btrfs v8, Jul 18 2017
  * Easier handling of multiple appended data structures of the dir
    item and inode ref families easier. (not backwards compatible!)
  * Don't keep metadata page transid value when retrieving a
    BlockGroupItem. This was introduced in v4, but it's not technically
    correct.
  * Improve architecture dependent ioctl number handling.
  * Examples added:
    - Do a custom sorted btrfs balance, working from the least used
      block group to the most used, stopping at some usage value.
    - Calculate an inode extref hash from an inode number and file name.
  * Fixes:
    - Another unfortunate typo in __str__ methods of an object

As usual, detailed explanations of all changes are in the git commit
messages.

My favourite one is the custom balance script. Figuring out the usage of
the block groups and sorting them etc is taking up 99% of the code. The
actual call to the balance ioctl is just two lines. :D

    args = btrfs.ioctl.BalanceArgs(vstart=vaddr, vend=vaddr+1)
    progress = btrfs.ioctl.balance_v2(fs.fd, data_args=args)

For the -o ssd users who need to use balance all the time to keep their
filesystem from crashing, this provides a fun way (well, at least it
gives live feedback about what it's doing...) to get rid of
underutilized chunks.

The debian packages are already uploaded to unstable (thanks, kilobyte!)
and they're also on their way to stretch-backports. \o/
After that happened, I'll be doing a small update for btrfs-heatmap and
also try to get that into stretch-backports.

-- 
Have fun,
Hans van Kranenburg
