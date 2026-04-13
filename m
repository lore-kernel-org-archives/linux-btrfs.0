Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7737DA66
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106075; cv=none; b=Y2I51iqVFJwQCsNAKqrQ81GKwz5lracGxZgK3JY1uEYJrNd0qngZnlTgitkgXVLJ097ZSAJoxsmxp9ttpRWN/NRe12isw8G5bSbxNCgJblb9WP7e+puIenF76ysLx3FxZdt/zYlxGjFn/x4LvE5J+xpNrN421sJGHJIwg3XqRUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106075; c=relaxed/simple;
	bh=RS/MoPHscFcJ5r6hWJtyuiYpf+31iCJsOzcgJNggIIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8mA5AzjBKSD9vfmKV2wG1b7hnWlsIAz27/L4/txCmVWZ+ovc875dehCeAe/q1NFNRqqgcMcBQZYrfRrW8a9LIg8um+D9WY6zeM+M7TykqX3sQvlAsx/0v4ip5UAW0vFdgEtVJ4q6YwInGPuTtVstkGQpj3qrn/psLC2hcbGbfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=m8zJUbjk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rjiWTEHv; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="m8zJUbjk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rjiWTEHv"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 351B81400166;
	Mon, 13 Apr 2026 14:47:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 13 Apr 2026 14:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1776106072;
	 x=1776192472; bh=g6Sw65hv9ev6c62PS1XPoQWCvvCKs0LyJpB5VZ0wUNc=; b=
	m8zJUbjkQ3/jtkMJ2VVMkLCjRSWlBI8JFIGlkKBzGeegsRWEHKKx0rrur6eIXT7z
	rDxfN7nwMcRUoqikxHwoKROe0KqRJNMtZIawLUx1ZP1vEAYNB38qP5SPNGVkyNXs
	wG1PK2/He+cB5B6DNEgT8TVv3vIrlt/dMfBjuIsBDqmgFbeGMr6A07T/V/MM38nk
	X3Dw4gVymbp132Z2NSLvnFHpfNO9qIi5VwWqF2IXGnH3LAYuwXWdkYBGLvseD38o
	BJ6aoTFE3ccZ5qGTpXN+yAovpbaUwK/33ld5rrMCUoTaqAkzsSUIfCgrG2tG/VHx
	QDRpsiBL0cwaUvYaqhD/0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776106072; x=
	1776192472; bh=g6Sw65hv9ev6c62PS1XPoQWCvvCKs0LyJpB5VZ0wUNc=; b=r
	jiWTEHvq46fSuWDwCSv3U19tMpUIfOISMTXNKqt8tr47xW6z1IBI9xLAZYq/dtb/
	xPNEGsP5+5DKWA+r5eMj4JqbUMKQWZPqPMMwWJc1nufarZh14nMGuQqWze7POjUr
	nHhmjL50/x0ZU2WDQNfam5i6FmojFW+O3yhJcVfq1PIWwlN+3swcUqgemQ4Q4nwn
	C585ZrkUb1JCkfHvQyWqX4JxxkriQCQ/aip8GVfWXtqBW4VCKbLY5LTdmnyhcUYK
	1nwnLWPyV5TMAMMLi1GJdwkSm0FQzbyeHKhDKM+GKOQ7yhEChJ2otY3yzQJCNyBy
	28UqW3iKayeU1kpwPczvQ==
X-ME-Sender: <xms:VzrdaaquwT-QTsVbia4N_Nf3AvCQsF_DChRAUPEA9CGqSn4DT3_b2w>
    <xme:VzrdaUjtAJDPfKRX1SyKZaQ9k_mZ8DIGS5dr2N4zbTQ4q9XRb2VqxD7WjcWgc-4_J
    qQaSH4xs-N9jSThqFIAPRo3Y8nF88WPUHBfbM3yxhDx5ar66pivhA>
