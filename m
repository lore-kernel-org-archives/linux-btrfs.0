Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42987 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2IESGd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 14:06:33 -0400
Received: by bkwj10 with SMTP id j10so408270bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2012 11:06:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50478BC9.1030409@libero.it>
References: <CAPsrAuCxYz0jncrtEgcget0MskXxaQ_3UW6ywWNDdZcraEvcNg@mail.gmail.com>
	<50478BC9.1030409@libero.it>
Date: Wed, 5 Sep 2012 20:06:31 +0200
Message-ID: <CAPsrAuD002esQ_bEMhWRSb7sd_ubvmDx2iqm2Q1FAXiBLb4cFQ@mail.gmail.com>
Subject: Re: BTRFS thinks device is busy [kernel 3.5.3]
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thank you for your reply.
I physically disconnected the device before the command "btrfs device
delete missing".
Maybe it was not wise to do that, but in a raid10 (both data and
metadata), there is one disk having the mirrored data from the
disconnected and deleted disk. right?

SANOS1:~ # btrfs filesystem df /btrfs/
Data, RAID10: total=330.00GB, used=261.11GB
Data: total=8.00MB, used=0.00
System, RAID10: total=63.75MB, used=168.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=260.94GB, used=423.32MB
Metadata: total=8.00MB, used=0.00


After the "btrfs device delete missing", I connected the disk again.
But it appeared again in the "btrfs filesystem show" output.

So now I'm searching for a way to add the device again... without
bringing the pool/volume offline/unmounting it, or at least trying to
let the device busy error go away and scrub the volume.

Now "btrfs device delete missing" could not zero out the superblock
signature, if I totally wipe the disk, would it change this situation?
The device busy error stays weird...


SANOS1:~ # btrfs filesystem sync /btrfs/
FSSync '/btrfs/'
SANOS1:~ # btrfs filesystem show
Label: 'firstpool'  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
        Total devices 13 FS bytes used 242.82GB
        devid    3 size 931.51GB used 90.28GB path /dev/sdg
        devid   14 size 931.51GB used 91.33GB path /dev/sdr
        devid   13 size 931.51GB used 90.50GB path /dev/sdq
        devid   12 size 931.51GB used 90.50GB path /dev/sdp
        devid   11 size 931.51GB used 90.50GB path /dev/sdo
        devid   10 size 931.51GB used 90.50GB path /dev/sdn
        devid    9 size 931.51GB used 90.50GB path /dev/sdm
        devid    8 size 931.51GB used 90.50GB path /dev/sdl
        devid    7 size 931.51GB used 91.50GB path /dev/sdk
        devid    6 size 931.51GB used 91.49GB path /dev/sdj
        devid    5 size 931.51GB used 91.33GB path /dev/sdi
        devid    4 size 931.51GB used 91.50GB path /dev/sdh
        devid    2 size 931.51GB used 91.33GB path /dev/sdf
        devid    1 size 931.51GB used 90.52GB path /dev/sde

=> check dmesg output
=> indeed the transid is different for /dev/sdg, however it still
appears in the list above

[109624.549395] device label firstpool devid 1 transid 32208 /dev/sde
[109624.549792] device label firstpool devid 2 transid 32208 /dev/sdf
[109624.550073] device label firstpool devid 4 transid 32208 /dev/sdh
[109624.550356] device label firstpool devid 5 transid 32208 /dev/sdi
[109624.551712] device label firstpool devid 6 transid 32208 /dev/sdj
[109624.552572] device label firstpool devid 7 transid 32208 /dev/sdk
[109624.553360] device label firstpool devid 8 transid 32208 /dev/sdl
[109624.553888] device label firstpool devid 9 transid 32208 /dev/sdm
[109624.554183] device label firstpool devid 10 transid 32208 /dev/sdn
[109624.554565] device label firstpool devid 11 transid 32208 /dev/sdo
[109624.555265] device label firstpool devid 12 transid 32208 /dev/sdp
[109624.555699] device label firstpool devid 13 transid 32208 /dev/sdq
[109624.556111] device label firstpool devid 14 transid 32208 /dev/sdr
[109624.592864] device label firstpool devid 3 transid 31490 /dev/sdg




