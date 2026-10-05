Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3D47F3DD
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202425; cv=none; b=tRPZsFguvDeW5QM92OMPu1rMeE6a0f/onSDoL4M9/inP4+PQHmF0bk74XtHnNBostaC8Top7n6MewRnT6GSY5yAQiX/QF8ryc/XIJuuZ04agkfWth6lW6c3CY8m0YC0GRn3IuNoJTbZKFrhG2ZsEjIU7uRNGfDdtv/ArWG3bPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202425; c=relaxed/simple;
	bh=G+0zxADAniYq0v3HvMPCTxTJo4gDtKiI2HOI/LkK1j0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3muZyl8iarKTgloG2i/SwtoeFWqYDnAToJEwKfSWWTXBUJDXDOO+7JfhHuJ+EH30owR+ofeTGa2OBLuhNZ+Qp+UKF3NWdwsRan6ojpHPUCiozbSQoyJbXetBUV/qH0DI5+J7BmoZSeAaOnnV0AMzyLm0GaNdp4Hj3R/BtAdr8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka2rBoQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka2rBoQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3546B1F00893
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202423;
	bh=ECsNlAsxri2qeeEFBh17Wcf7gophuvrWBvrw9zoeJKg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Ka2rBoQd6ZiV+GoBKCIyRsJ1GexVz5gWivQcWrlhdA6INyfGvfZd7MZnfsB6NW7Da
	 xNgpiuQW9f58nGw/CKyd7uhFTQnf4Zv9gAA1XocartimNCoRealWB0ckRUbMC3pOI8
	 LxUZzBqFV0FDgks/rUNF2YfHMWN1Eku8lW5I9LII5gMi70lMN6+ZKVLebNwYCjytw3
	 ole+tOfmkPrYxI3Pr+ecqZy43VwrKEkPKN2BqBeOVvln5gIVzyDOd1sJnEy4ZG/BPV
	 BHw7vJo69dT/TmgoLUJHpF70LsVd2YKSbJVuXvUEKwZ/XpqFsJEsNh5TdqHe5xRYjl
	 LfIwkKGNPMEEA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
Date: Mon,  5 Oct 2026 13:13:37 +0100
Message-ID: <69c7243d98cad088db5f853f9cc4a256b14236fa.1791202322.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791202322.git.fdmanana@suse.com>
References: <cover.1791202322.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to allocate a reserved file extent we then call
btrfs_record_squota_delta() and assign its return value to 'ret',
discarding the error from the failed allocation attempt and allowing
log replay to proceed as if no errors happened, resulting in some
replayed file extent item to point to an unallocated extent. At the
moment btrfs_record_squota_delta() always returns 0 (success).

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0d5ab03aae2..15b4ed56ce71 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5227,7 +5227,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 					 offset, ins, 1, root_objectid);
 	if (ret)
 		btrfs_pin_extent(trans, ins->objectid, ins->offset);
-	ret = btrfs_record_squota_delta(fs_info, &delta);
+	else
+		ret = btrfs_record_squota_delta(fs_info, &delta);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
-- 
2.47.2