X-ME-Received: <xmr:VzrdacPSviPXuDN4mcpzsL9qnZIvwVTSj1RI_cCiE8T5l2lMYDkIjmXPnSf057kgC6wGGOoDEK3KSSb722EEZq5qcuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeellecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthhqredttddtjeenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeeiff
    ffveejiefhudeitdeihfegleegjeeuteffvdejfedvhfevvdejfeegueelueenucffohhm
    rghinhepphgrshhtvggsihhnrdgtohhmpdhmvghrlhhinhhsrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdr
    ihhopdhnsggprhgtphhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epmhgrrhgtsehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinhhugidqsghtrhhf
    shesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfsehtohigih
    gtphgrnhgurgdrtghomhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdprhgtphht
    thhopehquhifvghnrhhuohdrsghtrhhfshesghhmgidrtghomhdprhgtphhtthhopehfug
    hmrghnrghnrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhishhtshestgholhho
    rhhrvghmvgguihgvshdrtghomhdprhgtphhtthhopegtvgefghekjhgujhesuhhmrghilh
    drfhhurhhrhihtvghrrhhorhdrohhrghdprhgtphhtthhopehrmhesrhhomhgrnhhrmhdr
    nhgvth
X-ME-Proxy: <xmx:VzrdaexZkMyWjoBRtGPSOJ15xUsfRDXygJsMN9ckZnfvQQDu8xSQAA>
    <xmx:VzrdaeqKISCnyIitR7N40ZqXsS0-0rHe_H-ivgBu72EVgRuFicK4IQ>
    <xmx:VzrdaeOefP-M1EilYItlRmVx5CAdaSWtw_Ch3F-pRllo-8jln3aG6A>
    <xmx:VzrdaScvnlg5esRRwRwWwxIRSWoadA7jSH6lJ4P_5b3U25tsr31yoA>
    <xmx:WDrdafXeH1fBiBrcb2FdCGnnTq3Xg2YW9HOQ4JnyZzR4CbysSr3PWbrz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Apr 2026 14:47:50 -0400 (EDT)
Date: Mon, 13 Apr 2026 11:47:31 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260413184731.GA3448810@zen.localdomain>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ad0tdWyavEngGlQ-@merlins.org>

On Mon, Apr 13, 2026 at 10:52:53AM -0700, Marc MERLIN wrote:
> TL;DR: do I need to urgently disable simple quotas on all my fileystems
> until I can upgrade to a confirmed fixed kernel?
>=20
> Oh no, now it's my 2nd system with a btrfs crash, just days after I
> enabled block-group-tree and simple quotas. This one is a simple
> laptop without raid, and its backup filesystem crashed overnight likely
> during balance (btrfs send/receive and snapshots, same than first one
> below) crashed overnight.
>=20
> First kernel was 6.12 which I can't upgrade, it's an rPi5 with vendor
> kernels with special hardware support that's out of tree I think.
> This one is kernel is 6.17.11 whic I will upgrade to 6.19.11+deb14 now
> but I have no idea if it fixes anything.
>=20
> I can't read the code or ooops outside of noticing the same exact
> do_free_extent_accounting which can't be a coincidence.
>=20
> I was able to rescue it with
> merlin:~# mount -o rw,enospc_debug,skip_balance  LABEL=3Dbtrfs_pool3 /mnt=
/btrfs_pool3
> merlin:~# btrfs quota disable  /mnt/btrfs_pool3
> merlin:~# umount /mnt/btrfs_pool3
> merlin:~# mount /mnt/btrfs_pool3
>=20
> I'll reboot with the new kernel now, but I'm also now scared of simple qu=
otas
> since it's 2 crashes in 3 days, one seems not posislbe to recover from an=
d a multi
> week restore.
> Suggestions welcome.

I am currently a little confused about your full story, so please help
me make sure I understand. I would like to fix any squotas problems you
are seeing if possible. I'm going to restate what I have understood from
your reports to try to confirm I am following properly.

