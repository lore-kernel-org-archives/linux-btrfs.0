Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B130C16B
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 06:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782456764; cv=none; b=cotltuJ29f3g4ZbUsvUM6+LstsyFZC/FNWsHY0ZsR4p1i+oEnIeH4PhB1OJMRx0WZGpwhoei4q5h7UA7nAWMs5T5kZ0qE8lMX8H1L6WD+p+bM6XVLOn1SshIzLOK+2Dp/tbgTTro7Pn8iJAFxEqrGI7P82vhRexEDU9RQbq010g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782456764; c=relaxed/simple;
	bh=kI+DDXIGID+BJDlTBPovM/DoGhMkeFD5F+WNLd7Acd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YdymNj3Se2he80IoXBkrGQ0bHcpVcYRsXrDgyvl9B+gulTmgj+W1NhX+qHeQs4HBRXZYjd7Hh8oVY2WlqL1HCq7ZB0JgmCST2oCQLFNgII3hliz10E2mhqIjVwJeqxtQ5KJakO0h71hFC1SbPIFdPKBpDATT/57NcWaeAcKbAww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=ei4Iixz8; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="ei4Iixz8"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4gmmQd6H0fzKJVhD4;
	Fri, 26 Jun 2026 14:45:45 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1782456346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xo3vJKKf4aPCoLLxrdju4yryD8V6qFeou6kW0HmaPqs=;
	b=ei4Iixz82AHSQl2/CdQIRbYckbQQWCRvjOFUaRQJYtk7sHeD/AMY6aEWDqDjFAap+lomKu
	+TxoLldyWeihuKXVXfN2YJQD5zHAmq5ILIgJZP3xNyKNXrKDN0T9CFDXXV0/rgVZ7tAJ8F
	R5nsRFP2x+CO6RrCL1RKe4Tr/2U1B0E=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
Date: Fri, 26 Jun 2026 14:45:24 +0800
Message-ID: <20260626064524.2288234-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
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

btrfs_getattr() unconditionally reads BTRFS_I(inode)->new_delalloc_bytes
and adds it (sector-aligned) to stat->blocks for every inode type.
However, new_delalloc_bytes lives in a union with last_dir_index_offset:

    union {
        u64 new_delalloc_bytes;     /* files only */
        u64 last_dir_index_offset;  /* directories only */
    };

For a directory inode this memory holds last_dir_index_offset, which is
set during directory logging (e.g. flush_dir_items_batch()) to the
offset of the last logged BTRFS_DIR_INDEX_KEY.  That offset grows with
the number of entries ever created in the directory (dir indexes are
monotonic and never reused), so it can be arbitrarily large.

As a result, after a directory has been logged (e.g. via an fsync that
triggers directory logging), btrfs_getattr() reports inflated st_blocks
for that directory.  The inflation is purely in-core and disappears
after the inode is evicted and reloaded (btrfs_alloc_inode() zeroes the
union), e.g. after a remount.

Reproducer (on a btrfs filesystem):

    D=/mnt/btrfs/d
    mkdir -p $D
    for i in $(seq 1 20000); do touch $D/f$i; done
    sync                      # commit, push dir index high
    touch $D/trigger          # dirty the dir in a new transaction
    xfs_io -c fsync $D        # log the directory -> sets last_dir_index_offset
    stat -c '%b' $D           # st_blocks is now inflated (e.g. 40)
    # umount + mount -> st_blocks drops back to the correct value

The evict path already knows this union is type-dependent and guards the
corresponding WARN_ON with !S_ISDIR() in btrfs_destroy_inode(); only
btrfs_getattr() was missing the equivalent check.

Only read new_delalloc_bytes for regular files, which are the only
inodes that ever set it.

Signed-off-by: Dave Chen <davechen@synology.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272598f6ae77..b446c3014b24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8068,7 +8068,8 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	stat->result_mask |= STATX_SUBVOL;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
+	delalloc_bytes = S_ISREG(inode->i_mode) ?
+			 BTRFS_I(inode)->new_delalloc_bytes : 0;
 	inode_bytes = inode_get_bytes(inode);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_bytes, blocksize) +
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
