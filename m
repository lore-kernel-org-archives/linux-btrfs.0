Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcmd04131.aruba.it ([62.149.158.131]:40855 "EHLO
        smtpcmd04131.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934542AbdGTKcQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 06:32:16 -0400
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com
From: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Subject: btrfs check --clear-space-cache v2- Aborted (core dumped)
Message-ID: <6d51cb50-519e-006f-8bc5-e3fc3bbce20d@prismatelecomtesting.com>
Date: Thu, 20 Jul 2017 12:31:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
trying to clear the free space tree along with its superblock flag with:

btrfs check --clear-space-cache v2 /dev/sda1

# btrfs check --clear-space-cache v2 /dev/sda1
warning, device 2 is missing
checksum verify failed on 2933047296 found C638A419 wanted 7BA892F9
checksum verify failed on 2933047296 found FCC10AC8 wanted F236F1E3
checksum verify failed on 2933047296 found C638A419 wanted 7BA892F9
bytenr mismatch, want=2933047296, have=905984309666124871
Clear free space cache v2
checksum verify failed on 991456149504 found 7314FC11 wanted 148C89F0
checksum verify failed on 991456149504 found 4D935969 wanted C2ABFEDC
checksum verify failed on 991456149504 found 7314FC11 wanted 148C89F0
bytenr mismatch, want=991456149504, have=12366213938999735219
checksum verify failed on 991456182272 found C33FF4B8 wanted D2B189C7
checksum verify failed on 991456182272 found ECEC23F6 wanted 72356443
checksum verify failed on 991456182272 found ECEC23F6 wanted 72356443

[...]

checksum verify failed on 2892513280 found 1FCC88EA wanted 6F69B679
checksum verify failed on 2892513280 found E35FBBCC wanted 6B469855
checksum verify failed on 2892513280 found 1FCC88EA wanted 6F69B679
bytenr mismatch, want=2892513280, have=12929583740463107260
Unable to find block group for 0
extent-tree.c:287: find_search_start: Warning: assertion `1` failed, value 1
btrfs(btrfs_reserve_extent+0x87e)[0x41b86c]
btrfs(btrfs_alloc_free_block+0x58)[0x41bc4c]
btrfs(__btrfs_cow_block+0xdb)[0x40bcc4]
btrfs(btrfs_cow_block+0x123)[0x40c7c1]
btrfs(btrfs_search_slot+0x1b7)[0x40f02d]
btrfs(btrfs_clear_free_space_tree+0x200)[0x437318]
btrfs(cmd_check+0x7e7)[0x45ccf5]
btrfs(main+0x15d)[0x40abd4]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7fe385281b35]
btrfs[0x40a6a9]
extent-tree.c:2696: btrfs_reserve_extent: BUG_ON `ret` triggered, value -28
btrfs[0x415f66]
btrfs(btrfs_reserve_extent+0xbb6)[0x41bba4]
btrfs(btrfs_alloc_free_block+0x58)[0x41bc4c]
btrfs(__btrfs_cow_block+0xdb)[0x40bcc4]
btrfs(btrfs_cow_block+0x123)[0x40c7c1]
btrfs(btrfs_search_slot+0x1b7)[0x40f02d]
btrfs(btrfs_clear_free_space_tree+0x200)[0x437318]
btrfs(cmd_check+0x7e7)[0x45ccf5]
btrfs(main+0x15d)[0x40abd4]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7fe385281b35]
btrfs[0x40a6a9]
Aborted (core dumped)

full output:
http://cwillu.com:8080/212.31.224.210/3

background:
Testing BTRFS RAID6

Problem:
I started copying data to filesystem with btrfs send.
One of the disks died while writing data.
The copy continued for some hours (and 2,6T) until it went RO.

full story:
http://cwillu.com:8080/212.31.224.210/1

Regards,

-- 
Marco Crociani
