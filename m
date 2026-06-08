Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6433845B0
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912071; cv=none; b=PqLC/l5XVX2s/3ibd4FypZZ7SoWEP7bt/tPccqAKCwlDmJvFQ6KA1FQM+1i7chyAF4vJI1JSljahEfiaG1UERSS4WXaOshjqrI0VgUafKeeObJeLemrxDsjZHEx3s5J1neRzuSJueIHRU3CSd4e7jFX/BfQYx4XZXRQ7X6LR3i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912071; c=relaxed/simple;
	bh=OqFQNVq3mGgw9H6HLnSpey7gP/UjiiTXB8dvfyiyheE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KwtWXPevxXOSPnkSaFI9SVy5sRz2mpolV+ajjwdpOFLui2S4jB+fpU7/K7TWJoXW4jIX15JsLSZBD91vGB7ITZ/CuyTpfJWrqiVnNstsz8nyY1aIDGwpOTwsEYQ3obD6t5dWqOt99rF6XefwQNdqWP4VsDZ+GsSIeF1A2WEhW54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vEe6Gobk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vEe6Gobk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vEe6Gobk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vEe6Gobk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D91C75B97;
	Mon,  8 Jun 2026 09:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780912068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=618cYawuFXVDbk3rEh3uFMPq+ZlK7cJ5wS5VV9i6mTY=;
	b=vEe6GobkYZm9xd65HtEd3ihea8A1Dankt9XtwucCSS2cCpcVN57ia0rPdoLh0Oodzn1sZQ
	S1sFUTwDuOMm0J5Lu1ca5RMAn4olfLQ1rTH2Pn4ng0ljLYZvlceLDl/Po/LFHxdb0eibtE
	OZn+B5PCNh9rrfA2R8ODH2+iP3T4ZIw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780912068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=618cYawuFXVDbk3rEh3uFMPq+ZlK7cJ5wS5VV9i6mTY=;
	b=vEe6GobkYZm9xd65HtEd3ihea8A1Dankt9XtwucCSS2cCpcVN57ia0rPdoLh0Oodzn1sZQ
	S1sFUTwDuOMm0J5Lu1ca5RMAn4olfLQ1rTH2Pn4ng0ljLYZvlceLDl/Po/LFHxdb0eibtE
	OZn+B5PCNh9rrfA2R8ODH2+iP3T4ZIw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A269779A9;
	Mon,  8 Jun 2026 09:47:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pegvA8OPJmrHGQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 08 Jun 2026 09:47:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag
Date: Mon,  8 Jun 2026 19:17:24 +0930
Message-ID: <e0be9c192cf8896a7f02ae23880f8e4921102129.1780912039.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
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
X-Spam-Score: -2.80

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
The direct cause is that after "chattr +S", the btrfs inode will lost its
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

[FIX]
Do not remove NODATASUM flag when FS_NOCOW_FL is not set.

However this will introduce a problem related to "chattr +C" then
"chattr -C" on zero sized files.

Previously such operations will revert to inode flags 0, but now it will
revert to inode flags NODATASUM.
This is due to the fact that we have no way to change NODATASUM flag but
only through mount options.

I know this is not ideal, but at least "chattr +S" removing unrelated
flags looks more serious and more like a bug.

So here I'm fine to slightly change the behavior of "chattr -C".

Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file via ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d4981d2a42d7..74849a4208b5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -336,8 +336,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		 */
 		if (S_ISREG(inode->vfs_inode.i_mode)) {
 			if (inode->vfs_inode.i_size == 0)
-				inode_flags &= ~(BTRFS_INODE_NODATACOW |
-						 BTRFS_INODE_NODATASUM);
+				inode_flags &= ~BTRFS_INODE_NODATACOW;
 		} else {
 			inode_flags &= ~BTRFS_INODE_NODATACOW;
 		}
-- 
2.54.0

