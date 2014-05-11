Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56600 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752845AbaEKDiz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 23:38:55 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49871 helo=[192.168.1.120])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WjKb1-003NP2-NW
	for linux-btrfs@vger.kernel.org; Sat, 10 May 2014 21:38:39 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: bug adding device to seed device, btrfs fi show fails
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com>
Date: Sat, 10 May 2014 21:38:18 -0600
Message-Id: <F5A9D7B2-E2C7-4C38-8113-2B0BAFA4422F@colorremedies.com>
References: <29B81ECC-8877-4BBB-9701-1CB5C46717ED@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 10, 2014, at 7:51 PM, Chris Murphy <lists@colorremedies.com> wrote:

> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
> btrfs-progs 3.14
> 
> /dev/sdb2 = existing btrfs fs
> /dev/sdc3 = unformatted partition
> 
> 
> # btrfstune -S1 /dev/sdb2
> # mount /dev/sdb2 /mnt
> mount: /dev/sdb2 is write-protected, mounting read-only
> # btrfs device add /dev/sdc3 /mnt
> Performing full device TRIM (75.90GiB) ...
> # btrfs fi show
> Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
> 	Total devices 1 FS bytes used 7.55GiB
> 	devid    1 size 79.31GiB used 11.04GiB path /dev/sda3
> 
> btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.

The problem only happens when added device sdc3 is mounted at /mnt. Otherwise btrfs fi show works. The following is strace when added device sdc3 is mounted, while mount shows the seed device mounted:

# cat /proc/self/mountinfo
84 58 0:44 / /mnt rw,relatime shared:35 - btrfs /dev/sdb2 rw,seclabel,space_cache


