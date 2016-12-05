Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:35097 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbcLELKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 06:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 5 Dec 2016 12:10:26 +0100
Message-ID: <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 December 2016 at 00:04, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> FWIW I hit this as well:
>
> BUG: unable to handle kernel paging request at ffffffff81ff08b7
> IP: [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30
> CPU: 0 PID: 21744 Comm: trinity-c56 Tainted: G    B           4.9.0-rc7+ #217
[...]

> I think you can rule out btrfs in any case, probably block layer as
> well, since it looks like this comes from shmem.

I should rather say that the VM runs on a 9p root filesystem and it
doesn't use/mount any block devices or disk-based filesystems.

I have all the trinity logs for the crash if that's useful. I tried a
couple of runs with just the (at the time) in-progress syscalls but it
didn't turn up anything interesting. Otherwise it seems like a lot of
data to go through by hand.

The crashing child seems to have just started, though, if that's relevant:

[child56:21744] [0]
open(filename="/sys/block/loop2/power/runtime_active_time",
flags=0x777b01, mode=666) = -1 (Not a directory)
[child56:21744] [1] [32BIT] sched_getattr(pid=1, param=0x7f37ec26c000,
size=3415) = -1 (Invalid argument)
[child56:21744] [2] [32BIT]
access(filename="/proc/2/task/2/net/stat/arp_cache", mode=2000) = -1
(Invalid argument)
[child56:21744] [3] getegid() = 0xfffe
[child56:21744] [4]
swapoff(path="/proc/721/task/721/net/dev_snmp6/tunl0") = -1 (Operation
not permitted)
[child56:21744] [5] timerfd_create(clockid=0x0, flags=0x0) = 439
[child56:21744] [6] pkey_mprotect(start=0x7f37ee656000, len=0,
prot=0x1000008, key=0x600000000000000) = 0
[child56:21744] [7] msync(start=0x7f37ee657000, len=0, flags=0x6) = 0
[child56:21744] [8] flock(fd=168, cmd=0xffffffc191f30b0c) = -1
(Invalid argument)
[child56:21744] [9] add_key(_type=0x437a15,
_description=0x7f37ec06c000, _payload=0x7f37ec06c000, plen=0,
ringid=0xfffffffffffffff8)

The other logfiles end thusly:

==> trinity-child0.log <==
[child0:21593] [311] faccessat(dfd=246,
filename="/proc/983/task/983/net/protocols", mode=2000) = -1 (Invalid
argument)
[child0:21593] [312] renameat(olddfd=246,
oldname="/proc/13/task/13/attr/sockcreate", newdfd=377,
newname="/proc/16/task/16/net/stat/rt_cache") = -1 (Permission denied)
[child0:21593] [313] [32BIT] readv(fd=289, vec=0x2e1a3d0, vlen=215) = 0

==> trinity-child100.log <==
[child100:21536] [439] setgid(gid=0x2a000200) = -1 (Operation not permitted)
[child100:21536] [440] waitid(which=175, upid=21587, infop=0x4,
options=3542, ru=0x7f37ec76c000) = -1 (Invalid argument)
[child100:21536] [441]
getxattr(pathname="/proc/980/task/980/net/ptype", name=0x7f37ee466000,
value=0x7f37ec26c000, size=49) = -1 (Operation not supported)

==> trinity-child101.log <==
[child101:21537] [55] getcwd(buf=0x7f37ee466000, size=4096) = 39
[child101:21537] [56] [32BIT] munlock(addr=0x7f37ee658000, len=0) = 0
[child101:21537] [57] semctl(semid=0xbd851e2b40e7df,
semnum=0x1b1b1b1b1b, cmd=0x2000000000, arg=0xcacacacaca) = -1 (Invalid
argument)

==> trinity-child102.log <==
[child102:21542] [11] readahead(fd=353, offset=2, count=249) = -1
(Invalid argument)
[child102:21542] [12] add_key(_type=0x43793f,
_description=0x7f37ec46c000, _payload=0x7f37ee658000, plen=32,
ringid=0xfffffffffffffffa) = -1 (Invalid argument)
[child102:21542] [13] time(tloc=0x7f37ee466000) = 0x584474e0

==> trinity-child103.log <==
[child103:21543] [45] dup(fildes=183) = 512
[child103:21543] [46] rt_sigpending(set=0x7f37ec86c000, sigsetsize=32)
= -1 (Invalid argument)
[child103:21543] [47] newstat(filename="/proc/587/task/587/gid_map",
statbuf=0x7f37ee466000) = 0

==> trinity-child104.log <==
[child104:21546] [49] getdents(fd=162, dirent=0x0, count=127) = -1
(Not a directory)
[child104:21546] [50] [32BIT] clock_adjtime(which_clock=0, utx=0x4) =
-1 (Bad address)
[child104:21546] [51] setsid() = 0x542a

==> trinity-child105.log <==
[child105:21547] [523] epoll_wait(epfd=244, events=0x8, maxevents=246,
timeout=-1) = -1 (Invalid argument)
[child105:21547] [524] dup2(oldfd=244, newfd=244) = 244
[child105:21547] [525] acct(name=0x7f37ec26c000) = -1 (Operation not permitted)

==> trinity-child106.log <==
[child106:19910] [136] getegid() = 0xfffe
[child106:19910] [137] munmap(addr=0x7f37ee65a000, len=4096) = 0
[child106:19910] [138] clock_nanosleep(which_clock=0x1, flags=0x1,
rqtp=0x7f37ec06c000, rmtp=0x7f37ee466000)
==> trinity-child107.log <==
[child107:21224] [994] copy_file_range(fd_in=373, off_in=0x2400e210,
fd_out=373, off_out=8, len=8, flags=0x0) = -1 (Bad file descriptor)
[child107:21224] [995] kcmp(pid1=1, pid2=21453, type=0x5,
idx1=0x787878787878, idx2=0xffffff6060606060) = -1 (Operation not
permitted)
[child107:21224] [996] [32BIT] readv(fd=365, vec=0x2e27e10, vlen=36) = 0

==> trinity-child108.log <==
[child108:21226] [759] recvfrom(fd=219, ubuf=0x7f37ec26c000, size=8,
flags=0x0, addr=0x2e1ed80, addr_len=110) = -1 (Bad file descriptor)
[child108:21226] [760] shmat(shmid=-4097, shmaddr=0x7f37ee465000,
shmflg=-195) = -1 (Invalid argument)
[child108:21226] [761] [32BIT] seccomp(op=0x0, flags=0x0, uargs=0x0)
==> trinity-child109.log <==
[child109:21552] [241] fremovexattr(fd=133, name=0x4) = -1 (Bad address)
[child109:21552] [242] sched_setattr(pid=0, uattr=0x1) = -1 (Invalid argument)
[child109:21552] [243] msgget(key=0x71717171717171,
msgflg=0xec00000000) = 0x2d805a

==> trinity-child10.log <==
[child10:21619] [120] creat(pathname="/proc/6/attr/fscreate", mode=0) = 521
[child10:21619] [121] [32BIT] sethostname(name=0x7f37ec06c000,
len=4096) = -1 (Operation not permitted)
[child10:21619] [122] add_key(_type=0x43793f,
_description=0x7f37ec66c000, _payload=0x7f37ec06c000, plen=8,
ringid=0xfffffffffffffffe) = -1 (Invalid argument)

==> trinity-child110.log <==
[child110:21554] [289] accept(fd=366, upeer_sockaddr=0x2e09f10,
upeer_addrlen=12) = -1 (Socket operation on non-socket)
[child110:21554] [290] unlinkat(dfd=147,
pathname="/proc/16/task/16/net/atm/br2684", flag=-62) = -1 (Invalid
argument)
[child110:21554] [291] [32BIT] seccomp(op=0x0, flags=0x0, uargs=0x0)
==> trinity-child111.log <==
[child111:21556] [102] getsockname(fd=292, usockaddr=0x2e10190,
usockaddr_len=110) = -1 (Socket operation on non-socket)
[child111:21556] [103] munmap(addr=0x7f37ee65a000, len=4096) = 0
[child111:21556] [104] personality(personality=1) = 0

==> trinity-child112.log <==
[child112:21241] [848] setpgid(pid=21456, pgid=9) = -1 (No such process)
[child112:21241] [849] splice(fd_in=182, off_in=0x7f37ec76c000,
fd_out=182, off_out=0x7f37ec76c008, len=4, flags=0x7) = -1 (Bad file
descriptor)
[child112:21241] [850] setgid(gid=0) = -1 (Operation not permitted)

==> trinity-child113.log <==
[child113:21560] [453] memfd_create(uname=0x7f37ee657000, flag=0x1) = 530
[child113:21560] [454] pwritev2(fd=342, vec=0x2e1e000, vlen=133,
pos_l=0xffffff1d, pos_h=-4, flags=0x0) = -1 (Illegal seek)
[child113:21560] [455] readahead(fd=338, offset=0xe000, count=4096) =
-1 (Invalid argument)

==> trinity-child114.log <==
[child114:21562] [27] [32BIT] getgroups16(gidsetsize=0xf12ec06dec,
grouplist=0x7f37ee465000) = -1 (Bad address)
[child114:21562] [28] keyctl(cmd=0x14, arg2=0xcecececece, arg3=8192,
arg4=0x7cc57bd0d8cf577, arg5=0x898989898989) = -1 (Invalid argument)
[child114:21562] [29] readlink(path="/sys/block/loop1/mq/0/pending",
buf=0x7f37ee467000, bufsiz=0x1565a3aa) = -1 (Invalid argument)

==> trinity-child115.log <==
[child115:21563] [392] eventfd(count=8) = 523
[child115:21563] [393] getegid() = 0xfffe
[child115:21563] [394] open(filename="/proc/587/stat", flags=0x795ac0,
mode=666) = -1 (Invalid argument)

==> trinity-child116.log <==
[child116:21567] [80] mbind(start=0x7f37ee65a000, len=0, mode=0x3,
nmask=0x0, maxnode=0x8000, flags=0x5) = -1 (Operation not permitted)
[child116:21567] [81] flock(fd=357, cmd=0xffffff0fe2220862) = 0
[child116:21567] [82] clock_adjtime(which_clock=15, utx=0x8) = -1
(Invalid argument)

==> trinity-child117.log <==
[child117:21570] [333] pipe(fildes=0x7f37ee466000) = 0
[child117:21570] [334] get_robust_list(pid=21439, head_ptr=0x1,
len_ptr=0x7f37ebc18000) = -1 (Operation not permitted)
[child117:21570] [335] execve(name="/proc/550/net/rt_cache",
argv=0x2e230d0, envp=0x2ba92a0)
==> trinity-child118.log <==
[child118:21572] [455] fstatat64(dfd=244,
filename="/proc/1297/task/1297/fdinfo/110", statbuf=0x8, flag=97) = -1
(Invalid argument)
[child118:21572] [456] flistxattr(fd=244, list=0x7f37ec26c000, size=8) = 0
[child118:21572] [457] ioprio_set(which=0x5d5d5d5d5d5d,
who=0x222734221582, ioprio=0xffffff5b5b5b5b5b) = -1 (Invalid argument)

==> trinity-child119.log <==
[child119:21574] [400] timerfd_create(clockid=0x0, flags=0x0) = 522
[child119:21574] [401] execveat(fd=338, name="/proc/1024/net/can-bcm",
argv=0x2bda9f0, envp=0x2e21130, flags=0x100) = 522
[child119:21574] [402] execveat(fd=244,
name="/sys/devices/platform/serial8250/tty/ttyS3/power/autosuspend_delay_ms",
argv=0x2e09b30, envp=0x2e1d0f0, flags=0x1000)
==> trinity-child11.log <==
[child11:21621] [352]
symlink(oldname="/sys/devices/virtual/sound/timer/uevent",
newname="/proc/549/task/549/net/rpc/auth.unix.gid") = -1 (File exists)
[child11:21621] [353] [32BIT] setgroups16(gidsetsize=0xffffff18,
grouplist=0x8) = -1 (Operation not permitted)
[child11:21621] [354] semtimedop(semid=0x100000de63c0d6e9, tsops=0x4,
nsops=0, timeout=0x8)
==> trinity-child120.log <==
[child120:21578] [141] execveat(fd=147,
name="/proc/2/task/2/net/llc/socket", argv=0x2e0a250, envp=0x2e10190,
flags=0x1000) = -1 (Permission denied)
[child120:21578] [142] readlinkat(dfd=330,
pathname="/sys/devices/virtual/misc/ocfs2_control/power/runtime_active_kids",
buf=0x7f37ee656000, bufsiz=4) = -1 (Invalid argument)
[child120:21578] [143] fremovexattr(fd=330, name=0x7f37ec26c000) = -1
(Permission denied)

==> trinity-child121.log <==
[child121:21263] [586] pread64(fd=237, buf=0x7f37ec76c000, count=3746,
pos=75) = 0
[child121:21263] [587] inotify_add_watch(fd=237,
pathname="/proc/974/task/974/net/atm/pvc", mask=0x5) = -1 (Invalid
argument)
[child121:21263] [588]
removexattr(pathname="/proc/974/task/974/net/sco",
name=0x7f37ec26c000) = -1 (Permission denied)

==> trinity-child122.log <==
[child122:21580] [57] getrusage(who=0x3a2a97385da52b25, ru=0x0) = -1
(Invalid argument)
[child122:21580] [58] getdents(fd=373, dirent=0x1, count=0x6cfbd4f4) =
-1 (Bad file descriptor)
[child122:21580] [59] msgsnd(msqid=-9, msgp=0x8, msgsz=59, msgflg=0x0)
= -1 (Bad address)

==> trinity-child123.log <==
[child123:21582] [289] recvmsg(fd=244, msg=0x7f37ec26c000,
flags=0x5f058) = -1 (Socket operation on non-socket)
[child123:21582] [290] poll(ufds=0x2d25880, nfds=7, timeout_msecs=0) = 5
[child123:21582] [291] getppid() = 1297

==> trinity-child124.log <==
[child124:20960] [493] uname(name=0x7f37ee466000) = 0
[child124:20960] [494] sysfs(option=0x1, arg1=-3,
arg2=0x5982b49806138008) = -1 (Bad address)
[child124:20960] [495]
execve(name="/proc/sys/net/ipv4/neigh/sit0/base_reachable_time_ms",
argv=0x2e122d0, envp=0x2bc95a0)
==> trinity-child125.log <==
[child125:21586] [15] setgroups(gidsetsize=12, grouplist=0x0) = -1
(Operation not permitted)
[child125:21586] [16] [32BIT] oldumount(name=0x7f37ec46c000) = -1
(Operation not permitted)
[child125:21586] [17] utimes(filename="/proc/5/net/anycast6",
utimes=0x8) = -1 (Bad address)

==> trinity-child126.log <==
[child126:21587] [29] shmdt(shmaddr=0x7f37ec66c000) = -1 (Invalid argument)
[child126:21587] [30]
setxattr(pathname="/sys/devices/pci0000:00/0000:00:03.0/net/eth0/power/runtime_active_kids",
name=0x4, value=0x7f37ec46c000, size=0xfffd, flags=0x1) = -1 (Bad
address)
[child126:21587] [31] chroot(filename="/proc/1240/net/hci") = -1 (Not
a directory)

==> trinity-child127.log <==
[child127:21588] [290] clock_gettime(which_clock=6156, tp=0x0) = -1
(Invalid argument)
[child127:21588] [291] statfs(pathname="/proc/1252/net/ipv6_route",
buf=0x7f37ee659000) = 0
[child127:21588] [292] msync(start=0x7f37ee658000, len=0, flags=0x6) = 0

==> trinity-child12.log <==
[child12:21625] [54] getsid(pid=21655) = 0
[child12:21625] [55] mlock2(start=0x7f37ec06c000, len=0x136000) = -1
(Cannot allocate memory)
[child12:21625] [56] dup3(oldfd=180, newfd=180, flags=0x80000) = -1
(Invalid argument)

==> trinity-child13.log <==
[child13:21627] [32] add_key(_type=0x437a15,
_description=0x7f37ee466001, _payload=0x7f37ee466000, plen=0x40000,
ringid=0xfffffffffffffffe) = -1 (Invalid argument)
[child13:21627] [33] mknodat(dfd=243,
filename="/proc/553/task/553/attr/fscreate", mode=0xf63d64273f4d42,
dev=-10) = -1 (Operation not permitted)
[child13:21627] [34] mq_timedreceive(mqdes=328,
u_msg_ptr=0x7f37ee466000, msg_len=0xd1d1d1, u_msg_prio=0x7f37ec06c000,
u_abs_timeout=0x7f37ee466000) = -1 (Invalid argument)

==> trinity-child14.log <==
[child14:21633] [194] msgsnd(msqid=0x4e251795f0, msgp=0x0, msgsz=8,
msgflg=0x0) = -1 (Bad address)
[child14:21633] [195] ppoll(ufds=0x2c4b530, nfds=7, tsp=0x2e09fc0,
sigmask=0x7f37ee465000, sigsetsize=128) = -1 (Invalid argument)
[child14:21633] [196] faccessat(dfd=251,
filename="/proc/15/task/15/net/stat/nf_conntrack", mode=40) = -1
(Invalid argument)

==> trinity-child15.log <==
[child15:21634] [210] timer_gettime(timer_id=1, setting=0x4) = -1
(Invalid argument)
[child15:21634] [211] lgetxattr(pathname="/proc/551/setgroups",
name=0x4, value=0xc, size=1) = -1 (Bad address)
[child15:21634] [212] splice(fd_in=265, off_in=0x7f37ec26c000,
fd_out=265, off_out=0x7f37ec26c008, len=1, flags=0x4) = -1 (Bad file
descriptor)

==> trinity-child16.log <==
[child16:21640] [307]
sched_get_priority_max(policy=0x7fffffff08000000) = -1 (Invalid
argument)
[child16:21640] [308] getcpu(cpup=0x7f37ee465000,
nodep=0x7f37ee465004, unused=0x7f37ee465008) = 0
[child16:21640] [309] sendfile(out_fd=367, in_fd=367, offset=0x0,
count=0) = -1 (Bad file descriptor)

==> trinity-child17.log <==
[child17:21642] [227]
llistxattr(pathname="/proc/16/task/16/net/route", list=0x8, size=4) =
0
[child17:21642] [228] msync(start=0x7f37ec66c000, len=16384, flags=0x6) = 0
[child17:21642] [229] [32BIT]
execve(name="/proc/1024/net/atm/devices", argv=0x2c32e20,
envp=0x2dfb5a0) = 0

==> trinity-child18.log <==
[child18:21644] [55] execve(name="/proc/971/task/971/net/icmp",
argv=0x2d25880, envp=0x2b996a0) = -1 (Permission denied)
[child18:21644] [56] utime(filename="/proc/974/net/raw",
times=0x7f37ee465000) = -1 (Operation not permitted)
[child18:21644] [57] umask(mask=0xfffffff7) = 18

==> trinity-child19.log <==
[child19:21651] [208] [32BIT] move_pages(pid=21604, nr_pages=145,
pages=0x2e1a3d0, nodes=0x2e1b3e0, status=0x2e1b630, flags=0x2) = -1
(Bad address)
[child19:21651] [209] timer_getoverrun(timer_id=-2) = -1 (Invalid argument)
[child19:21651] [210] rename(oldname="/proc/14/cmdline",
newname="/proc/1041/task/1041/net/can/rcvlist_all") = -1 (No such file
or directory)

==> trinity-child1.log <==
[child1:19992] [1361]
lsetxattr(pathname="/proc/1297/task/1297/fdinfo/96", name=0x1,
value=0x7f37ee466000, size=0, flags=0x0) = -1 (Bad address)
[child1:19992] [1362] setgid(gid=0xf0f0f0f0f) = -1 (Operation not permitted)
[child1:19992] [1363] clock_nanosleep(which_clock=0x1, flags=0x0,
rqtp=0x7f37ee659000, rmtp=0x7f37ee465000)
==> trinity-child20.log <==
[child20:21027] [1852] sendto(fd=244, buff=0x2df7410, len=1,
flags=0x800436c8, addr=0x2df7460, addr_len=16) = -1 (Socket operation
on non-socket)
[child20:21027] [1853] setresgid(rgid=0, egid=0x4848, sgid=0xdddddddd)
= -1 (Operation not permitted)
[child20:21027] [1854] poll(ufds=0x2e1fb80, nfds=8, timeout_msecs=0) = 6

==> trinity-child21.log <==
[child21:21330] [663]
statfs(pathname="/sys/block/md0/queue/scheduler", buf=0x7f37ec66c000)
= 0
[child21:21330] [664] sched_setaffinity(pid=1, len=1028,
user_mask_ptr=0x7f37ec46c000) = -1 (Operation not permitted)
[child21:21330] [665] [32BIT] seccomp(op=0x0, flags=0x0, uargs=0x0)
==> trinity-child22.log <==
[child22:21652] [61] pkey_alloc(flags=0, init_val=0x0) = -1 (No space
left on device)
[child22:21652] [62] fsync(fd=330) = 0
[child22:21652] [63] [32BIT] seccomp(op=0x0, flags=0x0, uargs=0x0)
==> trinity-child23.log <==
[child23:21655] [237] sync_file_range(fd=244, offset=191, nbytes=1,
flags=0xffffffffffffff9) = -1 (Invalid argument)
[child23:21655] [238] io_submit(ctx_id=4088, nr=1,
iocbpp=0x7f37ee658000) = -1 (Invalid argument)
[child23:21655] [239] flistxattr(fd=367, list=0x7f37ee656000, size=8)
==> trinity-child24.log <==
[child24:21657] [86] [32BIT] personality(personality=0x3fde3e4912ec) =
0x82604841
[child24:21657] [87]
mkdir(pathname="/proc/924/task/924/net/atalk/interface", mode=0) = -1
(File exists)
[child24:21657] [88] [32BIT] fchownat(dfd=381,
filename="/sys/module/nf_conntrack/parameters/nf_conntrack_helper",
user=0x1804802345, group=0xffffffff, flag=-3) = -1 (Invalid argument)

==> trinity-child25.log <==
[child25:21658] [157] timerfd_settime(ufd=201, flags=0x80800,
utmr=0x1, otmr=0x9) = -1 (Bad address)
[child25:21658] [158] rt_tgsigqueueinfo(tgid=0xc0da20044837,
pid=21330, sig=7099, uinfo=0x7f37ee466000) = -1 (Bad address)
[child25:21658] [159] pkey_mprotect(start=0x7f37ec76c000, len=0x79000,
prot=0x0, key=0x5120a54c676961) = -1 (Invalid argument)

==> trinity-child26.log <==
[child26:21665] [20] fdatasync(fd=217) = -1 (Invalid argument)
[child26:21665] [21] fsetxattr(fd=137, name=0x4, value=0x7f37ec26c000,
size=-9, flags=0x2) = -1 (Bad address)
[child26:21665] [22] open_by_handle_at(mountdirfd=137,
handle=0x7f37ee465000, flags=0x5b33c0) = -1 (Operation not permitted)

==> trinity-child27.log <==
[child27:21668] [190] preadv(fd=381, vec=0x2e1b3e0, vlen=233,
pos_l=0x710702af1dfa, pos_h=0xc976c19d4f) = 0
[child27:21668] [191] [32BIT] mlock(addr=0x7f37ec76c000, len=0xce000)
= -1 (Cannot allocate memory)
[child27:21668] [192] [32BIT] getsockopt(fd=381,
level=0x54100210202640, optname=0x9a9a9a9a9a9a, optval=0x7f37ee466000,
optlen=8) = -1 (Socket operation on non-socket)

==> trinity-child28.log <==
[child28:1813] [202] sched_setscheduler(pid=0, policy=0x5,
param=0x7f37ee465000) = 0
[child28:1813] [203] setresuid(ruid=0x80020293a4aa482, euid=247,
suid=0xffffffff81000002) = -1 (Operation not permitted)
[child28:1813] [204] epoll_ctl(epfd=332, op=0x3, fd=332,
event=0x2e0a150) [child28:1813] [204]
newstat(filename="/proc/9/task/9/net/atalk", statbuf=0x8)
[child28:1813] [204] newstat(filename="/proc/9/task/9/net/atalk",
statbuf=0x8) [child28:1813] [204]
statfs(pathname="/proc/989/task/989/attr/prev", buf=0x7f37ee466000)
[child28:1813] [204] newstat(filename="/proc/9/task/9/net/atalk",
statbuf=0x8) [child28:1813] [204]
statfs(pathname="/proc/989/task/989/attr/prev", buf=0x7f37ee466000)
[child28:1813] [204] timerfd_create(clockid=0x1, flags=0x800)
[child28:1813] [204] newstat(filename="/proc/9/task/9/net/atalk",
statbuf=0x8) [child28:1813] [204]
statfs(pathname="/proc/989/task/989/attr/prev", buf=0x7f37ee466000)
[child28:1813] [204] timerfd_create(clockid=0x1, flags=0x800)
[child28:1813] [204] process_vm_readv(pid=1, lvec=0x2e21d30,
liovcnt=48, rvec=0x2e22040, riovcnt=23, flags=0x0)
==> trinity-child29.log <==
= 0
[child29:1329] [68] [32BIT] getitimer(which=0xfffffffb,
value=0x7f37ee465000) [child29:1329] [68]
setpriority(which=0x8000000000, who=4, niceval=-2) [child29:1329] [68]
rt_sigprocmask(how=-9, set=0x0, oset=0x7f37ee466000, sigsetsize=128) =
-1 (Invalid argument)
[child29:1329] [69] shmat(shmid=0xfffffff9, shmaddr=0x1, shmflg=0x55d10db3)
==> trinity-child2.log <==
[child2:21596] [87] accept4(fd=189, upeer_sockaddr=0x2bda970,
upeer_addrlen=110, flags=0x80800) = -1 (Bad file descriptor)
[child2:21596] [88]
access(filename="/proc/1134/task/1134/net/llc/socket", mode=2060) = -1
(Invalid argument)
[child2:21596] [89] sendfile(out_fd=189, in_fd=172,
offset=0x7f37ee465000, count=4096) = -1 (Bad file descriptor)

==> trinity-child30.log <==
[child30:9344] [334] sendmsg(fd=0, msg=0x2c4b530, flags=0x5ba83) = -1
(Socket operation on non-socket)
[child30:9344] [335] signalfd(ufd=382, user_mask=0x7f37ee65a000,
sizemask=4) = -1 (Invalid argument)
[child30:9344] [336] listen(fd=206, backlog=0x4649119809)
[child30:9344] [336] io_getevents(ctx_id=0x372b076d67, min_nr=0xfff8,
nr=4096, events=0x7f37ec86c000, timeout=0x7f37ee65a000)
==> trinity-child31.log <==
[child31:2333] [416] munlockall() = 0
[child31:2333] [417] fgetxattr(fd=189, name=0x0, value=0x7f37ec76c000,
size=252) = -1 (Bad file descriptor)
[child31:2333] [418] fgetxattr(fd=308, name=0x4, value=0x7f37ec26c000,
size=8) [child31:2333] [418] clock_adjtime(which_clock=15, utx=0x1)
[child31:2333] [418] clock_adjtime(which_clock=15, utx=0x1)
[child31:2333] [418] timer_gettime(timer_id=0xf9f9f9f9f9f9,
setting=0x1) [child31:2333] [418] socket(family=32, type=0x80800,
protocol=10) [child31:2333] [418] socket(family=32, type=0x80800,
protocol=10) [child31:2333] [418] dup2(oldfd=371, newfd=363)
[child31:2333] [418] socket(family=32, type=0x80800, protocol=10)
[child31:2333] [418] dup2(oldfd=371, newfd=363) [child31:2333] [418]
unlink(pathname="/proc/1209/task/1209/net/atm/pvc") [child31:2333]
[418] openat(dfd=213, filename="/proc/971/task/971/net/atm",
flags=0x141a00, mode=712) [child31:2333] [418]
timer_gettime(timer_id=0x900040400186, setting=0x4) [child31:2333]
[418] getxattr(pathname="/proc/1023/net/stat/ndisc_cache",
name=0x7f37ec86c000, value=0x7f37ec86c001, size=259) [child31:2333]
[418] getxattr(pathname="/proc/1023/net/stat/ndisc_cache",
name=0x7f37ec86c000, value=0x7f37ec86c001, size=259) [child31:2333]
[418] open(filename="/sys/module/l2tp_ip", flags=0x80400, mode=211)
[child31:2333] [418] umask(mask=0xa10000004d483090) [child31:2333]
[418] umask(mask=0xa10000004d483090) [child31:2333] [418]
setgroups(gidsetsize=0, grouplist=0x4) [child31:2333] [418]
getgroups(gidsetsize=0xd4d4d4d4d4d4, grouplist=0x8) [child31:2333]
[418] getgroups(gidsetsize=0xd4d4d4d4d4d4, grouplist=0x8)
[child31:2333] [418] io_cancel(ctx_id=0xffffffff00000004,
iocb=0x7f37ee465000, result=0x4fc0000000) [child31:2333] [418]
getgroups(gidsetsize=0xd4d4d4d4d4d4, grouplist=0x8) [child31:2333]
[418] io_cancel(ctx_id=0xffffffff00000004, iocb=0x7f37ee465000,
result=0x4fc0000000) [child31:2333] [418] ioperm(from=221,
num=0x1786c7a03485c3c0, turn_on=176) [child31:2333] [418]
fadvise64(fd=271, offset=0x2afb1db, len=449, advice=0x5)
[child31:2333] [418] getpriority(which=0x1, who=2622) [child31:2333]
[418] signalfd(ufd=285, user_mask=0x7f37ee466000, sizemask=0)
[child31:2333] [418] setresuid(ruid=40, euid=0xffff, suid=-7)
==> trinity-child32.log <==
[child32:21672] [199] getresuid(ruid=0x7f37ec26c000,
euid=0x7f37ee65a000, suid=0x7f37ee465000) = 0
[child32:21672] [200] getrlimit(resource=0xa, rlim=0x4) = -1 (Bad address)
[child32:21672] [201] [32BIT] signalfd(ufd=367,
user_mask=0x7f37ec46c000, sizemask=32)
==> trinity-child33.log <==
[child33:21677] [231] mq_getsetattr(mqdes=244,
u_mqstat=0x7f37ee658000, u_omqstat=0x7f37ee658008) = -1 (Invalid
argument)
[child33:21677] [232] gettid() = 0x54ad
[child33:21677] [233] timer_create(which_clock=161,
timer_event_spec=0x7f37ec86c000, create_timer_id=0x7f37ec86c008)
==> trinity-child34.log <==
[child34:21679] [186] sched_rr_get_interval(pid=0, interval=0x7f37ee466000) = 0
[child34:21679] [187] [32BIT] epoll_pwait(epfd=244,
events=0x7f37ee657000, maxevents=0x40300000a, timeout=562) = -1
(Invalid argument)
[child34:21679] [188] getpriority(which=0x0, who=1)
==> trinity-child35.log <==
[child35:14725] [92] getrandom(buf=0x7f37ee656000, count=0, flags=0x3)
= -1 (Invalid argument)
[child35:14725] [93] setgid(gid=-4) = -1 (Operation not permitted)
[child35:14725] [94] execveat(fd=210, name="/proc/942/net/hidp",
argv=0x2bda970, envp=0x2e10190, flags=0x0) = -1 (Operation not
permitted)

==> trinity-child36.log <==
[child36:21681] [167] sethostname(name=0x7f37ec76c000, len=227) = -1
(Operation not permitted)
[child36:21681] [168] munlock(addr=0x7f37ec86c000, len=0x48000) = 0
[child36:21681] [169] execve(name="/proc/980/task/980/net/udplite",
argv=0x2e0a1a0, envp=0x2e10190)
==> trinity-child37.log <==
[child37:21682] [33] setgid(gid=0x6c6c6c6c) = -1 (Operation not permitted)
[child37:21682] [34] syslog(type=0x3, buf=0x7f37ee656000, len=0) = 0
[child37:21682] [35] pwrite64(fd=335, buf=0x2e204b0, count=1220,
pos=56) = -1 (Bad file descriptor)

==> trinity-child38.log <==
[child38:21689] [107] setpriority(which=0xafafafafafafafaf,
who=0xffffffffffff0000, niceval=0x400000000) = -1 (Invalid argument)
[child38:21689] [108] newstat(filename="/proc/983/cmdline",
statbuf=0x7f37ec66c000) = 0
[child38:21689] [109] mq_getsetattr(mqdes=367, u_mqstat=0x0, u_omqstat=0x0)
==> trinity-child39.log <==
[child39:20422] [556] adjtimex(txc_p=0x7f37ee466000) = -1 (Operation
not permitted)
[child39:20422] [557] ioperm(from=0, num=0xd000, turn_on=55) = -1
(Operation not permitted)
[child39:20422] [558] clock_nanosleep(which_clock=0x2, flags=0x0,
rqtp=0x7f37ec66c000, rmtp=0x7f37ec66c000)
==> trinity-child3.log <==
[child3:21597] [146] prlimit64(pid=1, resource=12, new_rlim=0x4,
old_rlim=0xc) = -1 (Bad address)
[child3:21597] [147] mq_unlink(u_name=0x7f37ec46c000) = -1 (No such
file or directory)
[child3:21597] [148] [32BIT] rt_sigprocmask(how=0x1616161616161617,
set=0x7f37ec76c000, oset=0x7f37ee465000, sigsetsize=128) = -1 (Invalid
argument)

==> trinity-child40.log <==
[child40:21692] [101] getgid() = 0xfffe
[child40:21692] [102]
lsetxattr(pathname="/proc/14/task/14/net/udplite6",
name=0x7f37ee657000, value=0x7f37ee465000, size=4096, flags=0x0) = -1
(Permission denied)
[child40:21692] [103] pwritev2(fd=367, vec=0x2e1a3d0, vlen=92,
pos_l=15, pos_h=0xffa4cdcdd0ee0601, flags=0x5)
==> trinity-child41.log <==
[child41:3589] [16] sched_get_priority_max(policy=0x34000000000000c3)
[child41:3589] [16] timerfd_settime(ufd=308, flags=0x80800,
utmr=0x7f37ec66c000, otmr=0x7f37ee466000) [child41:3589] [16]
timerfd_settime(ufd=326, flags=0x0, utmr=0x7f37ee465000,
otmr=0x7f37ec86c000) = -1 (File exists)
[child41:3589] [16] sched_get_priority_max(policy=0x34000000000000c3)
[child41:3589] [16] timerfd_settime(ufd=308, flags=0x80800,
utmr=0x7f37ec66c000, otmr=0x7f37ee466000) [child41:3589] [16]
timerfd_settime(ufd=326, flags=0x0, utmr=0x7f37ee465000,
otmr=0x7f37ec86c000) [child41:3589] [16]
getresuid(ruid=0x7f37ee467000, euid=0x7f37ee467000,
suid=0x7f37ec06c000) [child41:3589] [16] getrusage(who=0x703a9e50fc,
ru=0x8) [child41:3589] [16] munlockall() = 0
[child41:3589] [17]
chmod(filename="/proc/sys/net/ipv6/route/gc_min_interval", mode=4)
==> trinity-child42.log <==
[child42:21696] [165] getrusage(who=-5, ru=0x0) = -1 (Invalid argument)
[child42:21696] [166] fremovexattr(fd=168, name=0x7f37ee465000) = -1
(Numerical result out of range)
[child42:21696] [167] madvise(start=0x7f37ec06c000, len_in=0xdb000,
advice=0x9) = 0

==> trinity-child43.log <==
[child43:21700] [106] readv(fd=244, vec=0x2e1a3d0, vlen=246) = 0
[child43:21700] [107]
swapoff(path="/sys/devices/virtual/tty/tty26/power/runtime_usage") =
-1 (Operation not permitted)
[child43:21700] [108] linkat(olddfd=244,
oldname="/sys/devices/virtual/workqueue/writeback/nice", newdfd=244,
newname="/proc/1014/net/nfsfs/volumes", flags=0x0) = -1 (File exists)

==> trinity-child44.log <==
[child44:21703] [94] mkdir(pathname="/sys/module/pstore/parameters",
mode=0) = -1 (File exists)
[child44:21703] [95] sendfile(out_fd=367, in_fd=137, offset=0x1,
count=8) = -1 (Bad address)
[child44:21703] [96] [32BIT] sync_file_range(fd=367,
offset=0x707070707, nbytes=0x8000, flags=0xffffefff)
==> trinity-child45.log <==
[child45:21704] [1] fdatasync(fd=381) = -1 (Invalid argument)
[child45:21704] [2] munmap(addr=0x7f37ee656000, len=4096) = 0
[child45:21704] [3] pipe2(fildes=0x7f37ec46c000, flags=0x4800) = 0

==> trinity-child46.log <==
[child46:21705] [82]
rmdir(pathname="/sys/devices/tracepoint/power/runtime_active_kids") =
-1 (Permission denied)
[child46:21705] [83] chroot(filename="/proc/15/task/15/net/tcp") = -1
(Not a directory)
[child46:21705] [84] [32BIT] ioprio_set(which=-2, who=2048,
ioprio=0x646464646464) = -1 (Invalid argument)

==> trinity-child47.log <==
[child47:21710] [127] setrlimit(resource=0x7f37ee465000, rlim=16384) =
-1 (Bad address)
[child47:21710] [128] setns(fd=244, nstype=0x0) = -1 (Invalid argument)
[child47:21710] [129] pkey_alloc(flags=0, init_val=0x2)
==> trinity-child48.log <==
[child48:21717] [39]
access(filename="/proc/10/task/10/net/ip_vs_stats", mode=700) = -1
(Invalid argument)
[child48:21717] [40] [32BIT] sigprocmask(how=233, set=0x7f37ec46c000,
oset=-9) = -1 (Bad address)
[child48:21717] [41] [32BIT] seccomp(op=0x0, flags=0x0, uargs=0x0)
==> trinity-child49.log <==
[child49:21718] [81] sendto(fd=168, buff=0x2e0a540, len=1,
flags=0x41110, addr=0x2ba92a0, addr_len=28) = -1 (Socket operation on
non-socket)
[child49:21718] [82] clock_gettime(which_clock=0x430d4f678edd, tp=0x8)
= -1 (Invalid argument)
[child49:21718] [83] removexattr(pathname="/proc/13/attr/prev",
name=0x7f37ec06c000)
==> trinity-child4.log <==
[child4:21602] [155] getgroups(gidsetsize=0, grouplist=0x1) = 1
[child4:21602] [156] sendmsg(fd=0, msg=0x2c22c50, flags=0x40010883) =
-1 (Socket operation on non-socket)
[child4:21602] [157] fchown(fd=330, user=0x20240098000041,
group=0x20000) = -1 (Operation not permitted)

==> trinity-child50.log <==
[child50:21719] [41] shmctl(shmid=0x4c4c4c4c4c4c4c, cmd=0x2, buf=0x0)
= -1 (Invalid argument)
[child50:21719] [42] timer_delete(timer_id=0x80000000) = -1 (Invalid argument)
[child50:21719] [43] madvise(start=0x7f37ec86c000, len_in=0x20000, advice=0x2)
==> trinity-child51.log <==
[child51:21723] [91] msgctl(msqid=0x9f054e8b21, cmd=0x3,
buf=0x7f37ee466000) = 1763
[child51:21723] [92] time(tloc=0x7f37ee466000) = 0x584474e5
[child51:21723] [93] timer_gettime(timer_id=1, setting=0x7f37ee466000)
==> trinity-child52.log <==
[child52:21728] [70] epoll_ctl(epfd=244, op=0x3, fd=244,
event=0x2e0a2f0) = -1 (Operation not permitted)
[child52:21728] [71] [32BIT] statfs(pathname="/proc/548/net/atm/vc",
buf=0x7f37ec46c000) = -1 (Bad address)
[child52:21728] [72] rt_sigaction(sig=52, act=0x7f37ee465000,
oact=0x7f37ec06c000, sigsetsize=128) = -1 (Invalid argument)

==> trinity-child53.log <==
[child53:21734] [64] lseek(fd=244, offset=0, whence=0x1) = 33
[child53:21734] [65] preadv(fd=244, vec=0x2e10190, vlen=17,
pos_l=0x2714319808dd0822, pos_h=128) = 0
[child53:21734] [66] epoll_create1(flags=0x0) = 516

==> trinity-child54.log <==
[child54:21738] [50] ioprio_get(which=0, who=10023) = -1 (Invalid argument)
[child54:21738] [51] [32BIT] setregid(rgid=0x1000000000000,
egid=0xffff) = -1 (Operation not permitted)
[child54:21738] [52]
execve(name="/proc/1240/net/rpc/auth.rpcsec.context", argv=0x2e10190,
envp=0x2c6bd50)
==> trinity-child55.log <==
[child55:21741] [44] recvmsg(fd=381, msg=0x1, flags=0x20000000) = -1
(Socket operation on non-socket)
[child55:21741] [45] [32BIT] setgroups(gidsetsize=0xf9f9f9f9f9f9f9,
grouplist=0x0) = -1 (Operation not permitted)
[child55:21741] [46] execveat(fd=168, name="/proc/irq/4/smp_affinity",
argv=0x2e10190, envp=0x2e00900, flags=0x100)
==> trinity-child56.log <==
[child56:21744] [7] msync(start=0x7f37ee657000, len=0, flags=0x6) = 0
[child56:21744] [8] flock(fd=168, cmd=0xffffffc191f30b0c) = -1
(Invalid argument)
[child56:21744] [9] add_key(_type=0x437a15,
_description=0x7f37ec06c000, _payload=0x7f37ec06c000, plen=0,
ringid=0xfffffffffffffff8)
==> trinity-child57.log <==
[child57:21746] [12] [32BIT] mq_open(u_name=0x7f37ec86c000,
oflag=8192, mode=2000, u_attr=0x7f37ec86c004) = -1 (Bad address)
[child57:21746] [13] getpgid(pid=21226) = 0x52ea
[child57:21746] [14] execveat(fd=168, name="/proc/1297/task/1297",
argv=0x2bda970, envp=0x2ba92a0, flags=0x0)
==> trinity-child58.log <==
[child58:21749] [33] eventfd2(count=4, flags=0x0) = 441
[child58:21749] [34] mknodat(dfd=244,
filename="/sys/devices/pci0000:00/0000:00:03.0/net/eth0/queues",
mode=0x17104124, dev=0xffffffff0000567f) = -1 (Operation not
permitted)
[child58:21749] [35] clock_getres(which_clock=158, tp=0x4) = -1
(Invalid argument)

==> trinity-child59.log <==
[child59:21754] [21] setfsgid(gid=0x40000000000000) = 0xfffe
[child59:21754] [22] getpgrp() = 0
[child59:21754] [23] ppoll(ufds=0x2e0a5d0, nfds=0, tsp=0x2e0a590,
sigmask=0x0, sigsetsize=128)
==> trinity-child5.log <==
[child5:21604] [287] seccomp(op=0x1, flags=0x0, uargs=0x1) = 0
[child5:21604] [288] rt_sigpending(set=0x7f37ee466000,
sigsetsize=0x2323232323232323) = -1 (Invalid argument)
[child5:21604] [289] getuid() = 0xfffe

==> trinity-child60.log <==
[child60:21758] [0] getsid(pid=1) = 0
[child60:21758] [1] io_cancel(ctx_id=255, iocb=0x7f37ec46c000,
result=0x7f37ec46c000) = -1 (Invalid argument)
[child60:21758] [2] [32BIT] recvmmsg(fd=367, mmsg=0x1, vlen=4,
flags=0x0, timeout=0x7f37ec46c000)
==> trinity-child61.log <==
[child61:21760] [5] open(filename="/proc/1240/net/nfsfs",
flags=0x331702, mode=666) = 444
[child61:21760] [6] recvmmsg(fd=244, mmsg=0x7f37ec66c000, vlen=1,
flags=0x0, timeout=0x7f37ee466000) = -1 (Socket operation on
non-socket)
[child61:21760] [7] swapon(path=".//proc/3/task/3/net/ip_vs_conn/",
swap_flags=0x0)
==> trinity-child62.log <==
[child62:21428] [668] memfd_create(uname=0x7f37ee465000, flag=0x1) = 546
[child62:21428] [669]
newstat(filename="/sys/devices/virtual/net/sit0/statistics/rx_dropped",
statbuf=0x8) = -1 (Bad address)
[child62:21428] [670] [32BIT] sigpending(set=0x7f37ee467000) = -1 (Bad address)

==> trinity-child63.log <==
[child63:21431] [151] getgid() = 0xfffe
[child63:21431] [152] set_mempolicy(mode=0xffffffff, nmask=0x0,
maxnode=0xbbbbbbbbbbbbbbbb) = -1 (Invalid argument)
[child63:21762] [0] ioperm(from=0xb5b5b5b5b5b5b5b6, num=514, turn_on=135)
==> trinity-child64.log <==
[child64:21432] [754] utime(filename="/proc/552/net/can/rcvlist_eff",
times=0x4) = -1 (Bad address)
[child64:21432] [755] fcntl(fd=244, cmd=0x406, arg=244) = 540
[child64:21432] [756] mlock2(start=0x7f37ec06c000, len=0x9d000) = -1
(Cannot allocate memory)

==> trinity-child65.log <==
[child65:21435] [140] timer_create(which_clock=0x10000000,
timer_event_spec=0x1, create_timer_id=0x7f37ec46c000) = -1 (Invalid
argument)
[child65:21435] [141] getpeername(fd=152, usockaddr=0x2e0a1a0,
usockaddr_len=16) = -1 (Socket operation on non-socket)
[child65:21435] [142] ioperm(from=0x54ee6fb85625, num=1, turn_on=128)
= -1 (Invalid argument)

==> trinity-child66.log <==
[child66:21438] [310] msgctl(msqid=0x12121212121212, cmd=0x1,
buf=0x7f37ee465000) = -1 (Invalid argument)
[child66:21438] [311] set_robust_list(head=0x7f37ee658000, len=24) = 0
[child66:21438] [312] msgget(key=0x10000000,
msgflg=0x80000000000000d1) = -1 (Permission denied)

==> trinity-child67.log <==
[child67:21439] [184] pkey_alloc(flags=0, init_val=0x0) = -1 (Invalid argument)
[child67:21439] [185] getpgrp() = 0
[child67:21439] [186] [32BIT] getpgrp() = 0

==> trinity-child68.log <==
[child68:21443] [90] shmdt(shmaddr=0x7f37ee465000) = 0
[child68:21443] [91] remap_file_pages(start=0x7f37ec86c000, size=4096,
prot=0, pgoff=0, flags=0x10000) = 0
[child68:21443] [92] [32BIT] get_mempolicy(policy=0x7f37ee467000,
nmask=0x7f37ee467001, maxnode=147, addr=0x7f37ee466000, flags=0x0) =
-1 (Invalid argument)

==> trinity-child69.log <==
[child69:21444] [283] signalfd(ufd=139, user_mask=0x1, sizemask=8) =
-1 (Invalid argument)
[child69:21444] [284]
utimes(filename="/sys/devices/virtual/tty/tty50/power/runtime_status",
utimes=0x7f37ee465000) = -1 (Invalid argument)
[child69:21444] [285] fremovexattr(fd=139, name=0x7f37ee465000) = -1
(Permission denied)

==> trinity-child6.log <==
[child6:21605] [7] msync(start=0x7f37ee656000, len=0, flags=0x1) = 0
[child6:21605] [8] mq_timedreceive(mqdes=324,
u_msg_ptr=0x7f37ec06c000, msg_len=0x41da, u_msg_prio=0x7f37ee656000,
u_abs_timeout=0x7f37ee657000) = -1 (Bad file descriptor)
[child6:21605] [9] [32BIT] sethostname(name=0x7f37ec76c000,
len=0x85b19) = -1 (Operation not permitted)

==> trinity-child70.log <==
[child70:21447] [654] inotify_init1(flags=0x80000) = 547
[child70:21447] [655] setns(fd=244, nstype=0x0) = -1 (Invalid argument)
[child70:21447] [656] getdents(fd=367, dirent=0x4, count=0)
==> trinity-child71.log <==
[child71:21449] [86] fremovexattr(fd=344, name=0x1) = -1 (Bad address)
[child71:21449] [87] fadvise64(fd=344, offset=0, len=1, advice=0x2) = 0
[child71:21449] [88] [32BIT] fstat64(fd=285, statbuf=0x7f37ee467000) =
-1 (Bad address)

==> trinity-child72.log <==
[child72:21138] [88] [32BIT] pread64(fd=210, buf=0x7f37ec06c000,
count=1361, pos=0) = -1 (Invalid argument)
[child72:21138] [89] clock_settime(which_clock=512, tp=0x7f37ec06c000)
= -1 (Invalid argument)
[child72:21138] [90] mbind(start=0x7f37ec86c000, len=0xf5000,
mode=0x2, nmask=0x1, maxnode=0x8000, flags=0x6) = -1 (Bad address)

==> trinity-child73.log <==
[child73:21141] [706] setrlimit(resource=0x7f37ec26c000,
rlim=0xfffffffd) = -1 (Bad address)
[child73:21141] [707] pwrite64(fd=351, buf=0x2e091a0, count=1,
pos=0xfffd) = -1 (Bad file descriptor)
[child73:21141] [708] time(tloc=0x7f37ee65a000) = 0x584474dd

==> trinity-child74.log <==
[child74:21456] [429] setfsgid(gid=-5) = 0xfffe
[child74:21456] [430] sethostname(name=0x7f37ec26c000, len=8) = -1
(Operation not permitted)
[child74:21456] [431] open(filename="/sys/block/loop2/mq/0/cpu_list",
flags=0x333401, mode=666) = -1 (Not a directory)

==> trinity-child75.log <==
[child75:21458] [578] accept(fd=316, upeer_sockaddr=0x2e240e0,
upeer_addrlen=3729) = -1 (Socket operation on non-socket)
[child75:21458] [579] setxattr(pathname="/sys/block/loop5",
name=0x7f37ec06c000, value=0x7f37ec86c000, size=8, flags=0x1) = -1
(Permission denied)
[child75:21458] [580] sched_setscheduler(pid=0, policy=0x3, param=0x0)
= -1 (Invalid argument)

==> trinity-child76.log <==
[child76:21461] [546] gettimeofday(tv=0x7f37ee465000,
tz=0x7f37ee465004) = -1 (Bad address)
[child76:21461] [547] [32BIT] rt_sigaction(sig=32, act=0x7f37ec46c000,
oact=0x0, sigsetsize=128) = -1 (Invalid argument)
[child76:21461] [548] clock_nanosleep(which_clock=0x2, flags=0x1,
rqtp=0x7f37ee656000, rmtp=0x7f37ec06c000)
==> trinity-child77.log <==
[child77:21465] [73]
swapoff(path="/proc/865/task/865/net/rpc/auth.rpcsec.context") = -1
(Operation not permitted)
[child77:21465] [74] sched_getscheduler(pid=21253) = 0
[child77:21465] [75] [32BIT]
rt_sigtimedwait(uthese=0xba501c1fc77f1f57, uinfo=0x0,
uts=0x7f37ee466000, sigsetsize=0x7f37ee466008) = -1 (Invalid argument)

==> trinity-child78.log <==
[child78:21469] [216] mknod(filename="/proc/1023/net/ip_vs_conn",
mode=1007, dev=0x1b9008e90080) = -1 (No such file or directory)
[child78:21469] [217] geteuid() = 0xfffe
[child78:21469] [218] setsockopt(fd=169, level=0xa49a302c26ea,
optname=51, optval=0x2e1afd0, optlen=0x5bf09058529076) = -1 (Bad file
descriptor)

==> trinity-child79.log <==
[child79:21475] [696] setresuid(ruid=-2, euid=43,
suid=0x7272727272727272) = -1 (Operation not permitted)
[child79:21475] [697] msync(start=0x7f37ee659000, len=0, flags=0x6) = 0
[child79:21475] [698] io_submit(ctx_id=118, nr=8, iocbpp=0x8) = -1
(Invalid argument)

==> trinity-child7.log <==
[child7:21609] [33] prctl(option=22, arg2=2, arg3=0, arg4=0, arg5=0) =
-1 (Bad address)
[child7:21609] [34] userfaultfd(flags=0x800) = 511
[child7:21609] [35] getuid() = 0xfffe

==> trinity-child80.log <==
[child80:21478] [101] settimeofday(tv=0x7f37ec26c000,
tz=0x7f37ec46c000) = -1 (Operation not permitted)
[child80:21478] [102] getdents(fd=330, dirent=0x0, count=56) = -1 (Not
a directory)
[child80:21478] [103] epoll_ctl(epfd=330, op=0x2, fd=330,
event=0x2e0a390) = -1 (Invalid argument)

==> trinity-child81.log <==
[child81:21482] [33] [32BIT] move_pages(pid=0, nr_pages=304,
pages=0x2e19fc0, nodes=0x2e1afd0, status=0x2e1b4a0, flags=0x0) = -1
(Bad address)
[child81:21482] [34] getpriority(which=0x1, who=21008) = 1
[child81:21482] [35] sethostname(name=0x7f37ee659000, len=0x6aeaf512)
= -1 (Operation not permitted)

==> trinity-child82.log <==
[child82:21163] [963] keyctl(cmd=0x2, arg2=0xff00000, arg3=0xc928d000,
arg4=0x400000, arg5=1) = -1 (Invalid argument)
[child82:21163] [964] [32BIT] uselib(library=0x7f37ec46c000) = -1 (Bad address)
[child82:21163] [965] mq_getsetattr(mqdes=226, u_mqstat=0x1,
u_omqstat=0x2) = -1 (Bad address)

==> trinity-child83.log <==
[child83:21486] [531] getrlimit(resource=0xb, rlim=0x7f37ee465000) =
-1 (Bad address)
[child83:21486] [532] gettid() = 0x53ee
[child83:21486] [533] renameat(olddfd=244,
oldname="/proc/1252/net/atalk/socket", newdfd=267,
newname=".//proc/721/net/irda/ircomm") = -1 (Not a directory)

==> trinity-child84.log <==
[child84:21488] [238] mkdir(pathname="/proc/1161/task/1161/mounts",
mode=222) = -1 (File exists)
[child84:21488] [239] capget(header=0x67002320,
dataptr=0xfffaffb7effdfffe) = -1 (Bad address)
[child84:21488] [240]
rmdir(pathname="/sys/devices/virtual/misc/ocfs2_control/power/runtime_active_time")
= -1 (Permission denied)

==> trinity-child85.log <==
[child85:21489] [151] settimeofday(tv=0x7f37ec76c000,
tz=0x7f37ec76c008) = -1 (Invalid argument)
[child85:21489] [152] fstatat64(dfd=365,
filename=".//proc/551/net/ip_vs_conn", statbuf=0x7f37ec26c000,
flag=-2) = -1 (Invalid argument)
[child85:21489] [153] read(fd=365, buf=0x7f37ee466000, count=4096) = 0

==> trinity-child86.log <==
[child86:21496] [39] sched_getaffinity(pid=21349, len=217,
user_mask_ptr=0x4) = -1 (Invalid argument)
[child86:21496] [40] semtimedop(semid=149, tsops=0x7f37ec86c000,
nsops=-1, timeout=0x7f37ec86c000) = -1 (Argument list too long)
[child86:21496] [41] get_robust_list(pid=0, head_ptr=0x7f37ee465000,
len_ptr=0x7f37ec66c000) = 0

==> trinity-child87.log <==
[child87:21500] [517] select(n=0, inp=0x2e12fa0, outp=0x2e13030,
exp=0x2e130c0, tvp=0x2e09740) = 0
[child87:21500] [518] readlink(path="/proc/14/comm", buf=0x1,
bufsiz=223) = -1 (Invalid argument)
[child87:21500] [519] setgid(gid=0) = -1 (Operation not permitted)

==> trinity-child88.log <==
[child88:21502] [523] [32BIT] socketcall(call=1, args=0x2e1b390) = -1
(Address family not supported by protocol)
[child88:21502] [524]
newlstat(filename="/proc/722/task/722/net/rpc/nfs",
statbuf=0x7f37ec76c000) = 0
[child88:21502] [525] mq_unlink(u_name=0x7f37ec06c000)
==> trinity-child89.log <==
[child89:21507] [132] [32BIT] getresuid(ruid=0x7f37ec06c000,
euid=0x7f37ec06c001, suid=0x7f37ec06c005) = -1 (Bad address)
[child89:21507] [133] uname(name=0x7f37ec26c000) = 0
[child89:21507] [134] shutdown(fd=213, how=0x0) = -1 (Bad file descriptor)

==> trinity-child8.log <==
[child8:21610] [211] mlock2(start=0x7f37ec26c000, len=0x95000) = -1
(Cannot allocate memory)
[child8:21610] [212]
removexattr(pathname="/sys/module/zswap/parameters/compressor",
name=0x7f37ec46c000) = -1 (Permission denied)
[child8:21610] [213] socket(family=25, type=2048, protocol=5) = -1
(Address family not supported by protocol)

==> trinity-child90.log <==
[child90:21508] [36] [32BIT]
llistxattr(pathname="/proc/1045/net/protocols", list=0x0, size=-6) = 0
[child90:21508] [37] pipe(fildes=0x7f37ee467000) = 0
[child90:21508] [38] ftruncate(fd=183, length=0xffffffffca1f2000) = -1
(Invalid argument)

==> trinity-child91.log <==
[child91:21514] [28] unlink(pathname="/proc/924/net/netstat") = -1
(Permission denied)
[child91:21514] [29] pivot_root(new_root=0x7f37ee465000,
put_old=0x7f37ec06c000) = -1 (Operation not permitted)
[child91:21514] [30] sched_setscheduler(pid=21410, policy=0x3,
param=0x4) = -1 (Bad address)

==> trinity-child92.log <==
[child92:21517] [444] [32BIT]
chroot(filename="/proc/980/task/980/net/dev_snmp6/sit0") = -1 (Not a
directory)
[child92:21517] [445] syslog(type=0x1, buf=0x7f37ec26c000,
len=0x48000) = -1 (Operation not permitted)
[child92:21517] [446] getrandom(buf=0x7f37ec76c000, count=0x2a000,
flags=0x1) = -1 (Invalid argument)

==> trinity-child93.log <==
[child93:21518] [477] waitid(which=0xffd9, upid=1,
infop=0x7f37ec06c000, options=0x100000, ru=0x7f37ec06c000) = -1
(Invalid argument)
[child93:21518] [478] fchmod(fd=168, mode=0) = -1 (Operation not permitted)
[child93:21518] [479] clock_nanosleep(which_clock=0x2, flags=0x1,
rqtp=0x7f37ec76c000, rmtp=0x7f37ee466000)
==> trinity-child94.log <==
[child94:20875] [1515] access(filename="/proc/567/net/atm/pvc",
mode=5000) = -1 (Invalid argument)
[child94:20875] [1516] seccomp(op=0x1, flags=0x1, uargs=0x4) = -1
(Invalid argument)
[child94:20875] [1517] [32BIT] getuid() = 0xfffe

==> trinity-child95.log <==
[child95:21520] [94] userfaultfd(flags=0x0) = 516
[child95:21520] [95] eventfd(count=153) = 517
[child95:21520] [96] shmat(shmid=0x4000000, shmaddr=0x7f37ee466000,
shmflg=0x3000000000400000) = -1 (Invalid argument)

==> trinity-child96.log <==
[child96:21522] [225] pwritev2(fd=324, vec=0x2e19fc0, vlen=70,
pos_l=0x2727272727, pos_h=255, flags=0x2) = -1 (Illegal seek)
[child96:21522] [226] setfsuid(uid=-8) = 0xfffe
[child96:21522] [227] getdents(fd=324, dirent=0x7f37ec06c000,
count=4096) = -1 (Not a directory)

==> trinity-child97.log <==
[child97:21526] [119] [32BIT]
statfs64(pathname="/proc/545/task/545/net/can/rcvlist_all",
sz=0x8500000000000088) = -1 (Invalid argument)
[child97:21526] [120] pipe2(fildes=0x7f37ee465000, flags=0x0) = 0
[child97:21526] [121]
utimes(filename="/sys/devices/virtual/tty/ircomm4", utimes=0x0) = -1
(Permission denied)

==> trinity-child98.log <==
[child98:21529] [163] setresgid(rgid=20, egid=256,
sgid=0xffffffffffff5252) = -1 (Operation not permitted)
[child98:21529] [164]
llistxattr(pathname="/proc/986/net/dev_snmp6/ip_vti0", list=0x0,
size=4) = 0
[child98:21529] [165] getcpu(cpup=0x7f37ee659000,
nodep=0x7f37ee659008, unused=0x7f37ee659009) = 0

==> trinity-child99.log <==
[child99:21532] [223] sigaltstack(uss=0x7f37ec86c000,
uoss=0x7f37ec86c008, regs=0x7f37ee465000) = -1 (Invalid argument)
[child99:21532] [224] vmsplice(fd=320, iov=0x2e1afd0, nr_segs=1016,
flags=0xb) = -1 (Bad file descriptor)
[child99:21532] [225] [32BIT] setfsgid16(gid=0x2209024001252024) = 0xfffe

==> trinity-child9.log <==
[child9:21616] [294] getuid() = 0xfffe
[child9:21616] [295] fstatfs(fd=244, buf=0x8) = -1 (Bad address)
[child9:21616] [296] mlock2(start=0x7f37ec76c000, len=0xe000) = 0


Vegard