You sent this email in reply to your previous email which I understand
was for the following trace:
2026-04-10T15:40:14.846141-07:00 moremagic kernel: Call trace:
2026-04-10T15:40:14.846143-07:00 moremagic kernel:  __btrfs_free_extent.isr=
a.0+0x13a0/0x14a0 [btrfs]
2026-04-10T15:40:14.846145-07:00 moremagic kernel:  __btrfs_run_delayed_ref=
s+0x508/0xec0 [btrfs]
2026-04-10T15:40:14.846146-07:00 moremagic kernel:  btrfs_run_delayed_refs+=
0x48/0x198 [btrfs]
2026-04-10T15:40:14.846148-07:00 moremagic kernel:  btrfs_commit_transactio=
n+0x88/0xe20 [btrfs]
2026-04-10T15:40:14.846149-07:00 moremagic kernel:  relocate_block_group+0x=
174/0x508 [btrfs]
2026-04-10T15:40:14.846150-07:00 moremagic kernel:  btrfs_relocate_block_gr=
oup+0x228/0x3d8 [btrfs]
2026-04-10T15:40:14.846151-07:00 moremagic kernel:  btrfs_relocate_chunk+0x=
44/0x158 [btrfs]
2026-04-10T15:40:14.846153-07:00 moremagic kernel:  btrfs_balance+0x734/0x1=
000 [btrfs]
2026-04-10T15:40:14.846154-07:00 moremagic kernel:  balance_kthread+0xbc/0x=
1f0 [btrfs]
2026-04-10T15:40:14.846156-07:00 moremagic kernel:  kthread+0x118/0x128
2026-04-10T15:40:14.846157-07:00 moremagic kernel:  ret_from_fork+0x10/0x20
2026-04-10T15:40:14.846159-07:00 moremagic kernel: ---[ end trace 000000000=
0000000 ]---
2026-04-10T15:40:14.846170-07:00 moremagic kernel: BTRFS: error (device dm-=
0 state A) in do_free_extent_accounting:2996: errno=3D-2 No such entry
2026-04-10T15:40:14.869757-07:00 moremagic kernel: BTRFS info (device dm-0 =
state EA): forced readonly
2026-04-10T15:40:14.870327-07:00 moremagic kernel: BTRFS error (device dm-0=
 state EA): failed to run delayed ref for logical 15506102321152 num_bytes =
16384 type 182 action 2 ref_mod 1: -2

I will call this report 1. Report 1 is from a rpi running 6.12 with possibl=
e out
of tree modules and raid5.

And now you are seeing a different path abort on a very similar invalid
state, also in __btrfs_free_extent, but this time called via qgroups
logic triggering a transaction commit:
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

I'll call this report 2. Report 2 is from a laptop with no fancy raid
and upstream kernel 6.17.

Is that all accurate?

Some further questions/observations:
- I noticed that your paste from report 1 (https://pastebin.com/7HmQwy3n)
  had 16k pages and 4k block size:
  2026-04-10T10:43:22.673638-07:00 moremagic kernel: BTRFS warning (device =
dm-0): read-write for sector size 4096 with page size 16384 is experimental
  which seems a bit risky on an old kernel. There were a lot of fixes for
  subpage block size support in recent kernels. I believe it has been
  quite stable for us on 6.16 but Qu can give the most authoritative
  answer on when that got solid.

- Is the laptop also running subpage block size? Do you have a full
  dmesg from that system which you can share?

- On which of these systems did you enable squotas and when?

- The squotas specific object is type 172, and neither of these aborts
  reference that (182 is BTRFS_SHARED_BLOCK_REF_KEY and 176 is
  BTRFS_TREE_BLOCK_REF_KEY). So that noticeably reduces my suspicion of
  squotas at this point. As far as I can tell, the main things connecting
  us to squotas are: the bug is hit in __btrfs_free_extent and the bug was
  hit once in qgroup code while deleting a snapshot. The former is still
  kind of interesting, especially if you enabled squotas very recently
  on both systems. The latter is a red herring, IMO, as discussed a bit
  more inline with your hypothesis section.

- The most interesting things to latch on to so far, to me, are that we
  have an ENOENT in __btrfs_free_extent on metadata block backrefs, and
  that there is no thru-line wrt kernel version or raid setup.

>=20
> Possible analysis (could be wrong):
> * __btrfs_free_extent & btrfs_qgroup_cleanup_dropped_subvolume:
> Your btrfs-cleaner thread was in the middle of deleting an old snapshot. =
As it
> was freeing the blocks (extents), it attempted to update the quota accoun=
ting
> for that subvolume.

I don't see any evidence for that, as discussed above about the object
type referenced in the abort log. In fact, we don't really know that the
freeing even had to do with the subvolume being deleted as we were
running generic delayed refs as part of a consistency enforcing
transaction commit before digging into qgroup logic. We have not
connected the logical block that had the issue to subvol 83288, for
which we would probably need a tree dump.

> * failed to cleanup qgroup 0/83288: -2: The kernel tried to find the quota
> group record for the subvolume being deleted, but the record was missing
> or corrupted. To protect the filesystem, Btrfs panicked and locked
> itself read-only.

Unfortunately, this second bullet is nonsense, the qgroup cleanup log
is there simply because that is the caller of btrfs_commit_transaction
that consumed the failed delayed ref errno and also logged its own
failure. This is apparent from the stack trace and logs. This actually
confused and distracted me quite a bit :)

