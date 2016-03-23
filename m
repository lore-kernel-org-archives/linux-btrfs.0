Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34362 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbcCWB5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 21:57:03 -0400
Received: by mail-io0-f175.google.com with SMTP id m184so9822222iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 18:57:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 19:57:01 -0600
Message-ID: <CAJCQCtRfc+vG5kP8s=BNw44+HTQYKXTC7w5Lwsx98D1+3_kPMw@mail.gmail.com>
Subject: reflink copy 'invalid argument'
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel is 4.5.0

The source is on one subvolume, destination on another subvolume, the
full path from top-level id5 is being used for the copy. I've not
previously seen this error before so I'm not sure what's going on. The
suspicious part to me in the strace is this line:

ioctl(4, BTRFS_IOC_CLONE, 0x3)          = -1 EINVAL (Invalid argument)

?

I don't think this is kernel version related, because I've been using
4.5.0 since release and I've done such reflink copies before. But I'm
not thinking how this is user error.


[root@f23m images]# mount | grep sda
/dev/sda5 on / type btrfs
(rw,noatime,seclabel,ssd,space_cache,subvolid=288,subvol=/f23w-root)
/dev/sda5 on /home type btrfs
(rw,noatime,seclabel,ssd,space_cache,subvolid=289,subvol=/home)
/dev/sda5 on /mnt type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=5,subvol=/)


