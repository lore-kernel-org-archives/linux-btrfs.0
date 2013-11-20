Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:59589 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3KTDqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 22:46:11 -0500
Received: by mail-bk0-f48.google.com with SMTP id v10so2736745bkz.21
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 19:46:09 -0800 (PST)
Received: from linux-suse.localnet (5401C5A6.dsl.pool.telekom.hu. [84.1.197.166])
        by mx.google.com with ESMTPSA id l5sm22805792bko.7.2013.11.19.19.46.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2013 19:46:08 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs warning on file system defrag
Date: Wed, 20 Nov 2013 04:45:46 +0100
Message-ID: <3545636.faj611BQxI@linux-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

While I was defragging my file system, the following warning showed up in the 
dmesg:

[ 6323.296521] ------------[ cut here ]------------
[ 6323.296551] WARNING: CPU: 5 PID: 13598 at 
/home/abuild/rpmbuild/BUILD/kernel-
desktop-3.12.0/linux-3.12/fs/btrfs/backref.c:934 find_parent_nodes+0xe64/0xe70 
[btrfs]()
[ 6323.296552] Modules linked in: bnep bluetooth rfkill nvidia(PO) drm 
xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT nf_conntrack_ipv6 
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT ipt
able_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables fuse 
snd_hda_codec_hdmi coretemp gpio_ich mxm_wmi iTCO_wdt i
TCO_vendor_support kvm_intel usb_storage kvm snd_hda_codec_realtek sr_mod 
pcspkr snd_hda_intel serio_raw snd_hda_codec cdrom r8169 mii acpi_cpufreq wmi 
snd_seq snd_hwdep snd_seq_device snd_pcm button snd_time
r lpc_ich i7core_edac mfd_core i2c_i801 snd edac_core soundcore snd_page_alloc 
shpchp sg nf_conntrack ip_tables x_tables dm_mod autofs4 btrfs raid6_pq xor 
libcrc32c crc32c_intel hid_logitech_dj
[ 6323.296580]  processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc 
scsi_dh_alua scsi_dh ata_generic ata_piix [last unloaded: drm]
[ 6323.296588] CPU: 5 PID: 13598 Comm: btrfs-endio-wri Tainted: P           O 
3.12.0-6.ge7c00d8-desktop #1
[ 6323.296589] Hardware name: MSI MS-7522/MSI X58 Pro-E (MS-7522), BIOS V8.15 
03/19/2011
[ 6323.296591]  0000000000000009 ffffffff815bd494 0000000000000000 ffffffff810521d2
[ 6323.296594]  ffff880109231ba8 ffff88014d51d6e0 0000000000000000 ffff880000000000
[ 6323.296596]  ffff88016d5a1640 ffffffffa01100b4 ffffffff00000001 ffff880100000050
[ 6323.296598] Call Trace:
[ 6323.296610]  [<ffffffff81004a28>] dump_trace+0x88/0x310
[ 6323.296613]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
[ 6323.296616]  [<ffffffff810061cc>] show_stack+0x1c/0x50
[ 6323.296621]  [<ffffffff815bd494>] dump_stack+0x50/0x89
[ 6323.296628]  [<ffffffff810521d2>] warn_slowpath_common+0x72/0x90
[ 6323.296643]  [<ffffffffa01100b4>] find_parent_nodes+0xe64/0xe70 [btrfs]
[ 6323.296749]  [<ffffffffa0110a96>] iterate_extent_inodes+0xf6/0x320 [btrfs]
[ 6323.296820]  [<ffffffffa0110d44>] iterate_inodes_from_logical+0x84/0xa0 [btrfs]
[ 6323.296887]  [<ffffffffa00b820b>] record_extent_backrefs+0x6b/0xe0 [btrfs]
[ 6323.296920]  [<ffffffffa00c25b0>] btrfs_finish_ordered_io+0x1d0/0xad0 [btrfs]
[ 6323.297008]  [<ffffffffa00e43d9>] worker_loop+0x149/0x550 [btrfs]
[ 6323.297065]  [<ffffffff8107355f>] kthread+0xaf/0xc0
[ 6323.297071]  [<ffffffff815caf8c>] ret_from_fork+0x7c/0xb0
[ 6323.297074] ---[ end trace f4f4fc91916d37a0 ]---

Versions:
- OS: openSUSE 13.1
- Kernel: Linux linux-suse 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT Tue Nov 12 
13:09:24 UTC 2013 (e7c00d8) x86_64 x86_64 x86_64 GNU/Linux
- btrfs: Btrfs v0.20-rc1
- Ran command: ./btrfs fi defrag -clzo -r -v /usr/

Ákos
