Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CCC2E7179
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 10:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789034908; cv=none; b=HbpoIisG9KAkSvfkuiUu4pmre0papD65nvOhotCr3YoNlVc6OWxmtBRUqInFU/wUpJo+O6053ZP9ZufGcnStWbEKSdOrki8FEEq2dvgiFBM7gJkXw5ZGRUyWnqsz+bOltpGk0TGGBjXyNLG7eWg0xKRRFWASdVxY/XK26O0PpcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789034908; c=relaxed/simple;
	bh=teNUeH4zjBgbfAi1V59GZ5uzDPM3cdLJyGxjVSdyrkw=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ur+Pk+6Q/w8pf+yD0nGYkzUYHSs6rZFaIvTjyiwdOVdzfCtTF1iYDTma+6LQar1aHRG+tMrqJ/sEzbEblUMRzlpKMyJND2e/ExIm0uASo4r9j6y/eLIDNr/sxrFT/GMsUjoFw9hKXra4PezIn2DSnpIvJtIcQ44D0vZb5JyVy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zo0XRgZz; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zo0XRgZz"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4843f205a5bso4594109f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 03:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789034896; x=1789639696; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1f1drJA4Fu9Ujwo7lu6Jfjt3v5njFcbWLoOOrV+IJNs=;
        b=Zo0XRgZzRod+YqmU0gFUqxeqVcgMbeIb8an93e0hQV/TW7NJAtStkiAMwH9OSzFG3e
         ItroGAfdB2c3nyACC0fg2loOg8O44ueG60+kemIwOsMkkKDPEQ2oqwr0n72Av5P10i+N
         JSPoiU3aBR62tyzwdcn/b87hGpnOFZjjNV9biIrlPjKTA1mSfWgUpMbnL+yvK2P9RKVn
         fzSKVH/VCqpEvJyxfFVrCYe7myrkY9kGZnKaBO3I1fZyJXBWKpJxekQ2ZLiL7OzLvBGf
         MIUJhfuV2Eqy4y6ZdSFRmTlbfPWHHHRoyIPtKDrksh1K70drKVpX2KSV3XCUNg7gGsxj
         CmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789034896; x=1789639696;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1f1drJA4Fu9Ujwo7lu6Jfjt3v5njFcbWLoOOrV+IJNs=;
        b=I9c5P2FQjyKesBGXhYqdu14AkN0dxFgrhtSctjq4973zLcAvGKkQIwf9FpToIXSMmF
         s7A+wyNKHDbYIOQg2A+aID2NN7/suJQN8zg+O1sJkIjnlU7SBWAq5k3l9i3nlOIIkST+
         KkqxYl2eBHQeA9rfhw0eUI/Hn3oYYXtuMKRBV16+quS84qovgVfeUtBNJjvofhPC261K
         vE/qdjTLUCpMErBv0xoytyh8TT7V0nOtaW7nS7kZsnMEjUaVBxGERvOmjIAj0y5JTDnH
         Z80OHOOJOAtH4CT40jGRiCsYpImXsKr5ormQvqKoD5Lux8PLUb5BaI6EKXLfzEPnUho+
         Yb8g==
X-Gm-Message-State: AFuF++kpDZ4MBg178hj3auM21OHAj+PcFWYGiahxYdsaoMJ4SexNVmS0
	CQs8vzNuMXmCa5vYSZI30qlCddN7D1Cv2ZgIn8YZc9uwysdfUxvVZ2nn/+cKsw==
X-Gm-Gg: AYBFou2TNvgCYglXs91fQYybylKxGb9RrGfyZyb87C/9AH+dTGDHRIh+2qm3QHeRoGR
	J05435vnQPhZalD1E2GqLDdVg1GdyYE3EgSsbnz6GYpY5Fr2RLku9U8WR4B97GPd8WXt4So8rYb
	+LhBc4wJ3oLidXVNPCZw7pc5nQVpISYa5dL8eNoQ+xs3YKbmwpmgzZeAcHr7zspycOwxSvwHaNl
	LmxlhfrMtqPAIhp3kzeWCixJxZ4DLVfIAu1tTCMzLl71WNFYa5Ssh0A6C/fWA0CzxlQ1fBAhZVB
	XOe27eqgwCHjN6XIY1yEKkGkndYxL0gBmL0dNDVrQt+WjP+mPPRnYHPXMuVPvh+R8jesnvHdYis
	Xy7ag9pSnX3V+iczMbEU5mciJu9x9oZmEfOm7hlyxJvyhxFIRSb/xhr7S/1/41kJOGm2wv8Xmdr
	J5S+cao9kPwEINmQ1+EC4CunqCVajoDdSlgULqJYcjpO4RhYPIUASwflWAgK9Fk6njXQ8iX2iy6
	1AI6VNQLdaj1K03l6ipO9j+hliOhiyzLtQl4okLOPob64r41EzPjtES4apPCIPcGA6w1MIiPdha
	SNBrdOk/zPMaGA9PCft/JZVhHyfW7gVdaOw1AHgcH/bfrJ5aPAR+lRRb/bI=
