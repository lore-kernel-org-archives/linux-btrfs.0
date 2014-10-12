Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42000 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJLKFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 06:05:22 -0400
Received: from merkaba.localnet (ppp-212-114-182-233.dynamic.mnet-online.de [212.114.182.233])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 905B911C
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 11:56:51 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>
Subject: [REGRESSION?] Used+avail gives more than size of device
Date: Sun, 12 Oct 2014 11:56:51 +0200
Message-ID: <10721429.ggFParDapp@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On 3.17, i.e. since the size reporting changes, I get:

merkaba:~> LANG=C df -hT -t btrfs
Filesystem              Type   Size  Used Avail Use% Mounted on
/dev/mapper/sata-debian btrfs   30G   19G   21G  48% /
/dev/mapper/sata-debian btrfs   30G   19G   21G  48% /mnt/debian-zeit
/dev/mapper/msata-daten btrfs  200G  185G   15G  93% /daten
/dev/mapper/msata-home  btrfs  160G  135G   48G  75% /mnt/home-zeit
/dev/mapper/msata-home  btrfs  160G  135G   48G  75% /home

I wonder about used and avail not adding up to total size of filesystem:
19+21 = 40 GiB instead of 30 GiB for / and 135+48 = 183 GiB for /home.
Only /daten seems to be correct.

/ and /home are RAID 1 spanning two SSDs. /daten is single.

I wondered about compression taken into account? They use compress=lzo.

While /daten has also compress=lzo, it contains mostly incompressible data
like jpeg images and mp3, ogg vorbis and probably some flac music files as
well one or the other mp4 video file, compressed media data that is.

Any explaination for the discrepancy, can it just be due to the compression?

/home has large maildir and lots of source files… which I expect to compress
well. Also a debian installation may contain quite an amount of compressible
data. But still… the ratio seems a bit off. As it means it would have been
able to store 19 GiB of data within 9 GiB of actual disk space for / which
would be a quite high compression ratio for LZO.


merkaba:~> mount | grep btrfs
/dev/mapper/sata-debian on / type btrfs (rw,noatime,compress=lzo,ssd,space_cache)
/dev/mapper/sata-debian on /mnt/debian-zeit type btrfs (rw,noatime,compress=lzo,ssd,space_cache)
/dev/mapper/msata-daten on /daten type btrfs (rw,noatime,compress=lzo,ssd,space_cache)
/dev/mapper/msata-home on /mnt/home-zeit type btrfs (rw,noatime,compress=lzo,ssd,space_cache)
/dev/mapper/msata-home on /home type btrfs (rw,noatime,compress=lzo,ssd,space_cache)




merkaba:~> btrfs fi sh
Label: 'debian'  uuid: […]
        Total devices 2 FS bytes used 18.47GiB
        devid    1 size 30.00GiB used 30.00GiB path /dev/mapper/sata-debian
        devid    2 size 30.00GiB used 30.00GiB path /dev/mapper/msata-debian

Label: 'daten'  uuid: […]
        Total devices 1 FS bytes used 184.82GiB
        devid    1 size 200.00GiB used 188.02GiB path /dev/mapper/msata-daten

Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 134.39GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home


merkaba:~> btrfs fi df / 
Data, RAID1: total=27.99GiB, used=17.84GiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=645.88MiB
unknown, single: total=224.00MiB, used=0.00
merkaba:~> btrfs fi df /home
Data, RAID1: total=154.97GiB, used=131.46GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=2.93GiB
unknown, single: total=512.00MiB, used=0.00
merkaba:~> btrfs fi df /daten
Data, single: total=187.01GiB, used=184.53GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=1.01GiB, used=292.31MiB
unknown, single: total=112.00MiB, used=0.00


