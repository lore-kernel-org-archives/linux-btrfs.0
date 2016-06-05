Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33131 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcFEBMd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 21:12:33 -0400
Received: by mail-yw0-f178.google.com with SMTP id h19so112656741ywc.0
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 18:12:32 -0700 (PDT)
MIME-Version: 1.0
From: Fugou Nashi <fugounashi+btrfs@gmail.com>
Date: Sun, 5 Jun 2016 10:12:31 +0900
Message-ID: <CAO8gOzMt2Wgb2jZ-eq-an-RqHPgssMgZ+O1jOxmZ4GPc-MdDYw@mail.gmail.com>
Subject: WARNING: at /home/kernel/COD/linux/fs/btrfs/inode.c:9261
 btrfs_destroy_inode+0x247/0x2c0 [btrfs]
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Do I need to worry about this?

Thanks.

Linux nakku 4.6.0-040600-generic #201605151930 SMP Sun May 15 23:32:59
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.4


[73168.435290] ------------[ cut here ]------------
[73168.435308] WARNING: CPU: 1 PID: 31935 at
/home/kernel/COD/linux/fs/btrfs/inode.c:9261
btrfs_destroy_inode+0x247/0x2c0 [btrfs]
[73168.435309] Modules linked in: uas usb_storage hidp rfcomm bnep
snd_hda_codec_hdmi arc4 nls_iso8859_1 snd_soc_skl snd_soc_skl_ipc
snd_soc_sst_ipc snd_hda_codec_realtek snd_soc_sst_dsp
snd_hda_codec_generic snd_hda_ext_core snd_soc_sst_match snd_soc_core
snd_compress ac97_bus snd_pcm_dmaengine dw_dmac_core snd_hda_intel
snd_hda_codec snd_hda_core snd_hwdep snd_pcm 8250_dw snd_seq_midi
snd_seq_midi_event snd_rawmidi iwlmvm mac80211 intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp snd_seq kvm_intel
iwlwifi snd_seq_device snd_timer kvm idma64 snd cfg80211 virt_dma
irqbypass soundcore joydev input_leds intel_lpss_pci shpchp mei_me
btusb hci_uart btrtl ir_lirc_codec mei btbcm lirc_dev btqca btintel
intel_pch_thermal bluetooth rc_rc6_mce ite_cir rc_core intel_lpss_acpi
intel_lpss mac_hid acpi_als
[73168.435336]  kfifo_buf acpi_pad industrialio ip6t_REJECT
nf_reject_ipv6 nf_log_ipv6 xt_hl ip6t_rt nf_conntrack_ipv6
nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common
xt_LOG xt_limit xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
iptable_filter ip_tables x_tables parport_pc ppdev lp parport autofs4
btrfs xor raid6_pq algif_skcipher af_alg dm_crypt hid_generic usbhid
crct10dif_pclmul crc32_pclmul i915 ghash_clmulni_intel aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd i2c_algo_bit
drm_kms_helper syscopyarea e1000e sysfillrect sysimgblt ptp
fb_sys_fops sdhci_pci pps_core ahci drm sdhci libahci video
pinctrl_sunrisepoint i2c_hid
[73168.435361]  pinctrl_intel hid fjes
[73168.435364] CPU: 1 PID: 31935 Comm: aptd Tainted: G        W
4.6.0-040600-generic #201605151930
[73168.435365] Hardware name:                  /NUC6i5SYB, BIOS
SYSKLi35.86A.0044.2016.0512.1734 05/12/2016
[73168.435366]  0000000000000286 000000009520d82d ffff880117013d18
ffffffff813f1dd3
[73168.435368]  0000000000000000 0000000000000000 ffff880117013d58
ffffffff810827eb
[73168.435369]  0000242dbd6066c0 ffff880033b981c8 ffff880033b981c8
ffff880035c61000
[73168.435371] Call Trace:
[73168.435375]  [<ffffffff813f1dd3>] dump_stack+0x63/0x90
[73168.435378]  [<ffffffff810827eb>] __warn+0xcb/0xf0
[73168.435380]  [<ffffffff8108291d>] warn_slowpath_null+0x1d/0x20
[73168.435391]  [<ffffffffc0410657>] btrfs_destroy_inode+0x247/0x2c0 [btrfs]
[73168.435393]  [<ffffffff8123f2db>] destroy_inode+0x3b/0x60
[73168.435395]  [<ffffffff8123f436>] evict+0x136/0x1a0
[73168.435397]  [<ffffffff8123f6aa>] iput+0x1ba/0x240
[73168.435398]  [<ffffffff8123ad9d>] __dentry_kill+0x18d/0x1e0
[73168.435400]  [<ffffffff8123af1b>] dput+0x12b/0x220
[73168.435402]  [<ffffffff8122514b>] __fput+0x18b/0x230
[73168.435404]  [<ffffffff8122522e>] ____fput+0xe/0x10
[73168.435405]  [<ffffffff810a15f3>] task_work_run+0x73/0x90
[73168.435408]  [<ffffffff81003232>] exit_to_usermode_loop+0xc2/0xd0
[73168.435409]  [<ffffffff81003c4e>] syscall_return_slowpath+0x4e/0x60
[73168.435411]  [<ffffffff8184223e>] entry_SYSCALL_64_fastpath+0xa6/0xa8
[73168.435413] ---[ end trace 37eae140a43ef5a8 ]---
