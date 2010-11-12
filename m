From: Josh Berry <des@condordes.net>
Subject: Re: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 16:33:09 -0800
Message-ID: <AANLkTinh3jh_q2i4LLL5=6y-fAniywzNgfLE1VDpfSd6@mail.gmail.com>
References: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
	<201011112132.06687.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011112132.06687.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 11, 2010 at 12:32, Goffredo Baroncelli <kreijack@libero.it>=
 wrote:
> On Thursday, 11 November, 2010, Josh Berry wrote:
>> Hi,
>>
>> I have a cron script that runs periodically, taking new snapshots an=
d
>> cleaning up old ones when space gets low on my filesystem. =C2=A0Thi=
s
>> morning, the script suddenly stopped being able to remove snapshots.
>> When I tried to remove one manually, I got the following:
>>
>> # btrfs subvol del 2010-11-07-01:17:01
>> Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
>> ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'
>>
>> There is nothing in dmesg or in the above output to tell me what the
>> problem is, how to fix it, etc. =C2=A0I'm running kernel 2.6.36, and=
 I
>> updated btrfs-progs-unstable to the lastest Git revision
>> (1b444cd2e6...), with the same result.
>>
>> How do I diagnose this issue? =C2=A0I'm not even sure where to start=
=2E
>
> This error is due to a failure during the ioctl. Could you "strace" b=
trfs
> subvolume delete ?

The strace is short enough that I've included it directly below:

# strace btrfs subvol del test
execve("/usr/local/bin/btrfs", ["btrfs", "subvol", "del", "test"], [/*
28 vars */]) =3D 0
brk(0)                                  =3D 0xa04a000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb785e000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D36274, ...}) =3D 0
mmap2(NULL, 36274, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb7855000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libuuid.so.1", O_RDONLY)     =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\20\0\0004\0\0=
\0"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D13276, ...}) =3D 0
mmap2(NULL, 15948, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0xb7851000
mmap2(0xb7854000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) =3D 0xb7854000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/i686/cmov/libc.so.6", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320m\1\0004\0\=
0\0"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1323460, ...}) =3D 0
mmap2(NULL, 1333608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) =3D 0xb770b000
mmap2(0xb784b000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13f) =3D 0xb784b000
mmap2(0xb784e000, 10600, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0xb784e000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb770a000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb7709000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb770ab60,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) =3D 0
mprotect(0xb784b000, 8192, PROT_READ)   =3D 0
mprotect(0xb787c000, 4096, PROT_READ)   =3D 0
munmap(0xb7855000, 36274)               =3D 0
brk(0)                                  =3D 0xa04a000
brk(0xa06b000)                          =3D 0xa06b000
stat64("test", {st_mode=3DS_IFDIR|0755, st_size=3D44, ...}) =3D 0
getcwd("/btrfs", 4096)                  =3D 7
lstat64("/btrfs/test", {st_mode=3DS_IFDIR|0755, st_size=3D44, ...}) =3D=
 0
stat64("/btrfs", {st_mode=3DS_IFDIR|0555, st_size=3D50, ...}) =3D 0
open("/btrfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D=
 3
fcntl64(3, F_GETFD)                     =3D 0x1 (flags FD_CLOEXEC)
fstat64(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 0), ...}) =3D=
 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb785d000
write(1, "Delete subvolume '/btrfs/test'\n", 31Delete subvolume '/btrfs=
/test'
) =3D 31
ioctl(3, 0x5000940f, 0xbfe8fb30)        =3D -1 ENOTEMPTY (Directory not=
 empty)
close(3)                                =3D 0
write(2, "ERROR: cannot delete '/btrfs/tes"..., 35ERROR: cannot delete
'/btrfs/test'
) =3D 35
exit_group(11)                          =3D ?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
