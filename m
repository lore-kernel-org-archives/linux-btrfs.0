Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FE93DAAB9
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791203067; cv=none; b=hN59DtpralFb2bid0eD0rLguuZp7bITrYERUsXUaVILjTFcpuhqaDc/Duv1Ep2JK9bFOG4KlF0VBNNCfbS5TzpKDH2/bUbGMYt7JB0FuE/QUxNkm2KFo3pZLi2MvDCRACSEQKvDbVb4nc58StP5n/jV9KpYuwtLmo/T1F7MhrIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791203067; c=relaxed/simple;
	bh=NGSN7o0EwOePwtpRT7gvF3u1QoCGKVLMA/QxpjbQUbs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qFdo6Y5XVUAAfzjrxF6k/sfKQpUzMs55lIsUal7nVWIWqnyMtjxpeCAaunjxWUOJjxLDYOYC3keVlpsPQf17aGTogTN8uYsls9I1llw8hbj2dW5s6shB+lA0wa/cH9vjj8sD4epL47BXU+HBopFtiaSZRFBKJNwOZt/IwsK9lNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWdomhnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWdomhnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADE11F000FF
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791203066;
	bh=i4yv/a0nHJT7jresUoYeLiTXLDIRHpysyYoVTd9xJsk=;
	h=From:To:Subject:Date;
	b=dWdomhnj1PfbtChKj90EDN4cH5pEzx+3DzlkPrg23cQoQPbgi4fV7U1OE2B2Q3kTa
	 lCtvV0OW8Mob1N0CB43aJ9RaQyJisqlQ0byY88RJoznrX70QKOapOBi23fvy66F0Qu
	 Wn+fGOTnxTSy/pEMJwio0yQgcj14SyEpRdXI4USIIfQ5mOrGS/m1Xj8NT7d2ORwlik
	 rTztsTna1V65w6smAjChrEmwP7I75y66Gedglv3N//kHMRlZY9yaejnzkg7BRSxzJy
	 M8jqImTdWzmmYLjrS4aZKbyTZCKtrzaYhwXc+0oEEKmO2O/2hbTZVlrUoUASSM6Sw3
	 h0TPjIOcxvDuw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use READ_ONCE() to read the chunk size from the data space_info
Date: Mon,  5 Oct 2026 13:24:23 +0100
Message-ID: <7345c87bc7ec38c7d71aff8ae0542ad177b3dce2.1791203029.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The chunk size of a space_info is always updated with WRITE_ONCE() (see
btrfs_update_space_info_chunk_size()), so when reading it in
calc_effective_data_chunk_size() we should use READ_ONCE() to prevent
load tearing. We are already using READ_ONCE() in every other function
that accesses the chunk size of a space_info.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/space-info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 39a28e1bec8a..72fa01502461 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -443,8 +443,8 @@ static u64 calc_effective_data_chunk_size(const struct btrfs_fs_info *fs_info)
 	 */
 	data_sinfo = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
 	if (btrfs_is_zoned(fs_info))
-		return data_sinfo->chunk_size;
-	data_chunk_size = min(data_sinfo->chunk_size,
+		return READ_ONCE(data_sinfo->chunk_size);
+	data_chunk_size = min(READ_ONCE(data_sinfo->chunk_size),
 			      mult_perc(fs_info->fs_devices->total_rw_bytes, 10));
 	return min_t(u64, data_chunk_size, SZ_1G);
 }
-- 
2.47.2

