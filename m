Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6A2DEA93
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854610; cv=none; b=BHpL2zNA9HkXHGOxr5UtGf98hx3hhg31MLFrtdUNv1Iy20BIc29ERvT9VqufQLeQlfkRj/KmWGquuxRdXU7GRhrbNFMhs+vkRaX1yKBMU7Mm7mFPdCN42WhO4oraQiktXWKODy05BuqX7CqhnEmqbixaciYlMrCyFFt610yPIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854610; c=relaxed/simple;
	bh=8RJvzG96TFPq4fPvgAIy5tDbOWpkrpxVcn0TTiNmMKU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuctUw/KLFnAuAbm+Uulye1ZzczH7n1BQG4FiAsImnmrzR7TGjWTdoiv1iO8Cu+nkUNxn2IhJYvIcqOkSh7X0/+lWwybpMZOIUtxZuPuLFtuStWAZXf1WVLeAvMK2LD6YYNgAJPx18hCOKZQBr1zO+g1LUwrf67OlK34jUW4lZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aE9FnlnW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aE9FnlnW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aE9FnlnW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aE9FnlnW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 705AF4D41C
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eIOpRbkox/qfrn0Z/FhJJoewGDg53upTYJtcCpzVjoc=;
	b=aE9FnlnWMiUrCT+QItRNP7pRSOLwXGdT605dVP9ikLET1SXfDIsA3saa/Sb8lQ+He4fwu3
	zkS+V92Dx5jGItM/ZMTnx2vJXo6BTsmjGR8+1dDsoMbzfJEGq7DOkWI4ppmpmjNSvLVHRo
	JUuLpGYZ2T436XdnWgI9hj1ZmmcXXAY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aE9FnlnW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eIOpRbkox/qfrn0Z/FhJJoewGDg53upTYJtcCpzVjoc=;
	b=aE9FnlnWMiUrCT+QItRNP7pRSOLwXGdT605dVP9ikLET1SXfDIsA3saa/Sb8lQ+He4fwu3
	zkS+V92Dx5jGItM/ZMTnx2vJXo6BTsmjGR8+1dDsoMbzfJEGq7DOkWI4ppmpmjNSvLVHRo
	JUuLpGYZ2T436XdnWgI9hj1ZmmcXXAY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B23AB4A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SKxXHckhymk8DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: mkfs/rootdir: use a helper to read from source fs
Date: Mon, 30 Mar 2026 17:39:35 +1030
Message-ID: <2c49617dd22bc3884f397f2ce3c939ec5750b7d3.1774854459.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774854459.git.wqu@suse.com>
References: <cover.1774854459.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 705AF4D41C
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

We have 3 pread() call sites that are doing a simple loop to read data
from the source fs.

They have similar and duplicated handling, extract a simple helper,
read_from_source() to handle them all.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 85 +++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 46 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index ed0fcfccd42a..f7712d75aa6f 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -780,6 +780,29 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 	return 0;
 }
 
+static int read_from_source(const struct btrfs_fs_info *fs_info,
+			    const char *path, int fd,
+			    char *buf, u64 filepos, u32 length)
+{
+	u32 cur = 0;
+
+	UASSERT(IS_ALIGNED(filepos, fs_info->sectorsize));
+	UASSERT(length <= MAX_EXTENT_SIZE);
+
+	while (cur < length) {
+		ssize_t ret;
+
+		ret = pread(fd, buf, length - cur, filepos + cur);
+		if (ret < 0) {
+			error("cannot read %s at offset %llu length %u: %m",
+			      path, filepos + cur, length - cur);
+			return -errno;
+		}
+		cur += ret;
+	}
+	return length;
+}
+
 static int add_file_item_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_inode_item *btrfs_inode,
@@ -789,7 +812,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u32 sectorsize = root->fs_info->sectorsize;
-	u64 bytes_read, first_block, to_read, to_write;
+	u64 first_block, to_read, to_write;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item stack_fi = { 0 };
 	u64 buf_size;
@@ -840,24 +863,11 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 
 	buf_size = do_comp ? BTRFS_MAX_COMPRESSED : MAX_EXTENT_SIZE;
 	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
-	bytes_read = 0;
-
-	while (bytes_read < to_read) {
-		ssize_t ret_read;
-
-		ret_read = pread(source->fd, source->buf + bytes_read,
-				 to_read - bytes_read, file_pos + bytes_read);
-		if (ret_read < 0) {
-			error("cannot read %s at offset %llu length %llu: %m",
-			      source->path_name, file_pos + bytes_read,
-			      to_read - bytes_read);
-			return -errno;
-		}
-
-		bytes_read += ret_read;
-	}
-
-	if (bytes_read <= sectorsize)
+	ret = read_from_source(root->fs_info, source->path_name, source->fd,
+			       source->buf, file_pos, to_read);
+	if (ret < 0)
+		return ret;
+	if (to_read <= sectorsize)
 		do_comp = false;
 
 	if (do_comp) {
@@ -866,21 +876,20 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		switch (g_compression) {
 		case BTRFS_COMPRESS_ZLIB:
 			comp_ret = zlib_compress_extent(first_sector, sectorsize,
-							source->buf, bytes_read,
+							source->buf, to_read,
 							source->comp_buf);
 			break;
 #if COMPRESSION_LZO
 		case BTRFS_COMPRESS_LZO:
 			comp_ret = lzo_compress_extent(sectorsize, source->buf,
-						       bytes_read,
-						       source->comp_buf,
+						       to_read, source->comp_buf,
 						       source->wrkmem);
 			break;
 #endif
 #if COMPRESSION_ZSTD
 		case BTRFS_COMPRESS_ZSTD:
 			comp_ret = zstd_compress_extent(first_sector, sectorsize,
-							source->buf, bytes_read,
+							source->buf, to_read,
 							source->comp_buf);
 			break;
 #endif
@@ -905,24 +914,10 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 
 			buf_size = MAX_EXTENT_SIZE;
 			to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
-
-			while (bytes_read < to_read) {
-				ssize_t ret_read;
-
-				ret_read = pread(source->fd,
-						 source->buf + bytes_read,
-						 to_read - bytes_read,
-						 file_pos + bytes_read);
-				if (ret_read < 0) {
-					error("cannot read %s at offset %llu length %llu: %m",
-					      source->path_name,
-					      file_pos + bytes_read,
-					      to_read - bytes_read);
-					return -errno;
-				}
-
-				bytes_read += ret_read;
-			}
+			ret = read_from_source(root->fs_info, source->path_name, source->fd,
+					       source->buf, file_pos, to_read);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
@@ -1301,7 +1296,6 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = -1;
-	ssize_t ret_read;
 	u32 sectorsize = fs_info->sectorsize;
 	u64 file_pos = 0;
 	char *buf = NULL, *comp_buf = NULL, *wrkmem = NULL;
@@ -1340,10 +1334,9 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 			goto end;
 		}
 
-		ret_read = pread(fd, buffer, st->st_size, 0);
-		if (ret_read == -1) {
-			error("cannot read %s at offset %u length %zu: %m",
-			      path_name, 0, st->st_size);
+		ret = read_from_source(fs_info, path_name, fd, buffer,
+					    0, st->st_size);
+		if (ret < 0) {
 			free(buffer);
 			goto end;
 		}
-- 
2.53.0