I'm generally a happy LLM user, but this sort of "jumping to
conclusions" behavior is annoyingly common if you don't take precautions
to be stern with them and demand that they go above and beyond to
justify their conclusions.

Thank you for your reports and all the extra details you have provided
so far. I hope we can get this figured out,
Boris

>=20
> ------------[ cut here ]------------
> BTRFS: Transaction aborted (error -2)
> WARNING: CPU: 7 PID: 2987 at fs/btrfs/extent-tree.c:2999 __btrfs_free_ext=
ent.isra.0+0xc41/0x1020 [btrfs
>=20
> Modules linked in: ftdi_sio usbserial ufs qnx4 hfsplus hfs cdrom minix ms=
dos jfs nls_ucs2_utils xfs rpc
> v4 dns_resolver nfs netfs rfcomm xt_tcpudp snd_seq_dummy snd_hrtimer xt_c=
onntrack nf_conntrack_netlink=20
> lgo xt_addrtype br_netfilter bridge stp llc ccm qrtr overlay cmac algif_h=
ash algif_skcipher af_alg bnep
> JECT nf_reject_ipv4 xt_MASQUERADE xt_LOG nf_log_syslog nft_compat nft_cha=
in_nat nf_nat nf_conntrack nf_
> efrag_ipv4 nf_tables binfmt_misc nls_ascii nls_cp437 vfat fat snd_soc_sof=
_sdw snd_soc_sdw_utils vboxdrv
> 11_sdca snd_soc_rt715_sdca snd_soc_rt1316_sdw dell_pc regmap_sdw_mbq plat=
form_profile snd_hda_codec_int
> mic regmap_sdw kvm snd_hda_intel btusb snd_sof_pci_intel_tgl iwlmvm snd_s=
of_pci_intel_cnl btrtl irqbypa
> _hda_generic uvcvideo btintel soundwire_intel btbcm soundwire_generic_all=
ocation videobuf2_vmalloc snd_
> w_bpt btmtk uvc videobuf2_memops mac80211 snd_sof_intel_hda_common
>  videobuf2_v4l2 bluetooth snd_soc_hdac_hda videodev snd_sof_intel_hda_mli=
nk videobuf2_common intel_uncore_frequency snd_sof_intel_hda libarc4 snd_hd=
a_codec_hdmi snd_sof_pci intel_uncore_frequency_common mc ecdh_generic mei_=
hdcp soundwire_cadence snd_sof_xtensa_dsp mei_pxp ext4 x86_pkg_temp_thermal=
 crc8 intel_rapl_msr processor_thermal_device_pci intel_powerclamp hid_sens=
or_als dell_laptop iwlwifi soundwire_bus processor_thermal_device dell_wmi =
hid_sensor_trigger processor_thermal_wt_hint rapl hid_sensor_iio_common pla=
tform_temperature_control snd_soc_avs industrialio_triggered_buffer crc16 s=
nd_sof_probes processor_thermal_rfim intel_cstate iTCO_wdt mbcache dell_smb=
ios kfifo_buf squashfs jbd2 loop dcdbas intel_uncore cfg80211 dell_smm_hwmo=
n dell_wmi_sysman dell_wmi_ddv dell_wmi_descriptor firmware_attributes_clas=
s pcspkr snd_sof processor_thermal_rapl industrialio intel_pmc_bxt wmi_bmof=
 snd_soc_hda_codec ucsi_acpi mei_me spd5118 iTCO_vendor_support intel_rapl_=
common snd_hda_ext_core snd_sof_utils typec_ucsi
>  snd_intel_dspcfg watchdog mei processor_thermal_wt_req snd_intel_sdw_acp=
i rfkill intel_pmc_core typec processor_thermal_power_floor snd_soc_skl_hda=
_dsp igen6_edac processor_thermal_mbox roles int3403_thermal pmt_telemetry =
snd_soc_intel_sof_board_helpers int340x_thermal_zone snd_soc_acpi_intel_mat=
ch pmt_discovery joydev snd_soc_acpi_intel_sdca_quirks pmt_class snd_soc_ac=
pi int3400_thermal intel_hid intel_pmc_ssram_telemetry snd_soc_sdca acpi_th=
ermal_rel sparse_keymap acpi_tad acpi_pad ac serio_raw snd_soc_core evdev s=
nd_compress snd_pcm_dmaengine snd_soc_intel_hda_dsp_common snd_hda_codec sn=
d_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq=
_midi_event snd_seq snd_timer snd_rawmidi snd_seq_device snd_ctl_led snd so=
undcore ac97_bus coretemp nfsd msr ecryptfs auth_rpcgss nvme_fabrics nfs_ac=
l lockd efi_pstore grace sunrpc nfnetlink ip_tables x_tables autofs4 crc32c=
_cryptoapi essiv authenc btrfs blake2b_generic dm_crypt dm_mod efivarfs rai=
d10 raid456 async_raid6_recov async_memcpy
>  async_pq async_xor async_tx xor raid6_pq raid1 raid0 md_mod sata_sil24 l=
ibata scsi_mod scsi_common e1000e r8169 realtek mdio_devres libphy mdio_bus=
 mii xe configfs drm_gpusvm_helper drm_suballoc_helper hid_sensor_custom hi=
d_sensor_hub intel_ishtp_hid nouveau mxm_wmi drm_gpuvm i915 gpu_sched drm_b=
uddy drm_ttm_helper hid_multitouch ttm drm_exec i2c_algo_bit hid_generic dr=
m_display_helper xhci_pci cec xhci_hcd rc_core nvme rtsx_pci_sdmmc i2c_hid_=
acpi intel_lpss_pci drm_client_lib i2c_hid nvme_core mmc_core intel_lpss us=
bcore video nvme_keyring i2c_i801 intel_ish_ipc drm_kms_helper hid ghash_cl=
mulni_intel psmouse rtsx_pci thunderbolt intel_ishtp intel_vsec idma64 butt=
on usb_common i2c_smbus nvme_auth battery drm wmi aesni_intel
> CPU: 7 UID: 0 PID: 2987 Comm: btrfs-cleaner Tainted: G     U     OE      =
 6.17.11+deb14-amd64 #1 PREEMPT(lazy)  Debian 6.17.11-1=20
> Tainted: [U]=3DUSER, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> Hardware name: Dell Inc. XPS 17 9730/0JP3YK, BIOS 1.23.0 09/04/2025
> RIP: 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs]
> Code: ff ff 48 c7 c7 d8 ac 98 c1 e8 ab 7a 6c e4 0f 0b c6 44 24 2f 01 e9 2=
2 8a 0e 00 8b 74 24 10 48 c7 c7 d8 ac 98 c1 e8 8f 7a 6c e4 <0f> 0b e9 50 ff=
 ff ff 48 8b 34 24 48 8b 76 60 48 89 74 24 08 48 8d
