Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53638 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2KEL40 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 06:56:26 -0500
Date: Mon, 5 Nov 2012 12:56:06 +0100
From: Gabriel <g2p.code@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Corruption at start of files
Message-ID: <20121105125606.41c17200@moulinex>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is what I see in my kern.log (see below).

For me this first happened when the filesystem was close to full (less
than 1GB left), but someone on the irc channel mentioned a similar
problem on suspend to ram.

The files that have checksum failures end up with their first 4k filled
with 0x01 bytes. They were seeing a lot of writes; things like firefox
session data and cookie data, plus files that disappeared before I
could call inode-resolve on them.

I was running 3.6.3 when this happened; I've upgraded to -rcs since
but I haven't tried to reproduce the bug deliberately. I didn't see
relevant changes in the changelog.

Oct 31 17:06:31 moulinex kernel: [93539.008465] BTRFS warning (device dm-16): Aborting unused transaction.
Oct 31 17:06:31 moulinex kernel: [93539.011257] BTRFS warning (device dm-16): Aborting unused transaction.
Oct 31 17:06:31 moulinex kernel: [93539.017137] BTRFS warning (device dm-16): Aborting unused transaction.
Oct 31 17:06:46 moulinex kernel: [93554.728793] use_block_rsv: 16 callbacks suppressed
Oct 31 17:06:46 moulinex kernel: [93554.728795] btrfs: block rsv returned -28
Oct 31 17:06:46 moulinex kernel: [93554.728796] ------------[ cut here ]------------
Oct 31 17:06:46 moulinex kernel: [93554.728818] WARNING: at /home/apw/COD/linux/fs/btrfs/extent-tree.c:6323 use_block_rsv+0x19f/0x1b0 [btrfs]()
Oct 31 17:06:46 moulinex kernel: [93554.728819] Hardware name: System Product Name
Oct 31 17:06:46 moulinex kernel: [93554.728820] Modules linked in: snd_seq_dummy vhost_net macvtap macvlan xt_recent bnep rfcomm bluetooth snd_hrtimer nls_utf8 sch_fq_codel ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat bridge stp llc ppdev lp parport deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw serpent_generic xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek eeepc_wmi asus_wmi sparse_keymap coretemp kvm_intel kvm dm_multipath scsi_dh microcode arc4 joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rt61pci rt2x00pci rt2x00lib snd_seq_midi snd_rawmidi mac80211 snd_seq_midi_event snd_seq snd_timer snd_seq_device snd cfg80211 soundcore snd_page_alloc eeprom_93cx6 serio_raw lpc_ich mei mac_hid k8temp hw
 mon_vid i2c_nforce2 firewire_sbp2 firew
