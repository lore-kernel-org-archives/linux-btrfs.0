Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:49368 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727851AbeHLWhk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 18:37:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23408.34902.778845.675960@techsquare.com>
Date: Sun, 12 Aug 2018 15:19:50 -0400
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: trouble mounting btrfs filesystem....
From: "Scott E. Blomquist" <sb@techsquare.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi All,

Early this morning there was a power glitch that affected our system.

The second enclosure went offline but the file system stayed up for a
bit before rebooting and recovering the 2 missing arrays sdb1 and
sdc1.

When mounting we get....

    Aug 12 14:52:43 localhost kernel: [ 8536.649270] BTRFS info (device sda1): has skinny extents
    Aug 12 14:54:52 localhost kernel: [ 8665.900321] BTRFS error (device sda1): parent transid verify failed on 177443463479296 wanted 2159304 found 2159295
    Aug 12 14:54:52 localhost kernel: [ 8665.985512] BTRFS error (device sda1): parent transid verify failed on 177443463479296 wanted 2159304 found 2159295
    Aug 12 14:54:52 localhost kernel: [ 8666.056845] BTRFS error (device sda1): failed to read block groups: -5
    Aug 12 14:54:52 localhost kernel: [ 8666.254178] BTRFS error (device sda1): open_ctree failed

We are here...

    # uname -a
    Linux localhost 4.17.14-custom #1 SMP Sun Aug 12 11:54:00 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux

    # btrfs --version
    btrfs-progs v4.17.1
    
    # btrfs filesystem show
    Label: none  uuid: 8337c837-58cb-430a-a929-7f6d2f50bdbb
            Total devices 3 FS bytes used 75.05TiB
            devid    1 size 47.30TiB used 42.07TiB path /dev/sda1
            devid    2 size 21.83TiB used 16.61TiB path /dev/sdb1
            devid    3 size 21.83TiB used 16.61TiB path /dev/sdc1
    
Thanks for any help.

sb. Scott Blomquist
