From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Sat, 22 Jan 2011 16:56:12 +0100
Message-ID: <20110122155612.GA3664@scooter>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110122151124.GC29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It was a simple:

mkfs.btrfs -L backup -d single /dev/loop2

But it also happens without the options, like:

mkfs.btrfs /dev/loop2


/dev/loop2 is a loop device, which is aes encrypted. The output of "losetup /dev/loop2":

/dev/loop2: [0010]:5324 
(/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3) encryption=AES128


Thanks you for looking into this!
While writing this I read your second mail. The strace output is attached.

Regards,
Felix

P.S.: The btrfs wiki is down. If someone reads this and have time to answer:

Means "-d single" that the data are not spread across the devices? The default is
raid0, right? I want some kind of security that if a device crashes only the
files on that damaged device are gone. Raid1 will be the next step, but act. I don't
have money for that :)


On 22. January 2011 - 15:11, Hugo Mills wrote:
> Date: Sat, 22 Jan 2011 15:11:24 +0000
> From: Hugo Mills <hugo-lkml@carfax.org.uk>
> To: Felix Blanke <felixblanke@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
> Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>, Felix Blanke
>  <felixblanke@gmail.com>, linux-btrfs@vger.kernel.org
> 
> On Sat, Jan 22, 2011 at 03:52:22PM +0100, Felix Blanke wrote:
> > I was able to create the fs with the --force options. But that bug should be fixed,
> > too :)
> > 
> > Is that link maybe too long? It is created by udev, and there was never a problem
> > using that link.
> 
>    Yes, it certainly looks like it. There's 63 characters in the name
> in your strace report, so it looks like it's being truncated somewhere.
> 
>    What was the exact command line you used to get the error?
> 
>    Hugo.
> 
> > Regards,
> > Felix
> > 
> > On 22. January 2011 - 15:45, Felix Blanke wrote:
> > > Date: Sat, 22 Jan 2011 15:45:13 +0100
> > > From: Felix Blanke <felixblanke@gmail.com>
> > > To: linux-btrfs@vger.kernel.org
> > > Subject: Bug in mkfs.btrfs?!
> > > 
> > > Hi,
> > > 
> > > I wanted to create a new btrfs fs for my backups.
> > > When trying to mkfs.btrfs for that  device, I'm getting
> > > 
> > > "error checking /dev/loop2 mount status"
> > > 
> > > 
> > > With strace I see where the problem is:
> > > 
> > > lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par",
> > > 0x7fffa30b3cf0) = -1 ENOENT (No such file or directory)
> > > 
> > > 
> > > 
> > > The problem is there is something missing at the end of the link, should be
> > > something like "-part1", "-part2" etc.
> > > 
> > > 
> > > I'll try the patch with the --foce option.
> > > 
> > > Regards,
> > > Felix
> > > 
> > ---end quoted text---
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>      --- Great oxymorons of the world, no. 9: Standard Deviation ---     


---end quoted text---

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=strace