Oct 31 17:06:46 moulinex kernel: ire_core crc_itu_t psmouse ip6t_REJECT xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT xt_multiport xt_limit xt_tcpudp xt_addrtype xt_state ip6table_filter ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables btrfs zlib_deflate libcrc32c raid10 raid0 multipath linear raid456 async_pq async_xor xor async_memcpy async_raid6_recov hid_generic raid6_pq async_tx hid_cherry usbhid hid raid1 ghash_clmulni_intel sata_via wmi aesni_intel ablk_helper cryptd aes_x86_64 r8169 i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: ipmi_msghandler]
Oct 31 17:06:46 moulinex kernel: [93554.728873] Pid: 2230, comm: btrfs-endio-wri Tainted: G        W    3.6.3-030603-generic #201210211349
Oct 31 17:06:46 moulinex kernel: [93554.728874] Call Trace:
Oct 31 17:06:46 moulinex kernel: [93554.728880]  [<ffffffff81056f6f>] warn_slowpath_common+0x7f/0xc0
Oct 31 17:06:46 moulinex kernel: [93554.728882]  [<ffffffff81056fca>] warn_slowpath_null+0x1a/0x20
Oct 31 17:06:46 moulinex kernel: [93554.728889]  [<ffffffffa01feedf>] use_block_rsv+0x19f/0x1b0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728897]  [<ffffffffa020260d>] btrfs_alloc_free_block+0x3d/0x220 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728904]  [<ffffffffa01ef38d>] ? balance_level+0xcd/0x890 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728906]  [<ffffffff81332e10>] ? rb_insert_color+0x110/0x150
Oct 31 17:06:46 moulinex kernel: [93554.728916]  [<ffffffffa022f16c>] ? read_extent_buffer+0xbc/0x120 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728918]  [<ffffffff81178ebd>] ? kmem_cache_alloc_trace+0x12d/0x150
Oct 31 17:06:46 moulinex kernel: [93554.728925]  [<ffffffffa01ee3b2>] __btrfs_cow_block+0x122/0x4f0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728927]  [<ffffffff81136892>] ? set_page_dirty+0x62/0x70
Oct 31 17:06:46 moulinex kernel: [93554.728930]  [<ffffffff8169f37e>] ? _raw_spin_lock+0xe/0x20
Oct 31 17:06:46 moulinex kernel: [93554.728936]  [<ffffffffa01ee87c>] btrfs_cow_block+0xfc/0x220 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728943]  [<ffffffffa01f29f8>] btrfs_search_slot+0x368/0x740 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728951]  [<ffffffffa0206e84>] btrfs_lookup_csum+0x74/0x190 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728953]  [<ffffffff81179cfc>] ? kmem_cache_alloc+0x11c/0x150
Oct 31 17:06:46 moulinex kernel: [93554.728960]  [<ffffffffa0208044>] btrfs_csum_file_blocks+0xc4/0x6b0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728965]  [<ffffffffa0000001>] ? video_get_max_state+0x1/0x2a [video]
Oct 31 17:06:46 moulinex kernel: [93554.728973]  [<ffffffffa0215355>] add_pending_csums.isra.35+0x45/0x60 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728981]  [<ffffffffa021a303>] btrfs_finish_ordered_io+0x263/0x400 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728989]  [<ffffffffa021a4b5>] finish_ordered_fn+0x15/0x20 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.728998]  [<ffffffffa0239f50>] worker_loop+0xa0/0x320 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.729007]  [<ffffffffa0239eb0>] ? check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.729009]  [<ffffffff8107c3a3>] kthread+0x93/0xa0
Oct 31 17:06:46 moulinex kernel: [93554.729012]  [<ffffffff816a8c84>] kernel_thread_helper+0x4/0x10
Oct 31 17:06:46 moulinex kernel: [93554.729014]  [<ffffffff8107c310>] ? flush_kthread_worker+0xb0/0xb0
Oct 31 17:06:46 moulinex kernel: [93554.729015]  [<ffffffff816a8c80>] ? gs_change+0x13/0x13
Oct 31 17:06:46 moulinex kernel: [93554.729016] ---[ end trace b5818eac850e1347 ]---
Oct 31 17:06:46 moulinex kernel: [93554.756145] btrfs: block rsv returned -28
Oct 31 17:06:46 moulinex kernel: [93554.756147] ------------[ cut here ]------------
Oct 31 17:06:46 moulinex kernel: [93554.756164] WARNING: at /home/apw/COD/linux/fs/btrfs/extent-tree.c:6323 use_block_rsv+0x19f/0x1b0 [btrfs]()
Oct 31 17:06:46 moulinex kernel: [93554.756165] Hardware name: System Product Name
Oct 31 17:06:46 moulinex kernel: [93554.756165] Modules linked in: snd_seq_dummy vhost_net macvtap macvlan xt_recent bnep rfcomm bluetooth snd_hrtimer nls_utf8 sch_fq_codel ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat bridge stp llc ppdev lp parport deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw serpent_generic xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek eeepc_wmi asus_wmi sparse_keymap coretemp kvm_intel kvm dm_multipath scsi_dh microcode arc4 joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rt61pci rt2x00pci rt2x00lib snd_seq_midi snd_rawmidi mac80211 snd_seq_midi_event snd_seq snd_timer snd_seq_device snd cfg80211 soundcore snd_page_alloc eeprom_93cx6 serio_raw lpc_ich mei mac_hid k8temp hw
 mon_vid i2c_nforce2 firewire_sbp2 firew