> RSP: 0000:ffffd372a10cfb40 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000124f8b48000 RCX: 0000000000000027
> RDX: ffff8d4d0f3dce48 RSI: 0000000000000001 RDI: ffff8d4d0f3dce40
> RBP: 0000000000004000 R08: 0000000000000000 R09: ffffd372a10cf9e0
> R10: ffff8d4d4f745068 R11: 00000000ffffdfff R12: 0000000000000000
> R13: 000000000000002b R14: 00000000000039c1 R15: ffff8d4b42451930
> FS:  0000000000000000(0000) GS:ffff8d4d669c8000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000563efa2028b8 CR3: 0000000ce5c2c006 CR4: 0000000000f70ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __btrfs_run_delayed_refs+0x2dc/0xf70 [btrfs]
>  ? read_block_for_search+0x19e/0x400 [btrfs]
>  ? set_extent_buffer_dirty+0x26/0x200 [btrfs]
>  btrfs_run_delayed_refs+0x39/0x140 [btrfs]
>  btrfs_commit_transaction+0x6d/0xdf0 [btrfs]
>  btrfs_qgroup_cleanup_dropped_subvolume+0x49/0xb0 [btrfs]
>  btrfs_drop_snapshot+0x78e/0xcc0 [btrfs]
>  ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
>  btrfs_clean_one_deleted_snapshot+0xc2/0x130 [btrfs]
>  cleaner_kthread+0xdc/0x160 [btrfs]
>  ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
>  kthread+0xf9/0x240
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x194/0x1c0
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> ---[ end trace 0000000000000000 ]---
> BTRFS: error (device dm-4 state A) in do_free_extent_accounting:2999: err=
no=3D-2 No such entry
> BTRFS info (device dm-4 state EA): forced readonly
> BTRFS error (device dm-4 state EA): failed to run delayed ref for logical=
 1258303029248 num_bytes 16384 type 176 action 2 ref_mod 1: -2
