Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57524 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaLHWCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 17:02:45 -0500
Received: by mail-vc0-f179.google.com with SMTP id le20so2629691vcb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 14:02:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141130072942.GA475@gst.name>
References: <20141130072942.GA475@gst.name>
Date: Mon, 8 Dec 2014 17:02:43 -0500
Message-ID: <CAAVQaYAxa6LEz8516+NW8nWo28c41V+ekNUNqXpxHZpoXe4OOA@mail.gmail.com>
Subject: Re: Running out of disk space during BTRFS_IOC_CLONE - rebalance
 doesn't help
From: Dave <dave@thekilempire.com>
To: Guenther Starnberger <linux-btrfs@gst.priv.at>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 2:29 AM, Guenther Starnberger
<linux-btrfs@gst.priv.at> wrote:
> Here's the log output:
>
> dmesg:
>
> [235491.227888] ------------[ cut here ]------------
> [235491.227912] WARNING: CPU: 0 PID: 14837 at fs/btrfs/super.c:259 __btrfs_abort_transaction+0x50/0x110 [btrfs]()
> [235491.227914] BTRFS: Transaction aborted (error -28)
> [235491.227916] Modules linked in: fuse btrfs xor raid6_pq uas usb_storage ctr ccm toshiba_acpi sparse_keymap toshiba_haps joydev hp_accel lis3lv02d input_polldev hdaps(O) btusb bluetooth uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev qcserial media usb_wwan usbserial arc4 iwldvm snd_hda_codec_hdmi mousedev snd_hda_codec_conexant snd_hda_codec_generic mac80211 iTCO_wdt iTCO_vendor_support coretemp intel_powerclamp snd_hda_intel snd_hda_controller snd_hda_codec kvm_intel snd_hwdep iwlwifi thinkpad_acpi mei_me mei cfg80211 snd_pcm nvram lpc_ich kvm evdev snd_timer i915 snd mac_hid ac serio_raw e1000e psmouse led_class wmi rfkill shpchp drm_kms_helper intel_ips i2c_i801 soundcore drm battery hwmon ptp thermal pps_core i2c_algo_bit i2c_core video intel_agp intel_gtt button
> [235491.227968]  acpi_cpufreq processor sch_fq_codel tp_smapi(O) thinkpad_ec(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_crypt dm_mod atkbd libps2 crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci ehci_hcd usbcore usb_common i8042 serio ata_piix sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common ahci libahci ata_generic libata scsi_mod
> [235491.228001] CPU: 0 PID: 14837 Comm: bedup Tainted: G        W  O   3.17.4-1-ARCH #1
> [235491.228003] Hardware name: LENOVO 3680U4M/3680U4M, BIOS 6QET68WW (1.38 ) 12/01/2011
> [235491.228004]  0000000000000000 000000005deed0d1 ffff880144a57a90 ffffffff81537b0e
> [235491.228006]  ffff880144a57ad8 ffff880144a57ac8 ffffffff8107078d 00000000ffffffe4
> [235491.228008]  ffff8801719dcaa0 ffff88009e273800 ffffffffa09f7630 0000000000000c46
> [235491.228010] Call Trace:
> [235491.228017]  [<ffffffff81537b0e>] dump_stack+0x4d/0x6f
> [235491.228021]  [<ffffffff8107078d>] warn_slowpath_common+0x7d/0xa0
> [235491.228024]  [<ffffffff8107080c>] warn_slowpath_fmt+0x5c/0x80
> [235491.228029]  [<ffffffffa0949d10>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
> [235491.228040]  [<ffffffffa09aa9ba>] clone_finish_inode_update+0xda/0xf0 [btrfs]
> [235491.228046]  [<ffffffffa09ad0de>] btrfs_clone+0x6ae/0xcc0 [btrfs]
> [235491.228053]  [<ffffffffa09ade69>] btrfs_ioctl_clone+0x779/0x7b0 [btrfs]
> [235491.228059]  [<ffffffffa09b18b7>] btrfs_ioctl+0x10d7/0x2810 [btrfs]
> [235491.228063]  [<ffffffff81193b19>] ? free_pages_and_swap_cache+0xb9/0xe0
> [235491.228066]  [<ffffffff8117d14c>] ? tlb_flush_mmu_free+0x2c/0x50
> [235491.228068]  [<ffffffff8117dd2d>] ? tlb_finish_mmu+0x4d/0x50
> [235491.228070]  [<ffffffff81185cd2>] ? unmap_region+0xe2/0x130
> [235491.228073]  [<ffffffff811ac539>] ? kmem_cache_free+0x199/0x1d0
> [235491.228075]  [<ffffffff811da5f0>] do_vfs_ioctl+0x2d0/0x4b0
> [235491.228076]  [<ffffffff81187fd0>] ? do_munmap+0x260/0x400
> [235491.228078]  [<ffffffff811da851>] SyS_ioctl+0x81/0xa0
> [235491.228081]  [<ffffffff8153db29>] system_call_fastpath+0x16/0x1b
> [235491.228082] ---[ end trace 636d52c4c1dff6bc ]---

I'm seeing a near exact stack trace.  I'm running Syncthing.  When
making changes to a file, all of the machines that should receive the
change appear to show the old file.  An ls -l on the receiving
machines indicates the file has zero links.  Attempting to rename the
file causes the filesystem to go read-only and produce the below
dmesg.  Upon reboot, the file displays the correct contents.  I'm
running Archlinux with kernel 3.17.6.  I'm seeing this error on four
machines and can reproduce it consistently.


[  184.546231] WARNING: CPU: 3 PID: 2529 at fs/btrfs/super.c:259
__btrfs_abort_transaction+0x50/0x110 [btrfs]()
[  184.546267] BTRFS: Transaction aborted (error -2)
[  184.546270] Modules linked in: md5 ecb ecryptfs cbc sha256_ssse3
sha256_generic encrypted_keys sha1_ssse3 sha1_generic hmac trusted
joydev nf_conntrack_irc nf_conntrack_ftp xt_NFLOG nfnetlink_log
nfnetlink xt_limit xt_helper pci_stub vboxpci(O) vboxnetflt(O)
vboxnetadp(O) vboxdrv(O) nvidia_uvm(PO) nvidia(PO) ipt_REJECT
xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack dell_wmi sparse_keymap
snd_hda_codec_hdmi ip6table_filter ip6_tables iptable_filter ip_tables
x_tables snd_hda_codec_idt snd_hda_codec_generic iTCO_wdt
iTCO_vendor_support arc4 brcmsmac cordic brcmutil b43 mac80211
cfg80211 ssb rng_core pcmcia pcmcia_core ppdev dell_laptop rfkill
dcdbas nls_iso8859_1 coretemp hwmon intel_rapl nls_cp437
x86_pkg_temp_thermal vfat intel_powerclamp fat
[  184.546363]  kvm_intel kvm uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core v4l2_common mousedev videodev psmouse
media serio_raw i2c_i801 parport_pc snd_hda_intel snd_hda_controller
snd_hda_codec tpm_tis snd_hwdep bcma wmi tpm lpc_ich snd_pcm parport
e1000e dell_smo8800 evdev battery snd_timer mac_hid ac snd mei_me
thermal mei ptp shpchp pps_core soundcore processor sch_fq_codel btrfs
xor raid6_pq algif_skcipher af_alg hid_generic usbhid hid dm_crypt
dm_mod sd_mod crc_t10dif atkbd libps2 crct10dif_pclmul
crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
ahci libahci libata firewire_ohci sdhci_pci firewire_core sdhci
crc_itu_t led_class ehci_pci scsi_mod ehci_hcd mmc_core usbcore
usb_common i8042 serio i915
[  184.546479]  button intel_gtt i2c_algo_bit video drm_kms_helper drm i2c_core
[  184.546495] CPU: 3 PID: 2529 Comm: mv Tainted: P           O
3.17.6-1-dzk #1
[  184.546498] Hardware name: Dell Inc. Latitude E6520/0J4TFW, BIOS
A12 02/28/2012
[  184.546502]  0000000000000000 00000000e32254cc ffff8801f4d8bad0
ffffffff81540cbe
[  184.546509]  ffff8801f4d8bb18 ffff8801f4d8bb08 ffffffff8107079d
00000000fffffffe
[  184.546515]  ffff880231734e60 ffff880230b4a000 ffffffffa04367ab
0000000000002134
[  184.546522] Call Trace:
[  184.546535]  [<ffffffff81540cbe>] dump_stack+0x4d/0x6f
[  184.546546]  [<ffffffff8107079d>] warn_slowpath_common+0x7d/0xa0
[  184.546557]  [<ffffffff8107081c>] warn_slowpath_fmt+0x5c/0x80
[  184.546583]  [<ffffffffa0389d10>]
__btrfs_abort_transaction+0x50/0x110 [btrfs]
[  184.546613]  [<ffffffffa03c6ea1>] btrfs_rename2+0x351/0x7a0 [btrfs]
[  184.546622]  [<ffffffff811d7bf7>] vfs_rename+0x5b7/0x740
[  184.546632]  [<ffffffff8126510c>] ? security_inode_permission+0x1c/0x30
[  184.546640]  [<ffffffffa156cc5e>] ecryptfs_rename+0x9e/0x140 [ecryptfs]
[  184.546646]  [<ffffffff811d7d71>] vfs_rename+0x731/0x740
[  184.546652]  [<ffffffff811d1dcc>] ? lookup_dcache+0x5c/0xc0
[  184.546659]  [<ffffffff811d8eeb>] SyS_renameat2+0x4cb/0x540
[  184.546664]  [<ffffffff811d2c32>] ? final_putname+0x22/0x50
[  184.546672]  [<ffffffff8105e9bc>] ? __do_page_fault+0x2ec/0x600
[  184.546680]  [<ffffffff811ccb11>] ? cp_new_stat+0x121/0x150
[  184.546686]  [<ffffffff811d7ff1>] ? user_path_at+0x11/0x20
[  184.546692]  [<ffffffff811cc94a>] ? vfs_fstatat+0x6a/0xd0
[  184.546699]  [<ffffffff8105ecf2>] ? do_page_fault+0x22/0x30
[  184.546705]  [<ffffffff811d8f9e>] SyS_rename+0x1e/0x20
[  184.546712]  [<ffffffff81546ce9>] system_call_fastpath+0x16/0x1b
[  184.546717] ---[ end trace dd8088111b8a5fd9 ]---
[  184.546723] BTRFS: error (device dm-0) in btrfs_rename:8500:
errno=-2 No such entry
[  184.546729] BTRFS info (device dm-0): forced readonly
[  184.546783] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.546941] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547107] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547280] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547435] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547589] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547741] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.547907] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548058] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548231] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548369] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548488] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548610] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548737] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548851] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.548963] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549079] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549201] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549342] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549457] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549568] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549680] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549786] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.549902] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550015] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550119] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550257] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550374] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550488] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550614] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550729] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550843] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.550957] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  184.551879] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  188.524689] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  188.525102] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  188.525519] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  188.532231] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  200.209986] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  200.210397] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  201.074376] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  201.078328] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
[  201.088432] systemd-journald[213]: Failed to truncate file to its
own size: Read-only file system
-- 
-=[dave]=-

Entropy isn't what it used to be.
