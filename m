Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58141 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbHCDvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 23:51:33 -0400
Date: Sun, 2 Aug 2015 20:51:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150803035130.GL24824@merlins.org>
References: <20150706212156.GY17274@merlins.org> <20150710134348.GB15535@suse.cz> <20150712010229.GA5284@merlins.org> <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150724162446.GH30815@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 09:24:46AM -0700, Marc MERLIN wrote:
> > > > Screenshot: http://marc.merlins.org/tmp/btrfs_crash.jpg
> > 
> > So it's 32bit system, 3.19.8, crashing during snapshot deletion and
> > backref walking. EIP is in do_walk_down+0x142. I've tried to match it to
> > the sources on a local 32bit build, but it does not point to the
> > expected crash site:
> 
> Thanks for looking.
> Unfortunately it's a mythtv where if I put a 64bit kernel, other things
> go wrong with the 32bit userland/64bit kernel split.
> But I'll put a newer 64bit kernel on it to see what happens and report
> back.

I got home, built the last kernel and got netconsole working.
4.1.3/64bit and 32bit crash the same way. 

Here's the 64bit crash:
[  209.647162] BTRFS: device label bigbackup devid 1 transid 39536 /dev/mapper/crypt_sdd1
[  209.647449] BTRFS: device label bigbackup devid 5 transid 39536 /dev/mapper/crypt_sdh1
[  209.648069] BTRFS: device label bigbackup devid 4 transid 39536 /dev/mapper/crypt_sdg1
[  209.648469] BTRFS: device label bigbackup devid 2 transid 39536 /dev/mapper/crypt_sde1
[  209.648871] BTRFS: device label bigbackup devid 3 transid 39536 /dev/mapper/crypt_sdf1
[  209.675030] BTRFS info (device dm-0): disk space caching is enabled  
[  249.865515] ------------[ cut here ]------------  
[  249.865530] WARNING: CPU: 1 PID: 3556 at fs/btrfs/extent-tree.c:863 btrfs_lookup_extent_info+0x292/0x2e0()
[  249.865534] Modules linked in: xts gf128mul configs rc_hauppauge ir_kbd_i2c cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats autofs4 joydev hid_generic usbhid tuner_simple tuner_types tda9887 tda8290 hid tuner msp3400 firewire_sbp2 snd_hda_codec_hdmi rc_imon_mce saa7127 snd_hda_codec_realtek snd_hda_codec_generic hwmon_vid dm_crypt snd_hda_intel dm_mod snd_hda_controller imon saa7115 snd_hda_codec snd_hda_core coretemp snd_pcm_oss snd_mixer_oss ivtv bttv cx2341x tea575x v4l2_common snd_pcm videodev snd_hwdep snd_seq_midi videobuf_dma_sg videobuf_core rc_core snd_rawmidi snd_seq_midi_event snd_seq gpio_ich kvm_intel ehci_pci sr_mod media firewire_ohci cdrom floppy snd_timer ehci_hcd uhci_hcd psmouse snd_seq_device tveeprom acpi_cpufreq lpc_ich usbcore sg lp firewire_core asus_atk0110 evdev usb_common kvm atl1 serio_raw mii crc_itu_t parport snd soundcore processor microcode 8250_fintek
[  249.865672] CPU: 1 PID: 3556 Comm: btrfs-cleaner Not tainted 4.1.3-amd64-i915-volpreempt-20150421 #1
[  249.865674] Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604    07/16/2008
[  249.865676]  0000000000000009 ffff880041e03b68 ffffffff8169d72d 0000000000004fb9
[  249.865683]  0000000000000000 ffff880041e03ba8 ffffffff8105861f ffffffff00000094
[  249.865691]  ffffffff81239ac5 ffff8800772920b0 0000000000000000 0000000000000000
[  249.865700] Call Trace:
[  249.865706]  [<ffffffff8169d72d>] dump_stack+0x45/0x57
[  249.865711]  [<ffffffff8105861f>] warn_slowpath_common+0xa1/0xbb
[  249.865714]  [<ffffffff81239ac5>] ? btrfs_lookup_extent_info+0x292/0x2e0
[  249.865717]  [<ffffffff810586dc>] warn_slowpath_null+0x1a/0x1c
[  249.865720]  [<ffffffff81239ac5>] btrfs_lookup_extent_info+0x292/0x2e0
[  249.865724]  [<ffffffff816a3752>] ? _raw_write_lock+0xe/0x10
[  249.865727]  [<ffffffff8123c4af>] do_walk_down+0x14d/0x735
[  249.865731]  [<ffffffff8123cb1e>] walk_down_tree+0x87/0xb0
[  249.865734]  [<ffffffff8123f617>] btrfs_drop_snapshot+0x2e7/0x696
[  249.865739]  [<ffffffff8124ee09>] btrfs_clean_one_deleted_snapshot+0xce/0xdb
[  249.865742]  [<ffffffff81248452>] cleaner_kthread+0x112/0x146
[  249.865745]  [<ffffffff81248340>] ? atomic_add_unless.constprop.56+0x24/0x24
[  249.865748]  [<ffffffff81248340>] ? atomic_add_unless.constprop.56+0x24/0x24
[  249.865751]  [<ffffffff810706f6>] kthread+0xae/0xb6
[  249.865755]  [<ffffffff81070648>] ? __kthread_parkme+0x61/0x61
[  249.865758]  [<ffffffff816a3e62>] ret_from_fork+0x42/0x70
[  249.865761]  [<ffffffff81070648>] ? __kthread_parkme+0x61/0x61
[  249.865764] ---[ end trace 826326bc6da53e4f ]---
[  249.865767] BTRFS error (device dm-0): Missing references.
[  249.865781] ------------[ cut here ]------------
[  249.867106] kernel BUG at fs/btrfs/extent-tree.c:8113!
[  249.868435] invalid opcode: 0000 [#1] SMP
[  249.869508] Modules linked in: xts gf128mul configs rc_hauppauge ir_kbd_i2c cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats autofs4 joydev hid_generic usbhid tuner_simple tuner_types tda9887 tda8290 hid tuner msp3400 firewire_sbp2 snd_hda_codec_hdmi rc_imon_mce saa7127 snd_hda_codec_realtek snd_hda_codec_generic hwmon_vid dm_crypt snd_hda_intel dm_mod snd_hda_controller imon saa7115 snd_hda_codec snd_hda_core coretemp snd_pcm_oss snd_mixer_oss ivtv bttv cx2341x tea575x v4l2_common snd_pcm videodev snd_hwdep snd_seq_midi videobuf_dma_sg videobuf_core rc_core snd_rawmidi snd_seq_midi_event snd_seq gpio_ich kvm_intel ehci_pci sr_mod media firewire_ohci cdrom floppy snd_timer ehci_hcd uhci_hcd psmouse snd_seq_device tveeprom acpi_cpufreq lpc_ich usbcore sg lp firewire_core asus_atk0110 evdev usb_common kvm atl1 serio_raw mii crc_itu_t parport snd soundcore processor microcode 8250_fintek
[  249.869508] CPU: 1 PID: 3556 Comm: btrfs-cleaner Tainted: G        W       4.1.3-amd64-i915-volpreempt-20150421 #1
[  249.869508] Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604    07/16/2008
[  249.869508] task: ffff880041dfc110 ti: ffff880041e00000 task.ti: ffff880041e00000
[  249.869508] RIP: 0010:[<ffffffff8123c4e9>]  [<ffffffff8123c4e9>] do_walk_down+0x187/0x735
[  249.869508] RSP: 0018:ffff880041e03c68  EFLAGS: 00010296
[  249.869508] RAX: 000000000000002e RBX: ffff880046655010 RCX: 0000000000000007
[  249.869508] RDX: 0000000000005063 RSI: 0000000000000246 RDI: ffff88007f48e5d0
[  249.869508] RBP: ffff880041e03d38 R08: 000000000000004f R09: 0000000000000001
[  249.869508] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800778a1800
[  249.869508] R13: ffff8800477f4100 R14: ffff880077292140 R15: ffff880077292150
[  249.869508] FS:  0000000000000000(0000) GS:ffff88007f480000(0000) knlGS:0000000000000000
[  249.869508] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  249.869508] CR2: 00000000084764f8 CR3: 0000000071dda000 CR4: 00000000000006e0
[  249.869508] Stack:
[  249.869508]  ffff8800477f4148 0000000000000000 ffff880000000000 0000000000200282
[  249.869508]  ffff88007b5b1880 ffff8800477f4108 0000000000000008 ffff880077292148
[  249.869508]  ffff880000000001 0000000000000001 ffff880041e03d64 0000008636598000
[  249.869508] Call Trace:
[  249.869508]  [<ffffffff8123cb1e>] walk_down_tree+0x87/0xb0
[  249.869508]  [<ffffffff8123f617>] btrfs_drop_snapshot+0x2e7/0x696
[  249.869508]  [<ffffffff8124ee09>] btrfs_clean_one_deleted_snapshot+0xce/0xdb
[  249.869508]  [<ffffffff81248452>] cleaner_kthread+0x112/0x146
[  249.869508]  [<ffffffff81248340>] ? atomic_add_unless.constprop.56+0x24/0x24
[  249.869508]  [<ffffffff81248340>] ? atomic_add_unless.constprop.56+0x24/0x24
[  249.869508]  [<ffffffff810706f6>] kthread+0xae/0xb6
[  249.869508]  [<ffffffff81070648>] ? __kthread_parkme+0x61/0x61
[  249.869508]  [<ffffffff816a3e62>] ret_from_fork+0x42/0x70
[  249.869508]  [<ffffffff81070648>] ? __kthread_parkme+0x61/0x61
[  249.869508] Code: 45 ac e8 39 19 04 00 8b 45 ac e9 b8 05 00 00 49 83 3a 00 75 18 49 8b bc 24 f0 01 00 00 48 c7 c6 99 5e ad 81 31 c0 e8 92 e3 fe ff <0f> 0b 48 8b 45 80 c7 00 00 00 00 00 41 83 bd 94 00 00 00 01 0f
[  249.869508] RIP  [<ffffffff8123c4e9>] do_walk_down+0x187/0x735
[  249.869508]  RSP <ffff880041e03c68>
[  249.936818] ---[ end trace 826326bc6da53e50 ]---
[  249.936823] Kernel panic - not syncing: Fatal exception
[  249.938550] Kernel Offset: disabled