> BTRFS: error (device dm-4 state EA) in btrfs_run_delayed_refs:2161: errno=
=3D-2 No such entry
> BTRFS warning (device dm-4 state EA): failed to cleanup qgroup 0/83288: -2
>=20
>=20
>=20
> On Fri, Apr 10, 2026 at 08:35:33PM -0700, Marc MERLIN wrote:
> >=20
> > It started with:
> > [23345.326321] BTRFS: error (device dm-0 state A) in do_free_extent_acc=
ounting:2996: errno=3D-2 No such entry
> > [23345.336394] BTRFS error (device dm-0 state EA): failed to run delaye=
d ref for logical 15506102321152 num_bytes 16384 type 182 action 2 ref_mod =
1: -2
> > [23345.350299] BTRFS: error (device dm-0 state EA) in btrfs_run_delayed=
_refs:2215: errno=3D-2 No such entry
> > [23345.360154] BTRFS warning (device dm-0 state EA):
> >=20
> > I ended up with:
> >=20
> > moremagic:~# mount -t btrfs -o rw,skip_balance,space_cache=3Dv2,clear_c=
ache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
> > BTRFS: device label DS6 devid 1 transid 296950 /dev/mapper/crypt_bcache=
0 (251:0) scanned by mount (6029)
> > BTRFS info (device dm-0): first mount of filesystem a97dec85-a0d5-42ab-=
a0ef-e9b7479fbe43
> > BTRFS info (device dm-0): using crc32c (crc32c-generic) checksum algori=
thm
> > BTRFS warning (device dm-0): read-write for sector size 4096 with page =
size 16384 is experimental
> > BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd=
 0, flush 0, corrupt 5074, gen 0
