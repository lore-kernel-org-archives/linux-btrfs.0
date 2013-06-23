Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47835 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3FWDrc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 23:47:32 -0400
Received: by mail-wi0-f171.google.com with SMTP id hj3so1654731wib.4
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jun 2013 20:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
References: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Sun, 23 Jun 2013 05:47:09 +0200
Message-ID: <CAK-xaQZW9ba1Dvzz3VrtoY9RA4ueLi-xhUQm26ZqmXB_Jtj9OQ@mail.gmail.com>
Subject: Re: help: btrfs bad tree block start
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/6/23 Andrea Gelmini <andrea.gelmini@gmail.com>:
>    The system went read only mode while I was copying in some files.

I reply to myself to add the kernel complain when BTFS switched to ro mode:

Jun 23 05:01:06 glen kernel: [46511.108103] device label GelmaWdUsb2T
devid 1 transid 1479 /dev/mapper/toshi
Jun 23 05:01:06 glen kernel: [46511.111118] btrfs: use zlib compression
Jun 23 05:01:06 glen kernel: [46511.111122] btrfs: turning off barriers
Jun 23 05:01:06 glen kernel: [46511.111125] btrfs: disk space caching is enabled
Jun 23 05:01:59 glen kernel: [46564.107708] ------------[ cut here ]------------
Jun 23 05:01:59 glen kernel: [46564.107718] WARNING: at
fs/btrfs/super.c:253 __btrfs_abort_transaction+0x11d/0x130()
Jun 23 05:01:59 glen kernel: [46564.107720] Hardware name: 239238G
Jun 23 05:01:59 glen kernel: [46564.107721] btrfs: Transaction aborted
(error -75)
Jun 23 05:01:59 glen kernel: [46564.107723] Modules linked in:
nls_iso8859_1 nls_cp850 vfat fat btusb pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt(O) joydev vboxdrv(O) cpufreq_userspace
cpufreq_powersave cpufreq_ondemand iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi intel_powerclamp coretemp uvcvideo
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media
microcode snd_hda_codec_hdmi psmouse serio_raw snd_hda_codec_realtek
thinkpad_acpi nvram snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm
snd_page_alloc iwldvm snd_seq_midi snd_seq_midi_event mac80211
snd_rawmidi snd_seq iwlwifi lpc_ich tpm_tis cfg80211 tpm
snd_seq_device tpm_bios snd_timer snd soundcore mei bnep rfcomm
bluetooth binfmt_misc nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
fscache raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx raid1 raid0 multipath hid_generic usbhid hid
crc32_pclmul usb_storage ghash_clmulni_intel wmi sdhci_pci sdhci
mmc_core e1000e ptp pps_core i915 video i2c_algo_bit drm_kms_helper
drm
Jun 23 05:01:59 glen kernel:
Jun 23 05:01:59 glen kernel: [46564.107784] Pid: 766, comm:
btrfs-transacti Tainted: G           O 3.9.7+ #3
Jun 23 05:01:59 glen kernel: [46564.107786] Call Trace:
Jun 23 05:01:59 glen kernel: [46564.107791]  [<ffffffff810894b0>]
warn_slowpath_common+0x70/0xa0
Jun 23 05:01:59 glen kernel: [46564.107793]  [<ffffffff8108952c>]
warn_slowpath_fmt+0x4c/0x50
Jun 23 05:01:59 glen kernel: [46564.107796]  [<ffffffff8128589d>]
__btrfs_abort_transaction+0x11d/0x130
Jun 23 05:01:59 glen kernel: [46564.107800]  [<ffffffff812a3e1f>]
btrfs_del_csums+0x2bf/0x2d0
Jun 23 05:01:59 glen kernel: [46564.107802]  [<ffffffff812963b8>]
__btrfs_free_extent+0x7e8/0xa60
Jun 23 05:01:59 glen kernel: [46564.107806]  [<ffffffff8129a102>]
run_clustered_refs+0x372/0xd90
Jun 23 05:01:59 glen kernel: [46564.107810]  [<ffffffff810b86d5>] ?
check_preempt_curr+0x85/0xa0
Jun 23 05:01:59 glen kernel: [46564.107812]  [<ffffffff810b871c>] ?
ttwu_do_wakeup+0x2c/0xe0
Jun 23 05:01:59 glen kernel: [46564.107815]  [<ffffffff8129eec0>]
btrfs_run_delayed_refs+0xe0/0x530
Jun 23 05:01:59 glen kernel: [46564.107818]  [<ffffffff812aed0e>]
btrfs_commit_transaction+0x4e/0x960
Jun 23 05:01:59 glen kernel: [46564.107821]  [<ffffffff812a68e5>]
transaction_kthread+0x195/0x230
Jun 23 05:01:59 glen kernel: [46564.107824]  [<ffffffff812a6750>] ?
free_fs_root+0xa0/0xa0
Jun 23 05:01:59 glen kernel: [46564.107828]  [<ffffffff810abdb0>]
kthread+0xc0/0xd0
Jun 23 05:01:59 glen kernel: [46564.107831]  [<ffffffff810abcf0>] ?
kthread_create_on_node+0x120/0x120
Jun 23 05:01:59 glen kernel: [46564.107835]  [<ffffffff8166125c>]
ret_from_fork+0x7c/0xb0
Jun 23 05:01:59 glen kernel: [46564.107838]  [<ffffffff810abcf0>] ?
kthread_create_on_node+0x120/0x120
Jun 23 05:01:59 glen kernel: [46564.107840] ---[ end trace 61ae1f206606f04b ]---
Jun 23 05:01:59 glen kernel: [46564.107842] BTRFS error (device dm-3)
in btrfs_del_csums:657: errno=-75 unknown
Jun 23 05:01:59 glen kernel: [46564.107844] BTRFS info (device dm-3):
forced readonly
Jun 23 05:01:59 glen kernel: [46564.107846] BTRFS error (device dm-3)
in __btrfs_free_extent:5801: errno=-75 unknown
Jun 23 05:01:59 glen kernel: [46564.107847] BTRFS debug (device dm-3):
run_one_delayed_ref returned -75
Jun 23 05:01:59 glen kernel: [46564.107850] BTRFS error (device dm-3)
in btrfs_run_delayed_refs:2677: errno=-75 unknown

Thanks a lot for your time,
Gelma
