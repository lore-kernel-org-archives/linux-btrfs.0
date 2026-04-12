Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB91C233704
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776015534; cv=none; b=HnPyC8JAoCdncXcGbP2guKRCoNABi67/i+JZs6XiexzOyiTgb0IgqTdwB52L1NwECu3ym0TnaG5wX3pYLHQEpcQnAfZhM6EjPtu7y7U/3fqC2LPOMQIMG9JIV2wFvEQSWxuvp3J+RT5KyN5QC1Xa09Y5el/aOjJTs32yECP04uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776015534; c=relaxed/simple;
	bh=Rq2ON2bmyPIc4kXUOOjejYZE8O8PevpIIxng1pW5Zno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kby5AHMWlp5TncdWTRB5Q70kXYTFi5CFo+8sgwNShT1iWQj2K5oo+it9phaaglCFgVb8UNwsL+JN+qxJfT7M+5hf1gf6FSAF41rUFG6dl7Sz/TvTVjs4ePQmXBN5Fq+XZnRY5nD7DmiY5IfSbLeXNKi5+s3mgxnFvo7q1Rx2c+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=Xflz3sWM; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="Xflz3sWM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EnpVwazdUVYn//i1IY4FzfnHMEOS7lYHkTWcYQEn4m8=; b=Xflz3sWMnmhtC4leA4MxspU4hf
	qtYWZvgfnC88FuaUx9kgQ6OPtCB1/3pt2oz2P1P0Gl2lYwnvop0+CE1HD27u7LU1A8UmRnQvwa8eM
	1dUmo3XqpIgSiiaiIqCSTUcBv4C7j536MyJD2fwlXhy1Wbh21Fu8HInBjfyrjx33/OiJCJwYOsRac
	Rk6JwUQow6CBUPcAFYsiwRc11xj6nDTPtWwY+s1MKv8kDHSsPwFRv2oSoYo6I079Qu9OH76B8izZd
	wKYZ8SfYmI8gFp7nokorrXUr7jKtzqS/LPJcuXFsKuLG/HDmK+MIIApmjT+w9ngNe+EPsZLa9pe8z
	kfGYHHSA==;
