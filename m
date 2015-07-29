Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:36535 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbG2Q0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 12:26:01 -0400
Received: by vnk197 with SMTP id 197so3633175vnk.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 09:26:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Jul 2015 09:26:00 -0700
Message-ID: <CAOMFOmU3rPtY-VNzXHcYzrVjzwTGNO1qgiWns5=QOgN2O3MvuA@mail.gmail.com>
Subject: fs got readonly after "btrfs_run_delayed_refs:2783: errno=-5 IO failure"
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

At my home machine I use btrfs from the latest Linux kernel (Linux Arch).

A few days ago I started rebalance but unfortunately the machine got
rebooted. It looks like rebalance operation is not interrupt-tolerant
and now my filesystem got corrupted.

I see a lot of checksum errors, but as I use RAID most of these error
got fixed, I started scrub operation to find/fix all the problems but
the scrub operation got cancelled at the very beginning. I see
following error in kernel logs, it says "(device sdb):
run_one_delayed_ref returned -5" and after that "(device sdb): forced
readonly". What does it suppose to mean? I expect that scrub either
fix filesystem inconsistency problems. Or tell me what file are not
recoverable so I can delete/restore the data from backup. But now I
have a readonly filsystem and scrub refuses to recover it.

I see the same issue with current HEAD (v4.2-rc3). I enabled btrfs
debugging to get more info what is going on here

