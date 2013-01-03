Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout02.t-online.de ([194.25.134.17]:46843 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3ACUgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 15:36:05 -0500
Date: 03 Jan 2013 21:28:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8jEAMeCXB@helmut.hullen.de>
In-Reply-To: <1CC7957D-2FAD-4E8D-9850-6A06458FF1ED@colorremedies.com>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_CO800STPCXssuyMkra2IiTYpST4O7m1yayFe$KsN1xPC+nk69JNahka"
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=_CO800STPCXssuyMkra2IiTYpST4O7m1yayFe$KsN1xPC+nk69JNahka
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hallo, Chris,

Du meintest am 03.01.13:

> So 'btrfs fi label' relabeling with an unmounted system changes the
> file system label metadata on all member devices, according to btrfs
> fi label. Now when I use file:

On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)

        btrfs fi label /dev/sdb mylabel

only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc" and  
"/dev/sdd" remain without label.


> # file -s /dev/sdb
> /dev/sdb: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize
> 4096, leafsize 4096)
> # file -s /dev/sdc
> /dev/sdc: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize
> 4096, leafsize 4096)

> Again it correctly reports the label, even though I had only changed
> the label on sdc (which actually is improper language, I changed the
> label on the file system implied by device sdc which also extends to
> device sdb).

Strange.
Actually the btrfs system is mounted and has to run a job with needs  
about 5 days - I may not stop it.

But before the first mounting of the system only "/dev/sdb" showed the  
label. Maybe with the first mounting the label spreads over all disks.


>
> And then for blkid:

> # blkid
> /dev/sdb: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
> UUID_SUB="a5bbaa83-6d6f-45dc-9804-9442350c3bc9" TYPE="btrfs"
> /dev/sdc: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
> UUID_SUB="01e0bc77-cfdf-4bd7-bfd3-05e14affa66a" TYPE="btrfs"

Strange - in another way.

Here "blkid" (without any device) hangs. See the attachment ("strace  
blkid").

Viele Gruesse!
Helmut

--=_CO800STPCXssuyMkra2IiTYpST4O7m1yayFe$KsN1xPC+nk69JNahka
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=blkid-trace.log;
 modification-date="Thu, 3 Jan 2013 21:27:43 +0100";
 creation-date="Thu, 3 Jan 2013 21:27:43 +0100";
 read-date="Thu, 3 Jan 2013 21:27:43 +0100"

execve("/sbin/blkid", ["blkid"], [/* 47 vars */]) = 0
brk(0)                                  = 0x8050000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40024000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=55572, ...}) = 0
mmap2(NULL, 55572, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40025000
close(3)                                = 0
open("/lib/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0A\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=163440, ...}) = 0
mmap2(NULL, 162160, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x40033000
mmap2(0x40059000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x26) = 0x40059000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\16\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=13244, ...}) = 0
mmap2(NULL, 16004, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4005b000
mmap2(0x4005e000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0x4005e000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\227\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1790836, ...}) = 0
mmap2(NULL, 1591836, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4005f000
mprotect(0x401dd000, 4096, PROT_NONE)   = 0
mmap2(0x401de000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17e) = 0x401de000
mmap2(0x401e1000, 10780, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x401e1000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x401e4000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x401e5000
set_thread_area({entry_number:-1 -> 6, base_addr:0x401e4bc0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0x401de000, 8192, PROT_READ)   = 0
mprotect(0x40021000, 4096, PROT_READ)   = 0
munmap(0x40025000, 55572)               = 0
brk(0)                                  = 0x8050000
brk(0x8071000)                          = 0x8071000
getuid32()                              = 0
geteuid32()                             = 0
getgid32()                              = 0
getegid32()                             = 0
prctl(PR_GET_DUMPABLE)                  = 1
getuid32()                              = 0
geteuid32()                             = 0
getgid32()                              = 0
getegid32()                             = 0
prctl(PR_GET_DUMPABLE)                  = 1
open("/etc/blkid.conf", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/run/blkid/blkid.tab", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=1212, ...}) = 0
fcntl64(3, F_GETFL)                     = 0x8000 (flags O_RDONLY|O_LARGEFILE)
fstat64(3, {st_mode=S_IFREG|0644, st_size=1212, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40025000
_llseek(3, 0, [0], SEEK_CUR)            = 0
read(3, "<device DEVNO=\"0x0801\" TIME=\"135"..., 4096) = 1212
access("/dev/sda1", F_OK)               = 0
access("/dev/sda2", F_OK)               = 0
access("/dev/sda3", F_OK)               = 0
access("/dev/sda4", F_OK)               = 0
access("/dev/sdb5", F_OK)               = 0
access("/dev/sdb", F_OK)                = 0
access("/dev/sdc", F_OK)                = 0
access("/dev/sdd", F_OK)                = 0
read(3, "", 4096)                       = 0
_llseek(3, 1212, [1212], SEEK_SET)      = 0
close(3)                                = 0
munmap(0x40025000, 4096)                = 0
open("/run/blkid/blkid.tab", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=1212, ...}) = 0
close(3)                                = 0
open("/proc/evms/volumes", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/lvm/VGs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/dev", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
getdents64(3, /* 1115 entries */, 32768) = 32744
getdents64(3, /* 666 entries */, 32768) = 21160
getdents64(3, /* 0 entries */, 32768)   = 0
close(3)                                = 0
openat(AT_FDCWD, "/devfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/devices", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/proc/partitions", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40025000
read(3, "major minor  #blocks  name\n\n   2"..., 1024) = 412
stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
access("/dev/fd0", F_OK)                = 0
time(NULL)                              = 1357238073
stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
open("/dev/fd0", O_RDONLY|O_LARGEFILE)  = 4
fadvise64_64(4, 0, 0, POSIX_FADV_RANDOM) = 0
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
uname({sys="Linux", node="izar", ...})  = 0
ioctl(4, BLKGETSIZE64, 0x8050d5c)       = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4,  <unfinished ...>

--=_CO800STPCXssuyMkra2IiTYpST4O7m1yayFe$KsN1xPC+nk69JNahka--