Oct 31 17:06:46 moulinex kernel: ire_core crc_itu_t psmouse ip6t_REJECT xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT xt_multiport xt_limit xt_tcpudp xt_addrtype xt_state ip6table_filter ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables btrfs zlib_deflate libcrc32c raid10 raid0 multipath linear raid456 async_pq async_xor xor async_memcpy async_raid6_recov hid_generic raid6_pq async_tx hid_cherry usbhid hid raid1 ghash_clmulni_intel sata_via wmi aesni_intel ablk_helper cryptd aes_x86_64 r8169 i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: ipmi_msghandler]
Oct 31 17:06:46 moulinex kernel: [93554.756215] Pid: 2299, comm: btrfs-endio-wri Tainted: G        W    3.6.3-030603-generic #201210211349
Oct 31 17:06:46 moulinex kernel: [93554.756216] Call Trace:
Oct 31 17:06:46 moulinex kernel: [93554.756221]  [<ffffffff81056f6f>] warn_slowpath_common+0x7f/0xc0
Oct 31 17:06:46 moulinex kernel: [93554.756223]  [<ffffffff81056fca>] warn_slowpath_null+0x1a/0x20
Oct 31 17:06:46 moulinex kernel: [93554.756230]  [<ffffffffa01feedf>] use_block_rsv+0x19f/0x1b0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756238]  [<ffffffffa020260d>] btrfs_alloc_free_block+0x3d/0x220 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756248]  [<ffffffffa022f16c>] ? read_extent_buffer+0xbc/0x120 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756257]  [<ffffffffa0225874>] ? btrfs_get_token_32+0x64/0xf0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756263]  [<ffffffffa01ee3b2>] __btrfs_cow_block+0x122/0x4f0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756269]  [<ffffffffa01eb9b2>] ? leaf_space_used+0xd2/0x110 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756271]  [<ffffffff8169f37e>] ? _raw_spin_lock+0xe/0x20
Oct 31 17:06:46 moulinex kernel: [93554.756278]  [<ffffffffa01ee87c>] btrfs_cow_block+0xfc/0x220 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756285]  [<ffffffffa01f29f8>] btrfs_search_slot+0x368/0x740 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756292]  [<ffffffffa0206e84>] btrfs_lookup_csum+0x74/0x190 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756295]  [<ffffffff81179cfc>] ? kmem_cache_alloc+0x11c/0x150
Oct 31 17:06:46 moulinex kernel: [93554.756302]  [<ffffffffa0208044>] btrfs_csum_file_blocks+0xc4/0x6b0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756307]  [<ffffffffa0000001>] ? video_get_max_state+0x1/0x2a [video]
Oct 31 17:06:46 moulinex kernel: [93554.756316]  [<ffffffffa0215355>] add_pending_csums.isra.35+0x45/0x60 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756324]  [<ffffffffa021a303>] btrfs_finish_ordered_io+0x263/0x400 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756331]  [<ffffffffa021a4b5>] finish_ordered_fn+0x15/0x20 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756340]  [<ffffffffa0239f50>] worker_loop+0xa0/0x320 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756348]  [<ffffffffa0239eb0>] ? check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
Oct 31 17:06:46 moulinex kernel: [93554.756350]  [<ffffffff8107c3a3>] kthread+0x93/0xa0
Oct 31 17:06:46 moulinex kernel: [93554.756353]  [<ffffffff816a8c84>] kernel_thread_helper+0x4/0x10
Oct 31 17:06:46 moulinex kernel: [93554.756354]  [<ffffffff8107c310>] ? flush_kthread_worker+0xb0/0xb0
Oct 31 17:06:46 moulinex kernel: [93554.756356]  [<ffffffff816a8c80>] ? gs_change+0x13/0x13
Oct 31 17:06:46 moulinex kernel: [93554.756357] ---[ end trace b5818eac850e1348 ]---
Oct 31 17:09:02 moulinex kernel: [93690.074515] btrfs no csum found for inode 23272325 start 0
Oct 31 17:09:02 moulinex kernel: [93690.091631] btrfs csum failed ino 23272325 off 0 csum 1447302616 private 0
Oct 31 17:09:34 moulinex kernel: [93722.590549] btrfs no csum found for inode 23325564 start 0
Oct 31 17:09:34 moulinex kernel: [93722.620845] btrfs csum failed ino 23325564 off 0 csum 1264634154 private 0


