From: Curtis Jones <curtis.jones@gmail.com>
Subject: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sat, 18 Feb 2012 15:34:22 -0500
Message-ID: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I recently let the Update Manager run after ignoring it for a couple of weeks. It required a reboot. My USB btrfs volume didn't mount after reboot. dmesg revealed:

[ 463.187097] btrfs: open_ctree failed
[ 991.567090] device label StoreW devid 1 transid 37077 /dev/sdb
[ 1003.171989] device label StoreW devid 1 transid 37077 /dev/sdb
[ 1003.207990] parent transid verify failed on 79466496 wanted 33999 found 36704
[ 1003.208363] parent transid verify failed on 79466496 wanted 33999 found 36704
[ 1003.208857] parent transid verify failed on 79466496 wanted 33999 found 36704
[ 1003.208859] parent transid verify failed on 79466496 wanted 33999 found 36704
[ 1003.230889] btrfs: open_ctree failed

btrfs-show plainly enough finds my volume:

$ sudo btrfs-show
Label: StoreW uuid: e98e0ffd-3d0b-4b55-bacc-0d60797f0f29
Total devices 1 FS bytes used 1.79TB
devid 1 size 2.73TB used 1.90TB path /dev/sdb

Btrfs Btrfs v0.19

but everything else (like "btrfsctl -a") doesn't see it.

I've read dozens of pleas for "open_ctree" issues, but none of them had useful conclusions. Is there anything I can do?

Any help would be appreciated. Thank you. Please CC me on any replies.

Linux veriton 3.0.0-16-generic-pae #28-Ubuntu SMP Fri Jan 27 19:24:01 UTC 2012 i686 i686 i386 GNU/Linux

--
Curtis Jones
curtisjones.us
404.492.6437




