Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AB02727EB;
	Sun,  1 Mar 2026 01:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328327; cv=none; b=cYmTcAcIFrfl8I1k3uPDT0Q2qv4PoQeOTit/4xtRsUgMBW91zTRoruAnPrSZvykofe0StPVZCsx3zcSGpQBagM34hO9VJXVgyOc/9cwPlasuBd177JXqAiY59RIg+3IUm6HuZCc8q5e4zWdt9VnOLe69FkEyLnaKU6gsyquuoBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328327; c=relaxed/simple;
	bh=BSyhT9oBshIcKDVbATWxuNqm1mnYNuJkQRgeq5A5nEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GzhZunJzzafSaQTALg9FIfiWEv7/BK3f/YnjSAvKhNVKoLEf/nERkNh5sDpaPVt7ELQjYV2iHIweYCqQIiYhKvHzwsujMAxxb0aLn3NSr0YMdi1VctuA3YCbgu0+EBSF/wuOSPdIPeT1Z/nPJRxdZvI820gzTrHQdfURbvZrfWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLQJlKj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLQJlKj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EBCC19424;
	Sun,  1 Mar 2026 01:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328327;
	bh=BSyhT9oBshIcKDVbATWxuNqm1mnYNuJkQRgeq5A5nEY=;
	h=From:To:Cc:Subject:Date:From;
	b=qLQJlKj95SSHviF8ncZYF/vtqSQtc6CEeFmDE7MnuXkuA2nt/s6RbxmXznGXqSZug
	 U6uc4nFnjsqOqTZhkQrf505K1vF/tPG68EEOH5zwpV1N+W4gvKVx81kt1GkKV/SHqI
	 XzjSNW6iHQC8TcB1QhkJLyZQKfHOxfsLcoV32TgkmmNfX0u4gvJoEfmJ9c/WSzW4PV
	 q9XlmA/xWwDZqme/QuHmAykuevhQGHawkASuvKQpe6KBz0HCzAcrpa4dUyKgLtumyq
	 M2kORUq+KP6r+yfAOSM7YQ8u8VaJ7EzGc8weOQmOz8SzyybnfXwhdYfYEgw5fXsttL
	 wmAbdvyZ1bYYQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jinbaohong@synology.com
Cc: Qu Wenruo <wqu@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: FAILED: Patch "btrfs: continue trimming remaining devices on failure" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:25:25 -0500
Message-ID: <20260301012525.1682523-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 912d1c6680bdb40b72b1b9204706f32b6eb842c3 Mon Sep 17 00:00:00 2001
From: jinbaohong <jinbaohong@synology.com>
Date: Wed, 28 Jan 2026 07:06:38 +0000
Subject: [PATCH] btrfs: continue trimming remaining devices on failure

Commit 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle
error better") intended to make device trimming continue even if one
device fails, tracking failures and reporting them at the end. However,
it used 'break' instead of 'continue', causing the loop to exit on the
first device failure.

Fix this by replacing 'break' with 'continue'.

Fixes: 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle error better")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: jinbaohong <jinbaohong@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a91bce05ffb4c..b63296e9abf48 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6688,7 +6688,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
-			break;
+			continue;
 		}
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.51.0




