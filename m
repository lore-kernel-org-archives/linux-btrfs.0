Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799478;
	b=pR3pbnaRTpI4F7nuaka1+oSMlXBu3wmN4bBmSNgylOwweWQcadoQ1VIkFcv4IKE1zsZt
	 s121AJAaePjXMvDkeWg/tZ9268kBpc5e8sIys5JMhZro45Jrp7AEKL+X7jhbqqNtRFBlr
	 KFWgeBlx4BqZqiyE9RXX7giIPlh6p5H/uzciKrOhXlaepABMYl+GSY93X4FW7k+dwYxfa
	 XRrzi4LSW3yMcRNq2w7g48PN6GDEBEWcAsUEPzWxy2lclh9rmTMMXNFJ6eM+P6dRsbNDP
	 Dv7Lsy2/FLoObqekCAw4MN8crXJZXxRt/gkM782VoXHurAT95IUoamCT0vnZhUSSrYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799478;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfLabG6e/zV06L6P8zy2tmyyujko7C31l7rMUc3Ub+I=;
	b=Z1+hrVtx5XhTeGm2T+2IRa1XY8n+xbIJjhmqkGOdb4Bq1AAGRJj+QCs5frQugRCo0P10
	 Yfh801J6G1j7UscBHEZ/xJ10ny0ivUd3r4z1ifaKQNSrRN4o6EtpLYwivUBkwxx+8BQVH
	 Bf6bzTCbwdMy+2EzudQzEGZpmUqFRUKW3KnIL/HoXyndj8fxCSsGvsWx/Vqern+b/B8Zu
	 XaUaFggGn7t6J1Y557DQ5HfBMLRF+K5GCxsaYBG9+jNsdMIdAbcPPKx9OCmBnO/Ljxvp4
	 qoSCxSY4M71XsKndbIVq6HQUhTvg1pTxTa2T2kED+31XQ0Mm9UhpBU5lw/k3wOPVqSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJvV1qTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B69C606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJvV1qTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742C41F00893
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795799477;
	bh=NfLabG6e/zV06L6P8zy2tmyyujko7C31l7rMUc3Ub+I=;
	h=From:To:Subject:Date;
	b=WJvV1qTwM9G5L1iZ1Aa/VCRbQlraxO1/gfX4DFOUeA8GU2R0EM1XroCiB9Ws0ltdN
	 SHesVnmob1ladXnY2yGDSJb4+O8oFFpO/X8NZ88wntlYY54WEZe8Yda4mZhMFq1Orx
	 62KRjJqV+qSp146WSDOyK3WH7ssbAW0TAOXzpPQ1L+sktK9yoiRlU9woxiMZWaY4Zv
	 mliFs1oAzYDkvFDaazCwYYGDYBklE1seCoSJLaRNDrbmxPoaVt2nIqgD1VpR9Bj+h/
	 MyFwHhkMoXWfcrrzBctb3DWynXF7zz5wMDCgAUcwJJtu+5quUpiz95DP18rmkLSs1w
	 awwdM70SdhHpw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: reject rename exchange operations with subvolume stubs
Date: Fri, 27 Nov 2026 17:11:14 +0000
Message-ID: <db82ae780edd7572f150da6b25f2fb73af1e31a9.1795798503.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Currently we are allowing rename exchange operations when one of the paths
points to a subvolume stub (created with new_simple_dir(), due to creating
a snapshot of a subvolume that has subvolumes inside it). This results in
a transaction abort, turning the filesystem into RO mode, since the stubs
are mockup dentries that have no underlying inode, so attempting to search
and delete inode ref items fails during the rename exchange, leading to a
transaction abort with -ENOENT:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  btrfs subvolume create $MNT/subvol
  btrfs subvolume create $MNT/subvol/inner_subvol

  touch $MNT/subvol/file

  btrfs subvolume snapshot $MNT/subvol $MNT/snap

  mv --exchange -T $MNT/snap/file $MNT/snap/inner_subvol

  umount $MNT

Running it:

  $ ./test.sh
  (...)
  Create subvolume '/mnt/sdi/subvol'
  Create subvolume '/mnt/sdi/subvol/inner_subvol'
  Create snapshot of '/mnt/sdi/subvol' in '/mnt/sdi/snap'
  mv: cannot exchange '/mnt/sdi/snap/file' and '/mnt/sdi/snap/inner_subvol': No such file or directory

