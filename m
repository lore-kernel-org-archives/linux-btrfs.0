Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56076 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750792Ab2FROmJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 10:42:09 -0400
Message-ID: <4FDF3E3D.70806@gmx.de>
Date: Mon, 18 Jun 2012 16:42:05 +0200
From: Ronny Pfannschmidt <Ronny.Pfannschmidt@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: a stacktrace i had on my luks encrypted btrfs partition on kernel
 3.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while doing work, my luks encrypted btrfs home got a nice stacktrace

i run a Debian testing and a kernel 3.4 vanilla

% uname -a
Linux Klappe2 3.4.0 #2 SMP Thu Jun 14 03:02:37 CEST 2012 x86_64 GNU/Linux

the box is a dell xps m 1330 with about 4gb ram


% btrfs fi show
Label: 'home'  uuid: 9c1a77c9-3767-43aa-908d-0bae1ef4e534
	Total devices 1 FS bytes used 198.25GB
	devid    2 size 895.12GB used 284.12GB path /dev/dm-0



when the trace happened i was logged in with 2 x11 users via gdm3
in one of them i had a testsuite running that was forking excessively

in both users i had some normal apps running (browser, mail, im, irc)

the relevant trace follows

-- Ronny Pfannschmidt

[31985.760236] wlan0: no IPv6 routers present
[34736.233556] stack segment: 0000 [#1] SMP
[34736.233603] CPU 1
[34736.233622] Modules linked in: iwl3945 uvcvideo ip6table_filter 
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
binfmt_misc tun bridge stp snd_hrtimer cpufreq_userspace cpufreq_stats 
parport_pc ppdev cpufreq_conservative lp parport cpufreq_powersave 
uinput sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt 
snd_hda_codec_hdmi snd_hda_codec_idt videobuf2_vmalloc snd_hda_intel 
videobuf2_memops snd_hda_codec videobuf2_core videodev media snd_hwdep 
snd_pcm_oss snd_mixer_oss snd_pcm joydev r592 arc4 snd_page_alloc 
iwlegacy mac80211 snd_seq_midi snd_seq_midi_event snd_rawmidi i915 
drm_kms_helper snd_seq psmouse memstick snd_seq_device snd_timer battery 
cfg80211 dell_wmi acpi_cpufreq dell_laptop r852 sparse_keymap mperf drm 
i2c_algo_bit evdev snd wmi ac iTCO_wdt power_supply iTCO_vendor_support 
dcdbas processor video button coretemp microcode sm_common nand nand_ecc 
nand_ids mtd i2c_i801 serio_raw i2c_core rfkill soundcore kvm_intel kvm 
autofs4 ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate 
dm_mod usbhid hid sd_mod sr_mod cdrom crc_t10dif ata_generic thermal tg3 
firewire_ohci thermal_sys ahci libahci ata_piix sdhci_pci sdhci mmc_core 
uhci_hcd libphy firewire_core crc_itu_t libata ehci_hcd scsi_mod usbcore 
usb_common [last unloaded: iwl3945]
[34736.234950]
[34736.234966] Pid: 23, comm: kswapd0 Not tainted 3.4.0 #2 Dell Inc. XPS 
M1330                       /0N6705
[34736.235036] RIP: 0010:[<ffffffffa01ec2a8>]  [<ffffffffa01ec2a8>] 
btrfs_release_extent_buffer_page.constprop.37+0x49/0xc5 [btrfs]
[34736.235156] RSP: 0018:ffff880116fff9e0  EFLAGS: 00010286
[34736.235194] RAX: ffff8800bf66e7e8 RBX: ffff8800bf66e718 RCX: 
0000000000000000
[34736.235237] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 
00000000041cf0f9
[34736.235280] RBP: fffe0004febff800 R08: ffff880116fffbd0 R09: 
ffffffffffffffff
[34736.235323] R10: ffffffffffffffff R11: ffff880116fffb08 R12: 
0000000000000000
[34736.235366] R13: 0000000000000000 R14: 0000000000000001 R15: 
0000000000000000
[34736.235409] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) 
knlGS:0000000000000000
[34736.235463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[34736.235499] CR2: 0000000001bd90b8 CR3: 00000000b830c000 CR4: 
00000000000007e0
[34736.235542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[34736.235584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[34736.235628] Process kswapd0 (pid: 23, threadinfo ffff880116ffe000, 
task ffff880119fda870)
[34736.235676] Stack:
[34736.235694]  ffffea0001a52150 ffff8800bf66e718 ffff88011790bc28 
ffffea0001a52150
[34736.235757]  ffffea0001a52130 ffffffffa01ec37e 00000000ffffffff 
ffff8800bf66e718
[34736.235818]  ffffea0001a52130 ffffffffa01ee04d 0100000000000909 
ffff880116fffdb0
[34736.235879] Call Trace:
[34736.235928]  [<ffffffffa01ec37e>] ? 
release_extent_buffer.isra.28+0x5a/0x76 [btrfs]
[34736.235993]  [<ffffffffa01ee04d>] ? 
try_release_extent_buffer+0x96/0xa1 [btrfs]
[34736.236009]  [<ffffffff810c674e>] ? shrink_page_list+0x55b/0x741
[34736.236009]  [<ffffffff810faba7>] ? lookup_page_cgroup+0x31/0x3a
[34736.236009]  [<ffffffff810cda7e>] ? zone_page_state_add+0x14/0x23
[34736.236009]  [<ffffffff810ce298>] ? __mod_zone_page_state+0x3c/0x45
[34736.236009]  [<ffffffff810c5613>] ? 
update_isolated_counts.isra.44+0x109/0x128
[34736.236009]  [<ffffffff810c6d24>] ? shrink_inactive_list+0x237/0x439
[34736.236009]  [<ffffffff810c7589>] ? shrink_mem_cgroup_zone+0x371/0x480
[34736.236009]  [<ffffffff810c76fa>] ? shrink_zone+0x62/0x9b
[34736.236009]  [<ffffffff810c8402>] ? balance_pgdat+0x2cb/0x586
[34736.236009]  [<ffffffff810c8989>] ? kswapd+0x2cc/0x2e8
[34736.236009]  [<ffffffff810524fb>] ? add_wait_queue+0x3c/0x3c
[34736.236009]  [<ffffffff810c86bd>] ? balance_pgdat+0x586/0x586
[34736.236009]  [<ffffffff81051e9e>] ? kthread+0x7d/0x85
[34736.236009]  [<ffffffff8135f924>] ? kernel_thread_helper+0x4/0x10
[34736.236009]  [<ffffffff81051e21>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[34736.236009]  [<ffffffff8135f920>] ? gs_change+0x13/0x13
[34736.236009] Code: 15 ff ff ff 48 85 c0 49 89 c4 0f 84 8f 00 00 00 4c 
8d 2c c5 f8 ff ff ff 48 8b 83 50 01 00 00 49 ff cc 4a 8b 2c 28 48 85 ed 
74 67 <48> 8b 7d 08 48 81 c7 88 00 00 00 e8 46 d2 16 e1 48 8b 45 00 f6
[34736.236009] RIP  [<ffffffffa01ec2a8>] 
btrfs_release_extent_buffer_page.constprop.37+0x49/0xc5 [btrfs]
[34736.243075]  RSP <ffff880116fff9e0>
[34736.266399] ---[ end trace 299ec878d8ffefb7 ]---
[34736.266404] BUG: scheduling while atomic: kswapd0/23/0x10000001
[34736.266406] Modules linked in: iwl3945 uvcvideo ip6table_filter 
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
binfmt_misc tun bridge stp snd_hrtimer cpufreq_userspace cpufreq_stats 
parport_pc ppdev cpufreq_conservative lp parport cpufreq_powersave 
uinput sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt 
snd_hda_codec_hdmi snd_hda_codec_idt videobuf2_vmalloc snd_hda_intel 
videobuf2_memops snd_hda_codec videobuf2_core videodev media snd_hwdep 
snd_pcm_oss snd_mixer_oss snd_pcm joydev r592 arc4 snd_page_alloc 
iwlegacy mac80211 snd_seq_midi snd_seq_midi_event snd_rawmidi i915 
drm_kms_helper snd_seq psmouse memstick snd_seq_device snd_timer battery 
cfg80211 dell_wmi acpi_cpufreq dell_laptop r852 sparse_keymap mperf drm 
i2c_algo_bit evdev snd wmi ac iTCO_wdt power_supply iTCO_vendor_support 
dcdbas processor video button coretemp microcode sm_common nand nand_ecc 
nand_ids mtd i2c_i801 serio_raw i2c_core rfkill soundcore kvm_intel kvm 
autofs4 ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate 
dm_mod usbhid hid sd_mod sr_mod cdrom crc_t10dif ata_generic thermal tg3 
firewire_ohci thermal_sys ahci libahci ata_piix sdhci_pci sdhci mmc_core 
uhci_hcd libphy firewire_core crc_itu_t libata ehci_hcd scsi_mod usbcore 
usb_common [last unloaded: iwl3945]
[34736.266542] Pid: 23, comm: kswapd0 Tainted: G      D      3.4.0 #2
[34736.266545] Call Trace:
[34736.266547]  <#SS>  [<ffffffff81353c01>] ? __schedule_bug+0x3e/0x46
[34736.266558]  [<ffffffff813586cf>] ? __schedule+0x85/0x4e1
[34736.266563]  [<ffffffff8103a2d9>] ? console_unlock+0x1b6/0x1e9
[34736.266568]  [<ffffffff8105c46c>] ? __cond_resched+0x1d/0x26
[34736.266571]  [<ffffffff81358b79>] ? _cond_resched+0x11/0x1b
[34736.266575]  [<ffffffff813583d0>] ? down_read+0x9/0x19
[34736.266579]  [<ffffffff81048681>] ? exit_signals+0x1c/0x115
[34736.266583]  [<ffffffff8103cbe0>] ? do_exit+0x10f/0x7a9
[34736.266587]  [<ffffffff81078b95>] ? arch_local_irq_save+0x11/0x17
[34736.266592]  [<ffffffff8135950c>] ? _raw_spin_lock_irqsave+0x9/0x25
[34736.266595]  [<ffffffff8103b09a>] ? kmsg_dump+0x52/0xdc
[34736.266599]  [<ffffffff8135a484>] ? oops_end+0xb2/0xb7
[34736.266604]  [<ffffffff8100ec44>] ? do_stack_segment+0x5e/0x71
[34736.266608]  [<ffffffff813599d5>] ? stack_segment+0x25/0x30
[34736.266638]  [<ffffffffa01ec2a8>] ? 
btrfs_release_extent_buffer_page.constprop.37+0x49/0xc5 [btrfs]
[34736.266641]  <<EOE>>  [<ffffffffa01ec37e>] ? 
release_extent_buffer.isra.28+0x5a/0x76 [btrfs]
[34736.266680]  [<ffffffffa01ee04d>] ? 
try_release_extent_buffer+0x96/0xa1 [btrfs]
[34736.266686]  [<ffffffff810c674e>] ? shrink_page_list+0x55b/0x741
[34736.266691]  [<ffffffff810faba7>] ? lookup_page_cgroup+0x31/0x3a
[34736.266696]  [<ffffffff810cda7e>] ? zone_page_state_add+0x14/0x23
[34736.266700]  [<ffffffff810ce298>] ? __mod_zone_page_state+0x3c/0x45
[34736.266704]  [<ffffffff810c5613>] ? 
update_isolated_counts.isra.44+0x109/0x128
[34736.266708]  [<ffffffff810c6d24>] ? shrink_inactive_list+0x237/0x439
[34736.266712]  [<ffffffff810c7589>] ? shrink_mem_cgroup_zone+0x371/0x480
[34736.266717]  [<ffffffff810c76fa>] ? shrink_zone+0x62/0x9b
[34736.266721]  [<ffffffff810c8402>] ? balance_pgdat+0x2cb/0x586
[34736.266725]  [<ffffffff810c8989>] ? kswapd+0x2cc/0x2e8
[34736.266730]  [<ffffffff810524fb>] ? add_wait_queue+0x3c/0x3c
[34736.266734]  [<ffffffff810c86bd>] ? balance_pgdat+0x586/0x586
[34736.266737]  [<ffffffff81051e9e>] ? kthread+0x7d/0x85
[34736.266742]  [<ffffffff8135f924>] ? kernel_thread_helper+0x4/0x10
[34736.266746]  [<ffffffff81051e21>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[34736.266750]  [<ffffffff8135f920>] ? gs_change+0x13/0x13

