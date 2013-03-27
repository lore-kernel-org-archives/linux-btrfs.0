Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:60134 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3C0LzH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 07:55:07 -0400
Message-ID: <5152DE0B.9030703@giantdisaster.de>
Date: Wed, 27 Mar 2013 12:54:51 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, Sami Liedes <sami.liedes@iki.fi>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120702230121.GD12755@sli.dy.fi>
In-Reply-To: <20120702230121.GD12755@sli.dy.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 3 Jul 2012 02:01:21 +0300, Sami Liedes wrote:
> Hi,
> 
> I just got this oops on a computer running 3.4.2.
> 
> A few minutes before I had started "btrfs device scrub /" and had a
> watcher process running "btrfs scrub status /" every 5 seconds. After
> a few gigabytes of scrubbing, I got this crash.
> 
> The oops is transcribed from photos, so it may contain some errors. I
> tried to be careful, and double checked the backtrace.
> 
> 	Sami
> 
> ------------------------------------------------------------
> general protection fault: 0000 [#1] SMP
> CPU 4
> Modules linked in: tcp_diag inet_diag nfnetlink_log nfnetlink ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs ext3 jbd ext2 ip6_tables ebtable_nat ebtables cn rfcomm bnep
> parport_pc ppdev lp parport tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative binfmt_misc fuse nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc iptable_filter ipt_MASQUERADE
> ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables xfs ext4 jbd2 mbcache radeon drm_kms_helper ttm drm i2c_algo_bit loop kvm_intel kvm snd_hda_codec_hdmi
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_usbmidi_lib snd_hwdep snd_pcm_oss snd_mixer_oss joydev snd_pcm acpi_cpufreq snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmi
> di ath3k snd_seq snd_seq_device snd_timer iTCO_wdt bluetooth eeepci_wmi asus_wmi sparse_keymap crc16 rfkill pcspkr psmouse coretemp serio_raw evdev mperf pci_hotplug i2c_i801 i2c_core processor button
> intel_agp snd mxm_wmi video wmi intel_gtt microcode soundcore sha256_generic dm_crypt dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq md_mod nbd btrfs libcrc32c
> zlib_deflate sd_mod crc_t10dif crc32c_intel ghash_cmulni_intel firewire_ohci r8196 firewire_core ahci aesni_intel libahci mii crc_itu_t aes_x86_64 libata aes_generic cryptd scsi_mod e1000e thermal fa
> n thermal_sys [last unloaded: scsi_wait_scan]
> 
> Pid: 30863, comm: btrfs-endio-met Tainted: G        W    3.4.2 #1 System manufacturer System Product Name/P8P67 EVO
> RIP: 0010:[<ffffffff811e83bd>]  [<ffffffff811e83bd>] memcpy+0xd/0x110
> RSP: 0000:ffff88003174dba8  EFLAGS: 00010202
> RAX: ffff88003174dc8f RBX: 0000000000000011 RCX: 0000000000000002
> RDX: 0000000000000001 RSI: 0005080000000003 RDI: ffff88003174dc8f
> RBP: ffff88003174dbf0 R08: 000000000000000a R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003174dca0
> R13: ffff8800659f42b0 R14: 0000000000000048 R15: 0000000000000011
> FS:  0000000000000000(0000) GS:ffff88021ed00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000973c000 CR3: 0000000167ef3000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs-endio-met (pid: 30863, threadinfo ffff88003174c000, task ffff88006f818000)
> Stack:
>  ffffffffa026bd6b ffff8801960f5000 0000000000008003 0000000000001000
>  ffff88003174dc58 00000000000003dd ffff88000ac13c60 ffff88003174dc58
>  696f70203a61685f ffff88003174dc00 ffffffffa026904d ffff88003174dcd0
> Call Trace:
>  [<ffffffffa026bd6b>] ? read_extent_buffer+0xbb/0x110 [btrfs]
>  [<ffffffffa026304d>] btrfs_node_key+0x1d/0x20 [btrfs]
>  [<ffffffffa02994e0>] __readahead_hook.isra.5+0x3c0/0x420 [btrfs]
>  [<ffffffffa029986f>] btree_readahead_hook+0x1f/0x40 [btrfs]
>  [<ffffffffa023f841>] btree_readpage_end_io_hook+0x111/0x260 [btrfs]
>  [<ffffffffa0267452>] ? find_first_extent_bit_state+0x22/0x80 [btrfs]
>  [<ffffffffa026809b>] end_bio_extent_readpage+0xcb/0xa30 [btrfs]
>  [<ffffffffa023ee61>] ? end_workqueue_fn+0x31/0x50 [btrfs]
>  [<ffffffff81158958>] bio_endio+0x18/0x30
>  [<ffffffffa023ee6c>] end_workqueue_fn+0x3c/0x50 [btrfs]
>  [<ffffffffa0275857>] worker_loop+0x157/0x560 [btrfs]
>  [<ffffffffa0275700>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
>  [<ffffffff81058e5e>] kthread+0x8e/0xa0
>  [<ffffffff81418fe4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81058dd0>] ? flush_kthread_worker+0x70/0x70
>  [<ffffffff81418fe0>] ? gs_change+0x13/0x13
> Code: 4e 48 83 c4 08 5b 5d c3 66 0f 1f 44 00 00 e8 eb fb ff ff eb e1 90 90 90 90 90 90 90...
> 8 4c 8b 56 10 4c
> RIP  [<ffffffff811e83bd>] memcpy+0xd/0x110
>  RSP <ffff88003174dba8>
> 


Tonight my box had the same on a system running 3.7.10. Also with a Btrfs scrub running.

general protection fault: 0000 [#1] SMP
Modules linked in: xt_LOG xt_limit xt_multiport iptable_nat nf_nat_ipv4 nf_nat ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_mangle ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables bnep rfcomm bluetooth sp5100_tco edac_core edac_mce_amd k8temp i2c_piix4 kvm_amd kvm e1000e serio_raw mac_hid shpchp lp parport btrfs zlib_deflate libcrc32c raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 multipath linear ahci libahci [last unloaded: ipmi_msghandler]
CPU 1
Pid: 10376, comm: btrfs-endio-met Not tainted 3.7.10-030710-generic #201302271235 MICRO-STAR INTERNATIONAL CO., LTD MS-96B3/MS-96B3
RIP: 0010:[<ffffffff8134dcc2>]  [<ffffffff8134dcc2>] memcpy+0x12/0x110
RSP: 0018:ffff88011791fbc0  EFLAGS: 00010206
RAX: ffff88011791fca5 RBX: ffff88005d6836d8 RCX: 0000000000000003
RDX: 0000000000000003 RSI: 0005080000000000 RDI: ffff88011791fca5
RBP: ffff88011791fc08 R08: 0000000000003fd1 R09: ffff88011791fbd8
R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000003
R13: 0000000000000003 R14: ffff88011791fca8 R15: 0000000000000028
FS:  00007f78717fa700(0000) GS:ffff88011fc80000(0000) knlGS:00000000f743f700
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600000 CR3: 0000000092a4e000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-met (pid: 10376, threadinfo ffff88011791e000, task ffff8801128a1700)
Stack:
 ffffffffa00f1e5c ffff88010e407000 0000000000003000 0000000000001000
 ffff88011791fca8 ffff880073b5cea0 9b9628ac89c7f24a ffff88011791fca8
 00000000000001ed ffff88011791fc18 ffffffffa00e87f2 ffff88011791fce8
Call Trace:
 [<ffffffffa00f1e5c>] ? read_extent_buffer+0xbc/0x120 [btrfs]
 [<ffffffffa00e87f2>] btrfs_node_key+0x22/0x30 [btrfs]
 [<ffffffffa01255d3>] __readahead_hook.isra.4+0x3d3/0x410 [btrfs]
 [<ffffffffa01259d4>] btree_readahead_hook+0x24/0x40 [btrfs]
 [<ffffffffa00cd7b9>] btree_readpage_end_io_hook+0x149/0x290 [btrfs]
 [<ffffffffa00ee912>] end_bio_extent_readpage+0x142/0x330 [btrfs]
 [<ffffffffa00cbe66>] ? end_workqueue_fn+0x36/0x50 [btrfs]
 [<ffffffff811c8a5d>] bio_endio+0x1d/0x40
 [<ffffffffa00cbe71>] end_workqueue_fn+0x41/0x50 [btrfs]
 [<ffffffffa00fcd80>] worker_loop+0xa0/0x320 [btrfs]
 [<ffffffffa00fcce0>] ? check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
 [<ffffffff8107dca0>] kthread+0xc0/0xd0
 [<ffffffff8107dbe0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff816d19ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107dbe0>] ? flush_kthread_worker+0xb0/0xb0
Code: 4e 48 83 c4 08 5b 5d c3 90 e8 fb fd ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 <f3> a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d
RIP  [<ffffffff8134dcc2>] memcpy+0x12/0x110
 RSP <ffff88011791fbc0>
---[ end trace 76ff4bab3b10384b ]---

Looking at memcpy() in arch/x86/lib/memcpy_64.S, RDX is the length, RSI the source and RDI the destination.
And looking at the registers when the issue happens, there's a pattern. RDX is not as expected, RSI is 000508000000.... and RDI looks good.

The one from tonight: RDX is 0x3 (0x11 would be expected), RSI is 0005080000000000 (unexpected), RDI is ffff88011791fca5 (looks good).
The one from Sami in the quoted mail is excatly the same issue that my box had tonight. RDX is 0x1 (0x11 would be expected), RSI is 0005080000000003, RDI looks good.
"GPF in read_extent_buffer while scrubbing on 3.7.0-rc8-00014-g27d7c2a" http://comments.gmane.org/gmane.comp.file-systems.btrfs/21559 is the same, but this time RDX is 0x11 as expected. RSI is 0005080000000003 (unexpected), RDI looks good.
http://abrt.fedoraproject.org/faf/problems/326667/ is something that shows a similar pattern (without Btrfs being involved), here the "report backtrace 53429" looks somehow similar (memcpy is the crashing function, RSI: 00050800000007e1, RDI would make sense).

What's causing this issue? The RSI register content, does it look like CPU flags or anything else known?

