Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D39E3D88F1
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773841197; cv=none; b=TMX6e7BsDDhjKufVl66uuEPDEp1X5m3lVS08Z1Vg7SZHIPFplDrdDmgmv+BO1djONViTiX0TWUWpPtV32T5PBoexvTYQrNuJKOYwkDMhZEO2us+d5nOVoxsVJ6z7lf1N/wIVQWo37pw7P5TjVL0dGTa6OVLJZnukmZsj88y1DbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773841197; c=relaxed/simple;
	bh=NbeSq37hMVAGdUp33ynKJ9Je674wPnH6TJBkv9FwNp4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=i4od1QnDnysi7wEj8SAP6RlcT9RUn47WNNX1lu1zye8gj8pJkzfcHdoOW38avqlCS1iUN4SMmf101kAy5RBArspCBFiFgjHwVMA7K7DXCxCW/ENhAvgAgJOCUjz0SGk0/t/yIgvDR8bgNkm2jDgQX4tbBRCRFl7VKeMXYLIP9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8luOTBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8luOTBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A775CC19424
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773841197;
	bh=NbeSq37hMVAGdUp33ynKJ9Je674wPnH6TJBkv9FwNp4=;
	h=From:To:Subject:Date:From;
	b=n8luOTBiCu0A3F9Ekx7lfLm6dQ6EnPD+cS0Kyg+BCdXajk/HVZ8HapyAHhIbgAdIa
	 is/9N2daXdu446AYCDVmi9q1rJ/ViJ+Us4kvhyUthLPYXZnT/fd0YIDNpfHAQfCHG5
	 wA8LvZASvrB3LeaJ8yVUmqWbqNlUXEPR6sA+o46DTbr3KVpa3hbOGJeFvcth5Vwxs7
	 CcyY8+rKY/vxyVCSpoD8z8IfVX9ve5uyRW+TQ9Yg5Z5I/GjS93+TS852rCOkxaua8U
	 fVhUOf7a29E7CeILmlEFdCKFcf/SC9xzIRi/6CAblRCFTxGoLB2LlE/c1NPPE9kuOV
	 wTfKidxBoYO8Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: avoid taking the device_list_mutex in btrfs_run_dev_stats()
Date: Wed, 18 Mar 2026 13:39:51 +0000
Message-ID: <bf7c901abdf8279207fed149f76ce0ccc4718159.1773840032.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

btrfs_run_dev_stats() is called during the critical section of a
transaction commit and it takes the device_list_mutex, which is also
acquired by fitrim, which does discard operations while holding that
mutex. Most of the time, if we are on a healthy filesystem, we don't have
new stat updates to persist in the device tree, so blocking on the
device_list_mutex is just wasting time and making any tasks that need to
start a new transaction wait longer that necessary.

Since the device list is RCU safe/protected, make btrfs_run_dev_stats()
do an initial check for device stat updates using RCU and quit without
taking the device_list_mutex in case there are no new device stats that
need to be persisted in the device tree.

Also note that adding/removing devices also requires starting a
transaction, and since btrfs_run_dev_stats() is called from the critical
section of a transaction commit, no one can be concurrently adding or
removing a device while btrfs_run_dev_stats() is called.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b5bc30dbb3ad..8353ddbec243 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8250,6 +8250,36 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
 	struct btrfs_device *device;
 	int stats_cnt;
 	int ret = 0;
+	bool need_update_dev_stats = false;
+
+	/*
+	 * Do an initial pass using RCU to see if we need to update any dev
+	 * stats item. This is to avoid taking the device_list_mutex which is
+	 * acquired by the fitrim operation and can take a while since it does
+	 * discard operations while holding that mutex. Most of the time, if
+	 * we are on a healthy filesystem, we don't have new stat updates, so
+	 * this avoids blocking on that mutex, which is specially important
+	 * because we are called during the critical section of a transaction
+	 * commit, therefore blocking new transactions from starting while
+	 * discard is running.
+	 *
+	 * Also note that adding/removing devices also requires starting a
+	 * transaction, and since we are called from the critical section of a
+	 * transaction commit, no one can be concurrently adding or removing a
+	 * device.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
+		if (device->dev_stats_valid &&
+		    atomic_read(&device->dev_stats_ccnt) != 0) {
+			need_update_dev_stats = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (!need_update_dev_stats)
+		return 0;
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-- 
2.47.2

