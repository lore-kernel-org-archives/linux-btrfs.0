From: Oliver =?UTF-8?Q?Ve=C4=8Dernik?= <ov@vecernik.at>
Subject: Re: migrating drives (device delete)
Date: Wed, 10 Nov 2010 15:40:24 +0100
Message-ID: <1289400024.14203.28.camel@jeezo>
References: <1289387076.20690.28.camel@jeezo>
	 <20101110123403.GA11460@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101110123403.GA11460@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> This isn't necessarily RAID-0. It's just spread the block group
> allocations across both drives. Block groups are 1 GiB in size. if you
> use RAID-0, it will allocate block groups in pairs, on different
> drives, and stripe the data within the pair (on some much smaller
> stripe size). If you use basic allocation as you've got here, it
> allocates the block groups one at a time.

Thanks for clarification!  This explains why df says there should be
552GB free.

> There's no need to mount degraded, as there's no duplication in
> your filesystem to degrade. :)

Ok.

> Try running the dev del operation under strace (on a freshly
> mounted filesystem -- this will probably involve a reboot in your
> case), and report back on what the return value from the ioctl
> was. That _might_ give us some indication of what's wrong. It would
> also be good to know if subsequent attempts to run the dev del
> operation return the same error code.

I rebooted the box, here is my output:

# strace btrfs dev del /dev/sda2 /
execve("/sbin/btrfs", ["btrfs", "dev", "del", "/dev/sda2", "/"], [/* 19
vars */]) = 0
brk(0)                                  = 0x902000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or
directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7f0ebb6cf000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=12540, ...}) = 0
mmap(NULL, 12540, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f0ebb6cb000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or
directory)
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\25\0\0\0\0\0
\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=19008, ...}) = 0
mmap(NULL, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f0ebb2ac000
mprotect(0x7f0ebb2b0000, 2093056, PROT_NONE) = 0
mmap(0x7f0ebb4af000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_DENYWRITE, 3, 0x3000) = 0x7f0ebb4af000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or
directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\356\1\0\0\0
\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1572232, ...}) = 0
mmap(NULL, 3680296, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f0ebaf29000
mprotect(0x7f0ebb0a3000, 2093056, PROT_NONE) = 0
mmap(0x7f0ebb2a2000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_DENYWRITE, 3, 0x179000) = 0x7f0ebb2a2000
mmap(0x7f0ebb2a7000, 18472, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) = 0x7f0ebb2a7000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7f0ebb6ca000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7f0ebb6c8000
arch_prctl(ARCH_SET_FS, 0x7f0ebb6c8740) = 0
mprotect(0x7f0ebb2a2000, 16384, PROT_READ) = 0
mprotect(0x7f0ebb4af000, 4096, PROT_READ) = 0
mprotect(0x61c000, 4096, PROT_READ)     = 0
mprotect(0x7f0ebb6d1000, 4096, PROT_READ) = 0
munmap(0x7f0ebb6cb000, 12540)           = 0
brk(0)                                  = 0x902000
brk(0x923000)                           = 0x923000
stat("/", {st_mode=S_IFDIR|0755, st_size=244, ...}) = 0
open("/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
ioctl(3, 0x5000940b, 0x7fff5385a5f0)    = -1 EINVAL (Invalid argument)
write(2, "ERROR: error removing the device"..., 45ERROR: error removing
the device '/dev/sda2'
) = 45
close(3)                                = 0
exit_group(21)                          = ?

I repeated btrfs dev del a couple of times.  I it *always* gave a return
code of 21 and ioctl = -1 EINVAL respectively.

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             844G  293G  552G  35% /
none                  429M  180K  429M   1% /dev
none                  435M     0  435M   0% /dev/shm
none                  435M   44K  435M   1% /var/run
none                  435M     0  435M   0% /var/lock
none                  844G  293G  552G  35% /var/lib/ureadahead/debugfs
/dev/sdc1             2.0G   26M  1.9G   2% /boot

-- 
Regards,
Oliver


