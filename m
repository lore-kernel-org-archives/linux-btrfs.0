From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: [3.2.0-rc6] WARNING: at fs/btrfs/extent-tree.c:4771 while deleting subvolume
Date: Thu, 22 Dec 2011 22:51:33 +0100
Message-ID: <2clcs8-5ga.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs...

I tried to delete a subvolume which probably has some transid errors. After 
this, the subvolume is gone but I cannot reboot - it hangs. After reisub, 
the deleted subvolume is right back there (this is different from previous 
kernel version before 3.2.0-rc4 (afair) where the subvolume was gone even 
after hard reboot but during mount the btrfs got some hickups from 
btrfs_cleaner then). From this I suppose that btrfs is much more robust to 
unexpected reboots now, but how can I get rid of this broken subvolume now?

Here's my dmesg (including sysrq+w):

[  121.411013] device fsid 311dda08-f33f-4cb9-9d59-6eac6026b1b1 devid 2 
transid 146955 /dev/sda3
[  121.411330] btrfs: use lzo compression
[  121.411333] btrfs: disk space caching is enabled
[  125.232594] zcache: created ephemeral tmem pool, id=2, client=65535
[  157.519388] Old style space inode found, converting.
[  157.525214] Old style space inode found, converting.
[  157.525227] Old style space inode found, converting.
[  157.525236] Old style space inode found, converting.
[  157.525242] Old style space inode found, converting.
[  157.525446] Old style space inode found, converting.
[  157.525634] Old style space inode found, converting.
[  157.528640] Old style space inode found, converting.
[  157.529025] Old style space inode found, converting.
[  157.534514] Old style space inode found, converting.
[  157.534916] Old style space inode found, converting.
[  157.544907] Old style space inode found, converting.
[  157.545118] Old style space inode found, converting.
[  157.545312] Old style space inode found, converting.
[  157.545489] Old style space inode found, converting.
[  157.545675] Old style space inode found, converting.
[  157.545683] Old style space inode found, converting.
[  157.550657] Old style space inode found, converting.
[  157.550677] Old style space inode found, converting.
[  157.550879] Old style space inode found, converting.
[  157.551085] Old style space inode found, converting.
[  157.551265] Old style space inode found, converting.
[  157.551272] Old style space inode found, converting.
[  157.564007] btrfs: truncated 1 orphans
[  157.854236] Old style space inode found, converting.
[  157.895119] btrfs: unlinked 6 orphans
[  157.895122] btrfs: truncated 8 orphans
[  225.682864] Old style space inode found, converting.
[  262.885468] Old style space inode found, converting.
[  262.885477] Old style space inode found, converting.
[  262.885484] Old style space inode found, converting.
[  262.885490] Old style space inode found, converting.
[  262.885498] Old style space inode found, converting.
[  262.885504] Old style space inode found, converting.
[  262.885511] Old style space inode found, converting.
[  262.885525] Old style space inode found, converting.
[  262.885531] Old style space inode found, converting.
[  262.885537] Old style space inode found, converting.
[  262.885543] Old style space inode found, converting.
[  298.668898] Old style space inode found, converting.
[  298.668906] Old style space inode found, converting.
[  302.264552] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  302.264562] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  302.264575] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  302.264579] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  302.264582] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  302.264585] ------------[ cut here ]------------
[  302.264592] WARNING: at fs/btrfs/extent-tree.c:4771 
__btrfs_free_extent+0x290/0x5c7()
[  302.264595] Hardware name: To Be Filled By O.E.M.
[  302.264596] Modules linked in: af_packet snd_seq_oss snd_seq_midi_event 
snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 nls_cp437 vfat fat zram(C) 
loop tcp_cubic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi 
snd_seq_device gspca_sonixj gspca_main videodev v4l2_compat_ioctl32 evdev 
i2c_i801 pcspkr unix fuse xfs nfs nfs_acl auth_rpcgss lockd sunrpc reiserfs 
scsi_wait_scan hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress 
hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech usbhid usb_storage 
hid sr_mod cdrom sg pata_cmd64x [last unloaded: microcode]
[  302.264635] Pid: 6303, comm: btrfs-delayed-m Tainted: G         C   
3.2.0-rc6 #5
[  302.264637] Call Trace:
[  302.264644]  [<ffffffff810333ea>] ? warn_slowpath_common+0x78/0x8c
[  302.264647]  [<ffffffff8114e6f3>] ? __btrfs_free_extent+0x290/0x5c7
[  302.264651]  [<ffffffff810b2998>] ? __slab_free+0xd1/0x236
[  302.264655]  [<ffffffff81151a9f>] ? run_clustered_refs+0x66c/0x6b8
[  302.264659]  [<ffffffff81151bb4>] ? btrfs_run_delayed_refs+0xc9/0x173
[  302.264663]  [<ffffffff8115f82c>] ? __btrfs_end_transaction+0x90/0x1dd
[  302.264668]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  302.264673]  [<ffffffff8119690d>] ? 
btrfs_async_run_delayed_node_done+0x16c/0x1ca
[  302.264677]  [<ffffffff8117f192>] ? worker_loop+0x170/0x486
[  302.264681]  [<ffffffff8117f022>] ? btrfs_queue_worker+0x26d/0x26d
[  302.264684]  [<ffffffff8117f022>] ? btrfs_queue_worker+0x26d/0x26d
[  302.264689]  [<ffffffff810489af>] ? kthread+0x7a/0x82
[  302.264694]  [<ffffffff81446274>] ? kernel_thread_helper+0x4/0x10
[  302.264698]  [<ffffffff81048935>] ? kthread_worker_fn+0x135/0x135
[  302.264702]  [<ffffffff81446270>] ? gs_change+0xb/0xb
[  302.264704] ---[ end trace 01517597c3dd6946 ]---
[  302.264707] btrfs unable to find ref byte nr 1871181426688 parent 0 root 
2  owner 0 offset 0
[  302.264712] BUG: unable to handle kernel NULL pointer dereference at           
(null)
[  302.266278] IP: [<ffffffff81178924>] map_private_extent_buffer+0x9/0xde
[  302.267831] PGD 0 
[  302.269366] Oops: 0000 [#1] SMP 
[  302.270940] CPU 3 
[  302.270953] Modules linked in: af_packet snd_seq_oss snd_seq_midi_event 
snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 nls_cp437 vfat fat zram(C) 
loop tcp_cubic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi 
snd_seq_device gspca_sonixj gspca_main videodev v4l2_compat_ioctl32 evdev 
i2c_i801 pcspkr unix fuse xfs nfs nfs_acl auth_rpcgss lockd sunrpc reiserfs 
scsi_wait_scan hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress 
hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech usbhid usb_storage 
hid sr_mod cdrom sg pata_cmd64x [last unloaded: microcode]
[  302.277932] 
[  302.279719] Pid: 6303, comm: btrfs-delayed-m Tainted: G        WC   
3.2.0-rc6 #5 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[  302.281608] RIP: 0010:[<ffffffff81178924>]  [<ffffffff81178924>] 
map_private_extent_buffer+0x9/0xde
[  302.283505] RSP: 0018:ffff88022b54bb00  EFLAGS: 00010286
[  302.285489] RAX: 0000000000000066 RBX: ffff88022b54bb40 RCX: 
ffff88022b54bb40
[  302.287416] RDX: 0000000000000004 RSI: 000000000000007a RDI: 
0000000000000000
[  302.289344] RBP: 0000000000000065 R08: ffff88022b54bb38 R09: 
ffff88022b54bb30
[  302.291277] R10: 0000000000000000 R11: 0000000000000001 R12: 
000000000000007a
[  302.293252] R13: 0000000000000000 R14: ffff880235a55800 R15: 
0000000000000000
[  302.295212] FS:  0000000000000000(0000) GS:ffff88023fb80000(0000) 
knlGS:0000000000000000
[  302.297196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  302.299199] CR2: 0000000000000000 CR3: 0000000001805000 CR4: 
00000000000406e0
[  302.301218] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  302.303225] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  302.305150] Process btrfs-delayed-m (pid: 6303, threadinfo 
ffff88022b54a000, task ffff8802353ab8d0)
[  302.307186] Stack:
[  302.309212]  0000000000000000 ffffffff81442d7f 0000000000000030 
0000000000000000
[  302.311287]  0000000000000065 ffffffff81170ac9 0000000000000009 
000001b3ab1ab000
[  302.313200]  0000000000000000 0000000000000002 ffff8802232692d0 
00000000fffffffb
[  302.315154] Call Trace:
[  302.317194]  [<ffffffff81442d7f>] ? printk+0x40/0x49
[  302.319237]  [<ffffffff81170ac9>] ? btrfs_item_size+0x2c/0x62
[  302.321279]  [<ffffffff8114e733>] ? __btrfs_free_extent+0x2d0/0x5c7
[  302.323298]  [<ffffffff810b2998>] ? __slab_free+0xd1/0x236
[  302.325327]  [<ffffffff81151a9f>] ? run_clustered_refs+0x66c/0x6b8
[  302.327351]  [<ffffffff81151bb4>] ? btrfs_run_delayed_refs+0xc9/0x173
[  302.329364]  [<ffffffff8115f82c>] ? __btrfs_end_transaction+0x90/0x1dd
[  302.331382]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  302.333370]  [<ffffffff8119690d>] ? 
btrfs_async_run_delayed_node_done+0x16c/0x1ca
[  302.335382]  [<ffffffff8117f192>] ? worker_loop+0x170/0x486
[  302.337447]  [<ffffffff8117f022>] ? btrfs_queue_worker+0x26d/0x26d
[  302.339475]  [<ffffffff8117f022>] ? btrfs_queue_worker+0x26d/0x26d
[  302.341493]  [<ffffffff810489af>] ? kthread+0x7a/0x82
[  302.343515]  [<ffffffff81446274>] ? kernel_thread_helper+0x4/0x10
[  302.345598]  [<ffffffff81048935>] ? kthread_worker_fn+0x135/0x135
[  302.347634]  [<ffffffff81446270>] ? gs_change+0xb/0xb
[  302.349656] Code: 8b 74 24 18 48 8b 7c 24 40 e8 99 cb ff ff 48 81 c4 88 
00 00 00 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 55 53 48 89 cb 48 83 ec 18 
[  302.349878]  8b 2f 81 e5 ff 0f 00 00 48 8d 04 2e 48 89 c1 4c 8d 54 10 ff 
[  302.354000] RIP  [<ffffffff81178924>] map_private_extent_buffer+0x9/0xde
[  302.356138]  RSP <ffff88022b54bb00>
[  302.358253] CR2: 0000000000000000
[  302.360344] ---[ end trace 01517597c3dd6947 ]---
[  534.136962] SysRq : Show Blocked State
[  534.139466]   task                        PC stack   pid father
[  534.141981] btrfs-transacti D ffff8802353a8650     0  6308      2 
0x00000000
[  534.144496]  ffff8802353a8650 0000000000000046 ffffffff810274b3 
ffff880236c6f1a0
[  534.147030]  ffff880100000000 0000000000010880 ffff88022b509fd8 
ffff88022b509fd8
[  534.149549]  0000000000010880 ffff8802353a8650 0000000000010880 
0000000000010880
[  534.152070] Call Trace:
[  534.154556]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  534.157071]  [<ffffffff814438a9>] ? schedule_timeout+0x2d/0xd7
[  534.159574]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  534.162085]  [<ffffffff8144340b>] ? _cond_resched+0x9/0x20
[  534.162088]  [<ffffffff81443c53>] ? mutex_lock+0xd/0x2d
[  534.162092]  [<ffffffff814448f2>] ? _raw_spin_lock_irqsave+0x9/0x22
[  534.162098]  [<ffffffff81048f2a>] ? prepare_to_wait+0x19/0x74
[  534.162103]  [<ffffffff8115f31b>] ? btrfs_commit_transaction+0x264/0x6ca
[  534.162107]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  534.162109]  [<ffffffff8144340b>] ? _cond_resched+0x9/0x20
[  534.162115]  [<ffffffff810b212d>] ? 
slab_pre_alloc_hook.clone.47+0x15/0x1c
[  534.162118]  [<ffffffff810b33a7>] ? kmem_cache_alloc+0x1c/0x95
[  534.162122]  [<ffffffff81048d68>] ? wake_up_bit+0x23/0x23
[  534.162125]  [<ffffffff8115fba7>] ? start_transaction+0x1db/0x215
[  534.162129]  [<ffffffff810274b3>] ? should_resched+0x5/0x24
[  534.162134]  [<ffffffff811596c9>] ? transaction_kthread+0x16e/0x226
[  534.162138]  [<ffffffff8115955b>] ? btrfs_congested_fn+0x7b/0x7b
[  534.162142]  [<ffffffff8115955b>] ? btrfs_congested_fn+0x7b/0x7b
[  534.162146]  [<ffffffff810489af>] ? kthread+0x7a/0x82
[  534.162150]  [<ffffffff81446274>] ? kernel_thread_helper+0x4/0x10
[  534.162154]  [<ffffffff81048935>] ? kthread_worker_fn+0x135/0x135
[  534.162158]  [<ffffffff81446270>] ? gs_change+0xb/0xb

Thanks for looking into it, hth

Regards,
Kai

