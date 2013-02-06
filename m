Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50978 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3BFWMQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 17:12:16 -0500
Received: by mail-lb0-f172.google.com with SMTP id n8so1622132lbj.31
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 14:12:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRMg0kYWUf5rh0WXNc+++9gG+XZ0-n9_SWpVh8jRHN-_2DfXQ@mail.gmail.com>
References: <CAGRMg0kYWUf5rh0WXNc+++9gG+XZ0-n9_SWpVh8jRHN-_2DfXQ@mail.gmail.com>
Date: Wed, 6 Feb 2013 23:12:14 +0100
Message-ID: <CAGRMg0nmjsMNp1psLzMnf77HWP2Zynj3fWAA1c0DGkFTgvWx+g@mail.gmail.com>
Subject: btrfs balance -> hang/crash
From: Michael Schneider <mike2.schneider@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

my btrfs "hangs" when doing a balance operation.

I'm using a 3.7.1 kernel from opensuse:  linux-opzz 3.7.1-2.10-m4 #11 SMP
PREEMPT Fri Jan 11 18:04:04 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
and Btrfs v0.19+

I did a scrub which completed without errors. Then I tried "btrfs filesystem
balance /" which work fine for the first 23 of 46 chunks, then ist stopped
processing further chunks, but contiued to consume large amounts of the CPU.
The system logged filled quickly with messages like:

[  347.237658] btrfs: block rsv returned -28
[  347.237661] ------------[ cut here ]------------
[  347.237667] WARNING: at fs/btrfs/extent-tree.c:6297
btrfs_alloc_free_block+0x399/0x3a0()
[  347.237668] Hardware name: GA-MA74GM-S2H
[  347.237669] Modules linked in: fuse xt_pkttype af_packet ipt_REJECT
xt_conntrack iptable_raw xt_CT iptable_filter nf
_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables cpufreq_c
onservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf
sp5100_tco usb_storage kvm_amd kvm snd_hda_codec_rea
ltek k10temp edac_core edac_mce_amd sr_mod cdrom i2c_piix4 snd_hda_intel
snd_hda_codec sg snd_hwdep snd_pcm snd_timer s
nd_page_alloc floppy edd microcode autofs4 radeon ttm drm_kms_helper
processor thermal_sys pata_atiixp
[  347.237694] Pid: 320, comm: btrfs-balance Not tainted 3.7.1-2.10-m4 #11
[  347.237695] Call Trace:
[  347.237707]  [<ffffffff810046c7>] dump_trace+0x87/0x2f0
[  347.237711]  [<ffffffff81591682>] dump_stack+0x69/0x6f
[  347.237716]  [<ffffffff8103cb79>] warn_slowpath_common+0x79/0xc0
[  347.237720]  [<ffffffff8122c889>] btrfs_alloc_free_block+0x399/0x3a0
[  347.237725]  [<ffffffff81218617>] __btrfs_cow_block+0x137/0x550
[  347.237728]  [<ffffffff81218baf>] btrfs_cow_block+0xff/0x250
[  347.237731]  [<ffffffff8121d2f1>] btrfs_search_slot+0x421/0x980
[  347.237735]  [<ffffffff8127fa0e>] do_relocation+0x3be/0x510
[  347.237740]  [<ffffffff812839f3>] relocate_tree_blocks+0x5e3/0x610
[  347.237743]  [<ffffffff812849a4>] relocate_block_group+0x444/0x6c0
[  347.237747]  [<ffffffff81284dc9>] btrfs_relocate_block_group+0x1a9/0x2d0
[  347.237751]  [<ffffffff8125de36>] btrfs_relocate_chunk.isra.53+0x56/0x730
[  347.237754]  [<ffffffff812621fe>] btrfs_balance+0x82e/0xd50
[  347.237758]  [<ffffffff812627a0>] balance_kthread+0x80/0x90
[  347.237762]  [<ffffffff8105ec33>] kthread+0xb3/0xc0
[  347.237766]  [<ffffffff815a43fc>] ret_from_fork+0x7c/0xb0
[  347.237770] ---[ end trace cf4d2bf19a87ec83 ]---
[  347.239650] btrfs: block rsv returned -28