Received: from [24.6.49.44] (port=53040 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wByld-00000007E6x-32Pf by authid <merlins.org> with srv_auth_plain;
	Sun, 12 Apr 2026 10:38:41 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wBylc-003MC2-0v;
	Sun, 12 Apr 2026 10:38:40 -0700
Date: Sun, 12 Apr 2026 10:38:40 -0700
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
Message-ID: <advYoKqUCUmD4oO6@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <adr8DUbqkdFyvZsf@merlins.org>
 <adsDRShNS8OkIcbr@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <adsDRShNS8OkIcbr@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

Last update, looks like there is no way out for a regular user, which is di=
appointing.
btrfs check eventually worked with a lot of swap and a trick Gemini gave me:
moremagic:~# echo -1000 > /proc/$(pgrep -x btrfs)/oom_score_adj
moremagic:~# sysctl vm.swappiness=3D100

At least it got that part right, I was able to run the whole check:

Opening filesystem to check...
Checking filesystem on /dev/mapper/crypt_bcache0
UUID: a97dec85-a0d5-42ab-a0ef-e9b7479fbe43
[1/8] checking log skipped (none written)
[1/7] checking root items                      (0:06:49 elapsed, 35112838 i=
tems checked)
Fixed 0 roots.
No device size related problem found           (1:11:30 elapsed, 4288885 it=
ems checked)
[2/7] checking extents                         (1:11:31 elapsed, 4288885 it=
ems checked)
[3/7] checking free space cache                (0:07:16 elapsed, 20918 item=
s checked)
[4/7] checking fs roots                        (6:16:17 elapsed, 2835820 it=
ems checked)
[5/7] checking csums (without verifying data)  (0:50:04 elapsed, 10400884 i=
tems checked)
[6/7] checking root refs                       (0:00:00 elapsed, 112 items =
checked)
[7/7] checking quota groups                    (0:08:19 elapsed)
found 18657895645184 bytes used, no error found
total csum bytes: 18153824804
total tree bytes: 70266978304
total fs tree bytes: 46633795584
total extent tree bytes: 3394486272
btree space waste bytes: 11583902998
file data blocks allocated: 43054973927424
 referenced 23610773848064

So, not bad, but not good either since it shows nothing fixed.
And unsurprisingly, I'm back to square 1

As per my previous comments on btrfs and raid5, I think it's now my 5,
6th or 7th time in 12 years losing a filesystem (defined by it went bad
and I can't recover it myself).  I was really hopeful that after all
these years, fixes and new code, it would be more solid but at least for
me, it hasn't been :-/

Before I wipe it and start over, I'm willing to try a few things you'd like
to try and fix this issue kernel and/or btrfs check side.
I can build a TOT btrfs-progs, but can't upgrade the kernel as it's a Pi5 w=
ith
indeed a page size of 16384 which hopefully isn't the source of all of this
(retiring power hungry 400W-ish intel systems to save on electricity bills)

moremagic:~# mount -o rw,skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_=
bigbackup
usb 2-1: reset SuperSpeed USB device number 3 using xhci-hcd
BTRFS: device label DS6 devid 1 transid 296961 /dev/mapper/crypt_bcache0 (2=
51:0) scanned by mount (304163)
BTRFS info (device dm-0): first mount of filesystem a97dec85-a0d5-42ab-a0ef=
-e9b7479fbe43
BTRFS info (device dm-0): using crc32c (crc32c-generic) checksum algorithm
BTRFS info (device dm-0): forcing free space tree for sector size 4096 with=
 page size 16384
BTRFS warning (device dm-0): read-write for sector size 4096 with page size=
 16384 is experimental
BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, =
flush 0, corrupt 5074, gen 0
------------[ cut here ]------------
BTRFS: Transaction aborted (error -2)
WARNING: CPU: 1 PID: 304163 at fs/btrfs/extent-tree.c:2996 __btrfs_free_ext=
ent.isra.0+0x13a0/0x14a0 [btrfs]
Modules linked in: dm_crypt dm_mod bcache raid456 async_raid6_recov async_m=
emcpy async_pq async_xor async_tx xt_MASQUERADE ipt_REJECT nf_reject_ipv4 x=
t_tcpudp xt_conntrack xt_LOG nf_log_syslog nft_compat nft_chain_nat nf_nat =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfcomm algif_hash algi=
f_skcipher af_alg bnep cp210x brcmfmac_wcc binfmt_misc usbserial hci_uart b=
rcmfmac btbcm vc4 snd_soc_hdmi_codec brcmutil bluetooth drm_display_helper =
cfg80211 cec drm_dma_helper rpi_hevc_dec ecdh_generic v4l2_mem2mem ecc snd_=
soc_core pisp_be videobuf2_dma_contig v3d videobuf2_memops videobuf2_v4l2 g=
pu_sched rfkill videodev drm_shmem_helper snd_compress snd_pcm_dmaengine sn=
d_pcm videobuf2_common rp1_pio snd_timer snd drm_kms_helper mc raspberrypi_=
gpiomem rp1_fw sg sch_fq_codel ecryptfs fuse drm drm_panel_orientation_quir=
ks backlight nfnetlink ip_tables x_tables raid1 aes_ce_blk aes_ce_cipher gh=
ash_ce gf128mul libaes sha2_ce spidev sha256_arm64 sha1_ce raspberrypi_hwmo=
n sha1_generic ahci i2c_brcmstb spi_bcm2835
 md_mod gpio_keys libahci pwm_fan rp1_adc libata rp1_mailbox nvmem_rmem uio=
_pdrv_genirq uio btrfs blake2b_generic xor xor_neon raid6_pq zram lz4_compr=
ess ipv6
CPU: 1 UID: 0 PID: 304163 Comm: mount Tainted: G        W          6.12.47+=
rpt-rpi-2712 #1  Debian 1:6.12.47-1+rpt1
Tainted: [W]=3DWARN
Hardware name: Raspberry Pi 5 Model B Rev 1.1 (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
pc : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
lr : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
sp : ffffc00086a93680
x29: ffffc00086a93720 x28: 0000000000000000 x27: 0000000000002f02
x26: 000000000000007f x25: ffff8000157cec30 x24: 0000000000004000
x23: 0000000000000000 x22: ffff800102b671e0 x21: 0000000000004000
x20: 00000e1a4bb88000 x19: 00000000fffffffe x18: 0000000000000006
x17: ffff800100393640 x16: 0000000000000020 x15: 0000000000000002
x14: 0000000000000001 x13: 0000000020000000 x12: 0000000000000000
x11: ffffd06fcf9884f8 x10: 0000000000000ca9 x9 : ffffd06fcf1deb40
x8 : 0000000000017fe8 x7 : 00000000fffff000 x6 : 0000000000000002
x5 : 0000000000000400 x4 : 0000000000000800 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff80011f76c600
Call trace:
 __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
 __btrfs_run_delayed_refs+0x508/0xec0 [btrfs]
 btrfs_run_delayed_refs+0x48/0x198 [btrfs]
 btrfs_commit_transaction+0x88/0xe20 [btrfs]
 btrfs_recover_relocation+0x55c/0x5d0 [btrfs]
 btrfs_start_pre_rw_mount+0x1d4/0x470 [btrfs]
 open_ctree+0x101c/0x13b8 [btrfs]
 btrfs_get_tree+0x5b4/0x800 [btrfs]
 vfs_get_tree+0x30/0x108
 fc_mount+0x20/0x68
 btrfs_get_tree+0x238/0x800 [btrfs]
 vfs_get_tree+0x30/0x108
 vfs_cmd_create+0x58/0xf8
 __arm64_sys_fsconfig+0x444/0x5b8
 invoke_syscall+0x50/0x120
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x30/0xf8
 el0t_64_sync_handler+0x120/0x130
 el0t_64_sync+0x190/0x198
---[ end trace 0000000000000000 ]---
BTRFS: error (device dm-0 state A) in do_free_extent_accounting:2996: errno=
=3D-2 No such entry
BTRFS error (device dm-0 state EA): failed to run delayed ref for logical 1=
5506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2
BTRFS: error (device dm-0 state EA) in btrfs_run_delayed_refs:2215: errno=
=3D-2 No such entry
BTRFS warning (device dm-0 state EA): failed to recover relocation: -2
BTRFS error (device dm-0 state EA): commit super ret -30
mount: /mnt/btrfs_bigbackup: fsconfig() failed: No such file or directory.
       dmesg(1) may have more information after failed mount system call.
BTRFS error (device dm-0 state EA): open_ctree failed: -2

--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AA=
F9D08
