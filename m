From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Still ENOSPC problems with 2.6.35-rc3
Date: Wed, 16 Jun 2010 19:48:25 +0200
Message-ID: <201006161948.26611.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng " <yanzheng@21cn.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With kernel-2.6.34 I run into the ENOSPC problems that where reported on this 
list recently. The filesystem was somewhat over 90% full and most operations on 
it caused a Oops. I was able to delete files by trial and error and freed up 
half of the filesystem space. Operation on the other files still caused an Oops.

For 2.6.35 there went some patches in, that addressed this problem. Sadly they 
don't fix it but only avoid the Oops. A simple 'ls' on this filesystem results 
in

------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26973, comm: ls Not tainted 2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff8115aaa2>] ? btrfs_dirty_inode+0x58/0xf9
 [<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
 [<ffffffff810a809a>] ? touch_atime+0xfc/0x125
 [<ffffffff810a3a32>] ? filldir+0x0/0xc3
 [<ffffffff810a3c1c>] ? vfs_readdir+0x76/0x9c
 [<ffffffff810a3d7e>] ? sys_getdents+0x7d/0xcd
 [<ffffffff81364f1f>] ? page_fault+0x1f/0x30
 [<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4aa882f64f792d16 ]---
block_rsv size 654311424 reserved 67809280 freed 0 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26970, comm: btrfs-transacti Tainted: G        W   2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff81155a7a>] ? btrfs_commit_transaction+0xf4/0x5fd
 [<ffffffff8102c39f>] ? enqueue_task+0x39/0x47
 [<ffffffff81363dbb>] ? mutex_lock+0xd/0x31
 [<ffffffff81043979>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff81151b5b>] ? transaction_kthread+0x16d/0x213
 [<ffffffff811519ee>] ? transaction_kthread+0x0/0x213
 [<ffffffff810435ad>] ? kthread+0x75/0x7d
 [<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81043538>] ? kthread+0x0/0x7d
 [<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
---[ end trace 4aa882f64f792d17 ]---
block_rsv size 654311424 reserved 67809280 freed 0 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26973, comm: ls Tainted: G        W   2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff811562fb>] ? start_transaction+0x15f/0x1c4
 [<ffffffff8115aaaf>] ? btrfs_dirty_inode+0x65/0xf9
 [<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
 [<ffffffff810a809a>] ? touch_atime+0xfc/0x125
 [<ffffffff810a3a32>] ? filldir+0x0/0xc3
 [<ffffffff810a3c1c>] ? vfs_readdir+0x76/0x9c
 [<ffffffff810a3d7e>] ? sys_getdents+0x7d/0xcd
 [<ffffffff81364f1f>] ? page_fault+0x1f/0x30
 [<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4aa882f64f792d18 ]---
block_rsv size 654311424 reserved 67809280 freed 0 0
btrfs: fail to dirty  inode 256 error -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26973, comm: ls Tainted: G        W   2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff8115aaa2>] ? btrfs_dirty_inode+0x58/0xf9
 [<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
 [<ffffffff810a809a>] ? touch_atime+0xfc/0x125
 [<ffffffff8109a47e>] ? sys_readlinkat+0x4f/0x81
 [<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4aa882f64f792d19 ]---
block_rsv size 654311424 reserved 64905216 freed 2904064 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26970, comm: btrfs-transacti Tainted: G        W   2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff81155a7a>] ? btrfs_commit_transaction+0xf4/0x5fd
 [<ffffffff8102c39f>] ? enqueue_task+0x39/0x47
 [<ffffffff81363dbb>] ? mutex_lock+0xd/0x31
 [<ffffffff81043979>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff81151b5b>] ? transaction_kthread+0x16d/0x213
 [<ffffffff811519ee>] ? transaction_kthread+0x0/0x213
 [<ffffffff810435ad>] ? kthread+0x75/0x7d
 [<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81043538>] ? kthread+0x0/0x7d
 [<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
---[ end trace 4aa882f64f792d1a ]---
block_rsv size 654311424 reserved 67809280 freed 0 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0x13e()
Hardware name: To Be Filled By O.E.M.
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sata_sil sg 
sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2c_amd756 
hwmon
Pid: 26973, comm: ls Tainted: G        W   2.6.35-rc3 #1
Call Trace:
 [<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
 [<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
 [<ffffffff811562fb>] ? start_transaction+0x15f/0x1c4
 [<ffffffff8115aaaf>] ? btrfs_dirty_inode+0x65/0xf9
 [<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
 [<ffffffff810a809a>] ? touch_atime+0xfc/0x125
 [<ffffffff8109a47e>] ? sys_readlinkat+0x4f/0x81
 [<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4aa882f64f792d1b ]---
block_rsv size 654311424 reserved 67809280 freed 0 0
btrfs: fail to dirty  inode 44735539 error -28

