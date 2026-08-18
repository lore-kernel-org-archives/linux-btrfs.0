Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7F4499B1
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045414; cv=none; b=Ryw2Ji2t3GNhsdG1OOcxijFXD1d5jSUCeF/Yi3jPyyo+Rr0uk7RVJGJwglx1ZTOl96H9QGqG5pXY2I2G25vDvXZDVHnPQb1aStjm44wNDTVvMR1J5/vOaIOpwkEC4f8Q8otGAUmmmbNoPHSPQc5qELStRnsaTcQOSg7nyBlSfpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045414; c=relaxed/simple;
	bh=ufpwKmovFnPlolFDlSj/yLKYCNxwoI/7C31TwR2149Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ0tFPcDRGLs8Q8YP8IVCu3N7IzIW50Gn5INWe6KzRP2sPxM3GizJMpUxejbpATipW59VJ9DbEgcqSHP0YC7Snx0fqo4ZD1h4bJz4yurES7tYldjU5nRvf/Of2CYk5QG7oWaHwCXawWDJhED9lUKpLTvVmXi1GhFWaEPi/ALqEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PaWHMQYz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eYnFy9eT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PaWHMQYz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eYnFy9eT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B83F8449F
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BoVrpwm+Hb4huH5dd/aHzowQB4/YrNfTp6akkTTg/0=;
	b=PaWHMQYzIm+WBqQqCei03Qo06Txk7Wa6cgPUXhwl2AJWWfu0XU+5Glks9P+vXNq+eP+2p+
	SdTHS3bnn75CGzX9t37vTuMAXthTq7HviF/sxQyB2NrZhdxrgE9nd31TmYzAU5xxZS+mUV
	jwN2S+9hWJtgLxVHtEXFXS7HZHsx0xw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BoVrpwm+Hb4huH5dd/aHzowQB4/YrNfTp6akkTTg/0=;
	b=eYnFy9eTpBBfroaSkWgrneegcFYKqBS70Tb+3U0MBz7r45xGjSVdciQ2kfhZMRRP5D4bjX
	C3VeAZGF2LUm8pbW3XJT+3hrGW1suHeJPrEEj/04AFfFJY9cfHLCa0LzPmzpvoe+F0JJoW
	vbzmM6RQdIjyp+cNMSnHGDA+q0AJcbU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EB0822BA
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GNMSORkmhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs-progs: check: detect invalid file extent items
Date: Tue, 18 Aug 2026 18:59:34 +0930
Message-ID: <aa7d6552b90ddcb8ff836ad5756474e187e545c8.1787045341.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1787045341.git.wqu@suse.com>
References: <cover.1787045341.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

File extent items should only exist for regular and symlink inodes.
And for symlink inodes, the file extent must be inlined.

Add such check for lowmem mode to detect those invalid file extents.

Now for a corrupted image with the following fs tree layout:

	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 9 size 12 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..
	item 2 key (256 DIR_ITEM 496027801) itemoff 16075 itemsize 36
		location key (257 INODE_ITEM 0) type BLKDEV
		transid 9 data_len 0 name_len 6
		name: foobar
	item 3 key (256 DIR_INDEX 2) itemoff 16039 itemsize 36
		location key (257 INODE_ITEM 0) type BLKDEV
		transid 9 data_len 0 name_len 6
		name: foobar
	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 9 size 8192 nbytes 8192
		block group 0 mode 60660 links 1 uid 0 gid 0 rdev 0
		sequence 2 flags 0x0(none)
	item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
		index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
		generation 9 type 1 (regular)
		extent data disk byte 13631488 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)

Lowmem mode will detect the error like the following:

 [5/8] checking fs roots
 ERROR: root 5 ino 257 should not have file extent
 ERROR: root 5 INODE[257] nbytes 8192 not equal to extent_size 0
 ERROR: errors found in fs roots
 found 172032 bytes used, error(s) found

For the original mode, it's less strict than the lowmem mode, and it
only rejects the obvious cases, without the extra verification on
inlined extent for symlinks:

 [5/8] checking fs roots
 root 5 inode 257 errors 40, bad file extent
 ERROR: errors found in fs roots
 found 172032 bytes used, error(s) found

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c        |  5 +++++
 check/mode-lowmem.c | 26 ++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/check/main.c b/check/main.c
index 3f162ad408d1..b96498294645 100644
--- a/check/main.c
+++ b/check/main.c
@@ -844,6 +844,11 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 	if (!rec->found_inode_item)
 		return;
 
+	/* If it's not REG or SYMLNK, there should be no file extent. */
+	if (is_valid_imode(rec->imode) && !S_ISREG(rec->imode) &&
+	    !S_ISLNK(rec->imode) && rec->found_file_extent)
+		rec->errors |= I_ERR_BAD_FILE_EXTENT;
+
 	filetype = imode_to_type(rec->imode);
 	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
 		if (backref->found_dir_item && backref->found_dir_index) {
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index a3c590051054..813e29e2a9bb 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2093,8 +2093,8 @@ static int check_file_extent_inline(struct btrfs_root *root,
  * Return 0 if no error occurred.
  */
 static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
-			     unsigned int nodatasum, u64 isize, u64 *size,
-			     u64 *end)
+			     unsigned int nodatasum, u64 isize, u32 mode,
+			     u64 *size, u64 *end)
 {
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key fkey;
@@ -2119,6 +2119,14 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
 	extent_type = btrfs_file_extent_type(node, fi);
 
+	/* Only regular and symlink can have file extents. */
+	if (is_valid_imode(mode) && !S_ISREG(mode) && !S_ISLNK(mode)) {
+		err |= FILE_EXTENT_ERROR;
+		error("root %llu ino %llu should not have file extent",
+			btrfs_root_id(root), fkey.objectid);
+		return err;
+	}
+
 	/* Check extent type */
 	if (extent_type != BTRFS_FILE_EXTENT_REG &&
 	    extent_type != BTRFS_FILE_EXTENT_PREALLOC &&
@@ -2129,6 +2137,13 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		return err;
 	}
 
+	if (S_ISLNK(mode) && extent_type != BTRFS_FILE_EXTENT_INLINE) {
+		err |= FILE_EXTENT_ERROR;
+		error("root %llu ino %llu should not have regular/prealloc file extent",
+		      root->objectid, fkey.objectid);
+		return err;
+	}
+
 	/* Check inline extent */
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
 		return check_file_extent_inline(root, path, size, end);
@@ -2807,12 +2822,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 			err |= ret;
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
-			if (dir) {
-				warning("root %llu DIR INODE[%llu] shouldn't EXTENT_DATA[%llu %llu]",
-					root->objectid, inode_id, key.objectid,
-					key.offset);
-			}
-			ret = check_file_extent(root, path, nodatasum, isize,
+			ret = check_file_extent(root, path, nodatasum, isize, mode,
 						&extent_size, &extent_end);
 			err |= ret;
 			break;
-- 
2.54.0