[  347.239653] ------------[ cut here ]------------
[  347.239658] WARNING: at fs/btrfs/extent-tree.c:6297
btrfs_alloc_free_block+0x399/0x3a0()
[  347.239660] Hardware name: GA-MA74GM-S2H
[  347.239661] Modules linked in: fuse xt_pkttype af_packet ipt_REJECT
xt_conntrack iptable_raw xt_CT iptable_filter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf sp5100_tco usb_storage kvm_amd kvm snd_hda_codec_realtek
k10temp edac_core edac_mce_amd sr_mod cdrom i2c_piix4 snd_hda_intel
snd_hda_codec sg snd_hwdep snd_pcm snd_timer snd_page_alloc floppy edd
microcode autofs4 radeon ttm drm_kms_helper processor thermal_sys
pata_atiixp
[  347.239683] Pid: 320, comm: btrfs-balance Tainted: G        W
3.7.1-2.10-m4 #11
[  347.239685] Call Trace:
[  347.239695]  [<ffffffff810046c7>] dump_trace+0x87/0x2f0
[  347.239699]  [<ffffffff81591682>] dump_stack+0x69/0x6f
[  347.239704]  [<ffffffff8103cb79>] warn_slowpath_common+0x79/0xc0
[  347.239708]  [<ffffffff8122c889>] btrfs_alloc_free_block+0x399/0x3a0
[  347.239713]  [<ffffffff81218617>] __btrfs_cow_block+0x137/0x550
[  347.239716]  [<ffffffff81218baf>] btrfs_cow_block+0xff/0x250
[  347.239719]  [<ffffffff8121d2f1>] btrfs_search_slot+0x421/0x980
[  347.239723]  [<ffffffff8127fa0e>] do_relocation+0x3be/0x510
[  347.239728]  [<ffffffff812839f3>] relocate_tree_blocks+0x5e3/0x610
[  347.239731]  [<ffffffff812849a4>] relocate_block_group+0x444/0x6c0
[  347.239735]  [<ffffffff81284dc9>] btrfs_relocate_block_group+0x1a9/0x2d0
[  347.239739]  [<ffffffff8125de36>] btrfs_relocate_chunk.isra.53+0x56/0x730
[  347.239743]  [<ffffffff812621fe>] btrfs_balance+0x82e/0xd50
[  347.239746]  [<ffffffff812627a0>] balance_kthread+0x80/0x90
[  347.239750]  [<ffffffff8105ec33>] kthread+0xb3/0xc0
[  347.239755]  [<ffffffff815a43fc>] ret_from_fork+0x7c/0xb0
[  347.239758] ---[ end trace cf4d2bf19a87ec84 ]---
[  352.352742] use_block_rsv: 146 callbacks suppressed
[  352.352750] btrfs: block rsv returned -28
[  352.352753] ------------[ cut here ]------------
[  352.352765] WARNING: at fs/btrfs/extent-tree.c:6297
btrfs_alloc_free_block+0x399/0x3a0()
[  352.352769] Hardware name: GA-MA74GM-S2H
[  352.352772] Modules linked in: fuse xt_pkttype af_packet ipt_REJECT
xt_conntrack iptable_raw xt_CT iptable_filter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf sp5100_tco usb_storage kvm_amd kvm snd_hda_codec_realtek
k10temp edac_core edac_mce_amd sr_mod cdrom i2c_piix4 snd_hda_intel
snd_hda_codec sg snd_hwdep snd_pcm snd_timer snd_page_alloc floppy edd
microcode autofs4 radeon ttm drm_kms_helper processor thermal_sys
pata_atiixp
[  352.352842] Pid: 320, comm: btrfs-balance Tainted: G        W
3.7.1-2.10-m4 #11
[  352.352845] Call Trace:
[  352.352872]  [<ffffffff810046c7>] dump_trace+0x87/0x2f0


I have requested a cancel, but this not honoered. After re-boot, the
filesystem balance operation is resumed, but hangs again:
# btrfs filesystem balance status /
Balance on '/' is running, cancel requested
2 out of about 5 chunks balanced (17 considered),  60% left

Any idea what's going on?

Thanks,
Mike
