Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B637D12F
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776025314; cv=none; b=MKynU9IVQu7dMq2lg2Nc3aQrjby+h96stanRIWdnBDwiYRmw/QLtatwv38KVrj5N67gtgOI4+uvLlQlUerCXfKPHKVkdX22ds51maF8iKz9gQ62eraW57u1ya/Dg6JfNvC9ZuULgmuTg9hQxRHlRqhQTOIGE7DeH8sk/tJYzXzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776025314; c=relaxed/simple;
	bh=4SIBBFPiLKKMKK19ot31tZ+qpZbdNpprOPdfM5h2l9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ5n18lmJTfzlToKrqOfKFeW5y7Pzidc5rpioGj3FM2lEmn1eeBwQlhvRu8ifBmmZUFfN19CPqud9bY+gEJSfz74c2NCBaLadJaRTfChGpgFnkiOPecgJhIcox0MQGx9BJrYiO2kbvvDwmCwwuTmGmQKgN/+QQTkNCu4zkuWc/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=rUOcFenT; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="rUOcFenT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tmg9xvb5fXPHSouYUTfcPUwWs48UfLyCrHEJHyx0YCg=; b=rUOcFenTRomOER+rfV0j8Ots3f
	i/94+nzpspBVtuZh6heBlDxwYn5bD0VAIvdBCe5E+POU9EVocHd3JX973gLn16O9k327EeQlrE6qw
	PGgrumNJyvYzs9JTQt9u+Rbyl6XmDsYXR5Bp5oZWvJ4tgpPGuBzjVs9OeI/+99CB2Kz+Pa9z1yada
	fReZZCbp41fsXWqWt4/fZoHuyVBAi3BcqVjGsc/DeX2bCxZfUYucyzU8HC14z89BPKt6RQUdYqE+K
	vRdfIfunFtksV/HC++KmktrHvioBJ19uVLqfaOylULLgs9p50ApQoiEYBl6MU+SK+sDIkO1yrbXbX
	62EjbcOA==;
