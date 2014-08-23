Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60121 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHWQjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 12:39:49 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so17989649pab.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 09:39:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Aug 2014 16:39:48 +0000
Message-ID: <CAGP2HaPx2pXbN=FyBH5MskrsufDXcWtddVfG4Kaie-ZVg=ivJg@mail.gmail.com>
Subject: btrfs unmountable, any btrfs tool segfaults
From: Nikolay Shtabel <shtabnik@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm using archinux with btrfs as root filesystem, kernel 3.15.2, btrfs 3.14.2.

System was working fine for more than year, but suddenly
after large pacman update filesystem came to
unrecoverable error (remounted root ro).

I've decided to reboot, and after that btrfs failed to mount:

[ 1673.285020] BTRFS: bad tree block start 0 471748608
[ 1673.285071] BTRFS: bad tree block start 0 471748608
[ 1673.317384] BTRFS: open_ctree failed

When trying to mount with -o ro, recovery:

[ 1788.777081] BTRFS info (device sdc2): enabling auto recovery
[ 1788.777088] BTRFS info (device sdc2): disk space caching is enabled
[ 1788.778502] BTRFS: bad tree block start 0 471748608
[ 1788.778577] BTRFS: bad tree block start 0 471748608
[ 1788.778657] BTRFS: bad tree block start 0 471748608
[ 1788.778774] BTRFS: bad tree block start 0 471748608
[ 1788.778990] BTRFS: bad tree block start 0 260931584
[ 1788.779221] BTRFS: bad tree block start 0 260931584
[ 1788.779236] BTRFS: failed to read tree root on sdc2
[ 1788.779563] parent transid verify failed on 260562944 wanted 427348
found 427351
[ 1788.779907] parent transid verify failed on 260562944 wanted 427348
found 427351
[ 1788.779908] BTRFS: failed to read tree root on sdc2
[ 1788.780288] parent transid verify failed on 260358144 wanted 427347
found 427351
[ 1788.780571] parent transid verify failed on 260358144 wanted 427347
found 427351
[ 1788.780575] BTRFS: failed to read tree root on sdc2
[ 1788.844215] BTRFS: open_ctree failed

Then, i've tried to btrfs check:

Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
read block failed check_tree_block
Checking filesystem on /dev/sdc2
UUID: 9b5edd54-b3cb-4882-b8d5-ede68717e0aa
Critical roots corrupted, unable to fsck the FS
Segmentation fault
(btrfs[5049]: segfault at 1d3 ip 000000000042e35d sp 00007fff6b317870
error 4 in btrfs[400000+6b000])

As there are errors with csum and extent tree i've tried to reinit them also:

btrfs check --init-csum-tree:

Creating a new CRC tree
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
read block failed check_tree_block
Checking filesystem on /dev/sdc2
UUID: 9b5edd54-b3cb-4882-b8d5-ede68717e0aa
Reinit crc root
Unable to find block group for 0
btrfs: extent-tree.c:288: find_search_start: Assertion `!(1)' failed.
Aborted

btrfs check --init-extent-tree:

Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
read block failed check_tree_block
Checking filesystem on /dev/sdc2
UUID: 9b5edd54-b3cb-4882-b8d5-ede68717e0aa
Creating a new extent tree
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
read block failed check_tree_block
Error reading root block
error pinning down used bytes
Segmentation fault
([ 2816.659245] btrfs[5068]: segfault at 1d3 ip 000000000042e35d sp
00007fffc2052420 error 4 in btrfs[400000+6b000])

After all, the last step is to use btrfs restore:

btrfs restore -iv /dev/sdc2 /mnt/restore/
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
Check tree block failed, want=471748608, have=0
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
Check tree block failed, want=468189184, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
Check tree block failed, want=466935808, have=0
read block failed check_tree_block
Segmentation fault
[ 3324.252370] btrfs[32022]: segfault at fffffffffffffffb ip
000000000042a763 sp 00007fff14488690 error 5 in btrfs[400000+6b000]

I've tried this with latest btrfs-progs built from git.

Can you please suggest any method to restore files from filesystem?

Thanks!

Nikolay Shtabel
