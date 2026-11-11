Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794433274;
	b=xQ+87pqk/n+nApQe+UqTRXyL06aNz0NPskByCbcD6aaI0YD1CZy1CJPmAz4q5XJ6Kf/E
	 3Io0C7i67ldRw406luyv6C6oQjZ6y80x3TtBVJaVy1jwllQcBiOTQSG3hyAw1iNW91ONI
	 wBAsC+kKwcEePHIt4ehSfzGkP2DbDk/k3QzHxK7wB2pM9ePo/UdPxLFvZz4y5dbNIlwVe
	 Yzd8f5nMYPaDHl7NXCPIz87TLKzmxC2LtZWYognIrpucT7QBCEGNZeDZ/dig3vsbzpnlJ
	 xm6jfTRebxgMRedsft8NxHD+g2KFxNaMixwL8FIUeKVFmmhhCxgA/quupTHlX4pfzpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794433274;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1kEvh0l2Lq9vO+Sx97tlKmLk6qXU8j2YZAXmCALXyGw=;
	b=cTLMl+j/dwWqO2h4zaB0Go0bvxSNyZeQq+5FfUVe2LaRWZApGbMtPsvrbduli2KRbeUO
	 jyJYhvzqhKzxPj/VXP2o0hqq9zcduZB+We0cCpJxGYNP+DVSqOLd3OtbnKzYr/79zDYbn
	 CqN90NPNA3bqmkJojgVSafgVtzst3uogTCAdz/NVMw1ZxRoEezh7lNWX8aDmo2yi/4sLD
	 e2xMcwiR4TA5V6epz+MrtyainJLKRJeHzigDsKRGNEcX8oLBVvQrOGbiQlTrNuZrp5+lc
	 daorD7TIpBa5C93NIFXUX7qbliTb3FD+cGZcCB1E50pdhzgKtuP/IkuUf6EoV9Bi4cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5zF4jw0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134F606A338;
	Wed, 11 Nov 2026 21:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5zF4jw0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794433273;
	b=n+OfJLYD4o4eNtRdfZMU/sgkHXuCcXQd79hvB1L4glEpV8FZLb4cYhhlK05yD2zeUHpm
	 a3b14WW/v9sxjV2+Z8h8GHBs4GRA46M3ggfDtNnIf6cphPRc5goLqEtvPQyKuQrZDVA9h
	 x9iemoUndhmfXVTt1Ou95nOr09fACPrZJi2J916nnNe2jyqO38Vs2wcObQuIDCHjvlah0
	 2r5DCNikyii/Ptibs5UIXBRPNCdq3+gLbO5qWIOhehTVUASla2w7b4lozV/WtJSu7XNoB
	 54M+BKAekBgfxqPZ9eY7l8ZqWQ/syxGY6ZrjWNaL7tjFjOhtrpjhxvxwK5w0W6/XHGA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794433273;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1kEvh0l2Lq9vO+Sx97tlKmLk6qXU8j2YZAXmCALXyGw=;
	b=vtH6SitOqX/ITiibbgGgdDQfGLG6Yihf79ipk0ySVpV9YcL7z0qy4p6vsu3zEfbP0cEd
	 0We06qB48vlC1XnISDwEK7RC4142mU5K+HzuasCUCJDHvvHDHWVt7Gwcjhx8CyLSxtTs1
	 9R2Ar0EDywCe/gvfKTHdpqg1T0Xc5k1C8nDnG1AkQhUTnkexkMVvkfIYV9Jr5p3b+vJ+2
	 LhZwksV8NzszJ+x1zYFOyF7AdGtDyNT2saGMZ8MNkudTlG6KOcEAv32owgJp/o1KRBq9M
	 u0wX2lCQMewxNXV6jNfitYXzivMScU/+skwRBG97tcfz4UuCCWAknF++OyfEtUuliPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 17AD91F00A05;
	Wed, 11 Nov 2026 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794433273;
	bh=1kEvh0l2Lq9vO+Sx97tlKmLk6qXU8j2YZAXmCALXyGw=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=M5zF4jw0yN1CegGa/x7DxxSEi6GOsBDkXqrIyyxZpAxHBN3b8oUXpCH13B0x6hkHf
	 113kfq3BazZ31bmifr2qKbObhZZvRjLvMHj9BErgDNkRUwAViWXYNZ6/zEIEKfAfE9
	 BmZirdntyqhs7NTBDSAdLdrhBB9dOYa12qRiwJZr2dgHOYNGcwtcrypMk1g5z/JrG+
	 czdKqg6KPlhlIrHJWwb/b32zIIIyGo2HcKPqQnMFapfpntqnCWyVz73r9JvOuENLw4
	 jRFyTxU87hky14H7OLnKGhKwgP1su/WQgL+yaZcM3fdibwOOwc6OIyvMJhVlzSzFMv
	 LKK2IG5jGjxlg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6298D49128;
	Wed, 11 Nov 2026 21:41:12 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Wed, 11 Nov 2026 16:41:12 -0500
