Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199641;
	b=a7PeiT/REDf5Cpy89uQ2gZfjWNmkEbihOjvOyJsA21C9kUpYIaDcobyaS7aSCg3vRH9x
	 wT9Tdl8VVNp1OEwUGhgO3VtgkLGzid6urrPPVCVOaHtkaJfv23gmbjf+3CtEXgPgQLmsw
	 2p2xQuKXOFtKqTPaaKrTTg8bzTsIirWNfNCaiebym4Fsw2mXmnY7juAvL5JDkY1MUtB+/
	 LDrkwvOtZRa5Zp61lapF5JHDOd9CeswK5S0DqH1svCKrxSBLef8EOb55fvNcPhPkxuQP8
	 ys0r2CvETgAFD9JrflPMCxy+cVnWUCAd5QVQSA4GWX9VFcCAWUWmhRD6SxSMje4LUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199641;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4Qmn4Sy9RZghv0S/1gBYou8Ikdbm8AUf01Pn2KGmds=;
	b=I3QuKjYSfTG7fde4V7wEYgou/P2zVGVYMG6QiuxN3EcRWpFDogYn/SeSZxbdOZGZeXfn
	 MKuW6its7aE112/hw2I2ARy6ALiR+9zaOEotYqIl9or4TIxwqTJ0PilLOgEga/KCohL8V
	 ravkHe+vBB1mzuahcDUPb5b94wwuV3khkP8GRrhba8r6cEpGGcdVENsrt14rwQg/mSdiA
	 ZCbLPdcv31//+02GYHx3j3zQhyb2l2C2VkV90ZPpuYQ0uhWna9DKdC+3PBka1Yq+gP2Mp
	 tx8D6veZUm7L6AKvgdJ+jdsXkb7je1JBQgVf1V+F2k1hMgv7Z2hHVWMImtx5jCTHUug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/tVxlx+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870CA60A2603
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/tVxlx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937CE1F000CA
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199641;
	bh=f4Qmn4Sy9RZghv0S/1gBYou8Ikdbm8AUf01Pn2KGmds=;
	h=From:To:Subject:Date;
	b=i/tVxlx+uBe9dumLg7rT5Dhv3gy6FFzfHt10QQPWTzxQ91GSw83NA/ok+XiokqzfM
	 vVFKRmkxyxOJHTEQnhmMAAfZlDapMnDc3OKtklIsa7VV71+N+GyZkh7kThdrNovIl6
	 EnJBD4AAeykhel2u5+RMGINXkX30IH0RNhRoo0QfRKELjaPAdXf482xXRvt9pJse7a
	 obd8gxmzCUDT/mf5gwdNR/jhKF8e8dxoOGP8hk9oiuWb1FDOa0CjUDKyS38rJZkMb0
	 G7Sy43cqOZ7SsKm4oWwOPzEeyYuqCTDuyTYr/KA8TpUH0CpSV4iG8bq/3lFL9S53X4
	 bELYCTU+XlVLw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix leak of roots in dropped_roots list after transaction abort
Date: Fri, 20 Nov 2026 18:33:55 +0000
Message-ID: <7daabc94a5577726850f8f1c9dc7785077222111.1795198535.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

If a transaction is aborted and happens to have roots in its dropped_roots
list, we end up not empyting that list and drop the references for each
root there, resulting in memory leaks. A root is added to that list after
we delete a root, with a call to btrfs_add_dropped_root(), where we remove
the root from the fs_roots_radix radix tree. As a consequence during the
transaction abort path, we never drop the reference for such a root since
we don't find it in the fs_roots_radix radix tree and we don't empty the
dropped_roots list anywhere (like btrfs_cleanup_one_transaction(),
cleanup_transaction(), btrfs_cleanup_transaction(), etc).

Fix this by updating btrfs_cleanup_one_transaction() to  iterate over the
dropped_roots list and drop the log trees for all roots there as well as
their references.

Fixes: 2b9dbef272b6 ("Btrfs: keep dropped roots in cache until transaction commit")
Link: https://sashiko.dev/#/bug/linux-8cb356ea-6a28-4bfa-89d2-e04c9a391607
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c     | 14 ++++++++++++++
 fs/btrfs/transaction.c |  1 +
 2 files changed, 15 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7775fc768f7e..d8d433ac458b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4982,6 +4982,20 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 		btrfs_qgroup_clean_swapped_blocks(root);
 	}
 
+	spin_lock(&cur_trans->dropped_roots_lock);
+	while (!list_empty(&cur_trans->dropped_roots)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&cur_trans->dropped_roots,
+					struct btrfs_root, root_list);
+		list_del_init(&root->root_list);
+		spin_unlock(&cur_trans->dropped_roots_lock);
+		btrfs_free_log(NULL, root);
+		btrfs_drop_and_free_fs_root(fs_info, root);
+		spin_lock(&cur_trans->dropped_roots_lock);
+	}
+	spin_unlock(&cur_trans->dropped_roots_lock);
+
 	btrfs_destroy_delayed_refs(cur_trans);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d2da7de4b905..1ea8dc522d2e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -201,6 +201,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 			btrfs_put_block_group(cache);
 		}
 		WARN_ON(!list_empty(&transaction->dev_update_list));
+		WARN_ON(!list_empty(&transaction->dropped_roots));
 		kfree(transaction);
 	}
 }
-- 
2.53.0

