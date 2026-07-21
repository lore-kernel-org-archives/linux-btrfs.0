Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C5377AA6
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 11:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784634421; cv=none; b=CFQqI3YloBhvweZj7dHoI2wD+Z3SY0i85tDIifTvONRDAQRp1gnHar1GzihsbjjXSy3hLXpTIqRKbU6i0VokeNudl6hCyrJTgIO3L/ctVkvMSLBJegqHRASKabLcuZiVCHe1Zfn/WqMLuwbWPIlYVPh56uQKzFl/CYAMp7aXrPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784634421; c=relaxed/simple;
	bh=GNhyBOk6YOFhLqF2UxifjMKSwAXaM6fHs9ObYn6wQ3g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UxLGuaNXUjlfYktNn70R/R8oY24lJkWr2EaelSzFhy2XaT7UezyA4JcCGa63G8Kryp7ZX9TigdTpZTXuggW7l8grLFVq5/AuJPKLrP5M5m3uOPvWEOAf9ZDvo79xma4nElSkaqiJ+/v7XUUWS3LClpmYelFHdWaiPAqelfAEhik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bupt.moe; spf=pass smtp.mailfrom=bupt.moe; dkim=pass (1024-bit key) header.d=bupt.moe header.i=@bupt.moe header.b=h6KdzsuT; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bupt.moe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bupt.moe
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bupt.moe header.i=@bupt.moe header.b="h6KdzsuT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bupt.moe;
	s=qqmb2301; t=1784634412;
	bh=/wep6LPbvuvDGVk5Ha80XwgleKsOO+QukKTFR1I6YL8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject;
	b=h6KdzsuT6Gxdii+IxxfEzTHGy7YlBE/QlQNY2eFrX67AUDOSTZiwRL5fwZLPHw6Fi
	 MYOrciEm6T5MwxgcvFjAe7ix6QHuihsjhvzr8QM3fY7dqo35oKmob9roXX6x+HCJPx
	 2oCaL5VhwB3hTPMw0ZgBw1As1PVTLL7eqrIOJC4E=
X-QQ-mid: esmtpgz15t1784634411t4d144260
X-QQ-Originating-IP: Gff1+NDxmaHY/VGT7iQFtQmgYE55VzrJO+Vx+KARc0M=
Received: from [198.18.0.1] ( [123.134.104.77])
	by bizesmtp.qq.com (ESMTP) with SMTP id 0
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 19:46:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7273738389249578939
Message-ID: <FC0DE3FDAD40B4C0+924da345-6000-4644-9b0d-0439e63f3381@bupt.moe>
Date: Tue, 21 Jul 2026 19:46:53 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: HAN Yuwei <hrx@bupt.moe>
Subject: [BUG] cow_file_range failed and kernel panic on zoned device
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:bupt.moe:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NyqG2qnv0b2dKVeOjbwXcx4Y8XH3Tc4XFbOA7+AvPdUIht6pCpgjlWKy
	tdN5HgjlNsCLaeXGIRp8cq73ot2MlbgsaxKRNTcTrsfgQa0DSXcmx4/EDvZPY0EDMue2CRX
	wC1OZEe/E+MxFEEC6r5USl6WuYQMZtNSOAQTFgv1Cs1/4AHGpEMJySCPRHSAOaNfFiZEjAR
	p5R4G4xqHjIRTlnCEKKz2RbgbDhou3FrNMo7t5nWb1xZc71M0+kBRscHBSTFlOuLJ/Dhz8c
	ps9Zx9Do+umZn/7U/ekKd4MMtBFER1AyF+kKMn10fHOe10ItrvhxvUPTDBS5x1J0eqW7TXC
	MjBJJEtUWHIUY45E9YAsARXdYsceSphC2Wvjw8sF1vzZV1sKCgnYOssyIBfIussuEDsH5FY
	Z+M+adp2dWGDlCqjkNTOnNcRHbFKFhggUqtJtWCE+iKcaSBgaPdO4h2P0UHzxE+oVLsshX4
	UEJq7qFDL6F+CRLZzaMgXarvyVd4eKryqTqwEHEghEmMwYxL07y0t391Xi71mwHIJ7TvTG6
	1Lg8tuMTPTUC/Jl5m0OoYVDIvmT5mEN/Vmfo6lZJ0eawjIW06zTrYFKsrN6ncBL2KmG3GUz
	FFCGLXhxqC3wSR5OVbH1Wgz6GM0r1/q67Sapu/NlKj1HNwDjqeSV+/kcY94lAX21Qi7MhJr
	VsBnLAJmecJNj9t20g3srF/nH97uz7mb8Nlq1vULovpX7Luzd1q/dIX8JM9Xm810rAuCoat
	gwVrCd8mha65AJ4rC1jeh9uS6JdKN/bPa9EwFYADNe59GtqNw9B5TGsxOYZr8NTMOU9LvNQ
	DQd/9AtQ3ZyF49xRZnV4ksLa8MqQhU4Bi7YslxtHA3KyGUFKNXPRBjRfPzgAke/9/i4Rqnk
	6cTlA1zp5dfCCAo4qXGJuSnFeTYGWwPvIQGSZUdsfqdMuQv3Mk28bOGzQOV+PeXOlE4PaoW
	By9oQ/vdPCF7tPH41p15u/oY2eK7+AtPSoHmT4fd8Wz3v5azN7kwaDYc118eJjsLnKt0=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi all,
