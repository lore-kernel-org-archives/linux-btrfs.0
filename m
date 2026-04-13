Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20E314D26
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102788; cv=none; b=KAXc7dP2aPW5nDu9xu67b7mQ96GdslNK4D6QxildsDY8zrjoXL0B48+F/CBL6zQlhPwJnhVMfIOaDynNCNQH4IcDvc2/SfDx64umTFBRQ6UdMtYa0d5FRIJMh6Zf1vanyEC1YIubg4H3gKNsns3ekhZpr7ZGrxayKT7SSq1VWLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102788; c=relaxed/simple;
	bh=iQmM+0EYE3y1uBbG4KceER9DRW5xBH4fDES5Aoz7Xho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UH295bo0c2A3JNxvR/06uZ32D+uJkXaCdeoX37yMbKyjLw01ceJSvmUZ3qc/KTjHbzO4vQvGv8g9Uvz62jrPnqPtIPDyfY471YU/RUglDvJehn5V4NiA+br3ZRdlZ3+I8MttDyqGMmjgwcanuw/mouKjEjYAVH4KKCmbWsq+M7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=cMGuiHmf; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="cMGuiHmf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=T+i0R8P94kntkj0cy/ZSmMTMvCLwH1CXXA/2owoUkzk=; b=cMGuiHmf3EhW8aNgGxBxjyS3Dy
	4+jiYBkAQULATB+5CcwNXL4ZK9ak9T60iGGkqr1gX0cIk7zaTX8MJ3w2zvoSJdU6hvd9nJIp5nJnt
	NkpL/mC345oYF0f4X96MDceluKd+ZHozK+l3DKnFQpu3c+Mu/8Ty+nFq3W7zgzwz5WT/2+61GR0/+
	syY2zjjMqGg+cfeGdTJH97vym/oKtlQJN6HjSXMR325TBLEkAd4ThYHVYamaQplFpzX2SlUBnijs1
	9IRn57K1h3FZZbKIRtVduADWIn8jhiBr1v4Qva4vOTm/fep1Bq7pcaDIp2Mpd5m9H2CcMiwZaP09/
	Zdm2a1wQ==;
