Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCE4383326
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 23:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960437; cv=none; b=iD2Ual3+Fg3A3pGmO3AKcr82wLzMd1QSLQYBiIdnICUEnEZA+0enwaEM2ZlKmNC5LNdVHemPM9chOXNlHQjhiqZ+kZKPsJj/37d3Y+1ocJJpbxjRFIZrW1vgw25NR3nuy67eHb3EbP4vz2dkgkaoOaRXarI/jOGFWVCN9x1BmfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960437; c=relaxed/simple;
	bh=8tHflrqHl6O4nNl9x7SBJEJN7t+NnZMBl6GC7Vil3nE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c2H77+4Z1sFmtz1ZhfeEgl4ma9FVIT9eFo3IaB7gHULQlKHIP6sUL81auGSTmbYuDIE/H7kcBe15JEmbJCLa4/a86DA0dIFqTXvFUgExGpbiCY/tWxPYwtlUF2RFGYnWtfZo809BrLpsVgVV8HWPdjnrOBniCFgNXkKbObIHktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VFTKe9Lq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VFTKe9Lq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VFTKe9Lq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VFTKe9Lq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DAA56ABBE;
	Mon,  8 Jun 2026 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780960434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LlvBQsiL003PVCm6VH36t+0S85szQST49CUrtvdfmt4=;
	b=VFTKe9LqhAEvaaMQEjSOkA+8vRfTM/rqDHMxsCF8EEXWGXbhzePW9htyLYbnwjVGFwkhTv
	6SLe9rENAuvjr7z8/IPCHKSJnB78xNNjHUnqUfD6orSh2P1odoJyV4HBGdFptXDAbinUiZ
	g/KDzGTpp8X303ARBkyDwiJ8uwCeRwU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780960434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LlvBQsiL003PVCm6VH36t+0S85szQST49CUrtvdfmt4=;
	b=VFTKe9LqhAEvaaMQEjSOkA+8vRfTM/rqDHMxsCF8EEXWGXbhzePW9htyLYbnwjVGFwkhTv
	6SLe9rENAuvjr7z8/IPCHKSJnB78xNNjHUnqUfD6orSh2P1odoJyV4HBGdFptXDAbinUiZ
	g/KDzGTpp8X303ARBkyDwiJ8uwCeRwU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC819779A7;
	Mon,  8 Jun 2026 23:13:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 92i0JbBMJ2rcSQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 08 Jun 2026 23:13:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2] btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag
Date: Tue,  9 Jun 2026 08:43:34 +0930
Message-ID: <5ab8c8dba417f4d558c6849130b3072a6b2b3574.1780960338.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[TEST FAILURE]
The test case generic/628 will fail if MOUNT_OPTIONS is set to "-o
nodatasum":

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #383 SMP PREEMPT_DYNAMIC Sat May 30 07:35:42 ACST 2026
 MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 generic/628  1s ... - output mismatch (see /home/adam/xfstests/results//generic/628.out.bad)
    --- tests/generic/628.out	2022-05-11 11:25:30.816666664 +0930
    +++ /home/adam/xfstests/results//generic/628.out.bad	2026-06-08 18:56:49.878542927 +0930
    @@ -8,8 +8,9 @@
     310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
     310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
     test reflink flag not set iflag
    +XFS_IOC_CLONE: Invalid argument
     310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
    -310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
    +d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/b
    ...

[CAUSE]
The direct cause is that after "chattr +S", the btrfs inode will lose its
NODATASUM flag inherited from the mount option. E.g:

 # mkfs.btrfs -f $dev
 # mount $dev $mnt -o nodatasum
 # touch $mnt/foobar
 # sync
 # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 9 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x1(NODATASUM)
		                     ^^^^^^^^^ Proper NODATASUM flag

 # chattr +S $mnt/foobar
 # sync
 # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
 	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 10 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 2 flags 0x20(SYNC)
		                      ^^^^ Only the new SYNC flag

This makes the inode to drop the old NODATASUM flag, meanwhile the new
reflink destination will still inherit the NODATASUM flag.
The mismatching NODATASUM flags will cause the reflink to fail.

The root cause is that, inside btrfs_fileattr_set() if no FS_NOCOW_FL is
set, we remove both NODATASUM and NODATACOW flag.

However we should not touch NODATASUM flag, as data COW doesn't require
checksum.
Only NODATACOW implies NODATASUM, but DATACOW doesn't imply DATASUM.

The deeper problems are:

- Fileattr API is too binary
  It either clears or sets a flag, there is no "do not change" option.
  So that why "chattr +S" implies "chattr -C", and is forcing us to
  change NODATACOW along with NODATASUM flag.

- No way to change NODATASUM through fileattr API
  In fact NODATASUM can only be modified through mount option.

The deeper problems are much harder to attack.

[FIX]
Remove NODATACOW flag when FS_NOCOW_FL is not set, but only remove
NODATASUM if "nodatasum" mount option is not set.

This allows the existing "chattr +C" then "chattr -C" to remove
both NODATACOW and NODATASUM flags on a default mount.

But for a mount with "nodatasum" option, the NODATASUM inode flag will
persist through either "chattr +C" and "chattr -C".

Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file via ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Respect the current mount option when setting DATACOW flag
  Since there is no way to set/clear NODATASUM flag other than mount
  option, it's better to respect the current mount option so that
  NODATASUM is not always left unexpectedly.
---
 fs/btrfs/ioctl.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d4981d2a42d7..8e3f51551dfe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -331,14 +331,20 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 			inode_flags |= BTRFS_INODE_NODATACOW;
 		}
 	} else {
-		/*
-		 * Revert back under same assumptions as above
-		 */
-		if (S_ISREG(inode->vfs_inode.i_mode)) {
-			if (inode->vfs_inode.i_size == 0)
-				inode_flags &= ~(BTRFS_INODE_NODATACOW |
-						 BTRFS_INODE_NODATASUM);
-		} else {
+		/* We can only change NODATACOW for zero-sized regular file. */
+		if (S_ISREG(inode->vfs_inode.i_mode) && (inode->vfs_inode.i_size == 0)) {
+			inode_flags &= ~BTRFS_INODE_NODATACOW;
+			/*
+			 * There is no way to change NODATASUM flag through fileattr API.
+			 * If we unconditionally keep the current NODATASUM flag,
+			 * chattr +C then chattr -C will keep the NODATASUM flag, and
+			 * no way to remove that flag.
+			 *
+			 * So respect the current mount option for NODATASUM flag.
+			 */
+			if (!btrfs_test_opt(fs_info, NODATASUM))
+				inode_flags &= ~BTRFS_INODE_NODATASUM;
+		} else if (!S_ISREG(inode->vfs_inode.i_mode)) {
 			inode_flags &= ~BTRFS_INODE_NODATACOW;
 		}
 	}
-- 
2.54.0

