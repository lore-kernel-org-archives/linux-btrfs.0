From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: WARNING: at fs/inode.c:1333 (with 'autodefrag' Enabled)
Date: Sat, 6 Aug 2011 09:13:43 -0500
Message-ID: <CAKcLGm_=Wp_dKtYpKD9TG8e3tZxHTwZczuG8nZCEm0-ReBLmRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am getting the following warnings intermittently with autodefrag enabled.

[70440.795530] ------------[ cut here ]------------
[70440.795533] WARNING: at fs/inode.c:1333 iput+0x5e/0x14b()
[70440.795535] Hardware name: P35-DS3L
[70440.795536] Modules linked in: r8169 ipv6 snd_seq_midi
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
snd_mixer_oss lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core
rc_hauppauge tuner_simple tuner_types tda9887 tda8290 tuner
ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
ir_rc5_decoder ir_nec_decoder cx8800 cx88_alsa cx8802 cx88xx rc_core
i2c_algo_bit tveeprom nvidia(P) snd_ens1371 gameport snd_rawmidi
snd_seq_device sr_mod v4l2_common iTCO_wdt videodev snd_ac97_codec
iTCO_vendor_support media v4l2_compat_ioctl32 videobuf_dma_sg i2c_i801
videobuf_core btcx_risc intel_agp pcspkr intel_gtt ac97_bus snd_pcm
snd_timer snd snd_page_alloc tpm_tis i2c_core tpm ppdev tpm_bios
parport_pc parport iscsi_tcp libiscsi_tcp libiscsi fuse nfs nfs_acl
auth_rpcgss lockd sunrpc sl811_hcd ohci_hcd uhci_hcd ehci_hcd [last
unloaded: r8169]
[70440.795599] Pid: 2257, comm: btrfs-cleaner Tainted: P        W
3.0.0-git-local-v2+ #1
[70440.795602] Call Trace:
[70440.795605]  [<ffffffff81038445>] warn_slowpath_common+0x85/0x9d
[70440.795608]  [<ffffffff81038477>] warn_slowpath_null+0x1a/0x1c
[70440.795611]  [<ffffffff8110e1ad>] iput+0x5e/0x14b
[70440.795615]  [<ffffffff812be854>] btrfs_iget+0x428/0x42a
[70440.795618]  [<ffffffff812c2000>] ? btrfs_run_defrag_inodes+0xa7/0x1da
[70440.795622]  [<ffffffff812c2072>] btrfs_run_defrag_inodes+0x119/0x1da
[70440.795625]  [<ffffffff812ba0eb>] ? btrfs_run_delayed_iputs+0xe9/0x114
[70440.795629]  [<ffffffff812afc43>] cleaner_kthread+0x10b/0x170
[70440.795632]  [<ffffffff812afb38>] ? transaction_kthread+0x227/0x227
[70440.795635]  [<ffffffff812afb38>] ? transaction_kthread+0x227/0x227
[70440.795638]  [<ffffffff8105388a>] kthread+0x82/0x8a
[70440.795642]  [<ffffffff8163e5d4>] kernel_thread_helper+0x4/0x10
[70440.795645]  [<ffffffff81053808>] ? kthread_worker_fn+0x13a/0x13a
[70440.795648]  [<ffffffff8163e5d0>] ? gs_change+0xb/0xb
[70440.795651] ---[ end trace af1037390dedfdbc ]---

It appears to be associated with a stale inode error in the
btrfs_iget() function in fs/btrfs/inode.c

I'll try to pay closer attention to what is running when I get these warnings.
