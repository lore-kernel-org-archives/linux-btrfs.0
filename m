Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8D2E401
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775709128; cv=none; b=JoDaL3Fdm6DwBhxKksX2mib9qXEGm9PfH1GtIhgcVprDld/+gYMQWkpqNwQV+Pl44yGUDdLqAGDCPVwF1OOY9luYQYR9/zT6pdEx1PqwLfJ5T7SLlnLjJe51XiLTBRM1q9BBIh2Yv7uIwU8JlXP5OMyC5eMZ5aM3MBMtyZjsnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775709128; c=relaxed/simple;
	bh=DMKp0cdAqzpYNzEuRvy4XFp8dmTZ3GDQy8D83EXJBpw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCGP6meAls5EkKSTd9p7WEnhAgtd7eTAGQbuYLrCVHosPYG3D7upc0AuEPqG50Q8FBlZTHSmgBM43G9mZei25vZHnId/HhOVO+pCeT0D6+dqtoB0gdwz1HP04ScgRE66A6HFJoNVCOu+Zkk+IS3iVCWdKm1NO7xiRra0wZtQTu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mXc7Cikh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mXc7Cikh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mXc7Cikh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mXc7Cikh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A1A75BCFB
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14Lh5Vk2AEsXstkv1erBc6dYPXdKKRs7y+cPY47R7Yk=;
	b=mXc7CikhJ8EWf2h5iJXXOWaQxAoY3BCjl01bqfJ3xAdQA2SKx284HlcouylQdJPzufqshv
	9feiapyghNP06sADt6tr1vv5hc1BNEXzQOk4P0Vnaavii/gGJQtiXX/ojs6dO5feNn9flE
	YE6VpERTALo6NWM/V6jSdhBMMTVUkKk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14Lh5Vk2AEsXstkv1erBc6dYPXdKKRs7y+cPY47R7Yk=;
	b=mXc7CikhJ8EWf2h5iJXXOWaQxAoY3BCjl01bqfJ3xAdQA2SKx284HlcouylQdJPzufqshv
	9feiapyghNP06sADt6tr1vv5hc1BNEXzQOk4P0Vnaavii/gGJQtiXX/ojs6dO5feNn9flE
	YE6VpERTALo6NWM/V6jSdhBMMTVUkKk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9634E4A0B5
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SKamELwr12lLIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 04:31:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/5] btrfs-progs: implement the missing btrfs_insert_hole_extent()
Date: Thu,  9 Apr 2026 14:01:15 +0930
Message-ID: <e5b3209b5f8361329087ff7fce417b9af99946d1.1775708393.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775708393.git.wqu@suse.com>
References: <cover.1775708393.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Commit f8efe9f724c0 ("btrfs-progs: sync file-item.h into progs")
introduce the definition of btrfs_insert_hole_extent() but without an
implementation.

Now there are several call sites implementing a simple wrapper to insert
a hole extent. It's time to implement that function, which is pretty
simple, just set the file extent type to REG and set
disk_num_bytes/disk_bytenr to 0 with proper ram_bytes/num_bytes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/file-item.c | 17 +++++++++++++++++
 kernel-shared/file.c      |  6 +-----
 mkfs/rootdir.c            |  8 ++------
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel-shared/file-item.c b/kernel-shared/file-item.c
index c6cd3ce51124..76d6bfdb6824 100644
--- a/kernel-shared/file-item.c
+++ b/kernel-shared/file-item.c
@@ -25,6 +25,23 @@
 #include "kernel-shared/file-item.h"
 #include "kernel-shared/extent_io.h"
 #include "common/internal.h"
+#include "common/messages.h"
+
+int btrfs_insert_hole_extent(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 objectid, u64 pos,
+			     u64 num_bytes)
+{
+	struct btrfs_file_extent_item stack_fi = { 0 };
+	const u32 blocksize = root->fs_info->sectorsize;
+
+	UASSERT(IS_ALIGNED(pos, blocksize));
+	UASSERT(IS_ALIGNED(num_bytes, blocksize));
+
+	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
+	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, num_bytes);
+	return btrfs_insert_file_extent(trans, root, objectid, pos, &stack_fi);
+}
 
 #define MAX_CSUM_ITEMS(r, size) ((((BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
 			       sizeof(struct btrfs_item) * 2) / \
diff --git a/kernel-shared/file.c b/kernel-shared/file.c
index 12cd50e796b9..546e161abfdb 100644
--- a/kernel-shared/file.c
+++ b/kernel-shared/file.c
@@ -150,7 +150,6 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 		     u64 ino, u64 offset, u64 len)
 {
 	struct btrfs_path *path;
-	struct btrfs_file_extent_item stack_fi = { 0 };
 	int ret = 0;
 
 	path = btrfs_alloc_path();
@@ -165,10 +164,7 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_stack_file_extent_num_bytes(&stack_fi, len);
-	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, len);
-	ret = btrfs_insert_file_extent(trans, root, ino, offset, &stack_fi);
+	ret = btrfs_insert_hole_extent(trans, root, ino, offset, len);
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 37191ee427b7..62f7c57c5e4a 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -411,8 +411,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 * hole.  And hole extent has no size limit, no need to loop.
 	 */
 	if (disk_bytenr == 0)
-		return btrfs_insert_file_extent(trans, root, ino,
-					       file_pos, stack_fi);
+		return btrfs_insert_hole_extent(trans, root, ino, file_pos, num_bytes);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -819,10 +818,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		 */
 		const u64 length = min_t(u64, next - file_pos, SZ_1G);
 
-		btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
-		btrfs_set_stack_file_extent_num_bytes(&stack_fi, length);
-		btrfs_set_stack_file_extent_ram_bytes(&stack_fi, length);
-		ret = btrfs_insert_file_extent(trans, root, objectid, file_pos, &stack_fi);
+		ret = btrfs_insert_hole_extent(trans, root, objectid, file_pos, length);
 		if (ret < 0) {
 			error("cannot insert hole for range [%llu, %llu)",
 			      file_pos, file_pos + length);
-- 
2.53.0

