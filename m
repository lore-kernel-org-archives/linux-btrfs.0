Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611747;
	b=pyFIqphD/7F2MOn/9s0MmM9tcEWfhDLI9MNp7iVc8xSXKhccvpBiKPzvawUfPfLfz5NU
	 HmaWZ7S998zS7U4IW9/in1WVnk7lV57S7tAks6cmf5BD5tfER8dLD0sLvlyGZ5IRPsxBI
	 sdCu5Gc/NCgT6thEtTWapsyCjm5bnhiaPn1zAJlgoqqHm8DJUJ2uhNISQT7h2YHXFaDr3
	 8WgmYXh+I241Bn3CmGVCIvXt4dCPprBNNYPjlb2jOvPs/mwxORHFpH6B50Q1U+KRm4Knt
	 wo5jRi1rkAeEfdShoBJp3zcAMwrEWphqyaZmYipwi2tHxMk46NAn+dJq/ENnO8KFJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611747;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=pw/5Eb8ZyQd2kgCIP1ROd/JRYV1jbti3jSr4RnQxzxM=;
	b=ZOh277qnQRcCQIgxizs2SsbqWoyB9kmB1eBz8jFkjmHQaBVUIN0pPQgfSG/uxLRw6zgp
	 Aqlcy5ZbRTWxTHOS/kgeeDpgsfTU+V0zSzpoVLx0RM5yKvVxhLMdetSc66oPJcawmd00E
	 sN6gk4OzWDR2ZLS/doYHc67wevEQerMMXJTsrzdXZT2rrftiJS9Sqxe56RwoE1QOS1wmJ
	 0oJEsyk5I7sUlK/wvi1aiILgzCW7wLDzx1AOHuL5WTe0KGF8FyHicVR9cjeT8zOHcVjSs
	 cNAKWRnp1M/uHH8uBfa9Nzp3ictq3v7hvn2OhVIG6aX3o3OmifDN4pL7A7S3+V9XRdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PY5VM7uH;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PY5VM7uH;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8F606A334
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCA8F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PY5VM7uH;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PY5VM7uH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44FF71FBDE
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/5Eb8ZyQd2kgCIP1ROd/JRYV1jbti3jSr4RnQxzxM=;
	b=PY5VM7uHWPHiBYtbtQd05yRD4MMovS31+a1GACIyhjXcXET2e4B1JNmcTV+NtXoVBl6FuJ
	qgxPh1vRTEpeAmmtYoyd4570wFR37dBzkm9rSS3T7xDcSoNb0jcnqh+sXWz2gkQvQ5+zCf
	GuQgEGd6KIi8LMs4BnyVwyBPyUl+ksM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/5Eb8ZyQd2kgCIP1ROd/JRYV1jbti3jSr4RnQxzxM=;
	b=PY5VM7uHWPHiBYtbtQd05yRD4MMovS31+a1GACIyhjXcXET2e4B1JNmcTV+NtXoVBl6FuJ
	qgxPh1vRTEpeAmmtYoyd4570wFR37dBzkm9rSS3T7xDcSoNb0jcnqh+sXWz2gkQvQ5+zCf
	GuQgEGd6KIi8LMs4BnyVwyBPyUl+ksM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D5C6134B3
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R7qPENxX6GprcgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 09:29:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: reject subvolume ids that do not fit into unsigned long
Date: Mon,  2 Nov 2026 19:58:38 +1030
Message-ID: <33be0954dbdf0c1abe580d422ad6bbfa6025b191.1793611601.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793611601.git.wqu@suse.com>
References: <cover.1793611601.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

fs_roots_radix is indexed by unsigned long, so on 32-bit systems the
subvolume id is silently truncated to 32 bits, e.g:

  Subvolume 257 (0x101) and subvolume 4294967553 (0x100000101) will have
  the same index (0x101) on 32-bit systems.

Although this should be very rare, as btrfs can reuse deleted
subvolume ids, and there are other limits like anon_dev preventing us
from so many subvolumes.

But it's still better to address such problems, since 32 bit systems are
still widely supported by the kernel.

Address such rare problem by:

- Add btrfs_check_subvolid() to btrfs_insert_fs_root()
  So that all subvolumes inserted into the fs radix tree are ensured to
  be no larger than ULONG_MAX.

  If there is a high subvolumeid, it will show an error message.

- Do not search the radix tree if subvolid is is too larger
  It's possible to pass reloc tree into btrfs_lookup_fs_root() through
  backref walk.

  And it can be very common during qgroup operations. So we don't want
  to flood the dmesg with error messages.
  Just silently reject such search silently, and searching tree reloc
  tree inside btrfs_lookup_fs_root() will return nothing anyway.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 fs/btrfs/disk-io.h | 19 +++++++++++++++++++
 fs/btrfs/ioctl.c   |  2 +-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c47ac4eff28d..ed7ccda6da80 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1129,6 +1129,15 @@ static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root;
 
+#if BITS_PER_LONG == 32
+	/*
+	 * Roots with ids above ULONG_MAX are never inserted into the radix
+	 * tree, and a truncated index may hit an unrelated root.
+	 */
+	if (root_id > ULONG_MAX)
+		return NULL;
+#endif
+
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
 				 (unsigned long)root_id);
@@ -1181,6 +1190,10 @@ int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
+	ret = btrfs_check_subvolid(fs_info, btrfs_root_id(root));
+	if (ret)
+		return ret;
+
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index d721e58a69f3..2f0f7bbdfbae 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -105,6 +105,25 @@ static inline struct btrfs_root *btrfs_grab_root(struct btrfs_root *root)
 	return NULL;
 }
 
+/*
+ * fs_roots_radix is indexed by unsigned long, so on 32-bit systems a subvolume
+ * id above ULONG_MAX is truncated, and can conflict with other subvolumes.
+ * Such subvolumes are not supported.
+ */
+static inline int btrfs_check_subvolid(const struct btrfs_fs_info *fs_info,
+				       u64 subvolid)
+{
+#if BITS_PER_LONG == 32
+	if (unlikely(subvolid > ULONG_MAX)) {
+		btrfs_err_rl(fs_info,
+	"subvolume id %llu is too large for 32-bit systems, max supported id is %lu",
+			     subvolid, ULONG_MAX);
+		return -EOVERFLOW;
+	}
+#endif
+	return 0;
+}
+
 void btrfs_put_root(struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
 			     struct extent_buffer *buf);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 215e3220df7f..a7948e2a056c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5126,7 +5126,7 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
 	}
 
 	/* 32bit limitation: fs_roots_radix key is not wide enough. */
-	if (sizeof(unsigned long) != sizeof(u64) && args.subvolid > U32_MAX)
+	if (btrfs_check_subvolid(fs_info, args.subvolid))
 		return -EOVERFLOW;
 
 	while (1) {
-- 
2.56.0

