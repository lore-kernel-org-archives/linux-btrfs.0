Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33279 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcGNK3j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 06:29:39 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CADxRZqx-NJNpkA2hWeEuw_uMBB=oajUmTgMizdd2g5Ti9Cn1GQ@mail.gmail.com>
References: <CADxRZqx-NJNpkA2hWeEuw_uMBB=oajUmTgMizdd2g5Ti9Cn1GQ@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 14 Jul 2016 11:29:37 +0100
Message-ID: <CAL3q7H5s_h4x6_=cUY+5VL6vG_riF9j9MuPxH032QmBFa6WU-g@mail.gmail.com>
Subject: Re: btrfs on sparc64 results in kernel stack trace in 1 minute test
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Omar Sandoval <osandov@fb.com>,
        debian-sparc <debian-sparc@lists.debian.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2016 at 11:08 AM, Anatoly Pugachev <matorola@gmail.com> wrote:
> Hi!
>
> I'm using git (describe, v4.7-rc7-16-gcf875cc) kernel,
> with patch "fix extent buffer bitmap tests on big-endian systems", see
> [1] (to be able to load/use btrfs module)
>
> and getting brtfs filesystem going to read only mode as well getting
> kernel stack trace in 1 minute after started to copying files to fs.
>
> Here's my steps to reproduce:
>
> create a ramdisk and file on it
>
> root@nvg5120:# mount -t tmpfs tmpfs -o size=8G /ramdisk
> root@nvg5120:# dd if=/dev/zero of=/ramdisk/disk0 bs=1M count=7000
>
> create btrfs filesystem
>
> root@nvg5120:/home/mator/btrfs-progs# ./mkfs.btrfs /ramdisk/disk0
> btrfs-progs v4.6.1
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               81500fe0-da01-44dd-8fa6-d43646dd4916
> Node size:          16384
> Sector size:        8192
> Filesystem size:    6.84GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP             358.00MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     6.84GiB  /ramdisk/disk0
>
>
> mount it and start to copy files:
>
> root@nvg5120:/home/mator/btrfs-progs# mount /ramdisk/disk0 /mnt
> root@nvg5120:/home/mator/btrfs-progs# mkdir /mnt/1
> root@nvg5120:/home/mator/btrfs-progs# chown mator /mnt/1
>
> mator@nvg5120:~$ cnt=0; while true; do let cnt++; echo -n "$cnt ";
> date; sleep 2; rm -rf /mnt/1/testdir; rsync -a debian-installer
> linux-2.6 gcc-6.1.0 v7.4.1a /mnt/1/testdir;  [ $? != 0 ] && break;
> done; date
> 1 Thu Jul 14 12:37:39 MSK 2016
> rsync: rename "/mnt/1/testdir/gcc-6.1.0/gcc/testsuite/g++.dg/cpp0x/.variadic13.C.g2qPwQ"
> -> "gcc-6.1.0/gcc/testsuite/g++.dg/cpp0x/variadic13.C": No such file
> or directory (2)
> ...
> rsync: mkstemp "/mnt/1/testdir/gcc-6.1.0/gcc/testsuite/g++.dg/torture/.pr33134.C.Y2O2ac"
> failed: Read-only file system (30)
> rsync error: received SIGINT, SIGTERM, or SIGHUP (code 20) at
> io.c(504) [generator=3.1.1]
> rsync: [generator] write error: Broken pipe (32)
> Thu Jul 14 12:38:37 MSK 2016
>
>
> root@nvg5120:/home/mator/btrfs-progs# journalctl -k -f
> -- Logs begin at Mon 2016-04-18 15:59:04 MSK. --
> Jul 14 12:37:29 nvg5120 kernel: loop: module loaded
> Jul 14 12:37:30 nvg5120 kernel: BTRFS: device fsid
> 81500fe0-da01-44dd-8fa6-d43646dd4916 devid 1 transid 5 /dev/loop0
> Jul 14 12:37:30 nvg5120 kernel: BTRFS info (device loop0): disk space
> caching is enabled
> Jul 14 12:37:30 nvg5120 kernel: BTRFS info (device loop0): has skinny extents
> Jul 14 12:37:30 nvg5120 kernel: BTRFS info (device loop0): flagging fs
> with big metadata feature
> Jul 14 12:37:30 nvg5120 kernel: BTRFS info (device loop0): creating UUID tree
> Jul 14 12:38:32 nvg5120 kernel: ------------[ cut here ]------------
> Jul 14 12:38:32 nvg5120 kernel: WARNING: CPU: 12 PID: 11815 at
> fs/btrfs/inode.c:9832 btrfs_rename2+0x300/0x1300 [btrfs]
> Jul 14 12:38:32 nvg5120 kernel: BTRFS: Transaction aborted (error -2)
> Jul 14 12:38:33 nvg5120 kernel: Modules linked in: loop btrfs sg
> n2_rng rng_core n2_crypto flash sha256_generic des_generic autofs4
> ext4 crc16 jbd2 mbcache zlib_deflate raid10 raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
> crc32c_generic raid0 multipath linear dm_mod raid1 md_mod sd_mod
> mptsas scsi_transport_sas mptscsih scsi_mod mptbase e1000e ptp
> pps_core [last unloaded: btrfs]
> Jul 14 12:38:33 nvg5120 kernel: CPU: 12 PID: 11815 Comm: rsync
> Tainted: G        W       4.7.0-rc7+ #45
> Jul 14 12:38:33 nvg5120 kernel: Call Trace:
> Jul 14 12:38:33 nvg5120 kernel:  [00000000004671c0] __warn+0xc0/0xe0
> Jul 14 12:38:33 nvg5120 kernel:  [0000000000467214] warn_slowpath_fmt+0x34/0x60
> Jul 14 12:38:33 nvg5120 kernel:  [0000000011a8c340]
> btrfs_rename2+0x300/0x1300 [btrfs]
> Jul 14 12:38:33 nvg5120 kernel:  [00000000005e38f0] vfs_rename+0x630/0x980
> Jul 14 12:38:33 nvg5120 kernel:  [00000000005e9404] SyS_renameat2+0x484/0x500
> Jul 14 12:38:33 nvg5120 kernel:  [00000000005e94dc] SyS_rename+0x1c/0x40
> Jul 14 12:38:33 nvg5120 kernel:  [00000000004061f4]
> linux_sparc_syscall+0x34/0x44
> Jul 14 12:38:33 nvg5120 kernel: ---[ end trace 92caaac5f44fc009 ]---
> Jul 14 12:38:34 nvg5120 kernel: BTRFS: error (device loop0) in
> btrfs_rename:9832: errno=-2 No such entry
> Jul 14 12:38:34 nvg5120 kernel: BTRFS info (device loop0): forced readonly

We've seen this happening on arm64 as well, and it's currently being
investigated.
Thanks for the report.

>
> Thanks.
>
> PS:  I can provide machine access to debug this issue (as well access
> to serial management console, if it hangs).
>
> 1. http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg55792.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
