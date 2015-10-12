Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbbJLNYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOIVN026196
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:18 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 04/11] btrfs-progs: inspect: Bypass unnecessary clean function in open_error
Date: Mon, 12 Oct 2015 21:22:57 +0800
Message-ID: <24a594eddf990a332aeb4d1c5210f1aa9634c587.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to cleanup fd in open_fail case, because it is not opened.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-inspect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index fc3db99..879fd43 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -626,9 +626,8 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 	}
 
 	ret = print_min_dev_size(fd, devid);
-out:
 	close_file_or_dir(fd, dirstream);
-
+out:
 	return !!ret;
 }
 
-- 
1.8.5.1

