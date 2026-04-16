Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B3A3290D2
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776360110; cv=none; b=M93PEJPqrrwLcQRIfILCPbYN5Fvvi0YniAoGbvh4IQk9M1PZQGoRHAOIgnXEcaOOXSgpnCF/hBIoUQGRp5VZ4xB4cln9t7qZfk/ABTYstn5Yv13YvCqaQqLVnhAey6oJsmP3Ut7yp+WIxxIJqDFVWx+xDJDRg2ivysRPdOWMJcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776360110; c=relaxed/simple;
	bh=7Irtw796ZOk0sXNIsFGrR+EzATVP9AiEJt9TpMt1SZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG+htNiugwp1PtpPrJrTRrCl5wtDUveqGvRA6hyyqA9pzjloj5cWPSZ2xMTAhR8Fyin08IdCWHrLQbPjZXBJl/8Z+W0cSDF70DSDMKeH53+88BsKOtPGBRGJmz7tLJ+tr7z+dbJgqhFhDw+PLZlUVAfAXU/1vOmSWnemluUUECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=gDn+tsuS; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="gDn+tsuS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=29K+gzpj1QyvcGxuMSNlQXJusn09HiLBWsTuRNd51dM=; b=gDn+tsuSG9/OkPvcZ7AfeiqBaG
	hIush7nS4zd+cVAgqWXdJfWSithAwhsHJMy1Upi0Gz/p91ktV8ARN138AcPk/sdyDM9EWxmjUKCiG
	OX86HMn/dFNFmdLqxtEPzH2WATXUReOAEJabq/dyHClWtJNa8n9PbXynbyYFPUezlfp3IVsnugfl4
	vG45Hd2ZPvsMCPSvohn93Magt8MWw3+RMzomCkjbEB2vmy8XXR6iZTLkPIVgiD8vjzVlWWbaNEQz5
	mphD2Io2+Lbs7D7sCxedyp7vl8SBgH5Xrwp6i+q8IaCJzqZ+LJ7NFx8MeER40KeDZZYD24OSlMYzz
	n8HX7+HA==;
