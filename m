From: Roman Mamedov <rm@romanrm.ru>
Subject: mkfs.btrfs fails on ARM
Date: Thu, 16 Feb 2012 22:08:11 +0600
Message-ID: <20120216220811.534cbf02@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fJnoL.qfuXeerND9unBdk2E"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fJnoL.qfuXeerND9unBdk2E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

mkfs.btrfs does not seem to work on ARM at the moment.

Linux mahou 3.2.2orion5x-rm1+ #3 Mon Jan 30 19:29:49 YEKT 2012 armv5tel GNU=
/Linux
btrfs-tools 0.19+20111105-2 from Debian.

# free
             total       used       free     shared    buffers     cached
Mem:         60364      49200      11164          0       5528      27868
-/+ buffers/cache:      15804      44560
Swap:       262140       2488     259652

On a 20 GB loop device:

# mkfs.btrfs /dev/loop7=20

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

mkfs.btrfs: volumes.c:1575: btrfs_read_chunk_tree: Assertion `!(ret)' faile=
d.
Aborted


# mkfs.btrfs -s 4096 -n 4096 -l 4096 /dev/loop7=20

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

mkfs.btrfs: volumes.c:1575: btrfs_read_chunk_tree: Assertion `!(ret)' faile=
d.
Aborted


# strace mkfs.btrfs /dev/loop7=20
execve("/sbin/mkfs.btrfs", ["mkfs.btrfs", "/dev/loop7"], [/* 14 vars */]) =
=3D 0
brk(0)                                  =3D 0x16fb000
uname({sys=3D"Linux", node=3D"mahou", ...}) =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x4003d000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D14740, ...}) =3D 0
mmap2(NULL, 14740, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x40095000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/libuuid.so.1", O_RDONLY)     =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0008\21\0\0004\0\0\0"=
..., 512) =3D 512
lseek(3, 13908, SEEK_SET)               =3D 13908
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 1160) =3D 1160
lseek(3, 13616, SEEK_SET)               =3D 13616
read(3, "A+\0\0\0aeabi\0\1!\0\0\0\0054T\0\6\2\10\1\t\1\22\4\24\1\25\1"..., =
44) =3D 44
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D15068, ...}) =3D 0
mmap2(NULL, 46404, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x400ee000
mprotect(0x400f2000, 28672, PROT_NONE)  =3D 0
mmap2(0x400f9000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DEN=
YWRITE, 3, 0x3) =3D 0x400f9000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/arm-linux-gnueabi/libcom_err.so.2", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0X\17\0\0004\0\0\0"..=
., 512) =3D 512
lseek(3, 10380, SEEK_SET)               =3D 10380
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 1080) =3D 1080
lseek(3, 10076, SEEK_SET)               =3D 10076
read(3, "A1\0\0\0aeabi\0\1'\0\0\0\5ARM9TDMI\0\6\2\10\1\t\1"..., 50) =3D 50
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D11460, ...}) =3D 0
mmap2(NULL, 42896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x4003e000
mprotect(0x40041000, 28672, PROT_NONE)  =3D 0
mmap2(0x40048000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DEN=
YWRITE, 3, 0x2) =3D 0x40048000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/arm-linux-gnueabi/libgcc_s.so.1", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0T-\0\0004\0\0\0"...,=
 512) =3D 512
lseek(3, 44760, SEEK_SET)               =3D 44760
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 1160) =3D 1160
lseek(3, 44436, SEEK_SET)               =3D 44436
read(3, "A+\0\0\0aeabi\0\1!\0\0\0\0054T\0\6\2\10\1\t\1\22\4\24\1\25\1"..., =
44) =3D 44
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x40049000
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D45920, ...}) =3D 0
mmap2(NULL, 77260, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x40127000
mprotect(0x40132000, 28672, PROT_NONE)  =3D 0
mmap2(0x40139000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DEN=
YWRITE, 3, 0xa) =3D 0x40139000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/arm-linux-gnueabi/libc.so.6", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0,X\1\0004\0\0\0"...,=
 512) =3D 512
