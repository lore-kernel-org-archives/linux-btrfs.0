From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:4754 __btrfs_free_extent+0x290/0x5c7()
Date: Sat, 17 Dec 2011 14:14:23 +0100
Message-ID: <g6hur8-n5b.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs!

As already posted in another thread my btrfs oopsed when I tried to delete a 
subvolume which probably had an error. I've just upgraded to 3.2-rc5 and now 
it oopses on unmount.

Here's what I get on unmount:

[   89.907762] zcache: destroyed pool id=2, cli_id=65535
[   89.908762] Old style space inode found, converting.
[   89.908863] Old style space inode found, converting.
[   89.909468] Old style space inode found, converting.
[   89.909553] Old style space inode found, converting.
[   91.888894] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[   91.888899] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[   91.888902] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[   91.888904] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[   91.888906] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[   91.888909] ------------[ cut here ]------------
[   91.888923] WARNING: at fs/btrfs/extent-tree.c:4754 
__btrfs_free_extent+0x290/0x5c7()
[   91.888925] Hardware name: To Be Filled By O.E.M.
[   91.888926] Modules linked in: af_packet snd_seq_oss snd_seq_midi_event 
snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 nls_cp437 vfat fat 
tcp_cubic zram(C) loop snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi 
snd_seq_device gspca_sonixj gspca_main videodev pcspkr evdev i2c_i801 
v4l2_compat_ioctl32 unix fuse xfs nfs nfs_acl auth_rpcgss lockd sunrpc 
reiserfs scsi_wait_scan hid_monterey hid_microsoft hid_logitech hid_ezkey 
hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech usbhid 
usb_storage hid sr_mod cdrom sg pata_cmd64x [last unloaded: microcode]
[   91.888950] Pid: 6222, comm: umount Tainted: G         C   3.2.0-rc5 #4
[   91.888952] Call Trace:
[   91.888957]  [<ffffffff810333ea>] ? warn_slowpath_common+0x78/0x8c
[   91.888959]  [<ffffffff8114e64f>] ? __btrfs_free_extent+0x290/0x5c7
[   91.888961]  [<ffffffff810b293c>] ? __slab_free+0xd1/0x236
[   91.888963]  [<ffffffff81151963>] ? run_clustered_refs+0x66c/0x6b8
[   91.888966]  [<ffffffff81151a78>] ? btrfs_run_delayed_refs+0xc9/0x173
[   91.888968]  [<ffffffff8115ecbb>] ? 
btrfs_should_end_transaction+0x48/0x74
[   91.888970]  [<ffffffff811530a2>] ? btrfs_drop_snapshot+0x321/0x462
[   91.888972]  [<ffffffff8115fe95>] ? btrfs_clean_old_snapshots+0xf9/0x114
[   91.888974]  [<ffffffff8115b4ac>] ? btrfs_commit_super+0x27/0xb9
[   91.888976]  [<ffffffff8115c852>] ? close_ctree+0xbd/0x30f
[   91.888979]  [<ffffffff810cd19c>] ? dispose_list+0x35/0x3f
[   91.888981]  [<ffffffff810cd9ca>] ? evict_inodes+0xd0/0xdb
[   91.888983]  [<ffffffff8114325d>] ? btrfs_put_super+0x10/0x1d
[   91.888986]  [<ffffffff810bbc82>] ? generic_shutdown_super+0x4c/0xb3
[   91.888988]  [<ffffffff810bbd55>] ? kill_anon_super+0x9/0x11
[   91.888989]  [<ffffffff810bbfcd>] ? deactivate_locked_super+0x2f/0x65
[   91.888992]  [<ffffffff810d10b9>] ? sys_umount+0x2cf/0x301
[   91.888995]  [<ffffffff814446bb>] ? system_call_fastpath+0x16/0x1b
[   91.888997] ---[ end trace c6dbad6994d5476e ]---
[   91.888998] btrfs unable to find ref byte nr 1871181426688 parent 0 root 
2  owner 0 offset 0
[   91.889003] BUG: unable to handle kernel NULL pointer dereference at           
(null)
[   91.889999] IP: [<ffffffff811785a0>] map_private_extent_buffer+0x9/0xde
[   91.890987] PGD 22aaa8067 PUD 236ea1067 PMD 0 
[   91.891969] Oops: 0000 [#1] SMP 
[   91.892939] CPU 1 
[   91.892946] Modules linked in: af_packet snd_seq_oss snd_seq_midi_event 
snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 nls_cp437 vfat fat 
tcp_cubic zram(C) loop snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi 
snd_seq_device gspca_sonixj gspca_main videodev pcspkr evdev i2c_i801 
v4l2_compat_ioctl32 unix fuse xfs nfs nfs_acl auth_rpcgss lockd sunrpc 
reiserfs scsi_wait_scan hid_monterey hid_microsoft hid_logitech hid_ezkey 
hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech usbhid 
usb_storage hid sr_mod cdrom sg pata_cmd64x [last unloaded: microcode]
[   91.897222] 
[   91.898295] Pid: 6222, comm: umount Tainted: G        WC   3.2.0-rc5 #4 
To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[   91.899407] RIP: 0010:[<ffffffff811785a0>]  [<ffffffff811785a0>] 
map_private_extent_buffer+0x9/0xde
[   91.900529] RSP: 0018:ffff880231249aa8  EFLAGS: 00010292
[   91.901650] RAX: 0000000000000066 RBX: ffff880231249ae8 RCX: 
ffff880231249ae8
[   91.902769] RDX: 0000000000000004 RSI: 000000000000007a RDI: 
0000000000000000
[   91.903883] RBP: 0000000000000065 R08: ffff880231249ae0 R09: 
ffff880231249ad8
[   91.904994] R10: 0000000000000000 R11: 000000000000000c R12: 
000000000000007a
[   91.906178] R13: 0000000000000000 R14: ffff880234f1ac00 R15: 
0000000000000000
[   91.907293] FS:  00007f1c93621760(0000) GS:ffff88023fa80000(0000) 
knlGS:0000000000000000
[   91.908407] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   91.909514] CR2: 0000000000000000 CR3: 0000000231279000 CR4: 
00000000000406e0
[   91.910634] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   91.911750] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   91.912857] Process umount (pid: 6222, threadinfo ffff880231248000, task 
ffff880234fedeb0)
[   91.913965] Stack:
[   91.915069]  0000000000000000 ffffffff814423df 0000000000000030 
0000000000000000
[   91.916198]  0000000000000065 ffffffff81170745 0000000000000009 
000001b3ab1ab000
[   91.917319]  0000000000000000 0000000000000002 ffff880230ce9000 
00000000fffffffb
[   91.918436] Call Trace:
[   91.919537]  [<ffffffff814423df>] ? printk+0x40/0x49
[   91.920646]  [<ffffffff81170745>] ? btrfs_item_size+0x2c/0x62
[   91.921724]  [<ffffffff8114e68f>] ? __btrfs_free_extent+0x2d0/0x5c7
[   91.922782]  [<ffffffff810b293c>] ? __slab_free+0xd1/0x236
[   91.923843]  [<ffffffff81151963>] ? run_clustered_refs+0x66c/0x6b8
[   91.924902]  [<ffffffff81151a78>] ? btrfs_run_delayed_refs+0xc9/0x173
[   91.925955]  [<ffffffff8115ecbb>] ? 
btrfs_should_end_transaction+0x48/0x74
[   91.927018]  [<ffffffff811530a2>] ? btrfs_drop_snapshot+0x321/0x462
[   91.928073]  [<ffffffff8115fe95>] ? btrfs_clean_old_snapshots+0xf9/0x114
[   91.929137]  [<ffffffff8115b4ac>] ? btrfs_commit_super+0x27/0xb9
[   91.930204]  [<ffffffff8115c852>] ? close_ctree+0xbd/0x30f
[   91.931264]  [<ffffffff810cd19c>] ? dispose_list+0x35/0x3f
[   91.932311]  [<ffffffff810cd9ca>] ? evict_inodes+0xd0/0xdb
[   91.933367]  [<ffffffff8114325d>] ? btrfs_put_super+0x10/0x1d
[   91.934434]  [<ffffffff810bbc82>] ? generic_shutdown_super+0x4c/0xb3
[   91.935510]  [<ffffffff810bbd55>] ? kill_anon_super+0x9/0x11
[   91.936584]  [<ffffffff810bbfcd>] ? deactivate_locked_super+0x2f/0x65
[   91.937649]  [<ffffffff810d10b9>] ? sys_umount+0x2cf/0x301
[   91.938708]  [<ffffffff814446bb>] ? system_call_fastpath+0x16/0x1b
[   91.939764] Code: 8b 74 24 18 48 8b 7c 24 40 e8 99 cb ff ff 48 81 c4 88 
00 00 00 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 55 53 48 89 cb 48 83 ec 18 
[   91.939894]  8b 2f 81 e5 ff 0f 00 00 48 8d 04 2e 48 89 c1 4c 8d 54 10 ff 
[   91.942128] RIP  [<ffffffff811785a0>] map_private_extent_buffer+0x9/0xde
[   91.943259]  RSP <ffff880231249aa8>
[   91.944390] CR2: 0000000000000000
[   91.945523] ---[ end trace c6dbad6994d5476f ]---

