Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C7330DD22
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772194524; cv=none; b=BKuXbHfPA5gfYmuQsXxQcr4UvBbl3M73lYOq9yO5AtM8+fKK3fvhlhSo1VAN6CaKY3FOtvzCXP63W/+3wG1LOx/YyQbRshZ5Qh1+zO8E3xfOF5220GnPcxSHHXGJvS1c+y97R2copzEJcUq1Y4i05TgUOzhHfBoGnYSkE+X9VOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772194524; c=relaxed/simple;
	bh=+NUuDQ/ESQssMB6OL2Ja5kT8CpJnPzbFAtyBO+h9Wbw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SvwGKnS/BulcuInfB5AUlBQZ4v6x0JBODh+uTD1kkWjscnQfO1L9b/A+IujbuuklzYTH5rXYGXE6hM6Thk5BfMYpj8uhXycCBw3vHIunpfCpBaXpsSnRaTbvlWx8QeMcwKjuvnr9WJeraOXm1C/1IWxudRdHEUkHYgU/sKm/m4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1ROi8j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1ROi8j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62771C116C6
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 12:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772194523;
	bh=+NUuDQ/ESQssMB6OL2Ja5kT8CpJnPzbFAtyBO+h9Wbw=;
	h=From:To:Subject:Date:From;
	b=d1ROi8j2xf1Qb5ViJfnd7hFtlMzlZZ3aMgSu27T2fn0Ey1+qRWIiyXhAup+W8fHvv
	 PpRU3P8dWAwK4E+8iQmCJXmz3rbpynBLagEDdT8iRiQYsP7RjUP26PDVZ1WIHog6wp
	 xjWGR7jyG5YGbTeTfWpG/fH+0l+/5eIl8tI1cxPUdex44KljqWYUZyVMuieYyoDr1n
	 8aMEXQK2nHfv60Eh4uF3FZOufKoxJcfJXl6CiyXdayciT7EMLl943ClMKpEGW/yPxL
	 a+zXEFiFwkbeDKfmKV9W+MW1B5+eu41k3TY8Nt3M2tU8WL0dTwW6Xtp++F+ORyvzf3
	 p2bqRvw3oLaPw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove duplicated definition of btrfs_printk_in_rcu()
Date: Fri, 27 Feb 2026 12:15:20 +0000
Message-ID: <826d740b6c68bc0d503bcfdf1d45ba0f38872846.1772194240.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's defined twice in a row for the !CONFIG_PRINTK case, so remove one
of the duplicates.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/messages.h b/fs/btrfs/messages.h
index 666b84751f04..556d4e79cde6 100644
--- a/fs/btrfs/messages.h
+++ b/fs/btrfs/messages.h
@@ -28,9 +28,6 @@ void _btrfs_printk(const struct btrfs_fs_info *fs_info, unsigned int level, cons
 
 #else
 
-#define btrfs_printk_in_rcu(fs_info, level, fmt, args...)		\
-	btrfs_no_printk(fs_info, fmt, ##args)
-
 #define btrfs_printk_in_rcu(fs_info, level, fmt, args...)		\
 	btrfs_no_printk(fs_info, fmt, ##args)
 
-- 
2.47.2

