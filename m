Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995041;
	b=2tTzKqyn7Ht5Hqfv5zXhIQabV5mMsDnC3Qa+KcFLCT/Y8HDkfLqvGnZw1AuYrGa1rOq4
	 GpAoTlQO+RBNAvUzmmN/KvqJv/B2n+ngfWY32qkJG9bEa4Mkmnjt5Xa90+1cDAn4l30kS
	 FccDTct7N7GzjTcEwc/9WL/eEGHggypLk+rm2aZaFcKD/sipi8QkITjqM0X/jXOU5YXgY
	 Moncbw7mg86HAE/+gU3ilA8LAd5sSEH7rUqdZWDNN0XQ+SB51brQY/qLJpyF+ylynAgFm
	 lQFWt+gS4HqIw/1e26jOwr1bKh1vVQn25iYLilVhgot/PmjoaDQoE0l7uEoMHZj8R1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995041;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=v+NMN2cQ7Pue5XiOQBroqaZAa34qdntwlyVKVHVeGW0=;
	b=ZRDC4sjClKL9CGJdk3tvPkYEni4vWHvAGHOKidkNLFj/jAhAJ+sq7yRgly5nQr09oGWZ
	 DXAoofgMoteX+5aAjN/Ro59/ifLN1bxVcpBPoHGeBsqNlmcs7tJdsDVZLIaPKFHUXjatl
	 FXAznVsZzarFf/M20fvYkxiANghZNFJ9FnZAXla2BtXYhN6sVYI1nuMJY5HachZJCHsMw
	 otr37yhK8Fh4rpgDKPPrdH0nArzDNDG8DwwcBPye3fFCPQykjdwlsh3FV+a2T/Sm2vUVK
	 HcWsWSVkzgEbbR0J75dHrqIxBrwBsgsipesLD+2FZ0k27U5t2vSKPdfKzn8V9PxmilQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUv9McNR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B6606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUv9McNR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09AC1F0089F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793995040;
	bh=v+NMN2cQ7Pue5XiOQBroqaZAa34qdntwlyVKVHVeGW0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=XUv9McNRXPo9ucl0uHM0Zr9bs9yPjtIVZQaMnObOWlLrYnxmJ457ebbpGR1rwT/zi
	 8C72bRCjZ8QJS/0huPS9pwyXWhmpOkDgy6AbgGIHQ9gKPM8yG0a8O3/qgv5RQckRNZ
	 xg3L00np8guKUnHb49AgYvvrB9Hbgb4yuVbcQqBSXsUpaWvHgLL6F5AEcE0GMQvbAu
	 Gq3WaRI+wlhDyi+AFFiPUiIag5k2UL3xQonSs0ARKoYt4cAiIGHLvuXjEFzyVKhDQL
	 hQ9ijkk2RMi/qzB3F2WqjA9UC6ayIspaWbiWZ9hAXmcJUiuD8WamR27S2RFszQyDJI
	 d6t7DGMu9W9qQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: drop the link count of a subvolume inode when deleting the subvolume
Date: Fri,  6 Nov 2026 19:57:16 +0000
Message-ID: <1b1749d57e2b5be1c47b04937f5d7b9e2546c178.1793994629.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <de103b6af03cec8d98b21e0734fb482f9244bed6.1793988522.git.fdmanana@suse.com>
References: <de103b6af03cec8d98b21e0734fb482f9244bed6.1793988522.git.fdmanana@suse.com>
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

When we delete a subvolume we don't drop the link count of the subvolume's
inode. This is harmless in general, however if someone is holding an open
file descriptor on the inode while and after the subvolume is deleted, the
subvolume will still be listed by btrfs-progs.

Example reproducer:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  btrfs subvolume create $MNT/sv

  echo "*** Setting up inotify ***"
  inotifywait -m $MNT/sv &
  sleep 1
  echo "*** Setup done ***"

  echo "*** Deleting subvolume ***"
  btrfs subvolume delete $MNT/sv
  echo "*** Subvolume deleted ***"

  echo "*** Sleeping and syncing ***"
  sleep 30
  btrfs filesystem sync $MNT

  echo "*** Listing subvolumes ***"
  btrfs subvolume list -d $MNT

  echo "*** Killing inotify and syncing ***"
  kill %1
  sleep 5
  btrfs filesystem sync $MNT

  echo "*** Listing subvolumes again ***"
  btrfs subvolume list -d $MNT
  echo "*** Done ***"

  umount $MNT

When running this, the first subvolume listing still shows the deleted
subvolume and inotify does not report the subvolume as deleted:

  $ ./test.sh
  (...)
  Create subvolume '/mnt/sdi/sv'
  *** Setting up inotify ***
  Setting up watches.
  Watches established.
  *** Setup done ***
  *** Deleting subvolume ***
  Delete subvolume 256 (no-commit): '/mnt/sdi/sv'
  /mnt/sdi/sv/ OPEN,ISDIR
  /mnt/sdi/sv/ CLOSE_NOWRITE,CLOSE,ISDIR
  *** Subvolume deleted ***
  *** Sleeping and syncing ***
  *** Listing subvolumes ***
  ID 256 gen 9 top level 0 path DELETED
  *** Killing inotify and syncing ***
  *** Listing subvolumes again ***
  *** Done ***

Fix this by dropping the subvolume's inode link count when we delete a
subvolume.

After this, running the reproducer gives us:

  $ ./test.sh
  (...)
  Create subvolume '/mnt/sdi/sv'
  *** Setting up inotify ***
  Setting up watches.
  Watches established.
  *** Setup done ***
  *** Deleting subvolume ***
  Delete subvolume 256 (no-commit): '/mnt/sdi/sv'
  /mnt/sdi/sv/ OPEN,ISDIR
  /mnt/sdi/sv/ CLOSE_NOWRITE,CLOSE,ISDIR
  /mnt/sdi/sv/ DELETE_SELF
  *** Subvolume deleted ***
  *** Sleeping and syncing ***
  *** Listing subvolumes ***
  *** Killing inotify and syncing ***
  *** Listing subvolumes again ***
  *** Done ***

The subvolume is no longer listed after deleting it while inotifywait is
running and inotifywait reports the deletion.

Reported-by: Alex <linuxkernel+co@alexs.space>
Link: https://lore.kernel.org/linux-btrfs/18e431317f832f21-26f56778@a-workstation/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V3: Address a couple more concerns from shashiko (deal with btrfs_rmdir()
    case and avoid truncating items during inode eviction).

V2: Move the drop link count into btrfs_ioctl_snap_destroy() to address
    BUG_ON() during rename as pointed by sashiko.

 fs/btrfs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0bc668c9ec88..b3a123c8d9af 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4850,6 +4850,7 @@ int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry)
 out_up_write:
 	up_write(&fs_info->subvol_sem);
 	if (!ret) {
+		drop_nlink(inode);
 		d_invalidate(dentry);
 		btrfs_prune_dentries(dest);
 		ASSERT(dest->send_in_progress == 0);
@@ -5609,6 +5610,14 @@ void btrfs_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto out;
 
+	/*
+	 * For deleted subvolumes we drop the link count to 0 and we don't need
+	 * to truncate items in its btree (which is dropped all at once).
+	 */
+	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID &&
+	    btrfs_root_refs(&root->root_item) == 0)
+		goto out;
+
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		goto out;
 
-- 
2.53.0

