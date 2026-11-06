Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793988561;
	b=pmmwRB3NpfzmqoGOf29QkQcwJgnkk38KDqaqKSf5H75H/WZgr0SZcym+CS/cK+2PQwQf
	 0ep8x+xdcMkM48Be+aF+nZSRItdAwiE/kTiJfxffEfmwaDDeM5LMiDtux611yQwJ5be8S
	 QRJDo+aEbuyddOvPj1nr1ZJ50soeHdbhfOQk8ym0EpUrskQiNLeeFXoi+tIG9ckNxD6uQ
	 rZTvoBpggscm6EtDdrdza4gOY+urtmx6sIW12UhH7wkpeoaJLwTluT6tQmy/YJr0Kg1/0
	 DBtzwiwDvVeHJZ7liSf2FgcnY3W3aHSseLMhV15tyOesJuFup0+Jayw3eiT+AQCpJnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988561;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CZs5ED3VUPCKhjq0sjv6THqNUsdEyIhGK74BPs7J31w=;
	b=VjLGqoywPXmIz3B0C8HOvQBEXHgFMNQNcK/mGZGr/nu20WJhgylol0Drbq0/1tQ+OZXN
	 Bp+daay9UiiYzyPqlRzpnkrkC/N0lQikV6nm5KM1YdH+o8TqX7wJr38+eee482WpSMgb/
	 ZmLioZz/1L51bnkiW2/huroGIqT4JFuPuuG6YXgBivV8ODR6OAgXflGSR0ndGgOUKMsw7
	 Ve7KPHvbAp5GS4Z+iSsTJnS6bah1O7DRb0ZcUz+2yyR5vecI/nIP/bf3weDMyXoLykVCx
	 tGdqtD6/U+KwBhtVT54T5qVuC7GBOn13DnJy/+s0ISTPqxHSoMwzRO3FVx/QlvO7WUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CEIQAYqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E7606D82E
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CEIQAYqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866EF1F008A1
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793988560;
	bh=CZs5ED3VUPCKhjq0sjv6THqNUsdEyIhGK74BPs7J31w=;
	h=From:To:Subject:Date;
	b=CEIQAYqK1flpEoXY5ngqLEZtGi4Q/J7eZzuBmz6Upozhb1I6vf0ogcqAS3CmD42fl
	 UDwUCZlNlFGdXqqq5T++vFKWarh+HhegmBUiulH+ps0gNuaonc+4rvJv+jEZrcEdJi
	 ySCTlqqIR9RM5uV7Mlr7KXt3mA1kT+/AjRbxPbQvw6TIceESUrqeyEo4Uug3Vst8/J
	 iMfC2Y3wM2Ad0Ek6AT/4eN3iqttuUHJtxYHyZ6aWeb1UTWviQ+8fYD4kar0/aK60Ol
	 BHe0gNWFJSSuPWWcp/5qIFOoy3J6cdVD8T56NoUY1cqrdgsFIP9T9hKQ7vzKJgptCg
	 JG8l9bx5ZnSSA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: drop the link count of a subvolume inode when deleting the subvolume
Date: Fri,  6 Nov 2026 18:09:16 +0000
Message-ID: <de103b6af03cec8d98b21e0734fb482f9244bed6.1793988522.git.fdmanana@suse.com>
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
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0bc668c9ec88..e5ead75b6d01 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4622,6 +4622,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - fname.disk_name.len * 2);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode_set_mtime_to_ts(&dir->vfs_inode, inode_set_ctime_current(&dir->vfs_inode));
+	drop_nlink(&inode->vfs_inode);
 	ret = btrfs_update_inode_fallback(trans, dir);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
-- 
2.53.0

