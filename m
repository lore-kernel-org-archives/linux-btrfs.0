Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s28.hotmail.com ([65.55.116.39]:57300 "EHLO
	BLU004-OMC1S28.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbbJIN5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 09:57:41 -0400
Message-ID: <BLU436-SMTP21C3279F295A6811CDF2CEA9340@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
References: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
Date: Fri, 9 Oct 2015 15:52:37 +0200
Subject: Re: kernel BUG at /linux/fs/btrfs/extent-tree.c:1833!
From: Henk Slager <hslager@hotmail.com>
To: Peter Becker <floyd.net@gmail.com>
CC: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

I would try to add the mount option   skip_balance   for your raid1
pool first, then see if you can use your system as you normally would.
I assume you can live without explicit (re-)balance for some time,
i.e. that the original disks are not too full.

I recently did also some disks add/remove and also raid profile
convert and found out that kernel 4.2.x did crash my system with
various kernel bugs. So I switched back to 4.1.6 and although other
bugs hit me (see https://bugzilla.kernel.org/show_bug.cgi?id=104371 )
the actions I wanted did complete.

Using "btrfs check --repair" has never resulted in succes for me (for
some root filesystems (single profiles for s m d) on real and virual
machines), so I would only use that once you have your files backed up
on some other (cloned) filesystem.

/Henk

On Fri, Oct 9, 2015 at 9:41 AM, Peter Becker <floyd.net@gmail.com> wrote:
>
> At first i add a new device to my btrfs raid1 pool and start balance.
> After ~5 hours, balanace hangs and cpu-usage goes to 100% (kworker/u4
> use all cpu-power).
>
> What should i do now? Run "btrfs check --repair" on all devices?
>
> Kernel: 4.2.3-040203-generic
> Btrfs progs v4.2.1
>
> Full Syslog: https://bugzilla.kernel.org/show_bug.cgi?id=105681
>
> From Syslog:
>
> [16880.495586] kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:1833!
> [16880.495603] invalid opcode: 0000 [#1] SMP
> [16880.495614] Modules linked in: xt_nat veth xt_conntrack xt_addrtype
> br_netfilter nvram dm_thin_pool dm_persistent_data msr dm_bio_prison
> dm_bufio libcrc32c ir_lirc_codec ir_xmp_decoder lirc_dev
> ir_mce_kbd_decoder ir_sharp_decoder ir_sony_decoder ir_sanyo_decoder
> ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_rc6_mce
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 mceusb nf_nat_ipv4
> rc_core nf_nat nf_conntrack input_leds joydev xt_tcpudp bridge stp llc
> iptable_filter ip_tables x_tables autofs4 eeepc_wmi asus_wmi
> sparse_keymap dm_multipath scsi_dh intel_rapl iosf_mbi
> x86_pkg_temp_thermal intel_powerclamp kvm crct10dif_pclmul
> crc32_pclmul snd_seq_midi snd_seq_midi_event snd_rawmidi
> ghash_clmulni_intel cryptd snd_hda_codec_hdmi rfcomm snd_seq serio_raw
> bnep snd_hda_codec_realtek snd_hda_codec_generic bluetooth
> snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm
> snd_seq_device lpc_ich snd_timer mei_me mei snd shpchp mac_hid
> soundcore parport_pc ppdev nfsd nct6775 hwmon_vid coretemp auth_rpcgss
> nfs_acl nfs lockd grace binfmt_misc sunrpc lp parport fscache
> nls_iso8859_1 btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
> hid_generic usbhid hid uas usb_storage psmouse ahci libahci wmi i915
> video i2c_algo_bit drm_kms_helper drm e1000e ptp pps_core
> [16880.495944] CPU: 0 PID: 5967 Comm: btrfs Tainted: G     U
> 4.2.3-040203-generic #201510030832
> [16880.495964] Hardware name: ASUS All Series/H87I-PLUS, BIOS 2003 11/05/2014
> [16880.495979] task: ffff8800a918b300 ti: ffff8800a9f00000 task.ti:
> ffff8800a9f00000
> [16880.495995] RIP: 0010:[<ffffffffc02db016>]  [<ffffffffc02db016>]
> insert_inline_extent_backref+0xc6/0xd0 [btrfs]
> [16880.496028] RSP: 0018:ffff8800a9f03718  EFLAGS: 00010293
> [16880.496042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8800a9f03750
> [16880.496060] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
> [16880.496077] RBP: ffff8800a9f03788 R08: 0000000000004000 R09: ffff8800a9f03608
> [16880.496093] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880214b11000
> [16880.496109] R13: 000006a203798000 R14: 0000000000000000 R15: ffff8800d80c7990
> [16880.496125] FS:  00007fd9f02fa900(0000) GS:ffff88021fa00000(0000)
> knlGS:0000000000000000
> [16880.496146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16880.496159] CR2: 00007f438fbc2000 CR3: 00000000a90ae000 CR4: 00000000000406f0
> [16880.496175] Stack:
> [16880.496180]  000006a203798000 0000000000000414 0000000000000000
> 0000000000000000
> [16880.496200]  0000000000000001 ffffffffc02cef1a ffff8800a9f037f8
> 0000000000002bbd
> [16880.496220]  ffff88016f19f2e0 ffff880214b10000 ffff88016f19f2e0
> ffff8800d80c7990
> [16880.496239] Call Trace:
> [16880.496251]  [<ffffffffc02cef1a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [16880.496271]  [<ffffffffc02db0b8>]
> __btrfs_inc_extent_ref.isra.51+0x98/0x250 [btrfs]
> [16880.496295]  [<ffffffffc02e0d0a>]
> __btrfs_run_delayed_refs+0xcfa/0x1070 [btrfs]
> [16880.496316]  [<ffffffff813bda85>] ? __percpu_counter_add+0x55/0x70
> [16880.496337]  [<ffffffffc02e3c3e>]
> btrfs_run_delayed_refs.part.73+0x6e/0x280 [btrfs]
> [16880.496360]  [<ffffffffc02e3e67>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
> [16880.496383]  [<ffffffffc02f7dc9>]
> btrfs_should_end_transaction+0x49/0x60 [btrfs]
> [16880.496407]  [<ffffffffc02e2439>] btrfs_drop_snapshot+0x439/0x830 [btrfs]
> [16880.496431]  [<ffffffffc0346200>] ?
> invalidate_extent_cache+0x160/0x1a0 [btrfs]
> [16880.496455]  [<ffffffffc034b2e2>] merge_reloc_roots+0xd2/0x230 [btrfs]
> [16880.496475]  [<ffffffffc034b696>] relocate_block_group+0x256/0x600 [btrfs]
> [16880.496495]  [<ffffffffc034bc03>]
> btrfs_relocate_block_group+0x1c3/0x2d0 [btrfs]
> [16880.496517]  [<ffffffffc031f9be>]
> btrfs_relocate_chunk.isra.39+0x3e/0xc0 [btrfs]
> [16880.496537]  [<ffffffffc0320e3f>] __btrfs_balance+0x48f/0x8c0 [btrfs]
> [16880.496556]  [<ffffffffc03215ed>] btrfs_balance+0x37d/0x650 [btrfs]
> [16880.496575]  [<ffffffffc032d7b4>] ? btrfs_ioctl_balance+0x284/0x510 [btrfs]
> [16880.496594]  [<ffffffffc032d694>] btrfs_ioctl_balance+0x164/0x510 [btrfs]
> [16880.496613]  [<ffffffffc032fb8f>] btrfs_ioctl+0x56f/0x2470 [btrfs]
> [16880.496628]  [<ffffffff8118490b>] ?
> lru_cache_add_active_or_unevictable+0x2b/0xa0
> [16880.496645]  [<ffffffff811a4d9a>] ? handle_mm_fault+0xb8a/0x1810
> [16880.496658]  [<ffffffff811a8f39>] ? vma_link+0xb9/0xc0
> [16880.496670]  [<ffffffff811fc6fd>] do_vfs_ioctl+0x2cd/0x4b0
> [16880.496684]  [<ffffffff81063cc7>] ? __do_page_fault+0x1b7/0x430
> [16880.496697]  [<ffffffff811fc959>] SyS_ioctl+0x79/0x90
> [16880.496709]  [<ffffffff817a9b72>] entry_SYSCALL_64_fastpath+0x16/0x75
> [16880.496723] Code: 45 10 49 89 d9 48 8b 55 c8 4c 89 34 24 4c 89 e9
> 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 4e e4 ff ff
> 31 c0 eb bb <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5
> 41 57
> [16880.496802] RIP  [<ffffffffc02db016>]
> insert_inline_extent_backref+0xc6/0xd0 [btrfs]
> [16880.496823]  RSP <ffff8800a9f03718>
> [16880.502316] ---[ end trace bcd7d52a2c7cfdc7 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
