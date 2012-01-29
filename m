From: Daniel J Blueman <daniel@quora.org>
Subject: [3.2.2] disk-io.c:413, extent-tree.c:1481, transactions.c:1220: bad luck
Date: Sun, 29 Jan 2012 22:19:33 +0800
Message-ID: <CAMVG2str4eC8vjJe8_Sm9WXS1xcvipqjMF=c8FpN5nmt8J-ZaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Giving BTRFS another spin lately, while copying data onto a 1TB btrfs
filesystem (created with '-n 16384 -l 16384') backed by a
LUKS-encrypted USB storage blockdevice with 4KB sector size, and
'chattr +c' on the fs root on stock 3.2.2, I saw a bunch of warnings
[1], followed by a panic [2].

Trying to reproduce it on a 12GB partition on an SSD, I ran into a
different (space?) issue at fs/btrfs/transaction.c:1220.

Let me know if you'd like the exact steps to reproduce.

Thanks,
  Daniel

--- [1]

WARNING: at /home/apw/COD/linux/fs/btrfs/disk-io.c:413
csum_dirty_buffer+0x171/0x200 [btrfs]()
Hardware name: Latitude E5420
Modules linked in: btrfs zlib_deflate libcrc32c usb_storage xts
gf128mul nls_iso8859_1 nls_cp437 vfat fat sch_sfb bnep rfcomm
bluetooth kvm_intel kvm microcode ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables 8021q
garp stp dm_crypt snd_hda_codec_hdmi snd_hda_codec_idt arc4 dell_wmi
dell_laptop uvcvideo ppdev sparse_keymap videodev dcdbas
v4l2_compat_ioctl32 dm_multipath snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm psmouse snd_seq_midi snd_rawmidi serio_raw snd_seq_midi_event
snd_seq snd_timer snd_seq_device mac_hid iwlwifi parport_pc snd
mac80211 nfsd nfs lockd fscache auth_rpcgss cfg80211 nfs_acl
binfmt_misc sunrpc mei(C) soundcore snd_page_alloc lp parport wmi tg3
i915 drm_kms_helper sdhci_pci sdhci drm i2c_algo_bit video
Pid: 2822, comm: btrfs-worker-1 Tainted: G         C
3.2.2-030202-generic #201201252035
Call Trace:
 [<ffffffff810683af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106840a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa062c441>] csum_dirty_buffer+0x171/0x200 [btrfs]
 [<ffffffff810782d0>] ? lock_timer_base+0x70/0x70
 [<ffffffffa062c516>] __btree_submit_bio_start+0x46/0x80 [btrfs]
 [<ffffffffa0625885>] run_one_async_start+0x25/0x30 [btrfs]
 [<ffffffffa06578ac>] worker_loop+0x15c/0x4c0 [btrfs]
 [<ffffffffa0657750>] ? check_pending_worker_creates+0xf0/0xf0 [btrfs]
 [<ffffffff8108bb06>] kthread+0x96/0xa0
 [<ffffffff816559b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108ba70>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff816559b0>] ? gs_change+0x13/0x13

--- [2]