Received: from [24.6.49.44] (port=35578 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCLSx-0000000DCBP-0ppd by authid <merlins.org> with srv_auth_plain;
	Mon, 13 Apr 2026 10:52:55 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wCLSv-004ixO-2P;
	Mon, 13 Apr 2026 10:52:53 -0700
Date: Mon, 13 Apr 2026 10:52:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <ad0tdWyavEngGlQ-@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <adnBhWfJQ1n3hZC8@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

TL;DR: do I need to urgently disable simple quotas on all my fileystems
until I can upgrade to a confirmed fixed kernel?

Oh no, now it's my 2nd system with a btrfs crash, just days after I
enabled block-group-tree and simple quotas. This one is a simple
laptop without raid, and its backup filesystem crashed overnight likely
during balance (btrfs send/receive and snapshots, same than first one
below) crashed overnight.

First kernel was 6.12 which I can't upgrade, it's an rPi5 with vendor
kernels with special hardware support that's out of tree I think.
This one is kernel is 6.17.11 whic I will upgrade to 6.19.11+deb14 now
but I have no idea if it fixes anything.

I can't read the code or ooops outside of noticing the same exact
do_free_extent_accounting which can't be a coincidence.

I was able to rescue it with
merlin:~# mount -o rw,enospc_debug,skip_balance  LABEL=3Dbtrfs_pool3 /mnt/b=
trfs_pool3
merlin:~# btrfs quota disable  /mnt/btrfs_pool3
merlin:~# umount /mnt/btrfs_pool3
merlin:~# mount /mnt/btrfs_pool3

I'll reboot with the new kernel now, but I'm also now scared of simple quot=
as
since it's 2 crashes in 3 days, one seems not posislbe to recover from and =
a multi
week restore.
Suggestions welcome.

Possible analysis (could be wrong):
* __btrfs_free_extent & btrfs_qgroup_cleanup_dropped_subvolume:
Your btrfs-cleaner thread was in the middle of deleting an old snapshot. As=
 it
was freeing the blocks (extents), it attempted to update the quota accounti=
ng
for that subvolume.
* failed to cleanup qgroup 0/83288: -2: The kernel tried to find the quota
group record for the subvolume being deleted, but the record was missing
or corrupted. To protect the filesystem, Btrfs panicked and locked
itself read-only.

------------[ cut here ]------------
BTRFS: Transaction aborted (error -2)
WARNING: CPU: 7 PID: 2987 at fs/btrfs/extent-tree.c:2999 __btrfs_free_exten=
t.isra.0+0xc41/0x1020 [btrfs

Modules linked in: ftdi_sio usbserial ufs qnx4 hfsplus hfs cdrom minix msdo=
s jfs nls_ucs2_utils xfs rpc
v4 dns_resolver nfs netfs rfcomm xt_tcpudp snd_seq_dummy snd_hrtimer xt_con=
ntrack nf_conntrack_netlink=20
lgo xt_addrtype br_netfilter bridge stp llc ccm qrtr overlay cmac algif_has=
h algif_skcipher af_alg bnep
JECT nf_reject_ipv4 xt_MASQUERADE xt_LOG nf_log_syslog nft_compat nft_chain=
_nat nf_nat nf_conntrack nf_
efrag_ipv4 nf_tables binfmt_misc nls_ascii nls_cp437 vfat fat snd_soc_sof_s=
dw snd_soc_sdw_utils vboxdrv
11_sdca snd_soc_rt715_sdca snd_soc_rt1316_sdw dell_pc regmap_sdw_mbq platfo=
rm_profile snd_hda_codec_int
mic regmap_sdw kvm snd_hda_intel btusb snd_sof_pci_intel_tgl iwlmvm snd_sof=
_pci_intel_cnl btrtl irqbypa
_hda_generic uvcvideo btintel soundwire_intel btbcm soundwire_generic_alloc=
ation videobuf2_vmalloc snd_
w_bpt btmtk uvc videobuf2_memops mac80211 snd_sof_intel_hda_common
 videobuf2_v4l2 bluetooth snd_soc_hdac_hda videodev snd_sof_intel_hda_mlink=
 videobuf2_common intel_uncore_frequency snd_sof_intel_hda libarc4 snd_hda_=
codec_hdmi snd_sof_pci intel_uncore_frequency_common mc ecdh_generic mei_hd=
cp soundwire_cadence snd_sof_xtensa_dsp mei_pxp ext4 x86_pkg_temp_thermal c=
rc8 intel_rapl_msr processor_thermal_device_pci intel_powerclamp hid_sensor=
_als dell_laptop iwlwifi soundwire_bus processor_thermal_device dell_wmi hi=
d_sensor_trigger processor_thermal_wt_hint rapl hid_sensor_iio_common platf=
orm_temperature_control snd_soc_avs industrialio_triggered_buffer crc16 snd=
_sof_probes processor_thermal_rfim intel_cstate iTCO_wdt mbcache dell_smbio=
s kfifo_buf squashfs jbd2 loop dcdbas intel_uncore cfg80211 dell_smm_hwmon =
dell_wmi_sysman dell_wmi_ddv dell_wmi_descriptor firmware_attributes_class =
pcspkr snd_sof processor_thermal_rapl industrialio intel_pmc_bxt wmi_bmof s=
nd_soc_hda_codec ucsi_acpi mei_me spd5118 iTCO_vendor_support intel_rapl_co=
mmon snd_hda_ext_core snd_sof_utils typec_ucsi
 snd_intel_dspcfg watchdog mei processor_thermal_wt_req snd_intel_sdw_acpi =
rfkill intel_pmc_core typec processor_thermal_power_floor snd_soc_skl_hda_d=
sp igen6_edac processor_thermal_mbox roles int3403_thermal pmt_telemetry sn=
d_soc_intel_sof_board_helpers int340x_thermal_zone snd_soc_acpi_intel_match=
 pmt_discovery joydev snd_soc_acpi_intel_sdca_quirks pmt_class snd_soc_acpi=
 int3400_thermal intel_hid intel_pmc_ssram_telemetry snd_soc_sdca acpi_ther=
mal_rel sparse_keymap acpi_tad acpi_pad ac serio_raw snd_soc_core evdev snd=
_compress snd_pcm_dmaengine snd_soc_intel_hda_dsp_common snd_hda_codec snd_=
hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_m=
idi_event snd_seq snd_timer snd_rawmidi snd_seq_device snd_ctl_led snd soun=
dcore ac97_bus coretemp nfsd msr ecryptfs auth_rpcgss nvme_fabrics nfs_acl =
lockd efi_pstore grace sunrpc nfnetlink ip_tables x_tables autofs4 crc32c_c=
ryptoapi essiv authenc btrfs blake2b_generic dm_crypt dm_mod efivarfs raid1=
0 raid456 async_raid6_recov async_memcpy
 async_pq async_xor async_tx xor raid6_pq raid1 raid0 md_mod sata_sil24 lib=
ata scsi_mod scsi_common e1000e r8169 realtek mdio_devres libphy mdio_bus m=
ii xe configfs drm_gpusvm_helper drm_suballoc_helper hid_sensor_custom hid_=
sensor_hub intel_ishtp_hid nouveau mxm_wmi drm_gpuvm i915 gpu_sched drm_bud=
dy drm_ttm_helper hid_multitouch ttm drm_exec i2c_algo_bit hid_generic drm_=
display_helper xhci_pci cec xhci_hcd rc_core nvme rtsx_pci_sdmmc i2c_hid_ac=
pi intel_lpss_pci drm_client_lib i2c_hid nvme_core mmc_core intel_lpss usbc=
ore video nvme_keyring i2c_i801 intel_ish_ipc drm_kms_helper hid ghash_clmu=
lni_intel psmouse rtsx_pci thunderbolt intel_ishtp intel_vsec idma64 button=
 usb_common i2c_smbus nvme_auth battery drm wmi aesni_intel
CPU: 7 UID: 0 PID: 2987 Comm: btrfs-cleaner Tainted: G     U     OE       6=
=2E17.11+deb14-amd64 #1 PREEMPT(lazy)  Debian 6.17.11-1=20
Tainted: [U]=3DUSER, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: Dell Inc. XPS 17 9730/0JP3YK, BIOS 1.23.0 09/04/2025
RIP: 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs]
Code: ff ff 48 c7 c7 d8 ac 98 c1 e8 ab 7a 6c e4 0f 0b c6 44 24 2f 01 e9 22 =
8a 0e 00 8b 74 24 10 48 c7 c7 d8 ac 98 c1 e8 8f 7a 6c e4 <0f> 0b e9 50 ff f=
f ff 48 8b 34 24 48 8b 76 60 48 89 74 24 08 48 8d
RSP: 0000:ffffd372a10cfb40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000124f8b48000 RCX: 0000000000000027
RDX: ffff8d4d0f3dce48 RSI: 0000000000000001 RDI: ffff8d4d0f3dce40
RBP: 0000000000004000 R08: 0000000000000000 R09: ffffd372a10cf9e0
R10: ffff8d4d4f745068 R11: 00000000ffffdfff R12: 0000000000000000
R13: 000000000000002b R14: 00000000000039c1 R15: ffff8d4b42451930
FS:  0000000000000000(0000) GS:ffff8d4d669c8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563efa2028b8 CR3: 0000000ce5c2c006 CR4: 0000000000f70ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __btrfs_run_delayed_refs+0x2dc/0xf70 [btrfs]
 ? read_block_for_search+0x19e/0x400 [btrfs]
 ? set_extent_buffer_dirty+0x26/0x200 [btrfs]
 btrfs_run_delayed_refs+0x39/0x140 [btrfs]
 btrfs_commit_transaction+0x6d/0xdf0 [btrfs]
 btrfs_qgroup_cleanup_dropped_subvolume+0x49/0xb0 [btrfs]
 btrfs_drop_snapshot+0x78e/0xcc0 [btrfs]
 ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
 btrfs_clean_one_deleted_snapshot+0xc2/0x130 [btrfs]
 cleaner_kthread+0xdc/0x160 [btrfs]
 ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
 kthread+0xf9/0x240
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x194/0x1c0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
---[ end trace 0000000000000000 ]---
BTRFS: error (device dm-4 state A) in do_free_extent_accounting:2999: errno=
=3D-2 No such entry
BTRFS info (device dm-4 state EA): forced readonly
BTRFS error (device dm-4 state EA): failed to run delayed ref for logical 1=
258303029248 num_bytes 16384 type 176 action 2 ref_mod 1: -2
BTRFS: error (device dm-4 state EA) in btrfs_run_delayed_refs:2161: errno=
=3D-2 No such entry
BTRFS warning (device dm-4 state EA): failed to cleanup qgroup 0/83288: -2



On Fri, Apr 10, 2026 at 08:35:33PM -0700, Marc MERLIN wrote:
>=20
> It started with:
> [23345.326321] BTRFS: error (device dm-0 state A) in do_free_extent_accou=
nting:2996: errno=3D-2 No such entry
> [23345.336394] BTRFS error (device dm-0 state EA): failed to run delayed =
ref for logical 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1:=
 -2
> [23345.350299] BTRFS: error (device dm-0 state EA) in btrfs_run_delayed_r=
efs:2215: errno=3D-2 No such entry
> [23345.360154] BTRFS warning (device dm-0 state EA):
>=20
> I ended up with:
>=20
> moremagic:~# mount -t btrfs -o rw,skip_balance,space_cache=3Dv2,clear_cac=
he /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
> BTRFS: device label DS6 devid 1 transid 296950 /dev/mapper/crypt_bcache0 =
(251:0) scanned by mount (6029)
> BTRFS info (device dm-0): first mount of filesystem a97dec85-a0d5-42ab-a0=
ef-e9b7479fbe43
> BTRFS info (device dm-0): using crc32c (crc32c-generic) checksum algorithm
> BTRFS warning (device dm-0): read-write for sector size 4096 with page si=
ze 16384 is experimental
> BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0=
, flush 0, corrupt 5074, gen 0
> ------------[ cut here ]------------
> BTRFS: Transaction aborted (error -2)
> WARNING: CPU: 3 PID: 6029 at fs/btrfs/extent-tree.c:2996 __btrfs_free_ext=
ent.isra.0+0x13a0/0x14a0 [btrfs]
> Modules linked in: dm_crypt dm_mod bcache raid456 async_raid6_recov async=
_memcpy async_pq async_xor async_tx xt_MASQUERADE ipt_REJECT nf_reject_ipv4=
 xt_tcpudp xt_conntrack xt_LOG nf_log_syslog nft_compat nft_chain_nat nf_na=
t nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm algif_hash al=
gif_skcipher af_alg bnep cp210x brcmfmac_wcc binfmt_misc usbserial hci_uart=
 brcmfmac btbcm vc4 snd_soc_hdmi_codec brcmutil bluetooth drm_display_helpe=
r cfg80211 cec drm_dma_helper rpi_hevc_dec ecdh_generic v4l2_mem2mem ecc sn=
d_soc_core pisp_be videobuf2_dma_contig v3d videobuf2_memops videobuf2_v4l2=
 gpu_sched rfkill videodev drm_shmem_helper snd_compress snd_pcm_dmaengine =
snd_pcm videobuf2_common rp1_pio snd_timer snd drm_kms_helper mc raspberryp=
i_gpiomem rp1_fw sg sch_fq_codel ecryptfs fuse drm drm_panel_orientation_qu=
irks backlight nfnetlink ip_tables x_tables raid1 aes_ce_blk aes_ce_cipher =
ghash_ce gf128mul libaes sha2_ce spidev sha256_arm64 sha1_ce raspberrypi_hw=
mon sha1_generic ahci i2c_brcmstb spi_bcm2835
>  md_mod gpio_keys libahci pwm_fan rp1_adc libata rp1_mailbox nvmem_rmem u=
io_pdrv_genirq uio btrfs blake2b_generic xor xor_neon raid6_pq zram lz4_com=
press ipv6
> CPU: 3 UID: 0 PID: 6029 Comm: mount Not tainted 6.12.47+rpt-rpi-2712 #1  =
Debian 1:6.12.47-1+rpt1
> Hardware name: Raspberry Pi 5 Model B Rev 1.1 (DT)
> pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
> lr : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
> sp : ffffc000868bb680
> x29: ffffc000868bb720 x28: 0000000000000000 x27: 0000000000002f02
> x26: 000000000000007f x25: ffff8001de833aa0 x24: 0000000000004000
> x23: 0000000000000000 x22: ffff800102b64e70 x21: 0000000000004000
> x20: 00000e1a4bb88000 x19: 00000000fffffffe x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: 00000000000000c0 x10: 0000000000001a40 x9 : ffffd06fce4e06c0
> x8 : ffff80011f56e0a0 x7 : 000000042f72a7bd x6 : 0000000000000039
> x5 : 0000000000000001 x4 : 0000000000001ab0 x3 : 0000000000000804
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff80011f56c600
> Call trace:
>  __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
>  __btrfs_run_delayed_refs+0x508/0xec0 [btrfs]
>  btrfs_run_delayed_refs+0x48/0x198 [btrfs]
>  btrfs_commit_transaction+0x88/0xe20 [btrfs]
>  btrfs_recover_relocation+0x55c/0x5d0 [btrfs]
>  btrfs_start_pre_rw_mount+0x1d4/0x470 [btrfs]
>  open_ctree+0x101c/0x13b8 [btrfs]
>  btrfs_get_tree+0x5b4/0x800 [btrfs]
>  vfs_get_tree+0x30/0x108
>  fc_mount+0x20/0x68
>  btrfs_get_tree+0x238/0x800 [btrfs]
>  vfs_get_tree+0x30/0x108
>  vfs_cmd_create+0x58/0xf8
>  __arm64_sys_fsconfig+0x444/0x5b8
>  invoke_syscall+0x50/0x120
>  el0_svc_common.constprop.0+0x48/0xf0
>  do_el0_svc+0x24/0x38
>  el0_svc+0x30/0xf8
>  el0t_64_sync_handler+0x120/0x130
>  el0t_64_sync+0x190/0x198
> ---[ end trace 0000000000000000 ]---
> BTRFS: error (device dm-0 state A) in do_free_extent_accounting:2996: err=
no=3D-2 No such entry
> BTRFS error (device dm-0 state EA): failed to run delayed ref for logical=
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2
> BTRFS: error (device dm-0 state EA) in btrfs_run_delayed_refs:2215: errno=
=3D-2 No such entry
> BTRFS warning (device dm-0 state EA): failed to recover relocation: -2
> BTRFS error (device dm-0 state EA): commit super ret -30
> BTRFS error (device dm-0 state EA): open_ctree failed: -2
>=20
>=20
> Gemini said
>=20
> The Btrfs "Ghost" Accounting When you added discard=3Dasync to your fstab
> (or remounted with it), you told the Btrfs kernel module to start a speci=
fic
> background thread.
> Btrfs's Perspective: "The user told me to use async discard. I will now s=
tart a
> list of every extent we delete so I can 'trim' them later in the backgrou=
nd."
> The Problem: Btrfs doesn't check if the underlying dm-crypt device actual=
ly
> supports discards before it starts its own internal accounting.
> The Result: Btrfs started tracking a massive list of "extents to be disca=
rded"
> in its memory and metadata.
>=20
> 2. The "No Such Entry" (-2) Race Condition The crash didn't happen becaus=
e a
> command hit a drive; it happened because of a logic race inside the kerne=
l's
> Btrfs code:
> The Balance Thread: You were running a balance. This thread moves data fr=
om "Old
> Block A" to "New Block B."
> The Discard Thread: Because discard=3Dasync was on, the discard thread sa=
w "Old
> Block A" get freed. It put "Old Block A" on its "to-do list."
> The Metadata Conflict: The balance thread finished moving the data and
> successfully deleted the reference to "Old Block A" from the extent tree.
> The Crash: A few milliseconds later, the async discard thread woke up and=
 tried
> to "pin" or "process" the metadata for "Old Block A." It looked in the tr=
ee,
> found nothing (because the balance already deleted it), and threw an ENOE=
NT
> (Error -2: No such entry).
> Btrfs panicked: "Wait, I was told to discard this block, but it doesn't e=
xist in
> my records anymore! Something is inconsistent!" =E2=86=92 Transaction Abo=
rt.
>=20
> more details:
> backuproot didn't work (read write)
> I was forced to run
> btrfstune --convert-from-block-group-tree /dev/mapper/crypt_bcache0
> because
> When you ran btrfs check --clear-space-cache v2, the tool did exactly
> what it was supposed to do: it deleted the Free Space Tree and removed
> the FREE_SPACE_TREE flag from your superblock.
> The Conflict: Your 23TB array was formatted with the modern
> block-group-tree feature (which speeds up mounting).
> The Kernel Rule: The Btrfs kernel code explicitly dictates: If the Block
> Group Tree is enabled, the Free Space Tree MUST also be enabled. * The
> Crash: Because the FREE_SPACE_TREE flag is now missing, the kernel sees
> an "illegal" superblock state and throws a fatal -22 error, refusing to
> proceed to the mount options.
>=20
> This was vexing, hours lost removing the block group tree.
> and when it was finally finished,=20
> mount -t btrfs -o skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_bigba=
ckup/
> did run, but crashed as above
>=20
> Now doing a repair in case it can salvage things.
>=20
> Marc
> --=20
> "A mouse is a device used to point at the xterm you want to type in" - A.=
S.R.
> =20
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27=
AAF9D08
>=20

--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
=20
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AA=
F9D08
