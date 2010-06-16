From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Still ENOSPC problems with 2.6.35-rc3
Date: Thu, 17 Jun 2010 07:12:54 +0800
Message-ID: <AANLkTinQPUYU3tMWdPvJiM5aGNDBxW2zkr9TVWezuuar@mail.gmail.com>
References: <201006161948.26611.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006161948.26611.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 17, 2010 at 1:48 AM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
> With kernel-2.6.34 I run into the ENOSPC problems that where reported=
 on this
> list recently. The filesystem was somewhat over 90% full and most ope=
rations on
> it caused a Oops. I was able to delete files by trial and error and f=
reed up
> half of the filesystem space. Operation on the other files still caus=
ed an Oops.
>
> For 2.6.35 there went some patches in, that addressed this problem. S=
adly they
> don't fix it but only avoid the Oops. A simple 'ls' on this filesyste=
m results
> in

To avoid ENOSPC oops, btrfs in 2.6.35 reserves more metadata space for
system use than older btrfs. If the FS has already ran out of metadata =
space,
using btrfs in 2.6.35 doesn't help.

Yan, Zheng

>
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26973, comm: ls Not tainted 2.6.35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff8115aaa2>] ? btrfs_dirty_inode+0x58/0xf9
> =A0[<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
> =A0[<ffffffff810a809a>] ? touch_atime+0xfc/0x125
> =A0[<ffffffff810a3a32>] ? filldir+0x0/0xc3
> =A0[<ffffffff810a3c1c>] ? vfs_readdir+0x76/0x9c
> =A0[<ffffffff810a3d7e>] ? sys_getdents+0x7d/0xcd
> =A0[<ffffffff81364f1f>] ? page_fault+0x1f/0x30
> =A0[<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 4aa882f64f792d16 ]---
> block_rsv size 654311424 reserved 67809280 freed 0 0
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26970, comm: btrfs-transacti Tainted: G =A0 =A0 =A0 =A0W =A0 2.6=
=2E35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff81155a7a>] ? btrfs_commit_transaction+0xf4/0x5fd
> =A0[<ffffffff8102c39f>] ? enqueue_task+0x39/0x47
> =A0[<ffffffff81363dbb>] ? mutex_lock+0xd/0x31
> =A0[<ffffffff81043979>] ? autoremove_wake_function+0x0/0x2a
> =A0[<ffffffff81151b5b>] ? transaction_kthread+0x16d/0x213
> =A0[<ffffffff811519ee>] ? transaction_kthread+0x0/0x213
> =A0[<ffffffff810435ad>] ? kthread+0x75/0x7d
> =A0[<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
> =A0[<ffffffff81043538>] ? kthread+0x0/0x7d
> =A0[<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 4aa882f64f792d17 ]---
> block_rsv size 654311424 reserved 67809280 freed 0 0
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26973, comm: ls Tainted: G =A0 =A0 =A0 =A0W =A0 2.6.35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff811562fb>] ? start_transaction+0x15f/0x1c4
> =A0[<ffffffff8115aaaf>] ? btrfs_dirty_inode+0x65/0xf9
> =A0[<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
> =A0[<ffffffff810a809a>] ? touch_atime+0xfc/0x125
> =A0[<ffffffff810a3a32>] ? filldir+0x0/0xc3
> =A0[<ffffffff810a3c1c>] ? vfs_readdir+0x76/0x9c
> =A0[<ffffffff810a3d7e>] ? sys_getdents+0x7d/0xcd
> =A0[<ffffffff81364f1f>] ? page_fault+0x1f/0x30
> =A0[<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 4aa882f64f792d18 ]---
> block_rsv size 654311424 reserved 67809280 freed 0 0
> btrfs: fail to dirty =A0inode 256 error -28
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26973, comm: ls Tainted: G =A0 =A0 =A0 =A0W =A0 2.6.35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff8115aaa2>] ? btrfs_dirty_inode+0x58/0xf9
> =A0[<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
> =A0[<ffffffff810a809a>] ? touch_atime+0xfc/0x125
> =A0[<ffffffff8109a47e>] ? sys_readlinkat+0x4f/0x81
> =A0[<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 4aa882f64f792d19 ]---
> block_rsv size 654311424 reserved 64905216 freed 2904064 0
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26970, comm: btrfs-transacti Tainted: G =A0 =A0 =A0 =A0W =A0 2.6=
=2E35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff81155a7a>] ? btrfs_commit_transaction+0xf4/0x5fd
> =A0[<ffffffff8102c39f>] ? enqueue_task+0x39/0x47
> =A0[<ffffffff81363dbb>] ? mutex_lock+0xd/0x31
> =A0[<ffffffff81043979>] ? autoremove_wake_function+0x0/0x2a
> =A0[<ffffffff81151b5b>] ? transaction_kthread+0x16d/0x213
> =A0[<ffffffff811519ee>] ? transaction_kthread+0x0/0x213
> =A0[<ffffffff810435ad>] ? kthread+0x75/0x7d
> =A0[<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
> =A0[<ffffffff81043538>] ? kthread+0x0/0x7d
> =A0[<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 4aa882f64f792d1a ]---
> block_rsv size 654311424 reserved 67809280 freed 0 0
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x10c/0=
x13e()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_=
seq
> snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit
> snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_devic=
e
> snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod sa=
ta_sil sg
> sr_mod uhci_hcd ohci_hcd edac_core edac_mce_amd k8temp i2c_amd8111 i2=
c_amd756
> hwmon
> Pid: 26973, comm: ls Tainted: G =A0 =A0 =A0 =A0W =A0 2.6.35-rc3 #1
> Call Trace:
> =A0[<ffffffff81031044>] ? warn_slowpath_common+0x78/0x8c
> =A0[<ffffffff81147fdf>] ? btrfs_block_rsv_check+0x10c/0x13e
> =A0[<ffffffff81155857>] ? __btrfs_end_transaction+0x9f/0x1b1
> =A0[<ffffffff811562fb>] ? start_transaction+0x15f/0x1c4
> =A0[<ffffffff8115aaaf>] ? btrfs_dirty_inode+0x65/0xf9
> =A0[<ffffffff810b07ba>] ? __mark_inode_dirty+0x25/0x149
> =A0[<ffffffff810a809a>] ? touch_atime+0xfc/0x125
> =A0[<ffffffff8109a47e>] ? sys_readlinkat+0x4f/0x81
> =A0[<ffffffff81001e2b>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 4aa882f64f792d1b ]---
> block_rsv size 654311424 reserved 67809280 freed 0 0
> btrfs: fail to dirty =A0inode 44735539 error -28
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