I have received a report from a user stating kernel panic when writing 
to HM-SMR HDD in 1TiB. The user used "mkfs.btrfs -f /dev/sdX" to create 
a new volume. And he tested xfs on the same device without any issue.

Reported-By: LUO Xiang <luoxiang221@mails.ucas.ac.cn>
HDD Model:Seagate ST18000NM009J
uname -a:Linux pro69 7.1.3-arch2-2 #1 SMP PREEMPT_DYNAMIC Thu, 16 Jul 
2026 17:41:28 +0000 x86_64 GNU/Linux
btrfs-progs: local/btrfs-progs 7.1-1
dmesg:
[redacted]
Jul 19 21:28:13 pro69 kernel: BTRFS error (device sde): cow_file_range 
failed, root=5 inode=268 start=63255040000 len=688128 
cur_offset=63255040000 cur_alloc_size=0: -28
Jul 19 21:28:13 pro69 kernel: BTRFS error (device sde): cow_file_range 
failed, root=5 inode=268 start=63255728128 len=688128 
cur_offset=63255728128 cur_alloc_size=0: -28
Jul 19 21:28:13 pro69 kernel: BTRFS error (device sde): cow_file_range 
failed, root=5 inode=268 start=63256416256 len=688128 
cur_offset=63256416256 cur_alloc_size=0: -28
Jul 19 21:28:37 pro69 kernel: _btrfs_printk: 303 callbacks suppressed
Jul 19 21:28:37 pro69 kernel: BTRFS error (device sde): error while 
writing out transaction: -11
Jul 19 21:28:37 pro69 kernel: BTRFS warning (device sde): Skipping 
commit of aborted transaction.
Jul 19 21:28:37 pro69 kernel: ------------[ cut here ]------------
Jul 19 21:28:37 pro69 kernel: BTRFS: Transaction aborted (error -11)
Jul 19 21:28:37 pro69 kernel: WARNING: fs/btrfs/transaction.c:2067 at 
btrfs_commit_transaction+0xa7c/0xde0, CPU#11: btrfs-transacti/8799
Jul 19 21:28:37 pro69 kernel: Modules linked in: nf_conntrack_netlink 
xt_nat xt_tcpudp veth xt_conntrack xt_MASQUERADE xfrm_user xfrm_algo 
xt_set ip_set xt_addrtype nft_compat x_tables rpcrdma rdma_cm iw_cm 
ib_cm ib_core ccm rfcomm snd_seq_dummy snd_hrtimer snd_seq 
snd_seq_device nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject 
act_csum cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack 
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink overlay bonding tls 
bridge stp llc snd_ctl_led algif_hash algif_skcipher af_alg bnep uinput 
snd_hda_codec_intelhdmi snd_hda_codec_alc882 snd_hda_codec_realtek_lib 
snd_hda_codec_generic drm_gpusvm_helper drm_gpuvm snd_sof_pci_intel_tgl 
snd_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel 
snd_sof_intel_hda_sdw_bpt snd_sof_intel_hda_common snd_soc_hdac_hda 
snd_sof_intel_hda_mlink snd_sof_intel_hda soundwire_cadence snd_sof_pci 
snd_sof_xtensa_dsp snd_sof intel_rapl_msr snd_sof_utils 
intel_rapl_common snd_soc_acpi_intel_match intel_uncore_frequency 
snd_soc_acpi_intel_sdca_quirks
Jul 19 21:28:37 pro69 kernel:  soundwire_generic_allocation 
intel_uncore_frequency_common snd_soc_sdw_utils snd_soc_acpi 
intel_tcc_cooling x86_pkg_temp_thermal soundwire_bus intel_powerclamp 
snd_soc_sdca coretemp crc8 iwlmvm snd_soc_avs vfat snd_hda_codec_atihdmi 
fat amdgpu kvm_intel snd_soc_hda_codec mac80211 snd_hda_codec_hdmi i915 
snd_hda_intel snd_hda_ext_core libarc4 kvm snd_hda_codec snd_soc_core 
asus_armoury btusb snd_hda_core amdxcp btmtk aesni_intel 
drm_panel_backlight_quirks snd_compress snd_intel_dspcfg iwlwifi 
gpu_sched ac97_bus btrtl snd_intel_sdw_acpi gf128mul drm_exec 
snd_pcm_dmaengine snd_hwdep firmware_attributes_class iTCO_wdt rapl 
eeepc_wmi btbcm ucsi_acpi drm_suballoc_helper btintel asus_wmi spd5118 
snd_pcm mei_hdcp atlantic mei_pxp typec_ucsi intel_cstate intel_pmc_bxt 
drm_buddy drm_ttm_helper sparse_keymap wmi_bmof cfg80211 bluetooth igc 
snd_timer macsec ttm i2c_i801 roles mei_me ptp snd spi_nor intel_oc_wdt 
i2c_algo_bit i2c_smbus typec soundcore intel_uncore mtd pps_core pcspkr 
i2c_mux aead drm_display_helper
Jul 19 21:28:37 pro69 kernel:  rfkill intel_pmc_core mei thunderbolt 
pmt_telemetry cec pmt_discovery pmt_class intel_gtt 
intel_pmc_ssram_telemetry joydev mousedev video pinctrl_alderlake 
intel_vsec acpi_pad acpi_tad wmi mac_hid nfsd auth_rpcgss nfs_acl lockd 
grace nfs_localio sunrpc i2c_dev dm_mod pkcs8_key_parser crypto_user 
ntsync uhid zram 842_decompress 842_compress lz4hc_compress lz4_compress 
hid_uclogic hid_multitouch nvme nvme_core intel_lpss_pci nvme_keyring 
intel_lpss spi_intel_pci nvme_auth spi_intel vmd idma64 vfio_pci 
vfio_pci_core irqbypass vfio_iommu_type1 vfio iommufd
Jul 19 21:28:37 pro69 kernel: CPU: 11 UID: 0 PID: 8799 Comm: 
btrfs-transacti Tainted: G     U              7.1.3-arch2-2 #1 
PREEMPT(full)  cf81b9d1a4a39be4b5e92e0c1c96594e14e8e6c8
Jul 19 21:28:37 pro69 kernel: Tainted: [U]=USER
Jul 19 21:28:37 pro69 kernel: Hardware name: ASUS System Product 
Name/ProArt Z690-CREATOR WIFI, BIOS 4101 12/03/2024
Jul 19 21:28:37 pro69 kernel: RIP: 0010:btrfs_commit_transaction+0xa7e/0xde0
Jul 19 21:28:37 pro69 kernel: Code: ff 48 8b 7c 24 08 31 c9 48 8d b7 48 
01 00 00 e8 f8 e6 0b 00 48 c7 43 18 00 00 00 00 e9 89 fe ff ff 48 8d 3d 
c4 1d 14 02 89 ee <67> 48 0f b9 3a 41 be 01 00 00 00 e9 fc fe ff ff 49 
8b bc 24 48 03
Jul 19 21:28:37 pro69 kernel: RSP: 0018:ffffd29d0fadbe28 EFLAGS: 00010246
Jul 19 21:28:37 pro69 kernel: RAX: 0000000000000013 RBX: 
ffff8f52847605c0 RCX: 0000000000000027
Jul 19 21:28:37 pro69 kernel: RDX: 0000000002040001 RSI: 
00000000fffffff5 RDI: ffffffffbdd0d240
Jul 19 21:28:37 pro69 kernel: RBP: 00000000fffffff5 R08: 
0000000000000000 R09: ffffffffbe75e480
Jul 19 21:28:37 pro69 kernel: R10: ffffd29d0fadbc30 R11: 
ffffd29d0fadbc28 R12: ffff8f528263e000
Jul 19 21:28:37 pro69 kernel: R13: ffff8f528c873a00 R14: 
ffff8f528c873a00 R15: ffff8f5284760628
Jul 19 21:28:37 pro69 kernel: FS:  0000000000000000(0000) 
GS:ffff8f5a60e11000(0000) knlGS:0000000000000000
Jul 19 21:28:37 pro69 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Jul 19 21:28:37 pro69 kernel: CR2: 000055bb0521a008 CR3: 
0000000761c22002 CR4: 0000000000f72ef0
Jul 19 21:28:37 pro69 kernel: PKRU: 55555554
Jul 19 21:28:37 pro69 kernel: Call Trace:
Jul 19 21:28:37 pro69 kernel:  <TASK>
Jul 19 21:28:37 pro69 kernel:  transaction_kthread+0x152/0x1c0
Jul 19 21:28:37 pro69 kernel:  ? __pfx_transaction_kthread+0x10/0x10
Jul 19 21:28:37 pro69 kernel:  kthread+0xe4/0x120
Jul 19 21:28:37 pro69 kernel:  ? __pfx_kthread+0x10/0x10
Jul 19 21:28:37 pro69 kernel:  ret_from_fork+0x2a7/0x330
Jul 19 21:28:37 pro69 kernel:  ? __pfx_kthread+0x10/0x10
Jul 19 21:28:37 pro69 kernel:  ret_from_fork_asm+0x1a/0x30
Jul 19 21:28:37 pro69 kernel:  </TASK>
Jul 19 21:28:37 pro69 kernel: ---[ end trace 0000000000000000 ]---
Jul 19 21:28:37 pro69 kernel: BTRFS: error (device sde state A) in 
cleanup_transaction:2067: errno=-11 unknown
Jul 19 21:28:37 pro69 kernel: BTRFS info (device sde state EA): forced 
readonly
Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA): 
cow_file_range failed, root=5 inode=268 start=68295892992 len=688128 
cur_offset=68295892992 cur_alloc_size=0: -30
Jul 19 21:29:08 pro69 kernel: writepage_delalloc: 383 callbacks suppressed
Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA): failed 
to run delalloc range, root=5 ino=268 folio=68295892992 submit_bitmap=0 
start=68295892992 len=688128: -30

the full dmesg can be retreived if interested.

HAN Yuwei

