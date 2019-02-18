Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392AFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 07:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2E0A2089F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 07:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9UM2Zh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfBRHjA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 02:39:00 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:55393 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfBRHjA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 02:39:00 -0500
Received: by mail-it1-f196.google.com with SMTP id z131so28591518itf.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Feb 2019 23:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+26P9mgrGnMHYnfpt7J5q5VlfuggGbBnQkksjh0fGW8=;
        b=N9UM2Zh9EMlJa/ylnBO5o3qHdDFJMMQv0H7ukz5htv/3dtRRhQpBgy3Nx/F60KEU+k
         Umz4XmOadbQ+ss2ll9Ne2Vd15EFU2R1qpDZieV9fKSKFn0qLiRi/n82LZXcdyhX/xc1V
         lFKknOf2RXozS8lag6TCX3l+0qfdwd77YN7/DHclJ16K+ITZzUvaOxXb2QlyXiDmU1ju
         QNvxw9wSp1O2R4qWrGqexGiZzAS3fl+U/lEnd0rfuQ7EWxY1S1r3E4bGU4yavlFdZkYg
         uRWN/04apnmgDmJZCY4Iv55LuS3tWGTkz/ginSrxSXTdJGFuL2/z8uElygWfy09+shen
         6SZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+26P9mgrGnMHYnfpt7J5q5VlfuggGbBnQkksjh0fGW8=;
        b=fTMALexqJxO7ov30+ahDlLNH6RNmnOA1eCEtfk2LldrwKclbz5eDtxBh+cjb+Z6nxX
         rScCh1WgDfSkOf+m1VlDbyl6adsMDE1/d0Tkf4ykB/yuK4FHLcugTsM9nGjQdnkD2IGK
         8YEmm/VxfUzu95zZ9JBgUGN9nAuALbm6Nrj0epig8RvIADz2ggO3gBA2ok21mTmieh/R
         lWUAWaidX1pTDN0MkdvmLuc0OyjIZT2+8XiYEeL9Znzn/JuTMg1zrZ7EhTmItuiccbLl
         KNc+ArXyx29gmpvMn+EZ/YNXM22yvt5tpXrhDAspJ7k5IhA5/h2DlzpSQX0FyRR1mm96
         RMYA==
X-Gm-Message-State: AHQUAuaLCi/cACA1kyXNfH5VNsKzsCthSKEqrOHB/BTZ11mZGJuJg0P8
        9sHTQJ7/5aPvnfd5ifnMIQaAyXzZO2MS/ZEVg97Rbt1A
X-Google-Smtp-Source: AHgI3IYDPNYoZMfruKdadgYWkmIcZY2UtlpPnlavlJilLm5EgtLO2ynXGsziKg1pkXUdQL5dBWvgstsnf2hDOQRkmsc=
X-Received: by 2002:a05:660c:485:: with SMTP id a5mr7408342itk.29.1550475536604;
 Sun, 17 Feb 2019 23:38:56 -0800 (PST)
MIME-Version: 1.0
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
 <6a9c683a-bb47-109a-753d-010613ae595a@gmx.com> <CAG245DWL8+kEeMZ6WF2g0gWN+pjY=94704jvAwXVPeXuGuy-0g@mail.gmail.com>
 <CAG245DUHpvA53ziX_H1EXv4TPNbdh3zF_qmsE8RX-ARrVMgGTQ@mail.gmail.com>
In-Reply-To: <CAG245DUHpvA53ziX_H1EXv4TPNbdh3zF_qmsE8RX-ARrVMgGTQ@mail.gmail.com>
From:   =?UTF-8?Q?Martin_P=C3=B6hlmann?= <mpdeimos@gmail.com>
Date:   Mon, 18 Feb 2019 08:38:44 +0100
Message-ID: <CAG245DW_tx4f+-h4+nTXboKGALrpK8mSspeystx_KE6iECCWkA@mail.gmail.com>
Subject: Re: Btrfs corruption: Cannot mount partition
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Some more important insights: The switch to read-only mode may not
only happen on boot but also during working. I got the system running
and then tried again to compile our project with IntelliJ. Result is
basically the same as described in 1st mail. Compile aborts with some
unclear error. But when looking at the mounted partitions, the btrfs
mounts have changed from rw to ro. I guess this is why initially there
were logs that could be wiped with zero-log. But the actual problem
seems to be somewhere else.

The relevant dmesg output is identical to the one in my previous mail
(see bottom of this mail).

As I have a backup of all data I tried some scrub and check --repair cycles=
:
First check --repair complained about two things:
* space and super gen don't match, space cache will be invalidated
* 2x deleting bad dir index

Second (or any repeated) check --repair (after a scrub):
* block group X has wrong amount of free space
* free space cache has more free space then block item group item,
this could lead to serious corruption, please contact btrfs developers
:)
* failed to load free space cache

Also tried mounting with clear_cache, but after a while the system
goes to RO mode again.

As mentioned, I should have a backup to recover from (at least I can
boot from it). So you can either advise me to do even more adventurous
things or just to give up and recreate the FS. If it's the latter: I
have not backed up /var/lib/docker/btrfs as this will simply explode
in size (due to snapshotting and me using rsync for backup). Losing
this dir is no big deal, I'd just be interested if there are better
alternatives for backup (e.g. https://github.com/mwilck/btrfs-clone).

Thanks in advance!

Here is the dmesg output of the error again:

[   51.357285] BTRFS: Transaction aborted (error -2)
[   51.357304] WARNING: CPU: 3 PID: 54 at fs/btrfs/extent-tree.c:6828
__btrfs_free_extent.isra.25+0x67b/0x940 [btrfs]
[   51.357304] Modules linked in: isofs thunderbolt ccm rfcomm fuse
cmac snd_hda_codec_hdmi bnep snd_hda_codec_realtek
snd_hda_codec_generic hid_multitouch joydev arc4 iTCO_wdt
iTCO_vendor_support nls_iso8859_1 nls_cp437 vfat fat uvcvideo btusb
btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel
videobuf2_common ath10k_pci bluetooth ath10k_core videodev mousedev
i915 intel_rapl ath snd_soc_skl snd_soc_hdac_hda ecdh_generic
x86_pkg_temp_thermal intel_powerclamp snd_hda_ext_core media crc16
coretemp snd_soc_skl_ipc mac80211 uas snd_soc_sst_ipc kvm_intel
snd_soc_sst_dsp snd_soc_acpi_intel_match kvmgt snd_soc_acpi vfio_mdev
mdev mei_wdt dell_laptop vfio_iommu_type1 dell_wmi wmi_bmof
snd_soc_core vfio intel_wmi_thunderbolt dell_smbios
dell_wmi_descriptor snd_compress i2c_algo_bit dcdbas kvm ac97_bus
snd_pcm_dmaengine drm_kms_helper snd_hda_intel snd_hda_codec cfg80211
irqbypass intel_cstate intel_uncore snd_hda_core snd_hwdep input_leds
snd_pcm intel_rapl_perf drm snd_timer
[   51.357319]  psmouse rtsx_pci_ms pcspkr memstick idma64 rfkill snd
intel_gtt mei_me processor_thermal_device agpgart intel_soc_dts_iosf
soundcore mei syscopyarea sysfillrect i2c_i801 sysimgblt fb_sys_fops
intel_lpss_pci intel_lpss intel_pch_thermal ucsi_acpi tpm_crb
typec_ucsi wmi typec i2c_hid battery soc_button_array intel_vbtn
tpm_tis tpm_tis_core tpm int3403_thermal evdev int340x_thermal_zone
mac_hid intel_hid rng_core ac int3400_thermal acpi_thermal_rel
sparse_keymap pcc_cpufreq vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE)
vboxdrv(OE) sg crypto_user ip_tables x_tables btrfs libcrc32c
crc32c_generic xor raid6_pq algif_skcipher af_alg sd_mod usb_storage
scsi_mod hid_generic usbhid hid dm_crypt dm_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc mmc_core
serio_raw atkbd libps2 aesni_intel aes_x86_64 xhci_pci crypto_simd
cryptd glue_helper xhci_hcd rtsx_pci i8042 serio
[   51.357335] CPU: 3 PID: 54 Comm: kworker/u8:1 Tainted: G     U  W
OE     4.20.6-arch1-1-ARCH #1
[   51.357335] Hardware name: Dell Inc. XPS 13 9360/0PF86Y, BIOS 2.1.0
08/02/2017
[   51.357347] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs=
]
[   51.357355] RIP: 0010:__btrfs_free_extent.isra.25+0x67b/0x940 [btrfs]
[   51.357356] Code: 08 48 8b 40 50 f0 48 0f ba a8 90 12 00 00 02 0f
92 c0 5f 84 c0 0f 85 cc 0f 09 00 44 89 ee 48 c7 c7 70 82 35 c0 e8 af
7e 5d df <0f> 0b e9 b6 0f 09 00 4c 89 e7 e8 a6 7d fe ff 48 8b 3c 24 4d
89 f8
[   51.357356] RSP: 0018:ffffacf5c1b37c38 EFLAGS: 00010282
[   51.357357] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00000
[   51.357358] RDX: 0000000000000007 RSI: ffffffffa08a427e RDI: 00000000fff=
fffff
[   51.357358] RBP: 0000005ae1ce8000 R08: 0000000000000001 R09: 00000000000=
006b2
[   51.357359] R10: 0000000000000004 R11: 0000000000000000 R12: ffff9b03da4=
98ee0
[   51.357359] R13: 00000000fffffffe R14: 0000000000000000 R15: 00000000000=
00002
[   51.357360] FS:  0000000000000000(0000) GS:ffff9b04ae380000(0000)
knlGS:0000000000000000
[   51.357361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.357362] CR2: 00007f252cd16af0 CR3: 000000020140a006 CR4: 00000000003=
606e0
[   51.357362] Call Trace:
[   51.357364]  ? _raw_spin_lock+0x13/0x30
[   51.357365]  ? _raw_spin_unlock+0x16/0x30
[   51.357376]  ? btrfs_merge_delayed_refs+0x315/0x350 [btrfs]
[   51.357401]  __btrfs_run_delayed_refs+0x6f2/0x10e0 [btrfs]
[   51.357403]  ? preempt_count_add+0x79/0xb0
[   51.357411]  btrfs_run_delayed_refs+0x64/0x180 [btrfs]
[   51.357418]  delayed_ref_async_start+0x81/0x90 [btrfs]
[   51.357428]  normal_work_helper+0xbd/0x350 [btrfs]
[   51.357430]  process_one_work+0x1eb/0x410
[   51.357432]  worker_thread+0x2d/0x3d0
[   51.357433]  ? process_one_work+0x410/0x410
[   51.357434]  kthread+0x112/0x130
[   51.357435]  ? kthread_park+0x80/0x80
[   51.357437]  ret_from_fork+0x35/0x40
[   51.357438] ---[ end trace 0be7e900e0369796 ]---
[   51.357439] BTRFS: error (device dm-0) in __btrfs_free_extent:6828:
errno=3D-2 No such entry
[   51.357441] BTRFS info (device dm-0): forced readonly
[   51.357442] BTRFS: error (device dm-0) in
btrfs_run_delayed_refs:2978: errno=3D-2 No such entry

