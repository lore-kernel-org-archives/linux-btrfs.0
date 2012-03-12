From: Avi Kivity <avi@redhat.com>
Subject: btrfs oops (autodefrag related?)
Date: Mon, 12 Mar 2012 21:32:54 +0200
Message-ID: <4F5E4F66.2030701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because I'm such a btrfs fanboi I'm running btrfs on my /, all past
experience notwithstanding.  In an attempt to recover some performance,
I enabled autodefrag, and got this in return:

[567304.937620] ------------[ cut here ]------------
[567304.938525] kernel BUG at fs/btrfs/inode.c:1588!
[567304.938525] invalid opcode: 0000 [#1] SMP
[567304.938525] CPU 0
[567304.938525] Modules linked in: vfat fat usb_storage binfmt_misc
tcp_lp ppdev parport_pc lp parport fuse ebtable_nat ebtables be2iscsi
ipt_MASQUERADE iscsi_boot_sysfs iptable_nat nf_nat bnx2i xt_CHECKSUM
cnic iptable_mangle bridge stp llc uio cxgb4i cxgb4 cxgb3i libcxgbi
cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi_tcp libiscsi lockd rfcomm scsi_transport_iscsi bnep
nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state ip6table_filter ip6_tables nf_conntrack
snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel
snd_hda_codec uvcvideo snd_hwdep snd_seq arc4 snd_seq_device snd_pcm
videodev media thinkpad_acpi iwlwifi i2c_i801 snd_timer mac80211 tpm_tis
tpm tpm_bios v4l2_compat_ioctl32 e1000e cfg80211 iTCO_wdt snd
snd_page_alloc soundcore iTCO_vendor_support microcode joydev rfkill
vhost_net macvtap macvlan tun virtio_net kvm_intel kvm sunrpc uinput xts
gf128mul dm_crypt btrfs zlib_deflate libcrc32c sdhci_pci sdhci mmc_core
wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
scsi_wait_scan]
[567304.938525]
[567304.938525] Pid: 533, comm: btrfs-fixup-1 Not tainted
3.2.6-3.fc16.x86_64 #1 LENOVO 4174BH4/4174BH4
[567304.938525] RIP: 0010:[<ffffffffa013de12>]  [<ffffffffa013de12>]
btrfs_writepage_fixup_worker+0x152/0x160 [btrfs]
[567304.948748] RSP: 0018:ffff88011276fde0  EFLAGS: 00010246
[567304.948748] RAX: 0000000000000000 RBX: ffffea000416a000 RCX:
000000000664a000
[567304.948748] RDX: ffff8800452cbde8 RSI: ffffffffffffffff RDI:
ffff8800452cbde8
[567304.948748] RBP: ffff88011276fe30 R08: ffff88011e21a780 R09:
ffff88011276fd98
[567304.948748] R10: 0000000000000001 R11: 0000000000000010 R12:
000000000664a000
[567304.948748] R13: ffff88002ecc0190 R14: 0000000000000000 R15:
000000000664afff
[567304.948748] FS:  0000000000000000(0000) GS:ffff88011e200000(0000)
knlGS:0000000000000000
[567304.948748] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[567304.948748] CR2: 000007ff00ac2000 CR3: 00000000bbd92000 CR4:
00000000000426e0
[567304.948748] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[567304.948748] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[567304.948748] Process btrfs-fixup-1 (pid: 533, threadinfo
ffff88011276e000, task ffff8801125e5c80)
[567304.948748] Stack:
[567304.948748]  ffff880114cb4ea8 ffff88002ecc0030 0000000000000000
ffff88009b09b8c0
[567304.948748]  0000000000000000 ffff880116896360 ffff880114cb4ed0
ffff8801168963b0
[567304.948748]  ffff880116896378 ffff88011276fe98 ffff88011276fee0
ffffffffa0163647
[567304.948748] Call Trace:
[567304.948748]  [<ffffffffa0163647>] worker_loop+0x147/0x530 [btrfs]
[567304.948748]  [<ffffffffa0163500>] ? btrfs_queue_worker+0x2e0/0x2e0
[btrfs]
[567304.948748]  [<ffffffff8108fb9c>] kthread+0x8c/0xa0
[567304.948748]  [<ffffffff815ebaf4>] kernel_thread_helper+0x4/0x10
[567304.948748]  [<ffffffff8108fb10>] ? kthread_worker_fn+0x190/0x190
[567304.948748]  [<ffffffff815ebaf0>] ? gs_change+0x13/0x13
[567304.948748] Code: 00 48 8b 7d b8 48 8d 4d c8 41 b8 50 00 00 00 4c 89
fa 4c 89 e6 e8 3f 8f 01 00 eb b3 48 89 df e8 c5 bb fd e0 0f 1f 44 00 00
eb 92 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41
[567304.948748] RIP  [<ffffffffa013de12>]
btrfs_writepage_fixup_worker+0x152/0x160 [btrfs]
[567304.948748]  RSP <ffff88011276fde0>
[567305.036430] ---[ end trace 642b0cfbec5885d3 ]---

The thread that died was doing some O_DIRECT I/O.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