X-Received: by 2002:a05:600c:4e8f:b0:49c:fa20:cbfc with SMTP id 5b1f17b1804b1-49cfa20cd1fmr366700645e9.19.1789034895965;
        Thu, 10 Sep 2026 03:08:15 -0700 (PDT)
Received: from omarchy.local (046124165200.public.t-mobile.at. [46.124.165.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c300e2sm66356965e9.8.2026.09.10.03.08.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 03:08:15 -0700 (PDT)
From: mario.mohar1986@gmail.com
To: linux-btrfs@vger.kernel.org
Subject: BUG: NULL pointer dereference in btrfs_decompress_buf2page() on zstd
 compressed read (7.1.9)
Date: Thu, 10 Sep 2026 12:08:14 +0200
Message-ID: <178903489463.297496.3347545627104440629@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

I hit a NULL pointer dereference in btrfs_decompress_buf2page() while a read =
of
a zstd compressed extent was being completed. The oops killed the btrfs-endio
worker, and because it died inside the endio path the read never completed:
every task waiting on that extent stayed in uninterruptible sleep and could n=
ot
be killed, not even with SIGKILL. A reboot was the only way out.

The machine has since been rebooted and the same file now reads back fine, so=
 I
cannot reproduce this on demand. I am reporting it anyway because the trace is
complete and the failure mode is unpleasant. Details on that are at the end.


Environment
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Kernel:      7.1.9-arch1-2 (Arch Linux), Not tainted
Hardware:    LENOVO 82TS / LNVNB161216, BIOS JKCN23WW 03/21/2022
Filesystem:  btrfs on dm-crypt, subvolume mounted on /home
Mount:       compress=3Dzstd:3, ssd optimizations, free space tree
Checksum:    crc32c
Capacity:    237G total, 51G used, 186G free
Memory:      11 GB RAM, zram swap at priority 100 above a btrfs swapfile

Mount time lines:

  BTRFS info (device dm-0): using crc32c checksum algorithm
  BTRFS info (device dm-0): enabling ssd optimizations
  BTRFS info (device dm-0): enabling free space tree
  BTRFS info (device dm-0 state M): use zstd compression, level 3


Oops
=3D=3D=3D=3D

BUG: kernel NULL pointer dereference, address: 00000000000000f0
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 1787a6067 P4D 1787a6067 PUD 1787a5067 PMD 0=20
Oops: Oops: 0002 [#1] SMP NOPTI
CPU: 7 UID: 0 PID: 2626544 Comm: kworker/u32:15 Not tainted 7.1.9-arch1-2 #1 =
PREEMPT(full)  1dcb44188b0ac1c68b4b4adc32aedf169215449b
Hardware name: LENOVO 82TS/LNVNB161216, BIOS JKCN23WW 03/21/2022
Workqueue: btrfs-endio simple_end_io_work
RIP: 0010:memcpy+0xc/0x20
Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 66 90 48 89 f8 48 89 d1 <f3> a4 c3 cc cc cc cc=
 66 90 66 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0000:ffffd0df0ccbfc50 EFLAGS: 00010286
RAX: ffff8ca4b95c7000 RBX: 0000000000001000 RCX: 0000000000001000
RDX: 0000000000001000 RSI: ffff8ca3a855e000 RDI: ffff8ca4b95c7000
RBP: 0000000000005000 R08: 0000000000000000 R09: 0000000000001000
R10: 0000000000001000 R11: ffff8ca41fe88050 R12: ffff8ca3532a5340
R13: 0000000000005000 R14: 0000000000006000 R15: ffff8ca3bb6ce4c0
FS:  0000000000000000(0000) GS:ffff8ca64eb0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000f0 CR3: 00000001bdbed003 CR4: 0000000000f72ef0
PKRU: 55555554
Call Trace:
 <TASK>
 btrfs_decompress_buf2page+0x136/0x180
 zstd_decompress_bio+0x225/0x4b0
 end_bbio_compressed_read+0x25b/0x2d0
 btrfs_check_read_bio+0x49c/0x4b0
 process_one_work+0x19f/0x390
 worker_thread+0x1b1/0x310
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe4/0x120
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2a7/0x330
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in: tun nf_conntrack_netlink xt_nat veth xt_MASQUERADE bridge =
stp llc xfrm_user xfrm_algo xt_set ip_set nft_chain_nat nf_nat overlay uinput=
 uhid tcp_diag inet_diag ccm rfcomm snd_seq_dummy snd_hrtimer snd_seq snd_seq=
_device algif_hash algif_skcipher af_alg bnep vfat fat snd_hda_codec_intelhdm=
i snd_hda_codec_hdmi snd_hda_codec_alc269 snd_hda_codec_realtek_lib snd_hda_s=
codec_component snd_hda_codec_generic snd_hda_intel snd_sof_pci_intel_tgl snd=
_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel snd_sof_intel_hd=
a_sdw_bpt snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_intel_hda_mlink s=
nd_sof_intel_hda soundwire_cadence snd_sof_pci snd_sof_xtensa_dsp snd_sof snd=
_sof_utils snd_soc_acpi_intel_match snd_soc_acpi_intel_sdca_quirks soundwire_=
generic_allocation snd_soc_sdw_utils snd_soc_acpi soundwire_bus snd_soc_sdca =
crc8 snd_soc_avs snd_soc_hda_codec intel_rapl_msr intel_uncore_frequency snd_=
hda_ext_core intel_uncore_frequency_common snd_hda_codec intel_tcc_cooling x8=
6_pkg_temp_thermal
 snd_hda_core intel_powerclamp coretemp snd_intel_dspcfg snd_intel_sdw_acpi r=
8153_ecm snd_hwdep kvm_intel iwlmvm cdc_ether usbnet iTCO_wdt ee1004 snd_soc_=
core mei_pxp mei_hdcp intel_pmc_bxt hid_multitouch kvm mac80211 snd_compress =
ac97_bus uvcvideo irqbypass processor_thermal_device_pci snd_pcm_dmaengine ra=
pl processor_thermal_device btusb videobuf2_vmalloc ptp intel_cstate processo=
r_thermal_wt_hint snd_pcm uvc r8169 pps_core btmtk videobuf2_memops platform_=
temperature_control libarc4 realtek intel_uncore btrtl iwlwifi phy_package uc=
si_acpi videobuf2_v4l2 processor_thermal_soc_slider snd_timer mdio_devres btb=
cm pcspkr videobuf2_common i2c_i801 typec_ucsi spi_nor btintel r8152 libphy i=
deapad_laptop videodev roles mei_me i2c_smbus processor_thermal_rfim snd leno=
vo_wmi_hotkey_utilities wmi_bmof mii mtd sparse_keymap bluetooth mc mdio_bus =
cfg80211 soundcore i2c_mux mei typec intel_oc_wdt rfkill processor_thermal_ra=
pl int3403_thermal i2c_hid_acpi intel_rapl_common intel_pmc_core i2c_hid proc=
essor_thermal_wt_req
 pmt_telemetry processor_thermal_power_floor pmt_discovery processor_thermal_=
mbox int3400_thermal pinctrl_tigerlake pmt_class acpi_tad acpi_pad joydev acp=
i_thermal_rel intel_pmc_ssram_telemetry mousedev int340x_thermal_zone apple_m=
fi_fastcharge mac_hid ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt ipt_REJECT nf_=
reject_ipv4 xt_LOG nf_log_syslog nft_limit xt_limit xt_addrtype xt_tcpudp xt_=
conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat x_tables nf_t=
ables nfnetlink i2c_dev crypto_user zram 842_decompress 842_compress lz4hc_co=
mpress lz4_compress dm_crypt encrypted_keys trusted asn1_encoder tee dm_mod h=
id_apple hid_logitech_hidpp hid_logitech_dj xe drm_ttm_helper drm_suballoc_he=
lper gpu_sched drm_gpuvm drm_exec drm_gpusvm_helper i915 aesni_intel drm_budd=
y gf128mul serio_raw aead nvme i2c_algo_bit ttm nvme_core intel_lpss_pci inte=
l_gtt spi_intel_pci nvme_keyring video intel_lpss drm_display_helper spi_inte=
l nvme_auth wmi idma64 cec intel_vsec thunderbolt
CR2: 00000000000000f0
---[ end trace 0000000000000000 ]---
RIP: 0010:memcpy+0xc/0x20
Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 66 90 48 89 f8 48 89 d1 <f3> a4 c3 cc cc cc cc=
 66 90 66 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0000:ffffd0df0ccbfc50 EFLAGS: 00010286
RAX: ffff8ca4b95c7000 RBX: 0000000000001000 RCX: 0000000000001000
RDX: 0000000000001000 RSI: ffff8ca3a855e000 RDI: ffff8ca4b95c7000
RBP: 0000000000005000 R08: 0000000000000000 R09: 0000000000001000
R10: 0000000000001000 R11: ffff8ca41fe88050 R12: ffff8ca3532a5340
R13: 0000000000005000 R14: 0000000000006000 R15: ffff8ca3bb6ce4c0
FS:  0000000000000000(0000) GS:ffff8ca64eb0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000f0 CR3: 00000001bdbed003 CR4: 0000000000f72ef0
PKRU: 55555554
note: kworker/u32:15[2626544] exited with irqs disabled


How it showed up
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

A Node.js dev server would not start. No output, no listening socket, zero CP=
U,
no child processes, for 602 seconds. Reading the program file directly
reproduced it at the time:

  $ timeout 5 head -2 node_modules/next/dist/bin/next   # hangs, times out
  $ timeout 5 head -1 package.json                      # fine
  $ timeout 5 ls node_modules                           # fine

So it was one specific extent, repeatably, while the rest of the same directo=
ry
read normally. A second project with an identical dependency tree in a sibling
directory was unaffected.

The count of stuck readers grew with every attempt, seven processes over about
twenty minutes, because each new access to the same file blocked the same way.

>From userspace this looks like a program that starts and produces nothing at
all, with no error anywhere. The process never reaches execve of the
interpreter, so not even a shebang failure is reported. That made it hard to
attribute to the filesystem.


What I ruled out
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Data corruption:  btrfs scrub start -B over 38.48 GiB finished in 31 seconds,
                  "Error summary: no errors found".
Disk space:       186G free.
Application code: reverting all local source changes made no difference, the
                  hang happens before any application code runs.
npm:              invoking the binary directly, bypassing npm, hung identical=
ly.
Stale processes:  none, the hang reproduced from a clean state.


Possibly related activity
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

13 seconds before the oops, overlayfs activity was logged on the same
filesystem:

  overlayfs: upper fs does not support file handles, falling back to index=3D=
off.
  overlayfs: fs on '/home/<user>/.local/share/containers/storage/overlay/<id>=
/diff'
    does not support file handles, falling back to xino=3Doff.

Rootless podman containers (mysql:8.4, postgres:17-alpine) were being started
and stopped repeatedly on this filesystem in the minutes before it happened,
and a build cache directory of about 215 MB had been removed with rm -rf.
Whether overlayfs on btrfs with zstd is the trigger or just concurrent load, I
cannot say. I offer it as a lead, not a claim.


After the reboot
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1. The same file reads back with no error and no dmesg output. The build that
   had failed completes. npm ci was not needed, so nothing had to be rewritten
   to make it work. Together with the clean scrub this suggests the stored
   extent was never bad and the fault is in the read and decompress path.

2. The oops has not recurred in the three boots since.

3. The kernel changed. The oops was on 7.1.9-arch1-2. Arch shipped
   7.2.3-arch1-3 on the morning it happened, but the machine was still running
   the old kernel and only picked up the new one at the evening reboot. So th=
is
   report describes 7.1.9-arch1-2 and I cannot say whether 7.2.3-arch1-3 is
   affected.

4. The machine does reach the allocation failure regime in normal use. On
   2026-09-10, on 7.2.3-arch1-3, it logged an order:0 page allocation failure
   in the reclaim path:

     page allocation failure: order:0, mode:0xc0de0(GFP_KERNEL|__GFP_HIGH|
     __GFP_ZERO|__GFP_COMP|__GFP_NOMEMALLOC)
     __alloc_pages_slowpath -> folio_alloc_noprof -> swap_cluster_alloc_table
     -> cluster_alloc_swap_entry -> folio_alloc_swap -> shrink_folio_list
     -> evict_folios -> shrink_node -> try_to_free_pages

   That is a warning and a different call path, not a second oops. I mention =
it
   only because it shows this machine does run into failing allocations, which
   is the sort of condition the decompress path would have been in.

I have the complete dmesg ring buffer of the affected boot saved and can send
any part of it on request. Happy to test a patch or run a debug kernel, though
without a reproducer I cannot promise to trigger it again.

Thanks,
Mario Mohar
