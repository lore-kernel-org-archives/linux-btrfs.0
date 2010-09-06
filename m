From: Jan Steffens <jan.steffens@gmail.com>
Subject: parent transid verify failed
Date: Mon, 6 Sep 2010 19:28:47 +0200
Message-ID: <AANLkTi=0C_u-cMXSZuSDwEvc3+6OFmK95mJDLFmh7Y48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After an unclean shutdown, my btrfs is now unmountable:

device label root devid 1 transid 375202 /dev/sdc4
parent transid verify failed on 53984886784 wanted 375202 found 375201
parent transid verify failed on 53984886784 wanted 375202 found 375201
parent transid verify failed on 53984886784 wanted 375202 found 375201
btrfs: open_ctree failed

btrfsck aborts:

couldn't open because of unsupported option features (2).
btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
[1]    14899 abort      btrfsck /dev/sdc4

Is there any way to recover the filesystem?
