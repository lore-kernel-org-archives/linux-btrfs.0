Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793261814;
	b=aogN3+Gcj2dd5uaFWkhpRkSEX8fkM8m8FweVAGTx+5PpZ+SUXyHA/4ypQkiRPPgO4pqO
	 rSuyd0wUzF55GTRu0pIUHSkg38PzFNUMSzuIwABcw6cc7tgWdl2ts89mtX+nfmjhzxw1o
	 tzu7zpMECxT3fm14HTSOfg0nK3rF25Za+yH5g0erFzL0GFPin/zMLDDCQ9zfQBsghGm5P
	 IDZKQ8zf7lrNCm5zk/C0CN47sEjAlLK1AER4XM1bhb9dx7Z02P/EcaJqkiGW2lhGPcPr9
	 E3pGn4NQe8hlFkJVx4c9ySkT9cUBS3Sym9LSE0ChRYPj738feZjJDP1adMKg9P8zt+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261814;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=piBghiZYeWGYQnYfcj3/DPjYXKZYBNBwxEB3ZbQoJhE=;
	b=nT4j5rqGr/RG5LmJS6jbA+VN6m1xRyljIkloUk8LekBTbI4ZOmscyTqpq+hEkTwM4wOz
	 H/t9DcySXOzQ+mfqnxQSsltFvG+P7Nxrk0V7xDPMxRoSogmVAweFLtu27bRFa7pCFXttG
	 3ilqAjL+DkMhA1U7CPsozJ9F33/jK0p0YfNE7qeZ5EikG5Zv5KKau7UN/AmKeYdd3xSi1
	 sV/WaNJiyGTyrSKjgDbsu2tpO+izM0X32XHritkrKOTz6/Gp/d6kcP7UBRlo/3Aq/xpiF
	 ib01E8n4mcpuXBaw5Nl6GSFxtBe9Kakxlf4akC33ms8QhF+5Jbz/7NX2tBVvMr+jsMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZXRLyL13;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC92606A31F;
	Thu, 29 Oct 2026 08:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZXRLyL13
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793261814;
	b=PBn3kLVu29230TlFgxRVpJOEdM+SEn+F7RQP6F1srgZKeW8fOyCWVGID114/elzhM7xY
	 F8fum4Eudbsko5VVPyaMdalqPiVxsizX2wJ5rQff54FZU6CVzK6BH07orHKdwRV8H555z
	 DgSAB6xquxjn220ORIG9YKsZ8T3Q8TahPH5AiU3AiT5wzuUAeoER5N18v7TIhXf13cdxZ
	 nxpkTw0wzNp8JybocTmd85OkhI0r3jvxfoPbDJcMzF6hefH5lYpL0LjqM+6cakRBTJom6
	 yc4zZ+dmzMmS1uAmk7WTKIEnm8UzibTQ2gM8JdhDeJjgO8ni3pxVaSiNlnRboKntw5A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793261814;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=piBghiZYeWGYQnYfcj3/DPjYXKZYBNBwxEB3ZbQoJhE=;
	b=zyH9y6be2IH6VdtXRa4BZms5KUtYXt2iPRJFJQmNG3BmkDZ+n8PkmNNdVusLGb+EIOMU
	 xHDZwh1Q8aAtZU1eJ330bMw2EiVMRroTtCX8bj6Xr6zXVMNFv/hYK201tMfbaTBcBxycU
	 p1CCdjtK2edBLQ3goyMjQID3b0bUlVXmPQ2gN/Bv7ixxxdQtBPoMC3RaG430Z9qcEuY1e
	 fBounI8fYjuYufmDm1skzQFwwVW9BcZRJWcuBITYVoJv0TPzrOwsK+i6xGL4kDhZAKt4m
	 WK/ImL6WRm1VENy33rVPSY9YXbU4o+ASvkehulEaqIKhmtCEuQ9E9Irw10it4TC118w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0784F1F01828;
	Thu, 29 Oct 2026 08:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261814;
	bh=piBghiZYeWGYQnYfcj3/DPjYXKZYBNBwxEB3ZbQoJhE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZXRLyL13GxbLyR9eD4bunGsgkQbr7rW6sF8STLyVz1QXDXPEpcYADdL/I+sCYfJGV
	 iSRXPNJrvW17QXhH1YOa5F7M7WEZnPWEAxbLF2kTuyVPhWNsyRHd+1mxmdeNkGdBx9
	 JpkOeS+Q7mrULCnu4YAKYjTVbPZkTrZHbwFJP6TbTt2kQ5MvHArb+DEjm2FT47+PdO
	 JR8/Jnbjhj3xRRZNMxJICyuF/CHGOEG7T7ilFV2mXis6gt3bFRc3PjwgIUh6q5OWGy
	 4o4RHtsEu1iEypKUrgc6PTj/YOLwy2SUDT58eywV9t/Ioy14c954xISSz19hrHFdIm
	 C5BiKYUifEGbg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6EF5745785;
	Thu, 29 Oct 2026 08:16:52 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Date: Thu, 29 Oct 2026 13:16:44 +0500
