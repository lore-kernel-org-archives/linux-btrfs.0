Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57958 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab3FLLzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 07:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Umjdo-0008C7-2f
	for linux-btrfs@vger.kernel.org; Wed, 12 Jun 2013 13:55:04 +0200
Received: from artipc9.vub.ac.be ([134.184.26.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 13:55:04 +0200
Received: from fhimpe by artipc9.vub.ac.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 13:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: Frederik Himpe <fhimpe@vub.ac.be>
Subject: Kernel bug at fs/btrfs/inode.c:906
Date: Wed, 12 Jun 2013 11:51:20 +0000 (UTC)
Message-ID: <kp9nbo$tdh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just encoutered this btrfs bug. When this happened, I was  compiling
stuff in a qemu/kvm virtual machine running as guest on this host, so this
might be related. The guest hard disk image is a qcow2 file which has the
NO_COW attribute set.

After this happened, I was unable to unlock my X session, and running reboot
in a console did not have any effect, so I had to do a hard reset.

Let me know if you need more info.

[77286.680088] ------------[ cut here ]------------
[77286.680153] kernel BUG at /build/linux-9VFSO6/linux-3.9.4/fs/btrfs/inode.c:906!
[77286.680230] invalid opcode: 0000 [#1] SMP 
[77286.680283] Modules linked in: fuse ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext3 jbd ext2 hid_generic usbhid hid vhost_net macvtap macvlan tun ip6table_filter ip6_tables ebtable_nat ebtables ppdev cpufreq_stats lp cpufreq_userspace cpufreq_powersave cpufreq_conservative bnep binfmt_misc uinput act_police cls_basic cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq bridge stp llc xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_nat ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_defrag_ipv6 nf_tproxy_core xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc nls_utf8 nls_cp437 vfat fat ext4 jbd2 mbcache loop snd_hda_codec_hdmi snd_hda_codec_idt tpm_infineon coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul hp_wmi sparse_keymap joydev uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media btusb iTCO_wdt iTCO_vendor_support bluetooth arc4 crc16 iwldvm tpm_tis tpm mac80211 snd_hda_intel tpm_bios snd_hda_codec parport_pc parpor
t snd_hwdep snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer wmi hp_accel snd microcode soundcore lis3lv02d input_polldev i915 iwlwifi acpi_cpufreq video mperf drm_kms_helper drm i2c_algo_bit battery i2c_core ac psmouse cfg80211 evdev serio_raw processor rfkill lpc_ich mfd_core button efivars mei btrfs xor zlib_deflate raid6_pq crc32c libcrc32c dm_mod sg sr_mod sd_mod cdrom crc_t10dif firewire_ohci ahci libahci firewire_core crc_itu_t sdhci_pci sdhci mmc_core ehci_pci ehci_hcd xhci_hcd libata e1000e ptp pps_core scsi_mod thermal thermal_sys usbcore usb_common
[77286.683224] CPU 0 
[77286.683250] Pid: 25988, comm: qemu-system-x86 Not tainted 3.9-1-amd64 #1 Debian 3.9.4-1 Hewlett-Packard HP EliteBook 8470p/179B
[77286.683365] RIP: 0010:[<ffffffffa01e1870>]  [<ffffffffa01e1870>] __cow_file_range+0x14e/0x3c1 [btrfs]
[77286.683504] RSP: 0018:ffff88018c04d9b8  EFLAGS: 00010286
[77286.683559] RAX: ffff880233446000 RBX: 00000000663e0000 RCX: ffffea0003a0efb8
[77286.683630] RDX: ffff880234174000 RSI: ffff88021e2579c0 RDI: ffff88021e2579c0
[77286.683700] RBP: ffff88021e2579c0 R08: 00000000663e0000 R09: 000000006633bfff
[77286.683770] R10: 0000000000000000 R11: 000000000000ba72 R12: 0000000000000000
[77286.683840] R13: fffffffffff5c000 R14: fffffffffff5bfff R15: ffff8802340be000
[77286.683911] FS:  00007f0e6cef8700(0000) GS:ffff88023ea00000(0000) knlGS:0000000000000000
[77286.683990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[77286.684047] CR2: 00007fa24863c000 CR3: 00000001e4829000 CR4: 00000000001427e0
[77286.684118] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[77286.684188] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[77286.684259] Process qemu-system-x86 (pid: 25988, threadinfo ffff88018c04c000, task ffff880232ce27b0)
[77286.684347] Stack:
[77286.684370]  ffff88001ada09a0 ffff8800b41c7700 0000000000000292 ffff8802144f62e0
[77286.684454]  ffff8801cdc6bd10 000000006633bfff ffffea0003a0efb8 ffffffff8105eaea
[77286.684537]  80ffffffffffffff ffff88021e257810 0000000000000001 ffff880200000003
[77286.684622] Call Trace:
[77286.684656]  [<ffffffff8105eaea>] ? __wake_up+0x35/0x46
[77286.684714]  [<ffffffff813901fc>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[77286.684827]  [<ffffffffa01efd59>] ? release_extent_buffer.isra.19+0x90/0x97 [btrfs]
[77286.684940]  [<ffffffffa01e1fb2>] ? run_delalloc_nocow+0x4cf/0x795 [btrfs]
[77286.685011]  [<ffffffff810fe867>] ? kmem_cache_alloc+0x8e/0x101
[77286.685105]  [<ffffffffa01e23a1>] ? run_delalloc_range+0x64/0x333 [btrfs]
[77286.685207]  [<ffffffffa01f0265>] ? free_extent_state+0x12/0x21 [btrfs]
[77286.685310]  [<ffffffffa01f2f54>] ? __extent_writepage+0x1e0/0x625 [btrfs]
[77286.685414]  [<ffffffffa01f251a>] ? end_extent_writepage+0x5e/0x5e [btrfs]
[77286.685514]  [<ffffffffa01f34e3>] ? extent_write_cache_pages.isra.22.constprop.42+0x14a/0x255 [btrfs]
[77286.685637]  [<ffffffffa01f37fc>] ? extent_writepages+0x49/0x60 [btrfs]
[77286.685736]  [<ffffffffa01dec77>] ? btrfs_update_inode_item+0xde/0xde [btrfs]
[77286.685824]  [<ffffffff810c3c65>] ? __filemap_fdatawrite_range+0x4d/0x52
[77286.685928]  [<ffffffffa01e8dcf>] ? btrfs_sync_file+0x71/0x244 [btrfs]
[77286.685983]  [<ffffffff8107e8b9>] ? sys_futex+0x124/0x157
[77286.686039]  [<ffffffff81130b3f>] ? do_fsync+0x2b/0x50
[77286.686097]  [<ffffffff810c1534>] ? fire_user_return_notifiers+0x35/0x3d
[77286.686167]  [<ffffffff81130d3f>] ? sys_fdatasync+0xb/0xf
[77286.686226]  [<ffffffff813955e9>] ? system_call_fastpath+0x16/0x1b
[77286.690521] Code: 00 48 c7 c2 10 3c 23 a0 4c 89 fe 31 db e8 d4 9e fd ff e9 50 02 00 00 49 8b 87 e8 01 00 00 48 8b 80 d8 02 00 00 4c 3b 68 70 76 02 <0f> 0b 4c 89 ea 48 89 de 48 89 ef e8 0b d2 ff ff 49 8d 54 1d ff 
[77286.699858] RIP  [<ffffffffa01e1870>] __cow_file_range+0x14e/0x3c1 [btrfs]
[77286.704435]  RSP <ffff88018c04d9b8>
[77286.715889] ---[ end trace 0b81c66412c46ca7 ]---

-- 
Frederik Himpe

