Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gst.name ([78.46.150.186]:35633 "EHLO gst.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaK3Hi1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 02:38:27 -0500
Date: Sun, 30 Nov 2014 08:29:42 +0100
From: Guenther Starnberger <linux-btrfs@gst.priv.at>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Running out of disk space during BTRFS_IOC_CLONE - rebalance doesn't
 help
Message-ID: <20141130072942.GA475@gst.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having an issue with a filesystem where I'm regularly running out of disk
space during deduplication with bedup. Rebalancing does not help and the same
issue occurs even after a full rebalance.

Main use-case for this filesystem is a 3 TB backup disk where I'm creating
backups by copying a newer version of the data into a new directory and then
afterwards running bedup to deduplicate the data (using the older already
existing data).

What happens is that bedup will deduplicate some files successfully, but at
some point fails with an errno 28 (no space left on device) during
deduplication. I had some very limited success with running a balance, but
afterwards the same issue happens again after a few more files are
deduplicated (applies to balances with and without filters). According to fsck
the filesystem appears to be OK.

Is there anything else that I can try out in order to fix this issue? Or should
I try to create a new filesystem and copy the existing data?

Here's the log output:

dmesg:

[235491.227888] ------------[ cut here ]------------
[235491.227912] WARNING: CPU: 0 PID: 14837 at fs/btrfs/super.c:259 __btrfs_abort_transaction+0x50/0x110 [btrfs]()
[235491.227914] BTRFS: Transaction aborted (error -28)
[235491.227916] Modules linked in: fuse btrfs xor raid6_pq uas usb_storage ctr ccm toshiba_acpi sparse_keymap toshiba_haps joydev hp_accel lis3lv02d input_polldev hdaps(O) btusb bluetooth uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev qcserial media usb_wwan usbserial arc4 iwldvm snd_hda_codec_hdmi mousedev snd_hda_codec_conexant snd_hda_codec_generic mac80211 iTCO_wdt iTCO_vendor_support coretemp intel_powerclamp snd_hda_intel snd_hda_controller snd_hda_codec kvm_intel snd_hwdep iwlwifi thinkpad_acpi mei_me mei cfg80211 snd_pcm nvram lpc_ich kvm evdev snd_timer i915 snd mac_hid ac serio_raw e1000e psmouse led_class wmi rfkill shpchp drm_kms_helper intel_ips i2c_i801 soundcore drm battery hwmon ptp thermal pps_core i2c_algo_bit i2c_core video intel_agp intel_gtt button
[235491.227968]  acpi_cpufreq processor sch_fq_codel tp_smapi(O) thinkpad_ec(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_crypt dm_mod atkbd libps2 crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci ehci_hcd usbcore usb_common i8042 serio ata_piix sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common ahci libahci ata_generic libata scsi_mod
[235491.228001] CPU: 0 PID: 14837 Comm: bedup Tainted: G        W  O   3.17.4-1-ARCH #1
[235491.228003] Hardware name: LENOVO 3680U4M/3680U4M, BIOS 6QET68WW (1.38 ) 12/01/2011
[235491.228004]  0000000000000000 000000005deed0d1 ffff880144a57a90 ffffffff81537b0e
[235491.228006]  ffff880144a57ad8 ffff880144a57ac8 ffffffff8107078d 00000000ffffffe4
[235491.228008]  ffff8801719dcaa0 ffff88009e273800 ffffffffa09f7630 0000000000000c46
[235491.228010] Call Trace:
[235491.228017]  [<ffffffff81537b0e>] dump_stack+0x4d/0x6f
[235491.228021]  [<ffffffff8107078d>] warn_slowpath_common+0x7d/0xa0
[235491.228024]  [<ffffffff8107080c>] warn_slowpath_fmt+0x5c/0x80
[235491.228029]  [<ffffffffa0949d10>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
[235491.228040]  [<ffffffffa09aa9ba>] clone_finish_inode_update+0xda/0xf0 [btrfs]
[235491.228046]  [<ffffffffa09ad0de>] btrfs_clone+0x6ae/0xcc0 [btrfs]
[235491.228053]  [<ffffffffa09ade69>] btrfs_ioctl_clone+0x779/0x7b0 [btrfs]
[235491.228059]  [<ffffffffa09b18b7>] btrfs_ioctl+0x10d7/0x2810 [btrfs]
[235491.228063]  [<ffffffff81193b19>] ? free_pages_and_swap_cache+0xb9/0xe0
[235491.228066]  [<ffffffff8117d14c>] ? tlb_flush_mmu_free+0x2c/0x50
[235491.228068]  [<ffffffff8117dd2d>] ? tlb_finish_mmu+0x4d/0x50
[235491.228070]  [<ffffffff81185cd2>] ? unmap_region+0xe2/0x130
[235491.228073]  [<ffffffff811ac539>] ? kmem_cache_free+0x199/0x1d0
[235491.228075]  [<ffffffff811da5f0>] do_vfs_ioctl+0x2d0/0x4b0
[235491.228076]  [<ffffffff81187fd0>] ? do_munmap+0x260/0x400
[235491.228078]  [<ffffffff811da851>] SyS_ioctl+0x81/0xa0
[235491.228081]  [<ffffffff8153db29>] system_call_fastpath+0x16/0x1b
[235491.228082] ---[ end trace 636d52c4c1dff6bc ]---

btrfs fi show:

Label: none  uuid: 36c795fe-acb8-458e-87f4-721fedd81b8e
        Total devices 1 FS bytes used 2.14TiB
        devid    1 size 2.73TiB used 2.17TiB path /dev/mapper/crypt

btrfs fi df:

Data, single: total=2.12TiB, used=2.12TiB
System, DUP: total=32.00MiB, used=248.00KiB
Metadata, DUP: total=25.00GiB, used=23.64GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

I reported the same issue a year ago in <20131202081543.GA1104@gst.name> and
didn't receive a reply back then. The report in this email still applies to the
same filesystem. I just didn't use that filesystem a lot since then and also I
just recently retried to deduplicate the data on it.

- Guenther
