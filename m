Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQBfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 20:35:54 -0500
Message-ID: <52D888A1.2010305@cn.fujitsu.com>
Date: Fri, 17 Jan 2014 09:34:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: btrfs send ERROR: open <sub> failed. No such file or directory
References: <26459E7D-02A9-4B4A-99AD-3A5432DA5C21@colorremedies.com>
In-Reply-To: <26459E7D-02A9-4B4A-99AD-3A5432DA5C21@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

Some people reported the same issue for btrfs send/receive recently.
I fixed the problem in send[1], but we can still encounter the same 
issue in
receive[2]

And patches have been pused into david's latest integration....:-)

[1] https://patchwork.kernel.org/patch/3258971/
[2] https://patchwork.kernel.org/patch/3369111/

On 01/17/2014 04:20 AM, Chris Murphy wrote:
> kernel-3.13.0-0.rc8.git0.1.fc21.x86_64
>
> # btrfs subvol list / -ta
> 498	5690	5		<FS_TREE>/boot
> 499	5715	5		<FS_TREE>/root
> 500	5717	5		<FS_TREE>/home
>
> boot is mounted at /boot
> root is mounted at /
> home is mounted at /home
> ID5 is mounted at /mnt/toplevel
>
> # btrfs sub create /.snap_ro
> # btrfs sub snaps -r /home /.snap_ro/
> # btrfs subvol list / -ta
> 498	5690	5		<FS_TREE>/boot
> 499	5722	5		<FS_TREE>/root
> 500	5717	5		<FS_TREE>/home
> 501	5717	5		<FS_TREE>/root/.snap_ro
> 503	5717	5		<FS_TREE>/root/.snap_ro/home
>
> # btrfs send /.snap_ro/home/ -f <pathtoothervolume>
> At subvol /.snap_ro/home/
> ERROR: open root/.snap_ro/home failed. No such file or directory
>
> # btrfs send /mnt/toplevel/root/.snap_ro/home/ -f /mnt/isos/testremovedelete.img
>
> This works. So in the first case, /.snap_ <tab> autocompletes to home so it is found, but appears to not be a valid way to do send, instead I had to explicitly use send from the mounted top level. It's a bit confusing.
>
> Strace for failure contains:
> openat(4, "root/.snap_ro/home", O_RDONLY|O_NOATIME) = -1 ENOENT (No such file or directory)
>
> Strace for succeed contains:
> openat(4, "root/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
>
>
>
> Full straces:
>
> For the failure:
>
>
> # strace btrfs send /.snap_ro/home/ -f /mnt/isos/testremovedelete.img
> execve("/usr/sbin/btrfs", ["btrfs", "send", "/.snap_ro/home/", "-f", "/mnt/isos/testremovedelete.img"], [/* 25 vars */]) = 0
> brk(0)                                  = 0x8fa000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00efd000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=76128, ...}) = 0
> mmap(NULL, 76128, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ffa00eea000
> close(3)                                = 0
> open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\25@\2071\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=22624, ...}) = 0
> mmap(0x3187400000, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3187400000
> mprotect(0x3187404000, 2093056, PROT_NONE) = 0
> mmap(0x3187603000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x3187603000
> close(3)                                = 0
> open("/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\205\300}1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=259400, ...}) = 0
> mmap(0x317dc00000, 2349960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317dc00000
> mprotect(0x317dc39000, 2097152, PROT_NONE) = 0
> mmap(0x317de39000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x39000) = 0x317de39000
> mmap(0x317de3d000, 2952, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317de3d000
> close(3)                                = 0
> open("/lib64/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220X\0\1771\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1163072, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00ee9000
> mmap(0x317f000000, 3170648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317f000000
> mprotect(0x317f105000, 2097152, PROT_NONE) = 0
> mmap(0x317f305000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x105000) = 0x317f305000
> close(3)                                = 0
> open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\"\300~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=92560, ...}) = 0
> mmap(0x317ec00000, 2183688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317ec00000
> mprotect(0x317ec15000, 2093056, PROT_NONE) = 0
> mmap(0x317ee14000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x317ee14000
> close(3)                                = 0
> open("/lib64/liblzo2.so.2", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0&\200\37<\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=136872, ...}) = 0
> mmap(0x3c1f800000, 2228456, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3c1f800000
> mprotect(0x3c1f820000, 2093056, PROT_NONE) = 0
> mmap(0x3c1fa1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f000) = 0x3c1fa1f000
> close(3)                                = 0
> open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340m\200~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=150800, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00ee8000
> mmap(0x317e800000, 2213104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317e800000
> mprotect(0x317e818000, 2093056, PROT_NONE) = 0
> mmap(0x317ea17000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x317ea17000
> mmap(0x317ea19000, 13552, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317ea19000
> close(3)                                = 0
> open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\36\2~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=2100656, ...}) = 0
> mmap(0x317e000000, 3924576, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317e000000
> mprotect(0x317e1b4000, 2097152, PROT_NONE) = 0
> mmap(0x317e3b4000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b4000) = 0x317e3b4000
> mmap(0x317e3ba000, 16992, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317e3ba000
> close(3)                                = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00ee7000
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00ee5000
> arch_prctl(ARCH_SET_FS, 0x7ffa00ee5880) = 0
> mprotect(0x662000, 8192, PROT_READ)     = 0
> mprotect(0x3187603000, 4096, PROT_READ) = 0
> mprotect(0x317de39000, 12288, PROT_READ) = 0
> mprotect(0x317f305000, 4096, PROT_READ) = 0
> mprotect(0x317ee14000, 4096, PROT_READ) = 0
> mprotect(0x3c1fa1f000, 4096, PROT_READ) = 0
> mprotect(0x317ea17000, 4096, PROT_READ) = 0
> mprotect(0x317e3b4000, 16384, PROT_READ) = 0
> mprotect(0x317da1f000, 4096, PROT_READ) = 0
> munmap(0x7ffa00eea000, 76128)           = 0
> set_tid_address(0x7ffa00ee5b50)         = 9384
> set_robust_list(0x7ffa00ee5b60, 24)     = 0
> rt_sigaction(SIGRTMIN, {0x317e8068c0, [], SA_RESTORER|SA_SIGINFO, 0x317e80f750}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x317e806950, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x317e80f750}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
> creat("/mnt/isos/testremovedelete.img", 0600) = 3
> ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0x7fff71838b30) = -1 ENOTTY (Inappropriate ioctl for device)
> brk(0)                                  = 0x8fa000
> brk(0x91c000)                           = 0x91c000
> brk(0)                                  = 0x91c000
> lstat("/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> open("/.snap_ro/home", O_RDONLY|O_NOATIME) = 4
> close(4)                                = 0
> open("/proc/mounts", O_RDONLY)          = 4
> futex(0x317e3bb5d0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
> fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00efc000
> read(4, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
> read(4, ",cpuacct cgroup rw,nosuid,nodev,"..., 1024) = 1024
> read(4, "tmpfs /tmp tmpfs rw,seclabel 0 0"..., 1024) = 504
> read(4, "", 1024)                       = 0
> close(4)                                = 0
> munmap(0x7ffa00efc000, 4096)            = 0
> open("/", O_RDONLY|O_NOATIME)           = 4
> lstat("/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> open("/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> close(5)                                = 0
> open("/proc/mounts", O_RDONLY)          = 5
> fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa00efc000
> read(5, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
> read(5, ",cpuacct cgroup rw,nosuid,nodev,"..., 1024) = 1024
> read(5, "tmpfs /tmp tmpfs rw,seclabel 0 0"..., 1024) = 504
> read(5, "", 1024)                       = 0
> close(5)                                = 0
> munmap(0x7ffa00efc000, 4096)            = 0
> openat(4, "/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> ioctl(5, BTRFS_IOC_SUBVOL_GETFLAGS, 0x7fff71838b90) = 0
> close(5)                                = 0
> write(2, "At subvol /.snap_ro/home/\n", 26At subvol /.snap_ro/home/
> ) = 26
> lstat("/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> openat(4, ".snap_ro/home", O_RDONLY)    = 5
> ioctl(5, BTRFS_IOC_INO_LOOKUP, 0x7fff71836930) = 0
> close(5)                                = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71837b50) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71837b50) = 0
> openat(4, "/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> ioctl(5, BTRFS_IOC_SUBVOL_GETFLAGS, 0x7fff71838b90) = 0
> close(5)                                = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71837b70) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71837b70) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71835910) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff718338c0) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff71831870) = 0
> openat(4, "root/.snap_ro/home", O_RDONLY|O_NOATIME) = -1 ENOENT (No such file or directory)
> write(2, "ERROR: open root/.snap_ro/home f"..., 65ERROR: open root/.snap_ro/home failed. No such file or directory
> ) = 65
> close(4)                                = 0
> exit_group(1)                           = ?
> +++ exited with 1 +++
>
>
>
>
>
> For the success:
>
>
>
> strace btrfs send /mnt/toplevel/root/.snap_ro/home/ -f /mnt/isos/testremovedelete.img
> execve("/usr/sbin/btrfs", ["btrfs", "send", "/mnt/toplevel/root/.snap_ro/home"..., "-f", "/mnt/isos/testremovedelete.img"], [/* 25 vars */]) = 0
> brk(0)                                  = 0x1fad000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd64480e000
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=76128, ...}) = 0
> mmap(NULL, 76128, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fd6447fb000
> close(3)                                = 0
> open("/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\25@\2071\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=22624, ...}) = 0
> mmap(0x3187400000, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3187400000
> mprotect(0x3187404000, 2093056, PROT_NONE) = 0
> mmap(0x3187603000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x3187603000
> close(3)                                = 0
> open("/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\205\300}1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=259400, ...}) = 0
> mmap(0x317dc00000, 2349960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317dc00000
> mprotect(0x317dc39000, 2097152, PROT_NONE) = 0
> mmap(0x317de39000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x39000) = 0x317de39000
> mmap(0x317de3d000, 2952, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317de3d000
> close(3)                                = 0
> open("/lib64/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220X\0\1771\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1163072, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd6447fa000
> mmap(0x317f000000, 3170648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317f000000
> mprotect(0x317f105000, 2097152, PROT_NONE) = 0
> mmap(0x317f305000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x105000) = 0x317f305000
> close(3)                                = 0
> open("/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\"\300~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=92560, ...}) = 0
> mmap(0x317ec00000, 2183688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317ec00000
> mprotect(0x317ec15000, 2093056, PROT_NONE) = 0
> mmap(0x317ee14000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14000) = 0x317ee14000
> close(3)                                = 0
> open("/lib64/liblzo2.so.2", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0&\200\37<\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=136872, ...}) = 0
> mmap(0x3c1f800000, 2228456, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3c1f800000
> mprotect(0x3c1f820000, 2093056, PROT_NONE) = 0
> mmap(0x3c1fa1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1f000) = 0x3c1fa1f000
> close(3)                                = 0
> open("/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340m\200~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=150800, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd6447f9000
> mmap(0x317e800000, 2213104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317e800000
> mprotect(0x317e818000, 2093056, PROT_NONE) = 0
> mmap(0x317ea17000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x317ea17000
> mmap(0x317ea19000, 13552, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317ea19000
> close(3)                                = 0
> open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\36\2~1\0\0\0"..., 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=2100656, ...}) = 0
> mmap(0x317e000000, 3924576, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x317e000000
> mprotect(0x317e1b4000, 2097152, PROT_NONE) = 0
> mmap(0x317e3b4000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1b4000) = 0x317e3b4000
> mmap(0x317e3ba000, 16992, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x317e3ba000
> close(3)                                = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd6447f8000
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd6447f6000
> arch_prctl(ARCH_SET_FS, 0x7fd6447f6880) = 0
> mprotect(0x662000, 8192, PROT_READ)     = 0
> mprotect(0x3187603000, 4096, PROT_READ) = 0
> mprotect(0x317de39000, 12288, PROT_READ) = 0
> mprotect(0x317f305000, 4096, PROT_READ) = 0
> mprotect(0x317ee14000, 4096, PROT_READ) = 0
> mprotect(0x3c1fa1f000, 4096, PROT_READ) = 0
> mprotect(0x317ea17000, 4096, PROT_READ) = 0
> mprotect(0x317e3b4000, 16384, PROT_READ) = 0
> mprotect(0x317da1f000, 4096, PROT_READ) = 0
> munmap(0x7fd6447fb000, 76128)           = 0
> set_tid_address(0x7fd6447f6b50)         = 9913
> set_robust_list(0x7fd6447f6b60, 24)     = 0
> rt_sigaction(SIGRTMIN, {0x317e8068c0, [], SA_RESTORER|SA_SIGINFO, 0x317e80f750}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x317e806950, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x317e80f750}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
> creat("/mnt/isos/testremovedelete.img", 0600) = 3
> ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0x7fff2bc78a80) = -1 ENOTTY (Inappropriate ioctl for device)
> brk(0)                                  = 0x1fad000
> brk(0x1fcf000)                          = 0x1fcf000
> brk(0)                                  = 0x1fcf000
> lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
> lstat("/mnt/toplevel", {st_mode=S_IFDIR|0755, st_size=514, ...}) = 0
> lstat("/mnt/toplevel/root", {st_mode=S_IFDIR|0755, st_size=176, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> open("/mnt/toplevel/root/.snap_ro/home", O_RDONLY|O_NOATIME) = 4
> close(4)                                = 0
> open("/proc/mounts", O_RDONLY)          = 4
> futex(0x317e3bb5d0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
> fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd64480d000
> read(4, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
> read(4, ",cpuacct cgroup rw,nosuid,nodev,"..., 1024) = 1024
> read(4, "tmpfs /tmp tmpfs rw,seclabel 0 0"..., 1024) = 504
> read(4, "", 1024)                       = 0
> close(4)                                = 0
> munmap(0x7fd64480d000, 4096)            = 0
> lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
> lstat("/mnt/toplevel", {st_mode=S_IFDIR|0755, st_size=514, ...}) = 0
> open("/mnt/toplevel", O_RDONLY|O_NOATIME) = 4
> lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
> lstat("/mnt/toplevel", {st_mode=S_IFDIR|0755, st_size=514, ...}) = 0
> lstat("/mnt/toplevel/root", {st_mode=S_IFDIR|0755, st_size=176, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> open("/mnt/toplevel/root/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> close(5)                                = 0
> open("/proc/mounts", O_RDONLY)          = 5
> fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fd64480d000
> read(5, "rootfs / rootfs rw,seclabel 0 0\n"..., 1024) = 1024
> read(5, ",cpuacct cgroup rw,nosuid,nodev,"..., 1024) = 1024
> read(5, "tmpfs /tmp tmpfs rw,seclabel 0 0"..., 1024) = 504
> read(5, "", 1024)                       = 0
> close(5)                                = 0
> munmap(0x7fd64480d000, 4096)            = 0
> lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
> lstat("/mnt/toplevel", {st_mode=S_IFDIR|0755, st_size=514, ...}) = 0
> openat(4, "/mnt/toplevel/root/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> ioctl(5, BTRFS_IOC_SUBVOL_GETFLAGS, 0x7fff2bc78ae0) = 0
> close(5)                                = 0
> write(2, "At subvol /mnt/toplevel/root/.sn"..., 44At subvol /mnt/toplevel/root/.snap_ro/home/
> ) = 44
> lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=30, ...}) = 0
> lstat("/mnt/toplevel", {st_mode=S_IFDIR|0755, st_size=514, ...}) = 0
> lstat("/mnt/toplevel/root", {st_mode=S_IFDIR|0755, st_size=176, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro", {st_mode=S_IFDIR|0755, st_size=8, ...}) = 0
> lstat("/mnt/toplevel/root/.snap_ro/home", {st_mode=S_IFDIR|0755, st_size=10, ...}) = 0
> openat(4, "root/.snap_ro/home", O_RDONLY) = 5
> ioctl(5, BTRFS_IOC_INO_LOOKUP, 0x7fff2bc76880) = 0
> close(5)                                = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc77aa0) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc77aa0) = 0
> openat(4, "/mnt/toplevel/root/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> ioctl(5, BTRFS_IOC_SUBVOL_GETFLAGS, 0x7fff2bc78ae0) = 0
> close(5)                                = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc77ac0) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc77ac0) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc75860) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc73810) = 0
> ioctl(4, BTRFS_IOC_TREE_SEARCH, 0x7fff2bc717c0) = 0
> openat(4, "root/.snap_ro/home", O_RDONLY|O_NOATIME) = 5
> pipe([6, 7])                            = 0
> mmap(NULL, 8392704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fd643ff5000
> mprotect(0x7fd643ff5000, 4096, PROT_NONE) = 0
> clone(child_stack=0x7fd6447f4e70, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, parent_tidptr=0x7fd6447f59d0, tls=0x7fd6447f5700, child_tidptr=0x7fd6447f59d0) = 9914
> ioctl(5, BTRFS_IOC_SEND^[[A^[[B, 0x7fff2bc78c10) = 0
> close(7)                                = 0
> futex(0x7fd6447f59d0, FUTEX_WAIT, 9914, NULL) = 0
> close(5)                                = 0
> close(6)                                = 0
> close(4)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
> [root@f20s .snap_ro]#
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