And here is 4.1.3/32bit:
[ 1346.737490] ------------[ cut here ]------------
[ 1346.739026] WARNING: CPU: 1 PID: 12919 at fs/btrfs/extent-tree.c:863 btrfs_lookup_extent_info+0x2b8/0x2f7()
[ 1346.740592] Modules linked in: xts gf128mul rc_hauppauge ir_kbd_i2c cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats autofs4 tuner_simple tuner_types tda9887 tda8290 tuner msp3400 snd_hda_codec_hdmi saa7127 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller firewire_sbp2 saa7115 snd_hda_codec ivtv snd_hda_core snd_hwdep hwmon_vid snd_pcm_oss snd_mixer_oss snd_pcm dm_crypt snd_seq_midi snd_seq_midi_event dm_mod snd_rawmidi snd_seq bttv tea575x videobuf_dma_sg coretemp videobuf_core snd_seq_device snd_timer tveeprom cx2341x v4l2_common videodev kvm_intel gpio_ich snd soundcore ehci_pci ehci_hcd lpc_ich media kvm psmouse rc_imon_mce acpi_cpufreq imon rc_core joydev sr_mod asus_atk0110 lp cdrom microcode processor hid_generic serio_raw evdev parport sg usbhid hid raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx multipath firewire_ohci firewire_core crc_itu_t atl1 uhci_hcd mii floppy usbcore usb_common
[ 1346.750673] CPU: 1 PID: 12919 Comm: btrfs-cleaner Not tainted 4.1.3-ia32-i915-volpreempt-20150421 #2
[ 1346.752780] Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604    07/16/2008
[ 1346.754912]  00000000 00000000 d6413db0 c1544620 00000000 d6413dc8 c10388a5 c11abf7d
[ 1346.757115]  00000000 d87f65d8 00000000 d6413dd8 c1038920 00000009 00000000 d6413e24
[ 1346.759320]  c11abf7d 00000000 00000086 36598000 d87f7dec d87f7d38 00000000 d87f6648
[ 1346.761543] Call Trace:
[ 1346.763709]  [<c1544620>] dump_stack+0x49/0x73
[ 1346.765895]  [<c10388a5>] warn_slowpath_common+0x7e/0x95
[ 1346.768076]  [<c11abf7d>] ? btrfs_lookup_extent_info+0x2b8/0x2f7
[ 1346.770280]  [<c1038920>] warn_slowpath_null+0xf/0x13
[ 1346.772481]  [<c11abf7d>] btrfs_lookup_extent_info+0x2b8/0x2f7
[ 1346.774682]  [<c11aea5b>] do_walk_down+0x10c/0x65f
[ 1346.776890]  [<c11a7a2b>] ? btrfs_tree_unlock_rw+0x10/0x2e
[ 1346.779088]  [<c11ac90d>] ? walk_down_proc+0x110/0x1cb
[ 1346.781265]  [<c11af020>] walk_down_tree+0x72/0x93
[ 1346.783434]  [<c11b190a>] btrfs_drop_snapshot+0x278/0x591
[ 1346.785610]  [<c11bfbf2>] btrfs_clean_one_deleted_snapshot+0x79/0x87
[ 1346.787801]  [<c11b9985>] cleaner_kthread+0x74/0xdd
[ 1346.790007]  [<c11b9911>] ? btrfs_need_cleaner_sleep.isra.20+0x2a/0x2a
[ 1346.792248]  [<c104bccd>] kthread+0x88/0x8d
[ 1346.794503]  [<c105013e>] ? mmdrop+0xe/0x1c
[ 1346.796745]  [<c1050000>] ? check_same_owner+0x2c/0x43
[ 1346.798981]  [<c15498c1>] ret_from_kernel_thread+0x21/0x30
[ 1346.801236]  [<c104bc45>] ? __kthread_parkme+0x50/0x50
[ 1346.803480] ---[ end trace 482e6619a3037689 ]---
[ 1346.805757] BTRFS error (device dm-0): Missing references.
[ 1346.808066] ------------[ cut here ]------------
[ 1346.810375] kernel BUG at fs/btrfs/extent-tree.c:8113!
[ 1346.812053] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 1346.812053] Modules linked in: xts gf128mul rc_hauppauge ir_kbd_i2c cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats autofs4 tuner_simple tuner_types tda9887 tda8290 tuner msp3400 snd_hda_codec_hdmi saa7127 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller firewire_sbp2 saa7115 snd_hda_codec ivtv snd_hda_core snd_hwdep hwmon_vid snd_pcm_oss snd_mixer_oss snd_pcm dm_crypt snd_seq_midi snd_seq_midi_event dm_mod snd_rawmidi snd_seq bttv tea575x videobuf_dma_sg coretemp videobuf_core snd_seq_device snd_timer tveeprom cx2341x v4l2_common videodev kvm_intel gpio_ich snd soundcore ehci_pci ehci_hcd lpc_ich media kvm psmouse rc_imon_mce acpi_cpufreq imon rc_core joydev sr_mod asus_atk0110 lp cdrom microcode processor hid_generic serio_raw evdev parport sg usbhid hid raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx multipath firewire_ohci firewire_core crc_itu_t atl1 uhci_hcd mii floppy usbcore usb_common
[ 1346.812053] CPU: 1 PID: 12919 Comm: btrfs-cleaner Tainted: G        W       4.1.3-ia32-i915-volpreempt-20150421 #2
[ 1346.812053] Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604    07/16/2008
[ 1346.812053] task: d70faea0 ti: d6412000 task.ti: d6412000
[ 1346.812053] EIP: 0060:[<c11aea91>] EFLAGS: 00010282 CPU: 1
[ 1346.812053] EIP is at do_walk_down+0x142/0x65f
[ 1346.812053] EAX: 0000002e EBX: f4a2a4c0 ECX: f598b310 EDX: 80000000
[ 1346.812053] ESI: d87f66c0 EDI: c21a0c00 EBP: d6413ebc ESP: d6413e40
[ 1346.812053]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1346.812053] CR0: 8005003b CR2: 09947000 CR3: 34d01000 CR4: 000006d0
[ 1346.812053] Stack:
[ 1346.812053]  f4c50000 c174d1ac f4a435c0 00000001 00000000 00004000 d87f66b8 00000001
[ 1346.812053]  00000286 f4a2a4c8 00000000 36598000 00000086 d87f6648 00000002 00008f48
[ 1346.812053]  00000000 00000001 d87f3bc8 00000000 db2f1438 d6413e9c c11a7a2b d6413ebc
[ 1346.812053] Call Trace:
[ 1346.812053]  [<c11a7a2b>] ? btrfs_tree_unlock_rw+0x10/0x2e
[ 1346.812053]  [<c11ac90d>] ? walk_down_proc+0x110/0x1cb
[ 1346.812053]  [<c11af020>] walk_down_tree+0x72/0x93
[ 1346.812053]  [<c11b190a>] btrfs_drop_snapshot+0x278/0x591
[ 1346.812053]  [<c11bfbf2>] btrfs_clean_one_deleted_snapshot+0x79/0x87
[ 1346.812053]  [<c11b9985>] cleaner_kthread+0x74/0xdd
[ 1346.812053]  [<c11b9911>] ? btrfs_need_cleaner_sleep.isra.20+0x2a/0x2a
[ 1346.812053]  [<c104bccd>] kthread+0x88/0x8d
[ 1346.812053]  [<c105013e>] ? mmdrop+0xe/0x1c
[ 1346.812053]  [<c1050000>] ? check_same_owner+0x2c/0x43
[ 1346.812053]  [<c15498c1>] ret_from_kernel_thread+0x21/0x30
[ 1346.812053]  [<c104bc45>] ? __kthread_parkme+0x50/0x50
[ 1346.812053] Code: 45 cc e8 10 ff 03 00 8b 55 c8 89 d0 e9 2f 05 00 00 8b 4d a8 8b 41 04 0b 01 75 12 68 ac d1 74 c1 ff b7 dc 01 00 00 e8 02 f3 fe ff <0f> 0b 8b 45 0c c7 00 00 00 00 00 83 bb 94 00 00 00 01 0f 85 a5
[ 1346.812053] EIP: [<c11aea91>] do_walk_down+0x142/0x65f SS:ESP 0068:d6413e40
[ 1346.913822] ---[ end trace 482e6619a303768a ]---
[ 1346.916847] Kernel panic - not syncing: Fatal exception
[ 1346.919763] Kernel Offset: disabled
[ 1346.920844] drm_kms_helper: panic occurred, switching back to text console
[ 1346.920844] Rebooting in 20 seconds..


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
