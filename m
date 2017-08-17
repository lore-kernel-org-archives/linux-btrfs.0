Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:38573 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbdHQSnk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 14:43:40 -0400
Received: by mail-ua0-f173.google.com with SMTP id y36so28254730uac.5
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 11:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
References: <20170814225740.GK19638@pontus.sran> <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 17 Aug 2017 12:43:38 -0600
Message-ID: <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Piotr Szymaniak <szarpaj@grubelek.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs sub create test1
Create subvolume './test1'
# btrfs sub create test1/test2
Create subvolume 'test1/test2'
# btrfs sub snap test1 test1.snap
Create a snapshot of 'test1' in './test1.snap'
# btrfs fi du -s test1
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B       0.00B  test1
# btrfs fi du -s test1.snap
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device
#


Pretty strace here:
https://pastebin.com/raw/ibnha9Sx


Ugly MUA strace here for the archive:


# strace btrfs fi du -s test1.snap
execve("/sbin/btrfs", ["btrfs", "fi", "du", "-s", "test1.snap"],
0x7fff8c0af970 /* 32 vars */) = 0
brk(NULL)                               = 0xa96a201000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f84880a4000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=104181, ...}) = 0
mmap(NULL, 104181, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f848808a000
close(3)                                = 0
open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\23\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19568, ...}) = 0
mmap(NULL, 2113552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f8487c7b000
mprotect(0x7f8487c7f000, 2093056, PROT_NONE) = 0
mmap(0x7f8487e7e000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f8487e7e000
mmap(0x7f8487e7f000, 16, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8487e7f000
close(3)                                = 0
open("/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\227\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=304792, ...}) = 0
mmap(NULL, 2397952, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f8487a31000
mprotect(0x7f8487a75000, 2093056, PROT_NONE) = 0
mmap(0x7f8487c74000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x43000) = 0x7f8487c74000
mmap(0x7f8487c7a000, 1792, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8487c7a000
close(3)                                = 0
open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\"\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=94104, ...}) = 0
mmap(NULL, 2187272, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f848781a000
mprotect(0x7f8487830000, 2093056, PROT_NONE) = 0
mmap(0x7f8487a2f000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0x7f8487a2f000
mmap(0x7f8487a30000, 8, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8487a30000
close(3)                                = 0
open("/lib64/liblzo2.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320$\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=138800, ...}) = 0
mmap(NULL, 2232328, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f84875f8000
mprotect(0x7f8487619000, 2093056, PROT_NONE) = 0
mmap(0x7f8487818000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7f8487818000
mmap(0x7f8487819000, 8, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f8487819000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340^\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=153896, ...}) = 0
mmap(NULL, 2220552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f84873d9000
mprotect(0x7f84873f2000, 2097152, PROT_NONE) = 0
mmap(0x7f84875f2000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19000) = 0x7f84875f2000
mmap(0x7f84875f4000, 12808, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f84875f4000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\5\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2163104, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f8488088000
mmap(NULL, 4000096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f8487008000
mprotect(0x7f84871cf000, 2097152, PROT_NONE) = 0
mmap(0x7f84873cf000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c7000) = 0x7f84873cf000
mmap(0x7f84873d5000, 14688, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f84873d5000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f8488085000
arch_prctl(ARCH_SET_FS, 0x7f84880858c0) = 0
mprotect(0x7f84873cf000, 16384, PROT_READ) = 0
mprotect(0x7f84875f2000, 4096, PROT_READ) = 0
mprotect(0x7f8487818000, 4096, PROT_READ) = 0
mprotect(0x7f8487a2f000, 4096, PROT_READ) = 0
mprotect(0x7f8487e7e000, 4096, PROT_READ) = 0
mprotect(0x7f8487c74000, 20480, PROT_READ) = 0
mprotect(0xa968435000, 20480, PROT_READ) = 0
mprotect(0x7f84880a6000, 4096, PROT_READ) = 0
munmap(0x7f848808a000, 104181)          = 0
set_tid_address(0x7f8488085b90)         = 13929
set_robust_list(0x7f8488085ba0, 24)     = 0
rt_sigaction(SIGRTMIN, {sa_handler=0x7f84873de960, sa_mask=[],
sa_flags=SA_RESTORER|SA_SIGINFO, sa_restorer=0x7f84873eb2c0}, NULL, 8)
= 0
rt_sigaction(SIGRT_1, {sa_handler=0x7f84873dea00, sa_mask=[],
sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO,
sa_restorer=0x7f84873eb2c0}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024,
rlim_max=RLIM64_INFINITY}) = 0
uname({sysname="Linux", nodename="f26h.localdomain", ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
brk(NULL)                               = 0xa96a201000
brk(0xa96a222000)                       = 0xa96a222000
brk(NULL)                               = 0xa96a222000
write(1, "     Total   Exclusive  Set shar"..., 45     Total
Exclusive  Set shared  Filename
) = 45
newfstatat(AT_FDCWD, "test1.snap", {st_mode=S_IFDIR|0755, st_size=10,
...}, 0) = 0
stat("test1.snap", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
open("test1.snap", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
ioctl(3, BTRFS_IOC_INO_LOOKUP, {treeid=0, objectid=256 /*
BTRFS_FIRST_FREE_OBJECTID */} => {treeid=486, name=""}) = 0
getdents(3, /* 3 entries */, 32768)     = 80
newfstatat(3, "test2", {st_mode=S_IFDIR|0755, st_size=0, ...}, 0) = 0
stat("test1.snap/test2", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
open("test1.snap/test2", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
ioctl(4, BTRFS_IOC_INO_LOOKUP, {treeid=0, objectid=256 /*
BTRFS_FIRST_FREE_OBJECTID */}) = -1 ENOTTY (Inappropriate ioctl for
device)
close(4)                                = 0
getdents(3, /* 0 entries */, 32768)     = 0
close(3)                                = 0
write(2, "ERROR: ", 7ERROR: )                  = 7
write(2, "cannot check space of 'test1.sna"..., 66cannot check space
of 'test1.snap': Inappropriate ioctl for device) = 66
write(2, "\n", 1
)                       = 1
exit_group(1)                           = ?
+++ exited with 1 +++
#


# uname -r
4.13.0-0.rc4.git1.1.fc27.x86_64
# rpm -q btrfs-progs
btrfs-progs-4.12-1.fc27.x86_64


----
Chris Murphy
