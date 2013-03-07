Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49819 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3CGPV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 10:21:56 -0500
Message-ID: <5138B08F.70607@petaramesh.org>
Date: Thu, 07 Mar 2013 16:21:51 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>, Anand.Jain@oracle.com
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org> <5138980C.8080000@redhat.com> <5138ADA6.5070101@petaramesh.org> <5138AE96.3020304@redhat.com>
In-Reply-To: <5138AE96.3020304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/03/2013 16:13, Eric Sandeen a écrit :
> # strace -o tracefile.txt mkfs.btrfs /dev/sda5 tracefile.txt will
> contain all syscalls made by the binary and their results, which might
> give us a clue what's gone wrong. -Eric

Here it goes !

execve("/sbin/mkfs.btrfs", ["mkfs.btrfs", "/dev/sda5"], [/* 28 vars */]) = 0
brk(0)                                  = 0x9ee6000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb76f0000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=48297, ...}) = 0
mmap2(NULL, 48297, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb76e4000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\16\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=11888, ...}) = 0
mmap2(NULL, 14712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
= 0xb76e0000
mmap2(0xb76e3000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb76e3000
close(3)                                = 0
open("/lib/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@D\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=202934, ...}) = 0
mmap2(NULL, 176256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb76b4000
mmap2(0xb76de000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x29) = 0xb76de000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\227\1\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1769964, ...}) = 0
mmap2(NULL, 1571356, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7534000
mmap2(0xb76ae000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x179) = 0xb76ae000
mmap2(0xb76b1000, 10780, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb76b1000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7533000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7532000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7532700,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb76ae000, 8192, PROT_READ)   = 0
mprotect(0xb76de000, 4096, PROT_READ)   = 0
mprotect(0xb7712000, 4096, PROT_READ)   = 0
munmap(0xb76e4000, 48297)               = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb76ef000
write(1, "\n", 1)                       = 1
write(1, "WARNING! - Btrfs v0.20-rc1 IS EX"..., 43) = 43
write(1, "WARNING! - see http://btrfs.wiki"..., 57) = 57
write(1, "\n", 1)                       = 1
open("/dev/sda5", O_RDONLY|O_LARGEFILE) = 3
brk(0)                                  = 0x9ee6000
brk(0x9f08000)                          = 0x9f08000
pread64(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread64(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread64(3, "", 3531, 274877906944)      = 0
brk(0x9f07000)                          = 0x9f07000
open("/proc/mounts", O_RDONLY|O_CLOEXEC) = 4
fstat64(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb76ee000
read(4, "rootfs / rootfs rw 0 0\nproc /pro"..., 1024) = 480
stat64("rootfs", 0xbff5b970)            = -1 ENOENT (No such file or
directory)
stat64("proc", 0xbff5b970)              = -1 ENOENT (No such file or
directory)
stat64("sysfs", 0xbff5b970)             = -1 ENOENT (No such file or
directory)
stat64("devtmpfs", 0xbff5b970)          = -1 ENOENT (No such file or
directory)
stat64("tmpfs", 0xbff5b970)             = -1 ENOENT (No such file or
directory)
stat64("devpts", 0xbff5b970)            = -1 ENOENT (No such file or
directory)
stat64("fusectl", 0xbff5b970)           = -1 ENOENT (No such file or
directory)
stat64("/dev/loop2", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 2), ...}) = 0
stat64("/dev/sda5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
stat64("/dev/loop2", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 2), ...}) = 0
open("/dev/loop2", O_RDONLY|O_LARGEFILE) = 5
ioctl(5, 0x4c03, 0xbff59904)            = 0
close(5)                                = 0
lstat64("/dev", {st_mode=S_IFDIR|0755, st_size=10060, ...}) = 0
lstat64("/dev/sda5", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 5), ...}) = 0
lstat64("/sqfs_disk", 0xbff57820)       = -1 ENOENT (No such file or
directory)
close(4)                                = 0
munmap(0xb76ee000, 4096)                = 0
close(3)                                = 0
write(2, "error checking /dev/sda5 mount s"..., 38) = 38
exit_group(1)                           = ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

