From: "Helmut Hullen" <Hullen@t-online.de>
Subject: scrub: Inappropriate ioctl for device
Date: 01 Nov 2011 20:36:00 +0100
Message-ID: <Bx1FpyLi1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I'm just playing with "btrfs scrub".

Kernel 3.1 (self made)
btrfs integration-20111030 (Hugo Mills)

I have a bundle of 3 2-TByte-disks (data raid0, metadata raid1).

Since some (few) weeks one of the disks makes errors (I've reported the  
problems in this mailing list).

The bundle uses the devices /dev/sdb1, /dev/sdc1 and /dev/sdg1, "btrfs  
filesystem show" shows these informations.

Mounting doesn't work immediately; most times I have to run the "mount"  
command three times - strange.

When I run

       btrfs scrub start -r /dev/sdb1

(or another of the three disks) then I only get the error message

  ERROR: getting dev info for scrub failed: Inappropriate ioctl for
    device

I don't use "udev", "ls -l /dev/sdb1" shows

  brw-r----- 1 root disk 8, 17 29. Apr 1995  /dev/sdb1

Running the command via "strace" shows the last lines

set_thread_area({entry_number:-1 -> 6, base_addr:0x401b6b80,  
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,  
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0x401b0000, 8192, PROT_READ)   = 0
mprotect(0x4004c000, 4096, PROT_READ)   = 0
mprotect(0x4001d000, 4096, PROT_READ)   = 0
munmap(0x40021000, 89277)               = 0
set_tid_address(0x401b6be8)             = 10400
set_robust_list(0x401b6bf0, 0xc)        = 0
futex(0xbffe4c00, FUTEX_WAKE_PRIVATE, 1) = 0
futex(0xbffe4c00, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 1, NULL, bffe4c10) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0x4003b520, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x4003b5a0, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="Arktur.wm8.hullen.de", ...}) = 0
brk(0)                                  = 0x806d000
brk(0x808e000)                          = 0x808e000
mkdir("/var", 0777)                     = -1 EEXIST (File exists)
mkdir("/var/lib", 0777)                 = -1 EEXIST (File exists)
mkdir("/var/lib/btrfs", 0777)           = -1 EEXIST (File exists)
stat64("/dev/sdb1", {st_mode=S_IFBLK|0640, st_rdev=makedev(8, 17), ...}) = 0
open("/dev/sdb1", O_RDWR|O_LARGEFILE)   = 3
ioctl(3, 0x8400941f, 0xbffe4554)        = -1 ENOTTY (Inappropriate ioctl for device)
write(2, "ERROR: getting dev info for scru"..., 73ERROR: getting dev info for scrub failed: Inappropriate ioctl for device
) = 73
close(3)                                = 0
exit_group(1)                           = ?

--------------------------------------------------

Changing the rights of "/dev/sdb1" to 660 doesn't help - same nasty  
behaviour.

What goes wrong?

Viele Gruesse!
Helmut
