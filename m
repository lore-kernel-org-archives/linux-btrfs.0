Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AEB274B39
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779620252; cv=none; b=Rk3IDBjszLr41yaMWl3d8dnDwsg5O0U6tQ6vArcM4uKPMrc+d9tGz+1/CYAcMIFq+RrFNApnPwwsCFS+NBV/2RaPbA5dZ+RcaOyeRd6mgTH2+Z5HEm+yEtqLx+2ZJQrh5v/7TwXFy4hFrFSuZntuYRBncVT2YA8yxBSh+bl7/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779620252; c=relaxed/simple;
	bh=JA5XTy0PJm4hpxelwzLSvl7kykbdVL3Y2TVNcXgLOrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P+iPTChWbFN0/7OdeYaQK6H0Elf73uqRmD/ejGVxpor4S/lmiw0ZP9NuWg7lOj16RU775oEXyovjmyZ4lDbaPZ5WsF505P0xjBav/quhxC1fYvbbYh2bESR1T7y4Nm4eeC5YwiRAWcktme+b+e8MnJOEeoz1mu8nd8LG0rtEUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s8byoCl8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s8byoCl8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s8byoCl8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s8byoCl8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B19E3684AB;
	Sun, 24 May 2026 10:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779620210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WconbsFNc6GkyqiJRQPRPZDI1D0/KY5RlmaYZ6/absI=;
	b=s8byoCl8HZAXbuZ+v4Rirc4xKfq6ZvYXe6pb70RkRod0a+IGVFYTOM9DfaXmrlkWOgtktF
	Rzpym480vhCG3eedD329tIK2MGKbdeS9C09DTkOsfzfZbEle5H6Uu9vQbCEFlBnZq3mSRn
	VfOJ+vBX/fm/SwIJpKv9JK2pyjCvzSs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779620210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WconbsFNc6GkyqiJRQPRPZDI1D0/KY5RlmaYZ6/absI=;
	b=s8byoCl8HZAXbuZ+v4Rirc4xKfq6ZvYXe6pb70RkRod0a+IGVFYTOM9DfaXmrlkWOgtktF
	Rzpym480vhCG3eedD329tIK2MGKbdeS9C09DTkOsfzfZbEle5H6Uu9vQbCEFlBnZq3mSRn
	VfOJ+vBX/fm/SwIJpKv9JK2pyjCvzSs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A972359651;
	Sun, 24 May 2026 10:56:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IJVUKXLZEmqsHwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sun, 24 May 2026 10:56:50 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: send: switch struct fs_path to auto freeing
Date: Sun, 24 May 2026 12:56:49 +0200
Message-ID: <20260524105649.593580-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The fs_path can use the auto freeing pattern and it's completely
contained in send. Define the freeing wrapper and add the cleanup
attributes.

Almost all conversions are straightforward, replacing goto with direct
return.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 113 ++++++++++++++++++------------------------------
 1 file changed, 43 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 89d72d8cb85fdf..c36b741dbe6de4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -17,6 +17,7 @@
 #include <linux/compat.h>
 #include <linux/crc32c.h>
 #include <linux/fsverity.h>
+#include <linux/cleanup.h>
 #include "send.h"
 #include "ctree.h"
 #include "backref.h"
