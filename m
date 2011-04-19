From: brandon lansing <imraven@gmail.com>
Subject: Fwd: module/kernel crash while trying to delete missing device/balance
Date: Mon, 18 Apr 2011 21:13:06 -0600
Message-ID: <BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com>
References: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Distro: Ubuntu 10.10
Kernel:=A0Linux 2.6.35-28-generic #50-Ubuntu SMP Fri Mar 18 18:42:20 UT=
C
2011 x86_64 GNU/Linux
Btrfs tools version:=A0Btrfs Btrfs v0.19

I currently have 2 X 500GB hard drives in 'raid1' mode with about
400GB used. =A0Recently one of the hard drives crashed (but I have a
backup) but I'd like to help out if I can because I'm currently
getting an error when trying to 'rebuild' the filesystem.
I've mounted the array in degraded mode and added the new hard drive.
=46inally I issued the command to delete the missing device. =A0The dme=
sg
looks normal for a while with messages such as:=A0btrfs: relocating
block group 466167529472 flags 17. =A0However, after a few minutes of
running I get the following:

[ 1770.041623] ------------[ cut here ]------------
[ 1770.041655] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/volume=
s.c:3037!
[ 1770.041684] invalid opcode: 0000 [#1] SMP
[ 1770.041707] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uevent
[ 1770.041734] CPU 1
[ 1770.041744] Modules linked in: btrfs sha256_generic cryptd
aes_x86_64 aes_generic parport_pc ppdev dm_crypt xt_state xt_multiport
iptable_filter iptable_mangle ipt_MASQUERADE xt_tcpudp iptable_nat
ip_tables x_tables nf_nat_sip nf_nat nf_conntrack_sip nf_conntrack_ftp
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 usblp led_class
serio_raw lp parport raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid0 multipath
linear zlib_deflate crc32c libcrc32c raid1 i915 drm_kms_helper
firewire_ohci drm firewire_core crc_itu_t sky2 e1000 intel_agp
i2c_algo_bit video output [last unloaded: btrfs]
[ 1770.042098]
[ 1770.042108] Pid: 4598, comm: flush-btrfs-3 Not tainted
2.6.35-28-generic #50-Ubuntu FG31/SG31
[ 1770.042142] RIP: 0010:[<ffffffffa0351ccc>] =A0[<ffffffffa0351ccc>]
btrfs_map_bio+0x1ec/0x210 [btrfs]
[ 1770.042198] RSP: 0018:ffff8800ce8ef7f0 =A0EFLAGS: 00010246
[ 1770.042221] RAX: 0000000000000030 RBX: 0000000000000001 RCX: 0000000=
000000000
[ 1770.042925] RDX: ffff8801280a6b40 RSI: ffff880128db7600 RDI: ffff880=
0ceab0000
[ 1770.043645] RBP: ffff8800ce8ef850 R08: 0000000000000000 R09: 0000000=
000000002
[ 1770.044381] R10: ffff88011e8d8678 R11: 0000000000000002 R12: ffff880=
1280a69c0
[ 1770.045144] R13: 0000000000000000 R14: 0000000000000002 R15: ffff880=
1280a66c0
[ 1770.045910] FS: =A00000000000000000(0000) GS:ffff880001e80000(0000)
knlGS:0000000000000000
[ 1770.046701] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1770.047509] CR2: 00007f90b42f8cc1 CR3: 00000000ced70000 CR4: 0000000=
0000006e0
[ 1770.048343] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 1770.049196] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 1770.050055] Process flush-btrfs-3 (pid: 4598, threadinfo
ffff8800ce8ee000, task ffff880128aa2dc0)
[ 1770.050955] Stack:
[ 1770.051254] =A00000000000000001 000000002ee4e020 ffff8801285f0000
0000000000000001
[ 1770.051254] <0> ffff8801280a6b40 000000000000c000 0000000000000000
ffff88011e8d8560
[ 1770.051254] <0> ffff8801285f0000 ffff8801280a66c0 0000000000000001
0000000000000000
[ 1770.051254] Call Trace:
[ 1770.051254] =A0[<ffffffffa032ba71>] btrfs_submit_bio_hook+0x91/0x140=
 [btrfs]