I suppose next access to the filesystem would freeze my system now, so I did 
a sysrq+w and it shows btrfs-transaction in blocked state:

[  153.599180] SysRq : Show Blocked State
[  153.600512]   task                        PC stack   pid father
[  153.601860] btrfs-transacti D ffff8802357e8650     0  6211      2 
0x00000000
[  153.603200]  ffff8802357e8650 0000000000000046 ffff880230d09aa0 
ffff880236c6bf20
[  153.604557]  0000000000000000 0000000000010880 ffff880231227fd8 
ffff880231227fd8
[  153.605914]  0000000000010880 ffff8802357e8650 0000000000010880 
0000000000010880
[  153.607276] Call Trace:
[  153.608632]  [<ffffffff81442f09>] ? schedule_timeout+0x2d/0xd7
[  153.609977]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  153.611316]  [<ffffffff81442a6b>] ? _cond_resched+0x9/0x20
[  153.612650]  [<ffffffff814432b3>] ? mutex_lock+0xd/0x2d
[  153.613980]  [<ffffffff81443f52>] ? _raw_spin_lock_irqsave+0x9/0x22
[  153.615307]  [<ffffffff81048f2a>] ? prepare_to_wait+0x19/0x74
[  153.616626]  [<ffffffff8115f1db>] ? btrfs_commit_transaction+0x264/0x6ca
[  153.617943]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  153.619251]  [<ffffffff81442a6b>] ? _cond_resched+0x9/0x20
[  153.620558]  [<ffffffff810b20d1>] ? 
slab_pre_alloc_hook.clone.47+0x15/0x1c
[  153.621872]  [<ffffffff810b334b>] ? kmem_cache_alloc+0x1c/0x95
[  153.623143]  [<ffffffff81048d68>] ? wake_up_bit+0x23/0x23
[  153.624365]  [<ffffffff8115fa67>] ? start_transaction+0x1db/0x215
[  153.625540]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  153.626703]  [<ffffffff81159589>] ? transaction_kthread+0x16e/0x226
[  153.627841]  [<ffffffff8115941b>] ? btrfs_congested_fn+0x7b/0x7b
[  153.628961]  [<ffffffff8115941b>] ? btrfs_congested_fn+0x7b/0x7b
[  153.630057]  [<ffffffff810489af>] ? kthread+0x7a/0x82
[  153.631144]  [<ffffffff814458f4>] ? kernel_thread_helper+0x4/0x10
[  153.632232]  [<ffffffff81048935>] ? kthread_worker_fn+0x135/0x135
[  153.633320]  [<ffffffff814458f0>] ? gs_change+0xb/0xb

I suppose btrfs still tries to remove remainders of the deleted subvolume - 
how do I recover from that?

Regards,
Kai