On Sun, Feb 17, 2019 at 5:27 PM Martin P=C3=B6hlmann <mpdeimos@gmail.com> w=
rote:
>
> Tried zero-log. After reboot the system booted again. But all
> sub-volumes are mounted read-only.
>
> This should be the relevant dmesg excerpt (note to last lines, there
> it mentions forced to ro mode)
>
> [   51.356769] WARNING: CPU: 3 PID: 54 at fs/btrfs/extent-tree.c:6822
> __btrfs_free_extent.isra.25+0x61e/0x940 [btrfs]
> [   51.356770] Modules linked in: isofs thunderbolt ccm rfcomm fuse
> cmac snd_hda_codec_hdmi bnep snd_hda_codec_realtek
> snd_hda_codec_generic hid_multitouch joydev arc4 iTCO_wdt
> iTCO_vendor_support nls_iso8859_1 nls_cp437 vfat fat uvcvideo btusb
> btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel
> videobuf2_common ath10k_pci bluetooth ath10k_core videodev mousedev
> i915 intel_rapl ath snd_soc_skl snd_soc_hdac_hda ecdh_generic
> x86_pkg_temp_thermal intel_powerclamp snd_hda_ext_core media crc16
> coretemp snd_soc_skl_ipc mac80211 uas snd_soc_sst_ipc kvm_intel
> snd_soc_sst_dsp snd_soc_acpi_intel_match kvmgt snd_soc_acpi vfio_mdev
> mdev mei_wdt dell_laptop vfio_iommu_type1 dell_wmi wmi_bmof
> snd_soc_core vfio intel_wmi_thunderbolt dell_smbios
> dell_wmi_descriptor snd_compress i2c_algo_bit dcdbas kvm ac97_bus
> snd_pcm_dmaengine drm_kms_helper snd_hda_intel snd_hda_codec cfg80211
> irqbypass intel_cstate intel_uncore snd_hda_core snd_hwdep input_leds
> snd_pcm intel_rapl_perf drm snd_timer
> [   51.356792]  psmouse rtsx_pci_ms pcspkr memstick idma64 rfkill snd
> intel_gtt mei_me processor_thermal_device agpgart intel_soc_dts_iosf
> soundcore mei syscopyarea sysfillrect i2c_i801 sysimgblt fb_sys_fops
> intel_lpss_pci intel_lpss intel_pch_thermal ucsi_acpi tpm_crb
> typec_ucsi wmi typec i2c_hid battery soc_button_array intel_vbtn
> tpm_tis tpm_tis_core tpm int3403_thermal evdev int340x_thermal_zone
> mac_hid intel_hid rng_core ac int3400_thermal acpi_thermal_rel
> sparse_keymap pcc_cpufreq vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE)
> vboxdrv(OE) sg crypto_user ip_tables x_tables btrfs libcrc32c
> crc32c_generic xor raid6_pq algif_skcipher af_alg sd_mod usb_storage
> scsi_mod hid_generic usbhid hid dm_crypt dm_mod crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc mmc_core
> serio_raw atkbd libps2 aesni_intel aes_x86_64 xhci_pci crypto_simd
> cryptd glue_helper xhci_hcd rtsx_pci i8042 serio
> [   51.356817] CPU: 3 PID: 54 Comm: kworker/u8:1 Tainted: G     U
> OE     4.20.6-arch1-1-ARCH #1
> [   51.356817] Hardware name: Dell Inc. XPS 13 9360/0PF86Y, BIOS 2.1.0
> 08/02/2017
> [   51.356830] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btr=
fs]
> [   51.356839] RIP: 0010:__btrfs_free_extent.isra.25+0x61e/0x940 [btrfs]
> [   51.356840] Code: b8 00 00 00 48 8b 7c 24 08 e8 ae 1a ff ff 41 89
> c5 58 c6 44 24 2c 00 45 85 ed 0f 84 f2 fa ff ff 41 83 fd fe 0f 85 e1
> fb ff ff <0f> 0b 49 8b 3c 24 e8 87 32 00 00 49 89 d9 4d 89 f8 4c 89 f1
> ff b4
> [   51.356841] RSP: 0018:ffffacf5c1b37c38 EFLAGS: 00010246
> [   51.356842] RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 000000000=
0000000
> [   51.356842] RDX: 00000000fffffffe RSI: 0000000000000000 RDI: ffff9b03d=
bb6f3b0
> [   51.356843] RBP: 0000005ae1ce8000 R08: 0000000000000000 R09: 000000000=
000009b
> [   51.356844] R10: 000000000000003c R11: 0000000000000000 R12: ffff9b03d=
a498ee0
> [   51.356844] R13: 00000000fffffffe R14: 0000000000000000 R15: 000000000=
0000002
> [   51.356845] FS:  0000000000000000(0000) GS:ffff9b04ae380000(0000)
> knlGS:0000000000000000
> [   51.356846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.356847] CR2: 00007f252cd16af0 CR3: 000000020140a006 CR4: 000000000=
03606e0
> [   51.356847] Call Trace:
> [   51.356854]  ? _raw_spin_lock+0x13/0x30
> [   51.356855]  ? _raw_spin_unlock+0x16/0x30
> [   51.356866]  ? btrfs_merge_delayed_refs+0x315/0x350 [btrfs]
> [   51.356875]  __btrfs_run_delayed_refs+0x6f2/0x10e0 [btrfs]
> [   51.356879]  ? preempt_count_add+0x79/0xb0
> [   51.356887]  btrfs_run_delayed_refs+0x64/0x180 [btrfs]
> [   51.356895]  delayed_ref_async_start+0x81/0x90 [btrfs]
> [   51.356906]  normal_work_helper+0xbd/0x350 [btrfs]
> [   51.356909]  process_one_work+0x1eb/0x410
> [   51.356911]  worker_thread+0x2d/0x3d0
> [   51.356913]  ? process_one_work+0x410/0x410
> [   51.356914]  kthread+0x112/0x130
> [   51.356916]  ? kthread_park+0x80/0x80
> [   51.356917]  ret_from_fork+0x35/0x40
> [   51.356919] ---[ end trace 0be7e900e0369795 ]---
> [   51.356921] BTRFS info (device dm-0): leaf 88151867392 gen 554573
> total ptrs 207 free space 4277 owner 2
> [   51.356922] item 0 key (390330466304 169 0) itemoff 16250 itemsize 33
> [   51.356923] extent refs 1 gen 548992 flags 2
> [   51.356924] ref#0: tree block backref root 7
> [   51.356925] item 1 key (390330597376 169 0) itemoff 16217 itemsize 33
> [   51.356926] extent refs 1 gen 554161 flags 2
> [   51.356926] ref#0: tree block backref root 7
> [   51.356927] item 2 key (390330761216 169 0) itemoff 16184 itemsize 33
> [   51.356927] extent refs 1 gen 475169 flags 2
> [   51.356928] ref#0: tree block backref root 257
> [   51.356929] item 3 key (390330892288 169 0) itemoff 16151 itemsize 33
> [   51.356929] extent refs 1 gen 475169 flags 2
> [   51.356929] ref#0: tree block backref root 257
> [   51.356930] item 4 key (390330925056 169 0) itemoff 16118 itemsize 33
> [   51.356931] extent refs 1 gen 554472 flags 2
> [   51.356931] ref#0: tree block backref root 7
> [   51.356932] item 5 key (390330990592 169 0) itemoff 16085 itemsize 33
> [   51.356933] extent refs 1 gen 554161 flags 2
> [   51.356933] ref#0: tree block backref root 258
> [   51.356934] item 6 key (390331006976 169 0) itemoff 16052 itemsize 33
> [   51.356934] extent refs 1 gen 475169 flags 2
> [   51.356935] ref#0: tree block backref root 257
> [   51.356936] item 7 key (390331023360 169 0) itemoff 16019 itemsize 33
> [   51.356936] extent refs 1 gen 554472 flags 2
> [   51.356936] ref#0: tree block backref root 7
> [   51.356937] item 8 key (390331056128 169 0) itemoff 15986 itemsize 33
> [   51.356938] extent refs 1 gen 554161 flags 2
> [   51.356938] ref#0: tree block backref root 7
> [   51.356939] item 9 key (390331121664 169 0) itemoff 15953 itemsize 33
> [   51.356940] extent refs 1 gen 554161 flags 2
> [   51.356940] ref#0: tree block backref root 7
> [   51.356941] item 10 key (390331170816 169 0) itemoff 15920 itemsize 33
> [   51.356941] extent refs 1 gen 554472 flags 2
> [   51.356942] ref#0: tree block backref root 258
> [   51.356943] item 11 key (390331269120 169 0) itemoff 15887 itemsize 33
> [   51.356943] extent refs 1 gen 475169 flags 2
> [   51.356943] ref#0: tree block backref root 257
> [   51.356944] item 12 key (390331301888 169 0) itemoff 15854 itemsize 33
> [   51.356945] extent refs 1 gen 554472 flags 2
> [   51.356945] ref#0: tree block backref root 7
> [   51.356946] item 13 key (390331449344 169 0) itemoff 15821 itemsize 33
> [   51.356947] extent refs 1 gen 554161 flags 2
> [   51.356947] ref#0: tree block backref root 7
> [   51.356948] item 14 key (390331465728 169 0) itemoff 15788 itemsize 33
> [   51.356948] extent refs 1 gen 475169 flags 2
> [   51.356949] ref#0: tree block backref root 257
> [   51.356950] item 15 key (390331531264 169 0) itemoff 15755 itemsize 33
> [   51.356950] extent refs 1 gen 475169 flags 2
> [   51.356950] ref#0: tree block backref root 257
> [   51.356951] item 16 key (390331613184 169 0) itemoff 15722 itemsize 33
> [   51.356952] extent refs 1 gen 475169 flags 2
> [   51.356952] ref#0: tree block backref root 257
> [   51.356953] item 17 key (390332727296 169 0) itemoff 15689 itemsize 33
> [   51.356954] extent refs 1 gen 554161 flags 2
> [   51.356954] ref#0: tree block backref root 7
> [   51.356955] item 18 key (390332907520 169 0) itemoff 15656 itemsize 33
> [   51.356955] extent refs 1 gen 554161 flags 2
> [   51.356956] ref#0: tree block backref root 7
> [   51.356956] item 19 key (390332923904 169 0) itemoff 15623 itemsize 33
> [   51.356957] extent refs 1 gen 554472 flags 2
> [   51.356957] ref#0: tree block backref root 2
> [   51.356958] item 20 key (390333005824 169 0) itemoff 15590 itemsize 33
> [   51.356959] extent refs 1 gen 554472 flags 2
> [   51.356959] ref#0: tree block backref root 2
> [   51.356960] item 21 key (390333169664 169 0) itemoff 15557 itemsize 33
> [   51.356960] extent refs 1 gen 554472 flags 2
> [   51.356961] ref#0: tree block backref root 2
> [   51.356962] item 22 key (390333235200 169 0) itemoff 15524 itemsize 33
> [   51.356962] extent refs 1 gen 554472 flags 2
> [   51.356962] ref#0: tree block backref root 2
> [   51.356963] item 23 key (390333267968 169 0) itemoff 15491 itemsize 33
> [   51.356964] extent refs 1 gen 554472 flags 2
> [   51.356964] ref#0: tree block backref root 2
> [   51.356965] item 24 key (390333284352 169 0) itemoff 15458 itemsize 33
> [   51.356966] extent refs 1 gen 554472 flags 2
> [   51.356966] ref#0: tree block backref root 2
> [   51.356967] item 25 key (390333349888 169 0) itemoff 15425 itemsize 33
> [   51.356967] extent refs 1 gen 554472 flags 2
> [   51.356968] ref#0: tree block backref root 2
> [   51.356968] item 26 key (390333382656 169 0) itemoff 15392 itemsize 33
> [   51.356969] extent refs 1 gen 554472 flags 2
> [   51.356969] ref#0: tree block backref root 2
> [   51.356970] item 27 key (390333399040 169 0) itemoff 15359 itemsize 33
> [   51.356971] extent refs 1 gen 554472 flags 2
> [   51.356971] ref#0: tree block backref root 2
> [   51.356972] item 28 key (390333480960 169 0) itemoff 15326 itemsize 33
> [   51.356972] extent refs 1 gen 554285 flags 2
> [   51.356973] ref#0: tree block backref root 258
> [   51.356974] item 29 key (390333497344 169 0) itemoff 15293 itemsize 33
> [   51.356974] extent refs 1 gen 554285 flags 2
> [   51.356974] ref#0: tree block backref root 258
> [   51.356975] item 30 key (390333530112 169 0) itemoff 15260 itemsize 33
> [   51.356976] extent refs 1 gen 554161 flags 2
> [   51.356976] ref#0: tree block backref root 2
> [   51.356977] item 31 key (390333562880 169 0) itemoff 15227 itemsize 33
> [   51.356978] extent refs 1 gen 554472 flags 2
> [   51.356978] ref#0: tree block backref root 2
> [   51.356979] item 32 key (390333579264 169 0) itemoff 15194 itemsize 33
> [   51.356979] extent refs 1 gen 554472 flags 2
> [   51.356980] ref#0: tree block backref root 2
> [   51.356981] item 33 key (390333661184 169 0) itemoff 15161 itemsize 33
> [   51.356981] extent refs 1 gen 554472 flags 2
> [   51.356981] ref#0: tree block backref root 2
> [   51.356982] item 34 key (390333677568 169 0) itemoff 15128 itemsize 33
> [   51.356983] extent refs 1 gen 554472 flags 2
> [   51.356983] ref#0: tree block backref root 2
> [   51.356984] item 35 key (390333726720 169 0) itemoff 15095 itemsize 33
> [   51.356984] extent refs 1 gen 554472 flags 2
> [   51.356985] ref#0: tree block backref root 2
> [   51.356986] item 36 key (390333743104 169 0) itemoff 15062 itemsize 33
> [   51.356986] extent refs 1 gen 554472 flags 2
> [   51.356987] ref#0: tree block backref root 2
> [   51.356987] item 37 key (390333759488 169 0) itemoff 15029 itemsize 33
> [   51.356988] extent refs 1 gen 554472 flags 2
> [   51.356988] ref#0: tree block backref root 2
> [   51.356989] item 38 key (390333775872 169 0) itemoff 14996 itemsize 33
> [   51.356990] extent refs 1 gen 554472 flags 2
> [   51.356990] ref#0: tree block backref root 2
> [   51.356991] item 39 key (390333792256 169 0) itemoff 14963 itemsize 33
> [   51.356991] extent refs 1 gen 554285 flags 2
> [   51.356992] ref#0: tree block backref root 258
> [   51.356993] item 40 key (390333808640 169 0) itemoff 14930 itemsize 33
> [   51.356993] extent refs 1 gen 554285 flags 2
> [   51.356993] ref#0: tree block backref root 7
> [   51.356994] item 41 key (390333825024 169 0) itemoff 14897 itemsize 33
> [   51.356995] extent refs 1 gen 554285 flags 2
> [   51.356995] ref#0: tree block backref root 258
> [   51.356996] item 42 key (390333841408 169 0) itemoff 14864 itemsize 33
> [   51.356997] extent refs 1 gen 554285 flags 2
> [   51.356997] ref#0: tree block backref root 258
> [   51.356998] item 43 key (390333874176 169 0) itemoff 14831 itemsize 33
> [   51.356998] extent refs 1 gen 554472 flags 2
> [   51.356999] ref#0: tree block backref root 2
> [   51.357000] item 44 key (390333890560 169 0) itemoff 14798 itemsize 33
> [   51.357000] extent refs 1 gen 554472 flags 2
> [   51.357000] ref#0: tree block backref root 2
> [   51.357001] item 45 key (390333988864 169 0) itemoff 14765 itemsize 33
> [   51.357002] extent refs 1 gen 554161 flags 2
> [   51.357002] ref#0: tree block backref root 2
> [   51.357003] item 46 key (390334021632 169 0) itemoff 14732 itemsize 33
> [   51.357004] extent refs 1 gen 554161 flags 2
> [   51.357004] ref#0: tree block backref root 2
> [   51.357005] item 47 key (390334070784 169 0) itemoff 14699 itemsize 33
> [   51.357005] extent refs 1 gen 554472 flags 2
> [   51.357006] ref#0: tree block backref root 2
> [   51.357006] item 48 key (390334152704 169 0) itemoff 14666 itemsize 33
> [   51.357007] extent refs 1 gen 554285 flags 2
> [   51.357007] ref#0: tree block backref root 7
> [   51.357008] item 49 key (390334169088 169 0) itemoff 14633 itemsize 33
> [   51.357009] extent refs 1 gen 554285 flags 2
> [   51.357009] ref#0: tree block backref root 258
> [   51.357010] item 50 key (390334267392 169 0) itemoff 14600 itemsize 33
> [   51.357010] extent refs 1 gen 554472 flags 2
> [   51.357011] ref#0: tree block backref root 2
> [   51.357012] item 51 key (390334414848 169 0) itemoff 14567 itemsize 33
> [   51.357012] extent refs 1 gen 553440 flags 2
> [   51.357012] ref#0: tree block backref root 258
> [   51.357013] item 52 key (390334545920 169 0) itemoff 14534 itemsize 33
> [   51.357014] extent refs 1 gen 554472 flags 2
> [   51.357014] ref#0: tree block backref root 2
> [   51.357015] item 53 key (390334611456 169 0) itemoff 14501 itemsize 33
> [   51.357016] extent refs 1 gen 554285 flags 2
> [   51.357016] ref#0: tree block backref root 258
> [   51.357017] item 54 key (390334758912 169 0) itemoff 14468 itemsize 33
> [   51.357017] extent refs 1 gen 554472 flags 2
> [   51.357018] ref#0: tree block backref root 2
> [   51.357019] item 55 key (390334857216 169 0) itemoff 14435 itemsize 33
> [   51.357019] extent refs 1 gen 475169 flags 2
> [   51.357019] ref#0: tree block backref root 257
> [   51.357020] item 56 key (390334889984 169 0) itemoff 14402 itemsize 33
> [   51.357021] extent refs 1 gen 475169 flags 2
> [   51.357021] ref#0: tree block backref root 257
> [   51.357022] item 57 key (390335152128 169 0) itemoff 14369 itemsize 33
> [   51.357022] extent refs 1 gen 554472 flags 2
> [   51.357023] ref#0: tree block backref root 2
> [   51.357024] item 58 key (390335447040 169 0) itemoff 14336 itemsize 33
> [   51.357024] extent refs 1 gen 554472 flags 2
> [   51.357024] ref#0: tree block backref root 2
> [   51.357025] item 59 key (390335463424 169 8388608) itemoff 14303 items=
ize 33
> [   51.357026] extent refs 1 gen 554472 flags 2
> [   51.357026] ref#0: tree block backref root 2
> [   51.357027] item 60 key (390336692224 169 0) itemoff 14270 itemsize 33
> [   51.357028] extent refs 1 gen 553440 flags 2
> [   51.357028] ref#0: tree block backref root 258
> [   51.357029] item 61 key (390337609728 169 0) itemoff 14237 itemsize 33
> [   51.357029] extent refs 1 gen 553172 flags 2
> [   51.357030] ref#0: tree block backref root 258
> [   51.357031] item 62 key (390337855488 169 0) itemoff 14204 itemsize 33
> [   51.357031] extent refs 1 gen 478479 flags 2
> [   51.357031] ref#0: tree block backref root 259
> [   51.357032] item 63 key (390338117632 169 0) itemoff 14171 itemsize 33
> [   51.357033] extent refs 1 gen 554161 flags 2
> [   51.357033] ref#0: tree block backref root 2
> [   51.357034] item 64 key (390338150400 169 0) itemoff 14138 itemsize 33
> [   51.357035] extent refs 1 gen 554161 flags 2
> [   51.357035] ref#0: tree block backref root 2
> [   51.357036] item 65 key (390338314240 169 0) itemoff 14105 itemsize 33
> [   51.357036] extent refs 1 gen 554161 flags 2
> [   51.357037] ref#0: tree block backref root 2
> [   51.357038] item 66 key (390338772992 169 0) itemoff 14072 itemsize 33
> [   51.357038] extent refs 1 gen 554161 flags 2
> [   51.357038] ref#0: tree block backref root 2
> [   51.357039] item 67 key (390338805760 169 0) itemoff 14039 itemsize 33
> [   51.357040] extent refs 1 gen 554161 flags 2
> [   51.357040] ref#0: tree block backref root 2
> [   51.357041] item 68 key (390338822144 169 0) itemoff 14006 itemsize 33
> [   51.357042] extent refs 1 gen 554161 flags 2
> [   51.357042] ref#0: tree block backref root 7
> [   51.357043] item 69 key (390338854912 169 0) itemoff 13973 itemsize 33
> [   51.357043] extent refs 1 gen 554161 flags 2
> [   51.357044] ref#0: tree block backref root 2
> [   51.357044] item 70 key (390338920448 169 0) itemoff 13940 itemsize 33
> [   51.357045] extent refs 1 gen 554161 flags 2
> [   51.357045] ref#0: tree block backref root 2
> [   51.357046] item 71 key (390339198976 169 0) itemoff 13907 itemsize 33
> [   51.357047] extent refs 1 gen 554161 flags 2
> [   51.357047] ref#0: tree block backref root 2
> [   51.357048] item 72 key (390339346432 169 0) itemoff 13874 itemsize 33
> [   51.357048] extent refs 1 gen 553135 flags 2
> [   51.357049] ref#0: tree block backref root 258
> [   51.357050] item 73 key (390339461120 169 0) itemoff 13841 itemsize 33
> [   51.357050] extent refs 1 gen 553776 flags 2
> [   51.357050] ref#0: tree block backref root 2
> [   51.357051] item 74 key (390339608576 169 0) itemoff 13808 itemsize 33
> [   51.357052] extent refs 1 gen 554161 flags 2
> [   51.357052] ref#0: tree block backref root 2
> [   51.357053] item 75 key (390339706880 169 0) itemoff 13775 itemsize 33
> [   51.357054] extent refs 1 gen 554161 flags 2
> [   51.357054] ref#0: tree block backref root 2
> [   51.357055] item 76 key (390339723264 169 0) itemoff 13742 itemsize 33
> [   51.357055] extent refs 1 gen 551243 flags 2
> [   51.357056] ref#0: tree block backref root 259
> [   51.357057] item 77 key (390339739648 169 0) itemoff 13709 itemsize 33
> [   51.357057] extent refs 1 gen 554161 flags 2
> [   51.357057] ref#0: tree block backref root 2
> [   51.357058] item 78 key (390339756032 169 0) itemoff 13676 itemsize 33
> [   51.357059] extent refs 1 gen 553135 flags 2
> [   51.357059] ref#0: tree block backref root 258
> [   51.357060] item 79 key (390339805184 169 0) itemoff 13643 itemsize 33
> [   51.357061] extent refs 1 gen 553135 flags 2
> [   51.357061] ref#0: tree block backref root 258
> [   51.357062] item 80 key (390339870720 169 0) itemoff 13610 itemsize 33
> [   51.357062] extent refs 1 gen 553135 flags 2
> [   51.357063] ref#0: tree block backref root 258
> [   51.357063] item 81 key (390339919872 169 0) itemoff 13577 itemsize 33
> [   51.357064] extent refs 1 gen 554161 flags 2
> [   51.357064] ref#0: tree block backref root 2
> [   51.357065] item 82 key (390339936256 169 0) itemoff 13544 itemsize 33
> [   51.357066] extent refs 1 gen 554161 flags 2
> [   51.357066] ref#0: tree block backref root 2
> [   51.357067] item 83 key (390339985408 169 0) itemoff 13511 itemsize 33
> [   51.357067] extent refs 1 gen 554161 flags 2
> [   51.357068] ref#0: tree block backref root 2
> [   51.357069] item 84 key (390340001792 169 0) itemoff 13478 itemsize 33
> [   51.357069] extent refs 1 gen 553135 flags 2
> [   51.357069] ref#0: tree block backref root 258
> [   51.357070] item 85 key (390340132864 169 0) itemoff 13445 itemsize 33
> [   51.357071] extent refs 1 gen 553135 flags 2
> [   51.357071] ref#0: tree block backref root 258
> [   51.357072] item 86 key (390340427776 169 0) itemoff 13412 itemsize 33
> [   51.357073] extent refs 1 gen 554161 flags 2
> [   51.357073] ref#0: tree block backref root 2
> [   51.357074] item 87 key (390340460544 169 0) itemoff 13379 itemsize 33
> [   51.357074] extent refs 1 gen 554161 flags 2
> [   51.357075] ref#0: tree block backref root 2
> [   51.357076] item 88 key (390340509696 169 0) itemoff 13346 itemsize 33
> [   51.357076] extent refs 1 gen 554161 flags 2
> [   51.357076] ref#0: tree block backref root 2
> [   51.357077] item 89 key (390340591616 169 0) itemoff 13313 itemsize 33
> [   51.357078] extent refs 1 gen 554161 flags 2
> [   51.357078] ref#0: tree block backref root 2
> [   51.357079] item 90 key (390340608000 169 0) itemoff 13280 itemsize 33
> [   51.357079] extent refs 1 gen 554161 flags 2
> [   51.357080] ref#0: tree block backref root 2
> [   51.357081] item 91 key (390340673536 169 0) itemoff 13247 itemsize 33
> [   51.357081] extent refs 1 gen 554161 flags 2
> [   51.357081] ref#0: tree block backref root 2
> [   51.357082] item 92 key (390340706304 169 0) itemoff 13214 itemsize 33
> [   51.357083] extent refs 1 gen 554161 flags 2
> [   51.357083] ref#0: tree block backref root 2
> [   51.357084] item 93 key (390340837376 169 0) itemoff 13181 itemsize 33
> [   51.357085] extent refs 1 gen 532212 flags 2
> [   51.357085] ref#0: tree block backref root 258
> [   51.357086] item 94 key (390341132288 169 0) itemoff 13148 itemsize 33
> [   51.357086] extent refs 1 gen 553135 flags 2
> [   51.357087] ref#0: tree block backref root 7
> [   51.357088] item 95 key (390341197824 169 0) itemoff 13115 itemsize 33
> [   51.357088] extent refs 1 gen 554161 flags 2
> [   51.357088] ref#0: tree block backref root 2
> [   51.357089] item 96 key (390341804032 169 0) itemoff 13082 itemsize 33
> [   51.357090] extent refs 1 gen 554161 flags 2
> [   51.357090] ref#0: tree block backref root 2
> [   51.357091] item 97 key (390341820416 169 0) itemoff 13049 itemsize 33
> [   51.357091] extent refs 1 gen 554161 flags 2
> [   51.357092] ref#0: tree block backref root 7
> [   51.357093] item 98 key (390342131712 169 0) itemoff 13016 itemsize 33
> [   51.357093] extent refs 1 gen 554161 flags 2
> [   51.357093] ref#0: tree block backref root 2
> [   51.357094] item 99 key (390342459392 169 0) itemoff 12983 itemsize 33
> [   51.357095] extent refs 1 gen 554472 flags 2
> [   51.357095] ref#0: tree block backref root 2
> [   51.357096] item 100 key (390342672384 169 0) itemoff 12950 itemsize 3=
3
> [   51.357097] extent refs 1 gen 554161 flags 2
> [   51.357097] ref#0: tree block backref root 2
> [   51.357098] item 101 key (390343458816 169 0) itemoff 12917 itemsize 3=
3
> [   51.357098] extent refs 1 gen 554161 flags 2
> [   51.357099] ref#0: tree block backref root 2
> [   51.357100] item 102 key (390343507968 169 0) itemoff 12884 itemsize 3=
3
> [   51.357100] extent refs 1 gen 554161 flags 2
> [   51.357100] ref#0: tree block backref root 2
> [   51.357101] item 103 key (390343704576 169 0) itemoff 12851 itemsize 3=
3
> [   51.357102] extent refs 1 gen 553135 flags 2
> [   51.357102] ref#0: tree block backref root 258
> [   51.357103] item 104 key (390343720960 169 0) itemoff 12818 itemsize 3=
3
> [   51.357104] extent refs 1 gen 482485 flags 2
> [   51.357104] ref#0: tree block backref root 258
> [   51.357105] item 105 key (390344163328 169 0) itemoff 12785 itemsize 3=
3
> [   51.357105] extent refs 1 gen 554161 flags 2
> [   51.357106] ref#0: tree block backref root 2
> [   51.357107] item 106 key (390344605696 169 0) itemoff 12752 itemsize 3=
3
> [   51.357107] extent refs 1 gen 554161 flags 2
> [   51.357107] ref#0: tree block backref root 2
> [   51.357108] item 107 key (390345326592 169 0) itemoff 12719 itemsize 3=
3
> [   51.357109] extent refs 1 gen 552553 flags 2
> [   51.357109] ref#0: tree block backref root 7
> [   51.357110] item 108 key (390345457664 169 0) itemoff 12686 itemsize 3=
3
> [   51.357111] extent refs 1 gen 554161 flags 2
> [   51.357111] ref#0: tree block backref root 2
> [   51.357112] item 109 key (390345801728 169 0) itemoff 12653 itemsize 3=
3
> [   51.357112] extent refs 1 gen 554161 flags 2
> [   51.357113] ref#0: tree block backref root 2
> [   51.357113] item 110 key (390345818112 169 0) itemoff 12620 itemsize 3=
3
> [   51.357114] extent refs 1 gen 554161 flags 2
> [   51.357114] ref#0: tree block backref root 2
> [   51.357115] item 111 key (390345850880 169 0) itemoff 12587 itemsize 3=
3
> [   51.357116] extent refs 1 gen 554161 flags 2
> [   51.357116] ref#0: tree block backref root 2
> [   51.357117] item 112 key (390345949184 169 0) itemoff 12554 itemsize 3=
3
> [   51.357117] extent refs 1 gen 492593 flags 2
> [   51.357118] ref#0: tree block backref root 258
> [   51.357119] item 113 key (390346309632 169 0) itemoff 12521 itemsize 3=
3
> [   51.357119] extent refs 1 gen 554161 flags 2
> [   51.357119] ref#0: tree block backref root 2
> [   51.357120] item 114 key (390346326016 169 0) itemoff 12488 itemsize 3=
3
> [   51.357121] extent refs 1 gen 554161 flags 2
> [   51.357121] ref#0: tree block backref root 7
> [   51.357122] item 115 key (390346457088 169 0) itemoff 12455 itemsize 3=
3
> [   51.357123] extent refs 1 gen 554161 flags 2
> [   51.357123] ref#0: tree block backref root 2
> [   51.357124] item 116 key (390346588160 169 0) itemoff 12422 itemsize 3=
3
> [   51.357124] extent refs 1 gen 532212 flags 2
> [   51.357125] ref#0: tree block backref root 7
> [   51.357125] item 117 key (390346604544 169 0) itemoff 12389 itemsize 3=
3
> [   51.357126] extent refs 1 gen 554161 flags 2
> [   51.357126] ref#0: tree block backref root 2
> [   51.357127] item 118 key (390346948608 169 0) itemoff 12356 itemsize 3=
3
> [   51.357128] extent refs 1 gen 554161 flags 2
> [   51.357128] ref#0: tree block backref root 2
> [   51.357129] item 119 key (390347030528 169 0) itemoff 12323 itemsize 3=
3
> [   51.357129] extent refs 1 gen 554161 flags 2
> [   51.357130] ref#0: tree block backref root 2
> [   51.357131] item 120 key (390347538432 169 0) itemoff 12290 itemsize 3=
3
> [   51.357131] extent refs 1 gen 552553 flags 2
> [   51.357131] ref#0: tree block backref root 2
> [   51.357132] item 121 key (390347964416 169 0) itemoff 12257 itemsize 3=
3
> [   51.357133] extent refs 1 gen 552553 flags 2
> [   51.357133] ref#0: tree block backref root 2
> [   51.357134] item 122 key (390348570624 169 0) itemoff 12224 itemsize 3=
3
> [   51.357135] extent refs 1 gen 535248 flags 2
> [   51.357135] ref#0: tree block backref root 2
> [   51.357136] item 123 key (390348619776 169 0) itemoff 12191 itemsize 3=
3
> [   51.357136] extent refs 1 gen 535248 flags 2
> [   51.357137] ref#0: tree block backref root 7
> [   51.357138] item 124 key (390348914688 169 0) itemoff 12158 itemsize 3=
3
> [   51.357138] extent refs 1 gen 552553 flags 2
> [   51.357138] ref#0: tree block backref root 2
> [   51.357139] item 125 key (390348980224 169 0) itemoff 12125 itemsize 3=
3
> [   51.357140] extent refs 1 gen 554474 flags 2
> [   51.357140] ref#0: tree block backref root 7
> [   51.357141] item 126 key (390349389824 169 0) itemoff 12092 itemsize 3=
3
> [   51.357142] extent refs 1 gen 553135 flags 2
> [   51.357142] ref#0: tree block backref root 258
> [   51.357143] item 127 key (390349619200 169 0) itemoff 12059 itemsize 3=
3
> [   51.357143] extent refs 1 gen 548994 flags 2
> [   51.357144] ref#0: tree block backref root 258
> [   51.357145] item 128 key (390349684736 169 0) itemoff 12026 itemsize 3=
3
> [   51.357145] extent refs 1 gen 553135 flags 2
> [   51.357145] ref#0: tree block backref root 258
> [   51.357146] item 129 key (390350077952 169 0) itemoff 11993 itemsize 3=
3
> [   51.357147] extent refs 1 gen 554474 flags 2
> [   51.357147] ref#0: tree block backref root 7
> [   51.357148] item 130 key (390350290944 169 0) itemoff 11960 itemsize 3=
3
> [   51.357148] extent refs 1 gen 554474 flags 2
> [   51.357149] ref#0: tree block backref root 258
> [   51.357150] item 131 key (390350307328 169 0) itemoff 11927 itemsize 3=
3
> [   51.357150] extent refs 1 gen 554474 flags 2
> [   51.357150] ref#0: tree block backref root 258
> [   51.357151] item 132 key (390350340096 169 0) itemoff 11894 itemsize 3=
3
> [   51.357152] extent refs 1 gen 554161 flags 2
> [   51.357152] ref#0: tree block backref root 2
> [   51.357153] item 133 key (390350372864 169 0) itemoff 11861 itemsize 3=
3
> [   51.357154] extent refs 1 gen 554161 flags 2
> [   51.357154] ref#0: tree block backref root 2
> [   51.357155] item 134 key (390350569472 169 0) itemoff 11828 itemsize 3=
3
> [   51.357155] extent refs 1 gen 554474 flags 2
> [   51.357156] ref#0: tree block backref root 2
> [   51.357157] item 135 key (390350585856 169 0) itemoff 11795 itemsize 3=
3
> [   51.357157] extent refs 1 gen 554474 flags 2
> [   51.357157] ref#0: tree block backref root 2
> [   51.357158] item 136 key (390350635008 169 0) itemoff 11762 itemsize 3=
3
> [   51.357159] extent refs 1 gen 554474 flags 2
> [   51.357159] ref#0: tree block backref root 2
> [   51.357160] item 137 key (390350700544 169 0) itemoff 11729 itemsize 3=
3
> [   51.357161] extent refs 1 gen 554474 flags 2
> [   51.357161] ref#0: tree block backref root 2
> [   51.357162] item 138 key (390350766080 169 0) itemoff 11696 itemsize 3=
3
> [   51.357162] extent refs 1 gen 554474 flags 2
> [   51.357163] ref#0: tree block backref root 2
> [   51.357164] item 139 key (390350913536 169 0) itemoff 11663 itemsize 3=
3
> [   51.357164] extent refs 1 gen 554474 flags 2
> [   51.357164] ref#0: tree block backref root 2
> [   51.357165] item 140 key (390350946304 169 0) itemoff 11630 itemsize 3=
3
> [   51.357166] extent refs 1 gen 554474 flags 2
> [   51.357166] ref#0: tree block backref root 2
> [   51.357167] item 141 key (390351142912 169 0) itemoff 11597 itemsize 3=
3
> [   51.357167] extent refs 1 gen 548385 flags 2
> [   51.357168] ref#0: tree block backref root 258
> [   51.357169] item 142 key (390351159296 169 0) itemoff 11564 itemsize 3=
3
> [   51.357169] extent refs 1 gen 554474 flags 2
> [   51.357169] ref#0: tree block backref root 2
> [   51.357170] item 143 key (390351257600 169 0) itemoff 11531 itemsize 3=
3
> [   51.357171] extent refs 1 gen 554285 flags 2
> [   51.357171] ref#0: tree block backref root 258
> [   51.357172] item 144 key (390351323136 169 0) itemoff 11498 itemsize 3=
3
> [   51.357173] extent refs 1 gen 548385 flags 2
> [   51.357173] ref#0: tree block backref root 257
> [   51.357174] item 145 key (390351454208 169 0) itemoff 11465 itemsize 3=
3
> [   51.357174] extent refs 1 gen 554285 flags 2
> [   51.357175] ref#0: tree block backref root 7
> [   51.357176] item 146 key (390351634432 169 0) itemoff 11432 itemsize 3=
3
> [   51.357176] extent refs 1 gen 554285 flags 2
> [   51.357176] ref#0: tree block backref root 7
> [   51.357177] item 147 key (390351962112 169 0) itemoff 11399 itemsize 3=
3
> [   51.357178] extent refs 1 gen 554474 flags 2
> [   51.357178] ref#0: tree block backref root 2
> [   51.357179] item 148 key (390352240640 169 0) itemoff 11366 itemsize 3=
3
> [   51.357180] extent refs 1 gen 554474 flags 2
> [   51.357180] ref#0: tree block backref root 2
> [   51.357181] item 149 key (390352830464 169 0) itemoff 11333 itemsize 3=
3
> [   51.357181] extent refs 1 gen 512584 flags 2
> [   51.357182] ref#0: tree block backref root 7
> [   51.357182] item 150 key (390352977920 169 0) itemoff 11300 itemsize 3=
3
> [   51.357183] extent refs 1 gen 548685 flags 2
> [   51.357183] ref#0: tree block backref root 2
> [   51.357184] item 151 key (390353043456 169 0) itemoff 11267 itemsize 3=
3
> [   51.357185] extent refs 1 gen 548685 flags 2
> [   51.357185] ref#0: tree block backref root 2
> [   51.357186] item 152 key (390353141760 169 0) itemoff 11234 itemsize 3=
3
> [   51.357186] extent refs 1 gen 519476 flags 2
> [   51.357187] ref#0: tree block backref root 258
> [   51.357188] item 153 key (390353305600 169 0) itemoff 11201 itemsize 3=
3
> [   51.357188] extent refs 1 gen 551722 flags 2
> [   51.357188] ref#0: tree block backref root 258
> [   51.357189] item 154 key (390353371136 169 0) itemoff 11168 itemsize 3=
3
> [   51.357190] extent refs 1 gen 551722 flags 2
> [   51.357190] ref#0: tree block backref root 258
> [   51.357191] item 155 key (390353698816 169 0) itemoff 11135 itemsize 3=
3
> [   51.357192] extent refs 1 gen 482485 flags 2
> [   51.357192] ref#0: tree block backref root 258
> [   51.357193] item 156 key (390353731584 169 0) itemoff 11102 itemsize 3=
3
> [   51.357193] extent refs 1 gen 535583 flags 2
> [   51.357194] ref#0: tree block backref root 258
> [   51.357195] item 157 key (390354452480 169 0) itemoff 11069 itemsize 3=
3
> [   51.357195] extent refs 1 gen 548685 flags 2
> [   51.357195] ref#0: tree block backref root 2
> [   51.357196] item 158 key (390354501632 169 0) itemoff 11036 itemsize 3=
3
> [   51.357197] extent refs 1 gen 482485 flags 2
> [   51.357197] ref#0: tree block backref root 258
> [   51.357198] item 159 key (390354665472 169 0) itemoff 11003 itemsize 3=
3
> [   51.357199] extent refs 1 gen 528874 flags 2
> [   51.357199] ref#0: tree block backref root 2
> [   51.357200] item 160 key (390355271680 169 0) itemoff 10970 itemsize 3=
3
> [   51.357200] extent refs 1 gen 554285 flags 2
> [   51.357201] ref#0: tree block backref root 258
> [   51.357202] item 161 key (390355288064 169 0) itemoff 10937 itemsize 3=
3
> [   51.357202] extent refs 1 gen 551496 flags 2
> [   51.357202] ref#0: tree block backref root 2
> [   51.357203] item 162 key (390355369984 169 0) itemoff 10904 itemsize 3=
3
> [   51.357204] extent refs 1 gen 554285 flags 2
> [   51.357204] ref#0: tree block backref root 258
> [   51.357205] item 163 key (390355828736 169 0) itemoff 10871 itemsize 3=
3
> [   51.357206] extent refs 1 gen 507061 flags 2
> [   51.357206] ref#0: tree block backref root 258
> [   51.357207] item 164 key (390356598784 169 0) itemoff 10838 itemsize 3=
3
> [   51.357207] extent refs 1 gen 546118 flags 2
> [   51.357208] ref#0: tree block backref root 258
> [   51.357209] item 165 key (390356631552 169 0) itemoff 10805 itemsize 3=
3
> [   51.357209] extent refs 1 gen 507061 flags 2
> [   51.357209] ref#0: tree block backref root 258
> [   51.357210] item 166 key (390356647936 169 0) itemoff 10772 itemsize 3=
3
> [   51.357211] extent refs 1 gen 507061 flags 2
> [   51.357211] ref#0: tree block backref root 258
> [   51.357212] item 167 key (390356729856 169 0) itemoff 10739 itemsize 3=
3
> [   51.357212] extent refs 1 gen 553440 flags 2
> [   51.357213] ref#0: tree block backref root 7
> [   51.357214] item 168 key (390356779008 169 0) itemoff 10706 itemsize 3=
3
> [   51.357214] extent refs 1 gen 507061 flags 2
> [   51.357215] ref#0: tree block backref root 258
> [   51.357215] item 169 key (390357172224 169 0) itemoff 10673 itemsize 3=
3
> [   51.357216] extent refs 1 gen 478480 flags 2
> [   51.357216] ref#0: tree block backref root 259
> [   51.357217] item 170 key (390357237760 169 0) itemoff 10640 itemsize 3=
3
> [   51.357218] extent refs 1 gen 553440 flags 2
> [   51.357218] ref#0: tree block backref root 258
> [   51.357219] item 171 key (390357368832 169 0) itemoff 10607 itemsize 3=
3
> [   51.357219] extent refs 1 gen 553440 flags 2
> [   51.357220] ref#0: tree block backref root 7
> [   51.357221] item 172 key (390357499904 169 0) itemoff 10574 itemsize 3=
3
> [   51.357221] extent refs 1 gen 553440 flags 2
> [   51.357221] ref#0: tree block backref root 7
> [   51.357222] item 173 key (390357696512 169 0) itemoff 10541 itemsize 3=
3
> [   51.357223] extent refs 1 gen 553440 flags 2
> [   51.357223] ref#0: tree block backref root 7
> [   51.357224] item 174 key (390357712896 169 0) itemoff 10508 itemsize 3=
3
> [   51.357225] extent refs 1 gen 535248 flags 2
> [   51.357225] ref#0: tree block backref root 7
> [   51.357226] item 175 key (390357827584 169 0) itemoff 10475 itemsize 3=
3
> [   51.357226] extent refs 1 gen 553777 flags 2
> [   51.357227] ref#0: tree block backref root 258
> [   51.357228] item 176 key (390357991424 169 0) itemoff 10442 itemsize 3=
3
> [   51.357228] extent refs 1 gen 519476 flags 2
> [   51.357228] ref#0: tree block backref root 258
> [   51.357229] item 177 key (390358007808 169 0) itemoff 10409 itemsize 3=
3
> [   51.357230] extent refs 1 gen 519476 flags 2
> [   51.357230] ref#0: tree block backref root 258
> [   51.357231] item 178 key (390358040576 169 0) itemoff 10376 itemsize 3=
3
> [   51.357231] extent refs 1 gen 519476 flags 2
> [   51.357232] ref#0: tree block backref root 258
> [   51.357233] item 179 key (390358269952 169 0) itemoff 10343 itemsize 3=
3
> [   51.357233] extent refs 1 gen 519476 flags 2
> [   51.357234] ref#0: tree block backref root 258
> [   51.357234] item 180 key (390358450176 169 0) itemoff 10310 itemsize 3=
3
> [   51.357235] extent refs 1 gen 548386 flags 2
> [   51.357235] ref#0: tree block backref root 2
> [   51.357236] item 181 key (390359056384 169 0) itemoff 10277 itemsize 3=
3
> [   51.357237] extent refs 1 gen 483420 flags 2
> [   51.357237] ref#0: tree block backref root 7
> [   51.357238] item 182 key (390359072768 169 0) itemoff 10244 itemsize 3=
3
> [   51.357238] extent refs 1 gen 483420 flags 2
> [   51.357239] ref#0: tree block backref root 7
> [   51.357240] item 183 key (390359105536 169 0) itemoff 10211 itemsize 3=
3
> [   51.357240] extent refs 1 gen 483420 flags 2
> [   51.357240] ref#0: tree block backref root 7
> [   51.357241] item 184 key (390359138304 169 0) itemoff 10178 itemsize 3=
3
> [   51.357242] extent refs 1 gen 554475 flags 2
> [   51.357242] ref#0: tree block backref root 258
> [   51.357243] item 185 key (390359187456 169 0) itemoff 10145 itemsize 3=
3
> [   51.357244] extent refs 1 gen 554475 flags 2
> [   51.357244] ref#0: tree block backref root 258
> [   51.357245] item 186 key (390359203840 169 0) itemoff 10112 itemsize 3=
3
> [   51.357246] extent refs 1 gen 554475 flags 2
> [   51.357246] ref#0: tree block backref root 7
> [   51.357247] item 187 key (390359416832 169 0) itemoff 10079 itemsize 3=
3
> [   51.357247] extent refs 1 gen 554475 flags 2
> [   51.357248] ref#0: tree block backref root 258
> [   51.357249] item 188 key (390359482368 169 0) itemoff 10046 itemsize 3=
3
> [   51.357249] extent refs 1 gen 554475 flags 2
> [   51.357249] ref#0: tree block backref root 258
> [   51.357250] item 189 key (390359662592 169 0) itemoff 10013 itemsize 3=
3
> [   51.357251] extent refs 1 gen 554285 flags 2
> [   51.357251] ref#0: tree block backref root 7
> [   51.357252] item 190 key (390359793664 169 0) itemoff 9980 itemsize 33
> [   51.357253] extent refs 1 gen 551724 flags 2
> [   51.357253] ref#0: tree block backref root 2
> [   51.357254] item 191 key (390359990272 169 0) itemoff 9947 itemsize 33
> [   51.357255] extent refs 1 gen 554475 flags 2
> [   51.357255] ref#0: tree block backref root 258
> [   51.357256] item 192 key (390360170496 169 0) itemoff 9914 itemsize 33
> [   51.357256] extent refs 1 gen 554475 flags 2
> [   51.357257] ref#0: tree block backref root 258
> [   51.357258] item 193 key (390360399872 169 0) itemoff 9881 itemsize 33
> [   51.357258] extent refs 1 gen 551724 flags 2
> [   51.357258] ref#0: tree block backref root 2
> [   51.357259] item 194 key (390361071616 169 0) itemoff 9848 itemsize 33
> [   51.357260] extent refs 1 gen 530311 flags 2
> [   51.357260] ref#0: tree block backref root 258
> [   51.357261] item 195 key (390361186304 169 0) itemoff 9815 itemsize 33
> [   51.357262] extent refs 1 gen 530311 flags 2
> [   51.357262] ref#0: tree block backref root 258
> [   51.357263] item 196 key (390361219072 169 0) itemoff 9782 itemsize 33
> [   51.357263] extent refs 1 gen 530311 flags 2
> [   51.357264] ref#0: tree block backref root 258
> [   51.357265] item 197 key (390362005504 169 0) itemoff 9749 itemsize 33
> [   51.357265] extent refs 1 gen 553172 flags 2
> [   51.357265] ref#0: tree block backref root 2
> [   51.357266] item 198 key (390363054080 169 0) itemoff 9716 itemsize 33
> [   51.357267] extent refs 1 gen 554475 flags 2
> [   51.357267] ref#0: tree block backref root 7
> [   51.357268] item 199 key (390363316224 169 0) itemoff 9683 itemsize 33
> [   51.357269] extent refs 1 gen 519476 flags 2
> [   51.357269] ref#0: tree block backref root 258
> [   51.357270] item 200 key (390363512832 169 0) itemoff 9650 itemsize 33
> [   51.357270] extent refs 1 gen 554475 flags 2
> [   51.357271] ref#0: tree block backref root 258
> [   51.357272] item 201 key (390363545600 169 0) itemoff 9617 itemsize 33
> [   51.357272] extent refs 1 gen 554475 flags 2
> [   51.357272] ref#0: tree block backref root 258
> [   51.357273] item 202 key (390363643904 169 0) itemoff 9584 itemsize 33
> [   51.357274] extent refs 1 gen 554475 flags 2
> [   51.357274] ref#0: tree block backref root 7
> [   51.357275] item 203 key (390363807744 169 0) itemoff 9551 itemsize 33
> [   51.357275] extent refs 1 gen 553546 flags 2
> [   51.357276] ref#0: tree block backref root 258
> [   51.357277] item 204 key (390364135424 169 0) itemoff 9518 itemsize 33
> [   51.357277] extent refs 1 gen 553546 flags 2
> [   51.357278] ref#0: tree block backref root 7
> [   51.357278] item 205 key (390364299264 169 0) itemoff 9485 itemsize 33
> [   51.357279] extent refs 1 gen 553546 flags 2
> [   51.357279] ref#0: tree block backref root 258
> [   51.357280] item 206 key (390364774400 169 0) itemoff 9452 itemsize 33
> [   51.357281] extent refs 1 gen 553546 flags 2
> [   51.357281] ref#0: tree block backref root 258
> [   51.357283] BTRFS error (device dm-0): unable to find ref byte nr
> 390335463424 parent 0 root 2  owner 0 offset 0
> [   51.357285] ------------[ cut here ]------------
> [   51.357285] BTRFS: Transaction aborted (error -2)
> [   51.357304] WARNING: CPU: 3 PID: 54 at fs/btrfs/extent-tree.c:6828
> __btrfs_free_extent.isra.25+0x67b/0x940 [btrfs]
> [   51.357304] Modules linked in: isofs thunderbolt ccm rfcomm fuse
> cmac snd_hda_codec_hdmi bnep snd_hda_codec_realtek
> snd_hda_codec_generic hid_multitouch joydev arc4 iTCO_wdt
> iTCO_vendor_support nls_iso8859_1 nls_cp437 vfat fat uvcvideo btusb
> btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel
> videobuf2_common ath10k_pci bluetooth ath10k_core videodev mousedev
> i915 intel_rapl ath snd_soc_skl snd_soc_hdac_hda ecdh_generic
> x86_pkg_temp_thermal intel_powerclamp snd_hda_ext_core media crc16
> coretemp snd_soc_skl_ipc mac80211 uas snd_soc_sst_ipc kvm_intel
> snd_soc_sst_dsp snd_soc_acpi_intel_match kvmgt snd_soc_acpi vfio_mdev
> mdev mei_wdt dell_laptop vfio_iommu_type1 dell_wmi wmi_bmof
> snd_soc_core vfio intel_wmi_thunderbolt dell_smbios
> dell_wmi_descriptor snd_compress i2c_algo_bit dcdbas kvm ac97_bus
> snd_pcm_dmaengine drm_kms_helper snd_hda_intel snd_hda_codec cfg80211
> irqbypass intel_cstate intel_uncore snd_hda_core snd_hwdep input_leds
> snd_pcm intel_rapl_perf drm snd_timer
> [   51.357319]  psmouse rtsx_pci_ms pcspkr memstick idma64 rfkill snd
> intel_gtt mei_me processor_thermal_device agpgart intel_soc_dts_iosf
> soundcore mei syscopyarea sysfillrect i2c_i801 sysimgblt fb_sys_fops
> intel_lpss_pci intel_lpss intel_pch_thermal ucsi_acpi tpm_crb
> typec_ucsi wmi typec i2c_hid battery soc_button_array intel_vbtn
> tpm_tis tpm_tis_core tpm int3403_thermal evdev int340x_thermal_zone
> mac_hid intel_hid rng_core ac int3400_thermal acpi_thermal_rel
> sparse_keymap pcc_cpufreq vboxnetflt(OE) vboxnetadp(OE) vboxpci(OE)
> vboxdrv(OE) sg crypto_user ip_tables x_tables btrfs libcrc32c
> crc32c_generic xor raid6_pq algif_skcipher af_alg sd_mod usb_storage
> scsi_mod hid_generic usbhid hid dm_crypt dm_mod crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc mmc_core
> serio_raw atkbd libps2 aesni_intel aes_x86_64 xhci_pci crypto_simd
> cryptd glue_helper xhci_hcd rtsx_pci i8042 serio
> [   51.357335] CPU: 3 PID: 54 Comm: kworker/u8:1 Tainted: G     U  W
> OE     4.20.6-arch1-1-ARCH #1
> [   51.357335] Hardware name: Dell Inc. XPS 13 9360/0PF86Y, BIOS 2.1.0
> 08/02/2017
> [   51.357347] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btr=
fs]
> [   51.357355] RIP: 0010:__btrfs_free_extent.isra.25+0x67b/0x940 [btrfs]
> [   51.357356] Code: 08 48 8b 40 50 f0 48 0f ba a8 90 12 00 00 02 0f
> 92 c0 5f 84 c0 0f 85 cc 0f 09 00 44 89 ee 48 c7 c7 70 82 35 c0 e8 af
> 7e 5d df <0f> 0b e9 b6 0f 09 00 4c 89 e7 e8 a6 7d fe ff 48 8b 3c 24 4d
> 89 f8
> [   51.357356] RSP: 0018:ffffacf5c1b37c38 EFLAGS: 00010282
> [   51.357357] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000000
> [   51.357358] RDX: 0000000000000007 RSI: ffffffffa08a427e RDI: 00000000f=
fffffff
> [   51.357358] RBP: 0000005ae1ce8000 R08: 0000000000000001 R09: 000000000=
00006b2
> [   51.357359] R10: 0000000000000004 R11: 0000000000000000 R12: ffff9b03d=
a498ee0
> [   51.357359] R13: 00000000fffffffe R14: 0000000000000000 R15: 000000000=
0000002
> [   51.357360] FS:  0000000000000000(0000) GS:ffff9b04ae380000(0000)
> knlGS:0000000000000000
> [   51.357361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.357362] CR2: 00007f252cd16af0 CR3: 000000020140a006 CR4: 000000000=
03606e0
> [   51.357362] Call Trace:
> [   51.357364]  ? _raw_spin_lock+0x13/0x30
> [   51.357365]  ? _raw_spin_unlock+0x16/0x30
> [   51.357376]  ? btrfs_merge_delayed_refs+0x315/0x350 [btrfs]
> [   51.357401]  __btrfs_run_delayed_refs+0x6f2/0x10e0 [btrfs]
> [   51.357403]  ? preempt_count_add+0x79/0xb0
> [   51.357411]  btrfs_run_delayed_refs+0x64/0x180 [btrfs]
> [   51.357418]  delayed_ref_async_start+0x81/0x90 [btrfs]
> [   51.357428]  normal_work_helper+0xbd/0x350 [btrfs]
> [   51.357430]  process_one_work+0x1eb/0x410
> [   51.357432]  worker_thread+0x2d/0x3d0
> [   51.357433]  ? process_one_work+0x410/0x410
> [   51.357434]  kthread+0x112/0x130
> [   51.357435]  ? kthread_park+0x80/0x80
> [   51.357437]  ret_from_fork+0x35/0x40
> [   51.357438] ---[ end trace 0be7e900e0369796 ]---
> [   51.357439] BTRFS: error (device dm-0) in __btrfs_free_extent:6828:
> errno=3D-2 No such entry
> [   51.357441] BTRFS info (device dm-0): forced readonly
> [   51.357442] BTRFS: error (device dm-0) in
> btrfs_run_delayed_refs:2978: errno=3D-2 No such entry
>
> On Sat, Feb 16, 2019 at 9:46 PM Martin P=C3=B6hlmann <mpdeimos@gmail.com>=
 wrote:
