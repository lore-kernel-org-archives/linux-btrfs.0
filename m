Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38072 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbdC3WkK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 18:40:10 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 9290960012
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 00:40:06 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Bug: misleading free space tree messages when mounting ro
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <87ec1249-b0b8-643b-9031-ebc9aae5f80a@mendix.com>
Date: Fri, 31 Mar 2017 00:40:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today I wanted to convert a filesystem to free space tree, because it's
great. But, the filesystem is the root fs, so I could not just umount
and mount it.

I wanted to try to get the conversion done during boot, so I started
messing around with initramfs and grub.

When trying this and doing things like update initramfs, edit grub
settings with rootflags=space_cache=v2 etc, the filesystem *seemed* to
start using the free space tree, but was actually not. Mount output and
dmesg output says: "enabling free space tree", "using free space tree"
etc, but it actually never created the free space tree.

After trying some things, I realized that when doing a readonly mount
the first time, it would be quite understandable that the filesystem
would not do a free space conversion on a readonly target. So, after
using rw instead of ro once in the grub line, it actually happened.

However, when mounting with space_cache=v2 the first time, in
combination with readonly, the messages are quite misleading:

It's easily reproducable with a small test fs:

-# mount -o ro,space_cache=v2 /dev/sdx /mnt/btrfs

BTRFS info (device sdx): enabling free space tree
BTRFS info (device sdx): using free space tree

mount says:

/dev/sdx on /mnt/btrfs type btrfs
(ro,relatime,ssd,space_cache=v2,subvolid=5,subvol=/)

but:

-# ./show_tree_keys.py 10 /mnt/btrfs/
Traceback (most recent call last):
  File "./show_tree_keys.py", line 13, in <module>
    for header, _ in btrfs.ioctl.search_v2(fs.fd, tree):
  File "/home/knorrie/src/git/python-btrfs/examples/btrfs/ioctl.py",
line 265, in search_v2
    fcntl.ioctl(fd, IOC_TREE_SEARCH_V2, buf)
FileNotFoundError: [Errno 2] No such file or directory

Nope, no FST. Not even close.

When mounting rw,space_cache=v2, it actually happens:

BTRFS info (device sdx): creating free space tree
BTRFS info (device sdx): setting 1 ro feature flag
BTRFS info (device sdx): setting 2 ro feature flag

Well... there it is:

-# ./show_tree_keys.py 10 /mnt/btrfs/
(20971520 FREE_SPACE_INFO 8388608)
(20971520 FREE_SPACE_EXTENT 16384)
(21004288 FREE_SPACE_EXTENT 8355840)
(29360128 FREE_SPACE_INFO 1073741824)
(29360128 FREE_SPACE_EXTENT 49152)
(29507584 FREE_SPACE_EXTENT 114688)
(29638656 FREE_SPACE_EXTENT 98304)
(29769728 FREE_SPACE_EXTENT 49152)
(29835264 FREE_SPACE_EXTENT 16384)
(29868032 FREE_SPACE_EXTENT 1073233920)
(1103101952 FREE_SPACE_INFO 2147483648)
(1103101952 FREE_SPACE_EXTENT 2147483648)


So: it would be better to print something in dmesg about "not creating
free space tree, ignoring space_cache=v2 because mounting read only",
instead of keeping the mount option active and printing those messages.

And, of course not displaying the option as active afterwards.

Moo,

-- 
Hans van Kranenburg
