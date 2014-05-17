Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:35165 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaEQX7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 19:59:07 -0400
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140517220641.EGNK30009.eastrmfepo101.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 17 May 2014 18:06:41 -0400
Date: Sat, 17 May 2014 18:06:40 -0400
From: Chris Lawrence <lordsutch@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: BUG leading to fs hang in 3.14.4 during btrfs send
Message-ID: <20140517220640.GA18075@lordsutch.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During a full send/receive of a snapshot of the subvolume
/newhome/homefs, I get the following BUG and the filesystem hangs.

It seems to be reproducible every time I attempt to do so. This
doesn't appear to be the same problem reported a few days ago for
incremental backups that is reportedly fixed in 3.15-rc1

Here's the oops trace:

May 16 02:31:51 campbell kernel: [616435.305347] BUG: Bad page state in process btrfs  pfn:8d3c7
May 16 02:31:51 campbell kernel: [616435.305355] page:ffffea000234f1c0 count:0 mapcount:0 mapping:ffff8800ab4646f0 index:0x1ec233b
May 16 02:31:51 campbell kernel: [616435.305358] page flags: 0x400000000000000c(referenced|uptodate)
May 16 02:31:51 campbell kernel: [616435.305364] page dumped because: non-NULL mapping
May 16 02:31:51 campbell kernel: [616435.305366] Modules linked in: cpuid hfsplus hfs ntfs vfat msdos fat jfs xfs zram cpufreq_powersave nfnetlink_queue nfnetlink_log nfnetlink cpufreq_conservative cpufreq_ondemand bluetooth 6lowpan_iphc rfkill cpufreq_userspace binfmt_misc af_packet snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device joydev usbhid usb_storage uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core s5h1409 cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder ir_rc6_decoder ir_sony_decoder ir_jvc_decoder ir_rc5_decoder ir_nec_decoder rc_pinnacle_pctv_hd xc5000 tuner cx88_alsa cx8802 cx8800 cx88xx tveeprom snd_hda_codec_realtek btcx_risc videobuf_dma_sg snd_hda_codec_generic videobuf_core serio_raw rc_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_intel snd_hda_codec radeon snd_hwdep snd_pcm_oss i2c_piix4 snd_mixer_oss snd_pcm snd_timer snd i2c_algo_bit drm_kms_helper ttm drm rtc_cmos backlight wmi acpi_cpufreq k10temp it87 hwmon_vid evdev firewire_sbp2 fuse parport_pc ppdev lp parport ipv6 autofs4 dm_mod ohci_pci microcode firewire_ohci firewire_core crc_itu_t ehci_pci ohci_hcd ehci_hcd xhci_hcd sr_mod cdrom r8169 mii usbcore usb_common
May 16 02:31:51 campbell kernel: [616435.305543] CPU: 0 PID: 26339 Comm: btrfs Not tainted 3.14.3 #25
May 16 02:31:51 campbell kernel: [616435.305546] Hardware name: Gigabyte Technology Co., Ltd. GA-MA785GM-US2H/GA-MA785GM-US2H, BIOS F12a 07/08/2010
May 16 02:31:51 campbell kernel: [616435.305549]  0000000000000000 ffff88004718d818 ffffffffa24f64bd ffffea000234f1c0
May 16 02:31:51 campbell kernel: [616435.305556]  ffff88004718d840 ffffffffa21003a1 ffffea000234f1c0 0000000000000001
May 16 02:31:51 campbell kernel: [616435.305560]  0000000000000000 ffff88004718d878 ffffffffa210046d 400000000000000c
May 16 02:31:51 campbell kernel: [616435.305565] Call Trace:
May 16 02:31:51 campbell kernel: [616435.305575]  [<ffffffffa24f64bd>] dump_stack+0x4f/0x7b
May 16 02:31:51 campbell kernel: [616435.305581]  [<ffffffffa21003a1>] bad_page+0xe0/0xfd
May 16 02:31:51 campbell kernel: [616435.305584]  [<ffffffffa210046d>] free_pages_prepare+0xaf/0x121
May 16 02:31:51 campbell kernel: [616435.305588]  [<ffffffffa2101958>] free_hot_cold_page+0x23/0x11b
May 16 02:31:51 campbell kernel: [616435.305602]  [<ffffffffa210545f>] __put_single_page+0x23/0x26
May 16 02:31:51 campbell kernel: [616435.305605]  [<ffffffffa2105945>] put_page+0x26/0x28
May 16 02:31:51 campbell kernel: [616435.305611]  [<ffffffffa225ea0a>] btrfs_release_extent_buffer_page.constprop.39+0xe4/0xf6
May 16 02:31:51 campbell kernel: [616435.305614]  [<ffffffffa225ea6d>] release_extent_buffer+0x51/0xa1
May 16 02:31:51 campbell kernel: [616435.305618]  [<ffffffffa22633ae>] free_extent_buffer+0x72/0x7d
May 16 02:31:51 campbell kernel: [616435.305623]  [<ffffffffa2226f75>] btrfs_release_path+0x6f/0x8d
May 16 02:31:51 campbell kernel: [616435.305628]  [<ffffffffa2294931>] find_parent_nodes+0x1d4/0x5a9
May 16 02:31:51 campbell kernel: [616435.305646]  [<ffffffffa208637a>] ? get_parent_ip+0xd/0x3c
May 16 02:31:51 campbell kernel: [616435.305663]  [<ffffffffa2294da4>] btrfs_find_all_roots+0x82/0xe0
May 16 02:31:51 campbell kernel: [616435.305673]  [<ffffffffa22956a3>] iterate_extent_inodes+0x14e/0x2b5
May 16 02:31:51 campbell kernel: [616435.305679]  [<ffffffffa2299b7e>] ? btrfs_root_dec_send_in_progress+0x5a/0x5a
May 16 02:31:51 campbell kernel: [616435.305684]  [<ffffffffa229db06>] process_extent+0x674/0xfe3
May 16 02:31:51 campbell kernel: [616435.305689]  [<ffffffffa229ea12>] changed_cb+0x59d/0x8eb
May 16 02:31:51 campbell kernel: [616435.305693]  [<ffffffffa229f649>] btrfs_ioctl_send+0x8e9/0xcba
May 16 02:31:51 campbell kernel: [616435.305698]  [<ffffffffa200b14e>] ? arch_dup_task_struct+0x49/0xce
May 16 02:31:51 campbell kernel: [616435.305703]  [<ffffffffa22733b3>] btrfs_ioctl+0x195/0x2633
May 16 02:31:51 campbell kernel: [616435.305718]  [<ffffffffa208be6d>] ? __enqueue_entity+0x6c/0x6e
May 16 02:31:51 campbell kernel: [616435.305729]  [<ffffffffa208efe3>] ? enqueue_entity+0x60b/0x7f0
May 16 02:31:51 campbell kernel: [616435.305732]  [<ffffffffa208f2a2>] ? enqueue_task_fair+0xda/0x423
May 16 02:31:51 campbell kernel: [616435.305737]  [<ffffffffa202d6d3>] ? flat_send_IPI_mask+0x7c/0x8e
May 16 02:31:51 campbell kernel: [616435.305746]  [<ffffffffa208637a>] ? get_parent_ip+0xd/0x3c
May 16 02:31:51 campbell kernel: [616435.305758]  [<ffffffffa208641c>] ? preempt_count_sub+0x36/0x43
May 16 02:31:51 campbell kernel: [616435.305762]  [<ffffffffa24fb558>] ? _raw_spin_unlock_irqrestore+0x2f/0x43
May 16 02:31:51 campbell kernel: [616435.305771]  [<ffffffffa20881a1>] ? wake_up_new_task+0x120/0x161
May 16 02:31:51 campbell kernel: [616435.305779]  [<ffffffffa214cfa4>] do_vfs_ioctl+0x356/0x41a
May 16 02:31:51 campbell kernel: [616435.305783]  [<ffffffffa2155050>] ? __fget+0x6f/0x79
May 16 02:31:51 campbell kernel: [616435.305786]  [<ffffffffa214d0b8>] SyS_ioctl+0x50/0x7b
May 16 02:31:51 campbell kernel: [616435.305791]  [<ffffffffa24fc616>] system_call_fastpath+0x1a/0x1f

