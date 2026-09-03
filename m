Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455FB4E3ECA
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450211; cv=none; b=Yg8hEJ+Sf4vhhFRgHL6v30U3EBPZDd4PAHUzMY+choh0JN2K++lnU5PvvORLigUCDB6xBIbn2waOkdiq4zt4wnt9+ail2fP3zKuBSYzdTl9K8DTbL+TBJ2FwEeGeT6zdfzoQ6XTWosPEso1qVIqn+tWi2sd6fLQ6Ah8IFzsUcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450211; c=relaxed/simple;
	bh=hFr2BsUMV6yiN9Grh2oOXrDvuV3uUcXHXy7mQ3Mi1P8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bYi7aHCSYaBfj8exRpCAsFvIe4x8QG1MXHlElLcdRoIXCKVjNkCRphs7XnbEvfe1KK14QcF3R3hrv3/06yxLbKU5F2jTG+1PsuE6Z8uReCymxP74RhrRU/A3CQI6yUAygLh77a8m1sHxlSOafuD4PFjpU5k/sjuSmOJnIXuqYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R136vEFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R136vEFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908991F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450210;
	bh=8iyVIaQnEO9ow3oeaP3012OoEKANuHVMN3dzsP3eMGg=;
	h=From:To:Subject:Date;
	b=R136vEFxuNda3clkM/D7V9oZ9M7h4eIcCp4Ye64jexBFgE7+dJNZsJ1jUwgizfarj
	 8lfEUBjbVtUuKXkrZrEuij9Fz/p/fkB2KpcmV+ua4VH3FMHCXkeHfM+974fj+3gby+
	 CyAYWYW0lDcgKNpSE974hZbltA6SGoAxuTjflHkBOhnfZ7bZXQ6CuMLjjf2PDoShtm
	 SZb79igh+M4soLC1EYfB+6qzXjwcwL6be3lvLLPKThJsODxzKun0ZM9yxq4XytuB0T
	 nQbDQAuvJfpKz1KovQ6wCCZCWYqGkTgL9m1xBFKlOJIlJ7mqOsNb2j+8x/+SrWx7yO
	 FcUZuhQyICdzA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: avoid unnecessary transaction commit and tree-checker updates
Date: Thu,  3 Sep 2026 16:43:05 +0100
Message-ID: <cover.1788449622.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Details in the change logs.

V2: Updated patch 1 due to sashiko's complain about lacking
    checks in tree-checker for inode ref key offsets and unnecessarily
    trigger assert failure instead of falling back to transaction commit.

    Added tree-checker patches to validate inode ref keys and inode extref items.

Filipe Manana (3):
  btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
  btrfs: tree-checker: validate key offset for inode ref keys
  btrfs: tree-checker: validate parent field for inode extref items

 fs/btrfs/tree-checker.c | 22 ++++++++++++++++++++++
 fs/btrfs/tree-log.c     | 16 ++++++++++++++++
 2 files changed, 38 insertions(+)

-- 
2.47.2