@@ -72,6 +73,8 @@ struct fs_path {
 #define FS_PATH_INLINE_SIZE \
 	sizeof_field(struct fs_path, inline_buf)
 
+static void fs_path_free(struct fs_path *p);
+DEFINE_FREE(fs_path_free, struct fs_path *, fs_path_free(_T))
 
 /* reused for each extent */
 struct clone_root {
@@ -981,7 +984,7 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_inode_ref *iref;
 	struct btrfs_inode_extref *extref;
 	BTRFS_PATH_AUTO_FREE(tmp_path);
-	struct fs_path *p;
+	struct fs_path *p __free(fs_path_free) = NULL;
 	u32 cur = 0;
 	u32 total;
 	int slot = path->slots[0];
@@ -998,11 +1001,8 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 		return -ENOMEM;
 
 	tmp_path = alloc_path_for_send();
-	if (!tmp_path) {
-		fs_path_free(p);
+	if (!tmp_path)
 		return -ENOMEM;
-	}
-
 
 	if (found_key->type == BTRFS_INODE_REF_KEY) {
 		ptr = (unsigned long)btrfs_item_ptr(eb, slot,
@@ -1034,30 +1034,27 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 			start = btrfs_ref_to_path(root, tmp_path, name_len,
 						  name_off, eb, dir,
 						  p->buf, p->buf_len);
-			if (IS_ERR(start)) {
-				ret = PTR_ERR(start);
-				goto out;
-			}
+			if (IS_ERR(start))
+				return PTR_ERR(start);
+
 			if (start < p->buf) {
 				/* overflow , try again with larger buffer */
 				ret = fs_path_ensure_buf(p,
 						p->buf_len + p->buf - start);
 				if (ret < 0)
-					goto out;
+					return ret;
 				start = btrfs_ref_to_path(root, tmp_path,
 							  name_len, name_off,
 							  eb, dir,
 							  p->buf, p->buf_len);
-				if (IS_ERR(start)) {
-					ret = PTR_ERR(start);
-					goto out;
-				}
+				if (IS_ERR(start))
+					return PTR_ERR(start);
+
 				if (unlikely(start < p->buf)) {
 					btrfs_err(root->fs_info,
 			  "send: path ref buffer underflow for key " BTRFS_KEY_FMT,
 						  BTRFS_KEY_FMT_VALUE(found_key));
-					ret = -EINVAL;
-					goto out;
+					return -EINVAL;
 				}
 			}
 			p->start = start;
@@ -1065,17 +1062,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 			ret = fs_path_add_from_extent_buffer(p, eb, name_off,
 							     name_len);
 			if (ret < 0)
-				goto out;
+				return ret;
 		}
 
 		cur += elem_size + name_len;
 		ret = iterate(dir, p, ctx);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
-out:
-	fs_path_free(p);
 	return ret;
 }
 
@@ -2028,7 +2023,7 @@ static int is_first_ref(struct btrfs_root *root,
 			const char *name, int name_len)
 {
 	int ret;
-	struct fs_path *tmp_name;
+	struct fs_path *tmp_name __free(fs_path_free) = NULL;
 	u64 tmp_dir;
 
 	tmp_name = fs_path_alloc();
@@ -2037,17 +2032,13 @@ static int is_first_ref(struct btrfs_root *root,
 
 	ret = get_first_ref(root, ino, &tmp_dir, NULL, tmp_name);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	if (dir != tmp_dir || name_len != fs_path_len(tmp_name)) {
-		ret = 0;
-		goto out;
-	}
+	if (dir != tmp_dir || name_len != fs_path_len(tmp_name))
+		return 0;
 
 	ret = !memcmp(tmp_name->start, name, name_len);
 
-out:
-	fs_path_free(tmp_name);
 	return ret;
 }
 
@@ -2196,13 +2187,13 @@ static int did_overwrite_ref(struct send_ctx *sctx,
  */
 static int did_overwrite_first_ref(struct send_ctx *sctx, u64 ino, u64 gen)
 {
-	int ret = 0;
-	struct fs_path *name = NULL;
+	int ret;
+	struct fs_path *name __free(fs_path_free) = NULL;
 	u64 dir;
 	u64 dir_gen;
 
 	if (!sctx->parent_root)
-		goto out;
+		return 0;
 
 	name = fs_path_alloc();
 	if (!name)
@@ -2210,14 +2201,10 @@ static int did_overwrite_first_ref(struct send_ctx *sctx, u64 ino, u64 gen)
 
 	ret = get_first_ref(sctx->parent_root, ino, &dir, &dir_gen, name);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	ret = did_overwrite_ref(sctx, dir, dir_gen, ino, gen,
-			name->start, fs_path_len(name));
-
-out:
-	fs_path_free(name);
-	return ret;
+	return did_overwrite_ref(sctx, dir, dir_gen, ino, gen,
+				 name->start, fs_path_len(name));
 }
 
 static inline struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
@@ -2375,7 +2362,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 			struct fs_path *dest)
 {
 	int ret = 0;
-	struct fs_path *name = NULL;
+	struct fs_path *name __free(fs_path_free) = NULL;
 	u64 parent_inode = 0;
 	u64 parent_gen = 0;
 	int stop = 0;
@@ -2389,10 +2376,8 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	}
 
 	name = fs_path_alloc();
-	if (!name) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!name)
+		return -ENOMEM;
 
 	dest->reversed = 1;
 	fs_path_reset(dest);
@@ -2437,7 +2422,6 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	}
 
 out:
-	fs_path_free(name);
 	if (!ret) {
 		fs_path_unreverse(dest);
 		if (is_cur_inode && dest != &sctx->cur_inode_path)
@@ -2787,7 +2771,7 @@ static int trim_dir_utimes_cache(struct send_ctx *sctx)
 static int send_create_inode(struct send_ctx *sctx, u64 ino)
 {
 	int ret = 0;
-	struct fs_path *p;
+	struct fs_path *p __free(fs_path_free) = NULL;
 	int cmd;
 	struct btrfs_inode_info info;
 	u64 gen;
@@ -2801,7 +2785,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 	if (ino != sctx->cur_ino) {
 		ret = get_inode_info(sctx->send_root, ino, &info);
 		if (ret < 0)
-			goto out;
+			return ret;
 		gen = info.gen;
 		mode = info.mode;
 		rdev = info.rdev;
@@ -2826,17 +2810,16 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 	} else {
 		btrfs_warn(sctx->send_root->fs_info, "unexpected inode type %o",
 				(int)(mode & S_IFMT));
-		ret = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	ret = begin_cmd(sctx, cmd);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = gen_unique_name(sctx, ino, gen, p);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_INO, ino);
@@ -2845,7 +2828,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 		fs_path_reset(p);
 		ret = read_symlink(sctx->send_root, ino, p);
 		if (ret < 0)
-			goto out;
+			return ret;
 		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH_LINK, p);
 	} else if (S_ISCHR(mode) || S_ISBLK(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
@@ -2855,12 +2838,9 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 
 	ret = send_cmd(sctx);
 	if (ret < 0)
-		goto out;
-
+		return ret;
 
 tlv_put_failure:
-out:
-	fs_path_free(p);
 	return ret;
 }
 
@@ -3039,7 +3019,7 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 			  struct fs_path *path)
 {
 	int ret;
-	struct fs_path *orphan;
+	struct fs_path *orphan __free(fs_path_free) = NULL;
 
 	orphan = fs_path_alloc();
 	if (!orphan)
@@ -3047,17 +3027,15 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 
 	ret = gen_unique_name(sctx, ino, gen, orphan);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = send_rename(sctx, path, orphan);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (ino == sctx->cur_ino && gen == sctx->cur_inode_gen)
 		ret = fs_path_copy(&sctx->cur_inode_path, orphan);
 
-out:
-	fs_path_free(orphan);
 	return ret;
 }
 
@@ -3467,9 +3445,9 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
 
 static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 {
-	struct fs_path *from_path = NULL;
-	struct fs_path *to_path = NULL;
-	struct fs_path *name = NULL;
+	struct fs_path *from_path __free(fs_path_free) = NULL;
+	struct fs_path *to_path __free(fs_path_free) = NULL;
+	struct fs_path *name __free(fs_path_free) = NULL;
 	u64 orig_progress = sctx->send_progress;
 	struct recorded_ref *cur;
 	u64 parent_ino, parent_gen;
@@ -3482,10 +3460,8 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
-	if (!name || !from_path) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!name || !from_path)
+		return -ENOMEM;
 
 	dm = get_waiting_dir_move(sctx, pm->ino);
 	ASSERT(dm);
@@ -3599,9 +3575,6 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	}
 
 out:
-	fs_path_free(name);
-	fs_path_free(from_path);
-	fs_path_free(to_path);
 	sctx->send_progress = orig_progress;
 
 	return ret;
-- 
2.54.0

