Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51621 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcAAPor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 10:44:47 -0500
MIME-Version: 1.0
Message-ID: <trinity-453ea1bf-27ee-494f-a3a8-c39fd6061a58-1451663085330@3capp-gmx-bs06>
From: "Jan Koester" <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: cannot repair filesystem
Content-Type: text/plain; charset=UTF-8
Date: Fri, 1 Jan 2016 16:44:45 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

if I try to repair filesystem got I'am assert. I use Raid6.

Linux dibsi 3.16.0-0.bpo.4-amd64 #1 SMP Debian 3.16.7-ckt4-3~bpo70+1 (2015-02-12) x86_64 GNU/Linux

root@dibsi:~/btrfs-progs# btrfs fi show
Label: none  uuid: 6a2f3936-d0ef-43c0-9815-41e24f2bc21a
        Total devices 1 FS bytes used 26.63GiB
        devid    1 size 111.70GiB used 49.04GiB path /dev/sdf2

Label: none  uuid: 73d4dc77-6ff3-412f-9b0a-0d11458faf32
        Total devices 5 FS bytes used 1.17TiB
        devid    1 size 931.51GiB used 420.78GiB path /dev/sdb
        devid    2 size 931.51GiB used 420.78GiB path /dev/sdc
        devid    3 size 931.51GiB used 420.78GiB path /dev/sdd
        devid    4 size 931.51GiB used 420.78GiB path /dev/sde
        devid    5 size 931.51GiB used 420.78GiB path /dev/sda

root@dibsi:~/btrfs-progs# btrfs check --repair /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32 
enabling repair mode
parent transid verify failed on 2280450637824 wanted 861168 found 860380
parent transid verify failed on 2280450637824 wanted 861168 found 860380
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
bytenr mismatch, want=2280450637824, have=15938376490240
repair mode will force to clear out log tree, Are you sure? [y/N]: y
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
extent-tree.c:2728: alloc_reserved_tree_block: Assertion `ret` failed.
btrfs[0x4441cc]
btrfs[0x444441]
btrfs(btrfs_alloc_free_block+0x23d)[0x448c1a]
btrfs(__btrfs_cow_block+0x19d)[0x4387d6]
btrfs(btrfs_cow_block+0xec)[0x43922d]
btrfs[0x43e73a]
btrfs(btrfs_commit_transaction+0xec)[0x440408]
btrfs(cmd_check+0x648)[0x428e5e]
btrfs(main+0x155)[0x409e2e]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f0a80093b45]
btrfs[0x4099e9]
root@dibsi:~/btrfs
