Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F01306B37
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 06:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036394; cv=none; b=W7c6DOjXnYYhKnsdwanDsZcyM4cCY3T/B4Z0zKmBqaCL6QZZxJC5CZJeePnycKaKceUoIdYzNHx4WysAQpC+lasH7uuhaHl+E68LlK+TfA2N/dEp77gLG0AKnJTOj1njn4O7HOwm4Bzesu59k/RlPtRCPF9AAHBiCWzAjW6vW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036394; c=relaxed/simple;
	bh=88UqluabCvK8NpuQlHFUdtUltBeNIc0YceM/n5Qg5to=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=c+A81iTO6Ptv+Dm4GdQpVOIk2Q+YOhgA3bxxgFQB5oir0+KbpsTtW1ROLcikrHDmJyagwbaevEa3TLHgrQ+Q4DaGYPp6PBf2Aoh1uPwSC07QXMaCmYdZPTXcx+bu93aS+PEILuV3IBFE0bpTe91OfUwsCrLgMdRJNRg76X/g8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=TZAlGbB2; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="TZAlGbB2"
From: samho <samho@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1787036384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=050dZ58evRO6u/bUa9Lr7WryuP5wpOBqAXDmKo8ucuM=;
	b=TZAlGbB2/ip+VUsHshiG0lphws4JEt9vfMyUtJ1uLMgS4d5/Cx2QUdWdD33lsYtpUcoFvi
	KItWlF02stYzMKbe1Ri90jBb1YxbstPc/Zu2g5+e74aZDCCt0BkL+COrdFxV/BTZFRKy/x
	LdcpnrCJRmZJw+0vPB7XiuBDXzEMOvk=
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	samho <samho@synology.com>
Subject: [PATCH] btrfs: send: reproduce preallocated extents with send stream v2
Date: Tue, 18 Aug 2026 06:59:31 +0000
Message-Id: <20260818065931.1420959-1-samho@synology.com>
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

A preallocated extent is not reproduced by send. For a full send it is
skipped, so the receiver ends up with a hole and none of the space the
sender reserved:

  # fallocate -l 16M /mnt/sub/foo
  # btrfs subvolume snapshot -r /mnt/sub /mnt/snap
  # btrfs send --proto 2 /mnt/snap | btrfs receive /mnt/dst
  # du -h /mnt/snap/foo /mnt/dst/snap/foo
  16M   /mnt/snap/foo
  0     /mnt/dst/snap/foo

For an inode that already exists on the receiving side it is worse: the
range is sent as writes full of zeroes, so the receiver spends the stream
and the disk space to turn a preallocated extent into data.

The comment in process_extent() says that the send spec does not have a
prealloc command yet, which stopped being true with send stream v2 - it
has a fallocate command, and btrfs-progs runs fallocate(2) for it since v2
support was added there. Commit 005b0a0c24e1 ("btrfs: send: use fallocate
for hole punching with send stream v2") already uses it for holes with the
same reasoning.

So send a fallocate for a preallocated extent as well. For an inode that
already exists on the receiving side the range is punched first, because
fallocate on its own leaves the current content in place, which would
leave data where the sender has a preallocated extent.

The part of an extent that starts at or beyond the inode's size is still
skipped. A full send could reproduce it, as the truncate we send once we
are done with the inode grows the file on the receiving side and so does
not drop such a range, but an incremental send clips those ranges away
before it gets here, and making the two agree needs the fallocate to be
ordered after the truncate for a file that shrank. Both skip them for now.

For a file that gets 16M preallocated between two snapshots, the
incremental stream goes from 16781375 bytes, 128 writes of zeroes, down to
289 bytes, and the range ends up as a preallocated extent on the receiving
side instead of written zeroes. A full send of a 16M preallocated file
grows by 20 bytes, the single command for it, and the receiver ends up with
the extent instead of nothing at all. Stream v1 is not affected.

The send group of fstests passes with this, including btrfs/284, which
exercises send stream v2 with fsstress and verifies the result with fssum.

Assisted-by: Claude:claude-opus-5
Signed-off-by: samho <samho@synology.com>
---
 fs/btrfs/send.c | 65 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index dca3570168c7..028bc983ea2d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6088,6 +6088,26 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	}
 
 write_data:
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	if (btrfs_file_extent_type(path->nodes[0], ei) == BTRFS_FILE_EXTENT_PREALLOC &&
+	    proto_cmd_ok(sctx, BTRFS_SEND_C_FALLOCATE)) {
+		/*
+		 * The inode exists on the receiving side and the range may hold
+		 * anything there, so punch it before allocating it - fallocate
+		 * on its own leaves the current content in place, which would
+		 * turn a preallocated extent into data.
+		 */
+		ret = send_fallocate(sctx, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				     offset, num_bytes);
+		if (ret < 0)
+			return ret;
+
+		ret = send_fallocate(sctx, 0, offset, num_bytes);
+		sctx->cur_inode_next_write_offset = end;
+		return ret;
+	}
+
 	ret = send_extent_data(sctx, path, offset, num_bytes);
 	sctx->cur_inode_next_write_offset = end;
 	return ret;
@@ -6408,6 +6428,43 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 	return ret;
 }
 
+/*
+ * Reproduce a preallocated extent on the receiving side.
+ *
+ * Before send stream v2 there was no way to tell a receiver to allocate a range
+ * without writing to it, so a preallocated extent was skipped and the receiver
+ * ended up with a hole - the space the sender reserved is not reserved there.
+ * Since v2 we have a fallocate command, and btrfs-progs runs fallocate(2) for
+ * it, so use it.
+ *
+ * The part of an extent that starts at or beyond the inode's size is not
+ * reproduced. A full send could do it, as the truncate we send once we are done
+ * with the inode grows the file on the receiving side and so does not drop such
+ * a range, but an incremental send clips those ranges away before it gets here.
+ * Reproducing them only for a full send would have the two disagree about the
+ * same subvolume, so both skip them.
+ */
+static int send_prealloc(struct send_ctx *sctx, struct btrfs_path *path,
+			 struct btrfs_key *key)
+{
+	const u64 end = min(btrfs_file_extent_end(path), sctx->cur_inode_size);
+	int ret;
+
+	if (!proto_cmd_ok(sctx, BTRFS_SEND_C_FALLOCATE))
+		return 0;
+
+	if (key->offset >= end)
+		return 0;
+
+	ret = send_fallocate(sctx, 0, key->offset, end - key->offset);
+	if (ret < 0)
+		return ret;
+
+	sctx->cur_inode_next_write_offset = end;
+
+	return 0;
+}
+
 static int process_extent(struct send_ctx *sctx,
 			  struct btrfs_path *path,
 			  struct btrfs_key *key)
@@ -6433,14 +6490,8 @@ static int process_extent(struct send_ctx *sctx,
 		type = btrfs_file_extent_type(path->nodes[0], ei);
 		if (type == BTRFS_FILE_EXTENT_PREALLOC ||
 		    type == BTRFS_FILE_EXTENT_REG) {
-			/*
-			 * The send spec does not have a prealloc command yet,
-			 * so just leave a hole for prealloc'ed extents until
-			 * we have enough commands queued up to justify rev'ing
-			 * the send spec.
-			 */
 			if (type == BTRFS_FILE_EXTENT_PREALLOC)
-				return 0;
+				return send_prealloc(sctx, path, key);
 
 			/* Have a hole, just skip it. */
 			if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0)
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
