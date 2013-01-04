Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:35974 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ADM45 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2013 07:56:57 -0500
Date: 04 Jan 2013 13:11:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COClHaZuCXB@helmut.hullen.de>
In-Reply-To: <20130103212342.GE19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
>>
>>         btrfs fi label /dev/sdb mylabel
>>
>> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc"
>> and "/dev/sdd" remain without label.

>    This is a bug.

Very very strange ...

I've tested the commands on another laptop, with another (older) kernel,  
the same btrfs-progs-packet and the same "blkid" version.

"blkid" doesn't hang searching the (non existent) floppy drive.

  mkfs.btrfs -d raid0 -m raid1 -L mylabel /dev/sdb1 /dev/sdb2 /dev/sdb3

works,

        blkid

then shows all 3 btrfs partitions with the same label,

        findfs LABEL=mylabel

shows one (the first?) partition with this label.

Fine. But why does that work on the one laptop but not on the other?


------------------

I'll test this behaviour on the other laptop with the older kernel  
(3.3.7), but it's yet busy, backung up some TBytes of data.

------------------

Some minutes later: "blkid" hangs again.

[...]

access("/dev/sda1", F_OK)               = 0
access("/dev/sda2", F_OK)               = 0
access("/dev/sda3", F_OK)               = 0
access("/dev/sda4", F_OK)               = 0
access("/dev/sdb1", F_OK)               = 0
access("/dev/sdb2", F_OK)               = 0
access("/dev/sdb3", F_OK)               = 0
access("/dev/sdb4", F_OK)               = 0
read(3, "", 4096)                       = 0
_llseek(3, 1240, [1240], SEEK_SET)      = 0
close(3)                                = 0
munmap(0x40025000, 4096)                = 0
open("/run/blkid/blkid.tab", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=1240, ...}) = 0
close(3)                                = 0
open("/proc/evms/volumes", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/lvm/VGs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/dev", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
getdents64(3, /* 1084 entries */, 32768) = 32752
getdents64(3, /* 749 entries */, 32768) = 22672
getdents64(3, /* 0 entries */, 32768)   = 0
close(3)                                = 0
openat(AT_FDCWD, "/devfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/devices", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("/proc/partitions", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40025000
read(3, "major minor  #blocks  name\n\n   2"..., 1024) = 384
stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
access("/dev/fd0", F_OK)                = 0
time(NULL)                              = 1357301320
stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
open("/dev/fd0", O_RDONLY|O_LARGEFILE)  = 4
fadvise64_64(4, 0, 0, POSIX_FADV_RANDOM) = 0
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
uname({sys="Linux", node="ElNath.wm8.hullen.de", ...}) = 0
ioctl(4, BLKGETSIZE64, 0x8050dbc)       = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x8051804, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, 0x8051804, 1024)                = -1 EIO (Input/output error)
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4,  <unfinished ...>

# ------------------------------------

Is there something like "/dev/dice" running?

Viele Gruesse!
Helmut