[root@f23m images]# strace cp --reflink
/mnt/home/chris/Downloads/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2
/mnt/f23w-root/var/lib/libvirt/images/
execve("/bin/cp", ["cp", "--reflink",
"/mnt/home/chris/Downloads/Fedora"...,
"/mnt/f23w-root/var/lib/libvirt/i"...], [/* 31 vars */]) = 0
brk(NULL)                               = 0x5559e3d18000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5ce000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=88066, ...}) = 0
mmap(NULL, 88066, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f37bc5b8000
close(3)                                = 0
open("/lib64/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260b\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=136600, ...}) = 0
mmap(NULL, 2237248, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bc18c000
mprotect(0x7f37bc1ab000, 2097152, PROT_NONE) = 0
mmap(0x7f37bc3ab000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f000) = 0x7f37bc3ab000
mmap(0x7f37bc3ad000, 4928, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f37bc3ad000
close(3)                                = 0
open("/lib64/libacl.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\37\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=35992, ...}) = 0
mmap(NULL, 2130048, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bbf83000
mprotect(0x7f37bbf8b000, 2093056, PROT_NONE) = 0
mmap(0x7f37bc18a000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7000) = 0x7f37bc18a000
close(3)                                = 0
open("/lib64/libattr.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\23\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=23320, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5b7000
mmap(NULL, 2117648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bbd7d000
mprotect(0x7f37bbd81000, 2097152, PROT_NONE) = 0
mmap(0x7f37bbf81000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4000) = 0x7f37bbf81000
mmap(0x7f37bbf82000, 16, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f37bbf82000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\6\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2103656, ...}) = 0
mmap(NULL, 3934784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bb9bc000
mprotect(0x7f37bbb73000, 2097152, PROT_NONE) = 0
mmap(0x7f37bbd73000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b7000) = 0x7f37bbd73000
mmap(0x7f37bbd79000, 14912, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f37bbd79000
close(3)                                = 0
open("/lib64/libpcre.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\26\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=459248, ...}) = 0
mmap(NULL, 2552072, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bb74c000
mprotect(0x7f37bb7bb000, 2093056, PROT_NONE) = 0
mmap(0x7f37bb9ba000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6e000) = 0x7f37bb9ba000
close(3)                                = 0
open("/lib64/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\16\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19776, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5b6000
mmap(NULL, 2109712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bb548000
mprotect(0x7f37bb54b000, 2093056, PROT_NONE) = 0
mmap(0x7f37bb74a000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f37bb74a000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260`\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=149496, ...}) = 0
mmap(NULL, 2213040, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f37bb32b000
mprotect(0x7f37bb343000, 2093056, PROT_NONE) = 0
mmap(0x7f37bb542000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f37bb542000
mmap(0x7f37bb544000, 13488, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f37bb544000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5b5000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5b3000
arch_prctl(ARCH_SET_FS, 0x7f37bc5b3800) = 0
mprotect(0x7f37bbd73000, 16384, PROT_READ) = 0
mprotect(0x7f37bb542000, 4096, PROT_READ) = 0
mprotect(0x7f37bb74a000, 4096, PROT_READ) = 0
mprotect(0x7f37bb9ba000, 4096, PROT_READ) = 0
mprotect(0x7f37bbf81000, 4096, PROT_READ) = 0
mprotect(0x7f37bc18a000, 4096, PROT_READ) = 0
mprotect(0x7f37bc3ab000, 4096, PROT_READ) = 0
mprotect(0x5559e2fa8000, 4096, PROT_READ) = 0
mprotect(0x7f37bc5cf000, 4096, PROT_READ) = 0
munmap(0x7f37bc5b8000, 88066)           = 0
set_tid_address(0x7f37bc5b3ad0)         = 6625
set_robust_list(0x7f37bc5b3ae0, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7f37bb330b50, [], SA_RESTORER|SA_SIGINFO,
0x7f37bb33b9f0}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7f37bb330be0, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f37bb33b9f0}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
statfs("/sys/fs/selinux", {f_type="SELINUX_MAGIC", f_bsize=4096,
f_blocks=0, f_bfree=0, f_bavail=0, f_files=0, f_ffree=0, f_fsid={0,
0}, f_namelen=255, f_frsize=4096, f_flags=4128}) = 0
statfs("/sys/fs/selinux", {f_type="SELINUX_MAGIC", f_bsize=4096,
f_blocks=0, f_bfree=0, f_bavail=0, f_files=0, f_ffree=0, f_fsid={0,
0}, f_namelen=255, f_frsize=4096, f_flags=4128}) = 0
brk(NULL)                               = 0x5559e3d18000
brk(0x5559e3d39000)                     = 0x5559e3d39000
access("/etc/selinux/config", F_OK)     = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=111950656, ...}) = 0
mmap(NULL, 111950656, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f37b4867000
close(3)                                = 0
geteuid()                               = 0
stat("/mnt/f23w-root/var/lib/libvirt/images/", {st_mode=S_IFDIR|0711,
st_size=0, ...}) = 0
stat("/mnt/home/chris/Downloads/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2",
{st_mode=S_IFREG|0664, st_size=216596480, ...}) = 0
stat("/mnt/f23w-root/var/lib/libvirt/images/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2",
0x7ffd1d805750) = -1 ENOENT (No such file or directory)
open("/mnt/home/chris/Downloads/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2",
O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0664, st_size=216596480, ...}) = 0
open("/mnt/f23w-root/var/lib/libvirt/images/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2",
O_WRONLY|O_CREAT|O_EXCL, 0664) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
ioctl(4, BTRFS_IOC_CLONE, 0x3)          = -1 EINVAL (Invalid argument)
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 5
fstat(5, {st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f37bc5cd000
read(5, "# Locale name alias data base.\n#"..., 4096) = 2997
read(5, "", 4096)                       = 0
close(5)                                = 0
munmap(0x7f37bc5cd000, 4096)            = 0
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/coreutils.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/lib64/charset.alias", O_RDONLY|O_NOFOLLOW) = -1 ENOENT (No
such file or directory)
write(2, "cp: ", 4cp: )                     = 4
write(2, "failed to clone \342\200\230/mnt/f23w-roo"..., 180failed to
clone ‘/mnt/f23w-root/var/lib/libvirt/images/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2’
from ‘/mnt/home/chris/Downloads/Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2’)
= 180
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT
(No such file or directory)
write(2, ": Invalid argument", 18: Invalid argument)      = 18
write(2, "\n", 1
)                       = 1
close(4)                                = 0
close(3)                                = 0
lseek(0, 0, SEEK_CUR)                   = -1 ESPIPE (Illegal seek)
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++


conversely, relative command within subvolume works OK
ls -l
total 211520
-rw-rw-r--. 1 chris chris 216596480 Mar 22 19:22
Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2
[chris@f23m Downloads]$ cp --reflink
Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2 copy2
[chris@f23m Downloads]$ ls -l
total 423040
-rw-rw-r--. 1 chris chris 216596480 Mar 22 19:56 copy2
-rw-rw-r--. 1 chris chris 216596480 Mar 22 19:22
Fedora-Cloud-Base-24_Alpha-7.x86_64.qcow2


-- 
Chris Murphy
