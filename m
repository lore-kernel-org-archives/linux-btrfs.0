Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57920 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdFITMY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 15:12:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dJPKS-0004aZ-VN
        for linux-btrfs@vger.kernel.org; Fri, 09 Jun 2017 21:12:16 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
Date: Fri, 9 Jun 2017 21:12:16 +0200
Message-ID: <oherub$g5a$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Today the kernel got wedged during shutdown (4.11.x tends to do that, haven't
debugged) and I pressed the reset button. The next boot btrfs won't mount:

[Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
[Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
[Fri Jun  9 20:46:07 2017] BTRFS error (device md0): failed to read block groups: -5
[Fri Jun  9 20:46:08 2017] BTRFS error (device md0): open_ctree failed

I tried repair, but that didn't work either:

# btrfsck --repair /dev/md0
enabling repair mode
couldn't open RDWR because of unsupported option features (3).
ERROR: cannot open file system
enabling repair mode

Googling around it was suggested clearing the v2 space cache:

# btrfsck --mode=lowmem --clear-space-cache v2 /dev/md0
parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
Ignoring transid failure
leaf parent key incorrect 5840011722752
parent transid verify failed on 5367057465344 wanted 170755 found 170828
parent transid verify failed on 5367057465344 wanted 170755 found 170828
parent transid verify failed on 5367057465344 wanted 170755 found 170828
parent transid verify failed on 5367057465344 wanted 170755 found 170828
Ignoring transid failure
leaf parent key incorrect 72105984
btrfs unable to find ref byte nr 4628577484800 parent 0 root 10  owner 0 offset 1
parent transid verify failed on 5366993256448 wanted 170755 found 170827
parent transid verify failed on 5366993256448 wanted 170755 found 170827
parent transid verify failed on 5366993256448 wanted 170755 found 170827
parent transid verify failed on 5366993256448 wanted 170755 found 170827
Ignoring transid failure
leaf parent key incorrect 41287680
ERROR: failed to clear free space cache v2: -1
transaction.h:41: btrfs_start_transaction: BUG_ON `root->commit_root` triggered, value 22938400
btrfs check[0x411674]
btrfs check(close_ctree_fs_info+0x125)[0x41368c]
btrfs check(cmd_check+0x36d8)[0x45e8e8]
btrfs check(main+0x15d)[0x40ac5c]
/lib/libc.so.6(__libc_start_main+0xf0)[0x7f9b4cb060d0]
btrfs check[0x40a729]
Clear free space cache v2

The underlying md0 (raid6) doesn't report any errors, trying different kernels makes no difference, 4.10.17, 4.11.4 and 4.12.0-rc4 all give the same errors. Everything above was
done with btrfs-progs 4.11.

Any hints on how I can fix the errors in the filesystem? I don't mind loosing todays changes, but I would like to keep all the older data :)

regards,

Koen

