Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764B2EFDAF
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776229963; cv=none; b=lTb/uLajUUqTyCJtp7c0VqhAovzXnSG7xcXtl3Ub5zJ2dCU71DoqbWMCIhJahM/NNXDMNizON2uMo1s/SAebpMZYI8kGOc+CXvxyWh/rgYyYsGNVj92L1D4JuM+RmSl5wua2HlSCxSEoXmk5GThEz1ndSm8HU1miUKk07Jy9KzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776229963; c=relaxed/simple;
	bh=6oJjulsbPlur433Cv1b3qWmq5qREL6dVtRh4Nq/+a00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfhnYbdl3XBMP5l2ZqMN1VUB4nptsVpFJCO/IlzljV5tBNnLHSsfee2VtgJ3G2hA4bKy1dpXeKOrs5n/NQ2y+cZEqyEueDuZeic0lwWmgdUH44aj05GZLEDOSwnZP+sOZj+eJhNZlkNUlB0zv9gpeDdCiy3Q0AaSsSvWpD+dfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=LggkChSX; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="LggkChSX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Resent-To:
	Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Sender:Resent-Cc:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OECz+qyXEAwnkIFwQujhc6sgPXwjJYjF1sKPhWrUcn0=; b=LggkChSXNN/4pG9Hvt0q2NdPPV
	+TR3DLIqDRTscZxH9YNabS395ydUtabjd2H9H4ImjPccoo7TfDafBx15wn8S9INku83CSPFi2u+dT
	Pq+SpxB4Hf9v0PhlkEuuBTSrQa4E62E1ahnPJP0st0cTLmz3bHzr031EXoq4UshNI08EYCV+Xi448
	S6gxciJI0fuyn6+Gg9cjMiy/p1kD+ijR+C6fxQ7KTQh7UHv829DRl3mMF1kQz9o68jUPvRnHuaeKZ
	7cKdqylDZGmPmsKfdse9jOSHPlFHg7e5aDTS9BqMwzU0uC2u5fA1gUnlTZ8g7+i+BEGyvfWDMzTAu
	edL6FMYw==;
Received: from [24.6.49.44] (port=35822 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCsYL-00000004AUA-3XKe by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>;
	Tue, 14 Apr 2026 22:12:41 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <merlin@merlins.org>)
	id 1wCsYK-006sZe-1H
	for linux-btrfs@vger.kernel.org;
	Tue, 14 Apr 2026 22:12:40 -0700
Resent-From: Marc MERLIN <marc@merlins.org>
Resent-Date: Tue, 14 Apr 2026 22:12:40 -0700
Resent-Message-ID: <ad8eSNy217egb7WZ@merlins.org>
Resent-To: linux-btrfs@vger.kernel.org
Date: Sat, 11 Apr 2026 18:57:33 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
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
Message-ID: <adr8DUbqkdFyvZsf@merlins.org>
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
Message-ID: <20260412015733.kEBUYDzKF_rcFGmP_K_ORhRc1Wo7XsT58I7CCEbxKII@z>

So, btrfs repair is weird. The "real one" just OOM's even if I give it
64GB of swap, because I guess it wants gigabytes of RAM in huge chunks
that can't be swapped.

moremagic:~# btrfs check --repair /dev/mapper/crypt_bcache0
enabling repair mode
WARNING:

        Do not use --repair unless you are advised to do so by a developer
        or an experienced user, and then only after having accepted that no
        fsck can successfully repair all types of filesystem corruption. E.=
g.
        some software or hardware bugs can fatally damage a volume.
        The operation will start in 10 seconds.
        Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting repair.
Opening filesystem to check...
Checking filesystem on /dev/mapper/crypt_bcache0
UUID: a97dec85-a0d5-42ab-a0ef-e9b7479fbe43
[1/8] checking log skipped (none written)
[2/8] checking root items
Fixed 0 roots.
[3/8] checking extents
super bytes used 18659783561216 mismatches actual used 18659783544832
super bytes used 18659783544832 mismatches actual used 18659783593984
No device size related problem found
[4/8] checking free space cache
[5/8] checking fs roots
Killed

But this is strange lowmem is giving a totally different result, it may
just be entirely trashing my FS as I write this, but if it doesn't
succeed, I need to wipe it and start over anyway
moremagic:~# btrfs check --mode lowmem /dev/mapper/crypt_bcache0
Opening filesystem to check...
Checking filesystem on /dev/mapper/crypt_bcache0
UUID: a97dec85-a0d5-42ab-a0ef-e9b7479fbe43
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
ERROR: extent[16842752 168 4096] has unknown ref type: 172
ERROR: extent[16855040 168 4096] has unknown ref type: 172
ERROR: extent[1121296384 168 8192] has unknown ref type: 172

Gemnini said that's the simple quotas not supported in lowmem

moremagic:~# btrfstune --remove-simple-quota /dev/mapper/crypt_bcache0
bad eb member end: ptr 0x4000 start 15495212859392 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16568940527616 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16133001379840 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15495296155648 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15641227673600 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16027774648320 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16217827999744 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16217830113280 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15505949786112 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16357413355520 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15495414267904 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 3133210902528 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16027775500288 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16217837060096 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15181688930304 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 15181689208832 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16349905764352 member offset 16384 size=
 1
bad eb member end: ptr 0x4000 start 16349906010112 member offset 16384 size=
 1

So basically it looks like I'm kind of screwed unless I move the array
(remote, can't get to it right now) to a system with 64GB of RAM or whatnot.

Back to the original point, this is kind of sad
1) mdadm raid5 can't close the right hole while intent bitmaps are on
2) native btrfs raid5 has never been stable enough to be used in production
3) RST should eventually be, but nothing I read says it is today
4) btrfs check --repair still apparently requires at least as much RAM
as the filesystem size, which is "problematic"
5) --lowmem is out of date and not usable.

So, am I pretty much screwed and need to wipe, restart, and speed
probably weeks trying to resync all that data over the internet, or is
there a way out?

Thanks,
Marc

On Fri, Apr 10, 2026 at 08:35:33PM -0700, Marc MERLIN wrote:
> [Is there a more appropriate way to report FS corruption? Looks like
> Emails to just linux-btrfs@vger.kernel.org do not get seen amongst all
> the patches hiding a normal Email]
>=20
> Howdy,
>=20
> I had btfrs filesystem on top of raid5 with 5 spinning drives.
> I mistakenly enabled discard by mistake which caused a crash when the dis=
card thread tried
> to run (no discard on those drives)
> Kernel 6.12
>=20
> I worked on recovery using gemini 3.0 pro, mounting read only is fine, bu=
t I need read write
> or will waste days (probably weeks) recreating this entire 20TB+ backup o=
ver the internet
>=20
> I'm not qualified to say if everything Gemini said was correct, but I thi=
nk summary is:
> 1) discard can apparently kill a filesystem when it's hard drives below (=
it did for me)
> 2) -o skip_balance,usebackuproot didn't help
> 3) no way to mount after space cache has been cleared and block-group-tre=
e is enabled
> 4) still no way to mount read write after removing block-group-tree
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
