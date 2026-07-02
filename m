Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA647CC80
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993428; cv=none; b=RT4lh5wsKgWiP84clQgqyuheeswn39fgqRmFB+mcyuQFTkIogR74ecGL5jQqavUXdioMNQjBjmAHf5nvZQKNfx+8+oSljdq03eXkHH9Lvg13lOJh23ZMCAb2M6XARStFRZ7/Rb09+8s7qaEQ7ATKKs09QKNvIn7dXjTaTWM4i6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993428; c=relaxed/simple;
	bh=LDeG3w7d1Zam7Y81E/pg7n3OrK2aOsil2pVTKJJ/jPQ=;
	h=Content-Type:Cc:Date:Subject:Message-Id:To:From:Mime-Version; b=NuNYYuMbrXzu5Sy+dqP61a5bqgyC5zFu+5I3zw/XtxJTC+gATcKI8hOgM5IqxkRDrZFOGsn2HK/nHaTY7EncjzWjUQ/Um+mpCSmWek3wAPVjnBuaMLUyE1uTY1lJY+rjSK+hAFZTRiN8e1hJRkRNPHylyIQ5sFtikBZCtR9Gwl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=TFUMl60P; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="TFUMl60P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782993414;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jexPKJYAWrel5WRk+qem+1tO/gU/bIhzXbUs+nRK1yg=;
 b=TFUMl60POllHtgfNZ/h8V+z0/v2ttiTT7bwuJAyD1i52WCUA5z85bfpWOM6zdgaCXOT0GD
 VwstqpFH5VvnED9kn2vuxJYVAHom5NhWW/qr3rTw2xqblF+llzxMZAAymaJf262OIWuRjw
 e0DYbSpt+mwKvLDuxMkrLbV3jknYQZ8snvK6PNCn3mGHY3BCdHFNzFE/cPag3FHz5eagZU
 jKMfKZCtA37WnnOtWBzlQnrm0XBcyKKokcgvd59xNwXdL3FwOPGE8z7N6atiHuyLpcV1oq
 xCaRKE3Rg3/rT1fthbchQ98/y8w4QpvReMWatBBl/HeI4Vdj1qCS1LgYjFbxJg==
X-Lms-Return-Path: <lba+26a465205+e5984f+vger.kernel.org+zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <dsterba@suse.com>
Date: Thu,  2 Jul 2026 19:56:21 +0800
X-Mailer: git-send-email 2.39.5
Received: from pdzhu.teiron-inc.cn ([183.34.161.232]) by smtp.feishu.cn with ESMTPS; Thu, 02 Jul 2026 19:56:52 +0800
Subject: [PATCH] btrfs: set clear_cache for rescue=usebackuproot
Message-Id: <20260702115621.1151339-1-zhudongjiang@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>

The change that moved setting CLEAR_CACHE from the backup root loading
path to mount option parsing updated the deprecated usebackuproot and
recovery options, but missed rescue=usebackuproot.

rescue=usebackuproot is the preferred spelling for the same mount
option, so it should also set CLEAR_CACHE. Otherwise the deprecated
usebackuproot option clears or rebuilds the free space cache/tree while
the recommended rescue=usebackuproot option does not.

Set CLEAR_CACHE when parsing rescue=usebackuproot as well.

Fixes: 9fb3b1a7fed7 ("btrfs: set clear_cache if we use usebackuproot")
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c946bccf0748..b83391537c52 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -597,6 +597,9 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		switch (result.uint_32) {
 		case Opt_rescue_usebackuproot:
 			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
+
+			/* If we're loading the backup roots we can't trust the space cache. */
+			btrfs_set_opt(ctx->mount_opt, CLEAR_CACHE);
 			break;
 		case Opt_rescue_nologreplay:
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
-- 
2.39.5