> > ------------[ cut here ]------------
> > BTRFS: Transaction aborted (error -2)
> > WARNING: CPU: 3 PID: 6029 at fs/btrfs/extent-tree.c:2996 __btrfs_free_e=
xtent.isra.0+0x13a0/0x14a0 [btrfs]
> > Modules linked in: dm_crypt dm_mod bcache raid456 async_raid6_recov asy=
nc_memcpy async_pq async_xor async_tx xt_MASQUERADE ipt_REJECT nf_reject_ip=
v4 xt_tcpudp xt_conntrack xt_LOG nf_log_syslog nft_compat nft_chain_nat nf_=
nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm algif_hash =
algif_skcipher af_alg bnep cp210x brcmfmac_wcc binfmt_misc usbserial hci_ua=
rt brcmfmac btbcm vc4 snd_soc_hdmi_codec brcmutil bluetooth drm_display_hel=
per cfg80211 cec drm_dma_helper rpi_hevc_dec ecdh_generic v4l2_mem2mem ecc =
snd_soc_core pisp_be videobuf2_dma_contig v3d videobuf2_memops videobuf2_v4=
l2 gpu_sched rfkill videodev drm_shmem_helper snd_compress snd_pcm_dmaengin=
e snd_pcm videobuf2_common rp1_pio snd_timer snd drm_kms_helper mc raspberr=
ypi_gpiomem rp1_fw sg sch_fq_codel ecryptfs fuse drm drm_panel_orientation_=
quirks backlight nfnetlink ip_tables x_tables raid1 aes_ce_blk aes_ce_ciphe=
r ghash_ce gf128mul libaes sha2_ce spidev sha256_arm64 sha1_ce raspberrypi_=
hwmon sha1_generic ahci i2c_brcmstb spi_bcm2835
> >  md_mod gpio_keys libahci pwm_fan rp1_adc libata rp1_mailbox nvmem_rmem=
 uio_pdrv_genirq uio btrfs blake2b_generic xor xor_neon raid6_pq zram lz4_c=
ompress ipv6
> > CPU: 3 UID: 0 PID: 6029 Comm: mount Not tainted 6.12.47+rpt-rpi-2712 #1=
  Debian 1:6.12.47-1+rpt1
> > Hardware name: Raspberry Pi 5 Model B Rev 1.1 (DT)
> > pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> > pc : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
> > lr : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
> > sp : ffffc000868bb680
> > x29: ffffc000868bb720 x28: 0000000000000000 x27: 0000000000002f02
> > x26: 000000000000007f x25: ffff8001de833aa0 x24: 0000000000004000
> > x23: 0000000000000000 x22: ffff800102b64e70 x21: 0000000000004000
> > x20: 00000e1a4bb88000 x19: 00000000fffffffe x18: 0000000000000000
> > x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> > x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> > x11: 00000000000000c0 x10: 0000000000001a40 x9 : ffffd06fce4e06c0
> > x8 : ffff80011f56e0a0 x7 : 000000042f72a7bd x6 : 0000000000000039
> > x5 : 0000000000000001 x4 : 0000000000001ab0 x3 : 0000000000000804
> > x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff80011f56c600
> > Call trace:
> >  __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
> >  __btrfs_run_delayed_refs+0x508/0xec0 [btrfs]
> >  btrfs_run_delayed_refs+0x48/0x198 [btrfs]
> >  btrfs_commit_transaction+0x88/0xe20 [btrfs]
> >  btrfs_recover_relocation+0x55c/0x5d0 [btrfs]
> >  btrfs_start_pre_rw_mount+0x1d4/0x470 [btrfs]
> >  open_ctree+0x101c/0x13b8 [btrfs]
> >  btrfs_get_tree+0x5b4/0x800 [btrfs]
> >  vfs_get_tree+0x30/0x108
> >  fc_mount+0x20/0x68
> >  btrfs_get_tree+0x238/0x800 [btrfs]
> >  vfs_get_tree+0x30/0x108
> >  vfs_cmd_create+0x58/0xf8
> >  __arm64_sys_fsconfig+0x444/0x5b8
> >  invoke_syscall+0x50/0x120
> >  el0_svc_common.constprop.0+0x48/0xf0
> >  do_el0_svc+0x24/0x38
> >  el0_svc+0x30/0xf8
> >  el0t_64_sync_handler+0x120/0x130
> >  el0t_64_sync+0x190/0x198
> > ---[ end trace 0000000000000000 ]---
> > BTRFS: error (device dm-0 state A) in do_free_extent_accounting:2996: e=
rrno=3D-2 No such entry
> > BTRFS error (device dm-0 state EA): failed to run delayed ref for logic=
al 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2
> > BTRFS: error (device dm-0 state EA) in btrfs_run_delayed_refs:2215: err=
no=3D-2 No such entry
> > BTRFS warning (device dm-0 state EA): failed to recover relocation: -2
> > BTRFS error (device dm-0 state EA): commit super ret -30
> > BTRFS error (device dm-0 state EA): open_ctree failed: -2
> >=20
> >=20
> > Gemini said
> >=20
> > The Btrfs "Ghost" Accounting When you added discard=3Dasync to your fst=
ab
> > (or remounted with it), you told the Btrfs kernel module to start a spe=
cific
> > background thread.
> > Btrfs's Perspective: "The user told me to use async discard. I will now=
 start a
