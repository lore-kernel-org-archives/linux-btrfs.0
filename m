Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991579;
	b=uQdvFcmTH40Ggb9cR+D7gWQ+4La9od1otidofzYG+TL5BmqrzcKZWGblnhMzEnpboUVf
	 PG2oaHC7cUt92m1m2V80blkt+EVTf+Vgt5c1J0d2NEjlE0cRwhMA6NebR3x0ranRfh8Wx
	 SXuawxco6ijlxJM5YELazsHWV8h69uXb+ozKQcNoAZBhN42+57Nb0FjS3IZeyBT1+xrcv
	 6aCPpZVL8FU9q67VU3PPVJi8QPfoulu6NYQthIrrKlRb84Vfbwelv345oG0E07aqIDB4w
	 qJAc6AD4lYrFkNFP8v2OLs6Ti+2A3QdA51KnfYU3cdv/sD3ue5Ph1G8Gj87ry/0wADg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991579;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QhtohLvxYrOwXyOKUwtzleMdD2e3gXlWjkLmJYQl/mQ=;
	b=sn/Qu4eQLc2JsnQPzNyns+UGlnnllQQUBOtGFCImcWPL3HLqVhq1vkwGzQ8k5C6BB6fa
	 1U3jveTJ+L2igzmXt9/PzRQ8OV8PHMRd7WAp6bocLJI/jeEZe2qAKdD4Uji5YDNGvG6mP
	 QxNYds+aLuDC5lHzgEui6HOElgZN7bznSlXGqq++/C51D0WJr3rYlIH8GNJD35oplJii2
	 hyyAlRPUePb1ql5Yh4/5ylM+BjiPKNqLcx1E20cctQ9hjGWYMHBSki//3Mx+TmhTCbYMm
	 A7z1IVqyorObAEZhJyKEa62NTGG+zITdHEfYEv2URf4HDpNQwa7iyEQ5pRE+SvP9uVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbH3F1w8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D9A606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbH3F1w8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554E41F0089F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991578;
	bh=QhtohLvxYrOwXyOKUwtzleMdD2e3gXlWjkLmJYQl/mQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hbH3F1w8OE4ZW87B6fx764SnEh6rFKhHbQX61GjtfqjjX8x1fBXrnDC4JWMeOawn9
	 UDddE5sxaNB3gvjQLAmIjIW5z7zGO04ofMla2ln3xdQICEhA3I4QuWNNSFHkr6mjTs
	 PKRgbgvl5LYkqDpnMpZlO8uGQ9TWBzBX8sNUVeOJAoOGLGBuKUc5YQTiqgIb7BUZra
	 lklwSsnilgvIIeDNteOkW0Q7hdYlkIBKc+3D6M5Q8bQE3aaGaajBREibT/B6tU/+Gi
	 hbk6USFshkemyuUacRPW/fLRsgXIxC9DZxtYOZ05evoNGKEgCZ4vmGg6WKpYR5eUg7
	 FXbOkzg4C6lzg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: drop the link count of a subvolume inode when deleting the subvolume
Date: Fri,  6 Nov 2026 18:59:24 +0000
Message-ID: <115ec91d82e466382dd9cfb61bf484cb09be50db.1793989939.git.fdmanana@suse.com>
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
subvolume:

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
  ID 256 gen 9 top level 0 path DELETED
  *** Killing inotify and syncing ***
  *** Listing subvolumes again ***
  *** Done ***

Fix this by dropping the subvolume's inode link count when we delete a
subvolume.

Reported-by: Alex <linuxkernel+co@alexs.space>
Link: https://lore.kernel.org/linux-btrfs/18e431317f832f21-26f56778@a-workstation/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Move the drop link count into btrfs_ioctl_snap_destroy() to address
    BUG_ON() during rename as pointed by sashiko.

 fs/btrfs/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 651a780dd7b1..3f515256a6a0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2451,8 +2451,10 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	btrfs_inode_lock(BTRFS_I(inode), 0);
 	ret = btrfs_delete_subvolume(BTRFS_I(dir), dentry);
 	btrfs_inode_unlock(BTRFS_I(inode), 0);
-	if (!ret)
+	if (!ret) {
+		drop_nlink(inode);
 		d_delete_notify(dir, dentry);
+	}
 
 out_end_removing:
 	end_removing(dentry);
-- 
2.53.0

