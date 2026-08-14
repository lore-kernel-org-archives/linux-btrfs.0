Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B82737F9
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 05:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684892; cv=none; b=S5bsNxFFoFf8/MrhSfrrNrmCFbnK1wnWww1K5iQHGvvWwVKZqVSOxiS/+Io4xdnO9pCKpw6k4iYuxEu5P+LNfpmE96434PAfZ+JcTWMA6u+3HVwDSV3vJztI5PJoHUdpPcti/ifzIN0risyx10MK9r74esiex9H2pL8TZseYEsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684892; c=relaxed/simple;
	bh=eK3dD2xj7oq8TzQCIuDJcARFAcjN6JN+C3tHT2eQdes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=JPEQi2isQOdruILOXx6VnHTYkDxW8UtVYix2iG7t9eyNJXUBKa/GfjHCQecdj3tO7X1AV4Rj4CK++TyC3phhOWmW+4WECY4mx236uwTMirdaKzh05AdkZXdXadZ+zsqOkkdHu8vFZHCSuW+KSsmnABPoBuxa86jcZq//eiQzZZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=Hy5zkaA/; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Hy5zkaA/"
From: Sam Ho <samho@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1786684458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/fAoz+K+eSXsvNeNzBojpz07xsO1JTAxCjKcFXxl8oc=;
	b=Hy5zkaA/5c2yZCjjTQmyt27Ru8xM8+YzoxJpIuSD5wm5xhYPpPCDgziQ493x/wmqIi4DKs
	K+2Mp/LiJLDxr//btLZYNE6tNOBC77GrdgL0ek/HQkbK3dFJXXLa6UNofjJSbaK3VHaajf
	Vk+YPeGKyynQYDuj4AW9FFi/fz5OEgM=
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	Sam Ho <samho@synology.com>
Subject: [PATCH] btrfs: preserve the compression property when other inode flags change
Date: Fri, 14 Aug 2026 05:14:06 +0000
Message-Id: <20260814051406.1244006-1-samho@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
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

Only pick the default algorithm when compression is actually being enabled
by this call, that is when FS_COMPR_FL was not set before, and otherwise
keep the algorithm recorded in the property. Inodes that have the compress
flag set but no property still get the default, so they behave as before.

Signed-off-by: Sam Ho <samho@synology.com>
---
 fs/btrfs/ioctl.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index baa645e98812..2e54694f06f7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -384,9 +384,25 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		inode_flags |= BTRFS_INODE_COMPRESS;
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
-		comp = btrfs_compress_type2str(fs_info->compress_type);
-		if (!comp || comp[0] == 0)
-			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
+		/*
+		 * If compression was already enabled, keep the algorithm that
+		 * is recorded in the compression property. Otherwise changing
+		 * an unrelated attribute would reset it to the mount default,
+		 * since FS_IOC_SETFLAGS callers pass back the whole flag set
+		 * they got from FS_IOC_GETFLAGS.
+		 *
+		 * Fall back to the default when compression is being enabled
+		 * by this call, or when the inode has the compress flag set
+		 * but no property, which is possible on filesystems touched by
+		 * kernels that did not keep the two in sync.
+		 */
+		if (old_fsflags & FS_COMPR_FL)
+			comp = btrfs_compress_type2str(inode->prop_compress);
+		if (!comp || comp[0] == 0) {
+			comp = btrfs_compress_type2str(fs_info->compress_type);
+			if (!comp || comp[0] == 0)
+				comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
+		}
 	} else {
 		inode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