[  609.802479] BTRFS: read error corrected: ino 1 off 25324783960064
(dev /dev/sdc sector 2530931648)
[  609.814791] BTRFS (device sdb): parent transid verify failed on
25324789198848 wanted 443932 found 413701
[  609.835181] BTRFS: read error corrected: ino 1 off 25324789198848
(dev /dev/sdc sector 2530941880)
[  609.846056] BTRFS (device sdb): parent transid verify failed on
25324789448704 wanted 443932 found 413701
[  609.858280] BTRFS: read error corrected: ino 1 off 25324789448704
(dev /dev/sdc sector 2530942368)
[  609.859835] BTRFS (device sdb): parent transid verify failed on
25324789387264 wanted 443932 found 413701
[  609.870867] BTRFS: read error corrected: ino 1 off 25324789387264
(dev /dev/sdc sector 2530942248)
[  609.872679] BTRFS (device sdb): parent transid verify failed on
25324822609920 wanted 443938 found 441825
[  609.909616] BTRFS: read error corrected: ino 1 off 25324822609920
(dev /dev/sdc sector 2531007136)
[  609.967041] BTRFS (device sdb): parent transid verify failed on
25324678742016 wanted 443932 found 441820
[  609.970855] BTRFS: read error corrected: ino 1 off 25324678742016
(dev /dev/sdc sector 2530726144)
[  610.008460] BTRFS (device sdb): parent transid verify failed on
25324908392448 wanted 443938 found 415080
[  610.041669] BTRFS: read error corrected: ino 1 off 25324908392448
(dev /dev/sdc sector 2531174680)
[  610.116968] BTRFS (device sdb): parent transid verify failed on
25325058904064 wanted 443941 found 441828
[  610.123595] BTRFS: read error corrected: ino 1 off 25325058904064
(dev /dev/sdc sector 4024575336)
[  610.128482] BTRFS: read error corrected: ino 1 off 25324674007040
(dev /dev/sdc sector 2530716896)
[  640.028885] verify_parent_transid: 19 callbacks suppressed
[  640.030377] BTRFS (device sdb): parent transid verify failed on
25324845932544 wanted 443938 found 441825
[  640.062917] repair_io_failure: 18 callbacks suppressed
[  640.064486] BTRFS: read error corrected: ino 1 off 25324845932544
(dev /dev/sdc sector 2531052688)
[  640.119903] BTRFS (device sdb): parent transid verify failed on
25324845969408 wanted 443938 found 441827
[  640.125322] BTRFS: read error corrected: ino 1 off 25324845969408
(dev /dev/sdc sector 2531052760)
[  640.142157] BTRFS (device sdb): parent transid verify failed on
25325043716096 wanted 443940 found 441827
[  640.174974] BTRFS: read error corrected: ino 1 off 25325043716096
(dev /dev/sdc sector 4024545672)
[  640.185464] BTRFS (device sdb): parent transid verify failed on
25325503774720 wanted 443950 found 441837
[  640.238762] BTRFS: read error corrected: ino 1 off 25325503774720
(dev /dev/sdc sector 4025444224)
[  641.718129] BTRFS (device sdb): parent transid verify failed on
25325006667776 wanted 443940 found 441827
[  641.721734] BTRFS: read error corrected: ino 1 off 25325006667776
(dev /dev/sdc sector 4024473312)
[  641.723841] BTRFS (device sdb): parent transid verify failed on
25325006692352 wanted 443940 found 441827
[  641.725775] BTRFS: read error corrected: ino 1 off 25325006692352
(dev /dev/sdc sector 4024473360)
[  641.742454] BTRFS (device sdb): parent transid verify failed on
25325006716928 wanted 443940 found 441827
[  641.744649] BTRFS: read error corrected: ino 1 off 25325006716928
(dev /dev/sdc sector 4024473408)
[  641.778807] BTRFS (device sdb): parent transid verify failed on
25324804997120 wanted 443937 found 413700
[  641.819483] BTRFS: read error corrected: ino 1 off 25324804997120
(dev /dev/sdc sector 2530972736)
[  641.821201] BTRFS (device sdb): parent transid verify failed on
25324782997504 wanted 443937 found 441823
[  641.834794] BTRFS: read error corrected: ino 1 off 25324782997504
(dev /dev/sdc sector 2530929768)
[  641.836415] BTRFS (device sdb): parent transid verify failed on
25324805001216 wanted 443937 found 413700
[  641.838488] BTRFS: read error corrected: ino 1 off 25324805001216
(dev /dev/sdc sector 2530972744)
[  644.531005] BTRFS error (device sdb): run_one_delayed_ref returned -5
[  644.534562] ------------[ cut here ]------------
[  644.536283] WARNING: CPU: 1 PID: 106 at fs/btrfs/extent-tree.c:2783
btrfs_run_delayed_refs.part.40+0x223/0x250 [btrfs]()
[  644.538163] BTRFS: Transaction aborted (error -5)
[  644.538166] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  644.550463] CPU: 1 PID: 106 Comm: kworker/u4:9 Not tainted
4.2.0-rc4-gc4b5fd3 #1
[  644.552217] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  644.553897] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  644.555567]  0000000000000000 00000000bd668e66 ffff8800c88d7c68
ffffffff81565fb9
[  644.557249]  0000000000000000 ffff8800c88d7cc0 ffff8800c88d7ca8
ffffffff810737a6
[  644.558888]  0000000000000174 ffff88005d8e7000 ffff8800b8ed85a0
ffff8800c9716000
[  644.560498] Call Trace:
[  644.562131]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  644.563664]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  644.565160]  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
[  644.566662]  [<ffffffffa0778623>]
btrfs_run_delayed_refs.part.40+0x223/0x250 [btrfs]
[  644.568176]  [<ffffffffa07786ee>] delayed_ref_async_start+0x7e/0x90 [btrfs]
[  644.569642]  [<ffffffffa07bc227>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
[  644.571116]  [<ffffffffa07bc4ce>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  644.572502]  [<ffffffff8108b49b>] process_one_work+0x14b/0x440
[  644.573905]  [<ffffffff8108b7d8>] worker_thread+0x48/0x4a0
[  644.575260]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  644.576587]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  644.577914]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  644.579198]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  644.580500]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  644.581770]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  644.582992] ---[ end trace 7d2de1231b57cbbb ]---
[  644.584178] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2783: errno=-5 IO failure
[  644.585389] BTRFS error (device sdb): forced readonly
[  645.146126] verify_parent_transid: 46 callbacks suppressed
[  645.147359] BTRFS (device sdb): parent transid verify failed on
25325295259648 wanted 443949 found 441837
[  645.164884] BTRFS (device sdb): parent transid verify failed on
25325007695872 wanted 443940 found 414638
[  645.174681] BTRFS (device sdb): parent transid verify failed on
25325007749120 wanted 443940 found 414638
[  645.178334] BTRFS (device sdb): parent transid verify failed on
25325007753216 wanted 443940 found 414638
[  645.237449] BTRFS (device sdb): parent transid verify failed on
25325007773696 wanted 443940 found 441827
[  645.242862] BTRFS (device sdb): parent transid verify failed on
25324802801664 wanted 443937 found 441823
[  645.254271] BTRFS (device sdb): parent transid verify failed on
25325101031424 wanted 443941 found 441828
[  645.285372] BTRFS (device sdb): parent transid verify failed on
25325007802368 wanted 443940 found 414638
[  645.287101] BTRFS (device sdb): parent transid verify failed on
25325007872000 wanted 443940 found 441827
[  645.288678] BTRFS (device sdb): parent transid verify failed on
25325007884288 wanted 443940 found 441827
[  645.422416] ------------[ cut here ]------------
[  645.423418] WARNING: CPU: 1 PID: 97 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  645.424480] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  645.431851] CPU: 1 PID: 97 Comm: kworker/u4:4 Tainted: G        W
    4.2.0-rc4-gc4b5fd3 #1