Received: from [24.6.49.44] (port=47296 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDQPR-0000000CmOg-48dv by authid <merlins.org> with srv_auth_plain;
	Thu, 16 Apr 2026 10:21:45 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDQPQ-0018ZW-1m;
	Thu, 16 Apr 2026 10:21:44 -0700
Date: Thu, 16 Apr 2026 10:21:44 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aeEaqCJAWaWbz1vO@merlins.org>
References: <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260416012535.GB1065998@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

No help needed, just showing it happened overnight with balance and squota =
in 6.19
on my laptop. It looks like squota and balance are simply not compatible un=
til the
fix for squota, lands.
Now that I know more, I rescued the FS and removed squota on my own and it'=
s good again.

It looks pretty clear that btrfs balance seems to trigger the bug in
squota:
[37930.185472] BTRFS info (device dm-3): balance: start -dusage=3D20
[37930.187010] BTRFS info (device dm-3): relocating block group 45024983121=
92 flags data
[37930.417388] BTRFS info (device dm-3): found 83 extents, stage: move data=
 extents
[37930.896615] BTRFS info (device dm-3): found 83 extents, stage: update da=
ta pointers
[37931.311770] BTRFS info (device dm-3): relocating block group 45014245703=
68 flags data
[37931.355759] BTRFS info (device dm-3): found 11 extents, stage: move data=
 extents
[37931.501741] BTRFS info (device dm-3): found 11 extents, stage: update da=
ta pointers
[37931.507435] BTRFS: Transaction aborted (error -2)
[37931.508762] BTRFS: error (device dm-3 state A) in do_free_extent_account=
ing:3002: errno=3D-2 No such entry
[37931.508766] BTRFS info (device dm-3 state EA): forced readonly
[37931.508769] BTRFS error (device dm-3 state EA): failed to run delayed re=
f for logical 907535646720 num_bytes 16384 type 182 action 2 ref_mod 1: -2
[37931.508773] BTRFS: error (device dm-3 state EA) in btrfs_run_delayed_ref=
s:2166: errno=3D-2 No such entry
[37931.508798] BTRFS info (device dm-3 state EA): balance: ended with statu=
s: -2

[37931.507428] ------------[ cut here ]------------
[37931.507435] BTRFS: Transaction aborted (error -2)
[37931.507438] WARNING: fs/btrfs/extent-tree.c:3002 at __btrfs_free_extent.=
isra.0+0xdf6/0xfe0 [btrfs], CPU#0: btrfs/153883
[37931.507519] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs ne=
tfs sd_mod sg uas usb_storage uinput nf_conntrack_netlink xfrm_user xfrm_al=
go xt_addrtype br_netfilter bridge stp llc xt_tcpudp xt_conntrack ccm rfcom=
m snd_seq_dummy snd_hrtimer overlay ipt_REJECT nf_reject_ipv4 xt_MASQUERADE=
 xt_LOG nf_log_syslog nft_compat nft_chain_nat nf_nat nf_conntrack nf_defra=
g_ipv6 nf_defrag_ipv4 qrtr nf_tables cmac algif_hash algif_skcipher af_alg =
bnep binfmt_misc uvcvideo btusb videobuf2_vmalloc btmtk uvc videobuf2_memop=
s btrtl videobuf2_v4l2 btbcm btintel videodev videobuf2_common bluetooth mc=
 ftdi_sio ecdh_generic usbserial nls_ascii nls_cp437 vfat fat ext4 crc16 mb=
cache squashfs jbd2 loop intel_uncore_frequency intel_uncore_frequency_comm=
on x86_pkg_temp_thermal iwlmvm intel_powerclamp snd_hda_codec_intelhdmi kvm=
_intel snd_hda_codec_alc269 snd_hda_scodec_component snd_hda_codec_realtek_=
lib mac80211 snd_hda_codec_generic kvm snd_soc_dmic rtsx_pci_sdmmc mmc_core=
 libarc4 snd_sof_pci_intel_tgl irqbypass mei_hdcp mei_pxp
[37931.507593]  intel_rapl_msr snd_sof_pci_intel_cnl rapl intel_cstate snd_=
sof_intel_hda_generic soundwire_intel snd_sof_pci snd_sof_xtensa_dsp snd_so=
f_intel_hda_sdw_bpt processor_thermal_device_pci_legacy iwlwifi intel_uncor=
e think_lmi snd_sof_intel_hda_common iTCO_wdt snd_soc_sdw_utils processor_t=
hermal_device processor_thermal_wt_hint intel_pmc_bxt snd_soc_hdac_hda firm=
ware_attributes_class snd_hda_intel platform_temperature_control wmi_bmof i=
TCO_vendor_support snd_sof_intel_hda_mlink processor_thermal_soc_slider snd=
_soc_avs cfg80211 processor_thermal_rfim ee1004 snd_sof_intel_hda processor=
_thermal_rapl watchdog pcspkr snd_soc_hda_codec rtsx_pci snd_hda_codec_hdmi=
 intel_rapl_common ucsi_acpi processor_thermal_wt_req typec_ucsi mei_me sou=
ndwire_cadence processor_thermal_power_floor mei snd_hda_ext_core typec sou=
ndwire_generic_allocation processor_thermal_mbox crc8 roles soundwire_bus t=
hinkpad_acpi intel_soc_dts_iosf snd_sof_probes nvram platform_profile int34=
03_thermal snd_sof rfkill int340x_thermal_zone ac
[37931.507644]  intel_pmc_core snd_sof_utils pmt_telemetry snd_intel_dspcfg=
 pmt_discovery pmt_class snd_intel_sdw_acpi int3400_thermal joydev intel_hi=
d intel_pmc_ssram_telemetry sparse_keymap snd_soc_skl_hda_dsp acpi_thermal_=
rel snd_soc_intel_sof_board_helpers acpi_pad button acpi_tad snd_soc_acpi_i=
ntel_match evdev snd_soc_acpi_intel_sdca_quirks snd_soc_acpi serio_raw snd_=
soc_sdca snd_soc_core snd_compress snd_pcm_dmaengine snd_soc_intel_hda_dsp_=
common snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_p=
cm snd_seq_midi snd_seq_midi_event snd_seq snd_timer snd_rawmidi snd_seq_de=
vice snd_ctl_led snd nfsd soundcore ac97_bus coretemp auth_rpcgss msr ecryp=
tfs nfs_acl lockd grace efi_pstore sunrpc nfnetlink ip_tables x_tables auto=
fs4 crc32c_cryptoapi essiv authenc btrfs blake2b libblake2b dm_crypt dm_mod=
 efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor =
async_tx xor raid6_pq raid1 raid0 md_mod sata_sil24 libata scsi_mod scsi_co=
mmon e1000e r8169 realtek mii xe intel_vsec drm_gpuvm
[37931.507715]  configfs drm_gpusvm_helper gpu_sched drm_ttm_helper drm_exe=
c drm_suballoc_helper hid_generic usbhid hid i915 drm_buddy ttm i2c_algo_bi=
t drm_display_helper xhci_pci cec nvme xhci_hcd rc_core nvme_core drm_clien=
t_lib usbcore drm_kms_helper nvme_keyring video i2c_i801 ghash_clmulni_inte=
l psmouse i2c_smbus nvme_auth igc hkdf drm thunderbolt usb_common battery w=
mi aesni_intel
[37931.507761] CPU: 0 UID: 0 PID: 153883 Comm: btrfs Tainted: G S   U      =
        6.19.11+deb14-amd64 #1 PREEMPT(lazy)  Debian 6.19.11-1=20
[37931.507765] Tainted: [S]=3DCPU_OUT_OF_SPEC, [U]=3DUSER
[37931.507767] Hardware name: LENOVO 20YU002JUS/20YU002JUS, BIOS N37ET61W (=
1.97 ) 09/17/2025
[37931.507769] RIP: 0010:__btrfs_free_extent.isra.0+0xdfa/0xfe0 [btrfs]
[37931.507830] Code: 48 c7 c6 50 e1 a0 c1 48 8b 78 60 e8 30 80 0f 00 e8 4b =
e9 62 d9 44 88 6c 24 2f e9 98 aa 0e 00 48 8d 3d 6a 49 f4 ff 8b 74 24 14 <67=
> 48 0f b9 3a e9 ef fd ff ff 48 8d 3d 65 49 f4 ff 8b 74 24 14 67
[37931.507833] RSP: 0018:ffffcc4b75297800 EFLAGS: 00010206
[37931.507836] RAX: 000000000000001c RBX: 000000d34d570000 RCX: ffff891a045=
02000
[37931.507838] RDX: 0000000000000000 RSI: 00000000fffffffe RDI: ffffffffc17=
6e990
[37931.507840] RBP: 0000000000000000 R08: ffff89275fe8e2d0 R09: ffff89275fe=
8e2d0
[37931.507842] R10: ffff891a04502000 R11: 0000000000000011 R12: 00000000000=
04000
[37931.507843] R13: 0000000000000000 R14: ffff892b31377380 R15: 00000000000=
00010
[37931.507845] FS:  00007fa538c1d3c0(0000) GS:ffff893951da7000(0000) knlGS:=
0000000000000000
[37931.507847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37931.507849] CR2: 00003c840b875500 CR3: 00000010f962b005 CR4: 0000000000f=
70ef0
[37931.507851] PKRU: 55555554
[37931.507853] Call Trace:
[37931.507856]  <TASK>
[37931.507862]  __btrfs_run_delayed_refs+0x2e3/0xfb0 [btrfs]
[37931.507915]  ? need_preemptive_reclaim+0x36/0x190 [btrfs]
[37931.507976]  ? reserve_bytes+0x177/0x4a0 [btrfs]
[37931.508032]  btrfs_run_delayed_refs+0x3b/0x120 [btrfs]
[37931.508085]  btrfs_commit_transaction+0x6a/0xd50 [btrfs]
[37931.508142]  ? btrfs_init_metadata_block_rsv+0x28/0x40 [btrfs]
[37931.508200]  ? start_transaction+0x228/0x840 [btrfs]
[37931.508256]  prepare_to_relocate+0x135/0x1d0 [btrfs]
[37931.508323]  relocate_block_group+0x6b/0x530 [btrfs]
[37931.508382]  btrfs_relocate_block_group+0x26e/0x3d0 [btrfs]
[37931.508439]  btrfs_relocate_chunk+0x44/0x170 [btrfs]
[37931.508504]  btrfs_balance+0xa5b/0x1640 [btrfs]
[37931.508568]  btrfs_ioctl+0x28ac/0x2dd0 [btrfs]
[37931.508635]  ? kmem_cache_free+0x508/0x550
[37931.508640]  ? dput.part.0+0x27/0x110
[37931.508643]  ? __x64_sys_close+0x3d/0x80
[37931.508647]  __x64_sys_ioctl+0x97/0xe0
[37931.508651]  do_syscall_64+0x81/0x5e0
[37931.508656]  ? syscall_exit_work+0x143/0x1b0
[37931.508665]  ? do_syscall_64+0xbe/0x5e0
[37931.508671]  ? syscall_exit_work+0x143/0x1b0
[37931.508674]  ? do_syscall_64+0xbe/0x5e0
[37931.508676]  ? kernfs_fop_llseek+0x78/0xc0
[37931.508682]  ? syscall_exit_work+0x143/0x1b0
[37931.508685]  ? do_syscall_64+0xbe/0x5e0
[37931.508687]  ? clear_bhb_loop+0x50/0xa0
[37931.508690]  ? clear_bhb_loop+0x50/0xa0
[37931.508692]  ? clear_bhb_loop+0x50/0xa0
[37931.508695]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[37931.508697] RIP: 0033:0x7fa538d3ad3b
[37931.508741] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89=
> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[37931.508744] RSP: 002b:00007fff72a15140 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[37931.508747] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa538d=
3ad3b
[37931.508749] RDX: 00007fff72a15228 RSI: 00000000c4009420 RDI: 00000000000=
00003
[37931.508750] RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000000=
00000
[37931.508752] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff72a=
15228
[37931.508753] R13: 00007fff72a15bd8 R14: 00007fff72a17da5 R15: 00000000000=
00001
[37931.508756]  </TASK>
[37931.508758] ---[ end trace 0000000000000000 ]---
[37931.508762] BTRFS: error (device dm-3 state A) in do_free_extent_account=
ing:3002: errno=3D-2 No such entry
[37931.508766] BTRFS info (device dm-3 state EA): forced readonly
[37931.508769] BTRFS error (device dm-3 state EA): failed to run delayed re=
f for logical 907535646720 num_bytes 16384 type 182 action 2 ref_mod 1: -2
[37931.508773] BTRFS: error (device dm-3 state EA) in btrfs_run_delayed_ref=
s:2166: errno=3D-2 No such entry

sauron:/boot# mount /dev/mapper/pool4 /mnt/btrfs_pool4
[65964.162801] BTRFS error (device dm-3 state EMA): remounting read-write a=
fter error is not allowed

For google and people who find that thread, the quicker recovery is:
sauron:/mnt/btrfs_pool3# btrfs rescue clear-ino-cache  /dev/mapper/pool4
(...)
Successfully cleaned up ino cache for root id: 108518
Successfully cleared ino cache
sauron:/mnt/btrfs_pool3# mount -o rw,clear_cache,enospc_debug,skip_balance =
LABEL=3Dbtrfs_pool4 /mnt/btrfs_pool4
sauron:/mnt/btrfs_pool3# btrfs quota disable /mnt/btrfs_pool4

sauron:/mnt/btrfs_pool3# mount /dev/mapper/pool4 /mnt/btrfs_pool4
sauron:/mnt/btrfs_pool3# cd /mnt/btrfs_pool4
sauron:/mnt/btrfs_pool4# btrfs balance start -dusage=3D20  `pwd`
Done, had to relocate 0 out of 2008 chunks
sauron:/mnt/btrfs_pool4#=20

btrfs tune would have likely also worked to remove squota, but the trick
after that is mounting with skip_balance or otherwise, even after quota
removal, balance restarts right away and puts the FS read only again
if squota isn't disabled first.

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
=20
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AA=
F9D08