And dmesg shows a transaction abort:

  $ dmesg
  [277913.996925] BTRFS critical (device sdi): failed to delete reference to inner_subvol, root 258 inode 2 parent 256
  [277913.996950] ------------[ cut here ]------------
  [277913.996951] WARNING: fs/btrfs/inode.c:4399 at __btrfs_unlink_inode+0x3a8/0x420 [btrfs], CPU#0: mv/1549646
  [277914.001156] Modules linked in: btrfs dm_dust loop (...)
  [277914.016365] CPU: 0 UID: 0 PID: 1549646 Comm: mv Tainted: G        W           7.4.0-rc4-btrfs-next-252+ #1 PREEMPT(full)
  [277914.018964] Tainted: [W]=WARN
  [277914.019622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [277914.021892] RIP: 0010:__btrfs_unlink_inode+0x3a8/0x420 [btrfs]
  [277914.023185] Code: 85 c0 78 (...)
  [277914.026865] RSP: 0018:ffffd33e801dfb80 EFLAGS: 00010206
  [277914.028098] RAX: 00000000fffffffe RBX: ffff8c89cc89e000 RCX: 0000000000000000
  [277914.030305] RDX: 000000000000001c RSI: 0000000000000001 RDI: ffff8c89c4bb12c0
  [277914.031978] RBP: ffff8c8f542a9d80 R08: 3fffffffffefffff R09: 0000000000014b83
  [277914.033448] R10: ffffd33e801df840 R11: 0000000000000002 R12: ffff8c8f543bf838
  [277914.034891] R13: ffffd33e801dfca8 R14: ffff8c89defee000 R15: ffff8c89e4c31a10
  [277914.036370] FS:  00007f709e183840(0000) GS:ffff8c913f2ce000(0000) knlGS:0000000000000000
  [277914.037984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [277914.039144] CR2: 00007f709e29ba80 CR3: 0000000524f02004 CR4: 0000000000370ef0
  [277914.040585] Call Trace:
  [277914.041107]  <TASK>
  [277914.041584]  btrfs_rename_exchange+0x37b/0xbf0 [btrfs]
  [277914.042734]  ? inode_set_ctime_current+0x3b/0x220
  [277914.043690]  btrfs_rename2+0x53/0x60 [btrfs]
  [277914.044648]  vfs_rename+0x5b4/0xe40
  [277914.045371]  filename_renameat2+0x222/0x450
  [277914.046256]  __x64_sys_renameat2+0x4e/0x70
  [277914.047091]  do_syscall_64+0x8b/0x490
  [277914.047902]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [277914.048912] RIP: 0033:0x7f709e29ba8f
  [277914.049717] Code: 44 00 00 (...)
  [277914.054201] RSP: 002b:00007fff08b22438 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
  [277914.055699] RAX: ffffffffffffffda RBX: 00007fff08b242d2 RCX: 00007f709e29ba8f
  [277914.057110] RDX: 00000000ffffff9c RSI: 00007fff08b242d2 RDI: 00000000ffffff9c
  [277914.058534] RBP: 00007fff08b242e5 R08: 0000000000000002 R09: 0000000000000001
  [277914.059942] R10: 00007fff08b242e5 R11: 0000000000000202 R12: 0000000000000002
  [277914.061336] R13: 00000000ffffff9c R14: 00000000ffffff9c R15: 00007fff08b22a90
  [277914.062754]  </TASK>
  [277914.063232] ---[ end trace 0000000000000000 ]---
  [277914.064191] BTRFS error (device sdi state A): Transaction 10 aborted (-ENOENT)
  [277914.064195] BTRFS: error (device sdi state A) in __btrfs_unlink_inode:4399: errno=-2 No such entry
  [277914.064197] BTRFS info (device sdi state EA): forced readonly
  [277914.064199] BTRFS: error (device sdi state EA) in btrfs_rename_exchange:8458: errno=-2 No such entry

Fix this by rejecting rename exchange operations against dentries that are
subvolume stubs.

Reported-by: Tianyu Chen <chentianyu@microsoft.com>
Link: https://lore.kernel.org/linux-btrfs/TY8P153MB237624AA8DAAC5323DE20B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM/
Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..69fda53ce340 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8271,6 +8271,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	     new_ino != BTRFS_FIRST_FREE_OBJECTID))
 		return -EXDEV;
 
+	/*
+	 * Subvolume stubs, created with new_simple_dir(), have no associated
+	 * inode so we can not rename exchange.
+	 */
+	if (old_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
+	    new_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+		return -EPERM;
+
 	ret = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname);
 	if (ret)
 		return ret;
-- 
2.53.0

