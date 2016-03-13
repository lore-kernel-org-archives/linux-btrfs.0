Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32775 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbcCMUzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 16:55:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id d205so120300120oia.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 13:55:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160312204847.2092f3f3@natsu>
References: <20160312204847.2092f3f3@natsu>
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Sun, 13 Mar 2016 17:54:49 -0300
Message-ID: <CAFENT7JJkYma5QAE0dKnYsWurH4oNaqqEOpVoELa2XMpCfo-4A@mail.gmail.com>
Subject: Re: parent transid verify failed on snapshot deletion
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My unfortunate experience with these transid problems is that they (1)
randomly appear without warning and (2) --repair completely destroys
the filesystem. I have right now two separate volumes on two separate
disks reporting that error, and --repair surely destroyed the first
one. I am trying to see what I can restore from the second one before
I try --repair as well.

The frustrating part is that these volumes in my case are only used to
receive subvolumes, and delete them. From an outsider's point of view,
it hardly seems to be a very intensive workload.

Sylvain

2016-03-12 12:48 GMT-03:00 Roman Mamedov <rm@romanrm.net>:
> Hello,
>
> The system was seemingly running just fine for days or weeks, then I
> routinely deleted a bunch of old snapshots, and suddenly got hit with:
>
> [Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid verify failed on 7483566862336 wanted 410578 found 404133
> [Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid verify failed on 7483566862336 wanted 410578 found 404133
> [Sat Mar 12 20:17:10 2016] ------------[ cut here ]------------
> [Sat Mar 12 20:17:10 2016] WARNING: CPU: 0 PID: 217 at fs/btrfs/extent-tree.c:6549 __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]()
> [Sat Mar 12 20:17:10 2016] BTRFS: Transaction aborted (error -5)
> [Sat Mar 12 20:17:10 2016] Modules linked in: xt_tcpudp xt_multiport xt_limit xt_length xt_conntrack ip6t_rpfilter ipt_rpfilter ip6table_raw ip6table_mangle iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative cfg80211 rfkill arc4 ecb md4 hmac nls_utf8 cifs dns_resolver fscache 8021q garp mrp bridge stp llc tcp_illinois ext4 crc16 mbcache jbd2 fuse kvm_amd kvm irqbypass serio_raw evdev pcspkr joydev snd_hda_codec_realtek k10temp snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep acpi_cpufreq sp5100_tco snd_pcm snd_timer tpm_tis snd tpm shpchp soundcore i2c_piix4 button processor btrfs dm_mod raid1 raid456
> [Sat Mar 12 20:17:10 2016]  async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic md_mod sg ata_generic sd_mod hid_generic usbhid hid uas usb_storage ohci_pci xhci_pci xhci_hcd r8169 mii sata_mv ahci libahci pata_atiixp ehci_pci ohci_hcd ehci_hcd libata usbcore usb_common scsi_mod
> [Sat Mar 12 20:17:10 2016] CPU: 0 PID: 217 Comm: btrfs-cleaner Tainted: G        W       4.4.4-rm1+ #108
> [Sat Mar 12 20:17:10 2016] Hardware name: Gigabyte Technology Co., Ltd. GA-E350N-USB3/GA-E350N-USB3, BIOS F2 09/19/2011
> [Sat Mar 12 20:17:10 2016]  0000000000000286 000000007223a131 ffff880406befa88 ffffffff81315721
> [Sat Mar 12 20:17:10 2016]  ffff880406befad0 ffffffffa03539b2 ffff880406befac0 ffffffff8107e735
> [Sat Mar 12 20:17:10 2016]  0000000183c9c000 00000000fffffffb ffff88032dbc0e01 0000069c4f95b000
> [Sat Mar 12 20:17:10 2016] Call Trace:
> [Sat Mar 12 20:17:10 2016]  [<ffffffff81315721>] dump_stack+0x63/0x82
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8107e735>] warn_slowpath_common+0x95/0xe0
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8107e7dc>] warn_slowpath_fmt+0x5c/0x80
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02b2e42>] __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02b6f12>] __btrfs_run_delayed_refs+0x412/0x1230 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8133edad>] ? __percpu_counter_add+0x5d/0x80
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02bab4e>] btrfs_run_delayed_refs+0x7e/0x2b0 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02cfd08>] btrfs_should_end_transaction+0x68/0x70 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02b932d>] btrfs_drop_snapshot+0x45d/0x840 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffff815d1ee5>] ? __schedule+0x355/0xa30
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02d020d>] btrfs_clean_one_deleted_snapshot+0xbd/0x120 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02c7e6d>] cleaner_kthread+0x17d/0x210 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffffa02c7cf0>] ? check_leaf+0x370/0x370 [btrfs]
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8109db9a>] kthread+0xea/0x100
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8109dab0>] ? kthread_park+0x60/0x60
> [Sat Mar 12 20:17:10 2016]  [<ffffffff815d6c4f>] ret_from_fork+0x3f/0x70
> [Sat Mar 12 20:17:10 2016]  [<ffffffff8109dab0>] ? kthread_park+0x60/0x60
> [Sat Mar 12 20:17:10 2016] ---[ end trace 4a0a05309f1c27f4 ]---
> [Sat Mar 12 20:17:10 2016] BTRFS: error (device dm-0) in __btrfs_free_extent:6549: errno=-5 IO failure
> [Sat Mar 12 20:17:10 2016] BTRFS info (device dm-0): forced readonly
> [Sat Mar 12 20:17:10 2016] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:2927: errno=-5 IO failure
> [Sat Mar 12 20:17:10 2016] pending csums is 103825408
>
> Now this happens after each reboot too, causing the FS to be remounted read-only.
>
> I wonder what's the best way to proceed here. Maybe try btrfs-zero-log? But
> the difference between transid numbers of 6 thousands is concerning.
>
> Also puzzling why did this happen in the first place, I don't think this
> filesystem had any crashes or storage device-related issues recently.
>
> --
> With respect,
> Roman
