Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009867;
	b=ninKjLNdsb5UH9dYfynHRNmhr1XNS1uFaNxh9nlexBJWeX5vUQRKHaxYVNEwF/sQ/iEk
	 g22dJlttee+jfDLi/w8Cx7jAhQ+Ys3BeNxSx/XVS66eB2kgw0N7eWJLUTPAHviwVNhJFd
	 WKsnIrfq8NBrm/Z568TwN1o4Ti5szDtJ2eLTKSI7LCLmaNA7fiO6ziU3L66lHidygwgC9
	 wqJBJTvIYfqJIVC8f66OiavVgLwKXEu2kbOeP0sbPE6sxEMFH0ku/ghrrC45I0CORkSud
	 4n5yTKWD0iTKyW+aNJ1G/ok2Mou/Fy6CsSIppoE08+pjy2/S3E2JZ1AmB922rx8glsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009867;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+pHZZjbjZi9dhz8uX9Ih02/oyP/Ydt+NtP/FhTj234=;
	b=VE8ECUqNvK7DfL5zQMc+2gO2FH4P5z+CU4A5KJ5NP7HvSIeekFS9RQKvypnAggQVOs0s
	 25bt/8Uj7yYlgxmcIQpayEgR+coibrW5CIpyYIGD2xSSQokHBcfgh1UCGTxL2UaxnGYcC
	 9jgvVikhdc/zEhH4XMSMMXvsA0+XGZWO2BIhHvuUMaiINs5Q+ZEtY8gIgfh1yVRLOR95P
	 dg+go+kVGDyOCEG7R5igD9gtW0N2BLGJ2Si3WEMnlWtz6cVCkslTvJvQNi9wPtIDq1XMR
	 Yi4X6TBhWFsXSxtVOIjzV0JOGQ4wVtObOw5B9HPQq171ooTyNadlBcUEsUynGWXWiiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+phfPjp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4545C606A332
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+phfPjp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5711E1F000C9
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009866;
	bh=f+pHZZjbjZi9dhz8uX9Ih02/oyP/Ydt+NtP/FhTj234=;
	h=From:To:Subject:Date;
	b=L+phfPjplJzF81nQL94VHMd/VjQdqiygogz0hx4UyUQnJ2p6zrx0p9C+D1FcMgw54
	 bnIsyGxnyKpR8eYr5pouzfNhGnx2YarzV6IxVO+B75XyfM0vz8M3UkAAOFNveJa2Na
	 X3w2r27vUxRLTU/fJiafK+8uhiWCqHEkMBX8TnqrNlMb+0yhZ+MS+TbbkxdWEAPoZP
	 LPKLF/4enJhG6y8daJdoY0/F0zgCxm32NBWSYC9ubV964UZj9OwK4cxJKCkrrcV9ab
	 +9xiSRQUuzrGvpTJTkayNjtYo15aW/FeGEyVYOHAaBfy2sxxwqXDufRh+lwm6H+iRa
	 uG1Pp+AAjWe3g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix double free of reserved data space on error in btrfs_zero_range()
Date: Wed, 18 Nov 2026 13:51:03 +0000
Message-ID: <09aefee29f14e92778f56805b7b8fe7a539e5a8e.1795009782.git.fdmanana@suse.com>
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

If we reserved data space ('space_reserved' is set to true) and then got
an error from btrfs_fallocate_update_isize(), we end up attempting to free
the reserved data space by calling btrfs_free_reserved_data_space(), but
that is wrong because btrfs_prealloc_file_range() will deal with that, as
it either consumes the reserved data space in case it succeeds (by doing
extent allocation) or frees the reserved space if it errors out by calling
btrfs_free_reserved_data_space() - that means the second call we do in
btrfs_zero_range() will either result in an underflow of
space_info->bytes_may_use (in btrfs_space_info_update_bytes_may_use()) or
free space reserved by other task.

Fix this by always setting 'space_reserved' to false after calling
btrfs_prealloc_file_range(), as it clears the space reservation both when
it succeeds and when it errors out.

Fixes: b778cf962d71 ("btrfs: fix bytes_may_use underflow in prealloc error condtition")
Fixes: 9f13ce743b1b ("Btrfs: fix missing inode i_size update after zero range operation")
Link: https://sashiko.dev/#/bug/linux-c6462d6d-8e2a-45f7-8918-88f8788394a4
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 78af88168f18..ee1e1f90d660 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3077,11 +3077,13 @@ static int btrfs_zero_range(struct inode *inode,
 						update_times);
 		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				    &cached_state);
-		/* btrfs_prealloc_file_range releases reserved space on error */
-		if (ret) {
-			space_reserved = false;
+		/*
+		 * btrfs_prealloc_file_range() releases reserved space both when
+		 * it succeeds (by allocating extents) and when it errors out.
+		 */
+		space_reserved = false;
+		if (ret)
 			goto out;
-		}
 	}
 	ret = btrfs_fallocate_update_isize(inode, offset + len, mode,
 					   update_times);
-- 
2.53.0