campbell ~$ btrfs filesystem df /newhome
Data, single: total=132.01GiB, used=125.57GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=2.01GiB, used=938.20MiB
campbell ~$ sudo btrfs subvolume list /newhome
ID 376 gen 12789 top level 5 path homefs
ID 379 gen 195 top level 376 path homefs/snapshot/20140508-234337
ID 380 gen 972 top level 376 path homefs/snapshot/20140509-073709
ID 381 gen 3015 top level 376 path homefs/snapshot/20140510-073523
ID 383 gen 4289 top level 376 path homefs/snapshot/20140511-073521
ID 385 gen 5550 top level 376 path homefs/snapshot/20140512-075813
ID 388 gen 6954 top level 376 path homefs/snapshot/20140513-074012
ID 394 gen 8877 top level 376 path homefs/snapshot/20140514-080313
ID 395 gen 10551 top level 376 path homefs/snapshot/20140515-074545
ID 402 gen 11452 top level 376 path homefs/snapshot/20140516-004230
ID 403 gen 12395 top level 376 path homefs/snapshot/20140517-005509

Example send/receive command line:

# btrfs send /newhome/homefs/snapshot/20140517-005509 | btrfs receive /backup/newhome


Chris
-- 
Chris Lawrence <chris@lordsutch.com> - http://blog.lordsutch.com/