[ 1770.051254] =A0[<ffffffffa034658a>] submit_one_bio+0x6a/0xa0 [btrfs]
[ 1770.051254] =A0[<ffffffffa03466b3>] submit_extent_page+0xf3/0x280 [b=
trfs]
[ 1770.051254] =A0[<ffffffffa034b9db>] __extent_writepage+0x49b/0x6d0 [=
btrfs]
[ 1770.051254] =A0[<ffffffffa03482d0>] ?
end_bio_extent_writepage+0x0/0x180 [btrfs]
[ 1770.051254] =A0[<ffffffffa034bf68>] T.990+0x1f8/0x360 [btrfs]
[ 1770.051254] =A0[<ffffffffa034c1e6>] extent_writepages+0x46/0x60 [btr=
fs]
[ 1770.051254] =A0[<ffffffffa0334a10>] ? btrfs_get_extent+0x0/0x8b0 [bt=
rfs]
[ 1770.051254] =A0[<ffffffff8107f9f4>] ? bit_waitqueue+0x14/0xd0
[ 1770.051254] =A0[<ffffffffa032c6b7>] btrfs_writepages+0x27/0x30 [btrf=
s]
[ 1770.051254] =A0[<ffffffff8110b831>] do_writepages+0x21/0x40
[ 1770.051254] =A0[<ffffffff81175d56>] writeback_single_inode+0xe6/0x3f=
0
[ 1770.051254] =A0[<ffffffff8104d528>] ? update_curr+0xf8/0x1e0
[ 1770.051254] =A0[<ffffffff811764c5>] writeback_sb_inodes+0x195/0x280
[ 1770.051254] =A0[<ffffffff81176ce0>] writeback_inodes_wb+0xa0/0x1b0
[ 1770.051254] =A0[<ffffffff8117703b>] wb_writeback+0x24b/0x2b0
[ 1770.051254] =A0[<ffffffff8107058c>] ? lock_timer_base+0x3c/0x70
[ 1770.051254] =A0[<ffffffff810710c2>] ? del_timer_sync+0x22/0x30
[ 1770.051254] =A0[<ffffffff81177149>] wb_do_writeback+0xa9/0x190
[ 1770.051254] =A0[<ffffffff810706a0>] ? process_timeout+0x0/0x10
[ 1770.051254] =A0[<ffffffff81177283>] bdi_writeback_task+0x53/0x160
[ 1770.051254] =A0[<ffffffff8107f9f7>] ? bit_waitqueue+0x17/0xd0
[ 1770.051254] =A0[<ffffffff8111af46>] bdi_start_fn+0x86/0x100
[ 1770.051254] =A0[<ffffffff8111aec0>] ? bdi_start_fn+0x0/0x100
[ 1770.051254] =A0[<ffffffff8107f5d6>] kthread+0x96/0xa0
[ 1770.051254] =A0[<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
[ 1770.051254] =A0[<ffffffff8107f540>] ? kthread+0x0/0xa0
[ 1770.051254] =A0[<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
[ 1770.051254] Code: 24 10 48 8b 45 a8 49 89 04 24 e8 00 f4 e2 e0 e9
f9 fe ff ff 48 8b 7d c0 e8 12 0f df e0 66 90 eb 8a 83 7e 64 00 0f 85
43 ff ff ff <0f> 0b 66 90 eb fc 4c 89 ea 4c 89 e6 48 c7 c7 f8 f2 36 a0
31 c0
[ 1770.051254] RIP =A0[<ffffffffa0351ccc>] btrfs_map_bio+0x1ec/0x210 [b=
trfs]
[ 1770.051254] =A0RSP <ffff8800ce8ef7f0>
[ 1770.091790] ---[ end trace 0c19202b55031f21 ]---

Before this error occurs the system appears to be doing stuff.
Process list includes btrfs processes, disks are busy, etc. =A0After
this error the btrfs processes are no longer adding a load and the
disk=A0activity=A0goes to idle. =A0Also, the 'delete missing' command
appears to hang. =A0The mount appears to function including the ability
to read files/add new files etc.

I get a=A0similar=A0error if I try to do a balance instead of a delete =
missing.

Any thoughts? =A0Any other information I can provide?

Thanks,

Brandon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
