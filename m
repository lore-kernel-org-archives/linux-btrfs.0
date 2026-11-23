Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795414086;
	b=kiRO+XKHK1sgxIQOPdq0DJpUQ3iJvKoK2zhjoqTJg3vho9DNoPlJIMOetyGJCEmgs6NZ
	 MA6H57s/5jtz7RrvdvmSFhsO7Xy9vdDhorSVpITjzuJPSGEHTkiNFfyAbzOv2pn6OYpiS
	 nPCdhyhN0MhYiDJ+5fL3ytt1ee2dncoOUXUOcMW91ZEFNLHoZcwEP8PqUwOzuelnPGpwU
	 v8Q8CXtXD+9JIIzSE77wxFigVYpnZEHKfyiX1o/ReeIeSKHBbajs4FgLoiUO99SvIPnPR
	 pLCJqNvgoV0Q4nNmgH5kXok9SR/1lceJNtbR/10r9X/4BpSmC3EZaEMOf/fhtBwI5yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795414086;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ReilvFzCgYhLXA7zjDQvMxQ2lWWe0sIwwMgvBSXISis=;
	b=KCOH1NWTGk4+G4UBheoIevsHMEFv/VNbRkIz80lsjAItqi2KS1nLISI1lczGl7w79/vC
	 k8BODAktXLm3AGZzB3UYTq1r4xgbgidZZg5P+B742o3IzL4slcd6TkDi0iCzj77+oeIhI
	 4zXDNoqYU53hLm7sZw9DaoAkgAcgjCz87VCktovXHwsCblgUCaweALJe9haOxjWZwz+mN
	 xOYpG/N2ZrLiQdG4D6XW4RgvZyReQ6MW4VGatfJW4mpEdgbnrNZ55FI1WWx3EeNGAhTGv
	 dVmkzZfQEAIeVFL+F2H8sBIMvcpOL36xV1WmXFLAB6v0IBzWRq6PnHioWAyyiOAZF4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acX1GXXq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282E9606A31A;
	Mon, 23 Nov 2026 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acX1GXXq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795414085;
	b=PGXz+jXOMzN0/DjFziAUgIrfgu60yL25QHZHEg0tjBse036aRBK79FZuaBitK+tD6dE6
	 MH2R94U9c6yGf+3FVQYOzQVVvbKWhauMAX19XF2abbHkvODdBIwLGFczMnS0s26oiIMDP
	 Z9HE6y1WEYLY2NtY+tjQJ8kM0s625Oig7KRNc9edGKNUmOgf9XkHqdIavNrq7uk0QCItS
	 hdIIg0l0z1J/IoxJvVpH1477YThtJG9exDZyxa34ylRFXXcrVg/tjEc/8Nw0ubXY6vPRN
	 XVdBpqiihmt7GaDaLslglt+pEUr892MHr0ztwO80S1y9+AUhvxjUOgiWknxMfxyaWnw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795414085;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ReilvFzCgYhLXA7zjDQvMxQ2lWWe0sIwwMgvBSXISis=;
	b=J52XuCkCrN4AAp+KBdcE9f+nxoNKEs+rY+S7fRCCSfkrsGIfGiq/hRJ/tWOTtOscm+FJ
	 /pIHeYrzgvGe77nAvQffFYLoS4I5pjFVCm3T/DM+qOEuawsjvvZgJc5RavQkO1WDXGNOX
	 y3m7mPlwwxEQFRhNNllB6SzSfpjRa36r6xEMIisti5o8xlFmYovdNe2V0phje7+j8O1vA
	 0p+7qKf86bfNBnKaOpgovgHPSt84/AQ1dbaiOvi2+ELnXDtz64P+QkhgMda6epoEqJ5jJ
	 W+kcd+P92+PXIOCC5ilYnDK/89Z7COstl0AlydrqopsPQjqKIOz63Jm+cPmRVB01rew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6A67B1F000CA;
	Mon, 23 Nov 2026 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795414085;
	bh=ReilvFzCgYhLXA7zjDQvMxQ2lWWe0sIwwMgvBSXISis=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=acX1GXXqYktOxTs7tba0wJlXLba987VVTc02Y2bG4YJoNcPk8SF/LTDqjf7XQae/b
	 JPY2ZbyOIb3eR7CHDwkLcNiDAszqnrS9ifSH+X6VfrKPryo0DlCoYZQy6qKIlv9py3
	 37Egce38+16Eoh8wB3IZIDv4xe2SrzH8f5Zv08DCalNKlUifSysu6eN+ymR7p3N/Zr
	 HGPh6207SAXvwD3CUlx4o9WhQ7YP8MzLvfeGBEVarW71KHN9amt87poS1PCumj7l5S
	 AXZitnO/HE/DUYZ9b7CAVnMozrDwI9/ykOM3qrAgm/b9VahqpP4zq2a9+3MoVSEaN6
	 yOf19OpAwBxBA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EF2354C387;
	Mon, 23 Nov 2026 06:07:55 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Mon, 23 Nov 2026 01:07:56 -0500