> > list of every extent we delete so I can 'trim' them later in the backgr=
ound."
> > The Problem: Btrfs doesn't check if the underlying dm-crypt device actu=
ally
> > supports discards before it starts its own internal accounting.
> > The Result: Btrfs started tracking a massive list of "extents to be dis=
carded"
> > in its memory and metadata.
> >=20
> > 2. The "No Such Entry" (-2) Race Condition The crash didn't happen beca=
use a
> > command hit a drive; it happened because of a logic race inside the ker=
nel's
> > Btrfs code:
> > The Balance Thread: You were running a balance. This thread moves data =
=66rom "Old
> > Block A" to "New Block B."
> > The Discard Thread: Because discard=3Dasync was on, the discard thread =
saw "Old
> > Block A" get freed. It put "Old Block A" on its "to-do list."
> > The Metadata Conflict: The balance thread finished moving the data and
> > successfully deleted the reference to "Old Block A" from the extent tre=
e.
> > The Crash: A few milliseconds later, the async discard thread woke up a=
nd tried
> > to "pin" or "process" the metadata for "Old Block A." It looked in the =
tree,
> > found nothing (because the balance already deleted it), and threw an EN=
OENT
> > (Error -2: No such entry).
> > Btrfs panicked: "Wait, I was told to discard this block, but it doesn't=
 exist in
> > my records anymore! Something is inconsistent!" =E2=86=92 Transaction A=
bort.
> >=20
> > more details:
> > backuproot didn't work (read write)
> > I was forced to run
> > btrfstune --convert-from-block-group-tree /dev/mapper/crypt_bcache0
> > because
> > When you ran btrfs check --clear-space-cache v2, the tool did exactly
> > what it was supposed to do: it deleted the Free Space Tree and removed
> > the FREE_SPACE_TREE flag from your superblock.
> > The Conflict: Your 23TB array was formatted with the modern
> > block-group-tree feature (which speeds up mounting).
> > The Kernel Rule: The Btrfs kernel code explicitly dictates: If the Block
> > Group Tree is enabled, the Free Space Tree MUST also be enabled. * The
> > Crash: Because the FREE_SPACE_TREE flag is now missing, the kernel sees
> > an "illegal" superblock state and throws a fatal -22 error, refusing to
> > proceed to the mount options.
> >=20
> > This was vexing, hours lost removing the block group tree.
> > and when it was finally finished,=20
> > mount -t btrfs -o skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_big=
backup/
> > did run, but crashed as above
> >=20
> > Now doing a repair in case it can salvage things.
> >=20
> > Marc
> > --=20
> > "A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
> > =20
> > Home page: http://marc.merlins.org/                       | PGP 7F55D5F=
27AAF9D08
> >=20
>=20
> --=20
> "A mouse is a device used to point at the xterm you want to type in" - A.=
S.R.
> =20
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27=
AAF9D08
