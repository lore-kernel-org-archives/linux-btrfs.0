Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60496 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBXRf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 12:35:29 -0500
Date: Mon, 24 Feb 2014 09:35:19 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140224173519.GD11827@merlins.org>
References: <20140224061426.GB15937@merlins.org>
 <20140224061714.GC15937@merlins.org>
 <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
 <20140224065847.GE15937@merlins.org>
 <pan$2c66d$b9df9232$d5e4e0c4$992cc0f6@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$2c66d$b9df9232$d5e4e0c4$992cc0f6@cox.net>
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 07:29:58AM +0000, Duncan wrote:
> > But I'm still seeing these, albeit less often.
> > Any idea what they could be linked to?
> > (I have a btrs send/receive going right now, it could hanging
> > /mnt/btrfs_pool1 in a way that affects smbd, but the array feels ok
> > otherwise, weird...)
> > 
> > [ 1332.548370] INFO: task smbd:21882 blocked for more than 120 seconds.
> > [ 1332.587455]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
> > [ 1332.625478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> 
> I've not seen anything like that here, but there are several kernel 
> 3.13/3.14-rc reports of similar behavior on the list.
 
I'll have to try this. Interestingly, I just got the following overnight.

Something killed 3 different drives from software raid arrays, and the
drives are all fine.

It looks like btrfs hung my kernel hard enough that it messed up
software raid, killed my array on which btrfs was, and then caused a
cascade of further btrfs failures.
Are those 2 traces useful?

Many of these errors:
[23721.563736] BUG: soft lockup - CPU#0 stuck for 22s! [btrfs:6140]
[23721.601096] Modules linked in:[23721.601096] Modules linked in: ip6table_filter ip6table_filter ip6_tables ip6_tables ebtable_nat ebtable_nat ebtables ebtables tun tun ppdev ppdev lp lp autofs4 autofs4 binfmt_misc binfmt_misc kl5kusb105 kl5kusb105 deflate deflate ctr ctr twofish_generic twofish_generic twofish_common twofish_common camellia_generic camellia_generic serpent_generic serpent_generic blowfish_generic blowfish_generic blowfish_common blowfish_common cast5_generic cast5_generic cast_common cast_common ftdi_sio ftdi_sio des_generic des_generic keyspan keyspan cmac cmac xcbc xcbc rmd160 rmd160 sha512_generic sha512_generic crypto_null crypto_null af_key af_key xfrm_algo xfrm_algo dm_mirror dm_mirror dm_region_hash dm_region_hash dm_log dm_log nfsd nfsd nfs_acl nfs_acl auth_rpcgss auth_rpcgss nfs nfs fscache fscache lockd lockd sunrpc sunrpc ipt_REJECT ipt_REJECT xt_conntrack xt_conntrack xt_nat xt_nat xt_tcpudp xt_tcpudp xt_LOG xt_LOG iptable_mangle iptable_mangle iptable_filter iptable_filter fuse fuse lm85 lm85 hwmon_vid hwmon_vid dm_snapshot dm_snapshot iptable_nat iptable_nat ip_tables ip_tables nf_conntrack_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat_ipv4 nf_conntrack_ftp nf_conntrack_ftp ipt_MASQUERADE ipt_MASQUERADE nf_nat nf_nat x_tables x_tables nf_conntrack nf_conntrack sg sg st st snd_pcm_oss snd_pcm_oss snd_mixer_oss snd_mixer_oss snd_cmipci snd_cmipci gameport gameport microcode microcode snd_opl3_lib snd_opl3_lib snd_mpu401_uart snd_mpu401_uart kvm_intel kvm_intel snd_seq_midi snd_seq_midi kvm kvm eeepc_wmi eeepc_wmi snd_seq_midi_event snd_seq_midi_event rc_ati_x10 rc_ati_x10 asus_wmi asus_wmi ati_remote ati_remote snd_seq snd_seq sparse_keymap sparse_keymap coretemp coretemp asix asix snd_rawmidi snd_rawmidi snd_hda_codec_realtek snd_hda_codec_realtek parport_pc parport_pc libphy libphy intel_rapl intel_rapl rfkill rfkill parport parport pl2303 pl2303 x86_pkg_temp_thermal x86_pkg_temp_thermal snd_seq_device snd_seq_device intel_powerclamp intel_powerclamp rc
_core rc_core usbnet usbnet wmi wmi ezusb ezusb tpm_tis tpm_tis tpm tpm pcspkr pcspkr usbserial usbserial snd_hda_intel snd_hda_intel evdev evdev snd_hda_codec snd_hda_codec i2c_i801 i2c_i801 snd_hwdep snd_hwdep snd_pcm snd_pcm snd_timer snd_timer processor processor lpc_ich lpc_ich xhci_hcd xhci_hcd snd snd soundcore soundcore snd_page_alloc snd_page_alloc xts xts gf128mul gf128mul dm_crypt dm_crypt dm_mod dm_mod raid456 raid456 async_raid6_recov async_raid6_recov async_pq async_pq async_xor async_xor async_memcpy async_memcpy async_tx async_tx e1000e e1000e ptp ptp pps_core pps_core ehci_pci ehci_pci r8169 r8169 ehci_hcd ehci_hcd sata_sil24 sata_sil24 sata_mv sata_mv thermal thermal mii mii crc32_pclmul crc32_pclmul crc32c_intel crc32c_intel fan fan usbcore usbcore usb_common usb_common [last unloaded: kl5kusb105] [last unloaded: kl5kusb105]
[23722.377527] CPU: 0 PID: 6140 Comm: btrfs Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[23722.427962] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[23722.484154] task: f1a00510 ti: c6f84000 task.ti: c6f84000
[23722.517991] EIP: 0060:[<c119e324>] EFLAGS: 00000282 CPU: 0
[23722.552341] EIP is at btrfs_comp_cpu_keys+0x6/0x72
[23722.582497] EAX: c6f85cc7 EBX: 00000000 ECX: 00000d41 EDX: c6f85e05
[23722.621532] ESI: 00000000 EDI: 00000258 EBP: c6f85cbc ESP: c6f85cb0
[23722.660543]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[23722.694331] CR0: 80050033 CR2: b754df59 CR3: 2d7a5000 CR4: 000407d0
[23722.733354] Stack:
[23722.746819]  00000000[23722.746819]  00000000 00000000 00000000 00000258 00000258 c6f85cdc c6f85cdc c119e3c1 c119e3c1 410002bd 410002bd 0000000d 0000000d 6c000000 6c000000
[23722.794851]  00100000[23722.794851]  00100000 00000000 00000000 000002bd 000002bd c6f85d24 c6f85d24 c119e47d c119e47d c6f85e05 c6f85e05 00000019 00000019 00000018 00000018
[23722.842884]  c9c677d0[23722.842884]  c9c677d0 00000018 00000018 c7728000 c7728000 00000000 00000000 00001000 00001000 dfaca800 dfaca800 c6f85d2c c6f85d2c c1054429 c1054429
[23722.890935] Call Trace:
[23722.907058]  [<c119e3c1>] comp_keys+0x31/0x37
[23722.934655]  [<c119e47d>] generic_bin_search.constprop.24+0xb6/0xf5
[23722.973703]  [<c1054429>] ? try_to_wake_up+0x176/0x180
[23723.005987]  [<c119e4fa>] bin_search+0x3e/0x48
[23723.034114]  [<c119fd16>] btrfs_search_slot+0x22b/0x59c
[23723.066926]  [<c1104989>] ? __sb_start_write+0x86/0xb3
[23723.099195]  [<c11a2028>] btrfs_search_slot_for_read+0x32/0xc9
[23723.135657]  [<c1208a6e>] btrfs_ioctl_send+0x6c6/0x8a5
[23723.167948]  [<c10c77aa>] ? __rmqueue+0x7f/0x241
[23723.197116]  [<c11e144b>] ? update_ioctl_balance_args+0xde/0xde
[23723.234097]  [<c11e2a06>] btrfs_ioctl+0x15bb/0x23a5
[23723.264824]  [<c1005daf>] ? __cycles_2_ns+0x19/0x78
[23723.295550]  [<c1006318>] ? native_sched_clock+0x3a/0x3d
[23723.328862]  [<c1005c8f>] ? paravirt_sched_clock+0x9/0xd
[23723.362189]  [<c1005daf>] ? __cycles_2_ns+0x19/0x78
[23723.392889]  [<c10584ab>] ? update_rq_runnable_avg+0x1f0/0x1f8
[23723.429328]  [<c105788f>] ? hrtick_update+0x17/0x42
[23723.460037]  [<c11e144b>] ? update_ioctl_balance_args+0xde/0xde
[23723.497023]  [<c110f0d1>] do_vfs_ioctl+0x3d9/0x417
[23723.527188]  [<c110f0d1>] ? do_vfs_ioctl+0x3d9/0x417
[23723.558335]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[23723.596240]  [<c10508ae>] ? task_rq_unlock+0x1b/0x1f
[23723.627346]  [<c1109340>] ? path_put+0x1a/0x1d
[23723.655279]  [<c110f159>] SyS_ioctl+0x4a/0x6b
[23723.682661]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[23723.713642] Code:[23723.713642] Code: 8b 8b 45 45 dc dc 85 85 c0 c0 74 74 14 14 8b 8b 75 75 cc cc 39 39 06 06 74 74 05 05 e8 e8 d8 d8 5a 5a 04 04 00 00 8b 8b 45 45 dc dc e8 e8 46 46 48 48 03 03 00 00 89 89 f8 f8 8d 8d 65 65 f4 f4 5b 5b 5e 5e 5f 5f 5d 5d c3 c3 55 55 89 89 e5 e5 57 57 56 56 53 53 <66> <66> 66 66 66 66 66 66 90 90 8b 8b 78 78 04 04 8b 8b 72 72 04 04 8b 8b 18 18 8b 8b 0a 0a 39 39 f7 f7 77 77 4d 4d 72 72 46 46

Then eventually this:
[34474.730456] NMI backtrace for cpu 2
[34474.730458] CPU: 2 PID: 697 Comm: md8_raid5 Tainted: G        W    3.13.5-ia32-i915-preempt-20140216 #1
[34474.730459] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[34474.730461] task: f3cee090 ti: f2f76000 task.ti: f2f76000
[34474.730462] EIP: 0060:[<c1029222>] EFLAGS: 00000002 CPU: 2
[34474.730465] EIP is at early_serial_putc+0x1a/0x33
[34474.730467] EAX: 00000000 EBX: 000003f8 ECX: 0000ffe3 EDX: 000003fd
[34474.730468] ESI: 00000020 EDI: 00000006 EBP: f2f77c04 ESP: f2f77bfc
[34474.730470]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[34474.730471] CR0: 80050033 CR2: b774b000 CR3: 09bc4000 CR4: 000407d0
[34474.730472] Stack:
[34474.730477]  c18eb911 c18eb939 f2f77c14 c102925e c17cd3ec 00000059 f2f77c28 c106adc3
[34474.730481]  c19017ac 00000006 00000059 f2f77c5c c106b971 c18eb8e0 00000400 00015250
[34474.730485]  c150348b 0001b51f 00000000 00000001 00000086 00000052 00000001 00000000
[34474.730486] Call Trace:
[34474.730489]  [<c102925e>] early_serial_write+0x23/0x31
[34474.730492]  [<c106adc3>] call_console_drivers.constprop.6+0x91/0xb9
[34474.730495]  [<c106b971>] console_unlock+0x286/0x324
[34474.730497]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[34474.730500]  [<c106bd9a>] vprintk_emit+0x38b/0x3b2
[34474.730503]  [<c1051521>] ? finish_task_switch+0x70/0xa1
[34474.730506]  [<c14fb213>] printk+0x1c/0x1e
[34474.730509]  [<c11d4c69>] btrfs_dev_stat_print_on_error+0x62/0x72
[34474.730512]  [<c11d4d04>] btrfs_end_bio+0x8b/0xf4
[34474.730516]  [<c1126e78>] bio_endio+0x2a/0x2c
[34474.730526]  [<f88e60de>] dec_pending+0x268/0x294 [dm_mod]
[34474.730534]  [<f88e6902>] clone_endio+0x7b/0x83 [dm_mod]
[34474.730537]  [<c1126e78>] bio_endio+0x2a/0x2c
[34474.730543]  [<f856933e>] crypt_dec_pending+0x48/0x65 [dm_crypt]
[34474.730548]  [<f8569766>] crypt_endio+0x88/0x8e [dm_crypt]
[34474.730553]  [<f85696de>] ? crypt_free_buffer_pages.isra.10+0x44/0x44 [dm_crypt]
[34474.730556]  [<c1126e78>] bio_endio+0x2a/0x2c
[34474.730563]  [<f8883eb6>] return_io+0x3b/0x45 [raid456]
[34474.730570]  [<f888a3ee>] handle_stripe+0x1e34/0x1e79 [raid456]
[34474.730579]  [<f888a677>] handle_active_stripes.isra.23+0x244/0x2b8 [raid456]
[34474.730586]  [<f888a677>] ? handle_active_stripes.isra.23+0x244/0x2b8 [raid456]
[34474.730592]  [<f8884054>] ? __release_stripe+0x2d/0x32 [raid456]
[34474.730599]  [<f888a9aa>] raid5d+0x2bf/0x3ca [raid456]
[34474.730606]  [<f888a9aa>] ? raid5d+0x2bf/0x3ca [raid456]
[34474.730609]  [<c10217f1>] ? smp_reschedule_interrupt+0x19/0x1b
[34474.730612]  [<c1501477>] ? schedule+0x63/0x65
[34474.730615]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[34474.730618]  [<c141a1d5>] md_thread+0xed/0x104
[34474.730620]  [<c141a1d5>] ? md_thread+0xed/0x104
[34474.730623]  [<c105e774>] ? finish_wait+0x4e/0x4e
[34474.730625]  [<c141a0e8>] ? bb_store+0x4b/0x4b
[34474.730627]  [<c10496d4>] kthread+0x8d/0x92
[34474.730630]  [<c1508bf7>] ret_from_kernel_thread+0x1b/0x28
[34474.730633]  [<c1049647>] ? __kthread_parkme+0x55/0x55
[34474.730658] Code: 3b 75 e8 0f 85 1c ff ff ff 83 c4 0c 5b 5e 5f 5d c3 55 b9 ff ff 00 00 89 e5 56 89 c6 53 eb 02 f3 90 8b 1d 24 d4 7c c1 8d 53 05 ec <a8> 20 75 03 49 75 ed 89 f0 89 da ee 5b 31 c0 85 c9 0f 94 c0 f7


and plenty of those after that.
[34223.863987] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5692324, flush 0, corrupt 0, gen 0
[34228.450714] btrfs_dev_stat_print_on_error: 17000 callbacks suppressed
[34228.658914] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709325, flush 0, corrupt 0, gen 0
[34228.658914] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709325, flush 0, corrupt 0, gen 0
[34228.763017] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709326, flush 0, corrupt 0, gen 0
[34230.564858] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709327, flush 0, corrupt 0, gen 0
[34230.617159] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709328, flush 0, corrupt 0, gen 0
[34230.684634] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709329, flush 0, corrupt 0, gen 0
[34230.736985] btrfs: bdev /dev/mapper/dshelf2 errs: wr 13, rd 5709330, flush 0, corrupt 0, gen 0


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