[  645.432859] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  645.433877] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  645.434881]  0000000000000000 000000006a3037c0 ffff8800c8853b78
ffffffff81565fb9
[  645.435889]  0000000000000000 0000000000000000 ffff8800c8853bb8
ffffffff810737a6
[  645.436871]  ffff8800c8946400 ffff88005d8e7f18 ffff8800b8ed8468
0000000000000000
[  645.437850] Call Trace:
[  645.438827]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  645.439808]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  645.440787]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  645.441765]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  645.442750]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  645.443747]  [<ffffffffa07888ce>] ?
join_transaction.isra.3+0x10e/0x410 [btrfs]
[  645.444734]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  645.445728]  [<ffffffffa07786ee>] delayed_ref_async_start+0x7e/0x90 [btrfs]
[  645.446721]  [<ffffffffa07bc227>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
[  645.447717]  [<ffffffffa07bc4ce>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  645.448707]  [<ffffffff8108b49b>] process_one_work+0x14b/0x440
[  645.449694]  [<ffffffff8108b7d8>] worker_thread+0x48/0x4a0
[  645.450681]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  645.451680]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  645.452679]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  645.453679]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  645.454676]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  645.455677] ---[ end trace 7d2de1231b57cbbc ]---
[  647.522620] ------------[ cut here ]------------
[  647.523817] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.524955] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.534023] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.535333] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.536686]  0000000000000000 00000000f9176ba6 ffff8800c24c3b18
ffffffff81565fb9
[  647.538039]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.539430]  ffff8800c24c3b48 ffff88005d9827e8 ffff8800b8ed8468
0000000000000000
[  647.540822] Call Trace:
[  647.542221]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.543554]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.544838]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.546112]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.547290]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.548487]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.549691]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.550823]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.552024]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.553221]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.554295]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.555464]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.556609]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.557662]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.558821]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.559917]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.560963] ---[ end trace 7d2de1231b57cbbd ]---
[  647.593339] ------------[ cut here ]------------
[  647.594465] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.595774] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.606558] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.607870] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.609407]  0000000000000000 00000000f9176ba[  609.802479] BTRFS:
read error corrected: ino 1 off 25324783960064
(dev /dev/sdc sector 2530931648)
[  609.814791] BTRFS (device sdb): parent transid verify failed on
25324789198848 wanted 443932 found 413701
[  609.835181] BTRFS: read error corrected: ino 1 off 25324789198848
(dev /dev/sdc sector 2530941880)
[  609.846056] BTRFS (device sdb): parent transid verify failed on
25324789448704 wanted 443932 found 413701
[  609.858280] BTRFS: read error corrected: ino 1 off 25324789448704
(dev /dev/sdc sector 2530942368)
[  609.859835] BTRFS (device sdb): parent transid verify failed on
25324789387264 wanted 443932 found 413701
[  609.870867] BTRFS: read error corrected: ino 1 off 25324789387264
(dev /dev/sdc sector 2530942248)
[  609.872679] BTRFS (device sdb): parent transid verify failed on
25324822609920 wanted 443938 found 441825
[  609.909616] BTRFS: read error corrected: ino 1 off 25324822609920
(dev /dev/sdc sector 2531007136)
[  609.967041] BTRFS (device sdb): parent transid verify failed on
25324678742016 wanted 443932 found 441820
[  609.970855] BTRFS: read error corrected: ino 1 off 25324678742016
(dev /dev/sdc sector 2530726144)
[  610.008460] BTRFS (device sdb): parent transid verify failed on
25324908392448 wanted 443938 found 415080
[  610.041669] BTRFS: read error corrected: ino 1 off 25324908392448
(dev /dev/sdc sector 2531174680)
[  610.116968] BTRFS (device sdb): parent transid verify failed on
25325058904064 wanted 443941 found 441828
[  610.123595] BTRFS: read error corrected: ino 1 off 25325058904064
(dev /dev/sdc sector 4024575336)
[  610.128482] BTRFS: read error corrected: ino 1 off 25324674007040
(dev /dev/sdc sector 2530716896)
[  640.028885] verify_parent_transid: 19 callbacks suppressed
[  640.030377] BTRFS (device sdb): parent transid verify failed on
25324845932544 wanted 443938 found 441825
[  640.062917] repair_io_failure: 18 callbacks suppressed
[  640.064486] BTRFS: read error corrected: ino 1 off 25324845932544
(dev /dev/sdc sector 2531052688)
[  640.119903] BTRFS (device sdb): parent transid verify failed on
25324845969408 wanted 443938 found 441827
[  640.125322] BTRFS: read error corrected: ino 1 off 25324845969408
(dev /dev/sdc sector 2531052760)
[  640.142157] BTRFS (device sdb): parent transid verify failed on
25325043716096 wanted 443940 found 441827
[  640.174974] BTRFS: read error corrected: ino 1 off 25325043716096
(dev /dev/sdc sector 4024545672)
[  640.185464] BTRFS (device sdb): parent transid verify failed on
25325503774720 wanted 443950 found 441837
[  640.238762] BTRFS: read error corrected: ino 1 off 25325503774720
(dev /dev/sdc sector 4025444224)
[  641.718129] BTRFS (device sdb): parent transid verify failed on
25325006667776 wanted 443940 found 441827
[  641.721734] BTRFS: read error corrected: ino 1 off 25325006667776
(dev /dev/sdc sector 4024473312)
[  641.723841] BTRFS (device sdb): parent transid verify failed on
25325006692352 wanted 443940 found 441827
[  641.725775] BTRFS: read error corrected: ino 1 off 25325006692352
(dev /dev/sdc sector 4024473360)
[  641.742454] BTRFS (device sdb): parent transid verify failed on
25325006716928 wanted 443940 found 441827
[  641.744649] BTRFS: read error corrected: ino 1 off 25325006716928
(dev /dev/sdc sector 4024473408)
[  641.778807] BTRFS (device sdb): parent transid verify failed on
25324804997120 wanted 443937 found 413700
[  641.819483] BTRFS: read error corrected: ino 1 off 25324804997120
(dev /dev/sdc sector 2530972736)
[  641.821201] BTRFS (device sdb): parent transid verify failed on
25324782997504 wanted 443937 found 441823
[  641.834794] BTRFS: read error corrected: ino 1 off 25324782997504
(dev /dev/sdc sector 2530929768)
[  641.836415] BTRFS (device sdb): parent transid verify failed on
25324805001216 wanted 443937 found 413700
[  641.838488] BTRFS: read error corrected: ino 1 off 25324805001216
(dev /dev/sdc sector 2530972744)
[  644.531005] BTRFS error (device sdb): run_one_delayed_ref returned -5
[  644.534562] ------------[ cut here ]------------
[  644.536283] WARNING: CPU: 1 PID: 106 at fs/btrfs/extent-tree.c:2783
btrfs_run_delayed_refs.part.40+0x223/0x250 [btrfs]()
[  644.538163] BTRFS: Transaction aborted (error -5)
[  644.538166] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  644.550463] CPU: 1 PID: 106 Comm: kworker/u4:9 Not tainted
4.2.0-rc4-gc4b5fd3 #1
[  644.552217] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  644.553897] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  644.555567]  0000000000000000 00000000bd668e66 ffff8800c88d7c68
ffffffff81565fb9
[  644.557249]  0000000000000000 ffff8800c88d7cc0 ffff8800c88d7ca8
ffffffff810737a6
[  644.558888]  0000000000000174 ffff88005d8e7000 ffff8800b8ed85a0
ffff8800c9716000
[  644.560498] Call Trace:
[  644.562131]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  644.563664]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  644.565160]  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
[  644.566662]  [<ffffffffa0778623>]
btrfs_run_delayed_refs.part.40+0x223/0x250 [btrfs]
[  644.568176]  [<ffffffffa07786ee>] delayed_ref_async_start+0x7e/0x90 [btrfs]
[  644.569642]  [<ffffffffa07bc227>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
[  644.571116]  [<ffffffffa07bc4ce>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  644.572502]  [<ffffffff8108b49b>] process_one_work+0x14b/0x440
[  644.573905]  [<ffffffff8108b7d8>] worker_thread+0x48/0x4a0
[  644.575260]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  644.576587]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  644.577914]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  644.579198]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  644.580500]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  644.581770]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  644.582992] ---[ end trace 7d2de1231b57cbbb ]---
[  644.584178] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2783: errno=-5 IO failure
[  644.585389] BTRFS error (device sdb): forced readonly
[  645.146126] verify_parent_transid: 46 callbacks suppressed
[  645.147359] BTRFS (device sdb): parent transid verify failed on
25325295259648 wanted 443949 found 441837
[  645.164884] BTRFS (device sdb): parent transid verify failed on
25325007695872 wanted 443940 found 414638
[  645.174681] BTRFS (device sdb): parent transid verify failed on
25325007749120 wanted 443940 found 414638
[  645.178334] BTRFS (device sdb): parent transid verify failed on
25325007753216 wanted 443940 found 414638
[  645.237449] BTRFS (device sdb): parent transid verify failed on
25325007773696 wanted 443940 found 441827
[  645.242862] BTRFS (device sdb): parent transid verify failed on
25324802801664 wanted 443937 found 441823
[  645.254271] BTRFS (device sdb): parent transid verify failed on
25325101031424 wanted 443941 found 441828
[  645.285372] BTRFS (device sdb): parent transid verify failed on
25325007802368 wanted 443940 found 414638
[  645.287101] BTRFS (device sdb): parent transid verify failed on
25325007872000 wanted 443940 found 441827
[  645.288678] BTRFS (device sdb): parent transid verify failed on
25325007884288 wanted 443940 found 441827
[  645.422416] ------------[ cut here ]------------
[  645.423418] WARNING: CPU: 1 PID: 97 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  645.424480] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  645.431851] CPU: 1 PID: 97 Comm: kworker/u4:4 Tainted: G        W
    4.2.0-rc4-gc4b5fd3 #1
