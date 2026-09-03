Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A986337B016
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451240; cv=none; b=MNLyN22EIj+D/YTXxy1eyEmshpnKcG6iYHcocKdFoBCvylxwX98gLfjsEfm96w42JTpWyrD+pZyKmP/H0haHMRJCCyRImOROSMpQf3cVDNDIPw3Foih+vpWzZUgB1A2KIC9a9AgA63G8CXP8+JSpmHcM5DrN3yIbmbawoDpJgKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451240; c=relaxed/simple;
	bh=2xu1jiPJJeGjQNESRImHjjmih47OI4mFj6Fe0gsasd4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2oOyLwiJsZ1VwMv9XDWb83eK0eBkFghSm/o2EMe98PDkC5b802z2iNwOKvJ7cW+oZKRJNfszhpNMQ0vHF0Sb3kh84XGJfPi5uwQ1Ra6Zz8N7oilZF4x0vKExkL1HOOo2Z7jg3oDhrEZb1RyKZ5Ko/us6u8GiEmzAmQ+5MARuls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6xIvoIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6xIvoIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCEB1F00A3F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451238;
	bh=EE5xHP3ALzP5w2a6WwovFTXknUCddOdlV2HUk5Zjp4U=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=d6xIvoItnxF9iWwK8ySc2TF7VpZ7J4dP5t64msMo1fVKkukFqz9/2XHRtsSHggp7U
	 9yAtip48PRVic3xabaPKjKpPc4maqvXVvotH1BCxVB6jAAAdQzbaRyVqVJ782UmWy+
	 loPnKSZxqsmlI1AZtWb21avbESUwqKdCICqgTRqOI9d/BBpXlwBltLccJ6xZg+8cqy
	 D2GV1uWgtu6aikcNr4GsADaYJvJ7u9J8tmj5GA0qw5vzc1xA2FIAsM4iS3qRhLp/hk
	 5TQlZAPt8TTdpNJtq5fSW09tRC0bwUPIpk1NlnokX6nlcAAma8iK8hcy4edaf6n46o
	 tfikEMWcLQXJw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: tree-checker: validate key offset for inode ref keys
Date: Thu,  3 Sep 2026 17:00:32 +0100
Message-ID: <47be3dcdaa811319e0a6354e572c3cc795647d5d.1788451065.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788451065.git.fdmanana@suse.com>
References: <cover.1788451065.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

For a subvolume tree, the offset of an inode ref key corresponds to an
inode number, and that must always be within the range:

  [ BTRFS_FIRST_FREE_OBJECTID (256), BTRFS_LAST_FREE_OBJECTID (-256) ]

Add a check for that in check_inode_ref(). Sashiko had complained about
such check missing in another unrelated patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 622334ffd240..7dff824cfc4c 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1951,6 +1951,16 @@ static int check_inode_ref(struct extent_buffer *leaf,
 		return -EUCLEAN;
 	}
 
+	if (unlikely(btrfs_is_fstree(btrfs_header_owner(leaf)) &&
+	     (key->offset < BTRFS_FIRST_FREE_OBJECTID ||
+	      key->offset > BTRFS_LAST_FREE_OBJECTID))) {
+		inode_ref_err(leaf, slot,
+			      "invalid offset for ref key, have %llu expect [%llu, %lld]",
+			      key->offset, BTRFS_FIRST_FREE_OBJECTID,
+			      BTRFS_LAST_FREE_OBJECTID);
+		return -EUCLEAN;
+	}
+
 	ptr = btrfs_item_ptr_offset(leaf, slot);
 	end = ptr + btrfs_item_size(leaf, slot);
 	while (ptr < end) {
-- 
2.47.2

