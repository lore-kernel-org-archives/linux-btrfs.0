From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: btrfs bug in 2.6.37
Date: Tue, 1 Feb 2011 22:51:59 +0100
Message-ID: <20110201215159.GA1897@Pilar.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I am running 2.6.37 plus the revert of bf9dc102e284 (which is related to drm).

My /home is on btrfs as well as a 1TB external USB hard-disk.

I was compiling 2.6.38-rc3 from /home/mafra/linux2.6 using
the external hd as the destination of the compiled files:

make -j4 O=/mnt/wd/kernel-compile

So after some time I got this bug and I was dropped out of X

[ 2730.943101] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[ 2730.943159] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2730.943217] PGD 2248f067 PUD 5adc8067 PMD 0 
[ 2730.943256] Oops: 0000 [#1] SMP 
[ 2730.943285] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[ 2730.943331] CPU 0 
[ 2730.943346] Modules linked in: ppp_deflate ppp_async ppp_generic slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 snd_hwdep evdev
[ 2730.943526] 
[ 2730.943541] Pid: 15437, comm: as Not tainted 2.6.37-xrandr-00001-g1d95a75 #16 VAIO/VGN-FZ240E
[ 2730.943581] RIP: 0010:[<ffffffff811ba3e5>]  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2730.943629] RSP: 0000:ffff88005a771ad8  EFLAGS: 00010287
[ 2730.943661] RAX: 00000000fffffffb RBX: ffff88005b048d90 RCX: ffff880037f49d38
[ 2730.943695] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88004d456000
[ 2730.943729] RBP: ffff88005a771b58 R08: 00000000fffffffb R09: 0000000000000000
[ 2730.943763] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000005
[ 2730.943797] R13: ffff88005a771fd8 R14: 0000000000000000 R15: 0000000000000000
[ 2730.943831] FS:  00002b01b9f88000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 2730.943872] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2730.943901] CR2: 0000000000000030 CR3: 000000006161c000 CR4: 00000000000006f0
[ 2730.943934] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2730.943968] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2730.944002] Process as (pid: 15437, threadinfo ffff88005a770000, task ffff88002ffea680)
[ 2730.944009] Stack:
[ 2730.944009]  0000001cc7d27000 ffffffff811e4724 ffff88004d456000 0000001cc7784000
[ 2730.944009]  ffff88005a771b58 ffff88005b048d90 0000001cc7d27000 00000000005000a8
[ 2730.944009]  ffff8800491a0e00 ffff88006c2de6c0 0000000000000005 ffff88005b048d90
[ 2730.944009] Call Trace:
[ 2730.944009]  [<ffffffff811e4724>] ? set_extent_dirty+0x24/0x30
[ 2730.944009]  [<ffffffff811b30dd>] __btrfs_free_extent+0x61d/0x6e0
[ 2730.944009]  [<ffffffff811b635b>] run_clustered_refs+0x1fb/0x810
[ 2730.944009]  [<ffffffff811e7bda>] ? set_extent_buffer_dirty+0x4a/0xa0
[ 2730.944009]  [<ffffffff811c342f>] ? btrfs_mark_buffer_dirty+0xaf/0x130
[ 2730.944009]  [<ffffffff81201100>] ? btrfs_find_ref_cluster+0x60/0x190
[ 2730.944009]  [<ffffffff811b6a30>] btrfs_run_delayed_refs+0xc0/0x210
[ 2730.944009]  [<ffffffff811c55b8>] __btrfs_end_transaction+0x68/0x240
[ 2730.944009]  [<ffffffff811c57d0>] btrfs_end_transaction+0x10/0x20
[ 2730.944009]  [<ffffffff811ced57>] btrfs_evict_inode+0x1c7/0x1e0
[ 2730.944009]  [<ffffffff810fa8c2>] evict+0x22/0xb0
[ 2730.944009]  [<ffffffff810fb141>] iput+0x1b1/0x290
[ 2730.944009]  [<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
[ 2730.944009]  [<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
[ 2730.944009]  [<ffffffff810f2af1>] sys_unlink+0x11/0x20
[ 2730.944009]  [<ffffffff81002cfb>] system_call_fastpath+0x16/0x1b
[ 2730.944009] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 ba 00 
[ 2730.944009] RIP  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2730.944009]  RSP <ffff88005a771ad8>
[ 2730.944009] CR2: 0000000000000030
[ 2730.950886] ---[ end trace 3c2d14569018819f ]---
[ 2731.229129] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[ 2731.230010] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.230010] PGD 22623067 PUD 2278d067 PMD 0 
[ 2731.230010] Oops: 0000 [#2] SMP 
[ 2731.230010] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[ 2731.230010] CPU 1 
[ 2731.230010] Modules linked in: ppp_deflate ppp_async ppp_generic slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 snd_hwdep evdev
[ 2731.230010] 
[ 2731.230010] Pid: 15444, comm: as Tainted: G      D     2.6.37-xrandr-00001-g1d95a75 #16 VAIO/VGN-FZ240E
[ 2731.230010] RIP: 0010:[<ffffffff811ba3e5>]  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.230010] RSP: 0000:ffff88004d42dad8  EFLAGS: 00010287
[ 2731.230010] RAX: 00000000fffffffb RBX: ffff88005b048b50 RCX: ffff880037f49d38
[ 2731.230010] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88004d456000
[ 2731.230010] RBP: ffff88004d42db58 R08: 00000000fffffffb R09: 0000000000000000
[ 2731.230010] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000005
[ 2731.230010] R13: ffff88004d42dfd8 R14: 0000000000000000 R15: 0000000000000000
[ 2731.230010] FS:  00002aac5cec6000(0000) GS:ffff88007f500000(0000) knlGS:0000000000000000
[ 2731.230010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2731.230010] CR2: 0000000000000030 CR3: 00000000226af000 CR4: 00000000000006e0
[ 2731.230010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2731.230010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2731.230010] Process as (pid: 15444, threadinfo ffff88004d42c000, task ffff88007b69e280)
[ 2731.230010] Stack:
[ 2731.230010]  0000001cc7d2c000 ffffffff811dd7c5 ffff88004d456000 ffff8800218b8898
[ 2731.230010]  ffff88004d42dba8 ffff88005b048b50 0000001cc7d2c000 00000000005000a8
[ 2731.230010]  ffff88004d42db00 ffff88005a5e5cc0 0000000000000005 ffff88005b048b50
[ 2731.230010] Call Trace:
[ 2731.230010]  [<ffffffff811dd7c5>] ? btrfs_key_generation+0xe5/0xf0
[ 2731.230010]  [<ffffffff811b30dd>] __btrfs_free_extent+0x61d/0x6e0
[ 2731.230010]  [<ffffffff811e7bda>] ? set_extent_buffer_dirty+0x4a/0xa0
[ 2731.230010]  [<ffffffff811c342f>] ? btrfs_mark_buffer_dirty+0xaf/0x130
[ 2731.230010]  [<ffffffff811b635b>] run_clustered_refs+0x1fb/0x810
[ 2731.230010]  [<ffffffff81201100>] ? btrfs_find_ref_cluster+0x60/0x190
[ 2731.230010]  [<ffffffff811b6a30>] btrfs_run_delayed_refs+0xc0/0x210
[ 2731.230010]  [<ffffffff811c55b8>] __btrfs_end_transaction+0x68/0x240
[ 2731.230010]  [<ffffffff811c57d0>] btrfs_end_transaction+0x10/0x20
[ 2731.230010]  [<ffffffff811ced1f>] btrfs_evict_inode+0x18f/0x1e0
[ 2731.230010]  [<ffffffff810fa8c2>] evict+0x22/0xb0
[ 2731.230010]  [<ffffffff810fb141>] iput+0x1b1/0x290
[ 2731.230010]  [<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
[ 2731.230010]  [<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
[ 2731.230010]  [<ffffffff810f2af1>] sys_unlink+0x11/0x20
[ 2731.230010]  [<ffffffff81002cfb>] system_call_fastpath+0x16/0x1b
[ 2731.230010] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 ba 00 
[ 2731.230010] RIP  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.230010]  RSP <ffff88004d42dad8>
[ 2731.230010] CR2: 0000000000000030
[ 2731.304076] ---[ end trace 3c2d1456901881a0 ]---
[ 2731.778512] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[ 2731.779007] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.779007] PGD 2ffa8067 PUD 5a93d067 PMD 0 
[ 2731.779007] Oops: 0000 [#3] SMP 
[ 2731.779007] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[ 2731.779007] CPU 0 
[ 2731.779007] Modules linked in: ppp_deflate ppp_async ppp_generic slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 snd_hwdep evdev
[ 2731.779007] 
[ 2731.779007] Pid: 15448, comm: as Tainted: G      D     2.6.37-xrandr-00001-g1d95a75 #16 VAIO/VGN-FZ240E
[ 2731.779007] RIP: 0010:[<ffffffff811ba3e5>]  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.779007] RSP: 0018:ffff8800227c5ad8  EFLAGS: 00010287
[ 2731.779007] RAX: 00000000fffffffb RBX: ffff88005b048c70 RCX: ffff880021f9fd38
[ 2731.779007] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88004d456000
[ 2731.779007] RBP: ffff8800227c5b58 R08: 00000000fffffffb R09: 0000000000000000
[ 2731.779007] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000005
[ 2731.779007] R13: ffff8800227c5fd8 R14: 0000000000000000 R15: 0000000000000000
[ 2731.779007] FS:  00002b0f18c8e000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 2731.779007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2731.779007] CR2: 0000000000000030 CR3: 000000006c0b5000 CR4: 00000000000006f0
[ 2731.779007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2731.779007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2731.779007] Process as (pid: 15448, threadinfo ffff8800227c4000, task ffff88003acfc5c0)
[ 2731.779007] Stack:
[ 2731.779007]  0000001cc7d3c000 ffffffff811dd7c5 ffff88004d456000 ffff8800218b21f0
[ 2731.779007]  ffff8800227c5ba8 ffff88005b048c70 0000001cc7d3c000 00000000005000a8
[ 2731.779007]  ffff8800227c5b00 ffff88007229ea40 0000000000000005 ffff88005b048c70
[ 2731.779007] Call Trace:
[ 2731.779007]  [<ffffffff811dd7c5>] ? btrfs_key_generation+0xe5/0xf0
[ 2731.779007]  [<ffffffff811b30dd>] __btrfs_free_extent+0x61d/0x6e0
[ 2731.779007]  [<ffffffff811dd9b4>] ? btrfs_item_offset+0xe4/0xf0
[ 2731.779007]  [<ffffffff811b635b>] run_clustered_refs+0x1fb/0x810
[ 2731.779007]  [<ffffffff811e7bda>] ? set_extent_buffer_dirty+0x4a/0xa0
[ 2731.779007]  [<ffffffff811c342f>] ? btrfs_mark_buffer_dirty+0xaf/0x130
[ 2731.779007]  [<ffffffff81201100>] ? btrfs_find_ref_cluster+0x60/0x190
[ 2731.779007]  [<ffffffff811b6a30>] btrfs_run_delayed_refs+0xc0/0x210
[ 2731.779007]  [<ffffffff811c55b8>] __btrfs_end_transaction+0x68/0x240
[ 2731.779007]  [<ffffffff811c57d0>] btrfs_end_transaction+0x10/0x20
[ 2731.779007]  [<ffffffff811ced57>] btrfs_evict_inode+0x1c7/0x1e0
[ 2731.779007]  [<ffffffff810fa8c2>] evict+0x22/0xb0
[ 2731.779007]  [<ffffffff810fb141>] iput+0x1b1/0x290
[ 2731.779007]  [<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
[ 2731.779007]  [<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
[ 2731.779007]  [<ffffffff810f2af1>] sys_unlink+0x11/0x20
[ 2731.779007]  [<ffffffff81002cfb>] system_call_fastpath+0x16/0x1b
[ 2731.779007] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 ba 00 
[ 2731.779007] RIP  [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
[ 2731.779007]  RSP <ffff8800227c5ad8>
[ 2731.779007] CR2: 0000000000000030
[ 2731.855520] ---[ end trace 3c2d1456901881a1 ]---
[ 2732.101887] btrfs csum failed ino 244904 extent 124692799488 csum 4201110721 wanted 126609361 mirror 0
[ 2732.102064] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102084] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102102] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102121] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102139] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102158] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102176] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102195] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102213] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102231] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.102250] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2732.103048] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 0
[ 2732.103086] btrfs csum failed ino 244904 extent 124692799488 csum 2566472073 wanted 126609361 mirror 1
[ 2738.344564] btrfs csum failed ino 244835 extent 124686446592 csum 4201110721 wanted 3023272677 mirror 0
[ 2738.344662] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344683] btrfs csum failed ino 244835 extent 124686446592 csum 4201110721 wanted 3023272677 mirror 1
[ 2738.344702] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344729] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344748] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344752] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344768] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344772] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344792] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344823] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344843] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344862] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1
[ 2738.344884] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 0
[ 2738.344932] btrfs csum failed ino 244835 extent 124686446592 csum 2566472073 wanted 3023272677 mirror 1


Is this problem already known?