kernel BUG at /home/apw/COD/linux/fs/btrfs/extent-tree.c:1481!
invalid opcode: 0000 [#1] SMP
CPU 1
Modules linked in: btrfs zlib_deflate libcrc32c usb_storage xts
gf128mul nls_iso8859_1 nls_cp437 vfat fat sch_sfb bnep rfcomm
bluetooth kvm_intel kvm microcode ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables 8021q
garp stp dm_crypt snd_hda_codec_hdmi snd_hda_codec_idt arc4 dell_wmi
dell_laptop uvcvideo ppdev sparse_keymap videodev dcdbas
v4l2_compat_ioctl32 dm_multipath snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm psmouse snd_seq_midi snd_rawmidi serio_raw snd_seq_midi_event
snd_seq snd_timer snd_seq_device mac_hid iwlwifi parport_pc snd
mac80211 nfsd nfs lockd fscache auth_rpcgss cfg80211 nfs_acl
binfmt_misc sunrpc mei(C) soundcore snd_page_alloc lp parport wmi tg3
i915 drm_kms_helper sdhci_pci sdhci drm i2c_algo_bit video

Pid: 2830, comm: btrfs-endio-wri Tainted: G        WC
3.2.2-030202-generic #201201252035 Dell Inc. Latitude E5420/0H5TG2
RIP: 0010:[<ffffffffa061c3ca>]  [<ffffffffa061c3ca>]
lookup_inline_extent_backref+0x2ea/0x400 [btrfs]
RSP: 0018:ffff88021f7038d0  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff880128aa9000 RCX: 0000000000000000
RDX: 0000000000000008 RSI: 000000000000003b RDI: 0000000000000000
RBP: ffff88021f703970 R08: 0000000000000624 R09: ffff88021f703760
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000b2
R13: ffff880128aaa048 R14: 0000000000000001 R15: 000000000000001d
FS:  0000000000000000(0000) GS:ffff88022ec20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0590e0f000 CR3: 000000021c24e000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-wri (pid: 2830, threadinfo ffff88021f702000, task
ffff88021d502dc0)
Stack:
 ffff88021f703970 ffffffffa060db74 ffff88021f703a4c ffff88021f7039b8
 000000351f703a4c 0000000042dfe000 ffff880128aa9000 ffff880011ac1000
 0000003a0000003a 0000004e0000342a 0000000042dfe000 00000000080000a8
Call Trace:
 [<ffffffffa060db74>] ? setup_items_for_insert+0x284/0x330 [btrfs]
 [<ffffffffa0614dc6>] ? block_group_cache_tree_search+0x96/0xc0 [btrfs]
 [<ffffffffa061c549>] insert_inline_extent_backref+0x69/0x100 [btrfs]
 [<ffffffffa061c683>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
 [<ffffffffa061e476>] run_delayed_data_ref+0x96/0x160 [btrfs]
 [<ffffffffa060d293>] ? leaf_space_used+0xc3/0xf0 [btrfs]
 [<ffffffffa061e5eb>] run_one_delayed_ref+0xab/0xc0 [btrfs]
 [<ffffffffa061e6c0>] run_clustered_refs+0xc0/0x220 [btrfs]
 [<ffffffffa061e8ea>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
 [<ffffffff8164b36e>] ? _raw_spin_lock+0xe/0x20
 [<ffffffffa062e58f>] __btrfs_end_transaction+0xbf/0x250 [btrfs]
 [<ffffffffa062e795>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa06337eb>] btrfs_finish_ordered_io+0x16b/0x340 [btrfs]
 [<ffffffffa0633a11>] btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
 [<ffffffffa064a4db>] end_bio_extent_writepage+0x13b/0x180 [btrfs]
 [<ffffffff8164975b>] ? schedule_timeout+0x18b/0x2e0
 [<ffffffff811b14ad>] bio_endio+0x1d/0x40
 [<ffffffffa06283a4>] end_workqueue_fn+0xf4/0x130 [btrfs]
 [<ffffffffa06578ac>] worker_loop+0x15c/0x4c0 [btrfs]
 [<ffffffffa0657750>] ? check_pending_worker_creates+0xf0/0xf0 [btrfs]
 [<ffffffff8108bb06>] kthread+0x96/0xa0
 [<ffffffff816559b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108ba70>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff816559b0>] ? gs_change+0x13/0x13
Code: 8b 75 20 48 89 c3 48 8b 7d 18 e8 82 c2 ff ff 48 39 d8 77 1f b8
1d 00 00 00 e9 0a ff ff ff a8 01 90 0f 85 74 fe ff ff 0f 0b eb fe <0f>
0b eb fe 0f 0b eb fe 4c 89 fb 44 8b 7d ac 83 7d 30 00 41 be
RIP  [<ffffffffa061c3ca>] lookup_inline_extent_backref+0x2ea/0x400 [btrfs]
 RSP <ffff88021f7038d0>
-- 
Daniel J Blueman
