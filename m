From: Marti Raudsepp <marti@juffo.org>
Subject: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Sun, 13 Feb 2011 17:49:42 +0200
Message-ID: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list!

It seems I have found a serious regression in compressed btrfs in
kernel 2.6.37. When creating a small file (less than the block size)
and then cp/mv it to *another* file system, an appropriate number of
zeroes gets written to the destination file. Case in point:

% echo foobar > foobar
% hexdump -C foobar
00000000  66 6f 6f 62 61 72 0a                              |foobar.|
00000007
% mv foobar /tmp
% hexdump -C /tmp/foobar
00000000  00 00 00 00 00 00 00                              |.......|
00000007
% cp foobar foobar2
% hexdump -C foobar2
00000000  00 00 00 00 00 00 00                              |.......|
00000007

Via strace I found that mv doesn't even attempt to read anything:

open("foobar", O_RDONLY|O_NOFOLLOW)     = 3
fstat(3, {st_mode=S_IFREG|0664, st_size=7, ...}) = 0
open("/tmp/foobar", O_WRONLY|O_CREAT|O_EXCL, 0600) = 4
fstat(4, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
ioctl(3, FS_IOC_FIEMAP, 0x7fff62f6bfa0) = 0
write(4, "\0\0\0\0\0\0\0", 7)           = 7

What's that, is FS_IOC_FIEMAP telling it that it's a sparse file?
Compare with ext4:

ioctl(3, FS_IOC_FIEMAP, 0x7fff2c576a90) = 0
lseek(3, 0, SEEK_SET)                   = 0
read(3, "foobar\n", 4096)               = 7
write(4, "foobar\n", 7)                 = 7

I'm currently running on 2.6.37, x86_64 using Arch Linux -testing with
coreutils 8.10. Filesystem is mounted from LVM2 to /usr/src with -o
noatime,compress

This only seems to occur with compressed file systems (either zlib or
LZO). A person on IRC also reproduced the same problem in 2.6.28-rc.
I'm pretty sure this used to work correctly around 2.6.35 or 2.6.36.

This is 100% reproducible here. If anyone has trouble reproducing
this, I can dig further and provide information as needed.

Regards,
Marti
