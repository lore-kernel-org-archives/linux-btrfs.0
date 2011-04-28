From: Ruediger Meier <sweet_f_a@gmx.de>
Subject: kernel BUG at fs/btrfs/inode.c:6403
Date: Thu, 28 Apr 2011 17:25:52 +0200
Message-ID: <201104281725.52658.sweet_f_a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

About 3 weeks ago I was testing btrfs with enabled compression and got this:


[1376756.337203] ------------[ cut here ]------------
[1376756.337211] kernel BUG at /usr/src/packages/BUILD/kernel-desktop-2.6.37.1/linux-2.6.37/fs/btrfs/inode.c:6403!
[1376756.337217] invalid opcode: 0000 [#1] PREEMPT SMP
[1376756.337221] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[1376756.337226] CPU 2
[1376756.337228] Modules linked in: btrfs zlib_deflate ext4 jbd2 crc16 minix hfs vfat fat loop w83627ehf hwmon_vid 
coretemp snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfs lockd fscache nfs_acl auth_rpcgss sunrpc microcode 
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf xfs exportfs dm_mod sg firewire_ohci 
sr_mod button snd_hda_codec_realtek cdrom firewire_core e1000e snd_hda_intel snd_hda_codec iTCO_wdt 
iTCO_vendor_support snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc crc_itu_t serio_raw i2c_i801 reiserfs fan 
processor ata_generic pata_jmicron thermal thermal_sys [last unloaded: nvidia]
[1376756.337277]
[1376756.337279] Pid: 10477, comm: tee Tainted: P            2.6.37.1-1.2-desktop #1                  /DP43TF
[1376756.337287] RIP: 0010:[<ffffffffa03124da>]  [<ffffffffa03124da>] btrfs_truncate+0x21a/0x220 [btrfs]
[1376756.337307] RSP: 0018:ffff88000baf5c28  EFLAGS: 00010286
[1376756.337310] RAX: 00000000ffffffe4 RBX: ffff88002c11f8a0 RCX: 0000000000000000
[1376756.337314] RDX: 0000000000000008 RSI: ffff880031f847f0 RDI: ffff8801c172ab00
[1376756.337318] RBP: ffff88012f515800 R08: 0000000000000005 R09: ffff88000baf5a38
[1376756.337321] R10: 00000000ffffffe4 R11: 0000000000000001 R12: ffff88018665ed18
[1376756.337325] R13: ffff88018665eb80 R14: 0000000000000000 R15: 0000000000000008
[1376756.337330] FS:  00007f5630c4f700(0000) GS:ffff8800bf900000(0000) knlGS:0000000000000000
[1376756.337334] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1376756.337337] CR2: 00007f56307bcce0 CR3: 000000011d895000 CR4: 00000000000406e0
[1376756.337341] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1376756.337345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1376756.337349] Process tee (pid: 10477, threadinfo ffff88000baf4000, task ffff8800320ac880)
[1376756.337353] Stack:
[1376756.337355]  ffff88018665ed18 0000000000000000 ffff88002c11f8a0 ffff88000baf5d38
[1376756.337362]  0000000000000000 ffffffff81107938 ffff88012f515800 ffff880000000000
[1376756.337367]  ffff88000baf5d38 ffff88018665ed18 ffff88012f515800 ffffffffa0312847
[1376756.337373] Call Trace:
[1376756.337421]  [<ffffffff81107938>] vmtruncate+0x58/0x70
[1376756.337433]  [<ffffffffa0312847>] btrfs_setattr_size+0xa7/0x240 [btrfs]
[1376756.337469]  [<ffffffffa0312a92>] btrfs_setattr+0xb2/0xc0 [btrfs]
[1376756.337500]  [<ffffffff8116b33b>] notify_change+0x19b/0x370
[1376756.337508]  [<ffffffff81150a2a>] do_truncate+0x5a/0x90
[1376756.337513]  [<ffffffff81160310>] finish_open+0x160/0x1d0
[1376756.337519]  [<ffffffff81160b48>] do_filp_open+0x1a8/0x620
[1376756.337524]  [<ffffffff811518f6>] do_sys_open+0x66/0x110
[1376756.337531]  [<ffffffff81002f8b>] system_call_fastpath+0x16/0x1b
[1376756.337537]  [<00007f56307bccf0>] 0x7f56307bccf0
[1376756.337539] Code: df e8 eb c7 ff ff 85 c0 74 b9 0f 0b 4c 89 e2 48 89 ee 48 89 df e8 f7 4e 01 00 e9 c9 fe ff ff 0f 
0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b <0f> 0b 0f 1f 40 00 41 57 48 8d 87 68 fe ff ff 41 56 41 55 41 54
[1376756.337568] RIP  [<ffffffffa03124da>] btrfs_truncate+0x21a/0x220 [btrfs]
[1376756.337578]  RSP <ffff88000baf5c28>
[1376756.337847] ---[ end trace 32985f059586e488 ]---



Now a tee process and btrfs-transacti are hanging in state D. (That is not the
same tee pid as the one from the trace! It was started about 30 seconds after
that bug trace happened.)

Changing directories on that mount still works. Every read or write results in
state D too.
The machine is still up so I could get some more information if wanted. Note
that btrfs resides on lvm2 volume here.


gonzo:~ # lsb-release -d
Description:    openSUSE 11.4 (x86_64)

gonzo:~ # uname -a
Linux gonzo 2.6.37.1-1.2-desktop #1 SMP PREEMPT 2011-02-21 10:34:10 +0100 x86_64 x86_64 x86_64 GNU/Linux

gonzo:~ # grep btrfs  /proc/mounts
/dev/mapper/system-scratch /var/scratch btrfs rw,relatime,compress 0 0

gonzo:~ # ps aux |grep "tee\|btrfs"
freundt   4055  0.0  0.0   3960   280 ?        D    Apr07   0:00 tee orig/12546.xml
root      4557  0.0  0.0      0     0 ?        S    Apr07   2:15 [btrfs-endio-1]
root      6638  0.0  0.0      0     0 ?        S    Apr07   0:56 [btrfs-endio-wri]
root      6639  0.0  0.0      0     0 ?        S    Apr07   1:00 [btrfs-worker-1]
root     15192  0.0  0.0      0     0 ?        S    Apr07   0:07 [flush-btrfs-12]
root     29027  0.0  0.0      0     0 ?        S    Apr06   0:00 [btrfs-genwork-0]
root     29028  0.0  0.0      0     0 ?        S    Apr06   0:20 [btrfs-submit-0]
root     29030  0.0  0.0      0     0 ?        S    Apr06   0:00 [btrfs-fixup-0]
root     29032  0.0  0.0      0     0 ?        S    Apr06   0:01 [btrfs-endio-met]
root     29035  0.0  0.0      0     0 ?        S    Apr06   0:00 [btrfs-freespace]
root     29036  0.0  0.0      0     0 ?        S    Apr06   0:00 [btrfs-cleaner]
root     29037  0.0  0.0      0     0 ?        D    Apr06   0:16 [btrfs-transacti]
root     29346  0.0  0.0      0     0 ?        S    Apr06  23:40 [btrfs-delalloc-]
root     32731  0.0  0.0      0     0 ?        S    Apr06   0:05 [btrfs-endio-met]


cu,
Rudi
