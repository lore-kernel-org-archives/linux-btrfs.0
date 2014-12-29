Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:52202 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbaL2ByC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 20:54:02 -0500
Message-ID: <54A0B436.4010801@pobox.com>
Date: Sun, 28 Dec 2014 17:53:58 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: fstrim not working on one of three BTRFS filesystems
References: <3979684.puYLD8DjTq@merkaba>
In-Reply-To: <3979684.puYLD8DjTq@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2014 08:58 AM, Martin Steigerwald wrote:
> Hi!
>
> After my recent tests with my /home filesystem and the up and downsizing of
> it I get:
>
>
> merkaba:~> LANG=C fstrim -v /home
> /home: 0 B (0 bytes) trimmed
> merkaba:~> LANG=C fstrim -v /
> /: 24.5 GiB (26257555456 bytes) trimmed
> merkaba:~> LANG=C fstrim -v /daten
> /daten: 2.8 GiB (3016101888 bytes) trimmed
>
>
> The fstrim on /home returns immediately. It does not even seem to trim
> anything. What could be the cause for that?
>
>
>
>
> merkaba:~> btrfs fi sh
> Label: 'debian'  uuid: […]
>          Total devices 2 FS bytes used 17.95GiB
>          devid    1 size 30.00GiB used 30.00GiB path /dev/mapper/sata-debian
>          devid    2 size 30.00GiB used 30.00GiB path /dev/mapper/msata-debian
>
> Label: 'daten'  uuid: […]
>          Total devices 1 FS bytes used 191.20GiB
>          devid    1 size 220.00GiB used 194.02GiB path /dev/mapper/msata-daten
>
> Label: 'home'  uuid: […]
>          Total devices 2 FS bytes used 151.13GiB
>          devid    1 size 170.00GiB used 161.85GiB path /dev/mapper/msata-home
>          devid    2 size 170.00GiB used 161.85GiB path /dev/mapper/sata-home
>
> Label: none  uuid: […]
>          Total devices 2 FS bytes used 512.00KiB
>          devid    1 size 10.00GiB used 6.53GiB path /dev/mapper/sata-btrfsraid1
>          devid    2 size 10.00GiB used 6.53GiB path /dev/mapper/msata-btrfsraid1
>
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=156.89GiB, used=147.87GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=4.94GiB, used=3.26GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.99GiB, used=17.37GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=597.31MiB
> GlobalReserve, single: total=208.00MiB, used=0.00B
> merkaba:~> btrfs fi df /daten
> Data, single: total=193.01GiB, used=190.90GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=1.01GiB, used=306.44MiB
> GlobalReserve, single: total=112.00MiB, used=0.00B
>
>
> As far as I understand it should try to trim the free space in
>
> Data, RAID1: total=156.89GiB, used=147.87GiB
>
> like it does for the others.
>
>
>
>
> This is the strace of the 0-byte fstrim:
>
> merkaba:~> LANG=C strace -f fstrim -v /home
> execve("/sbin/fstrim", ["fstrim", "-v", "/home"], [/* 21 vars */]) = 0
> brk(0)                                  = 0x1ee5000
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78bc5000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=253940, ...}) = 0
> mmap(NULL, 253940, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4f78b87000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libmount.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\254\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=284096, ...}) = 0
> mmap(NULL, 2383648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f78761000
> mprotect(0x7f4f787a4000, 2097152, PROT_NONE) = 0
> mmap(0x7f4f789a4000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x43000) = 0x7f4f789a4000
> mmap(0x7f4f789a6000, 3872, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4f789a6000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\34\2\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1729984, ...}) = 0
> mmap(NULL, 3836448, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f783b8000
> mprotect(0x7f4f78557000, 2097152, PROT_NONE) = 0
> mmap(0x7f4f78757000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19f000) = 0x7f4f78757000
> mmap(0x7f4f7875d000, 14880, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4f7875d000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\210\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=258688, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78b86000
> mmap(NULL, 2358248, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f78178000
> mprotect(0x7f4f781b3000, 2097152, PROT_NONE) = 0
> mmap(0x7f4f783b3000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3b000) = 0x7f4f783b3000
> mmap(0x7f4f783b7000, 3048, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4f783b7000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20c\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=142728, ...}) = 0
> mmap(NULL, 2246896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f77f53000
> mprotect(0x7f4f77f74000, 2097152, PROT_NONE) = 0
> mmap(0x7f4f78174000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x21000) = 0x7f4f78174000
> mmap(0x7f4f78176000, 6384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4f78176000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \26\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=18904, ...}) = 0
> mmap(NULL, 2113952, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f77d4e000
> mprotect(0x7f4f77d52000, 2093056, PROT_NONE) = 0
> mmap(0x7f4f77f51000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f4f77f51000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libpcre.so.3", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\27\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=448440, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78b85000
> mmap(NULL, 2543976, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f77ae0000
> mprotect(0x7f4f77b4c000, 2097152, PROT_NONE) = 0
> mmap(0x7f4f77d4c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6c000) = 0x7f4f77d4c000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\16\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0644, st_size=14664, ...}) = 0
> mmap(NULL, 2109712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f778dc000
> mprotect(0x7f4f778df000, 2093056, PROT_NONE) = 0
> mmap(0x7f4f77ade000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f4f77ade000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20o\0\0\0\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=137440, ...}) = 0
> mmap(NULL, 2213008, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f4f776bf000
> mprotect(0x7f4f776d7000, 2093056, PROT_NONE) = 0
> mmap(0x7f4f778d6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f4f778d6000
> mmap(0x7f4f778d8000, 13456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4f778d8000
> close(3)                                = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78b84000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78b83000
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78b81000
> arch_prctl(ARCH_SET_FS, 0x7f4f78b81840) = 0
> mprotect(0x7f4f78757000, 16384, PROT_READ) = 0
> mprotect(0x7f4f778d6000, 4096, PROT_READ) = 0
> mprotect(0x7f4f77ade000, 4096, PROT_READ) = 0
> mprotect(0x7f4f77d4c000, 4096, PROT_READ) = 0
> mprotect(0x7f4f77f51000, 4096, PROT_READ) = 0
> mprotect(0x7f4f78174000, 4096, PROT_READ) = 0
> mprotect(0x7f4f783b3000, 12288, PROT_READ) = 0
> mprotect(0x7f4f789a4000, 4096, PROT_READ) = 0
> mprotect(0x607000, 4096, PROT_READ)     = 0
> mprotect(0x7f4f78bc7000, 4096, PROT_READ) = 0
> munmap(0x7f4f78b87000, 253940)          = 0
> set_tid_address(0x7f4f78b81b10)         = 3122
> set_robust_list(0x7f4f78b81b20, 24)     = 0
> rt_sigaction(SIGRTMIN, {0x7f4f776c59f0, [], SA_RESTORER|SA_SIGINFO, 0x7f4f776ce8d0}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x7f4f776c5a80, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f4f776ce8d0}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
> statfs("/sys/fs/selinux", 0x7fffaec07ac0) = -1 ENOENT (No such file or directory)
> statfs("/selinux", 0x7fffaec07ac0)      = -1 ENOENT (No such file or directory)
> brk(0)                                  = 0x1ee5000
> brk(0x1f06000)                          = 0x1f06000
> open("/proc/filesystems", O_RDONLY)     = 3
> fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78bc4000
> read(3, "nodev\tsysfs\nnodev\trootfs\nnodev\tr"..., 1024) = 329
> read(3, "", 1024)                       = 0
> close(3)                                = 0
> munmap(0x7f4f78bc4000, 4096)            = 0
> open("/home", O_RDONLY)                 = 3
> fstat(3, {st_mode=S_IFDIR|0755, st_size=124, ...}) = 0
> ioctl(3, FITRIM, 0x7fffaec07970)        = 0
> fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4f78bc4000
> write(1, "/home: 0 B (0 bytes) trimmed\n", 29/home: 0 B (0 bytes) trimmed
> ) = 29
> close(3)                                = 0
> close(1)                                = 0
> munmap(0x7f4f78bc4000, 4096)            = 0
> close(2)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
>
>
> There is nothing in dmesg about this.
>
> Thanks,
>

If you let that fallocate test loop (see prior emails) run for a long 
time in that filesystem, you might be in an odd state.

When I run that here my "data used" doesn't change but the amount of 
data I can fstrim does.

Gust Work # fstrim --all --verbose
/mnt/Work: 623.2 MiB (653516800 bytes) trimmed
Gust Work # while     touch ${TESTDIR}/$((++counter)) &&     fallocate 
-n -l $((4096 + $RANDOM)) $TESTDIR/$((counter));   do     if 
((counter%100 == 0));     then       echo $counter; if 
((counter%1000==0)); then btrfs fi df /mnt/Work; fi;    fi;   done
313500
313600
313700
313800
313900
314000
Data, RAID1: total=1.72GiB, used=1.64GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=58.08MiB
GlobalReserve, single: total=32.00MiB, used=0.00B
314100
314200
314300
314400
314500
314600
314700
314800
314900
315000
Data, RAID1: total=1.72GiB, used=1.64GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=58.08MiB
GlobalReserve, single: total=32.00MiB, used=0.00B
^C
Gust Work # fstrim --all --verbose
/mnt/Work: 622.8 MiB (652992512 bytes) trimmed


None of those results make good sense to me but I might be missing 
something.

I could re-harmonize the results by unmounting and remounting the 
filesystem. In a long run I got the fstrim down to ~300MiB and an 
unmount and mount brought it right back to 625. In this case, I got back 
from 622 to 625... e.g.

Gust Work # fstrim --all --verbose
/mnt/Work: 622.8 MiB (652992512 bytes) trimmed
Gust Work # umount /mnt/Work
umount: /mnt/Work: target is busy
         (In some cases useful info about processes that
          use the device is found by lsof(8) or fuser(1).)
Gust Work # cd
Gust ~ # umount /mnt/Work
Gust ~ # mount /dev/loop0 /mnt/Work
Gust ~ # fstrim --all --verbose
/mnt/Work: 625 MiB (655335424 bytes) trimmed


So "fishy" but possibly related to free space caching limitations or 
something.

Given the failure of the Data: line to change during massive fallocate 
activities I suspect there is something off in there somewhere but I 
don't have enough information to quantify what's happening.
