From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: btrfs filesystem df not working
Date: Wed, 13 Oct 2010 10:52:57 +0100
Message-ID: <AANLkTinta=KNbF2Poync8oSTCQSsjvFErBsmGUrkpGSg@mail.gmail.com>
References: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com>
	<AANLkTi=1VgjsZoJqzkp-zto3vAMUThh7TN054xQ1mpEu@mail.gmail.com>
	<AANLkTinYN+b=5qU_+pC_O6OK96JXez8QQeifdzC8dkCK@mail.gmail.com>
	<20101013004332.GK22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101013004332.GK22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 13, 2010 at 1:43 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, Oct 12, 2010 at 02:45:19PM +0100, Leonidas Spyropoulos wrote:
>> On Tue, Oct 12, 2010 at 2:43 PM, cwillu <cwillu@cwillu.com> wrote:
>> > On Tue, Oct 12, 2010 at 4:12 AM, Leonidas Spyropoulos
>> > <artafinde@gmail.com> wrote:
>> >> The above command is not working on my system.
>> >> Information:
>> >> btrfs f df /media/data
>> >
>> > btrfs f isn't unique; =A0fi is the minimum to specify "filesystem"
>> >
>> I tried even with btrfs filesystem df /media/data
>> and same results.
>
> Does strace give us any clues?
>
According to strace there is inappropriate ioctl for the device.
Here is the log

PS: results are the same for root access

[inglor@woofy ~]$ strace btrfs filesystem df /media/data/
execve("/usr/local/bin/btrfs", ["btrfs", "filesystem", "df",
"/media/data/"], [/* 16 vars */]) =3D 0
brk(0)                                  =3D 0x11ed000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7fd28d424000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D126024, ...}) =3D 0
mmap(NULL, 126024, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7fd28d405000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libuuid.so.1", O_RDONLY)     =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360\25\0\0\0\0\=
0\0"...,
832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D15720, ...}) =3D 0
mmap(NULL, 2110736, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x7fd28d005000
mprotect(0x7fd28d009000, 2093056, PROT_NONE) =3D 0
mmap(0x7fd28d208000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) =3D 0x7fd28d208000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\355\1\0\0\0\0\=
0"...,
832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1432968, ...}) =3D 0
mmap(NULL, 3541032, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x7fd28cca4000
mprotect(0x7fd28cdfc000, 2093056, PROT_NONE) =3D 0
mmap(0x7fd28cffb000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x157000) =3D 0x7fd28cffb000
mmap(0x7fd28d000000, 18472, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x7fd28d000000
close(3)                                =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7fd28d404000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x7fd28d402000
arch_prctl(ARCH_SET_FS, 0x7fd28d402740) =3D 0
mprotect(0x7fd28cffb000, 16384, PROT_READ) =3D 0
mprotect(0x7fd28d426000, 4096, PROT_READ) =3D 0
munmap(0x7fd28d405000, 126024)          =3D 0
brk(0)                                  =3D 0x11ed000
brk(0x120e000)                          =3D 0x120e000
stat("/media/data/", {st_mode=3DS_IFDIR|0755, st_size=3D124, ...}) =3D =
0
open("/media/data/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) =3D 3
fcntl(3, F_GETFD)                       =3D 0x1 (flags FD_CLOEXEC)
ioctl(3, 0xc0109414, 0x11f5620)         =3D -1 ENOTTY (Inappropriate
ioctl for device)


> -chris
>
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
