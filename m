From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: linux v3.1 with btrfs-work: oops when deleting files
Date: Tue, 25 Oct 2011 06:48:37 +0200
Message-ID: <6mrhn8-b6u.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

I'm trying to rm some files, this is what I get in dmesg:

[30975.249519] ------------[ cut here ]------------
[30975.249529] WARNING: at fs/btrfs/extent-tree.c:4588 
__btrfs_free_extent+0x3b7/0x7ed()
[30975.249532] Hardware name:  
[30975.249535] Modules linked in: af_packet lm90 it87 hwmon_vid hwmon fuse 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs 
lockd auth_rpcgss nfs_acl tcp_cubic sunrpc ipv6 snd_usb_audio 
snd_usbmidi_lib gspca_sonixj gspca_main videodev usbhid 8250_pnp 
i82875p_edac edac_core sr_mod sg analog cdrom firewire_ohci firewire_core 
evdev pcspkr parport_pc floppy parport ns558 gameport i2c_i801 ne2k_pci 8390 
8250 serial_core snd_mpu401 snd_mpu401_uart intel_agp e1000 crc_itu_t fan 
button intel_gtt agpgart processor thermal unix usb_storage hid [last 
unloaded: microcode]
[30975.249604] Pid: 12291, comm: rm Tainted: G       A C  3.1.0-00057-
gc82b96b-dirty #6
[30975.249607] Call Trace:
[30975.249615]  [<c1029497>] ? warn_slowpath_common+0x7c/0x8f
[30975.249620]  [<c1142ed2>] ? __btrfs_free_extent+0x3b7/0x7ed
[30975.249624]  [<c1142ed2>] ? __btrfs_free_extent+0x3b7/0x7ed
[30975.249628]  [<c10294c5>] ? warn_slowpath_null+0x1b/0x1e
[30975.249632]  [<c1142ed2>] ? __btrfs_free_extent+0x3b7/0x7ed
[30975.249638]  [<c11b7230>] ? rb_erase+0x1ce/0x1f0
[30975.249643]  [<c1143b40>] ? run_clustered_refs+0x838/0x87e
[30975.249648]  [<c1185a67>] ? btrfs_find_ref_cluster+0xfc/0x13c
[30975.249653]  [<c1143c42>] ? btrfs_run_delayed_refs+0xbc/0x13c
[30975.249658]  [<c114f901>] ? __btrfs_end_transaction+0x7e/0x1ac
[30975.249663]  [<c114fa7f>] ? btrfs_end_transaction+0x11/0x13
[30975.249667]  [<c1157cb5>] ? btrfs_evict_inode+0x288/0x29f
[30975.249672]  [<c10af24b>] ? evict+0x82/0x11d
[30975.249677]  [<c10a8fec>] ? do_unlinkat+0xc9/0x110
[30975.249683]  [<c10c3fbb>] ? fsnotify_find_inode_mark+0x17/0x1d
[30975.249688]  [<c109d513>] ? filp_close+0x58/0x5f
[30975.249693]  [<c1357c93>] ? sysenter_do_call+0x12/0x22
[30975.249697] ---[ end trace 568719abda29cd87 ]---
[30975.249701] btrfs unable to find ref byte nr 1271613026304 parent 0 root 
256  owner 445125 offset 2097152
[30975.249713] BUG: unable to handle kernel NULL pointer dereference at   
(null)
[30975.249992] IP: [<c11685d8>] map_private_extent_buffer+0x7/0xbc
[30975.250249] *pde = 00000000 
[30975.250446] Oops: 0000 [#1] SMP 
[30975.250652] Modules linked in: af_packet lm90 it87 hwmon_vid hwmon fuse 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs 
lockd auth_rpcgss nfs_acl tcp_cubic sunrpc ipv6 snd_usb_audio 
snd_usbmidi_lib gspca_sonixj gspca_main videodev usbhid 8250_pnp 
i82875p_edac edac_core sr_mod sg analog cdrom firewire_ohci firewire_core 
evdev pcspkr parport_pc floppy parport ns558 gameport i2c_i801 ne2k_pci 8390 
8250 serial_core snd_mpu401 snd_mpu401_uart intel_agp e1000 crc_itu_t fan 
button intel_gtt agpgart processor thermal unix usb_storage hid [last 
unloaded: microcode]
[30975.252788] 
[30975.252788] Pid: 12291, comm: rm Tainted: G       AWC  3.1.0-00057-
gc82b96b-dirty #6    /8KNXP    
[30975.252788] EIP: 0060:[<c11685d8>] EFLAGS: 00210282 CPU: 1
[30975.252788] EIP is at map_private_extent_buffer+0x7/0xbc
[30975.252788] EAX: 00000000 EBX: 00000000 ECX: 00000004 EDX: 0000007a
[30975.252788] ESI: 00000065 EDI: 0000007a EBP: fffffffb ESP: ec80bcf4
[30975.252788]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[30975.252788] Process rm (pid: 12291, ti=ec80a000 task=f1512370 
task.ti=ec80a000)
[30975.252788] Stack:
[30975.252788]  335b0009 35373930 3934322e 5d313037 c1020020 c13eac01 
00000000 00000065
[30975.252788]  0000007a fffffffb c1161fe2 ec80bd38 ec80bd34 ec80bd30 
00000000 0006cac5
[30975.252788]  f1f5a7e0 fffffffb 00000000 0006cac5 f1f5a7e0 c1142f61 
c13fc992 120af000
[30975.252788] Call Trace:
[30975.252788]  [<c1020020>] ? sched_move_task+0x70/0x8e
[30975.252788]  [<c1161fe2>] ? btrfs_item_size+0x32/0x63
[30975.252788]  [<c1142f61>] ? __btrfs_free_extent+0x446/0x7ed
[30975.252788]  [<c11b7230>] ? rb_erase+0x1ce/0x1f0
[30975.252788]  [<c1143b40>] ? run_clustered_refs+0x838/0x87e
[30975.252788]  [<c1185a67>] ? btrfs_find_ref_cluster+0xfc/0x13c
[30975.252788]  [<c1143c42>] ? btrfs_run_delayed_refs+0xbc/0x13c
[30975.252788]  [<c114f901>] ? __btrfs_end_transaction+0x7e/0x1ac
[30975.252788]  [<c114fa7f>] ? btrfs_end_transaction+0x11/0x13
[30975.252788]  [<c1157cb5>] ? btrfs_evict_inode+0x288/0x29f
[30975.252788]  [<c10af24b>] ? evict+0x82/0x11d
[30975.252788]  [<c10a8fec>] ? do_unlinkat+0xc9/0x110
[30975.252788]  [<c10c3fbb>] ? fsnotify_find_inode_mark+0x17/0x1d
[30975.252788]  [<c109d513>] ? filp_close+0x58/0x5f
[30975.252788]  [<c1357c93>] ? sysenter_do_call+0x12/0x22
[30975.252788] Code: c7 8b 74 24 04 89 e9 f3 a4 89 74 24 04 29 6c 24 1c ff 
04 24 31 ff 83 7c 24 1c 00 75 a6 5b 5e 5b 5e 5f 5d c3 55 57 56 53 83 ec 18 
<8b> 18 81 e3 ff 0f 00 00 8d 3c 1a 89 fe c1 ee 0c 8d 6c 0f ff c1 
[30975.252788] EIP: [<c11685d8>] map_private_extent_buffer+0x7/0xbc SS:ESP 
0068:ec80bcf4
[30975.252788] CR2: 0000000000000000
[30975.252788] ------------[ cut here ]------------
[30975.252788] WARNING: at kernel/softirq.c:159 
_local_bh_enable_ip+0x2f/0x67()
[30975.252788] Hardware name:  
[30975.252788] Modules linked in: af_packet lm90 it87 hwmon_vid hwmon fuse 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs 
lockd auth_rpcgss nfs_acl tcp_cubic sunrpc ipv6 snd_usb_audio 
snd_usbmidi_lib gspca_sonixj gspca_main videodev usbhid 8250_pnp 
i82875p_edac edac_core sr_mod sg analog cdrom firewire_ohci firewire_core 
evdev pcspkr parport_pc floppy parport ns558 gameport i2c_i801 ne2k_pci 8390 
8250 serial_core snd_mpu401 snd_mpu401_uart intel_agp e1000 crc_itu_t fan 
button intel_gtt agpgart processor thermal unix usb_storage hid [last 
unloaded: microcode]
[30975.252788] Pid: 12291, comm: rm Tainted: G       AWC  3.1.0-00057-
gc82b96b-dirty #6
[30975.252788] Call Trace:
[30975.252788]  [<c1029497>] ? warn_slowpath_common+0x7c/0x8f
[30975.252788]  [<c102dbbb>] ? _local_bh_enable_ip+0x2f/0x67
[30975.252788]  [<c102dbbb>] ? _local_bh_enable_ip+0x2f/0x67
[30975.252788]  [<c10294c5>] ? warn_slowpath_null+0x1b/0x1e
[30975.252788]  [<c102dbbb>] ? _local_bh_enable_ip+0x2f/0x67
[30975.252788]  [<c1230468>] ? cn_netlink_send+0x6d/0x161
[30975.252788]  [<c11e20e4>] ? uvesafb_exec+0xef/0x224
[30975.252788]  [<c11e2234>] ? uvesafb_prep+0x1b/0x2f
[30975.252788]  [<c11e233a>] ? uvesafb_blank+0xf2/0x113
[30975.252788]  [<c11db178>] ? fbcon_cursor+0x12b/0x14c
[30975.252788]  [<c11d4147>] ? fb_blank+0x2e/0x52
[30975.252788]  [<c11dc207>] ? fbcon_blank+0x117/0x23a
[30975.252788]  [<c122807a>] ? vt_console_print+0x276/0x284
[30975.252788]  [<c1227e04>] ? notify_update+0x22/0x22
[30975.252788]  [<c102963a>] ? __call_console_drivers+0x5d/0x69
[30975.252788]  [<c1040865>] ? up+0x9/0x2a
[30975.252788]  [<c1029b73>] ? console_unlock+0x17c/0x1b2
[30975.252788]  [<c10324ac>] ? lock_timer_base+0x19/0x34
[30975.252788]  [<c1032954>] ? __mod_timer+0xeb/0xf5
[30975.252788]  [<c1032a36>] ? mod_timer+0x76/0x7b
[30975.252788]  [<c1229921>] ? do_unblank_screen+0xe7/0x157
[30975.252788]  [<c1004b5c>] ? __die+0xe9/0xf2
[30975.252788]  [<c11bb79c>] ? bust_spinlocks+0x10/0x2c
[30975.252788]  [<c1004b75>] ? oops_end+0x10/0x7d
[30975.252788]  [<c1355a84>] ? printk+0x17/0x1b
[30975.252788]  [<c101a793>] ? no_context+0x11b/0x123
[30975.252788]  [<c101a8fd>] ? bad_area+0x38/0x3d
[30975.252788]  [<c101acde>] ? do_page_fault+0x18c/0x2f6
[30975.252788]  [<c11b93a9>] ? vsnprintf+0x89/0x263
[30975.252788]  [<c1040865>] ? up+0x9/0x2a
[30975.252788]  [<c101ab52>] ? vmalloc_sync_all+0xc2/0xc2
[30975.252788]  [<c13579df>] ? error_code+0x67/0x6c
[30975.252788]  [<c11685d8>] ? map_private_extent_buffer+0x7/0xbc
[30975.252788]  [<c1020020>] ? sched_move_task+0x70/0x8e
[30975.252788]  [<c1161fe2>] ? btrfs_item_size+0x32/0x63
[30975.252788]  [<c1142f61>] ? __btrfs_free_extent+0x446/0x7ed
[30975.252788]  [<c11b7230>] ? rb_erase+0x1ce/0x1f0
[30975.252788]  [<c1143b40>] ? run_clustered_refs+0x838/0x87e
[30975.252788]  [<c1185a67>] ? btrfs_find_ref_cluster+0xfc/0x13c
[30975.252788]  [<c1143c42>] ? btrfs_run_delayed_refs+0xbc/0x13c
[30975.252788]  [<c114f901>] ? __btrfs_end_transaction+0x7e/0x1ac
[30975.252788]  [<c114fa7f>] ? btrfs_end_transaction+0x11/0x13
[30975.252788]  [<c1157cb5>] ? btrfs_evict_inode+0x288/0x29f
[30975.252788]  [<c10af24b>] ? evict+0x82/0x11d
[30975.252788]  [<c10a8fec>] ? do_unlinkat+0xc9/0x110
[30975.252788]  [<c10c3fbb>] ? fsnotify_find_inode_mark+0x17/0x1d
[30975.252788]  [<c109d513>] ? filp_close+0x58/0x5f
[30975.252788]  [<c1357c93>] ? sysenter_do_call+0x12/0x22
[30975.252788] ---[ end trace 568719abda29cd88 ]---
[30975.509259] ---[ end trace 568719abda29cd89 ]---

Kernel is based on linux v3.1 with latest btrfs-work branch from Josef 
pulled in:

commit 60f9f544edc06db0833fb35c2ec3ebf37b4bcf1b                                                                                                   
Author: Josef Bacik <josef@redhat.com>
Date:   Tue Oct 18 13:07:31 2011 -0400

    Btrfs: if we have a lot of pinned space, commit the transaction

My kernel version is dirty because it contains the following uncomitted 
patch:

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fb2605d..f38e452 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -158,8 +158,7 @@ static void print_extent_ref_v0(struct extent_buffer 
*eb, int slot)
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
        int i;
-       u32 type;
-       u32 nr = btrfs_header_nritems(l);
+       u32 type, nr;
        struct btrfs_item *item;
        struct btrfs_root_item *ri;
        struct btrfs_dir_item *di;
@@ -172,6 +171,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct 
extent_buffer *l)
        struct btrfs_key key;
        struct btrfs_key found_key;
 
+       if (!l)
+               return;
+
+       nr = btrfs_header_nritems(l);
+
        printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
                (unsigned long long)btrfs_header_bytenr(l), nr,
                btrfs_leaf_free_space(root, l));

Without this patch, a NULL pointer exception in btrfs_print_lead() usually 
hides the other errors.

Thanks for the great work,
Kai

