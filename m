From: idank <idank@tonian.com>
Subject: btrfs truncate() does not change inode times
Date: Thu, 05 Jan 2012 15:39:45 +0200
Message-ID: <4F05A821.8090202@tonian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I was running fstest (http://www.tuxera.com/community/posix-test-suite/) on btrfs. Only one test failed, and I believe it to be a bug in btrfs. The scenario is as follows:
* crate a file.
* note its times with stat.
* sleep a few seconds
* call truncate() on the file (not ftruncate(). ftruncate() works).
* sync
* note the file's times again with stat.
expected result: ctime and mtime are greater.
actual result: ctime and mtime remain unchanged.

Example:
[root@fedora-client pjd-fstest-20080816]# pwd
/test/pjd-fstest-20080816
[root@fedora-client pjd-fstest-20080816]# mount | grep /test
/dev/loop0 on /test type btrfs (rw,relatime)
[root@fedora-client pjd-fstest-20080816]# touch ctime_test
[root@fedora-client pjd-fstest-20080816]# stat ctime_test
  File: `ctime_test'
  Size: 0             Blocks: 0          IO Block: 4096   regular empty file
Device: 29h/41d    Inode: 1160        Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2012-01-05 14:42:21.067444155 +0200
Modify: 2012-01-05 14:42:21.067444155 +0200
Change: 2012-01-05 14:42:21.067444155 +0200
 Birth: -
[root@fedora-client pjd-fstest-20080816]# strace ./fstest truncate ctime_test 200
execve("./fstest", ["./fstest", "truncate", "ctime_test", "200"], [/* 34 vars */]) = 0
brk(0)                                  = 0x17c9000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f412616d000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=47545, ...}) = 0
mmap(NULL, 47545, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4126161000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\24\342e2\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1951736, ...}) = 0
mmap(0x3265e00000, 3773688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3265e00000
mprotect(0x3265f8f000, 2097152, PROT_NONE) = 0
mmap(0x326618f000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18f000) = 0x326618f000
mmap(0x3266194000, 21752, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x3266194000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4126160000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f412615e000
arch_prctl(ARCH_SET_FS, 0x7f412615e720) = 0
mprotect(0x326618f000, 16384, PROT_READ) = 0
mprotect(0x326581e000, 4096, PROT_READ) = 0
munmap(0x7f4126161000, 47545)           = 0
umask(0)                                = 022
truncate("ctime_test", 200)             = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f412616c000
write(1, "0\n", 20
)                      = 2
exit_group(0)                           = ?
[root@fedora-client pjd-fstest-20080816]# sleep 2
[root@fedora-client pjd-fstest-20080816]# stat ctime_test
  File: `ctime_test'
  Size: 200           Blocks: 0          IO Block: 4096   regular file
Device: 29h/41d    Inode: 1160        Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2012-01-05 14:42:21.067444155 +0200
Modify: 2012-01-05 14:42:21.067444155 +0200
Change: 2012-01-05 14:42:21.067444155 +0200
 Birth: -
