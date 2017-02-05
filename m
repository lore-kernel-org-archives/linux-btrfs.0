Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49162 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdBEVyD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 16:54:03 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 98EA060014
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Feb 2017 22:54:00 +0100 (CET)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Bug or feature? logical_to_ino skips inodes with offset mismatch
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9eb6d42e-a44b-c427-ed37-1eaa67944b3f@mendix.com>
Date: Sun, 5 Feb 2017 22:54:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was playing around with logical_to_ino and also implemented calling
ino_lookup today to create a program that will print all data extents in
a block group, and their related inodes and at least one filename per inode.

https://github.com/knorrie/python-btrfs/commits/develop
See "examples: show filenames for data extents"

I ran into the following behaviour of logical_to_ino:

If the offset value in a backreference of an extent_item does not match
the offset value of the extent_data object in the fs tree,
logical_to_ino will skip the inode that uses data from the extent, and
not report it.

This leads to extents for which logical_to_ino does not give any result,
while there's actually a file using data from the extent.

Is this a bug or a feature?

How to test (only relevant output lines pasted):

1. copy a file into place:

-# cp /boot/vmlinuz-4.9.0-1-amd64 /mnt/i320/fstree/

-# examples/show_block_group_contents.py 289406976 /mnt/i320/fstree/
extent vaddr 336048128 length 4186112 refs 1 gen 57 flags DATA
    inline extent data backref root 5 objectid 266 offset 0 count 1

-# examples/show_block_group_data_extent_filenames.py 289406976
/mnt/i320/fstree/
extent vaddr 336048128 length 4186112 refs 1 gen 57 flags DATA
    root 5 inode 266 offset 0 path 'vmlinuz-4.9.0-1-amd64'

-# btrfs inspect-internal logical-resolve 336048128 .
./vmlinuz-4.9.0-1-amd64

2. Now, overwrite the beginning of the file, so we have a new extent for
that data, and so that the old big extent holds 16kiB of
'wasted/unreachable' data at the beginning.

-# dd if=/dev/urandom bs=16k conv=notrunc of=vmlinuz-4.9.0-1-amd64 count=1

Result:

-# examples/show_block_group_contents.py 289406976 /mnt/i320/fstree/
extent vaddr 336048128 length 4186112 refs 1 gen 57 flags DATA
    inline extent data backref root 5 objectid 266 offset 0 count 1
extent vaddr 341217280 length 16384 refs 1 gen 60 flags DATA
    inline extent data backref root 5 objectid 266 offset 0 count 1

Notice that the backrefs both list offset 0, since there's only one per
referenced inode and it doesn't get updated when the're a change in
which parts of the extent are actually still used by the inode.

3. logical_to_ino does not list the inode any more as user of this
extent now:

-# examples/show_block_group_data_extent_filenames.py 289406976
/mnt/i320/fstree/
extent vaddr 336048128 length 4186112 refs 1 gen 57 flags DATA
extent vaddr 341217280 length 16384 refs 1 gen 60 flags DATA
    root 5 inode 266 offset 0 path 'vmlinuz-4.9.0-1-amd64'

-# btrfs inspect-internal logical-resolve 336048128 .
<no output>

-# btrfs-debug-tree -t 5 /dev/i320/fstree
    item 6 key (266 EXTENT_DATA 0) itemoff 15765 itemsize 53
        extent data disk byte 341217280 nr 16384
        extent data offset 0 nr 16384 ram 16384
        extent compression(none)
    item 7 key (266 EXTENT_DATA 16384) itemoff 15712 itemsize 53
        extent data disk byte 336048128 nr 4186112
        extent data offset 16384 nr 4169728 ram 4186112
        extent compression(none)

-- 
Hans van Kranenburg
