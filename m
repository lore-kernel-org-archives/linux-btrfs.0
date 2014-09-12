Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53730 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751220AbaILXjB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 19:39:01 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:60266 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XSaQf-0013Ex-89
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 17:39:01 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] <subvol> doesn't belong to btrfs mount point
Message-Id: <1E99F2EE-0D94-4271-990F-3535BB005A0A@colorremedies.com>
Date: Fri, 12 Sep 2014 17:39:00 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: When a btrfs subvolume is mounted with -o subvol, and a nested ro subvol/snapshot is created, btrfs send returns with an error. If the top level (id 5) is mounted instead, the send command succeeds.

3.17.0-0.rc4.git0.1.fc22.i686
Btrfs v3.16

This may also be happening on x86_64, and this bug suggests the problem is commit de22c28ef31d9721606ba05965a093a8044be0de

https://bugzilla.kernel.org/show_bug.cgi?id=83741



[root@lati ~]# strace btrfs send /root/rpms.ro | btrfs receive /mnt/
execve("/usr/sbin/btrfs", ["btrfs", "send", "/root/rpms.ro"], [/* 26 vars */]) = 0
brk(0)                                  = 0x866a000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7767000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=84972, ...}) = 0
mmap2(NULL, 84972, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7752000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\17\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=19100, ...}) = 0
mmap2(NULL, 20692, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb774c000
mmap2(0xb7750000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0xb7750000
close(3)                                = 0
open("/lib/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320P\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=271276, ...}) = 0
mmap2(NULL, 271832, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7709000
mmap2(0xb7748000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3e000) = 0xb7748000
mmap2(0xb774b000, 1496, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb774b000
close(3)                                = 0
open("/lib/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\3\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pF\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=357384, ...}) = 0
mmap2(NULL, 311456, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76bc000
mmap2(0xb7707000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4b000) = 0xb7707000
close(3)                                = 0
open("/lib/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\30\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=93444, ...}) = 0
mmap2(NULL, 94464, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb76a4000
mmap2(0xb76ba000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0xb76ba000
close(3)                                = 0
open("/lib/liblzo2.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@ \0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=145984, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb76a3000
mmap2(NULL, 147584, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb767e000
mmap2(0xb76a1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x22000) = 0xb76a1000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\3\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320O\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=142932, ...}) = 0
mmap2(NULL, 115404, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7661000
mprotect(0xb7679000, 4096, PROT_NONE)   = 0
mmap2(0xb767a000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18000) = 0xb767a000
mmap2(0xb767c000, 4812, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb767c000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\3\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\200\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=2166836, ...}) = 0
mmap2(NULL, 1933020, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7489000
mmap2(0xb765a000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1d0000) = 0xb765a000
mmap2(0xb765f000, 7900, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb765f000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7488000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7487000
set_thread_area({entry_number:-1, base_addr:0xb7487800, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0 (entry_number:6)
mprotect(0xb765a000, 12288, PROT_READ)  = 0
mprotect(0xb767a000, 4096, PROT_READ)   = 0
mprotect(0xb76a1000, 4096, PROT_READ)   = 0
mprotect(0xb76ba000, 4096, PROT_READ)   = 0
mprotect(0xb7707000, 4096, PROT_READ)   = 0
mprotect(0xb7750000, 4096, PROT_READ)   = 0
mprotect(0xb7748000, 8192, PROT_READ)   = 0
mprotect(0x80c8000, 8192, PROT_READ)    = 0
mprotect(0xb7790000, 4096, PROT_READ)   = 0
munmap(0xb7752000, 84972)               = 0
set_tid_address(0xb7487868)             = 3024
set_robust_list(0xb7487870, 12)         = 0
rt_sigaction(SIGRTMIN, {0xb7665a50, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb7665ad0, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="lati.localdomain", ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0xbfdfdef8) = -1 ENOTTY (Inappropriate ioctl for device)
brk(0)                                  = 0x866a000
brk(0x868c000)                          = 0x868c000
brk(0)                                  = 0x868c000
lstat64("/root", {st_mode=S_IFDIR|0550, st_size=172, ...}) = 0
lstat64("/root/rpms.ro", {st_mode=S_IFDIR|0755, st_size=24834, ...}) = 0
open("/root/rpms.ro", O_RDONLY|O_LARGEFILE|O_NOATIME) = 3
close(3)                                = 0
open("/proc/self/mounts", O_RDONLY|O_CLOEXEC) = 3
futex(0xb765f114, FUTEX_WAKE_PRIVATE, 2147483647) = 0
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7766000
read(3, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
read(3, "memory 0 0\ncgroup /sys/fs/cgroup"..., 1024) = 1024
read(3, "s /run/user/42 tmpfs rw,seclabel"..., 1024) = 405
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0xb7766000, 4096)                = 0
write(2, "ERROR: /root/rpms.ro doesn't bel"..., 57ERROR: /root/rpms.ro doesn't belong to btrfs mount point
) = 57
close(0)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++


Chris Murphy

