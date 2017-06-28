Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64571 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750934AbdF1F72 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:59:28 -0400
Date: Wed, 28 Jun 2017 13:59:14 +0800
From: Dai Xiang <xiangx.dai@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: xiangx.dai@intel.com
Subject: [QUESTION] xfstest generic/015 run failed
Message-ID: <20170628055914.GA11753@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi! I test on my host and find below issue, i want to know how can fix it?

root@ubuntu ~/xfstests# ./check generic/015
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 ubuntu 4.12.0-rc6
MKFS_OPTIONS  -- /dev/sda2
MOUNT_OPTIONS -- /dev/sda2 /fs/scratch

generic/015     - output mismatch (see ~/xfstests/results//generic/015.out.bad)
    --- tests/generic/015.out    2017-05-31 18:15:23.000000000 +0800
    +++ ~/xfstests/results//generic/015.out.bad    2017-06-28 10:12:11.001630002 +0800
    @@ -4,4 +4,5 @@
     check free space:
     delete fill:
     check free space:
    -   !!! free space is in range
    +   !!! free space has value of 17348
    +free space is NOT in range 45591.48 .. 46512.52
    ...
    (Run 'diff -u tests/generic/015.out ~/xfstests/results//generic/015.out.bad'  to see the entire diff)
Ran: generic/015
Failures: generic/015
Failed 1 of 1 tests

I print _free to log and find after rm, the space do not free:

root@ubuntu ~/xfstests# cat log
/dev/sda2      btrfs       51200 16416     46052      27% /fs/scratch
46052
/dev/sda2      btrfs       51200 46144     17348      73% /fs/scratch
17348
/dev/sda2      btrfs       51200 46144     17348      73% /fs/scratch
17348

It makes me confused, and i am sure the file has removed and can not create size over 17348 file.
Is it a bug or something wrong with my host?

Thanks
Dai Xiang
