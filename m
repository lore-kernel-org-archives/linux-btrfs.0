Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747253;
	b=NbF4J+HmkyxsiSv3ifJ2YNxcqXc5t9xDwaTzaAOmlOj93SOIsmcdi2KlksIXeBDgbqP9
	 BtYd/xblqZObeAb0OXzlc+oF466F4krLDcLkz00IXDhq5XgKs7P0s3UHW0CQX8aL6zVHd
	 CDVCSPOvp6fs/mrB0y9UIHB0qBoCD2FLYxoTVKfHOHeZRE3GtN/C5kLmgwWinYknWEXHF
	 EQRi2C0uKIrDEMoBt+aA0qiydiIrMXZtpS1JB63S4UK3uOFrPe569qGdADVnHhZdObQF4
	 pOHmgusFJZ+L/e2+r/l/7wOBdb9GOm6wBBUsxOfwvS8ZZwBmJM6/sG8fuJeKkihf11A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747253;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4nTd8bFTcQ+zyQMHl3e1E5nLsrj8+lGfTMZUhyAufGs=;
	b=MsC2dfBdTloWMoBlWtNWQ2Qfvppq2dXkk2O+aEoWtPNQ/oHONtsrhGkFyfFGamvh0DCC
	 7h1hWbwtNEeem5N5VnI4u9vHXWF1w7ODJjg+N06OLVMbojuckAHulQXL9vi8MdzuBvsaS
	 27MabCQJr+ogTOYrorvwa6bCn9D4Z5OO7kVBEpRy3WgpfSSvLRoPMBOGzY7Cqtf88GnsN
	 AuKDid8Migh3CbuPYvG98MpUUlQVTPm5p5uMjkeRp50m0qM30QrESxX1MCedJJsbrXL+1
	 D93HMS5i6FY62ENMf49cdF9OpHlgobd9w1hQWSD66O5dxe6DNSmsiPlZJplEhJ2R/9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AapM/Wfv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57131606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AapM/Wfv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1B81F01825
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792747252;
	bh=4nTd8bFTcQ+zyQMHl3e1E5nLsrj8+lGfTMZUhyAufGs=;
	h=From:To:Subject:Date;
	b=AapM/WfvM+Fr2WcdC/t6YAfjdhV8uWG5dcaLkntY0p3i0guCQ+ET2IszBrmprtjd4
	 +gBw+cVspaByEonq7H9XyYTezVTH+1D1XRVwFVi7EmpmefQb212io8CLCGCQyhSYP0
	 KxtJg/LRcEWpzMugAmDdi0ropOt7Ja81fjpcBRm2uyMyXVwTdZGoFy6O1Hab2b4m7x
	 3Y2dRuI1XFZoBgZCUvaNx9HfsmwcsmU75198MLmIJrA3qLe9U/i1N5hvYPSeAbv0dn
	 4Wul1fYoCX3vWtRj9sqXVVWhLfMY3tS69P50dslr8vD4GdZnNzuU6u/JxGdCRbS5IX
	 bGQBcGdEn932g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove redundant space_info assignment in btrfs_add_bg_to_space_info()
Date: Fri, 23 Oct 2026 10:20:49 +0100
Message-ID: <b8eccd4aecfa8a9e4417f06fbd306b14391f81e6.1792747129.git.fdmanana@suse.com>
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

There's no point in setting the block group's space_info member as the
space_info was extracted from the block group early when the variable was
declared and did not change.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/space-info.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 82d4ac418a2d..4a19ffef5ea7 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -404,8 +404,6 @@ void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
 	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 
-	block_group->space_info = space_info;
-
 	index = btrfs_bg_flags_to_raid_index(block_group->flags);
 	down_write(&space_info->groups_sem);
 	list_add_tail(&block_group->list, &space_info->block_groups[index]);
-- 
2.53.0

