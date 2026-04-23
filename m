Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9230E821
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952987; cv=none; b=ifoEudtrM2d1nlQjJZRwyTcSnJLXYCYfj1uon4g5VsCjWfqHM0vKk3HW8APtYkVYL1dWryXyYW1vo/R73G7ztBw1bRLK13sE+qIPvc545dtTfJhQhkjKtBJgClCHO8qYnRTi4xQ2dbYAcqbqfOvhcSh0HxfZs2xQYzxXwKtkpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952987; c=relaxed/simple;
	bh=gCablaU+cybpk4MQ8hqxscKEfJ5WCVQ60icCMoiQ5MY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LC2CvSCplBWIwmf2H3VYLSQlJCBCk//jwuTywybOS2z4viAupUMN7dayou0o3CiaYUgw9SQsG2MEHm/EmJ3R+xZnvbx5Lr8wVLfNEsACGLVA9l6t9L7wTz/m+ZXOKb3xzxQCiloCRyi/uykB32/Hg4Laz0XY4rnVoWaQ2D5bZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kOXVqKRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kOXVqKRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3DAC2BCAF
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776952986;
	bh=gCablaU+cybpk4MQ8hqxscKEfJ5WCVQ60icCMoiQ5MY=;
	h=From:To:Subject:Date:From;
	b=kOXVqKRAngtCqM28CoppXc/kSaPDsAtCucpbADf86miD31Ghd52qrvqceXrc1piCV
	 2KYWhNNY1knMFla8xDR5kgoi//SexFQFyYwuegrxws7yfRjmilX34v67Mbb9auzW6t
	 psT722utcnnDL4pAMFhJyuWHMQbcVuzNQhsdagegobhmuKHXg1KNlqP8ajnvXUee0V
	 D3VnkQVaz0CQYO6XljW5DrTcYUY34iojk+t9/jMVbekcwLcp8MQ6BiV261/X+VVs18
	 xSFYFhIHqP3TLcn651lK55VT6UkjN5/I1BXYU5H78yI6QYIHXWKCaC79k/KJn8lIqc
	 DEc1td3fANM/w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: change return type from int to bool in check_eb_range()
Date: Thu, 23 Apr 2026 15:03:03 +0100
Message-ID: <1a69f68aedf5ea12277401b8ad5d0a17a3ac4a25.1776952936.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The function always returns true or false but the its return type is
defined as int, which makes no sense. Change it to bool.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2b0aec031a9a..0597b0041aa7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3983,8 +3983,8 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
  *
  * Caller should not touch the dst/src memory if this function returns error.
  */
-static inline int check_eb_range(const struct extent_buffer *eb,
-				 unsigned long start, unsigned long len)
+static inline bool check_eb_range(const struct extent_buffer *eb,
+				  unsigned long start, unsigned long len)
 {
 	unsigned long offset;
 
-- 
2.47.2

