Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3A46DFF0
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 13:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786712511; cv=none; b=hMszLHxdjGTQ3IBxo5vakCNOiyL1gfcdwyNPAYxXg713z+4Q/u3CWeUEQEz8Ih6PyE54OQ2Tso8w4ICixHVjQrxHrFOOz7xmt7WhkgX+TtoWCR40iKoUR0R50CP7b6x+JBXnosTXxJhWAN42dYwzBZQStwP1q7hJlA5lqzlOiuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786712511; c=relaxed/simple;
	bh=PwcoXm2AnLZ+B99EWtanloYYfW0KNuq6olTNYmjwLgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=foiLySsIx5E7+UvvDawkRRqEiEaq37ve9c2Kvp/NmGnEUYNhcKUep3Bn5auwCzcKlP9GOTV72bRbQN9zvCrELlcz6NYQM7m6g3B9N70u09fW08OkSXc+Axx60r0aPEX0nDCCcsI97E5YSeeeFWxNP+78UCJPqYmCtCHIvwcgKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=W6liPOiW; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="W6liPOiW"
From: Sam Ho <samho@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1786712506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMINqNnFJFZ5sBo7axXdVdYBmlm4DHuJJhid9EuLBag=;
	b=W6liPOiWciAedaRLGMBaiM0xR1H/0IUar5EOv56jR6nMOMJR2/D+bSJMCr02Wqtcn5jzDz
	RPlA9sDkEfxS3wAOftp7vjLUciD770wFwkyQa93tWWfxZ0z42t3BD6xUTPiOOurTZB6YVP
	oZ3IyKJpoBkd9DWxaGBvUoiDXkcCReU=
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	Sam Ho <samho@synology.com>
Subject: [PATCH v2] btrfs: preserve the compression property when other inode flags change
Date: Fri, 14 Aug 2026 13:01:11 +0000
Message-Id: <20260814130111.1258093-1-samho@synology.com>
In-Reply-To: <20260814051406.1244006-1-samho@synology.com>
References: <20260814051406.1244006-1-samho@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass
Content-Type: text/plain

Setting the compression property on an inode also sets BTRFS_INODE_COMPRESS
on it, and btrfs_inode_flags_to_fsflags() reports that back as FS_COMPR_FL
to FS_IOC_GETFLAGS. chattr(1), like any other FS_IOC_SETFLAGS caller, reads
the current flags, flips only the bit the user asked for and writes the
whole set back, so a request as unrelated as "chattr +i" reaches
btrfs_fileattr_set() with FS_COMPR_FL set.

btrfs_fileattr_set() takes that as a request to enable compression and
overwrites the compression property with the algorithm from the mount
options, falling back to zlib when the filesystem was not mounted with
-o compress. The algorithm the user selected is silently replaced:

  # btrfs property set /mnt/foo compression zstd
  # btrfs property get /mnt/foo compression
  compression=zstd
  # chattr +i /mnt/foo
  # btrfs property get /mnt/foo compression
  compression=zlib

Every chattr operation triggers this, not just +i, and directories are
affected as well, so files created afterwards inherit the wrong algorithm
too. On a filesystem mounted with -o compress=lzo the property is replaced
with lzo instead. Recovering needs a chattr -i first, because the immutable
flag rejects the setxattr that "btrfs property set" issues.

Prefer the algorithm recorded in the compression property and only fall
back to the mount default when there is no property, so that unrelated
flag changes no longer overwrite the user's choice. Inodes that have the
compress flag set but no property still get the default, so they behave
as before.

Signed-off-by: Sam Ho <samho@synology.com>
---
v2:
 - Pick the compression type first and convert it to a string only once at
   the end, instead of going through btrfs_compress_type2str() for every
   candidate, and check inode->prop_compress directly rather than testing
   old_fsflags for FS_COMPR_FL. Suggested by Qu Wenruo; the two are
   equivalent, since prop_compression_apply() only leaves prop_compress
   set while BTRFS_INODE_COMPRESS is set.
 - Reword the last changelog paragraph and the comment to match.

v1: https://lore.kernel.org/linux-btrfs/20260814051406.1244006-1-samho@synology.com/

 fs/btrfs/ioctl.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index baa645e98812..343d089aa5c3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -377,6 +377,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags &= ~BTRFS_INODE_COMPRESS;
 		inode_flags |= BTRFS_INODE_NOCOMPRESS;
 	} else if (fsflags & FS_COMPR_FL) {
+		enum btrfs_compression_type comp_type;
 
 		if (IS_SWAPFILE(&inode->vfs_inode))
 			return -ETXTBSY;
@@ -384,9 +385,23 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags |= BTRFS_INODE_COMPRESS;
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
-		comp = btrfs_compress_type2str(fs_info->compress_type);
-		if (!comp || comp[0] == 0)
-			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
+		/*
+		 * Keep the algorithm recorded in the compression property,
+		 * otherwise changing an unrelated attribute would reset it to
+		 * the mount default, since FS_IOC_SETFLAGS callers write back
+		 * the whole flag set they got from FS_IOC_GETFLAGS and that
+		 * includes FS_COMPR_FL for any inode carrying the property.
+		 *
+		 * Inodes with the compress flag set but no property keep using
+		 * the mount default, so they behave as before.
+		 */
+		if (inode->prop_compress)
+			comp_type = inode->prop_compress;
+		else if (fs_info->compress_type)
+			comp_type = fs_info->compress_type;
+		else
+			comp_type = BTRFS_COMPRESS_ZLIB;
+		comp = btrfs_compress_type2str(comp_type);
 	} else {
 		inode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
