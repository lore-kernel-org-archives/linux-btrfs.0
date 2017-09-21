Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48016 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750912AbdIUEKe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 00:10:34 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: LOGICAL_INO enhancements (this time based on 4.14-rc1)
Date: Thu, 21 Sep 2017 00:10:13 -0400
Message-Id: <20170921041016.14752-1-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The previous patch series was based on v4.12.14, and this introductory
text was missing.

This patch series fixes some weaknesses in the btrfs LOGICAL_INO ioctl.

Background:

Suppose we have a file with one extent:

    root@tester:~# zcat /usr/share/doc/cpio/changelog.gz > /test/a
    root@tester:~# sync

Split the extent by overwriting it in the middle:

    root@tester:~# cat /dev/urandom | dd bs=4k seek=2 skip=2 count=1 conv=notrunc of=/test/a

We should now have 3 extent refs to 2 extents, with one block unreachable.
The extent tree looks like:

    root@tester:~# btrfs-debug-tree /dev/vdc -t 2
    [...]
            item 9 key (1103101952 EXTENT_ITEM 73728) itemoff 15942 itemsize 53
                    extent refs 2 gen 29 flags DATA
                    extent data backref root 5 objectid 261 offset 0 count 2
    [...]
            item 11 key (1103175680 EXTENT_ITEM 4096) itemoff 15865 itemsize 53
                    extent refs 1 gen 30 flags DATA
                    extent data backref root 5 objectid 261 offset 8192 count 1
    [...]

and the ref tree looks like:

    root@tester:~# btrfs-debug-tree /dev/vdc -t 5
    [...]
            item 6 key (261 EXTENT_DATA 0) itemoff 15825 itemsize 53
                    extent data disk byte 1103101952 nr 73728
                    extent data offset 0 nr 8192 ram 73728
                    extent compression(none)
            item 7 key (261 EXTENT_DATA 8192) itemoff 15772 itemsize 53
                    extent data disk byte 1103175680 nr 4096
                    extent data offset 0 nr 4096 ram 4096
                    extent compression(none)
            item 8 key (261 EXTENT_DATA 12288) itemoff 15719 itemsize 53
                    extent data disk byte 1103101952 nr 73728
                    extent data offset 12288 nr 61440 ram 73728
                    extent compression(none)
    [...]

There are two references to the same extent with different, non-overlapping
byte offsets:

    [------------------72K extent at 1103101952----------------------]
    [--8K----------------|--4K unreachable----|--60K-----------------]
    ^                                         ^
    |                                         |
    [--8K ref offset 0--][--4K ref offset 0--][--60K ref offset 12K--]
                         |         
                         v
                         [-----4K extent-----] at 1103175680

We now want to find all of the references to extent bytenr 1103101952.

Without the patch (and without running btrfs-debug-tree), we have to
do it with 18 LOGICAL_INO calls:

    root@tester:~# btrfs ins log 1103101952 -P /test/
    Using LOGICAL_INO
    inode 261 offset 0 root 5

    root@tester:~# for x in $(seq 0 17); do btrfs ins log $((1103101952 + x * 4096)) -P /test/; done 2>&1 | grep inode
    inode 261 offset 0 root 5
    inode 261 offset 4096 root 5   <- same extent ref as offset 0
                                   (offset 8192 returns empty set, not reachable)
    inode 261 offset 12288 root 5
    inode 261 offset 16384 root 5  \
    inode 261 offset 20480 root 5  |
    inode 261 offset 24576 root 5  |
    inode 261 offset 28672 root 5  |
    inode 261 offset 32768 root 5  |
    inode 261 offset 36864 root 5  \
    inode 261 offset 40960 root 5   > all the same extent ref as offset 12288.
    inode 261 offset 45056 root 5  /  More processing required in userspace
    inode 261 offset 49152 root 5  |  to figure out these are all duplicates.
    inode 261 offset 53248 root 5  |
    inode 261 offset 57344 root 5  |
    inode 261 offset 61440 root 5  |
    inode 261 offset 65536 root 5  |
    inode 261 offset 69632 root 5  /

In the worst case the extents are 128MB long, and we have to do 32768
iterations of the loop to find one 4K extent ref.

With the patch, we just use one call to map all refs to the extent at once:

    root@tester:~# btrfs ins log 1103101952 -P /test/
    Using LOGICAL_INO_V2
    inode 261 offset 0 root 5
    inode 261 offset 12288 root 5

The TREE_SEARCH ioctl allows userspace to retrieve the offset and
extent bytenr fields easily once the root, inode and offset are known.
This is sufficient information to build a complete map of the extent
and all of its references.  Userspace can use this information to make
better choices to dedup or defrag.

