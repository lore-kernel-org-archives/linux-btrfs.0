Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:49127 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbLZLiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 06:38:23 -0500
From: covici@ccs.covici.com
To: Duncan <1i5t5.duncan@cox.net>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs problems on new file system
In-reply-to: <pan$a2c8c$6af1fa21$56a24ebc$40b50ca8@cox.net>
References: <16107.1451037790@ccs.covici.com> <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com> <18552.1451078098@ccs.covici.com> <CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com> <5117.1451114951@ccs.covici.com> <pan$a2c8c$6af1fa21$56a24ebc$40b50ca8@cox.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Sat, 26 Dec 2015 06:38:20 -0500
Message-ID: <25045.1451129900@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

Duncan <1i5t5.duncan@cox.net> wrote:

> covici posted on Sat, 26 Dec 2015 02:29:11 -0500 as excerpted:
> 
> > Chris Murphy <lists@colorremedies.com> wrote:
> > 
> >> If you can post the entire dmesg somewhere that'd be useful. MUAs tend
> >> to wrap that text and make it unreadable on list. I think the problems
> >> with your volume happened before the messages, but it's hard to say.
> >> Also, a generation of nearly 5000 is not that new?
> > 
> > The file system was only a few days old.  It was on an lvm volume group
> > which consisted of two ssd drives, so I am not sure what you are saying
> > about lvm cache -- how could I do anything different?
> > 
> >> On another thread someone said you probably need to specify the device
> >> to mount when using Btrfs and lvmcache? And the device to specify is
> >> the combined HDD+SSD logical device, for lvmcache that's the "cache
> >> LV", which is the OriginLV + CachePoolLV. If Btrfs decides to mount the
> >> origin, it can result in corruption.
> > 
> > See above.
> 
> I think he mixed up two threads and thought you were running lvm-cache, 
> not just regular lvm, which should be good unless you're exposing lvm 
> snapshots and thus letting btrfs see multiple supposed UUIDs that aren't 
> actually universal.  Since btrfs is multi-device and uses the UUID to 
> track which devices belong to it (because they're _supposed_ to be 
> universally unique, it's even in the _name_!), if it sees the same UUID 
> it'll consider it part of the same filesystem, thus potentially causing 
> corruption if it's a snapshot or something that's not actually supposed 
> to be part of the (current) filesystem.

I found a few more log entries, perhaps these may be helpful to track
this down, or maybe prevent the filesystem from going read-only.

--=-=-=
Content-Disposition: attachment; filename=btrfslog.txt

------------[ cut here ]------------
Dec 25 03:57:42 ccs.covici.com kernel: WARNING: CPU: 1 PID: 16580 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x52/0x114 [btrfs]()
Dec 25 03:57:42 ccs.covici.com kernel: BTRFS: Transaction aborted (error -95)
Dec 25 03:57:42 ccs.covici.com kernel: Modules linked in: rfcomm ip6table_nat nf_nat_ipv6 ip6t_REJECT nf_reject_ipv6 ip6table_mangle ip6table_raw nf_conntrack_ipv6 nf_defrag_ipv6 nf_log_ipv6 ip6table_filter ip6_tables sit tunnel4 ip_tunnel vmnet(O) fuse vmw_vsock_vmci_transport vsock vmw_vmci vmmon(O) uinput cmac ecb xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_recent xt_comment ipt_REJECT nf_reject_ipv4 xt_addrtype xt_mark xt_CT xt_multiport xt_NFLOG nfnetlink_log xt_LOG nf_log_ipv4 nf_log_common nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
Dec 25 03:57:42 ccs.covici.com kernel:  nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpudp xt_conntrack iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_filter ip_tables x_tables bnep ext4 jbd2 gpio_ich snd_emu10k1_synth snd_emux_synth snd_seq_midi_emul snd_seq_virmidi snd_pcm_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_mixer_oss btusb joydev btintel btbcm snd_emu10k1 bluetooth intel_rapl rfkill iosf_mbi x86_pkg_temp_thermal crc16 snd_util_mem snd_hwdep coretemp snd_ac97_codec ac97_bus kvm_intel snd_rawmidi snd_seq_device kvm snd_pcm e1000e snd_timer r8169 emu10k1_gp snd ptp gameport microcode i2c_i801 pps_core pcspkr lpc_ich mii acpi_cpufreq 8250_fintek processor
Dec 25 03:57:42 ccs.covici.com kernel:  button sch_fq_codel nvidia(PO) drm agpgart hid_logitech_hidpp dm_snapshot dm_bufio hid_logitech_dj usbhid btrfs xor raid6_pq ata_generic pata_acpi uas usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel cryptd xhci_pci xhci_hcd ehci_pci ehci_hcd ahci libahci pata_marvell libata usbcore usb_common dm_mirror dm_region_hash dm_log dm_mod ipv6 autofs4
Dec 25 03:57:42 ccs.covici.com kernel: CPU: 1 PID: 16580 Comm: kworker/u16:5 Tainted: P           O    4.1.12-gentoo #1
Dec 25 03:57:42 ccs.covici.com kernel: Hardware name: Supermicro C7P67/C7P67, BIOS 4.6.4 07/01/2011
Dec 25 03:57:42 ccs.covici.com kernel: Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  0000000000000009 ffff88037ca27c28 ffffffff81458291 0000000080000000
Dec 25 03:57:42 ccs.covici.com kernel:  ffff88037ca27c78 ffff88037ca27c68 ffffffff81045b50 ffff88037ca27c58
Dec 25 03:57:42 ccs.covici.com kernel:  ffffffffa0370008 00000000ffffffa1 ffff880166d8e228 ffffffffa0400aa0
Dec 25 03:57:42 ccs.covici.com kernel: Call Trace:
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81458291>] dump_stack+0x4f/0x7b
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81045b50>] warn_slowpath_common+0xa1/0xbb
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa0370008>] ? __btrfs_abort_transaction+0x52/0x114 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81045bb0>] warn_slowpath_fmt+0x46/0x48
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa0370008>] __btrfs_abort_transaction+0x52/0x114 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa03a06cb>] btrfs_finish_ordered_io+0x340/0x457 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa03a09d7>] finish_ordered_fn+0x15/0x17 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa03c0f0a>] normal_work_helper+0xd7/0x2b8 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffffa03c1338>] btrfs_endio_write_helper+0x12/0x14 [btrfs]
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81058cbb>] process_one_work+0x1b3/0x358
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81059a87>] worker_thread+0x273/0x35b
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81059814>] ? rescuer_thread+0x283/0x283
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff8105dbc4>] kthread+0xd2/0xda
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff81060000>] ? current_is_async+0x1e/0x3c
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff8105daf2>] ? kthread_create_on_node+0x180/0x180
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff8145da02>] ret_from_fork+0x42/0x70
Dec 25 03:57:42 ccs.covici.com kernel:  [<ffffffff8105daf2>] ? kthread_create_on_node+0x180/0x180
Dec 25 03:57:42 ccs.covici.com kernel: ---[ end trace 666a42c31af28f83 ]---
Dec 25 03:57:42 ccs.covici.com kernel: BTRFS: error (device dm-20) in btrfs_finish_ordered_io:2896: errno=-95 unknown
Dec 25 03:57:42 ccs.covici.com kernel: BTRFS info (device dm-20): forced readonly
Dec 25 03:57:42 ccs.covici.com kernel: pending csums is 1601536

--=-=-=


-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com

--=-=-=--
