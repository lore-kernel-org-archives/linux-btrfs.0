Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED536F415
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116453; cv=none; b=qdGoy8BQJODEjQipfnbpSWj+P/UiMQ1shWYoXL1K4NflNnqaUTy/MXovoQKOCzqXW0PbEbN8j0umTb2+Jf8jrAOQXyUPi7AkHjVM1jQ+R4SkYExrIj1BKnsVD5NldyVW8IKrG2Ld8GJqmvhTZc3kYxFJOA3miUDI/6BP5sieauc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116453; c=relaxed/simple;
	bh=anSX/SV9xeOSkJX8l+vsEHjGwvYXyn0HsOBOtmZMnDQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVPo0zFREyCqJ/l77QQNeTbXQbrZhJ17EPAjdEW8oY0Y3yLAq/U1KXIchUs8jWR5YBBe8c82+FO+a6yXyUWyQuNoophTFzwr7ZpkdD6eXyNYmmZGw5IBgFmqtEr85d8iH2Nm1iaciyX7Y37zjqybHGtq4lsFGUl6FBOhsC4sP2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZ/uS638; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZ/uS638"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E95C116C6
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772116453;
	bh=anSX/SV9xeOSkJX8l+vsEHjGwvYXyn0HsOBOtmZMnDQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QZ/uS638xmI/Ti7AZzCXCY/hD7BnDvZogTIk1ivOifDIfnuz/sHDRvr527Orr45DG
	 ERzQs4IOC0Y7DMDnBiKrvmtPoljVXqTW2aYp5AG/mDanicwx/lU1sFIsopz8s+QlsU
	 OOYfz9xOHLOLe8CciUVgt9/5loB1p+wwu90PEMriMqk9MtmbTssjJvuSiQp9kI0ZY5
	 0Boc7vHM9GTnz5xIIB4huAXG3HenboUOJf2Q7yXaDhXYF6cfPLlfVi+nDE+AfimQqK
	 eiPmTHhVq7RZyxBJqQuV29i3r64t7n9KYEtyOOozdzJM0nP+bcWa4dGnlBH9sTL7Qs
	 Dc3wiSh0gtqww==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs: remove pointless error check in btrfs_check_dir_item_collision()
Date: Thu, 26 Feb 2026 14:34:02 +0000
Message-ID: <2c5b7e7df7209fe866024d2dad12563af2fa851a.1772105193.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1772105193.git.fdmanana@suse.com>
References: <cover.1772105193.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We're under the IS_ERR() branch so we know that 'ret', which got assigned
the value of PTR_ERR(di) is always negative, so there's no point in
checking if it's negative.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/dir-item.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 085a83ae9e62..84f1c64423d3 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -253,9 +253,7 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir_ino,
 		/* Nothing found, we're safe */
 		if (ret == -ENOENT)
 			return 0;
-
-		if (ret < 0)
-			return ret;
+		return ret;
 	}
 
 	/* we found an item, look for our name in the item */
-- 
2.47.2