lseek(3, 1211156, SEEK_SET)             =3D 1211156
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 1400) =3D 1400
lseek(3, 1210716, SEEK_SET)             =3D 1210716
read(3, "A'\0\0\0aeabi\0\1\35\0\0\0\0054T\0\6\2\10\1\t\1\22\4\24\1\25\1"...=
, 40) =3D 40
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1212556, ...}) =3D 0
mmap2(NULL, 1254672, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x4013a000
mprotect(0x4025f000, 32768, PROT_NONE)  =3D 0
mmap2(0x40267000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DE=
NYWRITE, 3, 0x125) =3D 0x40267000
mmap2(0x4026a000, 9488, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANO=
NYMOUS, -1, 0) =3D 0x4026a000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/arm-linux-gnueabi/libpthread.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0DE\0\0004\0\0\0"...,=
 512) =3D 512
lseek(3, 86800, SEEK_SET)               =3D 86800
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 1400) =3D 1400
lseek(3, 86404, SEEK_SET)               =3D 86404
read(3, "A)\0\0\0aeabi\0\1\37\0\0\0\0054T\0\6\2\10\1\t\1\22\4\24\1\25\1"...=
, 42) =3D 42
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D119869, ...}) =3D 0
mmap2(NULL, 127508, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x400fa000
mprotect(0x4010f000, 28672, PROT_NONE)  =3D 0
mmap2(0x40116000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DEN=
YWRITE, 3, 0x14) =3D 0x40116000
mmap2(0x40118000, 4628, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANO=
NYMOUS, -1, 0) =3D 0x40118000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x4002f000
set_tls(0x4002f4c0, 0x4002fbe7, 0x4002fbe8, 0x4002f4c0, 0x400d3000) =3D 0
mprotect(0x40116000, 4096, PROT_READ)   =3D 0
mprotect(0x40267000, 8192, PROT_READ)   =3D 0
mprotect(0x400d2000, 4096, PROT_READ)   =3D 0
munmap(0x40095000, 14740)               =3D 0
set_tid_address(0x4002f068)             =3D 1962
set_robust_list(0x4002f070, 0xc)        =3D 0
futex(0xbef82d24, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, =
40117000) =3D -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0x400fe44c, [], SA_SIGINFO|0x4000000}, NULL, 8) =3D=
 0
