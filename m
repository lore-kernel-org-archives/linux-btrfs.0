From: Daniel Witzel <dannyboy48888@gmail.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Thu, 23 Jun 2011 21:11:22 +0000 (UTC)
Message-ID: <loom.20110623T230224-841@post.gmane.org>
References: <4E026FD4.7020606@podzimek.org> <1308793398-sup-9234@shiny> <20110623195409.GA21007@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Well still no cigar, didnt even change the error output. Thank you though for 
at least trying to help. here goes the error info with your patch applied to
/fs/btrfs/disk-io.c:

mount -o ro /dev/sdf1 (same for c1,d1,etc) /btrfs (dmesg output)
[ 1647.330104] btrfs: open_ctree failed
[ 1683.328038] device label 1TB0 devid 1 transid 2135 /dev/sdf1
[ 1683.344059] parent transid verify failed on 2206281838592 wanted 2135 found 
1545
[ 1683.349109] btrfs: open_ctree failed

btrfsck -s 0 (and 1) /dev/sdf1(c1,d1,etc):
localhost btrfs-progs-unstable # ./btrfsck -s 1 /dev/sdc1
using SB copy 1, bytenr 67108864
failed to read /dev/sr0
failed to read /dev/sr0
parent transid verify failed on 2206281838592 wanted 2135 found 1545
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
Aborted

(dmesg output)
[ 1825.231434] device label 1TB0 devid 1 transid 2135 /dev/sdf1
[ 1825.235292] device label 1TB0 devid 2 transid 2134 /dev/sde1
[ 1825.238560] device label 1TB0 devid 3 transid 2135 /dev/sdd1
[ 1825.241176] device label 1TB0 devid 4 transid 2135 /dev/sdc1
[ 1825.244681] device label 1TB0 devid 5 transid 2135 /dev/sdb1


gentoo baselayout 2, kernel 2.6.39-r1, btrfs-progs-unstable:cmason git master
branch, 5 disk usb raid-0 array