> >
> > Thanks a lot for your help.
> >
> > @Qu Wenruo: WIll zero log after completing the backup
> > @Chris Murphy: First of all, mount -ro,nologreplay works.
> >
> > dump-tree displays two items:
> >
> > # btrfs insp dump-tree -b 88560877568 --follow /dev/mapper/cryptroot
> > btrfs-progs v4.19.1
> > leaf 88560877568 items 2 free space 15355 generation 554510 owner TREE_=
LOG
> > leaf 88560877568 flags 0x1(WRITTEN) backref revision 1
> > fs uuid bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> > chunk uuid 25cacaa1-59ec-4c71-92e0-4b31f7937521
> > item 0 key (TREE_LOG ROOT_ITEM 258) itemoff 15844 itemsize 439
> > generation 554510 root_dirid 0 bytenr 88560812032 level 1 refs 0
> > lastsnap 0 byte_limit 0 bytes_used 376832 flags 0x0(none)
> > uuid 00000000-0000-0000-0000-000000000000
> > drop key (0 UNKNOWN.0 0) level 0
> > item 1 key (TREE_LOG ROOT_ITEM 259) itemoff 15405 itemsize 439
> > generation 554510 root_dirid 0 bytenr 917389312 level 0 refs 0
> > lastsnap 0 byte_limit 0 bytes_used 0 flags 0x0(none)
> > uuid 00000000-0000-0000-0000-000000000000
> > drop key (0 UNKNOWN.0 0) level 0
> >
> >
> > Regards 2nd mail:
> >
> > 1. as mentioned, mount with nologreplay works. Will update backups with=
 that.
