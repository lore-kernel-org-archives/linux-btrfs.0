Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188A32264A8;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866324; cv=none; b=PW6AQlUifQsL79LdjDyi/pncHamTtjJPxdfDGy3a9PMqbxM/p2ForgzkW4QAC/FLZdVJciixnm9tEayHNohtu4hhAEF0OCpWoYYip9+kv/OUBUHprixt+gRlP5cei2X2kNUlAeKSQ63LBK47v29Jmo199f+hl6plOLR6q43goNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866324; c=relaxed/simple;
	bh=vuzcIVzPjRqo7f5+zy8fi+bbRxHRjC33kq7tlm2vcbs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qEqGDP5/7o3MV2zeCKFAtj8aa/JEAOCKb69apRIoPGQlcQak3uBstPFdwyjvIYE1wLxUNis6V3NhwLfSH1kKMM6MEhSEbNQkDHRJ1eNyaGtBhaYZ723+fqFIkZBjm66t+MqhdHKZ3GfqUMGDxBuVfIwuL0AozG+87fE7bOSfTWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y34ILu+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y34ILu+b"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C263DC2BCB9;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783866323;
	bh=vuzcIVzPjRqo7f5+zy8fi+bbRxHRjC33kq7tlm2vcbs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Y34ILu+bh2NlUn0I8df29hgsLI6aRXxvoOiO+TPtNJOnTeu/c4I5UjgA8rp/adz8s
	 AAmYZAyQarffX31sZ6ojCtmtQgfSXKkOOgZZQK9MmFkN0rwJjGCPSGR+uSqCvc1uKb
	 kmWRI3Odl6g6tyaLREByozP6nKIf6RLFrH8VBA6vdLJA4r8v0aZA2145YO2crBb61l
	 mFO8W6SP+b+QDrCeCxIrEj6gxGcw0nl5R5dlIw4F9kmy41bkRRCbPUfkUy/6S4U9rg
	 rTSv8D+Bg2QToK2S1P2mm+uug5Yijbt7EddpNA8VVgxw2knCE46rrotRFm2am/v66o
	 qoSX+f8TsarXg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66B8C44506;
	Sun, 12 Jul 2026 14:25:23 +0000 (UTC)
From: Daan De Meyer via B4 Relay <devnull+daan.amutable.com@kernel.org>
Date: Sun, 12 Jul 2026 16:25:14 +0200
Subject: [PATCH 2/2] btrfs: allow reflinking from checksummed files into
 nodatasum files
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-reflink-into-nodatasum-v1-2-9f27ef836073@amutable.com>
References: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
In-Reply-To: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daan De Meyer <daan@amutable.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783866322; l=4259;
 i=daan@amutable.com; s=20260712; h=from:subject:message-id;
 bh=Hw0p3DRVBaGyXiZo3CL0kz3clGy7qMlOjFom3aktY3U=;
 b=9fuhcAk303kbpLIS3ldQ9CeEHlSms0au2XqPblElXbhfFBQyjkCW6MYLIsB1U4xiLjwBVwzfr
 sVOmcSM9WCHCqV4Io6bIuSAcCwTmLf9kn2IGyQps0YnpsTU2BenqhF5
X-Developer-Key: i=daan@amutable.com; a=ed25519;
 pk=I1l+WwrtmzRgofA5SQ1wTuJi18fjh91w+f5uRkFeZEA=
X-Endpoint-Received: by B4 Relay for daan@amutable.com/20260712 with
 auth_id=868
X-Original-From: Daan De Meyer <daan@amutable.com>
Reply-To: daan@amutable.com

From: Daan De Meyer <daan@amutable.com>

Cloning and deduplication have always been rejected when the source and
destination inodes differ in their NODATASUM flag, making it impossible
to reflink data from a regular, checksummed file into a NODATACOW file.
This is a long-standing annoyance for use cases like copying VM images
into chattr +C directories, where cp --reflink=auto silently degrades
to a full data copy, as previously reported.

The restriction is only needed in one direction. Checksum items live in
the csum tree keyed by disk bytenr and are shared by every inode that
references an extent, and a clone operation copies no csum items at
all. Therefore:

- Reflinking from a NODATASUM file into a checksummed file would make
  the destination refer to extents that have no checksums, and reads of
  those extents would fail with -EIO. Creating the missing checksums at
  clone time is not an option either: besides making the clone read and
  checksum the full range, the checksums would be shared with the
  source file, whose NOCOW behavior would then silently break, as
  writes never go in place for extents that have checksums. This
  direction remains rejected.

- Reflinking from a checksummed file into a NODATASUM file is safe. The
  destination inode has NODATASUM set, so reads through it never verify
  checksums, and the on-disk state it creates, a NODATASUM inode
  referencing extents that have checksums, is already handled correctly
  everywhere:

  * can_nocow_file_extent() forces COW for any range that has
    checksums, so in-place writes can never invalidate the checksums
    shared with the source, even after the source file is deleted and
    the extents are no longer shared. The first write to a cloned range
    COWs into a fresh extent without checksums, after which NOCOW
    behavior resumes. This is the same "COW once" behavior that NOCOW
    files already have after a snapshot.

  * fsync of the destination logs no csum items, and log replay only
    deletes csums that were found in the log, so replaying the
    destination cannot remove the checksums of the source's extents.

  * Scrub, balance and device replace operate on the csum tree per
    extent and do not consult inode flags. Relocation already tolerates
    per-extent mixed checksum state via EXTENT_NODATASUM.

  * Swap file activation rejects files with checksummed extents as of
    the previous patch.

Relax the check in btrfs_remap_file_range_prep() to only reject the
NODATASUM source -> checksummed destination direction. This applies to
both clone and dedupe, which share the prep code.

Link: https://lore.kernel.org/all/CA+H1V9zNSiJgXj6w8i2syhm_4qeaxkYPZHuxLgjmfP-jjGMYBQ@mail.gmail.com/
Signed-off-by: Daan De Meyer <daan@amutable.com>
---
 fs/btrfs/reflink.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 9a49d2ecb949..9dab689ea388 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -858,11 +858,21 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (IS_ENCRYPTED(&inode_in->vfs_inode) != IS_ENCRYPTED(&inode_out->vfs_inode))
 		return -EINVAL;
 
-	/* Don't make the dst file partly checksummed */
-	if ((inode_in->flags & BTRFS_INODE_NODATASUM) !=
-	    (inode_out->flags & BTRFS_INODE_NODATASUM)) {
+	/*
+	 * Reflinking from a NODATASUM inode into a checksummed inode would
+	 * make the destination refer to extents that have no csum items in
+	 * the csum tree, and reads of those extents would then fail with
+	 * -EIO. We can't create the missing csums here, so reject it.
+	 *
+	 * The other direction is safe: the destination inode has NODATASUM
+	 * set, so reads through it never verify csums, and any write over a
+	 * range whose extent has csums is forced to COW into a new extent
+	 * (see can_nocow_file_extent()), so the csums shared with the source
+	 * extents can never be invalidated by in-place writes.
+	 */
+	if ((inode_in->flags & BTRFS_INODE_NODATASUM) &&
+	    !(inode_out->flags & BTRFS_INODE_NODATASUM))
 		return -EINVAL;
-	}
 
 	/*
 	 * Now that the inodes are locked, we need to start writeback ourselves

-- 
2.54.0