Subject: [PATCH 1/2] btrfs: zoned: finish the zones of a relocated block
 group
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-btrfs-zoned-active-zone-leak-v1-1-777dd01ff914@gmail.com>
References: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
In-Reply-To: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793261811; l=4344;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=zRjBI+rJe+s4Uyjpfd78jmh2lrY/Nq7+JPNK4RV1AgQ=;
 b=2nZhBQNgYMl+xskDi0bYJDWXNYH/OIBVapj4dT9o4si/8CQfk9iRtSQt9ILvnEtBaQ3BrlVhS
 XXymjKOZiBpBEdwtZNnuW6Udt46TIcgI78xex0XH+PmTN6lTxuiP2jV
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com
Content-Transfer-Encoding: 7bit

From: Mark Korenberg <socketpair@gmail.com>

btrfs_relocate_block_group() ignores -EAGAIN from btrfs_zone_finish().
A metadata or system block group with tree blocks not written yet, or
the data relocation block group, is then relocated and removed with its
zone still active: it stays on zone_active_bgs and its share of
reserved_active_zones is never given back. Repeated balances drive the
reservation negative, which ends in -ENOSPC and lost data in writeback
(see the next patch).

Finish the zone in btrfs_relocate_chunk_finish() before removing the
block group. It is read-only and empty by then, and relocate_block_group()
has committed the transaction, so its tree blocks are written. Drop its
data relocation role and finish it. Keep the chunk if that fails.

Fixes: 7ae9bd18032e ("btrfs: zoned: finish relocating block group")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
---
 fs/btrfs/volumes.c |  3 +++
 fs/btrfs/zoned.c   | 36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h   |  6 ++++++
 3 files changed, 45 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd..112ef1a53199 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3703,7 +3703,10 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
 	length = bg->length;
+	ret = btrfs_zone_finish_relocated(bg);
 	btrfs_put_block_group(bg);
+	if (ret)
+		return ret;
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1cda88332284..ce8d96a48aa3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2649,6 +2649,42 @@ int btrfs_zone_finish(struct btrfs_block_group *block_group)
 	return do_zone_finish(block_group, false);
 }
 
+/*
+ * Finish the zones of a block group emptied by relocation, before removing it.
+ *
+ * btrfs_relocate_block_group() tries this before relocating, but gets -EAGAIN
+ * while tree blocks allocated in the block group are not written yet. If the
+ * block group is then removed with its zones still active, it stays on
+ * fs_info->zone_active_bgs and, for metadata and system, its share of
+ * reserved_active_zones is never given back. After a few balances the
+ * reservation is negative and data writeback fails with -ENOSPC.
+ *
+ * Here the zones can be finished: the block group is read-only, so nothing is
+ * allocated in it, and relocate_block_group() committed the transaction, so
+ * its tree blocks are written.
+ */
+int btrfs_zone_finish_relocated(struct btrfs_block_group *block_group)
+{
+	int ret;
+
+	if (!btrfs_is_zoned(block_group->fs_info))
+		return 0;
+
+	/*
+	 * do_zone_finish() refuses the data relocation block group. This one is
+	 * empty and gets no more relocated data, so drop that role.
+	 */
+	btrfs_clear_data_reloc_bg(block_group);
+	spin_lock(&block_group->lock);
+	clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags);
+	spin_unlock(&block_group->lock);
+
+	ret = do_zone_finish(block_group, false);
+	WARN_ON_ONCE(ret == -EAGAIN);
+
+	return ret;
+}
+
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..700d6909ee3f 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -82,6 +82,7 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
 bool btrfs_zone_activate(struct btrfs_block_group *block_group);
 int btrfs_zone_finish(struct btrfs_block_group *block_group);
+int btrfs_zone_finish_relocated(struct btrfs_block_group *block_group);
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags);
 int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
@@ -238,6 +239,11 @@ static inline int btrfs_zone_finish(struct btrfs_block_group *block_group)
 	return 0;
 }
 
+static inline int btrfs_zone_finish_relocated(struct btrfs_block_group *block_group)
+{
+	return 0;
+}
+
 static inline bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
 					   u64 flags)
 {

-- 
2.56.0