Please find below the strace output
-------------------------------------------------
strace btrfs device scan
execve("/sbin/btrfs", ["btrfs", "device", "scan"], [/* 60 vars */]) = 0
brk(0)                                  = 0x1956000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a7e000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=85716, ...}) = 0
mmap(NULL, 85716, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f1cf0a69000
close(3)                                = 0
open("/usr/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\31\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=19096, ...}) = 0
mmap(NULL, 2113968, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f1cf0659000
mprotect(0x7f1cf065d000, 2093056, PROT_NONE) = 0
mmap(0x7f1cf085c000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f1cf085c000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@l\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=131219, ...}) = 0
mmap(NULL, 2208656, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f1cf043d000
mprotect(0x7f1cf0454000, 2093056, PROT_NONE) = 0
mmap(0x7f1cf0653000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16000) = 0x7f1cf0653000
mmap(0x7f1cf0655000, 13200, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1cf0655000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\25\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1957616, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a68000
mmap(NULL, 3820608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f1cf0098000
mprotect(0x7f1cf0233000, 2097152, PROT_NONE) = 0
mmap(0x7f1cf0433000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19b000) = 0x7f1cf0433000
mmap(0x7f1cf0439000, 15424, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1cf0439000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a67000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a65000
arch_prctl(ARCH_SET_FS, 0x7f1cf0a65740) = 0
mprotect(0x7f1cf0433000, 16384, PROT_READ) = 0
mprotect(0x7f1cf0653000, 4096, PROT_READ) = 0
mprotect(0x7f1cf085c000, 4096, PROT_READ) = 0
mprotect(0x631000, 4096, PROT_READ)     = 0
mprotect(0x7f1cf0a7f000, 4096, PROT_READ) = 0
munmap(0x7f1cf0a69000, 85716)           = 0
set_tid_address(0x7f1cf0a65a10)         = 19914
set_robust_list(0x7f1cf0a65a20, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7f1cf04437a0, [], SA_RESTORER|SA_SIGINFO,
0x7f1cf044c140}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7f1cf0443820, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f1cf044c140}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
brk(0)                                  = 0x1956000
brk(0x1977000)                          = 0x1977000
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a7d000
write(1, "Scanning for Btrfs filesystems\n", 31Scanning for Btrfs filesystems
) = 31
open("/proc/partitions", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a7c000
read(3, "major minor  #blocks  name\n\n   8"..., 1024) = 700
lstat("/dev/sda", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 0), ...}) = 0
open("/dev/sda", O_RDONLY)              = 4
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\1\0\0\0\t\0\0\0(\26\0\0\0\0\0\0\360\25\0\0\0\0\0\0\1\0\0\0\4\0\0\0"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
close(4)                                = 0
lstat("/dev/sda1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 1), ...}) = 0
open("/dev/sda1", O_RDONLY)             = 4
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\0\0\0\0\0\0i$\0\0\0\0\0\0l&\0\0\0\0\0\0\v)\0\0\0\0\0\0\36)"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
close(4)                                = 0
lstat("/dev/sda2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 2), ...}) = 0
open("/dev/sda2", O_RDONLY)             = 4
pread(4, "\20\200\0\0\20\200\1\0\20\200\2\0\20\200\3\0\20\200\4\0\20\200\f\0\20\200\r\0\20\200\30\0"...,
3531, 65536) = 3531
pread(4, "\0\0\0\0\1\0\0\0\274\3\0\0\22\0\0\0j\2\0\0\302\0@\5\1\5\354\17\340\17\310\17"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
close(4)                                = 0
lstat("/dev/sdb", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 16), ...}) = 0
open("/dev/sdb", O_RDONLY)              = 4
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
close(4)                                = 0
lstat("/dev/sdb1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 17), ...}) = 0
open("/dev/sdb1", O_RDONLY)             = 4
pread(4, "", 3531, 65536)               = 0
close(4)                                = 0
lstat("/dev/sdb2", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 18), ...}) = 0
open("/dev/sdb2", O_RDONLY)             = 4
pread(4, "\0\0\0\0\0\0\0\0\30\0\0\0
\0\0\0(\0\0\0\270\v\0\0\0\0\0\0\0\0\0\0"..., 3531, 65536) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
close(4)                                = 0
lstat("/dev/sdb3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 19), ...}) = 0
open("/dev/sdb3", O_RDONLY)             = 4
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0p0K\1\10\0\0\0"...,
3531, 65536) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
close(4)                                = 0
lstat("/dev/sdc", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 32), ...}) = 0
open("/dev/sdc", O_RDONLY)              = 4
pread(4, "\216\210\342\337\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, ".\351\312\21\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdd", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 48), ...}) = 0
open("/dev/sdd", O_RDONLY)              = 4
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "", 3531, 274877906944)        = 0
close(4)                                = 0
lstat("/dev/sde", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 64), ...}) = 0
open("/dev/sde", O_RDONLY)              = 4
pread(4, "c\34\205&\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\303}\255\350\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, ">\372\373\331\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdf", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 80), ...}) = 0
open("/dev/sdf", O_RDONLY)              = 4
pread(4, "\350\203?_\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "H\342\27\221\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\265eA\240\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdh", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 112), ...}) = 0
open("/dev/sdh", O_RDONLY)              = 4
pread(4, "\316\"\304\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "nC\354\307\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\223\304\272\366\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdi", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 128), ...}) = 0
open("/dev/sdi", O_RDONLY)              = 4
pread(4, "t\7Q\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\324fy\314\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, ")\341/\375\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdj", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 144), ...}) = 0
open("/dev/sdj", O_RDONLY)              = 4
pread(4, "\226\230\242\v\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "6\371\212\305\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\313~\334\364\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdk", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 160), ...}) = 0
open("/dev/sdk", O_RDONLY)              = 4
pread(4, "%k\347\200\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\205\n\317N\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "x\215\231\177\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdl", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 176), ...}) = 0
open("/dev/sdl", O_RDONLY)              = 4
pread(4, "4\335O\212\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\224\274gD\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "i;1u\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdm", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 192), ...}) = 0
open("/dev/sdm", O_RDONLY)              = 4
pread(4, "\316\353\tb\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "n\212!\254\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\223\rw\235\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdn", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 208), ...}) = 0
open("/dev/sdn", O_RDONLY)              = 4
pread(4, "\3226\307\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "rW\357\6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\217\320\2717\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdo", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 224), ...}) = 0
open("/dev/sdo", O_RDONLY)              = 4
pread(4, "\324\360\230\214\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "t\221\260B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\211\26\346s\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdp", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 240), ...}) = 0
open("/dev/sdp", O_RDONLY)              = 4
pread(4, "\326i\t,\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "v\10!\342\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "\213\217w\323\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdq", {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 0), ...}) = 0
open("/dev/sdq", O_RDONLY)              = 4
pread(4, "\34\267+\376\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\274\326\0030\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "AQU\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdr", {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 16), ...}) = 0
open("/dev/sdr", O_RDONLY)              = 4
pread(4, "\21*\313_\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\261K\343\221\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "L\314\265\240\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = 0
close(5)                                = 0
close(4)                                = 0
lstat("/dev/sdg", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 96), ...}) = 0
open("/dev/sdg", O_RDONLY)              = 4
pread(4, "\v\\9\274\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 65536) = 3531
pread(4, "\253=\21r\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 67108864) = 3531
pread(4, "V\272GC\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
3531, 274877906944) = 3531
open("/dev/btrfs-control", O_RDONLY)    = 5
ioctl(5, 0x50009404, 0x7fff3e970be0)    = -1 EBUSY (Device or resource busy)
write(2, "ERROR: unable to scan the device"..., 70ERROR: unable to
scan the device '/dev/sdg' - Device or resource busy
) = 70
close(5)                                = 0
close(4)                                = 0
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0x7f1cf0a7c000, 4096)            = 0
open("/proc/partitions", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f1cf0a7c000
read(3, "major minor  #blocks  name\n\n   8"..., 1024) = 700
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0x7f1cf0a7c000, 4096)            = 0
exit_group(0)                           = ?
+++ exited with 0 +++

On Wed, Sep 5, 2012 at 7:28 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi,
>
>
> On 09/05/2012 03:29 PM, Joeri Vanthienen wrote:
>>
>> Hi,
>> I'm running OpenSuse 12.2 with kernel 3.5.3
>> HBA= LSI 1068e using the MPTSAS driver (patched)
>> (https://patchwork.kernel.org/patch/1379181/)
>>
>> SANOS1:/media # uname -a
>> Linux SANOS1 3.5.3 #3 SMP Sun Sep 2 18:44:37 CEST 2012 x86_64 x86_64
>> x86_64 GNU/Linux
>>
>> I've tried to simulate a disk replacement but it seems that now
>> /dev/sdg is stuck in the btrfs pool (RAID10)
>>
>> SANOS1:/media # btrfs device scan
>> Scanning for Btrfs filesystems
>> ERROR: unable to scan the device '/dev/sdg' - Device or resource busy
>
>
> Please could you send the strace of the command above ?
>
>
>> I've ran the btrfs device delete missing command before.
>> /dev/sdg is connected, but not mounted, is not in use and there is no
>> scrub running.
>
>
> I am not sure to have understood correctly: did you physically disconnected
> the device after or before you did "btrfs device delete ..." ?
>
> When you do a "btrfs dev rem" btrfs moves all the data to the others disks,
> then it zeroes the superblock signature invaliding the devices. To do that
> btrfs needs to access the devices.
>
>
>>
>> ANOS1:/media # btrfs  device delete /dev/sdg /btrfs/
>> ERROR: error removing the device '/dev/sdg' - No such file or directory
>>
>> SANOS1:/media # cat /etc/mtab /proc/mounts | grep btrfs
>> /dev/sde /btrfs btrfs rw,noatime,space_cache,inode_
>> cache 0 0
>> /dev/sde /btrfs btrfs rw,noatime,space_cache,inode_cache 0 0
>>
>> SANOS1:/media # cat /etc/mtab /proc/mounts | grep /dev/sdg
>> SANOS1:/media #
>> SANOS1:/media # lsof /dev/sdg
>> SANOS1:/media #
>>
>>
>> SANOS1:/media # btrfs filesystem show
>> Label: 'firstpool'  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
>>          Total devices 13 FS bytes used 242.82GB
>>          devid    3 size 931.51GB used 90.28GB path /dev/sdg
>>          devid   14 size 931.51GB used 91.33GB path /dev/sdr
>>          devid   13 size 931.51GB used 90.50GB path /dev/sdq
>>          devid   12 size 931.51GB used 90.50GB path /dev/sdp
>>          devid   11 size 931.51GB used 90.50GB path /dev/sdo
>>          devid   10 size 931.51GB used 90.50GB path /dev/sdn
>>          devid    9 size 931.51GB used 90.50GB path /dev/sdm
>>          devid    8 size 931.51GB used 90.50GB path /dev/sdl
>>          devid    7 size 931.51GB used 91.50GB path /dev/sdk
>>          devid    6 size 931.51GB used 91.49GB path /dev/sdj
>>          devid    5 size 931.51GB used 91.33GB path /dev/sdi
>>          devid    4 size 931.51GB used 91.50GB path /dev/sdh
>>          devid    2 size 931.51GB used 91.33GB path /dev/sdf
>>          devid    1 size 931.51GB used 90.52GB path /dev/sde
>
>
> The output of the command above is wrong: 14 devices are listed, but btrfs
> report that only 13 devices are used. Please do a sync before the command
> "btrfs filesystem show"
>
>
>
>> Also tried to again remove (physical) the disk drive, but the result
>> is the same.
>> dmesg:
>> [92728.516346] device label firstpool devid 1 transid 31965 /dev/sde
>> [92728.516378] device label firstpool devid 2 transid 31965 /dev/sdf
>> [92728.516406] device label firstpool devid 4 transid 31965 /dev/sdh
>> [92728.516432] device label firstpool devid 5 transid 31965 /dev/sdi
>> [92728.516458] device label firstpool devid 6 transid 31965 /dev/sdj
>> [92728.516484] device label firstpool devid 7 transid 31965 /dev/sdk
>> [92728.516510] device label firstpool devid 8 transid 31965 /dev/sdl
>> [92728.516535] device label firstpool devid 9 transid 31965 /dev/sdm
>> [92728.516589] device label firstpool devid 10 transid 31965 /dev/sdn
>> [92728.516617] device label firstpool devid 11 transid 31965 /dev/sdo
>> [92728.516643] device label firstpool devid 12 transid 31965 /dev/sdp
>> [92728.516669] device label firstpool devid 13 transid 31965 /dev/sdq
>> [92728.516695] device label firstpool devid 14 transid 31965 /dev/sdr
>> [92728.551786] device label firstpool devid 3 transid 31490 /dev/sdg
>> [92750.177157]  end_device-4:0:19: mptsas: ioc0: removing sata device:
>> fw_channel 0, fw_id 12, phy 12,sas_addr 0x50030480008a364c
>> [92750.177163]  phy-4:0:20: mptsas: ioc0: delete phy 12, phy-obj
>> (0xffff8803ab81d400)
>> [92750.177170]  port-4:0:19: mptsas: ioc0: delete port 19, sas_addr
>> (0x50030480008a364c)
>> [92750.178149] sd 4:0:18:0: [sdg] Synchronizing SCSI cache
>> [92750.178326] sd 4:0:18:0: [sdg]
>> [92750.178331] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>> [92750.178441] scsi target4:0:18: mptsas: ioc0: delete device:
>> fw_channel 0, fw_id 12, phy 12, sas_addr 0x50030480008a364c
>> [92766.761077] mptsas: ioc0: attaching sata device: fw_channel 0,
>> fw_id 12, phy 12, sas_addr 0x50030480008a364c
>> [92766.764242] scsi 4:0:19:0: Direct-Access     ATA      WDC
>> WD1002FBYS-0 0C06 PQ: 0 ANSI: 5
>> [92766.766302] sd 4:0:19:0: Attached scsi generic sg6 type 0
>> [92766.769374] sd 4:0:19:0: [sdg] 1953525168 512-byte logical blocks:
>> (1.00 TB/931 GiB)
>> [92766.778433] sd 4:0:19:0: [sdg] Write Protect is off
>> [92766.778438] sd 4:0:19:0: [sdg] Mode Sense: 73 00 00 08
>> [92766.780583] sd 4:0:19:0: [sdg] Write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [92766.797777]  sdg:
>> [92766.813296] sd 4:0:19:0: [sdg] Attached SCSI disk
>> [92773.288107] device label singleBTRFS devid 1 transid 43 /dev/sdc
>> [92773.288807] device label firstpool devid 1 transid 31967 /dev/sde
>> [92773.288845] device label firstpool devid 2 transid 31967 /dev/sdf
>> [92773.288877] device label firstpool devid 4 transid 31967 /dev/sdh
>> [92773.288904] device label firstpool devid 5 transid 31967 /dev/sdi
>> [92773.288927] device label firstpool devid 6 transid 31967 /dev/sdj
>> [92773.288949] device label firstpool devid 7 transid 31967 /dev/sdk
>> [92773.288971] device label firstpool devid 8 transid 31967 /dev/sdl
>> [92773.288993] device label firstpool devid 9 transid 31967 /dev/sdm
>> [92773.289014] device label firstpool devid 10 transid 31967 /dev/sdn
>> [92773.289036] device label firstpool devid 11 transid 31967 /dev/sdo
>> [92773.289058] device label firstpool devid 12 transid 31967 /dev/sdp
>> [92773.289080] device label firstpool devid 13 transid 31967 /dev/sdq
>> [92773.289102] device label firstpool devid 14 transid 31967 /dev/sdr
>> [92773.313675] device label firstpool devid 3 transid 31490 /dev/sdg
>>
>> Can someone help me?
>>
>>
>> It seems there is still some btrfs structure on the disk. Is this the
>> cause of the error? Why can't BTRFS rebuild this "online"?
>
>
> It seems that BTRFS was never aware of the /dev/sdg disconnection....
>
>
>>
>> SANOS1:/media # btrfs-find-root /dev/sdg | head
>> ERROR: unable to scan the device '/dev/sdg' - Device or resource busy
>> Well block 905192472576 seems great, but generation doesn't match,
>> have=31490, want=32015
>> Super think's the tree root is at 906491981824, chunk root 628100251648
>> Generation: 31490 Root bytenr: 905192484864 Root objectid: 2
>> Generation: 31490 Root bytenr: 905543114752 Root objectid: 4
>> Generation: 31490 Root bytenr: 905641820160 Root objectid: 5
>> Generation: 31490 Root bytenr: 905689354240 Root objectid: 7
>> Generation: 31490 Root bytenr: 905688096768 Root objectid: 554
>> Generation: 31490 Root bytenr: 905687691264 Root objectid: 561
>> Generation: 31490 Root bytenr: 905642328064 Root objectid: 565
>> Generation: 31490 Root bytenr: 905642332160 Root objectid: 566
>> Generation: 31490 Root bytenr: 905678802944 Root objectid: 568
>> Couldn't map the block 433225728
>> Well block 905192542208 seems great, but generation doesn't match,
>> have=31416, want=32015
>
>
> Pay attention that when a device is removed, the superblock signature is
> zeroed to mark the device as not valid any more. So the generation of a
> removed device doesn't make sense.
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>>
>
