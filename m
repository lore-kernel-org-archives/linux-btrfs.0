From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Wed, 2 Feb 2011 00:34:43 +0100
Message-ID: <201102020034.43808.johannes.hirte@fem.tu-ilmenau.de>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Maria =?utf-8?q?Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 28 January 2011 04:53:24 Zhong, Xin wrote:
> Could you describe the steps to recreate it?
> It will be a great help for me to look further. Thanks!

It's a little strange. I have to systems with btrfs, both Gentoo-based. One is 
affected by this bug the other is not. On the affected system it is enough to do 
a 'emerge dev-libs/libgcrypt' that should normaly compile and install 
libgcrypt. The emerge command is part of portage, the package management of 
Gentoo. 
The strace output looks similar to the one from Maria:

open("/home/tmp/portage/dev-libs/libgcrypt-1.4.6/.ipc_in", O_RDONLY|
O_NONBLOCK|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFIFO|0770, st_size=0, ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0xbff5f678) = -1 EINVAL (Invalid argument)
open("/dev/ptmx", O_RDWR)               = 5
ioctl(5, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(5, TIOCGPTN, [2])                 = 0
stat64("/dev/pts/2", {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
getuid32()                              = 0
ioctl(5, TIOCSPTLCK, [0])               = 0
ioctl(5, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(5, TIOCGPTN, [2])                 = 0
stat64("/dev/pts/2", {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
open("/dev/pts/2", O_RDWR|O_NOCTTY)     = 6
ioctl(6, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(6, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(6, SNDCTL_TMR_START or SNDRV_TIMER_IOCTL_TREAD or TCSETS, {B38400 -opost 
isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
stat64("/root/.terminfo", 0xbff5e790)   = -1 ENOENT (No such file or directory)
stat64("/etc/terminfo", {st_mode=S_IFDIR|0755, st_size=14, ...}) = 0
access("/etc/terminfo/x/xterm", R_OK)   = 0
open("/etc/terminfo/x/xterm", O_RDONLY|O_LARGEFILE) = 7
read(7, "\32\0010\0&\0\17\0\235\1l\5xterm|xterm terminal"..., 4097) = 3258
close(7)                                = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=40, ws_col=207, ws_xpixel=0, ws_ypixel=0}) = 0
access("/usr/local/sbin/stty", X_OK)    = -1 ENOENT (No such file or directory)
access("/usr/local/bin/stty", X_OK)     = -1 ENOENT (No such file or directory)
access("/usr/sbin/stty", X_OK)          = -1 ENOENT (No such file or directory)
access("/usr/bin/stty", X_OK)           = -1 ENOENT (No such file or directory)
access("/sbin/stty", X_OK)              = -1 ENOENT (No such file or directory)
access("/bin/stty", X_OK)               = 0
stat64("/bin/stty", {st_mode=S_IFREG|0755, st_size=58836, ...}) = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0xb753d728) = 2752
waitpid(2752, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0) = 2752
--- SIGCHLD (Child exited) @ 0 (0) ---
fcntl64(5, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(5, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
fstat64(5, {st_mode=S_IFCHR|0666, st_rdev=makedev(5, 2), ...}) = 0
ioctl(5, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 -opost isig icanon echo ...}) = 0
open("/home/tmp/portage/dev-libs/libgcrypt-1.4.6/temp/build.log", O_WRONLY|
O_CREAT|O_APPEND|O_LARGEFILE, 0666) = 7
fstat64(7, {st_mode=S_IFREG|0660, st_size=480, ...}) = 0
_llseek(7, 0, [480], SEEK_END)          = 0
ioctl(7, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0xbff5fad8) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(7, {st_mode=S_IFREG|0660, st_size=480, ...}) = 0
_llseek(7, 0, [480], SEEK_CUR)          = 0
stat64("/home/tmp/portage/dev-libs/libgcrypt-1.4.6/temp/build.log", 
{st_mode=S_IFREG|0660, st_size=480, ...}) = 0
dup(1)                                  = 8
fstat64(8, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
ioctl(8, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
{B38400 opost isig icanon echo ...}) = 0
fstat64(8, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
_llseek(8, 0, 0xbff5f820, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
stat64("/home/tmp/portage/dev-libs/libgcrypt-1.4.6/temp/environment", 
{st_mode=S_IFREG|0664, st_size=106597, ...}) = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0xb753d728) = 2753
close(6)                                = 0
gettimeofday({1296577457, 11117}, NULL) = 0
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 1 ([{fd=5, revents=POLLIN}])
read(5, ">>> Preparing source in /home/tm"..., 4096) = 92
write(8, ">>> Preparing source in /home/tm"..., 92) = 92
write(7, ">>> Preparing source in /home/tm"..., 92) = 92
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000) = 0 (Timeout)
poll([{fd=3, events=POLLIN|POLLERR|POLLHUP|POLLNVAL}, {fd=5, events=POLLIN|
POLLERR|POLLHUP|POLLNVAL}], 2, 3000 <unfinished ...>