merkaba:~> LANG=C strace df -hT -t btrfs
execve("/bin/df", ["df", "-hT", "-t", "btrfs"], [/* 55 vars */]) = 0
brk(0)                                  = 0x13c2000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e7de000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=250673, ...}) = 0
mmap(NULL, 250673, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f795e7a0000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\34\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1725888, ...}) = 0
mmap(NULL, 3832352, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f795e218000
mprotect(0x7f795e3b7000, 2093056, PROT_NONE) = 0
mmap(0x7f795e5b6000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19e000) = 0x7f795e5b6000
mmap(0x7f795e5bc000, 14880, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f795e5bc000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e79f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e79e000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e79d000
arch_prctl(ARCH_SET_FS, 0x7f795e79e700) = 0
mprotect(0x7f795e5b6000, 16384, PROT_READ) = 0
mprotect(0x616000, 4096, PROT_READ)     = 0
mprotect(0x7f795e7e0000, 4096, PROT_READ) = 0
munmap(0x7f795e7a0000, 250673)          = 0
brk(0)                                  = 0x13c2000
brk(0x13e3000)                          = 0x13e3000
open("/etc/mtab", O_RDONLY|O_CLOEXEC)   = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e7dd000
read(3, "rootfs / rootfs rw 0 0\nsysfs /sy"..., 1024) = 1024
read(3, "0 0\ncgroup /sys/fs/cgroup/memory"..., 1024) = 1024
read(3, "mapper/sata-debian /mnt/debian-z"..., 1024) = 496
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0x7f795e7dd000, 4096)            = 0
stat("/", {st_mode=S_IFDIR|0755, st_size=306, ...}) = 0
stat("/sys", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/dev", {st_mode=S_IFDIR|0755, st_size=3820, ...}) = 0
stat("/dev/pts", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/run", {st_mode=S_IFDIR|0755, st_size=1140, ...}) = 0
stat("/", {st_mode=S_IFDIR|0755, st_size=306, ...}) = 0
stat("/sys/kernel/security", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/dev/shm", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/run/lock", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=120, ...}) = 0
stat("/sys/fs/cgroup", {st_mode=S_IFDIR|0755, st_size=320, ...}) = 0
stat("/sys/fs/cgroup/systemd", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/pstore", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpuset", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/cpu,cpuacct", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/memory", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/devices", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/freezer", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/net_cls,net_prio", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/blkio", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/perf_event", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/sys/fs/cgroup/hugetlb", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
stat("/proc/sys/fs/binfmt_misc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/dev/hugepages", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/dev/mqueue", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=40, ...}) = 0
stat("/sys/kernel/debug", {st_mode=S_IFDIR|0700, st_size=0, ...}) = 0
stat("/sys/fs/fuse/connections", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=760, ...}) = 0
stat("/boot", {st_mode=S_IFDIR|0755, st_size=3072, ...}) = 0
stat("/mnt/debian-zeit", {st_mode=S_IFDIR|0755, st_size=12, ...}) = 0
stat("/daten", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
stat("/mnt/home-zeit", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
stat("/home", {st_mode=S_IFDIR|0755, st_size=124, ...}) = 0
stat("/proc/sys/fs/binfmt_misc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
stat("/run/user/1000", {st_mode=S_IFDIR|0700, st_size=120, ...}) = 0
uname({sys="Linux", node="merkaba", ...}) = 0
statfs("/", {f_type=0x9123683e, f_bsize=4096, f_blocks=7864320, f_bfree=2964122, f_bavail=5320460, f_files=0, f_ffree=0, f_fsid={1441862335, 1668422792}, f_namelen=255, f_frsize=4096}) = 0
stat("/", {st_mode=S_IFDIR|0755, st_size=306, ...}) = 0
statfs("/mnt/debian-zeit", {f_type=0x9123683e, f_bsize=4096, f_blocks=7864320, f_bfree=2964122, f_bavail=5320460, f_files=0, f_ffree=0, f_fsid={1441862335, 1668423053}, f_namelen=255, f_frsize=4096}) = 0
stat("/mnt/debian-zeit", {st_mode=S_IFDIR|0755, st_size=12, ...}) = 0
statfs("/daten", {f_type=0x9123683e, f_bsize=4096, f_blocks=52428800, f_bfree=3951188, f_bavail=3789488, f_files=0, f_ffree=0, f_fsid={-1029141028, 226079861}, f_namelen=255, f_frsize=4096}) = 0
stat("/daten", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
statfs("/mnt/home-zeit", {f_type=0x9123683e, f_bsize=4096, f_blocks=41943040, f_bfree=6582413, f_bavail=12322874, f_files=0, f_ffree=0, f_fsid={493729996, 1996367843}, f_namelen=255, f_frsize=4096}) = 0
stat("/mnt/home-zeit", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
statfs("/home", {f_type=0x9123683e, f_bsize=4096, f_blocks=41943040, f_bfree=6582413, f_bavail=12322874, f_files=0, f_ffree=0, f_fsid={493729996, 1996367590}, f_namelen=255, f_frsize=4096}) = 0
stat("/home", {st_mode=S_IFDIR|0755, st_size=124, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f795e7dd000
write(1, "Filesystem              Type   S"..., 64Filesystem              Type   Size  Used Avail Use% Mounted on
) = 64
write(1, "/dev/mapper/sata-debian btrfs   "..., 55/dev/mapper/sata-debian btrfs   30G   19G   21G  48% /
) = 55
write(1, "/dev/mapper/sata-debian btrfs   "..., 70/dev/mapper/sata-debian btrfs   30G   19G   21G  48% /mnt/debian-zeit
) = 70
write(1, "/dev/mapper/msata-daten btrfs  2"..., 60/dev/mapper/msata-daten btrfs  200G  185G   15G  93% /daten
) = 60
write(1, "/dev/mapper/msata-home  btrfs  1"..., 68/dev/mapper/msata-home  btrfs  160G  135G   48G  75% /mnt/home-zeit
) = 68
write(1, "/dev/mapper/msata-home  btrfs  1"..., 59/dev/mapper/msata-home  btrfs  160G  135G   48G  75% /home
) = 59
close(1)                                = 0
munmap(0x7f795e7dd000, 4096)            = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