execve("/sbin/mkfs.btrfs", ["mkfs.btrfs", "/dev/loop2"], [/* 41 vars */]) = 0
brk(0)                                  = 0x653000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e42d000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=156346, ...}) = 0
mmap(NULL, 156346, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fcd7e406000
close(3)                                = 0
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\27\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=18776, ...}) = 0
mmap(NULL, 2113952, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fcd7e00c000
mprotect(0x7fcd7e010000, 2093056, PROT_NONE) = 0
mmap(0x7fcd7e20f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7fcd7e20f000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\354\1\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1424672, ...}) = 0
mmap(NULL, 3533704, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fcd7dcad000
mprotect(0x7fcd7de02000, 2097152, PROT_NONE) = 0
mmap(0x7fcd7e002000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x155000) = 0x7fcd7e002000
mmap(0x7fcd7e007000, 19336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e007000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e405000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e403000
arch_prctl(ARCH_SET_FS, 0x7fcd7e403740) = 0
mprotect(0x7fcd7e002000, 16384, PROT_READ) = 0
mprotect(0x7fcd7e20f000, 4096, PROT_READ) = 0
mprotect(0x620000, 4096, PROT_READ)     = 0
mprotect(0x7fcd7e42e000, 4096, PROT_READ) = 0
munmap(0x7fcd7e406000, 156346)          = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e42c000
write(1, "\n", 1)                       = 1
write(1, "WARNING! - Btrfs v0.19-35-g1b444"..., 57) = 57
write(1, "WARNING! - see http://btrfs.wiki"..., 57) = 57
write(1, "\n", 1)                       = 1
open("/dev/loop2", O_RDONLY)            = 3
brk(0)                                  = 0x653000
brk(0x675000)                           = 0x675000
pread(3, "D\345\355-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2859, 65536) = 2859
pread(3, "\344\204\305\343\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2859, 67108864) = 2859
pread(3, "\31\3\223\322\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2859, 274877906944) = 2859
close(3)                                = 0
open("/proc/mounts", O_RDONLY)          = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd7e42b000
read(3, "rootfs / rootfs rw 0 0\n/dev/sdb4"..., 1024) = 877
stat("/dev/loop2", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 2), ...}) = 0
open("/dev/loop2", O_RDONLY)            = 4
ioctl(4, 0x4c03, 0x7fffbbd8a660)        = 0
close(4)                                = 0
stat("/dev/sdb4", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 20), ...}) = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/disk", {st_mode=S_IFDIR|0755, st_size=120, ...}) = 0
lstat("/dev/disk/by-id", {st_mode=S_IFDIR|0755, st_size=820, ...}) = 0
lstat("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", {st_mode=S_IFLNK|0777, st_size=10, ...}) = 0
readlink("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", "../../sda3", 4095) = 10
lstat("/dev/sda3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 3), ...}) = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/sdb4", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 20), ...}) = 0
stat("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 3), ...}) = 0
stat("/dev/sdb4", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 20), ...}) = 0
stat("/dev/loop2", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 2), ...}) = 0
open("/dev/loop2", O_RDONLY)            = 4
ioctl(4, 0x4c03, 0x7fffbbd8a660)        = 0
close(4)                                = 0
stat("/dev/loop4", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 4), ...}) = 0
open("/dev/loop4", O_RDONLY)            = 4
ioctl(4, 0x4c03, 0x7fffbbd8a660)        = 0
close(4)                                = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/disk", {st_mode=S_IFDIR|0755, st_size=120, ...}) = 0
lstat("/dev/disk/by-id", {st_mode=S_IFDIR|0755, st_size=820, ...}) = 0
lstat("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", {st_mode=S_IFLNK|0777, st_size=10, ...}) = 0
readlink("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", "../../sda3", 4095) = 10
lstat("/dev/sda3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 3), ...}) = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/disk", {st_mode=S_IFDIR|0755, st_size=120, ...}) = 0
lstat("/dev/disk/by-id", {st_mode=S_IFDIR|0755, st_size=820, ...}) = 0
lstat("/dev/disk/by-id/ata-WDC_WD5000AAKS-65YGA0_WD-WCAS82030114-part1", {st_mode=S_IFLNK|0777, st_size=10, ...}) = 0
readlink("/dev/disk/by-id/ata-WDC_WD5000AAKS-65YGA0_WD-WCAS82030114-part1", "../../sdd1", 4095) = 10
lstat("/dev/sdd1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 49), ...}) = 0
stat("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 3), ...}) = 0
stat("/dev/disk/by-id/ata-WDC_WD5000AAKS-65YGA0_WD-WCAS82030114-part1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 49), ...}) = 0
stat("/dev/loop2", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 2), ...}) = 0
open("/dev/loop2", O_RDONLY)            = 4
ioctl(4, 0x4c03, 0x7fffbbd8a660)        = 0
close(4)                                = 0
stat("/dev/loop1", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 1), ...}) = 0
open("/dev/loop1", O_RDONLY)            = 4
ioctl(4, 0x4c03, 0x7fffbbd8a660)        = 0
close(4)                                = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/disk", {st_mode=S_IFDIR|0755, st_size=120, ...}) = 0
lstat("/dev/disk/by-id", {st_mode=S_IFDIR|0755, st_size=820, ...}) = 0
lstat("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", {st_mode=S_IFLNK|0777, st_size=10, ...}) = 0
readlink("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3", "../../sda3", 4095) = 10
lstat("/dev/sda3", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 3), ...}) = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=3620, ...}) = 0
lstat("/dev/disk", {st_mode=S_IFDIR|0755, st_size=120, ...}) = 0
lstat("/dev/disk/by-id", {st_mode=S_IFDIR|0755, st_size=820, ...}) = 0
lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par", 0x7fffbbd88520) = -1 ENOENT (No such file or directory)
close(3)                                = 0
munmap(0x7fcd7e42b000, 4096)            = 0
write(2, "error checking /dev/loop2 mount "..., 39) = 39
exit_group(1)                           = ?

--zhXaljGHf11kAtnf--
