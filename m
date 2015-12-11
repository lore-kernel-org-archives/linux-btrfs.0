Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz29.laposte.net ([194.117.213.104]:58558 "EHLO
	smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbbLKNXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 08:23:03 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
	by lpn-prd-vrout017 (Postfix) with ESMTP id B6AEBA00E31
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 14:23:00 +0100 (CET)
Received: from lpn-prd-vrin004 (lpn-prd-vrin004.laposte [10.128.63.5])
	by lpn-prd-vrout017 (Postfix) with ESMTP id B3997A00DA0
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 14:23:00 +0100 (CET)
Received: from lpn-prd-vrin004 (localhost [127.0.0.1])
	by lpn-prd-vrin004 (Postfix) with ESMTP id A2A4270E25B
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 14:23:00 +0100 (CET)
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net> <56607848.5040705@laposte.net>
 <5660E2BD.3050000@cn.fujitsu.com>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org,
        calestyo@scientia.net
From: Laurent Bonnaud <L.Bonnaud@laposte.net>
Message-ID: <566ACE33.1010800@laposte.net>
Date: Fri, 11 Dec 2015 14:22:59 +0100
MIME-Version: 1.0
In-Reply-To: <5660E2BD.3050000@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/12/2015 01:47, Qu Wenruo wrote:

> The chunk mismatch problem should be resolved already, as the patch is merged in david's devel branch.

Great !  I am looking forward to a new release with this bug fix...

> But for the kernel abort transaction, I'm sorry there is no good clue yet.
> Only generic advice like update kernel to recent rc, as it has some new fixes which may help your case.

I tested again my "du -s" test with kernel 4.4-rc4 and got the following backtrace.  Is this a normal error message or an anomaly in the kernel ?

[  194.509475] BTRFS: device label sauvegarde-IUT2 devid 1 transid 9057 /dev/sdb1
[  194.599397] BTRFS info (device sdb1): disk space caching is enabled
[  227.764561] BTRFS warning (device sdb1): block group 314635714560 has wrong amount of free space
[  227.764564] BTRFS warning (device sdb1): failed to load free space cache for block group 314635714560, rebuild it now
[  228.108072] ------------[ cut here ]------------
[  228.108089] WARNING: CPU: 0 PID: 3303 at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:2927 btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]()
[  228.108090] BTRFS: Transaction aborted (error -17)
[  228.108091] Modules linked in: ses enclosure uas usb_storage xt_CHECKSUM iptable_mangle xt_tcpudp rfcomm xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c binfmt_misc bnep drbg ansi_cprng dm_crypt dell_wmi sparse_keymap intel_rapl dell_rbtn snd_hda_codec_hdmi iosf_mbi dell_laptop x86_pkg_temp_thermal intel_powerclamp dcdbas snd_hda_codec_idt coretemp dell_smm_hwmon snd_hda_codec_generic crct10dif_pclmul crc32_pclmul snd_hda_intel snd_hda_codec aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd snd_hda_core snd_hwdep arc4 btusb joydev input_leds btrtl btbcm btintel bluetooth iwlmvm
[  228.108120]  serio_raw mac80211 snd_pcm iwlwifi snd_seq_midi snd_seq_midi_event snd_rawmidi cfg80211 snd_seq snd_seq_device snd_timer lpc_ich mei_me snd mei soundcore kvm_intel shpchp kvm irqbypass dell_smo8800 8250_fintek mac_hid tpm_rng parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq hid_generic usbhid hid i915 psmouse firewire_ohci ahci libahci i2c_algo_bit firewire_core drm_kms_helper sdhci_pci e1000e sdhci crc_itu_t syscopyarea sysfillrect sysimgblt ptp fb_sys_fops pps_core drm wmi video fjes
[  228.108144] CPU: 0 PID: 3303 Comm: btrfs-transacti Not tainted 4.4.0-040400rc4-generic #201512061930
[  228.108145] Hardware name: Dell Inc. Latitude E6520/0NVF5K, BIOS A19 11/14/2013
[  228.108146]  0000000000000000 000000006496ca82 ffff88007c257d08 ffffffff813c8ab4
[  228.108148]  ffff88007c257d50 ffff88007c257d40 ffffffff8107d772 ffff8801b3b9b000
[  228.108149]  ffff880221f92000 ffff8801c4034170 ffffffffffffffff ffff880203a2d280
[  228.108151] Call Trace:
[  228.108155]  [<ffffffff813c8ab4>] dump_stack+0x44/0x60
[  228.108158]  [<ffffffff8107d772>] warn_slowpath_common+0x82/0xc0
[  228.108159]  [<ffffffff8107d80c>] warn_slowpath_fmt+0x5c/0x80
[  228.108166]  [<ffffffffc0345410>] ? __btrfs_run_delayed_refs+0xc40/0x1150 [btrfs]
[  228.108173]  [<ffffffffc034893b>] btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]
[  228.108180]  [<ffffffffc035b632>] ? btrfs_wait_pending_ordered+0x22/0x90 [btrfs]
[  228.108188]  [<ffffffffc035dc42>] btrfs_commit_transaction+0x4d2/0xa70 [btrfs]
[  228.108195]  [<ffffffffc0358e79>] transaction_kthread+0x229/0x240 [btrfs]
[  228.108201]  [<ffffffffc0358c50>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  228.108204]  [<ffffffff8109c8b8>] kthread+0xd8/0xf0
[  228.108206]  [<ffffffff8109c7e0>] ? kthread_create_on_node+0x1a0/0x1a0
[  228.108210]  [<ffffffff817fc58f>] ret_from_fork+0x3f/0x70
[  228.108211]  [<ffffffff8109c7e0>] ? kthread_create_on_node+0x1a0/0x1a0
[  228.108213] ---[ end trace 39e2e9062b36c29e ]---
[  228.108215] BTRFS: error (device sdb1) in btrfs_run_delayed_refs:2927: errno=-17 Object already exists
[  228.108217] BTRFS info (device sdb1): forced readonly
[  228.108219] BTRFS warning (device sdb1): Skipping commit of aborted transaction.
[  228.108220] BTRFS: error (device sdb1) in cleanup_transaction:1747: errno=-17 Object already exists

-- 
Laurent.