# strace btrfs fi show
execve("/usr/sbin/btrfs", ["btrfs", "fi", "show"], [/* 24 vars */]) = 0
brk(0)                                  = 0x2669000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2c3000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=84288, ...}) = 0
mmap(NULL, 84288, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fae8d2ae000
close(3)                                = 0
open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\25\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19944, ...}) = 0
mmap(NULL, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8ce9c000
mprotect(0x7fae8cea0000, 2093056, PROT_NONE) = 0
mmap(0x7fae8d09f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7fae8d09f000
close(3)                                = 0
open("/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\205\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=260640, ...}) = 0
mmap(NULL, 2353896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8cc5d000
mprotect(0x7fae8cc97000, 2097152, PROT_NONE) = 0
mmap(0x7fae8ce97000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3a000) = 0x7fae8ce97000
mmap(0x7fae8ce9b000, 2792, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fae8ce9b000
close(3)                                = 0
open("/lib64/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20V\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1171192, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2ad000
mmap(NULL, 3178856, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8c954000
mprotect(0x7fae8ca5c000, 2093056, PROT_NONE) = 0
mmap(0x7fae8cc5b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x107000) = 0x7fae8cc5b000
close(3)                                = 0
open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\"\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=89992, ...}) = 0
mmap(NULL, 2183688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8c73e000
mprotect(0x7fae8c753000, 2093056, PROT_NONE) = 0
mmap(0x7fae8c952000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x7fae8c952000
close(3)                                = 0
open("/lib64/liblzo2.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0&\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=134440, ...}) = 0
mmap(NULL, 2228456, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8c51d000
mprotect(0x7fae8c53d000, 2093056, PROT_NONE) = 0
mmap(0x7fae8c73c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f000) = 0x7fae8c73c000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200`\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=145568, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2ac000
mmap(NULL, 2213072, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8c300000
mprotect(0x7fae8c317000, 2097152, PROT_NONE) = 0
mmap(0x7fae8c517000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7fae8c517000
mmap(0x7fae8c519000, 13520, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fae8c519000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\1\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2125464, ...}) = 0
mmap(NULL, 3956544, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fae8bf3a000
mprotect(0x7fae8c0f6000, 2097152, PROT_NONE) = 0
mmap(0x7fae8c2f6000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bc000) = 0x7fae8c2f6000
mmap(0x7fae8c2fc000, 16192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fae8c2fc000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2ab000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2a9000
arch_prctl(ARCH_SET_FS, 0x7fae8d2a9880) = 0
mprotect(0x7fae8c2f6000, 16384, PROT_READ) = 0
mprotect(0x7fae8c517000, 4096, PROT_READ) = 0
mprotect(0x7fae8c73c000, 4096, PROT_READ) = 0
mprotect(0x7fae8c952000, 4096, PROT_READ) = 0
mprotect(0x7fae8cc5b000, 4096, PROT_READ) = 0
mprotect(0x7fae8d09f000, 4096, PROT_READ) = 0
mprotect(0x7fae8ce97000, 12288, PROT_READ) = 0
mprotect(0x666000, 12288, PROT_READ)    = 0
mprotect(0x7fae8d2c4000, 4096, PROT_READ) = 0
munmap(0x7fae8d2ae000, 84288)           = 0
set_tid_address(0x7fae8d2a9b50)         = 1111
set_robust_list(0x7fae8d2a9b60, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7fae8c305b60, [], SA_RESTORER|SA_SIGINFO, 0x7fae8c30f970}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7fae8c305bf0, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7fae8c30f970}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
brk(0)                                  = 0x2669000
brk(0x268a000)                          = 0x268a000
brk(0)                                  = 0x268a000
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
futex(0x7fae8c2fd368, FUTEX_WAKE_PRIVATE, 2147483647) = 0
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2c2000
read(3, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
read(3, "cpuacct 0 0\ncgroup /sys/fs/cgrou"..., 1024) = 1024
stat("/", {st_mode=S_IFDIR|0755, st_size=132, ...}) = 0
stat("/", {st_mode=S_IFDIR|0755, st_size=132, ...}) = 0
openat(AT_FDCWD, "/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
ioctl(4, BTRFS_IOC_FS_INFO, 0x7fff21622990) = 0
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722a0) = -1 ENODEV (No such device)
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722a0) = 0
close(4)                                = 0
open("/", O_RDONLY|O_NOATIME)           = 4
ioctl(4, BTRFS_IOC_GET_FSLABEL, 0x7fff21622800) = 0
close(4)                                = 0
open("/", O_RDONLY)                     = 4
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a260) = 0
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a280) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2c1000
write(1, "Label: 'rawhide'  uuid: d372e5d1"..., 61Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
) = 61
write(1, "\tTotal devices 1 FS bytes used 7"..., 39	Total devices 1 FS bytes used 7.55GiB
) = 39
open("/dev/sda3", O_RDONLY)             = 5
close(5)                                = 0
write(1, "\tdevid    1 size 79.31GiB used 1"..., 55	devid    1 size 79.31GiB used 11.04GiB path /dev/sda3
) = 55
write(1, "\n", 1
)                       = 1
close(4)                                = 0
read(3, " rw,relatime 0 0\ntmpfs /tmp tmpf"..., 1024) = 574
stat("/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
stat("/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
openat(AT_FDCWD, "/home", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
ioctl(4, BTRFS_IOC_FS_INFO, 0x7fff21622990) = 0
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = -1 ENODEV (No such device)
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = 0
close(4)                                = 0
open("/home", O_RDONLY|O_NOATIME)       = 4
ioctl(4, BTRFS_IOC_GET_FSLABEL, 0x7fff21622800) = 0
close(4)                                = 0
open("/home", O_RDONLY)                 = 4
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a280) = 0
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a2a0) = 0
close(4)                                = 0
stat("/var", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
stat("/var", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
openat(AT_FDCWD, "/var", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
ioctl(4, BTRFS_IOC_FS_INFO, 0x7fff21622990) = 0
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = -1 ENODEV (No such device)
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = 0
close(4)                                = 0
open("/var", O_RDONLY|O_NOATIME)        = 4
ioctl(4, BTRFS_IOC_GET_FSLABEL, 0x7fff21622800) = 0
close(4)                                = 0
open("/var", O_RDONLY)                  = 4
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a280) = 0
ioctl(4, BTRFS_IOC_SPACE_INFO, 0x266a2a0) = 0
close(4)                                = 0
stat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
stat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
openat(AT_FDCWD, "/mnt", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
ioctl(4, BTRFS_IOC_FS_INFO, 0x7fff21622990) = 0
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = -1 ENODEV (No such device)
ioctl(4, BTRFS_IOC_DEV_INFO, 0x26722c0) = 0
write(2, "btrfs: utils.c:1769: get_fs_info"..., 87btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.
) = 87
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fae8d2c0000
rt_sigprocmask(SIG_UNBLOCK, [ABRT], NULL, 8) = 0
tgkill(1111, 1111, SIGABRT)             = 0
--- SIGABRT {si_signo=SIGABRT, si_code=SI_TKILL, si_pid=1111, si_uid=0} ---
+++ killed by SIGABRT (core dumped) +++
Aborted (core dumped)