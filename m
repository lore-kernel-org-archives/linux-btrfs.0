Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53714 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbaLVOaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 09:30:04 -0500
Received: from [192.168.178.24] ([78.54.131.152]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MId0S-1Y0r4L34rw-002K7a for
 <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 15:30:02 +0100
Message-ID: <54982AE8.2080602@gmx.de>
Date: Mon, 22 Dec 2014 15:30:00 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: fuzz tester: delete/chmod etc won't work due to "No space left on
 device"
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created within a x86 KVM guest at a tmpfs file system under 3.19.0-rc1 a 257 MB file, created within that abtrfs file system and run the fuzzer trinity using that fs for its victim files:

$ mkdir /mnt/ramdisk/btrfs; truncate -s 257M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs"                                                   
SMALL VOLUME: forcing mixed metadata/data groups

WARNING! - Btrfs v3.14.2 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Created a data/metadata chunk of size 8388608
fs created label (null) on /mnt/ramdisk/btrfs.fs
        nodesize 4096 leafsize 4096 sectorsize 4096 size 257.00MiB
Btrfs v3.14.2

$ D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q; echo; echo " done"; echo; sleep 4; done

After a while I got :

$ sudo rm -rf /mnt/ramdisk/btrfs/t3/
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d63’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d10’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f98’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d4’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f7’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f20’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d5’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d84’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f60’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f43’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f42’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f33’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity.log’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity-testfile1’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity-testfile2’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity-testfile3’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity-testfile4’: No space left on device
rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/trinity-child1.log’: No space left on device

$ ls -ld /mnt/ramdisk/btrfs/t3/v1/v2/d63
-r--r-xrwx 1 tfoerste users 0 Dec 22 15:02 /mnt/ramdisk/btrfs/t3/v1/v2/d63

$ chmod a+w /mnt/ramdisk/btrfs/t3/v1/v2/d63
chmod: changing permissions of ‘/mnt/ramdisk/btrfs/t3/v1/v2/d63’: No space left on device

$ chmod u+w /mnt/ramdisk/btrfs/t3/v1/v2/d63
chmod: changing permissions of ‘/mnt/ramdisk/btrfs/t3/v1/v2/d63’: No space left on device

$ sudo chmod u+w /mnt/ramdisk/btrfs/t3/v1/v2/d63
chmod: changing permissions of ‘/mnt/ramdisk/btrfs/t3/v1/v2/d63’: No space left on device

$ uname -a
Linux n22kvm-clone 3.19.0-rc1 #1 SMP Sun Dec 21 18:03:48 CET 2014 i686 Intel Xeon E312xx (Sandy Bridge) GenuineIntel GNU/Linux


In the syslog I found nothing special (and this was already reported :

ec 22 15:00:03 n22kvm-clone kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Dec 22 15:00:03 n22kvm-clone kernel: warning: process `trinity-c1' used the deprecated sysctl system call with
Dec 22 15:00:03 n22kvm-clone kernel: trinity-c0 (2282) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.txt.
Dec 22 15:00:03 n22kvm-clone kernel: VFS: Warning: trinity-c0 using old stat() call. Recompile your binary.
Dec 22 15:00:03 n22kvm-clone kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Dec 22 15:00:03 n22kvm-clone kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Dec 22 15:00:03 n22kvm-clone kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Dec 22 15:00:09 n22kvm-clone kernel: INFO: trying to register non-static key.
Dec 22 15:00:09 n22kvm-clone kernel: the code is fine but needs lockdep annotation.
Dec 22 15:00:09 n22kvm-clone kernel: turning off the locking correctness validator.
Dec 22 15:00:09 n22kvm-clone kernel: CPU: 0 PID: 2316 Comm: trinity-c0 Not tainted 3.19.0-rc1 #1
Dec 22 15:00:09 n22kvm-clone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5.1-0-g8936dbb-20141113_115728-nilsson.home.kraxel.org 04/01/2014
Dec 22 15:00:09 n22kvm-clone kernel:  00000000 00000000 e3541b58 d705b42c d778f1a0 e3541b64 d70584ad d71a56a0
Dec 22 15:00:09 n22kvm-clone kernel:  e3541bdc d6c88475 00000000 f6388e14 e3541ba4 00000282 f6388df4 e3541bb0
Dec 22 15:00:09 n22kvm-clone kernel:  00000282 00000000 00000001 00000282 f88e3d06 f6388e04 00000000 f541b694
Dec 22 15:00:09 n22kvm-clone kernel: Call Trace:
Dec 22 15:00:09 n22kvm-clone kernel:  [<d705b42c>] dump_stack+0x41/0x52
Dec 22 15:00:09 n22kvm-clone kernel:  [<d70584ad>] register_lock_class.part.41+0x32/0x36
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6c88475>] __lock_acquire+0x1465/0x1930
Dec 22 15:00:09 n22kvm-clone kernel:  [<f88e3d06>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d7062c22>] ? _raw_spin_unlock+0x22/0x30
Dec 22 15:00:09 n22kvm-clone kernel:  [<f88e3d06>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f88f3cbf>] ? btrfs_make_block_group+0x1bf/0x290 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6c3f140>] ? native_restore_fl+0x10/0x10
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6c3f120>] ? native_wbinvd+0x10/0x10
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6c889f8>] lock_acquire+0xb8/0x150
Dec 22 15:00:09 n22kvm-clone kernel:  [<f8935736>] ? btrfs_alloc_chunk+0x46/0x50 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f8931cc4>] __btrfs_alloc_chunk+0x624/0xa90 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f8935736>] ? btrfs_alloc_chunk+0x46/0x50 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f8935736>] btrfs_alloc_chunk+0x46/0x50 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f88eabc9>] do_chunk_alloc+0x239/0x420 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d7062c22>] ? _raw_spin_unlock+0x22/0x30
Dec 22 15:00:09 n22kvm-clone kernel:  [<f88ebcee>] btrfs_check_data_free_space+0x13e/0x310 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f8918f93>] __btrfs_buffered_write+0x103/0x560 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<f891d7c5>] btrfs_file_write_iter+0x5b5/0x770 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d57024>] ? do_iter_readv_writev+0x64/0x90
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6c3f140>] ? native_restore_fl+0x10/0x10
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d57024>] do_iter_readv_writev+0x64/0x90
Dec 22 15:00:09 n22kvm-clone kernel:  [<f891d210>] ? btrfs_sync_file+0x350/0x350 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d583a1>] do_readv_writev+0xa1/0x270
Dec 22 15:00:09 n22kvm-clone kernel:  [<f891d210>] ? btrfs_sync_file+0x350/0x350 [btrfs]
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d56ad0>] ? iov_shorten+0x60/0x60
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d737c5>] ? __fdget_pos+0x35/0x40
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6cd0b24>] ? __audit_syscall_entry+0x94/0xe0
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6cd0b24>] ? __audit_syscall_entry+0x94/0xe0
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d58604>] vfs_writev+0x34/0x60
Dec 22 15:00:09 n22kvm-clone kernel:  [<d6d58750>] SyS_writev+0x50/0xd0
Dec 22 15:00:09 n22kvm-clone kernel:  [<d706387d>] syscall_call+0x7/0x7
Dec 22 15:01:32 n22kvm-clone sudo[2604]: pam_unix(sudo:session): session opened for user root by tfoerste(uid=0)


FWIW the self test:

Dec 22 14:59:26 n22kvm-clone kernel: raid6: mmxx1     5246 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: mmxx2     5371 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: sse1x1    4457 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: sse1x2    5468 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: sse2x1    9042 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: sse2x2   11062 MB/s
Dec 22 14:59:26 n22kvm-clone kernel: raid6: using algorithm sse2x2 (11062 MB/s)
Dec 22 14:59:26 n22kvm-clone kernel: raid6: using ssse3x1 recovery algorithm
Dec 22 14:59:26 n22kvm-clone kernel: xor: automatically using best checksumming function:
Dec 22 14:59:26 n22kvm-clone kernel:    avx       : 28520.000 MB/sec
Dec 22 14:59:26 n22kvm-clone kernel: Btrfs loaded
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running btrfs free space cache tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running extent only tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running bitmap only tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running bitmap and extent tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running space stealing from bitmap to extent
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Free space cache tests finished
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running extent buffer operation tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running btrfs_split_item tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running find delalloc tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running btrfs_get_extent tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running hole first btrfs_get_extent test
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Running qgroup tests
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Qgroup basic add
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: selftest: Qgroup multiple refs test
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: device fsid 9e71bb17-7483-4778-8feb-6fd4291a4505 devid 1 transid 4 /dev/loop0
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS info (device loop0): setting 8 feature flag
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS info (device loop0): disk space caching is enabled
Dec 22 14:59:26 n22kvm-clone kernel: BTRFS: creating UUID tree


-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

