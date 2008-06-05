From: Bron Gondwana <brong@fastmail.fm>
Subject: Bug Report - crash copying in large file
Date: Thu, 5 Jun 2008 14:15:16 +1000
Message-ID: <20080605041516.GA11964@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, random crash dump if you're interested:

Latest stable btrfs (557:4b7e2b315a32)
Latest stable progs (234:e6d157c83cfe)
Latest Ubuntu Hardy kernel (2.6.24-28-generic).
Ubuntu Hardy toolchain (gcc: 4.2.3-2ubuntu7)

Filesystem was freshly rebuilt about an hour ago.  I rsynced 
over my Maildir and associated offlineimap and mutt
configurations, had offlineimap syncing mail, mutt reading it
and an ~700Mb file being copied in from an NFS mount.

Space - there was about 1.5Gb free when I started the copy.
Still, I'm guessing from the dump it may be a disk space issue.

dmesg says:

[ 1480.288734] ------------[ cut here ]------------
[ 1480.288738] kernel BUG at /extra/src/work/kernel/extent-tree.c:1895!
[ 1480.288741] invalid opcode: 0000 [#1] SMP
[ 1480.288744] Modules linked in: nfs lockd nfs_acl sunrpc btrfs ieee80211_crypt_ccmp af_packet snd_rtctimer binfmt_misc rfcomm l2cap ppdev ipv6 tun snd_atiixp_modem snd_via82xx_modem snd_intel8x0m speedstep_centrino cpufreq_userspace cpufreq_stats cpufreq_ondemand freq_table cpufreq_powersave cpufreq_conservative dock sbs sbshc container microcode iptable_filter ip_tables x_tables libcrc32c reiserfs aes_i586 dm_crypt dm_mod sbp2 lp pcmcia joydev snd_intel8x0 snd_ac97_codec ac97_bus hci_usb snd_pcm_oss ipw2200 bluetooth snd_pcm ieee80211 ieee80211_crypt snd_mixer_oss yenta_socket rsrc_nonstatic pcmcia_core snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi video output snd_seq_midi_event snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support serio_raw button battery snd ac intel_agp
  irda soundcore parport_pc parport shpchp pci_hotplug agpgart crc_ccitt dcdbas snd_page_alloc evdev psmouse pcspkr ext3 jbd mbcache sg sr_mod cdrom sd_mod pata_acpi ata_piix ata_generic ohci1394 e100 mii libata ehci_hcd ieee1394 uhci_hcd scsi_mod usbcore thermal processor fan fbcon tileblit font bitblit softcursor fuse
[ 1480.288819]
[ 1480.288823] Pid: 9196, comm: pdflush Not tainted (2.6.24-18-generic #1)
[ 1480.288826] EIP: 0060:[<f91d3144>] EFLAGS: 00010292 CPU: 0
[ 1480.288853] EIP is at btrfs_alloc_extent+0x554/0x730 [btrfs]
[ 1480.288855] EAX: 0000002c EBX: 00000000 ECX: 00000092 EDX: 00000000
[ 1480.288858] ESI: 00000000 EDI: 00000001 EBP: 00000000 ESP: ecac7bac
[ 1480.288861]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1480.288865] Process pdflush (pid: 9196, ti=ecac6000 task=ea635700 task.ti=ecac6000)
[ 1480.288867] Stack: f91fe550 00000001 00000000 00000000 00000000 00000000 b2f1d000 00000000
[ 1480.288874]        38791000 00000000 ecac7ccb 00000000 00000000 00000000 00000000 00000001
[ 1480.288880]        ffffffff 00000000 ea5d2800 dc8b6000 ea71c000 ea67b200 f91d7e16 00000254
[ 1480.288886] Call Trace:
[ 1480.288928]  [<f91d7e16>] btrfs_insert_file_extent+0x126/0x140 [btrfs]
[ 1480.288979]  [<f91dfe5c>] cow_file_range+0x25c/0x430 [btrfs]
[ 1480.289068]  [<f91e0adc>] run_delalloc_range+0x2ec/0x320 [btrfs]
[ 1480.289131]  [<f91e07f0>] run_delalloc_range+0x0/0x320 [btrfs]
[ 1480.289167]  [<f91f4945>] __extent_writepage+0x3d5/0x8d0 [btrfs]
[ 1480.289211]  [<c0174f92>] test_clear_page_writeback+0x72/0x100
[ 1480.289259]  [<c016d701>] find_get_pages_tag+0x31/0x90
[ 1480.289284]  [<c01741cf>] write_cache_pages+0x21f/0x310
[ 1480.289292]  [<f91f4570>] __extent_writepage+0x0/0x8d0 [btrfs]
[ 1480.289327]  [<c01740ac>] write_cache_pages+0xfc/0x310
[ 1480.289365]  [<f91f25ed>] extent_writepages+0x2d/0x50 [btrfs]
[ 1480.289401]  [<f91e4090>] btrfs_get_extent+0x0/0x1010 [btrfs]
[ 1480.289435]  [<f91e15ba>] btrfs_writepages+0x1a/0x20 [btrfs]
[ 1480.289469]  [<c017431b>] do_writepages+0x2b/0x50
[ 1480.289477]  [<c01aebb9>] __writeback_single_inode+0x89/0x320
[ 1480.289507]  [<c01af1ef>] sync_sb_inodes+0x19f/0x270
[ 1480.289524]  [<c01af4d9>] writeback_inodes+0x89/0xc0
[ 1480.289535]  [<c0174d25>] wb_kupdate+0x85/0xf0
[ 1480.289557]  [<c01751d0>] pdflush+0x0/0x200
[ 1480.289561]  [<c01752f5>] pdflush+0x125/0x200
[ 1480.289569]  [<c0174ca0>] wb_kupdate+0x0/0xf0
[ 1480.289582]  [<c0140982>] kthread+0x42/0x70
[ 1480.289586]  [<c0140940>] kthread+0x0/0x70
[ 1480.289595]  [<c0105677>] kernel_thread_helper+0x7/0x10
[ 1480.289609]  =======================
[ 1480.289611] Code: 00 00 5b 5e 5f 5d c3 8b 94 24 a4 00 00 00 39 94 24 9c 00 00 00 73 18 89 7c 24 04 89 6c 24 08 c7 04 24 50 e5 1f f9 e8 5c a0 f5 c6 <0f> 0b eb fe 77 10 8b 8c 24 a0 00 00 00 39 8c 24 98 00 00 00 76
[ 1480.289640] EIP: [<f91d3144>] btrfs_alloc_extent+0x554/0x730 [btrfs] SS:ESP 0068:ecac7bac
[ 1480.289765] ---[ end trace c84978244e1205eb ]---
