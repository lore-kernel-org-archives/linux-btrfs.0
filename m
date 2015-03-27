Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ebox.rath.org ([23.92.25.96]:52061 "EHLO ebox.rath.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbbC0BCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 21:02:48 -0400
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Kernel warning at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0 [btrfs]()
Date: Thu, 26 Mar 2015 17:38:44 -0700
Message-ID: <87wq23ff57.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm running 4.0-rc3, and I'm regularly getting these warnings in my
kernel log:

Mar 26 17:31:13 vostro kernel: [21480.088671] ------------[ cut here ]------------
Mar 26 17:31:13 vostro kernel: [21480.088682] WARNING: CPU: 0 PID: 28958 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0 [btrfs]()
Mar 26 17:31:13 vostro kernel: [21480.088682] Modules linked in: hmac can_bcm sctp libcrc32c rds can_raw can binfmt_misc bridge stp llc tun ext4 crc16 mbcache jbd2 eeepc_wmi asus_wmi sparse_keymap rfkill mxm_wmi iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal mei_me intel_powerclamp psmouse intel_rapl lpc_ich pcspkr serio_raw iosf_mbi snd_hda_codec_hdmi mei snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 mfd_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore battery shpchp processor evdev wmi nct6775 hwmon_vid coretemp kvm_intel kvm loop fuse parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq sha256_ssse3 sha256_generic algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid usb_storage hid sr_mod cdrom sg sd_mod crct10dif_pclmul crc32_pclmul ahci xhci_pci i915 crc32c_intel ehci_pci e1000e i2c_algo_bit xhci_hcd ehci_hcd libahci ghash_clmulni_intel ptp libata aesni_intel aes_x86_64 lrw gf128mul pps_core glue_helper drm_kms_helper usbcore ablk_helper scsi_mod cryptd usb_common drm thermal i2c_core fan video thermal_sys button
Mar 26 17:31:13 vostro kernel: [21480.088729] CPU: 0 PID: 28958 Comm: python3 Tainted: G        W       4.0.0-rc3 #2
Mar 26 17:31:13 vostro kernel: [21480.088730] Hardware name: System manufacturer System Product Name/P8Z68-V GEN3, BIOS 3603 11/09/2012
Mar 26 17:31:13 vostro kernel: [21480.088730]  0000000000000000 ffffffffa055e547 ffffffff81553b12 0000000000000000
Mar 26 17:31:13 vostro kernel: [21480.088733]  ffffffff8106bfb1 ffff88020ed68f18 ffff88019a1b91b8 ffff880222b13000
Mar 26 17:31:13 vostro kernel: [21480.088734]  ffff88019a1b91b8 ffff8802248918b0 ffffffffa04edf7a ffff88019a1b91b8
Mar 26 17:31:13 vostro kernel: [21480.088736] Call Trace:
Mar 26 17:31:13 vostro kernel: [21480.088737]  [<ffffffff81553b12>] ? dump_stack+0x40/0x50
Mar 26 17:31:13 vostro kernel: [21480.088740]  [<ffffffff8106bfb1>] ? warn_slowpath_common+0x81/0xb0
Mar 26 17:31:13 vostro kernel: [21480.088743]  [<ffffffffa04edf7a>] ? btrfs_destroy_inode+0x1fa/0x2a0 [btrfs]
Mar 26 17:31:13 vostro kernel: [21480.088751]  [<ffffffff811d7370>] ? __dentry_kill+0x180/0x1f0
Mar 26 17:31:13 vostro kernel: [21480.088752]  [<ffffffff811d7507>] ? dput+0x127/0x220
Mar 26 17:31:13 vostro kernel: [21480.088754]  [<ffffffff811c19b6>] ? __fput+0x166/0x1e0
Mar 26 17:31:13 vostro kernel: [21480.088755]  [<ffffffff810879e7>] ? task_work_run+0xb7/0xf0
Mar 26 17:31:13 vostro kernel: [21480.088758]  [<ffffffff81013089>] ? do_notify_resume+0x69/0x90
Mar 26 17:31:13 vostro kernel: [21480.088760]  [<ffffffff8155976b>] ? int_signal+0x12/0x17
Mar 26 17:31:13 vostro kernel: [21480.088763] ---[ end trace e561afe37f492175 ]---

Anything I can do to help getting this fixed?

Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