rt_sigaction(SIGRT_1, {0x400fe2ec, [], SA_RESTART|SA_SIGINFO|0x4000000}, NU=
LL, 8) =3D 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) =3D 0
getrlimit(RLIMIT_STACK, {rlim_cur=3D8192*1024, rlim_max=3DRLIM_INFINITY}) =
=3D 0
fstat64(1, {st_mode=3DS_IFCHR|0600, st_rdev=3Dmakedev(136, 0), ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x4009b000
write(1, "\n", 1
)                       =3D 1
write(1, "WARNING! - Btrfs Btrfs v0.19 IS "..., 45WARNING! - Btrfs Btrfs v0=
.19 IS EXPERIMENTAL
) =3D 45
write(1, "WARNING! - see http://btrfs.wiki"..., 57WARNING! - see http://btr=
fs.wiki.kernel.org before using
) =3D 57
write(1, "\n", 1
)                       =3D 1
open("/dev/loop7", O_RDONLY|O_LARGEFILE) =3D 3
brk(0)                                  =3D 0x16fb000
brk(0x171d000)                          =3D 0x171d000
pread(3, "Z\331l\274\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0"..., 3531, 281474976710656) =3D 3531
pread(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"=
..., 3531, 288230376151711744) =3D 3531
pread(3, "", 3531, 0)                   =3D 0
open("/proc/mounts", O_RDONLY)          =3D 4
futex(0x4026ab84, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
fstat64(4, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x4026d000
read(4, "rootfs / rootfs rw 0 0\nsysfs /sy"..., 1024) =3D 846
read(4, "", 1024)                       =3D 0
close(4)                                =3D 0
munmap(0x4026d000, 4096)                =3D 0
close(3)                                =3D 0
open("/dev/loop7", O_RDWR|O_LARGEFILE)  =3D 3
fstat64(3, {st_mode=3DS_IFBLK|S_ISVTX|0660, st_rdev=3Dmakedev(7, 7), ...}) =
=3D 0
ioctl(3, BLKGETSIZE64, 0xbef82768)      =3D 0
ioctl(3, BLKDISCARD, 0xbef82758)        =3D 0
mmap2(NULL, 2101248, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0x4026d000
pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
"..., 2097152, 0) =3D 2097152
munmap(0x4026d000, 2101248)             =3D 0
pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
"..., 4096, 281474976710656) =3D 4096
pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
"..., 4096, 288230376151711744) =3D 4096
mmap2(NULL, 2101248, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0x4026d000
pwrite(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
"..., 2097152, 18437736874454810624) =3D 2097152
munmap(0x4026d000, 2101248)             =3D 0
gettimeofday({1329408373, 91714}, NULL) =3D 0
open("/dev/urandom", O_RDONLY|O_LARGEFILE) =3D 4
fcntl64(4, F_GETFD)                     =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getuid32()                              =3D 0
getppid()                               =3D 1961
gettimeofday({1329408373, 107503}, NULL) =3D 0
gettimeofday({1329408373, 109189}, NULL) =3D 0
read(4, "\37J/\2279'D\247\0104\23\6:\313\271?", 16) =3D 16
gettid()                                =3D 1962
gettimeofday({1329408373, 115493}, NULL) =3D 0
gettimeofday({1329408373, 117238}, NULL) =3D 0
read(4, "\313\342\233\310\35\254\256uu\354\325L\204\2\250v", 16) =3D 16
gettid()                                =3D 1962
gettimeofday({1329408373, 122574}, NULL) =3D 0
gettimeofday({1329408373, 124306}, NULL) =3D 0
read(4, "i\317i\263\357\216\0238\r\31\373\340\260\t\314_", 16) =3D 16
gettid()                                =3D 1962
pwrite(3, "\261\241Y\304\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0"..., 4096, 4802666790125568) =3D 4096
pwrite(3, "mB\251\233\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0"..., 4096, 4820258976169984) =3D 4096
pwrite(3, "g}`k\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...=
, 4096, 4837851162214400) =3D 4096
pwrite(3, "\212\232?>\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0"..., 4096, 4855443348258816) =3D 4096
pwrite(3, "\5\374\240\24\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0"..., 4096, 4873035534303232) =3D 4096
pwrite(3, "\334\275\307p\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0"..., 4096, 4890627720347648) =3D 4096
pwrite(3, "\340\213&G\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0"..., 4096, 281474976710656) =3D 4096
open("/dev/loop7", O_RDWR|O_CREAT|O_LARGEFILE, 0600) =3D 5
pread(5, "\340\213&G\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0"..., 3531, 281474976710656) =3D 3531
pread(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"=
..., 3531, 288230376151711744) =3D 3531
pread(5, "", 3531, 0)                   =3D 0
open("/dev/loop7", O_RDWR|O_LARGEFILE)  =3D 6
pread(6, "\340\213&G\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0"..., 3531, 281474976710656) =3D 3531
pread(6, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"=
..., 3531, 288230376151711744) =3D 3531
pread(6, "", 3531, 0)                   =3D 0
pread(6, "g}`k\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,=
 4096, 4837851162214400) =3D 4096
write(2, "mkfs.btrfs: volumes.c:1575: btrf"..., 78mkfs.btrfs: volumes.c:157=
5: btrfs_read_chunk_tree: Assertion `!(ret)' failed.
) =3D 78
rt_sigprocmask(SIG_UNBLOCK, [ABRT], NULL, 8) =3D 0
tgkill(1962, 1962, SIGABRT)             =3D 0
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++
Aborted




--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/fJnoL.qfuXeerND9unBdk2E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk89KesACgkQTLKSvz+PZwh8oACeO2gImA9tAdUiw6Ko3JK8hjbd
lOsAn0//7SJWJ87SGKR5+Z6M1qaiy6CT
=J3zg
-----END PGP SIGNATURE-----

--Sig_/fJnoL.qfuXeerND9unBdk2E--
