Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:37396 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcFUPUT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 11:20:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 88A9435AEBF
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 16:54:59 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FVscCRYKBkde for <linux-btrfs@vger.kernel.org>;
	Tue, 21 Jun 2016 16:54:57 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 16:54:57 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 21 Jun 2016 23:54:57 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: can't use btrfs on USB-stick (write errors)
Message-ID: <85480401635e3cc778b7ab1d241072e8@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've tried to use btrfs on USB-stick, but unfortunately it fails with 
write errors.

The below is for kernel 4.4; I've tried with 4.6.2, and it fails in a 
similar way.


I'm not sure how to reliably reproduce it, but it seems to me it has 
something to do with:

- plenty of random writes

- USB stick sometimes "very slow to reply" (may be USB-stick dependent)


The closest thing to reproduce pretty much within an hour was launching 
ktorrent and downloading a couple of Linux isos.

ext4 does not fail under similar load. USB stick is brand new, writing 
data with dd is successful, reading data with dd is successful (whether 
it's ext4, btrfs or raw partition); it only seems to fail with btrfs and 
plenty of random writes.


Jun 14 07:50:26 ativ kernel: [57362.029895] 
btrfs_dev_stat_print_on_error: 3 callbacks suppressed
Jun 14 07:50:26 ativ kernel: [57362.029912] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.030912] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.031585] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.032260] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033040] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033400] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033408] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033491] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033498] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033566] BTRFS error (device sdb1): 
bdev /dev/sdb1 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
Jun 14 07:50:26 ativ kernel: [57362.033587] BTRFS: error (device sdb1) 
in btrfs_commit_transaction:2124: errno=-5 IO failure (Error while 
writing out transaction)
Jun 14 07:50:26 ativ kernel: [57362.033591] BTRFS info (device sdb1): 
forced readonly
Jun 14 07:50:26 ativ kernel: [57362.033597] BTRFS warning (device sdb1): 
Skipping commit of aborted transaction.
Jun 14 07:50:26 ativ kernel: [57362.033601] ------------[ cut here 
]------------
Jun 14 07:50:26 ativ kernel: [57362.033659] WARNING: CPU: 3 PID: 24844 
at /build/linux-oXTOqc/linux-4.4.0/fs/btrfs/transaction.c:1746 
cleanup_transaction+0x92/0x300 [btrfs]()
Jun 14 07:50:26 ativ kernel: [57362.033662] BTRFS: Transaction aborted 
(error -5)
Jun 14 07:50:26 ativ kernel: [57362.033665] Modules linked in: 
nls_iso8859_1 ctr ccm hid_generic usbhid hid rfcomm pci_stub vboxpci(OE) 
vboxnetadp(OE) vboxnetflt(OE) msr vboxdrv(OE) drbg ansi_cprng 
xt_CHECKSUM iptable_mangle bnep ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp 
llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter 
ip_tables x_tables rtsx_usb_ms memstick ath3k btusb btrtl btbcm btintel 
amd_freq_sensitivity uvcvideo crct10dif_pclmul videobuf2_vmalloc 
videobuf2_memops crc32_pclmul bluetooth samsung_laptop videobuf2_v4l2 
videobuf2_core v4l2_common arc4 videodev media ath9k aesni_intel 
ath9k_common aes_x86_64 snd_hda_codec_realtek lrw snd_hda_codec_generic 
gf128mul ath9k_hw glue_helper snd_hda_codec_hdmi ablk_helper 
snd_hda_intel cryptd snd_hda_codec ath snd_hda_core snd_hwdep mac80211 
joydev snd_pcm edac_mce_amd input_leds snd_seq_midi edac_core serio_raw 
snd_seq_midi_event fam15h_power k10temp i2c_piix4 snd_rawmidi cfg80211 
snd_seq snd_seq_device snd_timer shpchp snd soundcore mac_hid 
binfmt_misc kvm_amd kvm irqbypass parport_pc ppdev sunrpc lp parport 
autofs4 btrfs xor raid6_pq rtsx_usb_sdmmc uas usb_storage rtsx_usb 
amdkfd amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper syscopyarea 
psmouse sysfillrect sysimgblt fb_sys_fops ahci drm libahci r8169 mii wmi 
fjes video
Jun 14 07:50:26 ativ kernel: [57362.033842] CPU: 3 PID: 24844 Comm: 
ktorrent Tainted: G        W  OE   4.4.0-24-generic #43-Ubuntu
Jun 14 07:50:26 ativ kernel: [57362.033846] Hardware name: SAMSUNG 
ELECTRONICS CO., LTD. 905S3G/906S3G/915S3G/NP905S3G-K01PL, BIOS 
P06RBV.074.130822.FL 08/22/2013
Jun 14 07:50:26 ativ kernel: [57362.033851]  0000000000000286 
000000004d3ecc09 ffff8800043a3bf0 ffffffff813eab23
Jun 14 07:50:26 ativ kernel: [57362.033858]  ffff8800043a3c38 
ffffffffc03fa060 ffff8800043a3c28 ffffffff810810d2
Jun 14 07:50:26 ativ kernel: [57362.033864]  ffff8801211a5cb0 
ffff880137001800 ffff8800442a93c0 00000000fffffffb
Jun 14 07:50:26 ativ kernel: [57362.033870] Call Trace:
Jun 14 07:50:26 ativ kernel: [57362.033884]  [<ffffffff813eab23>] 
dump_stack+0x63/0x90
Jun 14 07:50:26 ativ kernel: [57362.033893]  [<ffffffff810810d2>] 
warn_slowpath_common+0x82/0xc0
Jun 14 07:50:26 ativ kernel: [57362.033899]  [<ffffffff8108116c>] 
warn_slowpath_fmt+0x5c/0x80
Jun 14 07:50:26 ativ kernel: [57362.033937]  [<ffffffffc0374092>] 
cleanup_transaction+0x92/0x300 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.033945]  [<ffffffff810c3b80>] ? 
wake_atomic_t_function+0x60/0x60
Jun 14 07:50:26 ativ kernel: [57362.033983]  [<ffffffffc0374e64>] 
btrfs_commit_transaction+0x2e4/0xa90 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.034020]  [<ffffffffc036e9af>] 
btrfs_commit_super+0x8f/0xa0 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.034056]  [<ffffffffc03704ee>] 
close_ctree+0x2ae/0x360 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.034088]  [<ffffffffc033fee9>] 
btrfs_put_super+0x19/0x20 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.034097]  [<ffffffff8120ee7f>] 
generic_shutdown_super+0x6f/0x100
Jun 14 07:50:26 ativ kernel: [57362.034102]  [<ffffffff8120f192>] 
kill_anon_super+0x12/0x20
Jun 14 07:50:26 ativ kernel: [57362.034133]  [<ffffffffc03410b8>] 
btrfs_kill_super+0x18/0x120 [btrfs]
Jun 14 07:50:26 ativ kernel: [57362.034140]  [<ffffffff8120f363>] 
deactivate_locked_super+0x43/0x70
Jun 14 07:50:26 ativ kernel: [57362.034145]  [<ffffffff8120f83c>] 
deactivate_super+0x5c/0x60
Jun 14 07:50:26 ativ kernel: [57362.034151]  [<ffffffff8122d0ef>] 
cleanup_mnt+0x3f/0x90
Jun 14 07:50:26 ativ kernel: [57362.034156]  [<ffffffff8122d182>] 
__cleanup_mnt+0x12/0x20
Jun 14 07:50:26 ativ kernel: [57362.034163]  [<ffffffff8109eac3>] 
task_work_run+0x73/0x90
Jun 14 07:50:26 ativ kernel: [57362.034170]  [<ffffffff81003242>] 
exit_to_usermode_loop+0xc2/0xd0
Jun 14 07:50:26 ativ kernel: [57362.034176]  [<ffffffff81003c6e>] 
syscall_return_slowpath+0x4e/0x60
Jun 14 07:50:26 ativ kernel: [57362.034185]  [<ffffffff81825d50>] 
int_ret_from_sys_call+0x25/0x8f
Jun 14 07:50:26 ativ kernel: [57362.034189] ---[ end trace 
43a0a9df7507537d ]---
Jun 14 07:50:26 ativ kernel: [57362.034194] BTRFS: error (device sdb1) 
in cleanup_transaction:1746: errno=-5 IO failure
Jun 14 07:50:26 ativ kernel: [57362.034200] BTRFS info (device sdb1): 
delayed_refs has NO entry
Jun 14 07:50:26 ativ kernel: [57362.034220] BTRFS error (device sdb1): 
commit super ret -5
Jun 14 07:50:26 ativ kernel: [57362.034339] BTRFS error (device sdb1): 
cleaner transaction attach returned -30



Tomasz Chmielewski
http://wpkg.org
