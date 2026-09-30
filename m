Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1850B8C6
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778355; cv=none; b=fGqYumWF00Qw5omJZY3tTga0LcDNlEal5BzoB6ICVupVjMzME+Cp6XPBl6l1Q78hoalnzzpbi6Tcp31zK3laf+GhT8cxDZVOpccIlBdZD9wa8DAIrYMQwCL4cTtzelG23rp4asDfDFoHMxXOw6JxggMTuauIqKiS+Jp1w+KLJpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778355; c=relaxed/simple;
	bh=ELtEL8ElH/3LRc+xH5OoUKUzINlyycI7tli4KiEN2P0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCDASH/2iAJPfTvdrLs02UwQjXMdX7Uz48P0If0yx5lsy40RW+t6sIywlT6ugc39938bCneYYI0D8XTPQZD7gJ5ae9J5N2PgonBj90ZA1NuIapLxt5dyKKgF+4l79matxtYzTrTTPlUga2gZLwbvO+veQSUT6Q7mFBE+qL0gQ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHhBa+/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHhBa+/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811321F0089A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778347;
	bh=olbwS/oe4ZGSuACUxO9x+fZxSB6h6ZjCLrzrZRfolow=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MHhBa+/CfrXkUyrXcbNse9KGx5ntpAeDHOor/WnI03xdhnU3Z5KFgOwXzoXlQ7eH+
	 C2UMocMGaZ5XITCXX3rdAplZcsNzdDcgIi/yFIAghk0vJ5/hxZlLlKAekeZ0paMUTk
	 X2QEUMwvrpNvfqjtGYdo2RUOaZTIc0hNx4V6YbkSEGKW+MhGTbnD4Pc4Bvcw5SS8Z+
	 cGb3fI95fGa/rtLy7eIoZFQZIQ7yIlpTUCqWOi5EQIpsx+yV0vmaGUxamsXZK5FhQ8
	 Wgy/0lVqKE55lO91wY8T/EpP5kAomGg/CN3Y96/tV6x7Eh8qwsf+cVkZOwuLbDtnzJ
	 WNOOP+vczUPBA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: remove unncessary pointer increment in btrfs_state_to_string()
Date: Wed, 30 Sep 2026 15:25:37 +0100
Message-ID: <bb12808ee4b92d6451552ef3ff2741647786bec2.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
References: <cover.1790772326.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no point in incrementing the local pointer after we set the NUL
terminator, as we don't use the pointer anymore after that.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 2610b447165e..c42a12139377 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -56,7 +56,7 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
 	if (!states_printed)
 		curr = buf;
 
-	*curr++ = 0;
+	*curr = 0;
 }
 #endif
 
-- 
2.47.2