Subject: [PATCH v2] btrfs: fix loss of fsynced file after link into new dir
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
Message-Id: <20261123-btrfs-link-unlink-fsync-v2-1-ed3f9f63fbd7@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CQAyF4auQrm1iZwIJXsW4GMYOVE01UyAQw
 t0dcfXyLd6/gXEWNrhUG2SexeStBe5UQRyC9oxyLwZ3dg2R89iNORm+RJ846THJVo0YfGiprol
 800J5fzInWY7y9fa3Td2D4/jLwb5/AXziXF57AAAA
X-Change-ID: 20261123-btrfs-link-unlink-fsync-a3a915511369
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795414075; l=3112;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=Tc91JtfYmxCuiF0usK0qEfcZgYz3hGtDsKZfAKcD+5w=;
 b=M7IgzntfDd/wqtPf0wHciUSB5SEDcweEyRSuqVzvtgtZRBku0pV6oB/3gj7A9c0e+R8+QD24H
 +L4yLy5ZV6TDAbcEUoc727CvBKhH0JdCYH7tWSZvejEMSzKI+lyIgtq
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
  fsync(fd)
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
from the inode refs in the subvolume tree and logs B and A.  Also return
early for an inode with a link count of 0, which has no parents to log.

The problem is old, e.g., v7.1 has it.  It was hidden by a transaction
commit fallback between commit 0f24ea456ae1 ("btrfs: tracepoints: add
trace event for btrfs_log_all_parents()") and
commit 36f9aafa46f5 ("btrfs: fix unnecessary transaction commit fallback
from btrfs_log_all_parents()").

With the fix, the file survives log replay.

CC: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Changes in v2:
- Return early from log_all_new_ancestors() for an inode with a link
  count of 0, to avoid a transaction commit (Filipe)
- Drop the fdatasync mention and the reproducer paragraph (Filipe)
- Rebase on btrfs for-next
- Link to v1: https://lore.kernel.org/r/20261111-btrfs-link-unlink-fsync-v1-1-a817d4a890af@columbia.edu
---
 fs/btrfs/tree-log.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 763487114f85..445374b06ee8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7541,11 +7541,19 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 
 	trace_btrfs_log_all_new_ancestors_enter(trans, inode);
 
+	if (inode->vfs_inode.i_nlink == 0) {
+		ret = 0;
+		goto out;
+	}
+
 	/*
 	 * For a single hard link case, go through a fast path that does not
-	 * need to iterate the fs/subvolume tree.
+	 * need to iterate the fs/subvolume tree. But not if the inode had a
+	 * link, unlink or rename in the current transaction, since the dentry
+	 * used for the fsync may then be an unlinked one.
 	 */
-	if (inode->vfs_inode.i_nlink < 2) {
+	if (inode->vfs_inode.i_nlink < 2 &&
+	    inode->last_unlink_trans < trans->transid) {
 		ret = log_new_ancestors_fast(trans, inode, parent, ctx);
 		goto out;
 	}

---
base-commit: 845c6105edd82f5d0aa72377ef6eb8592ac4e00a
change-id: 20261123-btrfs-link-unlink-fsync-a3a915511369

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