> > 2. Used btrfs restore already for initial backup. Did a good job.
> > 3. Have to figure out how to get a usb-bootable recovery system w/ 5.0r=
c6 first.
> >
> > On Sat, Feb 16, 2019 at 1:54 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
> > >
> > >
> > >
> > > On 2019/2/16 =E4=B8=8A=E5=8D=885:31, Martin P=C3=B6hlmann wrote:
> > > > Hello,
> > > >
> > > > After a reboot I am lost with an unmountable BTRFS partition. Befor=
e
> > > > reboot I had first compile problems with freezing IntelliJ. These
> > > > persisted after a first reboot, after a second reboot I am faced wi=
th
> > > > the following error after entering the dm-crypt password (also afte=
r
> > > > manual mount with -o ro,recovery, see attached dmesg):
> > >
> > > [Move check result here]
> > > > # btrfs check --readonly /dev/mapper/cryptroot
> > > > [1/7] checking root items
> > > > [2/7] checking extents
> > > > [3/7] checking free space cache
> > > > [4/7] checking fs roots
> > > > root 258 inode 776 errors 200, dir isize wrong
> > > > root 258 inode 1131031 errors 1, no inode item
> > > >         unresolved ref dir 776 index 87215 namelen 17 name
> > > > TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> > > > root 258 inode 2911226 errors 1, no inode item
> > > >         unresolved ref dir 776 index 160611 namelen 17 name
> > > > TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> > > > ERROR: errors found in fs roots
> > > > Opening filesystem to check...
> > > > Checking filesystem on /dev/mapper/cryptroot
> > > > UUID: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> > > > found 409699909636 bytes used, error(s) found
> > > > total csum bytes: 390595732
> > > > total tree bytes: 5061541888
> > > > total fs tree bytes: 4224024576
> > > > total extent tree bytes: 339312640
> > > > btree space waste bytes: 892618468
> > > > file data blocks allocated: 529336496128
> > > >  referenced 490479570944
> > > >
> > > So there is just some minor problem in fs trees, not a big problem, a=
nd
> > > your extent tree passes the check, so it's not on-disk data corruptio=
n.
> > >
> > > >
> > > > [ 6098.921985] BTRFS error (device dm-0): unable to find ref byte n=
r
> > > > 390335463424 parent 0 root 2
> > > > [ 6098.922473] BTRFS: error (device dm-0) in __btrfs_free_extent:68=
28:
> > > > errno=3D-2 No such entry
> > > > [ 6098.922526] BTRFS: error (device dm-0) in
> > > > btrfs_run_delayed_refs:2978: errno=3D-2 No such entry
> > > > [ 6098.922601] BTRFS: error (device dm-0) in btrfs_replay_log:2267:
> > > > errno=3D-2 No such entry (Failed to recover log tree)
> > > > [ 6098.972326] BTRFS error (device dm-0): open_ctree failed
> > >
> > > It's log recovery causing problem.
> > >
> > > You could just use "btrfs rescue zero-log" to recovery it.
> > >
> > > Thanks,
> > > Qu
> > >
> > > >
> > > > I've searched for a solution on the web, but most articles tell to =
do
> > > > nothing, but write to this mailing list. So my hopes are that you c=
an
> > > > shed some light into what I can do.
> > > >
> > > > I've found a quite recent thread here
> > > > (https://lore.kernel.org/linux-btrfs/5b0d2e94-6e4e-aecd-3eda-459c4a=
96bb13@mokrynskyi.com/)
> > > > but this just mentions a fix for 'Fix missing reference aborts when
> > > > resuming snapshot delete' and is not further specific.
> > > >
> > > > Setup of my SSD looks like:
> > > >
> > > > * efi
> > > > * dm-crypt plain. Contains BTRFS (w/o lvm or similar). Several
> > > > subvolumes (/, /home, ...)
> > > > * swap
> > > >
> > > > I've already run btrfs restore on volid 258 (home) and gathered lot=
s
> > > > of data from the disk (>200GB). I also have a dd backup of the
> > > > cryptroot after the failure happened (in case something goes wrong)=
.
> > > > Besides I did not do any fix attempts yet. If there is anything I c=
an
> > > > do to get the system working again, I'm happy to hear.
> > > >
> > > > Thanks!
> > > >
> > > > My Linux system is Arch Linux (up to date), logs below come from th=
e
> > > > Arch install medium .
> > > >
> > > > # uname -a
> > > > Linux archiso 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:0=
1
> > > > UTC 2019 x86_64 GNU/Linux
> > > >
> > > > # btrfs --version
> > > > btrfs-progs v4.19.1
> > > >
> > > > # btrfs fi show
> > > > Label: 'root'  uuid: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
> > > >         Total devices 1 FS bytes used 381.56GiB
> > > >         devid    1 size 460.39GiB used 393.01GiB path /dev/mapper/c=
ryptroot
> > > >
> > >
