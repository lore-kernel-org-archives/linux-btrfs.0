From: Christian Kujau <lists@nerdbynature.de>
Subject: WARNING at fs/btrfs/extent_io.c:3618 write_extent_buffer (sparc64)
Date: Fri, 5 Feb 2010 02:43:01 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1002050233390.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net, a.beregalov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When mounting a newly created btrfs on sparc64, the following warning is 
printed (vanilla 2.6.33-rc6, Feb 03):

[ 1087.724622] ------------[ cut here ]------------
[ 1087.779337] WARNING: at /data/scm/linux-2.6-git/fs/btrfs/extent_io.c:3618 write_extent_buffer+0x140/0x1a0 [btrfs]()
[ 1087.903973] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c nfsd exportfs loop sg sr_mod cdrom
[ 1088.027849] Call Trace:
[ 1088.057125]  [0000000000452d44] warn_slowpath_common+0x44/0x80
[ 1088.126910]  [0000000000452d90] warn_slowpath_null+0x10/0x20
[ 1088.194785]  [00000000101354a0] write_extent_buffer+0x140/0x1a0 [btrfs]
[ 1088.273969]  [000000001013e550] btrfs_read_sys_array+0x50/0x340 [btrfs]
[ 1088.353124]  [00000000101070fc] open_ctree+0xf1c/0x17c0 [btrfs]
[ 1088.423941]  [00000000100dc938] btrfs_get_sb+0x358/0x4a0 [btrfs]
[ 1088.495701]  [00000000004c6e54] vfs_kern_mount+0x34/0xe0
[ 1088.559230]  [00000000004c6f44] do_kern_mount+0x24/0xe0
[ 1088.621737]  [00000000004e02b4] do_mount+0x2b4/0x8c0
[ 1088.681346]  [0000000000502338] compat_sys_mount+0x98/0x280
[ 1088.747812]  [0000000000406114] linux_sparc_syscall32+0x34/0x40
[ 1088.818614] ---[ end trace 19996b4574f21973 ]---


This has been reported[0] in 2008 by Alexander Beregalov and it was 
suggested to set sectorsize to the system's page size. This seems to be 
done anyway but even explicitly setting this during mkfs doesn't make the 
warning go away.

Full dmesg and .config: http://nerdbynature.de/bits/2.6.33-rc6/btrfs/

Thanks,
Christian.

[0] http://www.spinics.net/lists/linux-btrfs/msg01029.html
-- 
BOFH excuse #178:

short leg on process table