Subject: [PATCH] btrfs: fix loss of fsynced file after link into new dir
 and unlink
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
Message-Id: <20261111-btrfs-link-unlink-fsync-v1-1-a817d4a890af@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQqDMBBFryKz7oAGDOJVpAsTJ3baMi0ZFUW8u
 zH+zect3ttBKTIptMUOkRZW/kmC6lGAf/UyEvKQGExpbJWGbopB8cvywVnyBd3Eo2mobwzVvrY
 Okv2PFHjN5e55s87uTX66cnAcJ0LpL317AAAA
X-Change-ID: 20261111-btrfs-link-unlink-fsync-28ea82e5c56b
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794433272; l=3107;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=JJHTvU9AbtLdmkks3pC7kN08S+SdKLTMH7tvu3/atzo=;
 b=bVSKpsrlub2NsW242Dk1cjS+F/kB9pGV3rKL6fP/Jr72Ud+/xnaTg2lBFDFY8BOTMnk1QQRr+
 /mm/LylOVivAvTfGxPAEx5+vQZFHW16vBMJjewAFTkfzys/Sh6L63aX
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

If we create a file, add a hard link to it in a new directory, remove
its old name and then fsync the file through a file descriptor opened
before the unlink, the file is gone after a power failure.  Example:

  mkdir /mnt/A
  fd = open("/mnt/A/foo", O_CREAT | O_WRONLY)
  mkdir /mnt/A/B
  ln /mnt/A/foo /mnt/A/B/bar
  unlink /mnt/A/foo
  fsync(fd)                     /* or fdatasync(fd) */
  <power fail>

After log replay, B and B/bar don't exist and the file is gone.

The fsync uses the file's dentry, which is still the unlinked A/foo.
The inode is new, so btrfs_log_all_parents() finds no parent in the
commit root, and log_all_new_ancestors() then takes the fast path for a
single link.  That path walks up from the dentry's parent A and never
logs B.  On log replay the inode ref for B/bar is skipped because B
doesn't exist, and the inode ends up with no links.

Fix this by not taking the fast path when the inode had a link, unlink
or rename in the current transaction.  The slow path finds the parents
from the inode refs in the subvolume tree and logs B and A.  That only
adds a search of the subvolume tree.

The problem is old, e.g., v7.1 loses the file as well.  It was only
hidden, by a fallback to a transaction commit, between
commit 0f24ea456ae1 ("btrfs: tracepoints: add trace event for
btrfs_log_all_parents()") and commit 36f9aafa46f5 ("btrfs: fix
unnecessary transaction commit fallback from btrfs_log_all_parents()").

With the fix, the file and its data survive.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it every time.

CC: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/btrfslink.c

It uses dm-flakey to drop all writes once fsync returns.

No Fixes: tag since this looks older than the single link fast path.
---
 fs/btrfs/tree-log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 85ef3c26e0e4..4f24b277f1b7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7543,9 +7543,13 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 
 	/*
 	 * For a single hard link case, go through a fast path that does not
-	 * need to iterate the fs/subvolume tree.
+	 * need to iterate the fs/subvolume tree. But not if the inode had a
+	 * link, unlink or rename in the current transaction, since then the
+	 * dentry used for the fsync may be an unlinked one, whose parent is
+	 * not the parent of the remaining link.
 	 */
-	if (inode->vfs_inode.i_nlink < 2) {
+	if (inode->vfs_inode.i_nlink < 2 &&
+	    inode->last_unlink_trans < trans->transid) {
 		ret = log_new_ancestors_fast(trans, inode, parent, ctx);
 		goto out;
 	}

---
base-commit: 4c34f0909344e48d917afac0eeffb6e1c2681524
change-id: 20261111-btrfs-link-unlink-fsync-28ea82e5c56b

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


