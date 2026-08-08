Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC330FC27;
	Sat,  8 Aug 2026 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786171130; cv=none; b=V7C5tdWX0O9kSVxj1KWCDRwEdQJpJmdCfmj+2pVx1g4qDzXMFL+JXVQownLwU9TQo9pmS/1CrdZHmAKxhW0UV16irvRsaWRLfYn+IM6AzZUAiLisXmnmUG3C1TJ0FEN3gIztF8ZJMC4iRY2icpNc7Jp+humwy4fGLMU/q9ZUzdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786171130; c=relaxed/simple;
	bh=ly2O4DLEu3oCn7zJ1AdY7cNNK/nN+ciooqZD5gddQEI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=GEsQAbMYiImdMbO0HXQsXyXeJOdUatFQaiFVBLy7M8IwqN03Um0LbGbSdtRJWdbUuJiCTsZZBOlg6iz9+fHbtbtHOyDJM9MYk6DTZvEVslsNipHlJyupSfRetr7HXQmMdSzxeJS0hS/ioe3IYYbAc6qGPq5NTEshx8KG/+lwsjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=MZyyJhvL; arc=none smtp.client-ip=43.163.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="MZyyJhvL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786171125; bh=kj+0Mzv5ttgztkrHL3Pf16c95aIexpIVnqhxykenI0Q=;
	h=From:To:Cc:Subject:Date;
	b=MZyyJhvLA/q1fS8j55uuH+jiawkMzaYg1wp8YGO/e5Ebb0SnIN+yyDVbXtuAV8DHD
	 vSsrOIwkhX82xbrYftz6IyUdQwLzZLek+PcrGCB/ssv3RAwb0Tw/GlIL5HGH5E7iP5
	 plkg638LfS3nMyj53vlBe2w2zNMTFxgHe+ihQLmo=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4824:bd7c:c5a2:f149:1f65])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 9A4342D4; Sat, 08 Aug 2026 14:38:36 +0800
X-QQ-mid: xmsmtpt1786171116tzzrel1np
Message-ID: <tencent_853134544C3CE88A219EEB21346E2510D308@qq.com>
X-QQ-XMAILINFO: Mhzd+K3mccYxspHDQD51+omUPoArQjCBX9D+9vFQeeXY/ExsmYk0DMqqwbBPcM
	 vNPaD1n1swgUvwTT77tY48YEww17QX0Jer5OMsBeCNJ9vLg+Q6S5dfJ8qGc9EJPPSO7ZCCDDOMRn
	 LWg/tVs4ozgBuqTbhWkjsuDKEWP8GwGESuxpRAwp//56tsXUe1HB9JgV66XEuLMOjFMJoRsuTl1+
	 CkL0P/zcdoRF2kYGtUtZN60XBFpuYOM18YajSen9nkAFJRDp3JecWpw5wsc9m3UfE0cUJIouT79O
	 +W2KNo8prp0DwLFSdgpLNlgvBoymNVe+J7tlid3BYOQQW0b8M9BlkAJdvkWfCdt1xwfZIMwjz8AD
	 bj/qEI5iCNEJQNgKTQcjm3rTyuDfpVfvGG9uzu/1qva3hIBCx+11GjAKmgCpXb1R2IOIuMv4KGko
	 Sn+Gn1qUQMYbYO+oJLs2eRWeBSgnFS3UOsW5RzI04zNrGUkc5eX8EVT6eSW3mVSKJCtTtdtbqX24
	 hGmnHJLY0Uc3IbPFGTOtMUmnhSeP12LACOE3OWKiX140lLQt2vrD8VJhymFXIg1ukt9abu6TLaFG
	 e/1jaAOf75BuaIx6eKpioCGMDL0ksOsqCgwoYPnAFaxyB6Ldmyflz91XIn0S0evW5IBVOsey0Zwb
	 SdOvRuX5Hzb81E9MZIf0fTDzxEgBspJxMUJw7Re3N6fiY+G8TvV7jX2XKSOhV92QV0LiuwfQh2z7
	 D60AzpDOwlWaoB0SeN7SlfLHbH1kh97g0ndZcBV9qz5wDkRvtTksMGffOw6NveMW88ctsG/VxlAH
	 6VGQ6Kqcds4lLVMuj/tGv+fFTRW1Kk14LSzZvU7nAFoFFp41XZBEXWLqD1axp4jd9YH8RfjFreHr
	 wM9GBKWULaDbBsYhRRIlGQQsAU5FNuLTjXeOm4afkDuT4yb50C+hS7AeyBIZNejm0+sPlQVJyiLM
	 Ka0AW4k9sqpGny1uBWkDoqCOm0qYtvT0MtllGBgy1E0+0U2IMUdrn/FDS2oV9D8xNFrKhjMR9hqh
	 CsxymsAFveKdeuPpKmhbMuHGeNxb04HCwT0g5TmzcmT02MKEd0epwd1RwZuPaa3tWcmZpdZw==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Guanghui Yang <3497809730@qq.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] btrfs: clean up target device if block group marking fails
Date: Sat,  8 Aug 2026 14:38:32 +0800
X-OQ-MSGID: <20260808063832.149396-1-3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_dev_replace_start() adds the replacement target to the device
list before marking block groups to copy. If marking fails, returning
directly leaves the target linked and keeps the device accounting
incremented.

Jump to the existing cleanup path so the target device is removed and
released on failure.

The issue was found by a failure-path metadata residual analyzer and
verified with targeted failure injection on v6.14.

Assisted-by: Codex:gpt-5
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 318ddb790..bf0b78790 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -626,7 +626,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 	ret = mark_block_group_to_copy(fs_info, src_device);
 	if (ret)
-		return ret;
+		goto leave;
 
 	down_write(&dev_replace->rwsem);
 	dev_replace->replace_task = current;
-- 
2.53.0