[  645.432859] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  645.433877] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  645.434881]  0000000000000000 000000006a3037c0 ffff8800c8853b78
ffffffff81565fb9
[  645.435889]  0000000000000000 0000000000000000 ffff8800c8853bb8
ffffffff810737a6
[  645.436871]  ffff8800c8946400 ffff88005d8e7f18 ffff8800b8ed8468
0000000000000000
[  645.437850] Call Trace:
[  645.438827]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  645.439808]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  645.440787]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  645.441765]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  645.442750]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  645.443747]  [<ffffffffa07888ce>] ?
join_transaction.isra.3+0x10e/0x410 [btrfs]
[  645.444734]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  645.445728]  [<ffffffffa07786ee>] delayed_ref_async_start+0x7e/0x90 [btrfs]
[  645.446721]  [<ffffffffa07bc227>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
[  645.447717]  [<ffffffffa07bc4ce>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  645.448707]  [<ffffffff8108b49b>] process_one_work+0x14b/0x440
[  645.449694]  [<ffffffff8108b7d8>] worker_thread+0x48/0x4a0
[  645.450681]  [<ffffffff8108b790>] ? process_one_work+0x440/0x440
[  645.451680]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  645.452679]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  645.453679]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  645.454676]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  645.455677] ---[ end trace 7d2de1231b57cbbc ]---
[  647.522620] ------------[ cut here ]------------
[  647.523817] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.524955] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.534023] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.535333] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.536686]  0000000000000000 00000000f9176ba6 ffff8800c24c3b18
ffffffff81565fb9
[  647.538039]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.539430]  ffff8800c24c3b48 ffff88005d9827e8 ffff8800b8ed8468
0000000000000000
[  647.540822] Call Trace:
[  647.542221]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.543554]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.544838]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.546112]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.547290]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.548487]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.549691]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.550823]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.552024]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.553221]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.554295]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.555464]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.556609]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.557662]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.558821]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.559917]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.560963] ---[ end trace 7d2de1231b57cbbd ]---
[  647.593339] ------------[ cut here ]------------
[  647.594465] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.595774] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.606558] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.607870] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.609407]  0000000000000000 00000000f9176ba6 ffff8800c24c3b18
ffffffff81565fb9
[  647.610719]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.612201]  ffff8800c24c3b48 ffff88005d982c38 ffff8800b8ed8468
0000000000000000
[  647.613602] Call Trace:
[  647.615053]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.616350]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.617691]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.619082]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.620360]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.621707]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.622969]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.624212]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.625448]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.626655]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.627808]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.629000]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.630149]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.631276]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.632441]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.633604]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.634698] ---[ end trace 7d2de1231b57cbbe ]---
[  647.650381] ------------[ cut here ]------------
[  647.651534] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.652641] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.661181] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.662412] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.663648]  0000000000000000 00000000f9176ba6 ffff8800c24c3b18
ffffffff81565fb9
[  647.664952]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.666267]  ffff8800c24c3b48 ffff88005d9820b8 ffff8800b8ed8468
0000000000000000
[  647.667527] Call Trace:
[  647.668794]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.670109]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.671368]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.672627]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.673858]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.675099]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.676337]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.677492]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.678594]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.679780]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.680935]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.682019]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.683130]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.684251]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.685326]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.686445]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.687537] ---[ end trace 7d2de1231b57cbbf ]---
[  650.786951] BTRFS error (device sdb): Skipping commit of aborted transaction.
[  650.788422] BTRFS: error (device sdb) in cleanup_transaction:1710:
errno=-5 IO failure6 ffff8800c24c3b18
ffffffff81565fb9
[  647.610719]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.612201]  ffff8800c24c3b48 ffff88005d982c38 ffff8800b8ed8468
0000000000000000
[  647.613602] Call Trace:
[  647.615053]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.616350]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.617691]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.619082]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.620360]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.621707]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.622969]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.624212]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.625448]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.626655]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.627808]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.629000]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.630149]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.631276]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.632441]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.633604]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.634698] ---[ end trace 7d2de1231b57cbbe ]---
[  647.650381] ------------[ cut here ]------------
[  647.651534] WARNING: CPU: 0 PID: 275 at fs/btrfs/delayed-ref.c:265
btrfs_select_ref_head+0x116/0x130 [btrfs]()
[  647.652641] Modules linked in: nct6775 hwmon_vid btrfs xor
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support ppdev evdev mac_hid
snd_hda_codec_hdmi serio_raw psmouse snd_hda_codec_realtek
snd_hda_codec_generic i2c_i801 crct10dif_pclmul crc32_pclmul
crc32c_intel i915 ghash_clmulni_intel cryptd pcspkr snd_hda_intel
snd_hda_codec raid6_pq snd_hda_core snd_hwdep drm_kms_helper atl1c
snd_pcm drm snd_timer intel_gtt snd i2c_algo_bit i2c_core lpc_ich
soundcore shpchp mei_me parport_pc nuvoton_cir mei rc_core parport
battery tpm_tis tpm video button processor sch_fq_codel ip_tables
x_tables ext4 crc16 mbcache jbd2 sd_mod uas usb_storage atkbd libps2
ahci libahci ehci_pci ehci_hcd xhci_pci libata xhci_hcd scsi_mod
usbcore usb_common i8042 serio
[  647.661181] CPU: 0 PID: 275 Comm: btrfs-transacti Tainted: G
W       4.2.0-rc4-gc4b5fd3 #1
[  647.662412] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[  647.663648]  0000000000000000 00000000f9176ba6 ffff8800c24c3b18
ffffffff81565fb9
[  647.664952]  0000000000000000 0000000000000000 ffff8800c24c3b58
ffffffff810737a6
[  647.666267]  ffff8800c24c3b48 ffff88005d9820b8 ffff8800b8ed8468
0000000000000000
[  647.667527] Call Trace:
[  647.668794]  [<ffffffff81565fb9>] dump_stack+0x4c/0x6e
[  647.670109]  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
[  647.671368]  [<ffffffff810738da>] warn_slowpath_null+0x1a/0x20
[  647.672627]  [<ffffffffa07d9c56>] btrfs_select_ref_head+0x116/0x130 [btrfs]
[  647.673858]  [<ffffffffa0773330>]
__btrfs_run_delayed_refs+0x250/0x1120 [btrfs]
[  647.675099]  [<ffffffffa078156e>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[  647.676337]  [<ffffffffa0778473>]
btrfs_run_delayed_refs.part.40+0x73/0x250 [btrfs]
[  647.677492]  [<ffffffffa0778d03>]
btrfs_start_dirty_block_groups+0x353/0x3f0 [btrfs]
[  647.678594]  [<ffffffffa0789b50>]
btrfs_commit_transaction+0x1d0/0xd10 [btrfs]
[  647.679780]  [<ffffffffa078a741>] ? start_transaction+0xb1/0x5d0 [btrfs]
[  647.680935]  [<ffffffffa0785113>] transaction_kthread+0x1c3/0x230 [btrfs]
[  647.682019]  [<ffffffffa0784f50>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  647.683130]  [<ffffffff81091378>] kthread+0xd8/0xf0
[  647.684251]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.685326]  [<ffffffff8156b89f>] ret_from_fork+0x3f/0x70
[  647.686445]  [<ffffffff810912a0>] ? kthread_worker_fn+0x170/0x170
[  647.687537] ---[ end trace 7d2de1231b57cbbf ]---
[  650.786951] BTRFS error (device sdb): Skipping commit of aborted transaction.
[  650.788422] BTRFS: error (device sdb) in cleanup_transaction:1710:
errno=-5 IO failure


run_one_delayed_ref returned returns EIO. What does it mean? I can do
some kernel debugging if you give me some pointer about this problem.
