Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20BA1A6829
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 03:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775878542; cv=none; b=fYn8lyUYtEKygglAhyblvieltYGudf4mwnYjptMNjNKKZTLmrRbQVFeE5TlEJVHrDL9dRiSu3gfXCHpZG/gR5cCGyVe6jjZvaVGYaSUvkrVLx8iB2feJiwmMpjF5cIPADCpUEMD056Z75zgmJfWlniwF3P9NwgOfeJWjLvu8fkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775878542; c=relaxed/simple;
	bh=DXgQnkA8roEniPV5OGys6dG2R4MEDaA5Q7I9otSWpUY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GjtM26D9EmgE9JwRyjqDXayhc4QXQBcavAJP3nBHo4bUWU07AcEannGllYIeyJ60AQeRoyL+JajwpVFYQcfOU7BH7Gxj50eUGztqvz5VlCPR+1xOfA9GZLVPLZJEPq8EsjzHqs/DTlXsMCEqcQ42njrS357P+ERoP/eTEhuWwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=qLbpUWhv; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="qLbpUWhv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=59kQ0Xhxgmg/j0iVXZgy/M+0ajoGJgSP6ZwEQiO3UCI=; b=qLbpUWhvREJsTXhj5YQjUvZ1J0
	34KFpVcy59WDrYUGQutkyKClU+yVSbJn7s+xtXexgpsMpVffJuCqnuNCgR2R68NX/eYLEUtJLvciQ
	LUFm9ONBrC406Kkqq6KqcvKDnnXqSAgbX5WAM3KQEQPfxO5lfkEhz5h+929oETpUAdMtBa0ZNtZSj
	4SBdnx3kq4tmef15G77YH9TwBMcMRWg1kA1jLw3rieuZXltXFaqWNsz8WIH8Qxh/a/oZAcUTVortK
	MJKEqs1yryJdNQRQCPYWpIYW3YcdrYv9rCW54zNnExLCZi9B3VVG5MnR9CKC5/atn258apHZ+UDio
	KIxO3rRw==;
Received: from [24.6.49.44] (port=48654 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wBP8A-0000000DQo6-4Bgt by authid <merlins.org> with srv_auth_plain;
	Fri, 10 Apr 2026 20:35:34 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wBP89-001B5T-19;
	Fri, 10 Apr 2026 20:35:33 -0700
Date: Fri, 10 Apr 2026 20:35:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <adnBhWfJQ1n3hZC8@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

[Is there a more appropriate way to report FS corruption? Looks like
Emails to just linux-btrfs@vger.kernel.org do not get seen amongst all
the patches hiding a normal Email]

Howdy,

I had btfrs filesystem on top of raid5 with 5 spinning drives.
I mistakenly enabled discard by mistake which caused a crash when the disca=
rd thread tried
to run (no discard on those drives)
Kernel 6.12

I worked on recovery using gemini 3.0 pro, mounting read only is fine, but =
I need read write
or will waste days (probably weeks) recreating this entire 20TB+ backup ove=
r the internet

I'm not qualified to say if everything Gemini said was correct, but I think=
 summary is:
1) discard can apparently kill a filesystem when it's hard drives below (it=
 did for me)
2) -o skip_balance,usebackuproot didn't help
3) no way to mount after space cache has been cleared and block-group-tree =
is enabled
4) still no way to mount read write after removing block-group-tree

It started with:
[23345.326321] BTRFS: error (device dm-0 state A) in do_free_extent_account=
ing:2996: errno=3D-2 No such entry
[23345.336394] BTRFS error (device dm-0 state EA): failed to run delayed re=
f for logical 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2
[23345.350299] BTRFS: error (device dm-0 state EA) in btrfs_run_delayed_ref=
s:2215: errno=3D-2 No such entry
[23345.360154] BTRFS warning (device dm-0 state EA):

I ended up with:

moremagic:~# mount -t btrfs -o rw,skip_balance,space_cache=3Dv2,clear_cache=
 /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
BTRFS: device label DS6 devid 1 transid 296950 /dev/mapper/crypt_bcache0 (2=
51:0) scanned by mount (6029)
BTRFS info (device dm-0): first mount of filesystem a97dec85-a0d5-42ab-a0ef=
-e9b7479fbe43
BTRFS info (device dm-0): using crc32c (crc32c-generic) checksum algorithm
BTRFS warning (device dm-0): read-write for sector size 4096 with page size=
 16384 is experimental
BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, =
flush 0, corrupt 5074, gen 0
------------[ cut here ]------------
BTRFS: Transaction aborted (error -2)
WARNING: CPU: 3 PID: 6029 at fs/btrfs/extent-tree.c:2996 __btrfs_free_exten=
t.isra.0+0x13a0/0x14a0 [btrfs]
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
CPU: 3 UID: 0 PID: 6029 Comm: mount Not tainted 6.12.47+rpt-rpi-2712 #1  De=
bian 1:6.12.47-1+rpt1
Hardware name: Raspberry Pi 5 Model B Rev 1.1 (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
pc : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
lr : __btrfs_free_extent.isra.0+0x13a0/0x14a0 [btrfs]
sp : ffffc000868bb680
x29: ffffc000868bb720 x28: 0000000000000000 x27: 0000000000002f02
x26: 000000000000007f x25: ffff8001de833aa0 x24: 0000000000004000
x23: 0000000000000000 x22: ffff800102b64e70 x21: 0000000000004000
x20: 00000e1a4bb88000 x19: 00000000fffffffe x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 00000000000000c0 x10: 0000000000001a40 x9 : ffffd06fce4e06c0
x8 : ffff80011f56e0a0 x7 : 000000042f72a7bd x6 : 0000000000000039
x5 : 0000000000000001 x4 : 0000000000001ab0 x3 : 0000000000000804
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff80011f56c600
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
BTRFS error (device dm-0 state EA): open_ctree failed: -2


Gemini said

The Btrfs "Ghost" Accounting When you added discard=3Dasync to your fstab
(or remounted with it), you told the Btrfs kernel module to start a specific
background thread.
Btrfs's Perspective: "The user told me to use async discard. I will now sta=
rt a
list of every extent we delete so I can 'trim' them later in the background=
=2E"
The Problem: Btrfs doesn't check if the underlying dm-crypt device actually
supports discards before it starts its own internal accounting.
The Result: Btrfs started tracking a massive list of "extents to be discard=
ed"
in its memory and metadata.

2. The "No Such Entry" (-2) Race Condition The crash didn't happen because a
command hit a drive; it happened because of a logic race inside the kernel's
Btrfs code:
The Balance Thread: You were running a balance. This thread moves data from=
 "Old
Block A" to "New Block B."
The Discard Thread: Because discard=3Dasync was on, the discard thread saw =
"Old
Block A" get freed. It put "Old Block A" on its "to-do list."
The Metadata Conflict: The balance thread finished moving the data and
successfully deleted the reference to "Old Block A" from the extent tree.
The Crash: A few milliseconds later, the async discard thread woke up and t=
ried
to "pin" or "process" the metadata for "Old Block A." It looked in the tree,
found nothing (because the balance already deleted it), and threw an ENOENT
(Error -2: No such entry).
Btrfs panicked: "Wait, I was told to discard this block, but it doesn't exi=
st in
my records anymore! Something is inconsistent!" =E2=86=92 Transaction Abort.

more details:
backuproot didn't work (read write)
I was forced to run
btrfstune --convert-from-block-group-tree /dev/mapper/crypt_bcache0
because
When you ran btrfs check --clear-space-cache v2, the tool did exactly
what it was supposed to do: it deleted the Free Space Tree and removed
the FREE_SPACE_TREE flag from your superblock.
The Conflict: Your 23TB array was formatted with the modern
block-group-tree feature (which speeds up mounting).
The Kernel Rule: The Btrfs kernel code explicitly dictates: If the Block
Group Tree is enabled, the Free Space Tree MUST also be enabled. * The
Crash: Because the FREE_SPACE_TREE flag is now missing, the kernel sees
an "illegal" superblock state and throws a fatal -22 error, refusing to
proceed to the mount options.

This was vexing, hours lost removing the block group tree.
and when it was finally finished,=20
mount -t btrfs -o skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_bigback=
up/
did run, but crashed as above

Now doing a repair in case it can salvage things.

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
=20
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AA=
F9D08