Received: from [24.6.49.44] (port=54736 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wC1JU-00000007qtp-1vHH by authid <merlins.org> with srv_auth_plain;
	Sun, 12 Apr 2026 13:21:48 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wC1JS-003Wkb-2f;
	Sun, 12 Apr 2026 13:21:46 -0700
Date: Sun, 12 Apr 2026 13:21:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <adv-2iUrLuHK7MsJ@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <adr8DUbqkdFyvZsf@merlins.org>
 <adsDRShNS8OkIcbr@merlins.org>
 <advYoKqUCUmD4oO6@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <advYoKqUCUmD4oO6@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

One last ditch effort from Gemini:

moremagic:~# btrfs rescue zero-log /dev/mapper/crypt_bcache0
Clearing log on /dev/mapper/crypt_bcache0, previous log_root 0, level 0
moremagic:~# mount -o rw,clear_cache,skip_balance /dev/mapper/crypt_bcache0=
 /mnt/btrfs_bigbackup
mount: /mnt/btrfs_bigbackup: fsconfig() failed: No such file or directory.
       dmesg(1) may have more information after failed mount system call.
moremagic:~# mount -wno remount,skip_balance /mnt/btrfs_bigbackup/
^^^ works, filesystem is still there:

Read/write still failing :-/

Gemini says the following, whether it's right or wrong about the
details, it would be nice to have a way to btrfs --repair or force
cleanup/revert/delete on read-write mount to recover to a working state.
Coping 22TB off from r/o FS is pointless, it's an offsite backup, never mind
that I have nowhere to copy that too anyway, I really would like to
get it back to read/write if there isn't massive corruption, and there
does not seem to be.

Btrfs operates on a strict "clean up your mess first" policy.
Read-Only: The kernel simply reads the B-trees as they currently exist
on the disk. It completely ignores the Btrfs "to-do" list (the delayed
refs and the aborted relocation tree).
Read-Write: The kernel refuses to let you write new data until it
finishes the aborted relocation from when the system crashed days
ago. It tries to execute that "to-do" list, hits the corrupted Extent
Tree/Squota bug (ENOENT), and instantly panics and aborts the mount to
prevent further corruption.

Because there is no skip_relocation mount option in the Linux kernel,
you cannot force this filesystem to mount Read-Write without clearing
that broken tree. And because standard tools cannot clear a broken
relocation tree offline, the RW mount is effectively bricked.


moremagic:~# mount -wno remount,skip_balance /mnt/btrfs_bigbackup/
kernel: usb 2-1: reset SuperSpeed USB device number 3 using xhci-hcd
kernel: ------------[ cut here ]------------
kernel: BTRFS: Transaction aborted (error -2)
kernel: WARNING: CPU: 1 PID: 325244 at fs/btrfs/extent-tree.c:2996 __btrfs_=
free_extent.isra.0+0x13a0/0x14a0 [btrfs]
kernel: Modules linked in: dm_crypt dm_mod bcache raid456 async_raid6_recov=
 async_memcpy async_pq async_xor async_tx xt_MASQUERADE ipt_REJECT nf_rejec=
t_ipv4 xt_tcpudp xt_conntrack xt_LOG nf_log_syslog nft_compat nft_chain_nat=
 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm algif_h=
ash algif_skcipher af_alg bnep cp210x brcmfmac_wcc binfmt_misc usbserial hc=
i_uart brcmfmac btbcm vc4 snd_soc_hdmi_codec brcmutil bluetooth drm_display=
_helper cfg80211 cec drm_dma_helper rpi_hevc_dec ecdh_generic v4l2_mem2mem =
ecc snd_soc_core pisp_be videobuf2_dma_contig v3d videobuf2_memops videobuf=
2_v4l2 gpu_sched rfkill videodev drm_shmem_helper snd_compress snd_pcm_dmae=
ngine snd_pcm videobuf2_common rp1_pio snd_timer snd drm_kms_helper mc rasp=
berrypi_gpiomem rp1_fw sg sch_fq_codel ecryptfs fuse drm drm_panel_orientat=
ion_quirks backlight nfnetlink ip_tables x_tables raid1 aes_ce_blk aes_ce_c=
ipher ghash_ce gf128mul libaes sha2_ce spidev sha256_arm64 sha1_ce raspberr=
ypi_hwmon sha1_generic ahci i2c_brcmstb spi_bcm2835
kernel:  md_mod gpio_keys libahci pwm_fan rp1_adc libata rp1_mailbox nvmem_=
rmem uio_pdrv_genirq uio btrfs blake2b_generic xor xor_neon raid6_pq zram l=
z4_compress ipv6
kernel: CPU: 1 UID: 0 PID: 325244 Comm: mount Tainted: G        W          =
6.12.47+rpt-rpi-2712 #1  Debian 1:6.12.47-1+rpt1
kernel: Tainted: [W]=3DWARN
kernel: Hardware name: Raspberry Pi 5 Model B Rev 1.1 (DT)
kernel: pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
kernel: pc : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
kernel: lr : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
kernel: sp : ffffc0008a843820
kernel: x29: ffffc0008a8438c0 x28: 0000000000000000 x27: 0000000000002f02
kernel: x26: 000000000000007f x25: ffff80011fbbae60 x24: 0000000000004000
kernel: x23: 0000000000000000 x22: ffff8001033a9068 x21: 0000000000004000
kernel: x20: 00000e1a4bb88000 x19: 00000000fffffffe x18: 0000000000000000
kernel: x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
kernel: x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
kernel: x11: 00000000000000c0 x10: 0000000000001a40 x9 : ffffd06fce4e06c0
kernel: x8 : ffff80011e5a9ea0 x7 : ffffc0008293bc30 x6 : 0000000000000043
kernel: x5 : 0000000000000001 x4 : 0000000000001ab0 x3 : 0000000000000804
kernel: x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff80011e5a8400
kernel: Call trace:
kernel:  __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
kernel:  __btrfs_run_delayed_refs+0x508/0xec0 [btrfs]
kernel:  btrfs_run_delayed_refs+0x48/0x198 [btrfs]
kernel:  btrfs_commit_transaction+0x88/0xe20 [btrfs]
kernel:  btrfs_recover_relocation+0x55c/0x5d0 [btrfs]
kernel:  btrfs_start_pre_rw_mount+0x1d4/0x470 [btrfs]
kernel:  btrfs_reconfigure+0x198/0x6d8 [btrfs]
kernel:  reconfigure_super+0xc8/0x260
kernel:  __arm64_sys_fsconfig+0x510/0x5b8
kernel:  invoke_syscall+0x50/0x120
kernel:  el0_svc_common.constprop.0+0x48/0xf0
kernel:  do_el0_svc+0x24/0x38
kernel:  el0_svc+0x30/0xf8
kernel:  el0t_64_sync_handler+0x120/0x130
kernel:  el0t_64_sync+0x190/0x198
kernel: ---[ end trace 0000000000000000 ]---
kernel: BTRFS: error (device dm-0 state MA) in do_free_extent_accounting:29=
96: errno=3D-2 No such entry
kernel: BTRFS error (device dm-0 state EMA): failed to run delayed ref for =
logical 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2
kernel: BTRFS: error (device dm-0 state EMA) in btrfs_run_delayed_refs:2215=
: errno=3D-2 No such entry
kernel: BTRFS warning (device dm-0 state EMA): failed to recover relocation=
: -2
mount: /mnt/btrfs_bigbackup: fsconfig() failed: No such file or directory.
       dmesg(1) may have more information after failed mount system call.



--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
=20
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AA=
F9D08
