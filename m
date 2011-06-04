From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c:1418!
Date: Sat, 04 Jun 2011 15:21:09 +0200
Message-ID: <4DEA3145.5040304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On kernel 2.6.39 I encountered the following kernel BUG (see below). The btrfs filesystem (just application data) is 1.4TB big with several subvolumes, was created with -m raid1 -d raid0, and reports 108G free (via df -h) at the moment. The system has a dual core cpu. The load average is constantly increasing (reached 43 within 2 days), one core is 100% busy with kernel time and the other core is doing maybe up to 5% of kernel and user time while it spends the other 95% with io-wait. All process which tried to access the btrfs filesystem (for writing I guess) are stuck in D state. When the bug occured the vdr was doing a tv recording and noad was rereading another recording for marking all the ads.
Unfortunately, I am not at the site of the machine until Sunday evening and the machine did not react on a "shutdown -r", so I think I will have to push the power button then.
Is there anything I should take care of before hard rebooting?

Thanks,
Andreas Philipp

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1418!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/model
CPU 0
Modules linked in: xt_TCPMSS ipt_LOG ipt_REDIRECT xt_tcpudp ipt_MASQUERADE iptable_raw xt_comment iptable_nat ipt_REJECT bridge stp llc iptable_mangle nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp iptable_filter xt_DSCP xt_dscp xt_string xt_NFQUEUE xt_multiport xt_mark xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip_tables x_tables coretemp snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nfsd tun btrfs zl
 ib_deflate lzo_compress cpufreq_ondemand cpufreq_stats acpi_cpufreq freq_table mperf zl10353 em28xx_dvb snd_hda_codec_hdmi tda826x tda10086 lnbp21 stb6100 stb0899 tuner_xc2028 nvidia(P)
tuner tvp5150 snd_hda_codec_realtek snd_hda_intel snd_hda_codec budget budget_core saa7146 uvcvideo mantis mantis_core snd_usb_audio em28xx snd_hwdep snd_usbmidi_lib snd_pcm ttpci_eeprom snd_rawmidi snd_timer rtc_cmos snd_seq_device rtc_core tpm_tis dvb_core v4l2_common i2c_i801 videodev ir_lirc_codec lirc_dev tpm videobuf_vmalloc videobuf_core snd rc_core snd_page_alloc joydev tveeprom serio_raw rtc_lib tpm_bios v4l2_compat_ioctl32 processor fuse xfs nfs lockd sunrpc reiserfs raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid0 dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usbhid uhci_hcd usb_storage ehci_hcd usbcore sg ata_piix ahci libahci pata_jmicron

Pid: 5359, comm: btrfs-endio-wri Tainted: P        W   2.6.39 #2    /965P-DQ6
RIP: 0010:[<ffffffffa11011de>]  [<ffffffffa11011de>] lookup_inline_extent_backref+0xec/0x3fd [btrfs]
RSP: 0018:ffff88012d7db9d0  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff880059572a30 RCX: 0000000000000019
RDX: 0000000000000001 RSI: ffff880000000000 RDI: ffff880136a29ef8
RBP: 00000000000000b2 R08: 0000000000800020 R09: 0000000000000000
R10: 0000000000000034 R11: ffff880059572a30 R12: ffff88013d018920
R13: 0000000000000001 R14: 000000000000001d R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007faadc4c0c50 CR3: 0000000134190000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-wri (pid: 5359, threadinfo ffff88012d7da000, task ffff88013bc80100)
Stack:
 0000000000000240 ffff88012d7dbb60 000000322d7da000 ffff880059572a30
 0000001d0000052e ffff88013afdd800 000000352d7dbc41 000003b84e69e000
 ffff880136a29828 ffff88012d7dbab8 000003b84e69e000 000000000bf000a8
Call Trace:
 [<ffffffffa1101dec>] ? insert_inline_extent_backref+0x63/0xec [btrfs]
 [<ffffffffa10fd427>] ? update_block_group+0x1d4/0x1f1 [btrfs]
 [<ffffffffa1101f26>] ? __btrfs_inc_extent_ref+0xb1/0x1e3 [btrfs]
 [<ffffffffa110322e>] ? run_clustered_refs+0x69d/0x768 [btrfs]
 [<ffffffffa11033c6>] ? btrfs_run_delayed_refs+0xcd/0x1c0 [btrfs]
 [<ffffffffa110d59f>] ? __btrfs_end_transaction+0x66/0x1c1 [btrfs]
 [<ffffffffa1118a07>] ? btrfs_finish_ordered_io+0x2b3/0x2d8 [btrfs]
 [<ffffffffa1128c15>] ? end_bio_extent_writepage+0xa0/0x14a [btrfs]
 [<ffffffffa1132208>] ? worker_loop+0x17f/0x47d [btrfs]
 [<ffffffffa1132089>] ? btrfs_queue_worker+0x248/0x248 [btrfs]
 [<ffffffffa1132089>] ? btrfs_queue_worker+0x248/0x248 [btrfs]
 [<ffffffff810432d8>] ? kthread+0x7a/0x82
 [<ffffffff812e1dd4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8104325e>] ? kthread_worker_fn+0x139/0x139
 [<ffffffff812e1dd0>] ? gs_change+0xb/0xb
Code: 24 50 41 b9 01 00 00 00 44 8b 44 24 24 48 89 d9 48 8b 74 24 28 4c 89 e7 e8 7e 63 ff ff 41 89 c5 83 f8 00 0f 8c e0 02 00 00 74 04 <0f> 0b eb fe 4c 8b 2b 48 63 73 40 4c 89 ef 48 6b f6 19 48 83 c6
RIP  [<ffffffffa11011de>] lookup_inline_extent_backref+0xec/0x3fd [btrfs]
 RSP <ffff88012d7db9d0>
---[ end trace 1dac9e78db79cc03 ]---

